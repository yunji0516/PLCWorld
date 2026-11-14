"""Check replay projections against the sealed capping mechanism."""
import copy
import importlib.util
import json
from pathlib import Path
import sys
import tempfile
import unittest
from types import SimpleNamespace

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'scripts'))
from material_visual.project import capper_position
from replay_run_index import write_index

class DisplayTest(unittest.TestCase):
    def test_capper_matches_mechanism_for_nominal_and_slow_cases(self):
        runtime = ROOT / 'evaluator/common/groups/hard/runtime'
        sys.path.insert(0, str(runtime))
        from material_hard_stations import Capper
        for duration in (1.6, 3.5):
            plant = SimpleNamespace(dt=.01, parts={1:{'capped':False}}, emit=lambda *a,**k:None)
            cap = Capper(plant, {'a':-1.3,'b':1.3}, -1., cap_s=duration)
            cap.request('b', {'token':1})
            heights = []
            for _ in range(700):
                cap.step()
                recorded = {'x':cap.x,'job':copy.deepcopy(cap.job)}
                before = copy.deepcopy(recorded)
                position = capper_position(recorded, duration)
                self.assertAlmostEqual(position[1], cap.y-.25*cap.down)
                self.assertEqual(recorded,before)
                heights.append(position[1])
            self.assertAlmostEqual(min(heights),1.2)
            self.assertAlmostEqual(heights[-1],1.45)
            self.assertTrue(plant.parts[1]['capped'])

    def test_index_excludes_program_geometry_and_scan_payloads(self):
        bundle={'schema_version':'canonical-replay-trace/0.2','tasks':{'MAT-H09':{'runs':{'generated':{'label':'generated','verdict':'FAIL','goal':False,'frames':[{'huge':'payload'}],'il':'program','recorded_geometry':{'huge':'geometry'}}}}}}
        before=copy.deepcopy(bundle)
        with tempfile.TemporaryDirectory() as directory:
            write_index(Path(directory)/'original-replay.catalog.json',bundle)
            result=json.loads((Path(directory)/'original-replay.index.json').read_text())
            run=result['tasks']['MAT-H09']['runs']['generated']
            self.assertEqual(run['verdict'],'FAIL')
            self.assertEqual(run['frames'],[])
            self.assertNotIn('recorded_geometry',run)
            self.assertEqual(run['il'],'')
        self.assertEqual(bundle,before)

if __name__ == '__main__': unittest.main()
