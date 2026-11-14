"""Compare complete local re-evaluations with the published result manifest.

This reads preserved ST evaluation outputs only; it does not call a model API.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import math
import sys
from pathlib import Path
from artifact_provenance import protect_historical_output, trusted_evaluator_seals, verify_historical_data


ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "evaluator"))
from aggregate import TASKS, aggregate, metrics  # noqa: E402


def compare(expected: object, actual: object, path: str, differences: list[dict]) -> None:
    if isinstance(expected, dict):
        if not isinstance(actual, dict):
            differences.append({"path": path, "expected": expected, "actual": actual})
            return
        for key, value in expected.items():
            compare(value, actual.get(key), f"{path}/{key}", differences)
    elif isinstance(expected, float):
        if not isinstance(actual, (int, float)) or not math.isclose(
            expected, actual, rel_tol=0, abs_tol=1e-12
        ):
            differences.append({"path": path, "expected": expected, "actual": actual})
    elif expected != actual:
        differences.append({"path": path, "expected": expected, "actual": actual})


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=ROOT / "outputs/reproduction")
    parser.add_argument("--output", type=Path,
                        help="Optional path for the machine-readable comparison report")
    args = parser.parse_args()
    if args.output:
        protect_historical_output(ROOT, args.output)
    paper = json.loads((ROOT / "results/manifest.json").read_text(encoding="utf-8"))
    submissions = json.loads((ROOT / "submissions/manifest.json").read_text(
        encoding="utf-8"
    ))["entries"]
    submission_hashes = {
        (row["model"], row["repeat"], row["task"]):
            row.get("sha256")
        for row in submissions
    }
    current_seal = hashlib.sha256((ROOT / "evaluator/release-seal.json").read_bytes()).hexdigest()
    valid_seals = trusted_evaluator_seals(ROOT)
    historical_files_verified = verify_historical_data(ROOT)
    differences: list[dict] = []
    model_reports = []

    for model_record in paper["direct_generation"]:
        model = model_record["model"]
        combined = []
        repetitions = []
        for repeat in range(1, model_record["repetitions"] + 1):
            directory = args.root / model / f"repeat-{repeat:02}"
            summary_path = directory / "summary.json"
            if not summary_path.is_file():
                differences.append({"path": str(summary_path), "error": "missing summary"})
                continue
            summary = json.loads(summary_path.read_text(encoding="utf-8"))
            paths = sorted(directory.glob("*/case-*.json"))
            rows = [json.loads(path.read_text(encoding="utf-8")) for path in paths]
            compare(model, summary.get("model"), f"{model}/r{repeat}/model", differences)
            compare(repeat, summary.get("repeat"), f"{model}/r{repeat}/repeat", differences)
            compare(len(TASKS), summary.get("tasks"), f"{model}/r{repeat}/tasks", differences)
            compare(len(rows), summary.get("cases"), f"{model}/r{repeat}/cases", differences)
            compare(model_record["conditions_per_repetition"], len(rows),
                    f"{model}/r{repeat}/registered_cases", differences)
            for path, row in zip(paths, rows):
                task = row["task"]
                expected_hash = submission_hashes.get((model, repeat, task), "unregistered")
                compare(expected_hash, row.get("st_sha256"),
                        f"{model}/r{repeat}/{task}/{path.name}/st_sha256", differences)
                if row.get("integration_seal_sha256") not in valid_seals:
                    differences.append({"path": f"{model}/r{repeat}/{task}/{path.name}/seal",
                                        "error": "unverified evaluator provenance"})
            try:
                # The sealed evaluator deliberately accepts only its own seal.
                # After validating sealed bytes and sampled runtime provenance, bind
                # copies in memory for aggregation; never restamp saved results.
                if any(row.get("integration_seal_sha256") not in valid_seals for row in rows):
                    raise ValueError("Unverified source seal cannot be rebound")
                bound_rows = [{**row, "integration_seal_sha256": current_seal} for row in rows]
                recomputed = aggregate(bound_rows, require_full=True)
            except ValueError as error:
                differences.append({"path": f"{model}/r{repeat}", "error": str(error)})
                continue
            compare(recomputed, summary.get("metrics"),
                    f"{model}/r{repeat}/summary_metrics", differences)
            combined.extend(rows)
            repetitions.append({"repeat": repeat, "cases": len(rows),
                                "SR": recomputed["overall"]["SR"],
                                "SVR": recomputed["overall"]["SVR"]})

        if len(repetitions) != model_record["repetitions"]:
            continue
        overall = metrics(combined)
        compare(model_record["total_cases"], len(combined),
                f"{model}/total_cases", differences)
        compare(model_record["metrics"], overall, f"{model}/metrics", differences)
        groups = {}
        for row in combined:
            task = TASKS[row["task"]]
            groups.setdefault(task["suite"] + "/" + task["difficulty"], []).append(row)
        group_metrics = {name: metrics(rows) for name, rows in groups.items()}
        compare(model_record["groups"], group_metrics, f"{model}/groups", differences)
        model_reports.append({"model": model, "cases": len(combined),
                              "SR": overall["SR"], "SVR": overall["SVR"],
                              "repetitions": repetitions})

    matched_record = next(
        (row for row in paper["generation_and_verification"]
         if row["method"] == "direct-gpt-5.5-matched"), None
    )
    if matched_record is None:
        differences.append({"path": "generation_and_verification/direct-gpt-5.5-matched",
                            "error": "missing paper record"})
    else:
        matched_summary = ROOT / "results/matched-direct.json"
        if not matched_summary.is_file():
            differences.append({"path": str(matched_summary), "error": "missing summary"})
        else:
            actual = json.loads(matched_summary.read_text(encoding="utf-8"))
            compare(matched_record["overall"], actual["metrics"]["overall"],
                    "generation_and_verification/direct-gpt-5.5-matched",
                    differences)
    excluded_methods = [
        row["method"] for row in paper["generation_and_verification"]
        if row["method"] != "direct-gpt-5.5-matched"
    ]
    report = {"passed": not differences,
              "current_evaluator_seal_sha256": current_seal,
              "verified_source_seals": sorted(valid_seals),
              "historical_files_verified": historical_files_verified,
              "fresh_evaluation_performed": False,
              "scope": f"{len(paper['direct_generation'])} direct-generation models plus matched direct GPT-5.5 row",
              "models": model_reports,
              "adapted_methods_not_reproduced": excluded_methods,
              "differences": differences}
    rendered = json.dumps(report, indent=2) + "\n"
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(rendered, encoding="utf-8")
    print(rendered, end="")
    if differences:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
