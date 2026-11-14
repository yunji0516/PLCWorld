"""Sealed bridge loading must not depend on missing TS or extraction timestamps."""
import ast
from pathlib import Path
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
SOURCES = [ROOT / 'evaluator/motion/runtime/submission.py',
           *(ROOT / 'evaluator/common/groups').glob('*/runtime/submission.py')]


class RuntimeBridgeTest(unittest.TestCase):
    def loaders(self, output):
        for path in SOURCES:
            tree = ast.parse(path.read_text())
            function = next(node for node in tree.body if isinstance(node, ast.FunctionDef) and node.name == '_ensure_st_bridge')
            code = ast.Module(body=[function], type_ignores=[])
            namespace = {'Path': Path, '_bridge_output': lambda: output}
            exec(compile(code, str(path), 'exec'), namespace)
            yield namespace['_ensure_st_bridge']

    def test_no_compiler_or_ts_source_required(self):
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / 'bridge.js'
            output.write_text('sealed bridge')
            for loader in self.loaders(output):
                self.assertEqual(loader(), output)

    def test_missing_sealed_bridge_fails(self):
        with tempfile.TemporaryDirectory() as directory:
            for loader in self.loaders(Path(directory) / 'missing.js'):
                with self.assertRaisesRegex(RuntimeError, 'Missing sealed ST bridge'):
                    loader()

    def test_loading_does_not_mutate_sealed_bytes(self):
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / 'bridge.js'
            output.write_text('sealed bridge')
            for loader in self.loaders(output):
                loader()
            self.assertEqual(output.read_text(), 'sealed bridge')


if __name__ == '__main__':
    unittest.main()
