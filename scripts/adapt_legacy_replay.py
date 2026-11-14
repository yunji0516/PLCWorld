"""Adapt sealed final-evaluator traces to the original 3D replay schema."""

from __future__ import annotations

import argparse
import copy
import gzip
import hashlib
import importlib.util
import json
from math import cos, pi, sin
from pathlib import Path
import sys
from types import SimpleNamespace
from artifact_provenance import protect_historical_output, trusted_evaluator_seals


from artifact_paths import model_input_dir

ROOT = Path(__file__).resolve().parents[1]
TASK = "MOT-E01"
PROJECTED_MECHANISMS = {
    "MOT-E09": "mot_e09_unit_v04_boundary_v09",
    "MOT-E10": "mot_e10_unit_v04",
    "MOT-E11": "mot_e11_unit_v04",
    "MOT-E12": "mot_e12_unit_v04",
    "MOT-E14": "mot_e14_unit_v04_boundary_v09",
    "MOT-E15": "mot_e15_unit_v04",
}
MOBILE_TASK = "MOT-E13"
PUBLIC_GEOMETRY_TASKS = tuple(f"MOT-E{i:02}" for i in range(2, 16))
MEDIUM_PROJECTED = {
    "MOT-M04": "mot_m04_hoist_v11",
    "MOT-M05": "mot_m05_counterbalance_v11",
    "MOT-M14": "mot_m14_table_slide_v12",
}
MEDIUM_ASSEMBLY = {
    "MOT-M01": ("mot_m01_exchange_v11", {"S_AXIS_A": "s", "U_AXIS_A": "u", "V_AXIS_A": "v"}),
    "MOT-M03": ("mot_m03_flying_v11", {"S_AXIS_A": "s", "U_AXIS_A": "u", "F_AXIS_A": "f"}),
}
MEDIUM_AXIS_TASKS = (*MEDIUM_ASSEMBLY, *MEDIUM_PROJECTED, "MOT-M20")
PRIORITY_GEOMETRY_TASKS = ("MOT-M02", "MOT-M12")
GROUNDED_GEOMETRY_TASKS = tuple(f"MOT-M{i:02}" for i in (6, 7, 8, 9, 10, 11, 13, 15, 16, 17, 18, 19))
GROUNDED_V6_TASKS = {f"MOT-M{i:02}" for i in (6, 7, 13, 15, 19)}
HARD_BATCH_TASKS = tuple(f"MOT-H{i:02}" for i in range(1, 16))
MATERIAL_EASY_TASKS = tuple(f"MAT-E{i:02}" for i in range(1, 16))
MATERIAL_MEDIUM_TASKS = tuple(f"MAT-M{i:02}" for i in range(1, 21))
MATERIAL_HARD_TASKS = tuple(f"MAT-H{i:02}" for i in range(1, 16))
MATERIAL_TASKS = (*MATERIAL_EASY_TASKS, *MATERIAL_MEDIUM_TASKS, *MATERIAL_HARD_TASKS)
MATERIAL_CATALOG_IDS = {
    **{task_id: task_id.replace("MAT-E", "MAT-EASY15-E") for task_id in MATERIAL_EASY_TASKS},
    **dict(zip(MATERIAL_MEDIUM_TASKS, (
        "MAT-V6-D01", "MAT-V6-D03", "MAT-V6-D04", "MAT-V6-D06", "MAT-V6-D10",
        "MAT-V7-D11", "MAT-V7-D12", "MAT-V7-D13", "MAT-V7-D14", "MAT-V7-D15",
        "MAT-V8-D16", "MAT-V8-D17", "MAT-V8-D18", "MAT-V8-D19", "MAT-V8-D20",
        "MAT-V8-D21", "MAT-V8-D22", "MAT-M18-TAPE-R1", "MAT-V8-D24", "MAT-V8-D25",
    ))),
    **{task_id: task_id for task_id in MATERIAL_HARD_TASKS},
}
DEFERRED_TASKS = (*GROUNDED_GEOMETRY_TASKS, *HARD_BATCH_TASKS,
                  *(MATERIAL_CATALOG_IDS[task_id] for task_id in MATERIAL_TASKS))
DEVICE_AXES = {
    "MOT-E01": {"AXIS": "s"},
    "MOT-E02": {"AXIS": "s"},
    "MOT-E03": {"S_AXIS_A": "s"},
    "MOT-E04": {"S_AXIS_A": "s"},
    "MOT-E05": {"S_AXIS_A": "s"},
    "MOT-E06": {"V_AXIS_A": "v"},
    "MOT-E07": {"S_AXIS_A": "s", "U_AXIS_A": "u"},
    "MOT-E08": {"S_AXIS_A": "s", "U_AXIS_A": "u"},
    **{task_id: {} for task_id in PROJECTED_MECHANISMS},
    MOBILE_TASK: {},
    "MOT-M04": {},
    "MOT-M05": {},
    "MOT-M14": {"SLIDE": "b"},
    "MOT-M20": {"S_AXIS_A": "s", "U_AXIS_A": "u"},
    **{task_id: mapping for task_id, (_, mapping) in MEDIUM_ASSEMBLY.items()},
}


def scenario_data(package: Path, scenario_index: int) -> dict:
    scenarios = read_json(package / "task.json")["scenarios"]
    if not 0 <= scenario_index < len(scenarios):
        raise SystemExit(f"Invalid replay scenario {scenario_index}: {package.name}")
    return read_json(package / scenarios[scenario_index])


def project_mechanism(task_id: str, axes: dict, scan: int, scenario_index: int = 0) -> dict:
    """Apply the sealed simulator's pose equation to recorded final axis values."""
    benchmark = (ROOT / "evaluator/common/groups/motion-core/runtime")
    if str(benchmark) not in sys.path:
        sys.path.insert(0, str(benchmark))
    from motion_medium_mechanisms import DiverseMotionPlant

    package = benchmark / "tasks" / PROJECTED_MECHANISMS[task_id]
    calibration = read_json(package / "calibration.json")
    scenario = scenario_data(package, scenario_index)
    calibration.update(scenario.get("parameters", {}))
    calibration["obstruction_start_ms"] = scenario["initial"].get("obstacle_ms", 100)
    plant = object.__new__(DiverseMotionPlant)
    plant.mode = calibration["mechanism"]
    plant.c = calibration
    plant.i = scenario["initial"]
    plant.drives = {axis: SimpleNamespace(x=state["actual"]) for axis, state in axes.items()}
    plant.time_ms = (scan + 1) * 10
    plant.wheel_l = 0
    plant.wheel_r = 0
    mechanism = plant.mechanism()
    if task_id == "MOT-E10":
        mechanism["poses"].pop("pin", None)
    return mechanism


