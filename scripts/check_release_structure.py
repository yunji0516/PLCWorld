"""Audit all packaged source syntax, runtime resource links and release naming."""
from __future__ import annotations

import ast
import json
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
EXCLUDED = {'node_modules', '.next', '__pycache__', '.git', '.pytest_cache', 'test-results'}
RETIRED_ROOT_FILES = (
    'READINESS.json', 'VALIDATION.json', 'PROMOTION_EQUIVALENCE.json',
    'promotion-binding-checks.json', 'release-checks.json', 'parents.json',
    'input-manifest.json', 'prepare_requests.py', 'priority-instrumentation.patch',
    'render_public_spec.py', 'render_parameters.py', 'render_geometry.py', 'seal.py',
)


def audit(root=ROOT):
    root = Path(root)
    errors = []
    counts = {'files': 0, 'python_sources': 0, 'json_documents': 0,
              'task_packages': 0, 'resource_links': 0, 'registered_tasks': 0,
              'javascript_relative_imports': 0}
    seen = {}
    python_imports = []
    python_modules = set(sys.stdlib_module_names) | {'engine', 'dependencies'}
    for path in sorted(root.rglob('*')):
        name = path.relative_to(root).as_posix()
        if EXCLUDED & set(path.relative_to(root).parts) or name.startswith('outputs/generated/'):
            continue
        if path.is_symlink():
            errors.append('Symlink in release: ' + name)
            continue
        if any(re.search(r'[<>:"\\|?*]', part) or part.endswith((' ', '.'))
               or re.fullmatch(r'(CON|PRN|AUX|NUL|COM[1-9]|LPT[1-9])(?:\..*)?', part, re.I)
               for part in path.relative_to(root).parts):
            errors.append('Windows-incompatible path: ' + name)
        folded = name.casefold()
        if folded in seen:
            errors.append('Case-insensitive path collision: ' + name)
        seen[folded] = name
        if not path.is_file():
            continue
        counts['files'] += 1
        if path.suffix == '.py':
            tree = ast.parse(path.read_text(encoding='utf-8'), filename=name)
            python_modules.add(path.stem)
            if path.name == '__init__.py':
                python_modules.add(path.parent.name)
            for node in ast.walk(tree):
                imports = [item.name for item in node.names] if isinstance(node, ast.Import) else [node.module] if isinstance(node, ast.ImportFrom) and node.module and not node.level else []
                python_imports.extend((name, item.split('.')[0]) for item in imports)
            counts['python_sources'] += 1
        if path.suffix == '.json':
            json.loads(path.read_text(encoding='utf-8'))
            counts['json_documents'] += 1
        if path.suffix not in {'.gz', '.png', '.ico', '.woff', '.woff2'}:
            try:
                text = path.read_text(encoding='utf-8')
            except UnicodeDecodeError:
                continue
            if re.search(r'plc' + r'plant|https?://plc\.[A-Za-z0-9.-]+|/home1?/[^\s\"\x27]+', text, re.I):
                errors.append('Old branding or identifying path: ' + name)
            if re.search(r'-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----|sk-[A-Za-z0-9_-]{32,}', text):
                errors.append('Potential embedded private key/token: ' + name)
            if path.suffix in {'.js', '.cjs', '.ts', '.tsx'}:
                for ref in re.findall(r'(?:require\s*\(\s*|from\s+)[\x27\x22](\.[^\x27\x22]+)[\x27\x22]', text):
                    counts['javascript_relative_imports'] += 1
                    base = path.parent / ref
                    candidates = [base] + [Path(str(base) + suffix) for suffix in ('.js', '.cjs', '.ts', '.tsx')] + [base / ('index' + suffix) for suffix in ('.js', '.ts', '.tsx')]
                    if not any(candidate.is_file() for candidate in candidates):
                        errors.append('Missing JavaScript relative import: ' + name + ' -> ' + ref)

    for name, module in python_imports:
        if module not in python_modules:
            errors.append('Unresolved packaged Python module: ' + name + ' -> ' + module)

    def linked(base, value):
        if not isinstance(value, str):
            errors.append('Non-string resource link: ' + str(base.relative_to(root)))
            return
        target = (base / value).resolve()
        counts['resource_links'] += 1
        if not target.is_relative_to(root.resolve()) or not target.exists():
            errors.append('Missing/escaping resource: ' + str(base.relative_to(root)) + '/' + value)

    for filename in RETIRED_ROOT_FILES:
        if (root / 'evaluator' / filename).exists():
            errors.append('Obsolete evaluator-root file: ' + filename)
    if (root / 'inputs/VALIDATION.json').exists():
        errors.append('Obsolete input validation report')
    if (root / 'evaluator/motion/runtime/dependencies/alignment_fixture').exists():
        errors.append('Superseded Motion package')
    if list((root / 'evaluator').glob('**/programs/manifest.json')):
        errors.append('Unbundled authoring-program inventories')
    for path in (root / 'evaluator').rglob('task.json'):
        task = json.loads(path.read_text())
        counts['task_packages'] += 1
        for key in ('requirement', 'plant', 'binding', 'calibration', 'oracle', 'replay', 'program_manifest'):
            if key in task and isinstance(task[key], str):
                linked(path.parent, task[key])
        for value in task.get('scenarios', []):
            if isinstance(value, str) and value.endswith('.json'):
                linked(path.parent, value)
        for value in task.get('submission', {}).get('reference_programs', {}).values():
            linked(path.parent, value)
    manifest = json.loads((root / 'evaluator/manifest.json').read_text())
    counts['registered_tasks'] = len(manifest['tasks'])
    inputs = json.loads((root / 'inputs/manifest.json').read_text())
    for row in manifest['tasks']:
        for key in ('input', 'public_spec', 'contract'):
            linked(root / 'evaluator', row[key])
    for row in inputs['tasks'].values():
        for key in ('input', 'public_spec'):
            linked(root / 'inputs', row[key])
    for backend in ('common', 'motion'):
        path = root / 'evaluator' / backend / 'manifest.json'
        rows = json.loads(path.read_text())['tasks']
        selected = {row['id'] for row in manifest['tasks'] if row['backend'] == backend}
        if {row['id'] for row in rows} != selected:
            errors.append('Unselected/missing backend registrations: ' + backend)
        for row in rows:
            base = path.parent / 'groups' / row['group'] / 'runtime' if backend == 'common' else path.parent
            linked(base, row['package'])
            if 'legacy_package' in row:
                linked(base, row['legacy_package'])
            if backend == 'motion':
                if 'input' not in row:
                    errors.append('Missing backend input link: ' + row['id'])
                else:
                    linked(path.parent, row['input'])
    return {'passed': not errors, 'scope': 'All packaged source syntax and filenames; registered resource paths and all task-package runtime links. Historical data identifiers and third-party attribution are preserved.', 'counts': counts, 'errors': errors, 'api_calls': 0}


if __name__ == '__main__':
    report = audit()
    print(json.dumps(report, indent=2))
    raise SystemExit(0 if report['passed'] else 1)
