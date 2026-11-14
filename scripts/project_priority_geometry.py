"""Visual-only reconstruction of the admitted rail-transfer and jig scenes.

The dimensions and equations match the original priority-redesign geometry;
this module does not simulate PLC commands or change evaluator state.
"""

from __future__ import annotations

from math import atan2, cos, hypot, sin


STEEL = "#83949b"
FRAME = "#384f5a"
DRIVE = "#407e88"
LIGHT = "#d3dcdf"
DARK = "#394c55"


def rail_transfer_geometry(state: dict) -> dict:
    """Project MOT-M02 recorded plant state into the original 3D dimensions."""
    parts = []

    def box(name, position, size, color=STEEL, style="plate", shape="box", axis="y"):
        parts.append(dict(name=name, pos=position, size=size, color=color,
                          shape=shape, axis=axis, style=style))

    def cylinder(name, position, radius, length, axis="y", color=STEEL):
        size = [2 * radius] * 3
        size["xyz".index(axis)] = length
        box(name, position, size, color, "motor" if color == DRIVE else "rail", "cylinder", axis)

    def base(x, z, width, depth, top):
        box("Machine base", [x, top - .06, z], [width, .12, depth], FRAME, "base")
        for i, xx in enumerate((x - width / 2 + .08, x + width / 2 - .08)):
            for j, zz in enumerate((z - depth / 2 + .08, z + depth / 2 - .08)):
                box(f"Support frame {i}{j}", [xx, (top - .12) / 2, zz],
                    [.06, top - .12, .06], FRAME, "base")
                box(f"Leveling foot {i}{j}", [xx, .025, zz], [.13, .05, .13], DARK, "base")

    positions = {axis: value["position"] for axis, value in state["axes"].items()}
    scale = .003
    left = positions["a"] * scale
    right = positions["b"] * scale
    dock = state["setup"]["request"]["dock"] * scale
    base(.65, 1.35, 1.9, 3.1, .75)
    for z in (0, 1.8):
        box(f"Longitudinal rail {z}", [.75, .84, z], [1.65, .06, .065], STEEL, "rail")
        cylinder(f"Beam travel motor {z}", [-.15, .84, z], .07, .15, "x", DRIVE)
    for side, (xx, z) in enumerate(((left, 0), (right, 1.8))):
        box(f"End carriage {side}", [xx, .91, z], [.18, .08, .18], DRIVE, "carriage")
        box(f"Encoder {side}", [xx + .1, .93, z], [.045, .035, .045], DARK, "sensor")
    angle = atan2(right - left, 1.8)
    parts.append(dict(name="Moving beam", pos=[0, 0, 0],
                      size=[.085, .12, hypot(right - left, 1.8)], color=LIGHT,
                      shape="box", style="rail", node="bridge"))
    box("Fixed service rail", [dock, 1.01, 2.325], [.085, .12, 1.05], LIGHT, "rail")
    box("Fixed rail wheel flange", [dock, 1.07, 2.325], [.18, .012, 1.05], STEEL, "rail")
    parts.append(dict(name="Moving rail wheel flange", pos=[0, .06, 0],
                      size=[.18, .012, 1.8], color=STEEL, shape="box", style="rail", node="bridge"))
    for z in (2.1, 2.75):
        box(f"Fixed rail column {z}", [dock + .19, .9, z], [.065, .3, .075], FRAME)
        box(f"Fixed rail bracket {z}", [dock + .09, .975, z], [.25, .05, .09], STEEL)
    trolley_x, trolley_z = (value * scale for value in state["trolley_world"])
    box("Empty cart", [trolley_x, 1.23, trolley_z], [.20, .12, .36], DRIVE, "carriage")
    for side in (-1, 1):
        for wheel in (-1, 1):
            cylinder(f"Cart wheel {side} {wheel}",
                     [trolley_x + side * .066, 1.118, trolley_z + wheel * .12],
                     .042, .035, "x", DARK)
    for wheel in (-1, 1):
        cylinder(f"Wheel axle {wheel}", [trolley_x, 1.118, trolley_z + wheel * .12], .012, .18, "x")
        for side in (-1, 1):
            box(f"Cart wheel bearing {wheel} {side}",
                [trolley_x + side * .066, 1.158, trolley_z + wheel * .12],
                [.03, .082, .055], STEEL, "carriage")
    cylinder("Cart drive", [trolley_x + .15, 1.23, trolley_z], .05, .1, "x", DRIVE)
    box("Latch cylinder", [dock + .19, 1.04, 1.8], [.16, .075, .075], DRIVE, "actuator")
    box("Coupling pin", [dock + .11 - .10 * state["latch"], 1.04, 1.8], [.12, .026, .028], STEEL, "rail")
    for index, z in enumerate((1.78, 1.82)):
        box(f"End stop {index}", [right if index == 0 else dock, 1.07 - .07 * state["latch"], z],
            [.12, .09, .018], DARK)
    box("Fixed-side exit detector", [dock + .14, 1.11, 1.98], [.05, .05, .04], DRIVE, "sensor")
    poses = {"bridge": dict(pos=[(left + right) / 2, 1.01, .9],
                            quaternion=[0, sin(angle / 2), 0, cos(angle / 2)], scale=[1, 1, 1])}
    labels = {"a": "A left beam travel", "b": "B right beam travel", "c": "C empty-cart travel"}
    sensor_labels = {"latch_open": "Latch open", "latch_engaged": "Latch engaged",
                     "fully_fixed": "Cart fully on fixed rail", "joint_aligned": "Joint aligned"}
    result_labels = {"rail_connected": "Rails connected", "trolley_cleared": "Cart support transferred",
                     "result_asserted": "Completion asserted"}
    coupling = {
        "purpose": "Transfer the cart over connected rails, then return the empty beam",
        "states": [dict(id=key, label=sensor_labels.get(key, key),
                        value="Detected" if value else "Not detected",
                        status="ready" if value else "waiting")
                   for key, value in state["sensors"].items() if key in sensor_labels],
        "results": [dict(id=key, label=result_labels.get(key, key),
                         value=f"{value:.0f} ms", status="recorded")
                    for key, value in state["history"].items() if key != "request_available"],
    }
    geometry = dict(version="motion-grounded-geometry/4.1", task_number=2,
                    axis_labels=labels, local_dwell_required=False, coupling=coupling,
                    parts=parts, protected_pairs=[], source="priority-redesign/1")
    return {"geometry": geometry, "poses": poses}