def replay_mobile_mechanisms(frames: list, scenario_index: int = 0) -> dict[int, dict]:
    """Reconstruct wheel poses from sealed commands and check every recorded axis."""
    benchmark = (ROOT / "evaluator/common/groups/motion-core/runtime")
    if str(benchmark) not in sys.path:
        sys.path.insert(0, str(benchmark))
    from motion_easy import LocalMotionPlant

    package = benchmark / "tasks/mot_e13_unit_v04"
    frozen = SimpleNamespace(
        plant=read_json(package / "plant.json"),
        binding=read_json(package / "binding.json"),
        calibration=read_json(package / "calibration.json"),
    )
    simulator = LocalMotionPlant(frozen, scenario_data(package, scenario_index))
    mechanisms = {}
    for frame in frames:
        simulator.apply_commands(frame["command_image"])
        simulator.step_devices(10)
        recorded = frame["plant"]["motion_easy_unit"]["axes"]
        if any(abs(simulator.x(axis) - state["actual"]) > 1e-6 for axis, state in recorded.items()):
            raise SystemExit(f"Mobile mechanism replay diverged at scan {frame['scan']}")
        mechanisms[frame["scan"]] = simulator.snapshot()["motion_easy_unit"]["mechanism"]
    return mechanisms


def project_medium_mechanism(task_id: str, state: dict, scan: int, scenario_index: int = 0) -> dict:
    """Restore the sealed Medium mechanism poses omitted from compact traces."""
    benchmark = (ROOT / "evaluator/common/groups/motion-core/runtime")
    package = benchmark / "tasks" / MEDIUM_PROJECTED[task_id]
    axes = state["axes"]
    if task_id == "MOT-M14":
        # Exact geometry equation in the frozen TableSlidePlant.snapshot().
        angle = axes["a"]["actual_deg"] * pi / 180
        slide = axes["b"]["actual_mm"] / 1000
        return {
            "mode": "table_slide", "initial": {},
            "axis_labels": {"a": "Rotary table", "b": "Approach slide"},
            "poses": {
                "table": {"pos": [0, .85, 0], "quaternion": [0, -sin(angle / 2), 0, cos(angle / 2)]},
                "tongue": {"pos": [1.25 - slide, 1.0412, 0], "quaternion": [0, 0, 0, 1]},
                "cantilever": {"pos": [1.475 - slide, 1.0412, 0], "quaternion": [0, 0, 0, 1]},
            },
        }
    if str(benchmark) not in sys.path:
        sys.path.insert(0, str(benchmark))
    from motion_boundary import BoundaryMotionPlant
    from motion_medium_mechanisms import DiverseMotionPlant

    calibration = read_json(package / "calibration.json")
    scenario = scenario_data(package, scenario_index)
    calibration.update(scenario.get("parameters", {}))
    simulator = object.__new__(BoundaryMotionPlant if task_id == "MOT-M05" else DiverseMotionPlant)
    simulator.mode = read_json(package / "plant.json")["interactions"][0]["mode"]
    simulator.c = calibration
    simulator.i = scenario["initial"]
    simulator.drives = {axis: SimpleNamespace(x=values.get("actual_mm", values.get("actual_deg")))
                        for axis, values in axes.items()}
    simulator.time_ms = (scan + 1) * 10
    simulator.wheel_l = 0
    simulator.wheel_r = 0
    if task_id == "MOT-M05":
        simulator.brake = state["diagnostics"]["brake_fraction"]
    return simulator.mechanism()


