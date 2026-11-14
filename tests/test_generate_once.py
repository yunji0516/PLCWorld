"""Offline tests for the one-call generation and replay path."""

from __future__ import annotations

import argparse
import importlib.util
import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch


ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location("generate_once", ROOT / "scripts/generate_once.py")
generator = importlib.util.module_from_spec(spec)
assert spec and spec.loader
spec.loader.exec_module(generator)


class GenerateOnceTest(unittest.TestCase):
    def args(self, **changes):
        values = dict(task="MAT-E01", model="test-model", max_completion_tokens=32768,
                      temperature=None, scenario=0, dry_run=False)
        values.update(changes)
        return argparse.Namespace(**values)

    def test_dry_run_uses_frozen_inputs_without_api_key(self):
        with patch.dict("os.environ", {"OPENAI_API_KEY": ""}), patch.object(generator, "request_completion") as request:
            self.assertIsNone(generator.run(self.args(dry_run=True)))
            request.assert_not_called()

    def test_one_call_evaluates_and_keeps_replay(self):
        code = (ROOT / "submissions/gpt-5.5/repeat-01/MAT-E01.st").read_text(encoding="utf-8")
        response = {"id": "mock-id", "choices": [{"finish_reason": "stop", "message": {"content": code}}],
                    "usage": {"total_tokens": 10}}
        with tempfile.TemporaryDirectory() as directory, \
             patch.object(generator, "OUTPUTS", Path(directory)), \
             patch.object(generator, "request_completion", return_value=response) as request, \
             patch.dict("os.environ", {"OPENAI_API_KEY": "test-only"}):
            output = generator.run(self.args())
            self.assertEqual(request.call_count, 1)
            body = request.call_args.args[0]
            self.assertEqual([row["role"] for row in body["messages"]], ["system", "user"])
            self.assertEqual(body["messages"][1]["content"],
                             (ROOT / "inputs/tasks/material/easy/MAT-E01/st-generation.user.md").read_text(encoding="utf-8"))
            metadata = json.loads((output / "run.json").read_text(encoding="utf-8"))
            self.assertEqual(metadata["status"], "evaluated")
            self.assertTrue(metadata["results"][0]["task_success"])
            self.assertNotIn("test-only", json.dumps(metadata))
            self.assertTrue((output / "evaluation/case-00.frames.json.gz").is_file())
            self.assertTrue((output / "original-replay.catalog.json").is_file())
            self.assertTrue((output / "original-replay.index.json").is_file())
            self.assertEqual(metadata["replay_url"], metadata["original_3d_url"])
            self.assertIn("localhost:3201/replay?task=MAT-E01", metadata["replay_url"])

    def test_incomplete_response_is_not_evaluated(self):
        response = {"choices": [{"finish_reason": "length", "message": {"content": "PROGRAM Main"}}]}
        with tempfile.TemporaryDirectory() as directory, \
             patch.object(generator, "OUTPUTS", Path(directory)), \
             patch.object(generator, "request_completion", return_value=response), \
             patch.dict("os.environ", {"OPENAI_API_KEY": "test-only"}):
            with self.assertRaisesRegex(RuntimeError, "incomplete"):
                generator.run(self.args())
            output = next(Path(directory).iterdir())
            self.assertFalse((output / "evaluation").exists())
            self.assertEqual(json.loads((output / "run.json").read_text())["status"], "incomplete_response")

    def test_motion_easy_run_is_adapted_for_original_3d(self):
        code = (ROOT / "submissions/gpt-5.5/repeat-01/MOT-E01.st").read_text(encoding="utf-8")
        response = {"choices": [{"finish_reason": "stop", "message": {"content": code}}]}
        with tempfile.TemporaryDirectory() as directory, \
             patch.object(generator, "OUTPUTS", Path(directory)), \
             patch.object(generator, "request_completion", return_value=response), \
             patch.dict("os.environ", {"OPENAI_API_KEY": "test-only"}):
            output = generator.run(self.args(task="MOT-E01"))
            metadata = json.loads((output / "run.json").read_text())
            self.assertIn("original_3d_url", metadata)
            catalog = json.loads((output / "original-replay.catalog.json").read_text())
            runs = catalog["tasks"]["MOT-E01"]["runs"]
            # A generated sidecar contains only that run; the viewer merges it
            # with the immutable base catalog instead of copying reference data.
            self.assertEqual(len(runs), 1)
            self.assertTrue(any(name.startswith(f"My runs · {output.name}") for name in runs))
            base = json.loads((ROOT / "replay/viewer/catalog.json").read_text())
            self.assertTrue(base["tasks"]["MOT-E01"]["runs"]["Reference · condition 0"]["goal"])

    def test_invalid_st_has_score_but_no_replay_link(self):
        response = {"choices": [{"finish_reason": "stop", "message": {"content": "not an ST program"}}]}
        with tempfile.TemporaryDirectory() as directory, \
             patch.object(generator, "OUTPUTS", Path(directory)), \
             patch.object(generator, "request_completion", return_value=response), \
             patch.dict("os.environ", {"OPENAI_API_KEY": "test-only"}):
            output = generator.run(self.args(task="MOT-E01"))
            metadata = json.loads((output / "run.json").read_text())
            self.assertEqual(metadata["status"], "evaluated")
            self.assertFalse(metadata["results"][0]["replay_available"])
            self.assertNotIn("replay_url", metadata)
            self.assertNotIn("original_3d_url", metadata)


if __name__ == "__main__":
    unittest.main()
