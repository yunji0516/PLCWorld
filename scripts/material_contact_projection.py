"""Presentation-only projection of final recorded Material Hard mechanics.

Coordinates come from recorded physical state or sealed station anchors. Mesh
dimensions are schematic presentation geometry, not additional simulator state.
No commands are executed and no success/safety fields are recalculated.
"""
from __future__ import annotations

import math


def project(plant: dict, devices: list[dict]) -> dict:
    physical = plant.get("physical", {})
    anchors = {d["id"].lower(): d["pos"] for d in devices if d["id"] != "MATERIAL_CELL"}
    poses = {}

    def pose(name, position, kind="tool", yaw=0, size=None):
        if isinstance(position, (tuple, list)) and len(position) == 3:
            if all(isinstance(x, (int, float)) and math.isfinite(x) for x in position):
                poses[name] = {"pos": list(position), "kind": kind, "yaw": yaw}
                if size:
                    poses[name]["size"] = size

    for key in ("head", "shuttle_xyz", "grip_xyz", "tool"):
        pose(key, physical.get(key))
    for key, value in physical.get("tools", {}).items():
        pose("tool_" + key, value)
    if "cart_x" in physical:
        pose("cart", [physical["cart_x"], anchors.get("deck", [0, .85, 0])[1], 0], "deck")
    if "angle" in physical:
        pose("cradle" if "cradle" in anchors else "table", anchors.get("table", anchors.get("cradle", [0, .85, 0])),
             "cradle" if "cradle" in anchors else "table", physical["angle"])
    if isinstance(physical.get("cart"), (int, float)):
        anchor = anchors.get("pouch", [0, .9, 0])
        pose("cart", [physical["cart"], anchor[1], anchor[2]], "deck")
    if "dancer_y" in physical:
        anchor = anchors.get("dancer", [0, .5, 0])
        pose("dancer", [anchor[0], physical["dancer_y"], anchor[2]], "roller")
    for side, nozzle in physical.get("nozzles", {}).items():
        anchor = anchors.get("nozzle_" + side)
        if anchor:
            pose("nozzle_" + side, [anchor[0], anchor[1] - nozzle, anchor[2]])
    for key, lift in physical.get("lifts", {}).items():
        anchor = anchors.get(key, anchors.get("lift_" + key))
        if anchor and isinstance(lift, dict) and "y" in lift:
            pose("lift_" + key, [anchor[0], lift["y"], anchor[2]], "deck")
    for key, carriage in physical.get("carriages", {}).items():
        pose("carriage_" + key, [carriage["x"], carriage["top"], carriage["z"]], "deck")
    fork = physical.get("fork", {})
    pose("fork", fork.get("pos"), "fork")
    capper = physical.get("capper", {})
    if "x" in capper:
        anchor = anchors.get("capper", [0, 1.45, -1])
        pose("capper", [capper["x"], anchor[1], anchor[2]])
    for side, z in physical.get("tool_z", {}).items():
        anchor = anchors.get("tool_" + side, anchors.get("press_" + side, anchors.get(side, [0, 1.4, 0])))
        pose("stroke_" + side, [anchor[0], anchor[1] - physical.get("stroke", {}).get(side, 0), z])
    extension = physical.get("extension", {})
    if "bin_x" in physical:
        anchor = anchors.get("bin", [0, .3, .65])
        pose("scrap_bin", [physical["bin_x"], anchor[1], anchor[2]], "box", size=[.6,.35,.5])
    for key in ("head", "grip_xyz"):
        pose("extension_" + key, extension.get(key))
    for key in ("boxes", "rolls", "pallets"):
        for item in extension.get(key, []):
            position = item.get("pos") or ([item[axis] for axis in ("x", "y", "z")] if all(axis in item for axis in ("x", "y", "z")) else None)
            pose(f"{key}_{item.get('id', len(poses))}", position, "reel" if key == "rolls" else "pallet" if key == "pallets" else "box", size=item.get("size"))
    reel = physical.get("reel", {})
    radius = reel.get("radius", physical.get("reel_radius"))
    if radius is not None:
        pose("active_reel", anchors.get("reel", [-1.2, .8, 0]), "reel", size=[radius, radius, .18])
    # Keep the recorded polyline, including dancer contact. Do not reconstruct a
    # web trajectory using the older public-site task definitions.
    web = reel.get("path") or physical.get("web_path") or []
    lanes = []
    stops = []
    for name, lane in physical.get("transport", {}).items():
        axis = lane.get("axis")
        if axis not in ("x", "z"):
            continue
        points = []
        for stop in lane.get("stops", []):
            if "face" not in stop or "cross" not in stop:
                continue
            point = [stop["face"], .85, stop["cross"]] if axis == "x" else [stop["cross"], .85, stop["face"]]
            points.append(point)
            stops.append({"id": name + ":" + stop["id"], "pos": point, "closed": stop["closed"], "axis": axis})
        for clamp in lane.get("clamps", []):
            p = clamp.get("position", {})
            if all(k in p for k in ("x", "y", "z")):
                points.append([p["x"], p["y"] - .075, p["z"]])
        anchor = anchors.get(name, anchors.get(name.replace("input_", "")))
        if anchor:
            points.append(anchor)
        for key in lane.get("bodies", {}):
            part = plant.get("material_hard", {}).get("parts", {}).get(str(key), {})
            if all(k in part for k in ("x", "y", "z")):
                points.append([part["x"], part["y"] - part.get("size", [.2,.1,.2])[1] / 2, part["z"]])
        pusher = lane.get("pusher", {})
        if pusher.get("origin"):
            origin = list(pusher["origin"])
            offset = pusher.get("offset", 0)
            origin[0 if axis == "x" else 2] += offset
            pose("pusher_" + name, origin, "deck")
        if len(points) >= 2:
            index = 0 if axis == "x" else 2
            a, b = min(points, key=lambda p: p[index]), max(points, key=lambda p: p[index])
            if b[index] - a[index] > .05:
                lanes.append({"id": name, "a": a, "b": b})
    return {"schema": "recorded-contact-geometry/1", "poses": poses, "lanes": lanes, "stops": stops, "web_path": web}
