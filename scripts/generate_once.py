"""Generate one ST submission from frozen public inputs, then evaluate it."""

from __future__ import annotations

import argparse
from datetime import datetime, timezone
import gzip
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import urllib.error
import urllib.request
from uuid import uuid4


ROOT = Path(__file__).resolve().parents[1]
OUTPUTS = ROOT / "outputs" / "generated"
API_URL = "https://api.openai.com/v1/chat/completions"


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def read_verified(path: Path, expected: str) -> str:
    data = path.read_bytes()
    if sha256(data) != expected:
        raise ValueError(f"Frozen input hash mismatch: {path.relative_to(ROOT)}")
    return data.decode("utf-8")


def request_completion(body: dict, key: str) -> dict:
    request = urllib.request.Request(
        API_URL,
        data=json.dumps(body).encode("utf-8"),
        headers={"Authorization": f"Bearer {key}", "Content-Type": "application/json"},
        method="POST",
    )
    try:
        with urllib.request.urlopen(request, timeout=600) as response:
            return json.load(response)
    except urllib.error.HTTPError as exc:
        # Never echo an upstream response: it can contain account-specific data.
        raise RuntimeError(f"OpenAI API returned HTTP {exc.code}") from None
    except urllib.error.URLError as exc:
        raise RuntimeError(f"OpenAI API connection failed: {exc.reason}") from None