def project_medium_assembly(task_id: str, axes: dict) -> dict:
    """Resolve the frozen moving-assembly mounts from recorded normalized axes."""
    benchmark = ROOT / "evaluator/common/groups/motion-core/runtime"
    if str(benchmark) not in sys.path:
        sys.path.insert(0, str(benchmark))
    from motion_assembly import resolve

    package_name, mapping = MEDIUM_ASSEMBLY[task_id]
    scene = read_json(benchmark / "tasks" / package_name / "plant.json")["scene"]
    states = {device: axes[axis]["position"] for device, axis in mapping.items()}
    return resolve(scene, states)


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def read_json(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8"))


def material_package(task_id: str):
    """Load the final evaluator's declarative 3D scene for a Material task."""
    if task_id == "MAT-H07":
        raise ValueError("MAT-H07 uses a priority plant without a declarative PlantSpec")
    group = "hard" if task_id in MATERIAL_HARD_TASKS else "material-core"
    benchmark = ROOT / f"evaluator/common/groups/{group}/runtime"
    if str(benchmark) not in sys.path:
        sys.path.insert(0, str(benchmark))
    spec = importlib.util.spec_from_file_location(f"plcworld_{group.replace('-', '_')}_plant_spec", benchmark / "plant_spec.py")
    if spec is None or spec.loader is None:
        raise RuntimeError(f"Cannot load sealed PlantSpec projector: {group}")
    module = sys.modules.get(spec.name)
    if module is None:
        module = importlib.util.module_from_spec(spec)
        sys.modules[spec.name] = module
        spec.loader.exec_module(module)

    manifest = read_json(ROOT / "evaluator/manifest.json")
    package_name = next(item["package"] for item in manifest["tasks"] if item["id"] == task_id)
    return module.PlantPackage.load(benchmark / package_name)


def adapt_material_run(frames: list, result: dict, layout: dict, *, label: str,
                       category: str, model: str, program: str = "", scenario: int = 0) -> dict:
    """Project recorded scans with sealed PlantSpec geometry, without re-simulating."""
    package = material_package(layout["evaluation_task"])
    scene = package.scene()
    converted = []
    violations = []
    seen = set()
    for source in frames:
        projected = scene.project_frame(source)
        projected["time_ms"] = source["time_ms"]
        if layout["evaluation_task"] in MATERIAL_HARD_TASKS and layout["evaluation_task"] != "MAT-H01":
            physical = source["plant"].get("material_hard")
            if physical is None or "parts" not in physical:
                raise SystemExit(f"Missing recorded Material Hard physical state: {layout['evaluation_task']}, scan {source['scan']}")
            poses = {f"part{part_id}": {"pos": [part["x"], part["y"], part["z"]],
                                         "size": part.get("size", [0.2, 0.1, 0.2])}
                     for part_id, part in physical["parts"].items()
                     if all(axis in part for axis in ("x", "y", "z"))}
            from material_contact_projection import project
            contact = project(source["plant"], layout["devices"])
            projected["world"]["material_hard"] = {**physical, "poses": poses, "contact": contact}
        converted.append(projected)
        for entry in source["plant"].get("violations", []):
            name = entry["type"] if isinstance(entry, dict) else str(entry)
            if name not in seen:
                seen.add(name)
                violations.append({"k": source["scan"], "name": name})
    if converted and converted[0].get("world", {}).get("material_hard", {}).get("contact"):
        inventory = {}
        for frame in converted:
            inventory.update(frame["world"]["material_hard"]["contact"]["poses"])
        converted[0]["world"]["material_hard"]["contact"]["inventory"] = inventory
    from material_visual.project import project as project_geometry
    geometry = (project_geometry(layout["evaluation_task"], frames,
                                 parameters={**package.calibration, **scenario_data(package.task_dir, scenario).get("parameters", {})})
                if layout["evaluation_task"] in MATERIAL_HARD_TASKS and layout["evaluation_task"] != "MAT-H01" else None)
    return {
        **({"recorded_geometry": geometry} if geometry is not None else {}),
        "label": label, "category": category, "frames": converted,
        "il": program, "viol": violations,
        "goal": result["task_success"],
        "verdict": "PASS" if result["task_success"] and not result["safety_violation"] else "FAIL",
        "reason": result.get("stop_reason") or "final evaluator result", "model": model,
    }


def objective_only(markdown: str) -> str:
    """Keep only the Objective section in the public 3D replay catalog."""
    lines = markdown.splitlines()
    start = next((i for i, line in enumerate(lines)
                  if line.strip().lower() == "## objective"), None)
    if start is None:
        raise ValueError("Task specification has no Objective heading")
    body = []
    for line in lines[start + 1:]:
        if line.lstrip().startswith("#"):
            break
        if line.strip():
            body.append(line)
    if not body:
        raise ValueError("Task Objective section is empty")
    return "## Objective\n\n" + "\n".join(body).strip() + "\n"


def task_io(markdown: str) -> dict[str, str]:
    section = markdown.split("## I/O Interface", 1)[1].split("\n## ", 1)[0]
    rows = {}
    for line in section.splitlines():
        cells = [cell.strip() for cell in line.strip().strip("|").split("|")]
        if len(cells) == 4 and cells[0].startswith(("X", "Y", "D")) and cells[0][1:].isdigit():
            rows[cells[0]] = cells[3].rstrip(".")
    if not rows:
        raise ValueError("Task specification has no I/O table")
    return rows


def reference_run(task_id: str, layout: dict, seal: str) -> dict:
    directory = ROOT / "replay/traces/reference" / task_id
    result = read_json(directory / "manifest.json")
    compressed = (directory / "case-00.frames.json.gz").read_bytes()
    if (result["task"] != task_id or result["evaluator_seal_sha256"] not in trusted_evaluator_seals(ROOT)
            or result["error"] or not result["task_success"] or result["safety_violation"]
            or sha256(compressed) != result["trace_gzip_sha256"]):
        raise SystemExit(f"Reference trace provenance mismatch: {task_id}")
    raw = gzip.decompress(compressed)
    if sha256(raw) != result["trace_sha256"]:
        raise SystemExit(f"Reference trace hash mismatch: {task_id}")
    frames = json.loads(raw)
    if not frames or any(frame["scan"] != index for index, frame in enumerate(frames)):
        raise SystemExit(f"Reference scans are not contiguous: {task_id}")
    converter = (adapt_priority_material_run if task_id == "MAT-H07" else
                 adapt_material_run if task_id in MATERIAL_TASKS else
                 adapt_hard_run if task_id in HARD_BATCH_TASKS else
                 adapt_priority_run if task_id in PRIORITY_GEOMETRY_TASKS else
                 adapt_grounded_run if task_id in GROUNDED_GEOMETRY_TASKS else adapt_run)
    return converter(frames, result, layout, label="Reference · condition 0",
                     category="reference", model="reference", scenario=0)


def adapt_priority_material_run(frames: list, result: dict, layout: dict, *, label: str,
                                category: str, model: str, program: str = "", scenario: int = 0) -> dict:
    """Use MAT-H07's recorded priority-plant physical snapshot directly."""
    if layout["evaluation_task"] != "MAT-H07":
        raise ValueError("Priority Material adapter only supports MAT-H07")
    binding = read_json(ROOT / "evaluator/priority/runtime/engine/tasks/MAT-H07/binding.json")
    converted = []
    violations = []
    seen = set()
    for frame in frames:
        state = frame["state_after"]
        physical = state["physical"]
        material = copy.deepcopy(state["material_hard"])
        material["wind_tape"] = {
            "source_a_radius": physical["sources"]["a"]["radius"],
            "source_b_radius": physical["sources"]["b"]["radius"],
            "source_a_path": physical["sources"]["a"]["path"],
            "source_b_path": physical["sources"]["b"]["path"],
            "tape_head": physical["extension"]["tape"]["head"],
            "tape_length": physical["extension"]["tape"]["length"],
            "tape_severed": physical["extension"]["tape"]["severed"],
            "mandrel": physical["mandrel"],
            "support_y": physical["support_y"],
            "exit_pusher_x": physical["exit_pusher_x"],
            "exit_pusher_z": physical["exit_pusher_z"],
        }
        for entry in state.get("violations", []):
            name = entry["type"] if isinstance(entry, dict) else str(entry)
            if name not in seen:
                seen.add(name)
                violations.append({"k": frame["scan"], "name": name})
        converted.append({
            "k": frame["scan"], "time_ms": frame["time_end_ms"],
            "x": {key: int(bool(value)) for key, value in frame["inputs"].items() if key.startswith("X")},
            "y": {address: int(bool(frame["outputs"][key])) for key, address in binding["outputs"].items()},
            "words": {key: int(value) for key, value in frame["inputs"].items() if key.startswith("D")},
            "s": {"MATERIAL_CELL": 0}, "v": int(bool(state.get("violations"))),
            "world": {"devices": {}, "parts": {}, "events": [entry["type"] for entry in frame["events"]],
                      "material_hard": material},
        })
    from material_visual.project import project as project_geometry
    geometry = (project_geometry(layout["evaluation_task"], frames)
                if layout["evaluation_task"] in MATERIAL_HARD_TASKS and layout["evaluation_task"] != "MAT-H01" else None)
    return {
        **({"recorded_geometry": geometry} if geometry is not None else {}),
        "label": label, "category": category, "frames": converted, "il": program,
        "viol": violations, "goal": result["task_success"],
        "verdict": "PASS" if result["task_success"] and not result["safety_violation"] else "FAIL",
        "reason": result.get("stop_reason") or "final evaluator result", "model": model,
    }


def adapt_hard_run(frames: list, result: dict, layout: dict, *, label: str,
                   category: str, model: str, program: str = "", scenario: int = 0) -> dict:
    """Restore omitted physical poses from frozen Hard plant state, never PLC policy."""
    task_id = layout["task"]
    if task_id not in HARD_BATCH_TASKS:
        raise ValueError("Unsupported Hard 3D task")
    benchmark = ROOT / "evaluator/common/groups/hard/runtime"
    if str(benchmark) not in sys.path:
        sys.path.insert(0, str(benchmark))
    from motion_hard_miniprocess import MiniProcessPlant
    from motion_mini_line_h01 import MiniLinePlant

    manifest = read_json(ROOT / "evaluator/manifest.json")
    package_name = next(item["package"] for item in manifest["tasks"] if item["id"] == task_id)
    package = benchmark / package_name
    calibration = read_json(package / "calibration.json")
    calibration.update(scenario_data(package, scenario).get("parameters", {}))
    simulator = object.__new__(MiniLinePlant if task_id == "MOT-H01" else MiniProcessPlant)
    simulator.c = calibration
    simulator.raw = {}
    if task_id != "MOT-H01":
        simulator.layout = calibration["layout"]
        simulator.slug = calibration["task_slug"]
        simulator.i = {}
    converted = []
    violations = []
    seen_violations = set()
    for frame in frames:
        motion = copy.deepcopy(frame["plant"]["motion_hard"])
        simulator.drives = {axis: SimpleNamespace(x=state["actual"], v=state["velocity"])
                            for axis, state in motion["axes"].items()}
        simulator.jobs = motion["requests"]
        simulator.time_ms = frame["time_ms"]
        if task_id == "MOT-H01":
            simulator.locations = {int(lane): position
                                   for lane, position in motion["line"]["locations"].items()}
            motion["mechanisms"] = simulator.mechanisms()
        else:
            simulator.stage = {int(station): {**state, "local": motion["process"]["metrics"].get(station, {})}
                               for station, state in motion["process"]["stages"].items()}
            simulator.brake = motion["shared"]["brake_fraction"]
            simulator.locations = {job["lane"]: job["location"] for job in motion["requests"]}
            motion["process"]["cells"] = simulator.cells_snapshot()
            if not converted:
                motion["process"]["layout"] = simulator.layout
        motion["poses"] = simulator.poses()
        events = [event["type"] if isinstance(event, dict) else str(event)
                  for event in frame.get("events", [])]
        for entry in frame["plant"].get("violations", []):
            name = entry["type"] if isinstance(entry, dict) else str(entry)
            if name not in seen_violations:
                seen_violations.add(name)
                violations.append({"k": frame["scan"], "name": name})
        bits = frame.get("plc", {}).get("bits", {})
        converted.append({
            "k": frame["scan"], "time_ms": frame["time_ms"],
            "x": {key: value for key, value in frame["input_image"].items() if key.startswith("X")},
            "y": {key: value for key, value in bits.items() if key.startswith("Y")},
            "words": frame.get("plc", {}).get("words", {}),
            "s": {"CELL": 0}, "v": int(bool(frame["plant"].get("violations"))),
            "world": {"devices": {}, "parts": {}, "events": events, "motion_hard": motion},
        })
    return {
        "label": label, "category": category, "frames": converted,
        "il": program, "viol": violations,
        "goal": result["task_success"],
        "verdict": "PASS" if result["task_success"] and not result["safety_violation"] else "FAIL",
        "reason": result.get("stop_reason") or "final evaluator result", "model": model,
    }


def adapt_grounded_run(frames: list, result: dict, layout: dict, *, label: str,
                       category: str, model: str, program: str = "", scenario: int = 0) -> dict:
    """Project frozen grounded-Medium states into the original measured 3D scene."""
    task_id = layout["task"]
    if task_id not in GROUNDED_GEOMETRY_TASKS:
        raise ValueError("Unsupported grounded-motion geometry")
    benchmark = ROOT / "evaluator/motion/runtime"
    if str(benchmark) not in sys.path:
        sys.path.insert(0, str(benchmark))
    from project_grounded_motion import geometry

    version = "spatial" if task_id in GROUNDED_V6_TASKS else "planar"
    package = benchmark / "dependencies" / version / "tasks" / task_id
    binding = read_json(package / "binding.json")
    calibration = read_json(package / "calibration.json")
    task_number = int(task_id[-2:])
    converted = []
    violations = []
    for frame in frames:
        state = frame["state_after"]
        scene = geometry(task_number, state)
        poses = scene.pop("poses")
        memory = dict(frame["inputs"])
        memory.update({address: frame["outputs"][key] for key, address in binding["commands"].items()})
        memory[binding["result"]["completion"]] = frame["outputs"]["result"]
        events = [event["type"] if isinstance(event, dict) else str(event)
                  for event in frame.get("events", [])]
        if not state.get("geometry_safe", True):
            violations.append({"k": frame["scan"], "name": "geometry_interference"})
        axes = {axis: dict(actual=value["position"], velocity=value["velocity"],
                           target=frame["outputs"].get(f"{axis}_target", round(value["position"] * 100)) / 100,
                           unit=calibration["axis_units"][axis])
                for axis, value in state["axes"].items()}
        motion = {
            "mode": "dependency", "axes": axes, "requests": [],
            "shared": {"contract_revision": 6, "local_dwell_ms": state["dwell_ms"],
                       "evaluation_complete": int(frame is frames[-1]),
                       "task_success": int(bool(result["task_success"])),
                       "safety_violation": int(bool(result["safety_violation"]))},
            "routes": [], "poses": poses, "mechanisms": {}, "dependency": scene,
            "result_asserted": state["result"], "result_age_ms": state["hold_ms"],
            "success": bool(result["task_success"] and not result["safety_violation"]
                            and frame is frames[-1]),
            "violations": [entry["name"] for entry in violations if entry["k"] == frame["scan"]],
            "available": state["time_ms"] >= 30,
        }
        converted.append({
            "k": frame["scan"], "time_ms": state["time_ms"],
            "x": {key: int(value) for key, value in memory.items() if key.startswith("X")},
            "y": {key: int(value) for key, value in memory.items() if key.startswith("Y")},
            "words": {key: value for key, value in memory.items() if key.startswith("D")},
            "s": {"CELL": 0}, "v": int(not state.get("geometry_safe", True)),
            "world": {"devices": {}, "parts": {}, "events": events, "motion_hard": motion},
        })
    return {
        "label": label, "category": category, "frames": converted,
        "il": program, "viol": violations,
        "goal": result["task_success"],
        "verdict": "PASS" if result["task_success"] and not result["safety_violation"] else "FAIL",
        "reason": result.get("stop_reason") or "final evaluator result", "model": model,
    }


def adapt_priority_run(frames: list, result: dict, layout: dict, *, label: str,
                       category: str, model: str, program: str = "", scenario: int = 0) -> dict:
    """Map recorded priority-plant scans to the existing local 3D schema."""
    task_id = layout["task"]
    if task_id not in PRIORITY_GEOMETRY_TASKS:
        raise ValueError("Unsupported priority geometry")
    from project_priority_geometry import jig_approach_geometry, rail_transfer_geometry

    projection = rail_transfer_geometry if task_id == "MOT-M02" else jig_approach_geometry
    binding = read_json(ROOT / "evaluator/priority/runtime/engine/tasks" / task_id / "binding.json")
    converted = []
    violations = []
    violation_types = {"geometry_interference", "travel_limit", "gantry_skew", "motion_before_request"}
    for frame in frames:
        state = frame["state_after"]
        geometry = projection(state)
        memory = dict(frame["inputs"])
        memory.update({address: frame["outputs"][key] for key, address in binding["commands"].items()})
        memory[binding["result"]["completion"]] = frame["outputs"]["result"]
        events = [event["type"] if isinstance(event, dict) else str(event)
                  for event in frame.get("events", [])]
        for name in events:
            if name in violation_types:
                violations.append({"k": frame["scan"], "name": name})
        axes = {axis: dict(actual=value["position"], velocity=value["velocity"],
                           target=frame["outputs"].get(f"{axis}_target", round(value["position"] * 100)) / 100,
                           unit="mm") for axis, value in state["axes"].items()}
        motion = {
            "mode": "dependency", "axes": axes, "requests": [],
            "shared": {"contract_revision": 18, "local_dwell_ms": 0,
                       "evaluation_complete": int(frame is frames[-1]),
                       "task_success": int(bool(result["task_success"])),
                       "safety_violation": int(bool(result["safety_violation"])),
                       "interlock": state["interlock_reason"]},
            "routes": [], "poses": geometry["poses"], "mechanisms": {},
            "dependency": geometry["geometry"],
            "result_asserted": state["result"], "result_age_ms": state["hold_ms"],
            "success": bool(result["task_success"] and not result["safety_violation"]
                            and frame is frames[-1]),
            "violations": [event for event in events if event in violation_types],
            "available": state["time_ms"] >= 30,
        }
        converted.append({
            "k": frame["scan"], "time_ms": state["time_ms"],
            "x": {key: int(value) for key, value in memory.items() if key.startswith("X")},
            "y": {key: int(value) for key, value in memory.items() if key.startswith("Y")},
            "words": {key: value for key, value in memory.items() if key.startswith("D")},
            "s": {"CELL": 0}, "v": int(not state["geometry_safe"]),
            "world": {"devices": {}, "parts": {}, "events": events, "motion_hard": motion},
        })
    return {
        "label": label, "category": category, "frames": converted,
        "il": program, "viol": violations,
        "goal": result["task_success"],
        "verdict": "PASS" if result["task_success"] and not result["safety_violation"] else "FAIL",
        "reason": result.get("stop_reason") or "final evaluator result", "model": model,
    }


def adapt_run(frames: list, result: dict, layout: dict, *, label: str,
              category: str, model: str, program: str = "", scenario: int = 0) -> dict:
    task_id = layout["task"]
    axis_devices = DEVICE_AXES[task_id]
    if not set(axis_devices).issubset({device["id"] for device in layout["devices"]}):
        raise ValueError(f"Missing moving axis device in {task_id}")
    converted = []
    mobile_mechanisms = replay_mobile_mechanisms(frames, scenario) if task_id == MOBILE_TASK else {}
    violations = []
    seen_violations = set()
    for frame in frames:
        plant = frame["plant"]
        motion_state = plant["motion_medium"] if task_id in MEDIUM_AXIS_TASKS else plant["motion_easy_unit"]
        axes = motion_state["axes"]
        events = [event["type"] if isinstance(event, dict) else str(event)
                  for event in frame.get("events", [])]
        for violation in plant.get("violations", []):
            name = violation["type"] if isinstance(violation, dict) else str(violation)
            if name not in seen_violations:
                seen_violations.add(name)
                violations.append({"k": frame["scan"], "name": name})
        bits = frame.get("plc", {}).get("bits", {})
        poses = {device["id"]: {"pos": device["pos"][:]} for device in layout["devices"]}
        if task_id in MEDIUM_ASSEMBLY:
            poses = project_medium_assembly(task_id, axes)
        for name, model_spec in layout.get("dynamic_accessories_x", {}).items():
            poses[name]["pos"][0] = model_spec["offset"] + model_spec["scale"] * axes[model_spec["axis"]]["actual"]
        states = {device["id"]: axes[axis_devices[device["id"]]]["position"]
                  if device["id"] in axis_devices else 0 for device in layout["devices"]}
        if task_id == "MOT-E06":
            states["BRAKE"] = int(bool(plant["brake"]))
        if task_id in PROJECTED_MECHANISMS:
            motion_state = {**motion_state, "mechanism": project_mechanism(task_id, axes, frame["scan"], scenario)}
        elif task_id == MOBILE_TASK:
            motion_state = {**motion_state, "mechanism": mobile_mechanisms[frame["scan"]]}
        elif task_id in MEDIUM_PROJECTED:
            motion_state = {**motion_state, "mechanism": project_medium_mechanism(
                task_id, motion_state, frame["scan"], scenario)}
        converted.append({
            "k": frame["scan"],
            "x": {key: value for key, value in frame["input_image"].items() if key.startswith("X")},
            "y": {key: value for key, value in bits.items() if key.startswith("Y")},
            "s": states,
            "v": int(bool(plant.get("violations"))),
            "words": frame.get("plc", {}).get("words", {}),
            "world": {
                "devices": poses,
                "parts": {},
                "events": events,
                **({"motion_medium": motion_state} if task_id in MEDIUM_AXIS_TASKS
                   else {"motion_easy_unit": motion_state}),
            },
        })
    return {
        "label": label, "category": category,
        "frames": converted, "il": program, "viol": violations,
        "goal": result["task_success"],
        "verdict": "PASS" if result["task_success"] and not result["safety_violation"] else "FAIL",
        "reason": result.get("stop_reason") or "final evaluator result",
        "model": model,
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=ROOT / "replay/viewer/catalog.json")
    parser.add_argument("--generated-run-id", required=True, help="Convert only this generated run using its bundled task layout")
    parser.add_argument("--generated-root", type=Path, default=ROOT / "outputs/generated")
    args = parser.parse_args()
    protect_historical_output(ROOT, args.output)

    if args.generated_run_id and (not args.generated_run_id.isascii()
                                  or not all(char.islower() or char.isdigit() or char == "-"
                                             for char in args.generated_run_id)):
        parser.error("Invalid generated run ID")
    selected_task = None
    if args.generated_run_id:
        selected_run = args.generated_root / args.generated_run_id / "run.json"
        if not selected_run.is_file():
            raise SystemExit(f"Generated run not found: {selected_run}")
        selected_task = read_json(selected_run).get("task")
    if args.generated_run_id:
        catalog = read_json(ROOT / "replay/viewer/catalog.json")
        catalog_id = MATERIAL_CATALOG_IDS.get(selected_task, selected_task)
        if catalog_id not in catalog["tasks"]:
            raise SystemExit("Generated task has no bundled device layout")
        # Reuse only the selected task geometry; no archived sample is loaded.
        selected_layout = {key: value for key, value in catalog["tasks"][catalog_id].items()
                           if key not in ("runs", "replay_deferred")}
        tasks = {catalog_id: {**selected_layout, "runs": {}}}
    else:
        source_dir = ROOT / "replay/traces/fixtures" / TASK
        source = read_json(source_dir / "manifest.json")
        seal = read_json(ROOT / "artifact.json")["evaluator_seal_sha256"]
        if source["task"] != TASK or source["evaluator_seal_sha256"] not in trusted_evaluator_seals(ROOT):
            raise SystemExit("Source task or evaluator seal mismatch")
        trace_file = source_dir / source["trace_file"]
        compressed = trace_file.read_bytes()
        raw = gzip.decompress(compressed)
        if sha256(compressed) != source["trace_gzip_sha256"] or sha256(raw) != source["trace_sha256"]:
            raise SystemExit("Source trace hash mismatch")
        frames = json.loads(raw)
        if not frames or any(frame["scan"] != index for index, frame in enumerate(frames)):
            raise SystemExit("Source scans are not contiguous")

        result = read_json(source_dir / f"{TASK}.case-{source['scenario']:02}.json")
        if (result["integration_seal_sha256"] != source["evaluator_seal_sha256"]
                or result["trace_sha256"] != source["trace_sha256"]
                or result["task_success"] != source["task_success"]
                or result["safety_violation"] != source["safety_violation"]):
            raise SystemExit("Source result mismatch")
        program = ROOT / "submissions" / source["model"] / f"repeat-{source['repeat']:02}" / f"{TASK}.st"
        if sha256(program.read_bytes()) != source["program_sha256"]:
            raise SystemExit("Preserved ST hash mismatch")

        layout = read_json(ROOT / "replay/traces/fixtures/MOT-E01/layout.json")
        spec = (ROOT / "inputs/tasks/motion/easy/MOT-E01/st-generation.user.md").read_text(encoding="utf-8")
        task = {**layout,
                "req": objective_only(spec),
                "provenance": "PLCWorld final evaluator trace; original renderer geometry",
                "evaluation_release": "plcworld-evaluation/5.2.6"}
        task["runs"] = {
            "Reference · condition 0": reference_run(TASK, layout, seal),
            "Paper sample · gpt-5.5 repeat 1 · condition 0": adapt_run(
                frames, result, layout, label="Paper sample · gpt-5.5 repeat 1 · condition 0",
                category="paper-sample", model=source["model"], program=program.read_text(encoding="utf-8")),
        }
        sidecar_dir = args.output.parent / "tasks"
        sidecars = {}
        presentation_dir = args.output.parent / "presentation"
        presentations = {}

        def stage_task(task_id: str, full: dict) -> dict:
            if args.generated_run_id:
                return full
            if task_id in MATERIAL_HARD_TASKS and task_id not in {"MAT-H01", "MAT-H07"}:
                name, run = next(iter(full["runs"].items()))
                contacts = [frame["world"]["material_hard"].pop("contact") for frame in run["frames"]]
                inventory = contacts[0].pop("inventory")
                points = [device["pos"] for device in full["devices"]]
                points.extend(pose["pos"] for contact in contacts for pose in contact["poses"].values())
                xs, zs = [p[0] for p in points], [p[2] for p in points]
                bounds = {"x": (min(xs) + max(xs)) / 2, "z": (min(zs) + max(zs)) / 2,
                          "width": max(xs) - min(xs) + 2, "depth": max(zs) - min(zs) + 2}
                payload = {"label": name, "inventory": inventory, "bounds": bounds, "frames": contacts}
                presentation_dir.mkdir(parents=True, exist_ok=True)
                asset = gzip.compress(json.dumps(payload, separators=(",", ":")).encode(), mtime=0)
                (presentation_dir / f"{task_id}.json.gz").write_bytes(asset)
                source = f"replay/traces/reference/{task_id}/case-00.frames.json.gz"
                presentations[task_id] = {"source": source, "source_sha256": sha256((ROOT / source).read_bytes()),
                                          "asset_sha256": sha256(asset), "scans": len(contacts), "label": name}
            sidecar_dir.mkdir(parents=True, exist_ok=True)
            data = (json.dumps(full, ensure_ascii=False, separators=(",", ":")) + "\n").encode("utf-8")
            filename = task_id + ".json.gz"
            compressed = gzip.compress(data, compresslevel=6, mtime=0)
            (sidecar_dir / filename).write_bytes(compressed)
            sidecars[task_id] = {"file": filename, "sha256": sha256(compressed),
                                 "raw_sha256": sha256(data),
                                 "frames": len(next(iter(full["runs"].values()))["frames"])}
            return {**full, "replay_deferred": True,
                    "runs": {name: {**run, "frames": run["frames"][:1]}
                             for name, run in full["runs"].items()}}

        tasks = {TASK: task}
        public_layouts = read_json(ROOT / "replay/layouts/public-site-layouts.json")["tasks"]
        for task_id in PUBLIC_GEOMETRY_TASKS:
            if selected_task and task_id != selected_task:
                continue
            spec = (model_input_dir(ROOT, task_id) / "st-generation.user.md").read_text(encoding="utf-8")
            title = spec.splitlines()[0].split("—", 1)[1].strip()
            objective = objective_only(spec)
            axis_layout = copy.deepcopy(public_layouts[task_id])
            axis_layout["task"] = task_id
            reference_frames = json.loads(gzip.decompress(
                (ROOT / "replay/traces/reference" / task_id / "case-00.frames.json.gz").read_bytes()))
            function_id = reference_frames[0]["plant"]["motion_easy_unit"]["function_id"]
            axis_layout.update({
                "task": task_id, "title": title,
                "aim": objective.splitlines()[-1].removeprefix("- "),
                "suite": "motion", "difficulty": "easy", "family": "motion_easy_unit",
                "function_id": function_id, "parent_medium": layout["parent_medium"],
                "task_version": layout["task_version"], "completion_output": "Y2",
                "io": task_io(spec), "observed": list(task_io(spec)),
                "req": objective,
                "provenance": "PLCWorld final evaluator reference trace; public-site original renderer geometry snapshot",
                "evaluation_release": "plcworld-evaluation/5.2.6",
            })
            axis_layout["runs"] = {"Reference · condition 0": reference_run(task_id, axis_layout, seal)}
            tasks[task_id] = axis_layout
        for task_id in MEDIUM_AXIS_TASKS:
            if selected_task and task_id != selected_task:
                continue
            spec = (model_input_dir(ROOT, task_id) / "st-generation.user.md").read_text(encoding="utf-8")
            title = spec.splitlines()[0].split("—", 1)[1].strip()
            objective = objective_only(spec)
            axis_layout = copy.deepcopy(public_layouts[task_id])
            axis_layout.update({
                "task": task_id, "title": title,
                "aim": objective.splitlines()[-1].removeprefix("- "),
                "suite": "motion", "difficulty": "medium", "family": "motion_medium_core",
                "parent_medium": layout["parent_medium"],
                "task_version": layout["task_version"], "completion_output": "Y2",
                "io": task_io(spec), "observed": list(task_io(spec)),
                "req": objective,
                "provenance": "PLCWorld final evaluator reference trace; public-site original renderer geometry snapshot",
                "evaluation_release": "plcworld-evaluation/5.2.6",
            })
            axis_layout["runs"] = {"Reference · condition 0": reference_run(task_id, axis_layout, seal)}
            tasks[task_id] = axis_layout
        for task_id in PRIORITY_GEOMETRY_TASKS:
            if selected_task and task_id != selected_task:
                continue
            spec = (model_input_dir(ROOT, task_id) / "st-generation.user.md").read_text(encoding="utf-8")
            objective = objective_only(spec)
            priority_layout = copy.deepcopy(public_layouts[task_id])
            priority_layout.update({
                "task": task_id, "title": spec.splitlines()[0].split("—", 1)[1].strip(),
                "aim": objective.splitlines()[-1].removeprefix("- "),
                "suite": "motion", "difficulty": "medium", "family": "motion_hard15",
                "task_version": "priority-redesign/1" if task_id == "MOT-M02" else "priority-redesign/1.1",
                "visual_revision": "priority-redesign/1" if task_id == "MOT-M02" else "priority-redesign/1-m12-mechanical-r2",
                "completion_output": "Y2", "io": task_io(spec), "observed": list(task_io(spec)),
                "req": objective,
                "provenance": "PLCWorld final evaluator reference trace; original mechanical geometry projection",
                "evaluation_release": "plcworld-evaluation/5.2.6",
            })
            priority_layout["runs"] = {"Reference · condition 0": reference_run(task_id, priority_layout, seal)}
            tasks[task_id] = priority_layout
        for task_id in GROUNDED_GEOMETRY_TASKS:
            if selected_task and task_id != selected_task:
                continue
            spec = (model_input_dir(ROOT, task_id) / "st-generation.user.md").read_text(encoding="utf-8")
            objective = objective_only(spec)
            grounded_layout = copy.deepcopy(public_layouts[task_id])
            grounded_layout.update({
                "task": task_id, "title": spec.splitlines()[0].split("—", 1)[1].strip(),
                "aim": objective.splitlines()[-1].removeprefix("- "),
                "suite": "motion", "difficulty": "medium", "family": "motion_hard15",
                "task_version": "motion-medium-grounded-v6", "evaluation_status": "admitted",
                "completion_output": "Y2", "io": task_io(spec), "observed": list(task_io(spec)),
                "req": objective,
                "provenance": "PLCWorld final evaluator trace; original grounded mechanical geometry projection",
                "evaluation_release": "plcworld-evaluation/5.2.6",
            })
            grounded_layout["runs"] = {"Reference · condition 0": reference_run(task_id, grounded_layout, seal)}
            tasks[task_id] = stage_task(task_id, grounded_layout)
        for task_id in HARD_BATCH_TASKS:
            if selected_task and task_id != selected_task:
                continue
            spec = (model_input_dir(ROOT, task_id) / "st-generation.user.md").read_text(encoding="utf-8")
            objective = objective_only(spec)
            hard_layout = copy.deepcopy(public_layouts[task_id])
            hard_layout.update({
                "task": task_id, "title": spec.splitlines()[0].split("—", 1)[1].strip(),
                "aim": objective.splitlines()[-1].removeprefix("- "),
                "suite": "motion", "difficulty": "hard", "family": "motion_hard15",
                "task_version": "motion-hard-final", "evaluation_status": "admitted",
                "completion_output": "Y2", "io": task_io(spec), "observed": list(task_io(spec)),
                "req": objective,
                "provenance": "PLCWorld final evaluator trace; frozen Hard plant pose projection",
                "evaluation_release": "plcworld-evaluation/5.2.6",
            })
            hard_layout["runs"] = {"Reference · condition 0": reference_run(task_id, hard_layout, seal)}
            if task_id != "MOT-H01":
                hard_layout["replay_shared_motion_layout"] = True
            tasks[task_id] = stage_task(task_id, hard_layout)
        for task_id in MATERIAL_TASKS:
            if task_id == "MAT-H07":
                if selected_task and task_id != selected_task:
                    continue
                priority = ROOT / "evaluator/priority/runtime/engine/tasks/MAT-H07"
                spec = (ROOT / "inputs/tasks/material/hard/MAT-H07/st-generation.user.md").read_text(encoding="utf-8")
                objective = objective_only(spec)
                binding = read_json(priority / "binding.json")
                material_layout = {
                    "task": task_id, "evaluation_task": task_id,
                    "title": spec.splitlines()[0].split("—", 1)[1].strip(),
                    "aim": objective.splitlines()[-1].removeprefix("- "),
                    "suite": "material", "difficulty": "hard", "family": "material_priority_wind_tape",
                    "task_version": "priority-redesign/1", "evaluation_status": "admitted",
                    "completion_output": binding["result"]["completion"],
                    "devices": [{"id": "MATERIAL_CELL", "kind": "static", "ui": "fixture",
                                 "pos": [0, 0, 0], "size": [2.4, 2.2, 2.1],
                                 "visual_variant": "cell3-priority-wind-tape",
                                 "label": "Two-web winding, core feed, tail tape, and roll dispatch"}],
                    "relations": [], "assembly_view": {"dist": 3.7, "target": [0.2, 1.0, 0.2], "front_sign": 1},
                    "io": task_io(spec), "observed": list(binding["inputs"].values()),
                    "req": objective,
                    "provenance": "PLCWorld final evaluator priority trace and recorded physical state; local 3D projection",
                    "evaluation_release": "plcworld-evaluation/5.2.6",
                }
                run = reference_run(task_id, material_layout, seal)
                material_layout["runs"] = {run["label"]: run}
                tasks[task_id] = stage_task(task_id, material_layout)
                continue
            if selected_task and task_id != selected_task:
                continue
            package = material_package(task_id)
            scene = package.scene()
            catalog_id = MATERIAL_CATALOG_IDS[task_id]
            spec = (model_input_dir(ROOT, task_id) / "st-generation.user.md").read_text(encoding="utf-8")
            objective = objective_only(spec)
            devices = scene.device_definitions()
            for device in devices:
                if any(0xAC00 <= ord(char) <= 0xD7A3 for char in device.get("sensor_purpose", "")):
                    device.pop("sensor_purpose")
            material_layout = {
                "task": catalog_id, "evaluation_task": task_id,
                "title": spec.splitlines()[0].split("—", 1)[1].strip(),
                "aim": objective.splitlines()[-1].removeprefix("- "),
                "suite": "material", "difficulty": ("easy" if task_id in MATERIAL_EASY_TASKS else
                                                     "hard" if task_id in MATERIAL_HARD_TASKS else "medium"),
                "family": package.task["family_id"], "task_version": package.task["task_version"],
                "evaluation_status": "admitted", "completion_output": package.binding["result"]["completion"],
                "devices": devices, "relations": scene.relations(),
                "assembly_view": package.plant["scene"].get("assembly_view", {"dist": 3.5, "target": [0, 0.8, 0], "front_sign": 1}),
                "io": task_io(spec), "observed": scene.observed(), "req": objective,
                "provenance": "PLCWorld final evaluator trace and sealed PlantSpec 3D scene",
                "evaluation_release": "plcworld-evaluation/5.2.6",
            }
            material_run = reference_run(task_id, material_layout, seal)
            material_layout["runs"] = {material_run["label"]: material_run}
            tasks[catalog_id] = stage_task(catalog_id, material_layout)
        tasks = dict(sorted(tasks.items()))
    run_files = ([args.generated_root / args.generated_run_id / "run.json"]
                 if args.generated_run_id else sorted(args.generated_root.glob("*/run.json")))
    for run_file in run_files:
        if not run_file.is_file():
            raise SystemExit(f"Generated run not found: {run_file}")
        run = read_json(run_file)
        task_id = run.get("task")
        catalog_id = MATERIAL_CATALOG_IDS.get(task_id, task_id)
        if (catalog_id not in tasks or run.get("status") != "evaluated"
                or run.get("evaluator_seal_sha256") not in trusted_evaluator_seals(ROOT)):
            if args.generated_run_id:
                raise SystemExit(f"Generated run is not an evaluated, supported 3D task: {run_file}")
            continue
        generated = run_file.parent
        st = (generated / "submission.st").read_bytes()
        if sha256(st) != run["st_sha256"]:
            raise SystemExit(f"Generated ST hash mismatch: {generated.name}")
        generated_count = 0
        for case in run["results"]:
            if case.get("replay_available") is False:
                continue
            index = case["scenario"]
            case_result = read_json(generated / "evaluation" / f"case-{index:02}.json")
            case_trace = (generated / "evaluation" / f"case-{index:02}.frames.json.gz").read_bytes()
            if (case_result["task"] != task_id
                    or case_result["scenario_index"] != index
                    or case_result["integration_seal_sha256"] != run["evaluator_seal_sha256"]
                    or case_result["st_sha256"] != run["st_sha256"]
                    or sha256(gzip.decompress(case_trace)) != case_result["trace_sha256"]):
                raise SystemExit(f"Generated trace provenance mismatch: {generated.name}, condition {index}")
            case_frames = json.loads(gzip.decompress(case_trace))
            if not case_frames:
                continue
            name = f"My runs · {generated.name} · condition {index}"
            label = f"{run['model']} · {run['created_utc']} · condition {index}"
            converter = (adapt_priority_material_run if task_id == "MAT-H07" else
                         adapt_material_run if task_id in MATERIAL_TASKS else
                         adapt_hard_run if task_id in HARD_BATCH_TASKS else
                         adapt_priority_run if task_id in PRIORITY_GEOMETRY_TASKS else
                         adapt_grounded_run if task_id in GROUNDED_GEOMETRY_TASKS else adapt_run)
            tasks[catalog_id]["runs"][name] = converter(
                case_frames, case_result, tasks[catalog_id],
                label=label, category="my-runs", model=run["model"],
                program=st.decode("utf-8"), scenario=index)
            generated_count += 1
        if args.generated_run_id and generated_count == 0:
            raise SystemExit("Generated run has no replayable scan frames")
    if args.generated_run_id:
        generated_runs = {name: value for name, value in tasks[catalog_id]["runs"].items()
                          if name.startswith(f"My runs · {args.generated_run_id} ·")}
        catalog_tasks = {catalog_id: {"runs": generated_runs}}
    else:
        sidecar_dir.mkdir(parents=True, exist_ok=True)
        (sidecar_dir / "manifest.json").write_text(
            json.dumps({"schema": "plcworld-original-3d-sidecars/1", "tasks": sidecars}, indent=2) + "\n",
            encoding="utf-8")
        (presentation_dir / "manifest.json").write_text(json.dumps({
            "schema": "recorded-contact-presentation/1", "tasks": presentations,
            "projection_sha256": sha256((ROOT / "scripts/material_contact_projection.py").read_bytes()),
        }, indent=2) + "\n", encoding="utf-8")
        catalog_tasks = tasks
    bundle = {
        "schema_version": "canonical-replay-trace/0.2",
        "contains_enterprise_data": False,
        "scan_ms": 10,
        "tasks": catalog_tasks,
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(bundle, ensure_ascii=False, separators=(",", ":")) + "\n", encoding="utf-8")
    if args.generated_run_id:
        from replay_run_index import write_index
        write_index(args.output, bundle)
    print(f"Adapted {len(catalog_tasks)} tasks using final evaluator traces and original renderer geometry")


if __name__ == "__main__":
    main()
