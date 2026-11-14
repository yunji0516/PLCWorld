"""Exercise typed ST, overflow, constants, syntax, and scan-clock timing."""
from pathlib import Path
import subprocess
import unittest

class RuntimeContractTest(unittest.TestCase):
    def test_all_packaged_runtimes(self):
        directory = Path(__file__).resolve().parent / 'runtime'
        for name in ('test_contract.cjs', 'test_constants.cjs',
                     'test_profile.cjs', 'test_all_runtimes.cjs'):
            with self.subTest(suite=name):
                result = subprocess.run(['node', str(directory / name)],
                                        capture_output=True, text=True, timeout=60)
                self.assertEqual(result.returncode, 0, result.stderr)