def run(args: argparse.Namespace) -> Path | None:
    artifact = json.loads((ROOT / "artifact.json").read_text(encoding="utf-8"))
    if sha256((ROOT / "inputs/input-seal.json").read_bytes()) != artifact["input_seal_sha256"]:
        raise ValueError("Input seal hash mismatch")
    inputs = json.loads((ROOT / "inputs/manifest.json").read_text(encoding="utf-8"))
    input_seal = json.loads((ROOT / "inputs/input-seal.json").read_text(encoding="utf-8"))
    if sha256((ROOT / "inputs/manifest.json").read_bytes()) != input_seal["manifest.json"]:
        raise ValueError("Frozen input manifest hash mismatch")
    tasks = inputs["tasks"]
    if args.task not in tasks:
        raise ValueError(f"Unknown task: {args.task}")
    task = tasks[args.task]
    system_hash = input_seal["system-instructions.txt"]
    system_path = ROOT / "inputs/system-instructions.txt"
    input_path = ROOT / "inputs" / task["input"]
    system = read_verified(system_path, system_hash)
    user = read_verified(input_path, task["input_sha256"])
    evaluator_manifest = json.loads((ROOT / "evaluator/manifest.json").read_text(encoding="utf-8"))
    evaluator_tasks = {row["id"]: row for row in evaluator_manifest["tasks"]}
    if args.task not in evaluator_tasks:
        raise ValueError("Task is not registered in the evaluator")
    if args.scenario is not None and not 0 <= args.scenario < evaluator_tasks[args.task]["conditions"]:
        raise ValueError("Scenario is outside the registered range")
    from importlib.util import module_from_spec, spec_from_file_location

    spec = spec_from_file_location("plcworld_evaluate", ROOT / "evaluator/evaluate.py")
    evaluator = module_from_spec(spec)
    assert spec and spec.loader
    spec.loader.exec_module(evaluator)
    evaluator.verify()

    body = {
        "model": args.model,
        "messages": [{"role": "system", "content": system}, {"role": "user", "content": user}],
        "max_completion_tokens": args.max_completion_tokens,
    }
    if args.temperature is not None:
        body["temperature"] = args.temperature
    if args.dry_run:
        print(json.dumps({
            "api_calls": 0, "task": args.task, "model": args.model,
            "input_sha256": task["input_sha256"], "system_sha256": system_hash,
            "max_completion_tokens": args.max_completion_tokens,
            "scenario": args.scenario, "conditions": evaluator_tasks[args.task]["conditions"],
        }, indent=2))
        return None

    key = os.environ.get("OPENAI_API_KEY", "").strip()
    if not key:
        raise ValueError("Set OPENAI_API_KEY in the environment before running generation")
    if not args.model.strip():
        raise ValueError("--model must not be empty")
    if args.max_completion_tokens < 1:
        raise ValueError("--max-completion-tokens must be positive")

    # One call only; no evaluator feedback is ever sent to the model.
    completion = request_completion(body, key)
    choices = completion.get("choices") or []
    choice = choices[0] if choices else {}
    content = choice.get("message", {}).get("content")
    finish_reason = choice.get("finish_reason")
    stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    slug = re.sub(r"[^a-z0-9]+", "-", args.model.lower()).strip("-")[:32] or "model"
    run_id = f"{args.task.lower()}-{slug}-{stamp.lower()}-{uuid4().hex[:8]}"
    OUTPUTS.mkdir(parents=True, exist_ok=True)
    output = OUTPUTS / run_id
    output.mkdir()
    metadata = {
        "schema": "plcworld-single-shot-run/1", "task": args.task,
        "model": args.model, "created_utc": stamp,
        "input_version": inputs["version"],
        "input_sha256": task["input_sha256"],
        "system_sha256": system_hash,
        "evaluator_version": evaluator_manifest["version"],
        "evaluator_seal_sha256": sha256((ROOT / "evaluator/release-seal.json").read_bytes()),
        "api": "openai-chat-completions", "api_calls": 1,
        "response_id": completion.get("id"), "usage": completion.get("usage"),
        "finish_reason": finish_reason, "max_completion_tokens": args.max_completion_tokens,
        "temperature": args.temperature, "scenario": args.scenario,
        "status": "received", "paper_result": False,
    }
    if isinstance(content, str):
        (output / "response.txt").write_text(content, encoding="utf-8")
    if finish_reason != "stop" or not isinstance(content, str) or not content.strip():
        metadata["status"] = "incomplete_response"
        (output / "run.json").write_text(json.dumps(metadata, indent=2) + "\n", encoding="utf-8")
        raise RuntimeError(f"Model response was incomplete; saved at {output}")
    # Preserve the model's exact content. Do not silently strip Markdown fences.
    program = output / "submission.st"
    program.write_text(content, encoding="utf-8")
    metadata["st_sha256"] = sha256(program.read_bytes())
    command = [sys.executable, str(ROOT / "evaluator/evaluate.py"), args.task,
               str(program), "--output", str(output / "evaluation"), "--keep-traces"]
    if args.scenario is not None:
        command.extend(["--scenario", str(args.scenario)])
    result = subprocess.run(command, cwd=ROOT, check=False)
    metadata["status"] = "evaluated" if result.returncode == 0 else "evaluation_error"
    metadata["evaluation_exit_code"] = result.returncode
    if result.returncode == 0:
        cases = sorted((output / "evaluation").glob("case-*.json"))
        metadata["results"] = []
        for path in cases:
            row = json.loads(path.read_text(encoding="utf-8"))
            trace = path.with_name(path.stem + ".frames.json.gz")
            available = bool(json.loads(gzip.decompress(trace.read_bytes())))
            metadata["results"].append({
                "scenario": row["scenario_index"],
                "task_success": row["task_success"],
                "safety_violation": row["safety_violation"],
                "error": row["error"], "replay_available": available,
            })
        available = [row["scenario"] for row in metadata["results"] if row["replay_available"]]
        selected = args.scenario if args.scenario is not None else (available[0] if available else None)
    (output / "run.json").write_text(json.dumps(metadata, indent=2) + "\n", encoding="utf-8")
    from adapt_legacy_replay import (DEVICE_AXES, GROUNDED_GEOMETRY_TASKS, HARD_BATCH_TASKS,
                                     MATERIAL_TASKS, PRIORITY_GEOMETRY_TASKS)
    if (result.returncode == 0 and
            (args.task in DEVICE_AXES or args.task in PRIORITY_GEOMETRY_TASKS or
             args.task in GROUNDED_GEOMETRY_TASKS or args.task in HARD_BATCH_TASKS or
             args.task in MATERIAL_TASKS)
            and any(row["replay_available"] for row in metadata.get("results", []))):
        catalog = output / "original-replay.catalog.json"
        adapted = subprocess.run([
            sys.executable, str(ROOT / "scripts/adapt_legacy_replay.py"),
            "--generated-run-id", run_id, "--generated-root", str(OUTPUTS),
            "--output", str(catalog),
        ], cwd=ROOT, check=False)
        if adapted.returncode == 0:
            metadata["original_3d_catalog"] = catalog.name
            metadata["original_3d_url"] = f"http://localhost:3201/replay?task={args.task}&run={run_id}"
            metadata["replay_url"] = metadata["original_3d_url"]
        else:
            metadata["original_3d_status"] = "adapter_failed"
        (output / "run.json").write_text(json.dumps(metadata, indent=2) + "\n", encoding="utf-8")
    print(f"Run saved: {output}")
    if "original_3d_url" in metadata:
        print(f"Original-renderer 3D replay: {metadata['original_3d_url']}")
    if result.returncode:
        raise RuntimeError(f"Evaluation failed; inspect {output / 'evaluation'}")
    return output


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--task", required=True)
    parser.add_argument("--model", required=True, help="OpenAI model ID available to your account")
    parser.add_argument("--max-completion-tokens", type=int, default=32768)
    parser.add_argument("--temperature", type=float, help="Omit for models that do not support it")
    parser.add_argument("--scenario", type=int, help="Evaluate one registered condition; default is all")
    parser.add_argument("--dry-run", action="store_true", help="Verify inputs without calling the API")
    args = parser.parse_args()
    try:
        run(args)
    except (ValueError, RuntimeError, OSError) as exc:
        parser.exit(1, f"{exc}\n")


if __name__ == "__main__":
    main()
