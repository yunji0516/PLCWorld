"""Re-evaluate preserved submissions with the frozen PLCWorld evaluator."""

from __future__ import annotations

import argparse
from concurrent.futures import ThreadPoolExecutor, as_completed
import hashlib
import json
import subprocess
import sys
import tempfile
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "evaluator"))
from aggregate import aggregate  # noqa: E402


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--model", required=True)
    parser.add_argument("--repeat", type=int, required=True)
    parser.add_argument("--task")
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--resume", action="store_true",
                        help="Reuse complete task results from the current evaluator seal")
    parser.add_argument("--jobs", type=int, default=1,
                        help="Number of independent tasks to evaluate concurrently")
    args = parser.parse_args()
    if args.jobs < 1:
        parser.error("--jobs must be at least 1")
    if args.output.exists() and not args.resume:
        parser.error("Output directory already exists")
    entries = json.loads((ROOT / "submissions/manifest.json").read_text(encoding="utf-8"))["entries"]
    selected = [row for row in entries if row["model"] == args.model and row["repeat"] == args.repeat
                and (args.task is None or row["task"] == args.task)]
    if not selected:
        parser.error("No matching submissions")
    args.output.mkdir(parents=True, exist_ok=args.resume)
    current_seal = hashlib.sha256((ROOT / "evaluator/release-seal.json").read_bytes()).hexdigest()
    task_conditions = {row["id"]: row["conditions"] for row in json.loads(
        (ROOT / "evaluator/manifest.json").read_text(encoding="utf-8")
    )["tasks"]}
    def evaluate_task(row: dict) -> tuple[str, list[Path]]:
        if row["status"] == "present":
            program = ROOT / row["path"]
            if hashlib.sha256(program.read_bytes()).hexdigest() != row["sha256"]:
                raise SystemExit(f"Submission changed: {row['path']}")
        else:
            program = ROOT / "submissions" / "missing" / f"{row['task']}.st"
        output = args.output / row["task"]
        expected_cases = task_conditions[row["task"]]
        if output.exists():
            if not args.resume:
                parser.error(f"Task output already exists: {output}")
            task_cases = sorted(output.glob("case-*.json"))
            if len(task_cases) != expected_cases or not (output / "summary.json").is_file():
                raise SystemExit(f"Incomplete task output cannot be resumed: {output}")
            for index, path in enumerate(task_cases):
                result = json.loads(path.read_text(encoding="utf-8"))
                if (path.name != f"case-{index:02}.json" or result["task"] != row["task"]
                    or result["scenario_index"] != index
                    or result["integration_seal_sha256"] != current_seal
                    or result.get("st_sha256") != row.get("sha256")):
                    raise SystemExit(f"Task output does not match current inputs: {path}")
            print(f"Reused {row['task']}: {expected_cases} cases", flush=True)
        elif row['status'] == 'missing':
            # A failed generation is an observed outcome, not an ST candidate.
            # Preserve it without regenerating or executing a partial response.
            from artifact_provenance import verify_historical_data
            from evaluate import stamp
            verify_historical_data(ROOT)
            source = ROOT / 'outputs/reproduction' / row['model'] / f"repeat-{row['repeat']:02}" / row['task']
            output.mkdir()
            registered = next(item for item in json.loads((ROOT / 'evaluator/manifest.json').read_text())['tasks'] if item['id'] == row['task'])
            results = []
            for path in sorted(source.glob('case-*.json')):
                result = json.loads(path.read_text())
                if result.get('error', {}).get('phase') != 'generation':
                    raise ValueError('Expected a recorded generation failure')
                stamp(result, registered)
                result['execution_provenance'] = 'Preserved generation failure; no ST execution'
                (output / path.name).write_text(json.dumps(result, indent=2) + '\n')
                results.append(result)
            (output / 'summary.json').write_text(json.dumps({'results': results}, indent=2) + '\n')
            task_cases = sorted(output.glob('case-*.json'))
        else:
            with tempfile.TemporaryDirectory(prefix=f".{row['task']}-", dir=args.output) as directory:
                stage = Path(directory) / "evaluation"
                subprocess.run(
                    [sys.executable, str(ROOT / "evaluator/evaluate.py"), row["task"], str(program),
                     "--output", str(stage)],
                    check=True, cwd=ROOT,
                )
                stage.rename(output)
            task_cases = sorted(output.glob("case-*.json"))
        return row["task"], task_cases

    cases = []
    with ThreadPoolExecutor(max_workers=args.jobs) as executor:
        futures = [executor.submit(evaluate_task, row) for row in sorted(
            selected, key=lambda item: item["task"
        ])]
        for future in as_completed(futures):
            _task, task_cases = future.result()
            cases.extend(task_cases)
    rows = [json.loads(path.read_text(encoding="utf-8")) for path in cases]
    metrics = aggregate(rows, require_full=args.task is None)
    summary = {
        "model": args.model,
        "repeat": args.repeat,
        "tasks": len(selected),
        "cases": len(cases),
        "metrics": metrics,
    }
    (args.output / "summary.json").write_text(json.dumps(summary, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({"tasks": len(selected), "cases": len(cases), "SR": metrics["overall"]["SR"],
                      "SVR": metrics["overall"]["SVR"]}))


if __name__ == "__main__":
    main()
