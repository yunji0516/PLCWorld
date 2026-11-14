import math
from .material_station_geometry import STEEL, FRAME, DRIVE, A, BLUE
from .winding_math import radial_height

def tube(s, key, p, outer, width, inner, color, **kw):
    s.node(key, p, [outer, width, inner], color, 'tube', rx=math.pi / 2, **kw)

def strip(s, key, points, width, color, **kw):
    s.node(key, [0, 0, 0], [8e-05 if color == A else 0.00012, width, 8e-05 if color == A else 0.00012], color, 'ribbon', points=points, width_axis=[0, 0, 1], **kw)
from .material_process_housings import plinth, backboard, guides

def layout(s):
    plinth(s, 'unwind_station', -0.55, 0.11, 0.46, 0.54, top=0.36)
    backboard(s, 'unwind_guard', -0.55, 0.34, 0.49, lower=0.45, upper=1.56)
    plinth(s, 'core_preparation_station', 0.45, 0.63, 0.35, 0.59, top=0.64)
    plinth(s, 'roll_receiving_station', 0.45, -0.98, 0.35, 0.7, top=0.64)
    plinth(s, 'mandrel_service_base', 0.45, 0.99, 0.34, 0.5, top=0.65)
    for side, y in [('a', 1.3), ('b', 0.65)]:
        s.box('source_post_' + side, [-0.55, y / 2, 0.23], [0.06, y, 0.06], FRAME)
        s.cyl('source_motor_' + side, [-0.55, y, 0.27], 0.05, 0.13, DRIVE, 'z')
        s.beam('source_shaft_' + side, [-0.55, y, -0.1], [-0.55, y, 0.23], 0.018)
    s.box('source_base', [-0.55, 0.05, 0.1], [0.4, 0.1, 0.5], FRAME)
    for z in [0.4, 0.58, 0.76, -1.2, -0.97, -0.74]:
        y = 0.95 - radial_height(0.05) if z > 0 else 0.86
        for sign in [-1, 1]:
            x = 0.45 + sign * 0.045
            s.cyl('fixed_receiver' + str(z) + str(sign), [x, y, z], 0.025, 0.035, STEEL, 'z')
            s.box('receiver_leg' + str(z) + str(sign), [x, y / 2 - 0.025, z], [0.025, y - 0.05, 0.025], FRAME)
    for x in [0.26, 0.64]:
        s.beam('cradle_rail' + str(x), [x, 0.72, -1.4], [x, 0.72, 0.92], 0.018, STEEL)
        for z in [-1.4, 0.92]:
            s.box('rail_leg' + str(x) + str(z), [x, 0.36, z], [0.045, 0.72, 0.045], FRAME)
    s.box('mandrel_stand', [0.45, 0.5, 1.0], [0.24, 1.0, 0.18], FRAME)
    s.box('mandrel_slide', [0.45, 0.95, 1.12], [0.12, 0.12, 0.4], DRIVE)
    s.cabinet('controls', [-0.14, 0.49, 0.69])

