"""Export a saved ST submission as a trace for the local replay viewer."""

from __future__ import annotations

import argparse
import gzip
import hashlib
import json
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--task", required=True, help="Public task ID, for example MAT-E01")
    parser.add_argument("--scenario", type=int, default=0, help="Registered condition index")
    parser.add_argument("--model", default="gpt-5.5")
    parser.add_argument("--repeat", type=int, default=1)
    parser.add_argument("--output", required=True, type=Path, help="New output directory")
    args = parser.parse_args()

    tasks = {row["id"]: row for row in json.loads(
        (ROOT / "evaluator/manifest.json").read_text(encoding="utf-8")
    )["tasks"]}
    task = tasks.get(args.task)
    if task is None:
        parser.error(f"Unknown task: {args.task}")
    if not 0 <= args.scenario < task["conditions"]:
        parser.error(f"Scenario must be between 0 and {task['conditions'] - 1} for {args.task}")
    if args.output.exists():
        parser.error("Output directory already exists")

    entries = json.loads((ROOT / "submissions/manifest.json").read_text(encoding="utf-8"))["entries"]
    matches = [row for row in entries if row["model"] == args.model
               and row["repeat"] == args.repeat and row["task"] == args.task]
    if len(matches) != 1 or matches[0]["status"] != "present":
        parser.error("No preserved ST submission for that model, repeat, and task")
    entry = matches[0]
    program = ROOT / entry["path"]
    if not program.is_file() or sha256(program) != entry["sha256"]:
        raise SystemExit(f"Preserved submission hash mismatch: {entry['path']}")

    with tempfile.TemporaryDirectory(prefix="plcworld-trace-export-") as directory:
        result_dir = Path(directory) / "evaluation"
        subprocess.run([
            sys.executable, str(ROOT / "evaluator/evaluate.py"), args.task,
            str(program), "--scenario", str(args.scenario), "--output", str(result_dir),
            "--keep-traces",
        ], cwd=ROOT, check=True)
        case = result_dir / f"case-{args.scenario:02}.json"
        trace = result_dir / f"case-{args.scenario:02}.frames.json.gz"
        result = json.loads(case.read_text(encoding="utf-8"))
        if hashlib.sha256(gzip.decompress(trace.read_bytes())).hexdigest() != result["trace_sha256"]:
            raise SystemExit("Evaluator trace digest mismatch")
        args.output.mkdir(parents=True)
        trace_name = f"{args.task}.case-{args.scenario:02}.frames.json.gz"
        shutil.copyfile(trace, args.output / trace_name)
        shutil.copyfile(case, args.output / f"{args.task}.case-{args.scenario:02}.json")

    manifest = {
        "schema": "plcworld-replay-export/1",
        "task": args.task,
        "scenario": args.scenario,
        "model": args.model,
        "repeat": args.repeat,
        "program_sha256": entry["sha256"],
        "evaluator_seal_sha256": result["integration_seal_sha256"],
        "trace_file": trace_name,
        "trace_gzip_sha256": sha256(args.output / trace_name),
        "trace_sha256": result["trace_sha256"],
        "task_success": result["task_success"],
        "safety_violation": result["safety_violation"],
    }
    (args.output / "manifest.json").write_text(
        json.dumps(manifest, indent=2) + "\n", encoding="utf-8"
    )
    print(f"Authoritative recorded scans: {args.output / trace_name}")


if __name__ == "__main__":
    main()
