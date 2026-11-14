"""Verify the release, frozen inputs, and saved result commitments."""
import argparse
import hashlib
import json
from pathlib import Path
from artifact_provenance import verify_release_files, verify_historical_data

ROOT = Path(__file__).resolve().parents[1]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--package-profile', choices=('full', 'evaluator'), default='full')
    args = parser.parse_args()
    print(f'Verified {verify_release_files(ROOT, args.package_profile)} release assets', flush=True)
    print(f'Verified {verify_historical_data(ROOT)} historical data commitments', flush=True)
    artifact = json.loads((ROOT / 'artifact.json').read_text())
    inputs = json.loads((ROOT / 'inputs/manifest.json').read_text())
    evaluator = json.loads((ROOT / 'evaluator/manifest.json').read_text())
    assert inputs['version'] == artifact['input_version'] == evaluator['model_input_freeze']
    assert evaluator['version'] == artifact['evaluator_version']
    assert len(evaluator['tasks']) == artifact['tasks'] == 100
    assert sum(row['conditions'] for row in evaluator['tasks']) == artifact['registered_conditions'] == 473
    entries = json.loads((ROOT / 'submissions/manifest.json').read_text())['entries']
    assert len(entries) == 1800
    present = 0
    for row in entries:
        if row['status'] == 'present':
            assert hashlib.sha256((ROOT / row['path']).read_bytes()).hexdigest() == row['sha256']
            present += 1
        else:
            assert row['status'] == 'missing'
    assert present == 1777
    print('100 tasks; 473 conditions; 1,777 programs; 23 recorded generation failures')
    trace_scope = 'included' if (ROOT / 'replay/traces/reference').is_dir() else 'not bundled'
    print(f'3D viewer assets are included; archived raw replay traces are {trace_scope}.')


if __name__ == '__main__':
    main()
