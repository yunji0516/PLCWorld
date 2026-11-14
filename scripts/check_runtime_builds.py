"""Construct every registered plant/scenario in isolated processes, without ST/API."""
from __future__ import annotations

import argparse
from concurrent.futures import ThreadPoolExecutor
import importlib
import importlib.util
import json
from pathlib import Path
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]


def build_task(task):
    spec = importlib.util.spec_from_file_location('release_build_entry', ROOT / 'evaluator/evaluate.py')
    evaluator = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(evaluator)
    read, load_backend, verify = evaluator.read, evaluator.load_backend, evaluator.verify
    verify()
    rows = {row['id']: row for row in read(ROOT / 'evaluator/manifest.json')['tasks']}
    row = rows[task]
    backend = load_backend(row['backend'])
    if row['backend'] == 'common':
        entry = backend.TASKS[task]
        backend.initialize(entry['group'])
        from plant_factory import compile_plant
        for index in range(row['conditions']):
            if entry['group'] == 'material-core':
                from material_release_evaluation import build
                built, _ = build(entry['original_entry'], index)
            else:
                built = compile_plant(backend.B / entry.get('legacy_package', entry['package']), scenario_index=index)
            if entry.get('transport_revision') == 17:
                from transport_adapter import replace_transport
                built = replace_transport(backend.B, entry, built, index)
            backend.configured_oracle(task, built.package.oracle)
    elif row['backend'] == 'motion':
        entry = next(item for item in read(ROOT / 'evaluator/motion/manifest.json')['tasks'] if item['id'] == task)
        module = importlib.import_module('dependencies.' + entry['implementation'] + '.evaluate')
        for index in range(row['conditions']):
            package, scenario = module.load(ROOT / 'evaluator/motion' / entry['package'], index)
            module.DependencyPlant(package, scenario)
    else:
        module = importlib.import_module('engine.evaluate')
        for index in range(row['conditions']):
            _, package, scenario = module.load(task, index)
            if task == 'MAT-H07':
                module.WindTape(package.binding, package.calibration, scenario['parameters'])
            else:
                plant = module.GantryTransfer if task == 'MOT-M02' else module.SerialCylinderVariant
                plant(package, scenario)
    verify()
    return {'task': task, 'passed': True, 'conditions': row['conditions']}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--task', help='Check one registered task in this process')
    args = parser.parse_args()
    if args.task:
        print(json.dumps(build_task(args.task)))
        return
    tasks = json.loads((ROOT / 'evaluator/manifest.json').read_text())['tasks']

    def check(row):
        process = subprocess.run([sys.executable, '-B', str(Path(__file__).resolve()), '--task', row['id']],
                                 text=True, capture_output=True, timeout=120)
        if process.returncode:
            return {'task': row['id'], 'passed': False, 'error': process.stderr}
        return json.loads(process.stdout)

    with ThreadPoolExecutor(max_workers=8) as pool:
        results = list(pool.map(check, tasks))
    report = {'passed': all(row['passed'] for row in results),
              'tasks_checked': len(results),
              'conditions_constructed': sum(row.get('conditions', 0) for row in results),
              'api_calls': 0, 'st_execution_performed': False,
              'scope': 'Construct each registered plant/scenario and validate configured common oracles; not a score or scan-trace regression.',
              'failures': [row for row in results if not row['passed']]}
    print(json.dumps(report, indent=2))
    raise SystemExit(0 if report['passed'] else 1)


if __name__ == '__main__':
    main()
