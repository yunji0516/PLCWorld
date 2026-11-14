"""Regression checks for complete saved-ST packaging, including Claude."""
import hashlib
import json
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[1]


class SubmissionBundleTest(unittest.TestCase):
    def test_all_result_models_have_complete_submission_inventories(self):
        models = json.loads((ROOT / 'results/manifest.json').read_text())['direct_generation']
        entries = json.loads((ROOT / 'submissions/manifest.json').read_text())['entries']
        tasks = {row['id'] for row in json.loads((ROOT / 'evaluator/manifest.json').read_text())['tasks']}
        self.assertEqual({row['model'] for row in entries}, {row['model'] for row in models})
        keys = [(row['model'], row['repeat'], row['task']) for row in entries]
        self.assertEqual(len(keys), len(set(keys)))
        for model in models:
            for repeat in range(1, model['repetitions'] + 1):
                cohort = [row for row in entries if row['model'] == model['model'] and row['repeat'] == repeat]
                self.assertEqual({row['task'] for row in cohort}, tasks)
                for row in cohort:
                    if row['status'] == 'present':
                        expected = f"submissions/{row['model']}/repeat-{repeat:02}/{row['task']}.st"
                        self.assertEqual(row['path'], expected)
                        self.assertEqual(hashlib.sha256((ROOT / expected).read_bytes()).hexdigest(), row['sha256'])
                    else:
                        self.assertEqual(row['status'], 'missing')

    def test_claude_has_three_complete_repetitions(self):
        models = json.loads((ROOT / 'results/manifest.json').read_text())['direct_generation']
        entries = json.loads((ROOT / 'submissions/manifest.json').read_text())['entries']
        model = next(row for row in models if row['model'] == 'claude-sonnet-5')
        self.assertEqual(model['repetitions'], 3)
        self.assertEqual(model['total_cases'], 1419)
        claude = [row for row in entries if row['model'] == 'claude-sonnet-5']
        self.assertEqual(len(claude), 300)
        self.assertTrue(all(row['status'] == 'present' for row in claude))


if __name__ == '__main__':
    unittest.main()
