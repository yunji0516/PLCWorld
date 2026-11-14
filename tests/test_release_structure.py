"""Prevent obsolete metadata and dangling runtime resources from returning."""
import json
from pathlib import Path
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'scripts'))
from check_release_structure import audit


class ReleaseStructureTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.root = Path(self.temp.name)
        self.save('evaluator/task.txt', 'task')
        self.save('inputs/task.txt', 'task')
        row = {'id': 'EXAMPLE', 'backend': 'common', 'input': 'task.txt',
               'public_spec': 'task.txt', 'contract': 'task.txt'}
        self.save('evaluator/manifest.json', {'tasks': [row]})
        self.save('inputs/manifest.json', {'tasks': {'EXAMPLE': {'input': 'task.txt', 'public_spec': 'task.txt'}}})
        self.save('evaluator/common/manifest.json', {'tasks': [{'id': 'EXAMPLE', 'group': 'core', 'package': 'task.txt'}]})
        self.save('evaluator/common/groups/core/runtime/task.txt', 'task')
        self.save('evaluator/motion/manifest.json', {'tasks': []})

    def tearDown(self):
        self.temp.cleanup()

    def save(self, name, value):
        path = self.root / name
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(value if isinstance(value, str) else json.dumps(value))

    def test_current_structure_passes(self):
        self.assertTrue(audit(self.root)['passed'])

    def test_missing_resource_fails(self):
        (self.root / 'evaluator/task.txt').unlink()
        self.assertFalse(audit(self.root)['passed'])

    def test_old_report_fails(self):
        self.save('evaluator/READINESS.json', {})
        self.assertFalse(audit(self.root)['passed'])

    def test_windows_invalid_name_fails(self):
        self.save('bad:name.txt', 'example')
        self.assertFalse(audit(self.root)['passed'])

    def test_unselected_backend_registration_fails(self):
        self.save('evaluator/motion/manifest.json', {'tasks': [{'id': 'STALE', 'package': '.'}]})
        self.assertFalse(audit(self.root)['passed'])

    def test_private_token_fails(self):
        self.save('secret.txt', 'sk-' + 'A' * 40)
        self.assertFalse(audit(self.root)['passed'])

    def test_missing_js_dependency_fails(self):
        self.save('bridge.cjs', "require('./absent.js');")
        self.assertFalse(audit(self.root)['passed'])


if __name__ == '__main__':
    unittest.main()
