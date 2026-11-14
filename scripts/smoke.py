"""Verify release assets/bindings, construct all plants and run one closed loop."""

from __future__ import annotations

import json
import argparse
import subprocess
import sys
import tempfile
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SUBMISSION = ROOT / "submissions/gpt-5.5/repeat-01/MAT-E01.st"


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--package-profile", choices=("full", "evaluator"), default="full")
    args = parser.parse_args()
    subprocess.run([sys.executable, str(ROOT / "scripts/verify.py"),
                    "--package-profile", args.package_profile], check=True)
    subprocess.run([sys.executable, str(ROOT / "scripts/check_release_structure.py")], check=True)
    subprocess.run([sys.executable, str(ROOT / "scripts/check_runtime_builds.py")], check=True)
    with tempfile.TemporaryDirectory(prefix="plcworld-smoke-") as directory:
        subprocess.run([sys.executable, str(ROOT / "evaluator/check_release.py"),
                        "--output", str(Path(directory) / "binding-checks.json")], check=True)
        output = Path(directory) / "evaluation"
        subprocess.run(
            [sys.executable, str(ROOT / "evaluator/evaluate.py"), "MAT-E01", str(SUBMISSION),
             "--scenario", "0", "--output", str(output)],
            check=True, cwd=ROOT,
        )
        case = json.loads((output / "case-00.json").read_text(encoding="utf-8"))
        if case["task_success"] is not True or case["safety_violation"] is not False:
            raise SystemExit("Preserved submission did not pass the smoke test")
    print("Closed-loop smoke test passed")


if __name__ == "__main__":
    main()