def jig_approach_geometry(state: dict) -> dict:
    """Project MOT-M12's nested X1/X2/Z and moving jig from recorded axes."""
    parts = []

    def box(name, position, size, color=STEEL, style="plate", shape="box", axis="y"):
        parts.append(dict(name=name, pos=position, size=size, color=color,
                          shape=shape, axis=axis, style=style))

    def cylinder(name, position, radius, length, axis="y", color=STEEL):
        size = [2 * radius] * 3
        size["xyz".index(axis)] = length
        box(name, position, size, color, "motor" if color == DRIVE else "rail", "cylinder", axis)

    box("Machine base", [.04, .54, .04], [2.25, .12, 1.35], FRAME, "base")
    for i, xx in enumerate((.04 - 2.25 / 2 + .08, .04 + 2.25 / 2 - .08)):
        for j, zz in enumerate((.04 - 1.35 / 2 + .08, .04 + 1.35 / 2 - .08)):
            box(f"Support frame {i}{j}", [xx, (.60 - .12) / 2, zz], [.06, .48, .06], FRAME, "base")
            box(f"Leveling foot {i}{j}", [xx, .025, zz], [.13, .05, .13], DARK, "base")

    positions = {axis: value["position"] for axis, value in state["axes"].items()}
    a, b, z = (positions[key] * .004 for key in "abc")
    jig = (positions["d"] - 100) * .004
    combined_x = a + b
    for xx in (-.60, .60):
        box(f"Upper frame column {xx}", [xx, 1.10, .50], [.085, 1.0, .10], FRAME, "base")
        box(f"Column anchoring foot {xx}", [xx, .62, .50], [.18, .04, .18])
    box("Upper fixed beam", [0, 1.56, .50], [1.36, .08, .10], FRAME, "base")
    for xx in (-.30, .25):
        box(f"X1 fixed support arm {xx}", [xx, 1.56, .36], [.09, .08, .28])
    box("X1 fixed mounting plate", [-.02, 1.53, .23], [.74, .04, .34], LIGHT)
    for zz in (.12, .32):
        box(f"X1 fixed guide {zz}", [.05, 1.498, zz], [.46, .024, .032], STEEL, "rail")
        for offset in (-.06, .06):
            box(f"X1 linear bearing {zz} {offset}", [a - .04 + offset, 1.481, zz],
                [.075, .038, .058], DRIVE, "carriage")
    box("X1 carriage", [a - .04, 1.445, .22], [.25, .034, .35], LIGHT, "carriage")
    box("X1 cylinder", [-.24, 1.49, .22], [.22, .04, .055], DRIVE, "actuator")
    for xx in (-.35, -.13):
        box(f"X1 cylinder end cap {xx}", [xx, 1.49, .22], [.018, .04, .065])
    cylinder("X1 rod", [(a - .17) / 2, 1.49, .22], .007, .09 + a, "x")
    box("X1 rod coupling", [a - .04, 1.473, .22], [.03, .055, .05])
    for offset in (-.10, .055):
        box(f"Serial coupling bracket {offset}", [a + offset, 1.415, .22], [.07, .026, .31])
    box("X2 mounting beam", [a - .03, 1.389, .22], [1.78, .026, .38], LIGHT)
    box("X2 cylinder", [a - .47, 1.325, .07], [.80, .09, .085], DRIVE, "actuator")
    for offset in (-.85, -.09):
        box(f"X2 body clamp {offset}", [a + offset, 1.373, .07], [.06, .006, .10])
    for offset in (-.87, -.065):
        box(f"X2 cylinder end cap {offset}", [a + offset, 1.325, .07], [.03, .10, .105])
    cylinder("X2 cylinder rod", [a + (b - .05) / 2, 1.325, .07], .0105, b + .05, "x")
    box("X2 rod coupling", [combined_x, 1.312, .07], [.03, .076, .05])
    for zz in (.22, .35):
        box(f"X2 guide support {zz}", [a + .37, 1.364, zz], [.96, .024, .05])
        box(f"X2 guide {zz}", [a + .37, 1.337, zz], [.96, .030, .035], STEEL, "rail")
        box(f"X2 linear bearing {zz}", [combined_x, 1.313, zz], [.11, .04, .065], DRIVE, "carriage")
    box("X2 carriage", [combined_x, 1.274, .17], [.18, .038, .45], LIGHT, "carriage")
    box("Z electric actuator", [combined_x, 1.165, 0], [.09, .18, .09], DRIVE, "actuator")
    box("Z lower bushing", [combined_x, 1.082, 0], [.09, .014, .09])
    cylinder("Z rod", [combined_x, 1.0575 - z / 2, 0], .009, .035 + z)
    for zz in (-.017, .017):
        cylinder(f"Z anti-rotation guide {zz}", [combined_x, 1.0575 - z / 2, zz], .004, .035 + z)
    box("Empty approach head", [combined_x, 1.0 - z, 0], [.048, .08, .048], LIGHT)
    for name, xx, yy, zz in (("X1 home", -.04, 1.49, .27), ("X1 end", .12, 1.49, .27),
                              ("X2 home", a, 1.337, .39), ("X2 end", a + .72, 1.337, .39)):
        box(f"{name} sensor bracket", [xx, yy + .022, zz], [.040, .034, .035])
        box(f"{name} limit sensor", [xx, yy, zz], [.026, .027, .018], DARK, "sensor")
    box("Jig axis fixed base", [.16, .613, -.20], [.30, .026, .70], STEEL, "base")
    for sign in (-1, 1):
        xx = .16 + sign * .09
        box(f"Jig transfer rail {sign}", [xx, .63, -.19], [.025, .025, .68], STEEL, "rail")
        for offset in (-.043, .043):
            box(f"Jig linear bearing {sign} {offset}", [xx, .6525, jig + offset],
                [.050, .04, .075], DRIVE, "carriage")
    cylinder("Jig transfer ballscrew", [.16, .66, -.19], .009, .66, "z")
    box("Jig ball nut", [.16, .664, jig], [.045, .029, .055], STEEL, "carriage")
    cylinder("Jig drive", [.16, .66, -.61], .045, .12, "z", DRIVE)
    box("Jig motor mount", [.16, .635, -.54], [.14, .07, .035])
    cylinder("Jig drive coupling", [.16, .66, -.535], .017, .03, "z")
    box("Jig carriage", [.16, .68625, jig], [.25, .0275, .20], LIGHT, "carriage")
    for sign in (-1, 1):
        box(f"Jig side wall {sign}", [.16 + sign * .052, .81, jig], [.008, .22, .144], LIGHT)
        box(f"Jig entry wall {sign}", [.16, .81, jig + sign * .064], [.112, .22, .016], LIGHT)
    box("Jig position sensor post", [.32, .69, 0], [.04, .18, .04])
    box("Jig mount detector", [.32, .78, 0], [.04, .025, .04], DARK, "sensor")
    box("Jig sensor target", [.2875, .74, jig], [.005, .08, .035])
    box("Long approach mark post", [.88, .795, .11], [.025, .39, .025])
    box("Long approach reference mark", [.88, .995, .11], [.06, .01, .04], DARK)

    sensor_labels = {"jig_loaded": "Jig at work position", "a_end": "Short stroke at end",
                     "b_end": "Long stroke at end"}
    result_labels = {"pickup_checked": "Long pickup position checked",
                     "jig_approached": "Single-jig approach", "result_asserted": "Completion asserted"}
    coupling = {
        "purpose": "Use jig alignment before the long-stroke approach",
        "states": [dict(id=key, label=sensor_labels.get(key, key),
                        value="Detected" if value else "Not detected",
                        status="ready" if value else "waiting")
                   for key, value in state["sensors"].items() if key in sensor_labels],
        "results": [dict(id=key, label=result_labels.get(key, key),
                         value=f"{value:.0f} ms", status="recorded")
                    for key, value in state["history"].items() if key != "request_available"],
    }
    geometry = dict(version="motion-grounded-geometry/4.1", task_number=12,
                    axis_labels={"a": "X1 short cylinder", "b": "X2 long cylinder",
                                 "c": "Z approach head", "d": "J jig transfer"},
                    local_dwell_required=False, coupling=coupling, parts=parts,
                    protected_pairs=[], source="priority-redesign/1")
    return {"geometry": geometry, "poses": {}}
