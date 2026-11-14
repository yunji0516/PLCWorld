"""The flattened release records reject data drift and unverified source seals."""
import hashlib
import json
from pathlib import Path
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'scripts'))
from artifact_provenance import (protect_historical_output, trusted_evaluator_seals,
                                 verify_historical_data, verify_release_files)


class ReleaseVerificationTest(unittest.TestCase):
    def save(self, name, value):
        path = self.root / name
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(json.dumps(value))
        return hashlib.sha256(path.read_bytes()).hexdigest()

    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.root = Path(self.temp.name)
        runtime = self.save('evaluator/runtime.json', {'scan_ms': 10})
        current = self.save('evaluator/release-seal.json', {'runtime.json': runtime})
        prompt = self.save('inputs/prompt.json', {'objective': 'stop'})
        inputs = self.save('inputs/input-seal.json', {'prompt.json': prompt})
        historical = self.save('replay/result.json', {'passed': True, 'source_seal': 'a' * 64})
        script = self.save('scripts/example.json', {'helper': True})
        self.files = {'evaluator/runtime.json': runtime,
                      'evaluator/release-seal.json': current, 'inputs/prompt.json': prompt,
                      'inputs/input-seal.json': inputs, 'replay/result.json': historical,
                      'scripts/example.json': script}
        self.evidence = {
            'schema': 'plcworld-release-equivalence/1', 'passed': True,
            'current_evaluator_seal_sha256': current, 'input_seal_sha256': inputs,
            'accepted_source_seals': [current, 'a' * 64],
            'behavioral_checks': [{'passed': True, 'api_calls': 0, 'cases_checked': 1,
                'previous_evaluator_seal_sha256': 'a' * 64,
                'current_evaluator_seal_sha256': current,
                'results': [{'passed': True, 'scoring_fields_match': True,
                             'differing_fields': [], 'trace_sha256_before': 'c' * 64,
                             'trace_sha256_after': 'c' * 64}]}]}
        self.artifact = {'evaluator_seal_sha256': current, 'input_seal_sha256': inputs,
                         'release_verification': {'integrity_file': 'verification/integrity.json',
                                                  'equivalence_file': 'verification/equivalence.json'}}
        self.inventory = {'schema': 'plcworld-release-integrity/1', 'files': self.files,
                          'historical_files': {'replay/result.json': historical}}
        self.repin()

    def repin(self):
        proof = self.save('verification/equivalence.json', self.evidence)
        self.files['verification/equivalence.json'] = proof
        inventory = self.save('verification/integrity.json', self.inventory)
        self.artifact['release_verification'].update(integrity_sha256=inventory,
                                                     equivalence_sha256=proof)
        self.save('artifact.json', self.artifact)
        trusted_evaluator_seals.cache_clear()

    def tearDown(self):
        trusted_evaluator_seals.cache_clear()
        self.temp.cleanup()

    def test_accepts_connected_source_seal(self):
        self.assertEqual(trusted_evaluator_seals(self.root),
                         {self.artifact['evaluator_seal_sha256'], 'a' * 64})
        self.assertEqual(verify_historical_data(self.root), 1)
        self.assertEqual(verify_release_files(self.root), len(self.files))

    def test_rejects_unconnected_source_seal(self):
        self.evidence['accepted_source_seals'].append('b' * 64)
        self.repin()
        with self.assertRaisesRegex(ValueError, 'Unverified'):
            trusted_evaluator_seals(self.root)

    def test_rejects_failed_trace_equivalence(self):
        self.evidence['behavioral_checks'][0]['results'][0]['trace_sha256_after'] = 'd' * 64
        self.repin()
        with self.assertRaisesRegex(ValueError, 'Behavioral'):
            trusted_evaluator_seals(self.root)

    def test_rejects_runtime_drift(self):
        self.save('evaluator/runtime.json', {'scan_ms': 20})
        with self.assertRaisesRegex(ValueError, 'runtime drift'):
            trusted_evaluator_seals(self.root)

    def test_rejects_input_drift(self):
        self.save('inputs/prompt.json', {'objective': 'move'})
        with self.assertRaisesRegex(ValueError, 'runtime drift'):
            trusted_evaluator_seals(self.root)

    def test_rejects_unsealed_runtime_file(self):
        self.save('evaluator/extra.json', {})
        with self.assertRaisesRegex(ValueError, 'unsealed'):
            trusted_evaluator_seals(self.root)

    def test_rejects_historical_data_drift(self):
        self.save('replay/result.json', {'passed': False})
        with self.assertRaisesRegex(ValueError, 'Historical data drift'):
            verify_historical_data(self.root)

    def test_rejects_helper_drift(self):
        self.save('scripts/example.json', {'helper': False})
        with self.assertRaisesRegex(ValueError, 'Release asset drift'):
            verify_release_files(self.root)

    def test_rejects_unpinned_evidence_changes(self):
        self.save('verification/equivalence.json', {})
        with self.assertRaisesRegex(ValueError, 'evidence hash mismatch'):
            trusted_evaluator_seals(self.root)

    def test_rejects_path_escape(self):
        self.inventory['historical_files']['../outside.json'] = 'e' * 64
        self.files['../outside.json'] = 'e' * 64
        self.repin()
        with self.assertRaisesRegex(ValueError, 'Unsafe'):
            verify_historical_data(self.root)

    def test_protects_release_files_and_parent_directories(self):
        for name in ('artifact.json', 'verification/new.json', 'replay/result.json', 'replay', '.'):
            with self.assertRaisesRegex(ValueError, 'immutable'):
                protect_historical_output(self.root, self.root / name)
        protect_historical_output(self.root, self.root / 'outputs/generated/new')
        protect_historical_output(self.root, self.root / 'outputs/new-report.json')

    def test_generated_runs_are_not_immutable_release_assets(self):
        self.save('outputs/generated/local/run.json', {'status': 'evaluated'})
        self.assertEqual(verify_release_files(self.root), len(self.files))

    def test_evaluator_profile_excludes_separate_viewer_and_host_files(self):
        self.files['viewer3d/package.json'] = self.save('viewer3d/package.json', {})
        self.files['compose.yaml'] = self.save('compose.yaml', {})
        self.repin()
        (self.root / 'viewer3d/package.json').unlink()
        (self.root / 'compose.yaml').unlink()
        self.assertEqual(verify_release_files(self.root, 'evaluator'), len(self.files) - 2)
        with self.assertRaises(FileNotFoundError):
            verify_release_files(self.root)

    def test_evaluator_profile_still_requires_its_helpers(self):
        (self.root / 'scripts/example.json').unlink()
        with self.assertRaises(FileNotFoundError):
            verify_release_files(self.root, 'evaluator')


if __name__ == '__main__':
    unittest.main()