def draw(s, f):
    q = f['plant']['physical']
    ps = f['plant']['parts']
    active = ps.get(str(q['active']), ps.get(q['active'])) if q['active'] else None
    for side, color in [('a', A), ('b', BLUE)]:
        z = q['sources'][side]
        y = 1.3 if side == 'a' else 0.65
        tube(s, 'source_core_' + side, [-0.55, y, 0], 0.05, 0.14, 0.035, STEEL)
        tube(s, 'source_wound_' + side, [-0.55, y, 0], z['radius'], 0.12, 0.05, color, material=True)
        for zz in [-0.079, 0.079]:
            tube(s, 'source_flange_' + side + str(zz), [-0.55, y, zz], 0.075, 0.01, 0.035, STEEL)
        strip(s, 'supply_' + side, z['path'], 0.12, color, material=True)
        s.cyl('guide_' + side, z['guide'], 0.0149, 0.14, DRIVE, 'z')
        s.beam('guide_shaft_' + side, [*z['guide'][:2], 0], [*z['guide'][:2], 0.2], 0.008)
        sign = 1 if side == 'a' else -1
        cut_y = z['path'][-1][1]
        w = q['web'][side]
        closed = max(w['nip'], w['hold'])
        pressure_y = cut_y - sign * (0.015 + 0.03 * (1 - closed))
        s.cyl('pressure_' + side, [0.18, pressure_y, 0], 0.0149, 0.14, STEEL, 'z')
        s.box('guide_actuator_' + side, [0.18, z['guide'][1], 0.26], [0.07, 0.08, 0.08], DRIVE)
        s.beam('pressure_arm_' + side, [0.18, pressure_y, 0], [0.18, pressure_y, 0.22], 0.008)
        s.box('nip_slide_' + side, [0.18, pressure_y, 0.23], [0.065, 0.035, 0.04], DRIVE)
        s.box('nip_post_' + side, [0.18, (cut_y + 0.12) / 2, 0.3], [0.045, cut_y - 0.12, 0.045], FRAME)
        knife = q['knives'][side]
        stroke = math.sin(math.pi * min(1, knife['age'] / 0.1)) if knife else 0.0
        ky = cut_y + 0.022 - 0.027 * stroke
        s.box('knife_' + side, [0.22, ky, 0], [0.003, 0.014, 0.14], STEEL)
        s.box('knife_carriage_' + side, [0.22, ky, 0.12], [0.03, 0.018, 0.06], DRIVE)
        s.box('knife_actuator_' + side, [0.22, cut_y + 0.022, 0.22], [0.04, 0.04, 0.08], DRIVE)
        s.beam('knife_stay_' + side, [0.22, cut_y + 0.022, 0.13], [0.22, cut_y + 0.022, 0.26], 0.008)
    if active and active['tail'] > 1e-09:
        length = active['tail']
        connected = all(active['connected'].values())
        lo = 0.0 if connected else 0.25 - length
        hi = length if connected else 0.25
        tips = []
        for side, color, off, sign in [('a', A, 4e-05, 1), ('b', BLUE, 0.00014, -1)]:
            y = 0.95 + active['radius'] - off
            path = [[0.22, y + sign * 0.04, 0], [0.25, y, 0], [0.45, y, 0]]

            def point(u):
                if u <= 0.05:
                    return [0.22 + 0.03 * u / 0.05, y + sign * 0.04 * (1 - u / 0.05), 0]
                return [0.25 + u - 0.05, y, 0]
            points = [point(lo)] + ([path[1]] if lo < 0.05 < hi else []) + [point(hi)]
            strip(s, 'tail_' + side, points, 0.12, color, material=True)
            tips.append(point(hi))
        gx = tips[0][0]
    else:
        gx = 0.22
    guiding = bool(active and active['length'] < 0.25 and (active['tail'] > 0))
    gy = tips[0][1] + 4e-05 + 0.009 if guiding else 0.95 + (active['radius'] if active else 0.05) + 0.16
    s.box('leader_grip', [gx, gy, 0], [0.025, 0.018, 0.13], DRIVE)
    s.beam('leader_rod', [gx, 1.3, 0], [gx, gy + 0.009, 0], 0.007)
    s.box('leader_slide', [0.325, 1.32, 0], [0.32, 0.035, 0.04], FRAME)
    trim = q['trim_z']
    tx = q['trim_x']
    s.box('trim_tray', [tx, 0.9523, trim], [0.204, 0.015, 0.15], STEEL)
    s.box('trim_carriage', [tx, 0.89, trim], [0.15, 0.07, 0.12], DRIVE)
    s.beam('trim_rail', [tx, 0.83, -0.45], [tx, 0.83, 0], 0.014)
    s.beam('trim_xrail', [-0.18, 0.78, -0.4], [0.4, 0.78, -0.4], 0.014)
    s.cyl('mandrel', [0.45, 0.95, 0.11 + 0.3 * q['mandrel']], 0.038, 0.18, STEEL, 'z')
    s.beam('mandrel_drive_rod', [0.45, 0.95, 0.2 + 0.3 * q['mandrel']], [0.45, 0.95, 1.0], 0.025, STEEL)
    y, z = (q['support_y'], q['support_z'])
    for j, dx in enumerate([-0.045, 0.045]):
        for k, dz in enumerate([-0.045, 0.045]):
            s.cyl('cradle_roller' + str(j) + str(k), [0.45 + dx, y, z + dz], 0.025, 0.025, DRIVE, 'z')
    s.box('cradle_saddle', [0.45, y - 0.05, z], [0.17, 0.035, 0.16], FRAME)
    s.box('cradle_lift', [0.45, (y - 0.07 + 0.74) / 2, z], [0.045, max(0.006, y - 0.07 - 0.74), 0.045], STEEL)
    s.box('cradle_carriage', [0.45, 0.735, z], [0.43, 0.045, 0.21], DRIVE)
    for i, p in ps.items():
        pos = [p[k] for k in 'xyz']
        if int(i) == 201:
            s.box('part' + str(i), pos, p['size'], BLUE, material=True, visible=p['length'] > 1e-06, name='Equipment')
        else:
            s.box('part' + str(i), pos, p['size'], A, material=True, visible=False)
            tube(s, 'core' + str(i), pos, 0.05, 0.12, 0.04, STEEL, material=True)
            tube(s, 'wound' + str(i), [p['x'], p['y'], p['z'] + 0.005], p['radius'], 0.11, 0.05, A, material=True, visible=p['wound'] > 1e-06)
            tube(s, 'wound_b' + str(i), [p['x'], p['y'], p['z'] - 0.055], p['radius'], 0.01, 0.05, BLUE, material=True, visible=p['wound'] > 1e-06)
