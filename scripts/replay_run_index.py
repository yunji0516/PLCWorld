"""Small generated-run catalogs for replay discovery without loading scan payloads."""
import json
from pathlib import Path


def write_index(catalog_path: Path, bundle: dict):
    index = {**bundle, 'tasks': {}}
    for task_id, task in bundle['tasks'].items():
        index['tasks'][task_id] = {'runs': {}}
        for label, run in task.get('runs', {}).items():
            summary = {key: run[key] for key in ('label','category','goal','verdict','reason','model') if key in run}
            summary.update(frames=[], il='', viol=[])
            index['tasks'][task_id]['runs'][label] = summary
    target = catalog_path.with_name('original-replay.index.json')
    temporary = target.with_suffix('.tmp')
    temporary.write_text(json.dumps(index, ensure_ascii=False, separators=(',', ':')) + '\n', encoding='utf-8')
    temporary.replace(target)
