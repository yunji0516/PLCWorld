import copy, hashlib, json, math
from .material_station_geometry import Scene as BaseScene, STEEL, FRAME, DRIVE, BELT, A, BLUE, LIGHT, add
from .wrapping_math import CORNERS, GUIDE, PERIMETER, rotate_yz, tangent

class Scene(BaseScene):

    def node(self, *args, **kwargs):
        key = super().node(*args, **kwargs)
        if self.dynamic:
            self.poses[key]['rx'] = kwargs.get('rx', 0.0)
        return key
from .material_process_housings import plinth, backboard, guides

def layout(s):
    plinth(s, 'bundle_supply_station', 0, 2.18, 0.78, 1.9, top=0.8)
    guides(s, 'bundle_supply', 0, 2.2, 0.61, 1.9, top=0.95)
    plinth(s, 'film_service_station', 0, -0.74, 0.51, 0.62, top=0.29)
    plinth(s, 'tape_preparation_station', 1.15, -0.44, 0.41, 0.47, top=0.7)
    backboard(s, 'tape_cell_guard', 1.14, -0.76, 0.54, lower=0.73, upper=1.83)
    plinth(s, 'bundle_output_station', 1.2, -1.5, 1.65, 0.68, top=0.8)
    guides(s, 'bundle_output', 1.21, -1.5, 0.54, 1.55, top=0.95, axis='x')
    s.bed('source', 0, 2.2, 2.0, 0.68, 0.95, 'z')
    s.bed('exit', 0, -1.5, 1.0, 0.68, 0.95, 'z')
    s.bed('takeaway', 1.195, -1.5, 1.71, 0.6, 0.95, 'x')
    for x in [-0.88, 0.88]:
        for z in [-1.95, 3.25]:
            s.box('gantry_post' + str(x) + str(z), [x, 1.28, z], [0.075, 2.56, 0.075], FRAME)
        s.box('gantry_rail' + str(x), [x, 2.52, 0.65], [0.1, 0.12, 5.27], FRAME)
    for z in [-1.95, 3.25]:
        s.box('gantry_end' + str(z), [0, 2.52, z], [1.83, 0.12, 0.1], FRAME)
    s.cyl('gantry_drive', [1.02, 2.52, 3.16], 0.09, 0.22, DRIVE, 'x')
    for sign in [-1, 1]:
        x = sign * 0.53
        s.box('chuck_post' + str(sign), [x, 0.51, 0], [0.1, 1.02, 0.12], FRAME)
        s.box('chuck_foot' + str(sign), [x, 0.055, 0], [0.27, 0.11, 0.35], FRAME)
        s.cyl('bearing' + str(sign), [x, 1.1, 0], 0.105, 0.18, STEEL, 'x')
        s.cyl('chuck_actuator' + str(sign), [sign * 0.68, 1.1, 0], 0.067, 0.18, DRIVE, 'x')
    s.cyl('chuck_drive', [-0.87, 1.1, 0], 0.093, 0.19, DRIVE, 'x', name='Equipment')
    s.frame('reel_stand', 0, -0.735, 0.54, 0.64, 0.32)
    for i, z in enumerate([-0.55, -0.89]):
        for x in [-0.16, 0.16]:
            s.box(f'reel_support{i}{x}', [x, 0.385, z], [0.035, 0.17, 0.055], STEEL)
        s.cyl('reel_axle' + str(i), [0, 0.46, z], 0.025, 0.4, STEEL, 'x')
        for x in [-0.12, 0.12]:
            s.cyl(f'reel_flange{i}{x}', [x, 0.46, z], 0.155, 0.012, STEEL, 'x')
        s.line('leader' + str(i), [[0, 0.6, z], [0, 0.64, z], [0, 0.7, -0.55]], 0.18, BLUE, width_axis=[1, 0, 0])
    s.box('splice_base', [0, 0.687, -0.55], [0.24, 0.022, 0.075], STEEL)
    s.box('splice_post', [0.28, 0.47, -0.55], [0.045, 0.5, 0.045], FRAME)
    s.box('tape_post', [1.15, 0.72, -0.214], [0.07, 1.44, 0.07], FRAME)
    s.box('tape_actuator', [1.14, 1.266, -0.214], [0.26, 0.08, 0.12], DRIVE)
    s.cyl('tape_reel', [0.95, 1.6, -0.5], 0.105, 0.15, A, 'x')
    s.beam('tape_axle', [0.83, 1.6, -0.5], [1.15, 1.6, -0.5], 0.024)
    s.beam('tape_reel_stay', [1.15, 0.8, -0.5], [1.15, 1.6, -0.5], 0.025, FRAME)
    s.line('tape_feed', [[0.95, 1.5, -0.5], [0.95, 1.35, -0.25], [0.95, 1.28, -0.214]], 0.14, A, width_axis=[1, 0, 0])
    s.box('cutter_body', [0.52, 1.244, -0.22], [0.24, 0.06, 0.055], DRIVE)
    s.beam('cutter_stay', [0.6, 0.05, -0.22], [0.6, 1.244, -0.22], 0.025, FRAME)
    s.cabinet('control', [1.45, 0.63, 1.0])

def band_points(p):
    a = p['rx']
    i, _ = tangent(a)
    steps = int((a + 1e-10) / (2 * math.pi)) * 4 + (i - 3) % 4
    if a < 2 * math.pi - 1e-08 and i == 3 and (a > math.pi):
        steps = 4

    def world(q):
        y, z = rotate_yz(q, a)
        return [p['x'], p['y'] + y, p['z'] + z]
    return ([world(CORNERS[(3 + k) % 4]) for k in range(steps + 1)], world(CORNERS[i]))

def draw(s, f):
    q = f['plant']['physical']
    parts = f['plant']['parts']
    g = q['grip_xyz']
    closure = q['grip']
    s.box('transfer_carriage', [0, 2.46, g[2]], [1.76, 0.08, 0.19], DRIVE, name='Equipment')
    s.box('transfer_slide', [0, g[1] + 0.38, g[2]], [0.46, 0.1, 0.13], DRIVE)
    for x in [-0.13, 0.13]:
        s.beam('transfer_rod' + str(x), [x, 2.42, g[2]], [x, g[1] + 0.43, g[2]], 0.019)
    for x in [-0.17, 0.17]:
        for sign in [-1, 1]:
            zz = g[2] + sign * (0.229 + 0.1 * (1 - closure))
            key = f'transfer_finger{x}{sign}'
            s.box(key, [g[0] + x, g[1] + 0.11, zz], [0.05, 0.44, 0.03], STEEL, name='Equipment')
            s.box(key + '_pad', [g[0] + x, g[1] - 0.015, zz - sign * 0.017], [0.05, 0.17, 0.004], DRIVE)
            s.beam(key + '_slide', [g[0] + x, g[1] + 0.33, g[2]], [g[0] + x, g[1] + 0.33, zz], 0.014)
    for sign in [-1, 1]:
        x = sign * (0.265 + 0.13 * (1 - q['clamp']))
        s.cyl('chuck_' + str(sign), [x, 1.1, 0], 0.095, 0.03, DRIVE, 'x', name='Equipment')
        s.beam('chuck_shaft' + str(sign), [sign * 0.53, 1.1, 0], [x, 1.1, 0], 0.034)
    for i, p in parts.items():
        xyz = [p[k] for k in 'xyz']
        s.box('part' + i, xyz, p['size'], A, material=True, rx=p['rx'], name='Equipment' + i)
        for j in [-0.1, 0, 0.1]:
            yy, zz = rotate_yz((j, 0.211), p['rx'])
            s.box('layer' + i + str(j), add(xyz, [0, yy, zz]), [0.492, 0.003, 0.002], LIGHT, material=True, rx=p['rx'])
        points, end = band_points(p)
        s.line('film_band' + i, points, 0.18, BLUE, visible=len(points) > 1, material=True, width_axis=[1, 0, 0])
        s.line('free_film' + i, [[0, 1.1 + GUIDE[0], GUIDE[1]], end], 0.18, BLUE, visible=p['connected'], material=True, width_axis=[1, 0, 0])
        s.box('tape_patch' + i, add(xyz, [0, 0.158, -0.16]), [0.14, 0.004, 0.1], A, visible=p['taped'], material=True, rx=p['rx'])
    s.box('splice_jaw', [0, 0.72 + (0.025 if not q['swap_left'] else 0), -0.55], [0.22, 0.02, 0.07], DRIVE)
    for i, z in enumerate([-0.55, -0.89]):
        remaining = q['remaining'] if i == q['reel_index'] else 0 if i < q['reel_index'] else 2944
        radius = 0.03 + 0.113 * math.sqrt(max(0, remaining) / (2208 if i == 0 else 2944))
        s.cyl('reel_stock' + str(i), [0, 0.46, z], radius, 0.2, BLUE, 'x', material=True, name='Equipment')
    apply = q.get('apply_job')
    stroke = math.sin(math.pi * min(1.0, apply['age'] / 0.8)) if apply else 0.0
    tx = 0.95 * (1 - stroke)
    s.box('tape_head', [tx, 1.266, -0.214], [0.14, 0.024, 0.1], STEEL, name='Equipment')
    s.beam('tape_rod', [1.01, 1.266, -0.214], [tx + 0.07, 1.266, -0.214], 0.014)
    s.box('prepared_tape', [tx, 1.252, -0.214], [0.14, 0.003, 0.09], A, material=True, visible=bool(q['tape_slot'] or apply))
    cut = q['cut_job']
    cs = math.sin(math.pi * min(1.0, cut['age'] / 0.8)) if cut else 0.0
    cx = 0.39 * (1 - cs)
    s.box('cutter_blade', [cx, 1.244, -0.22], [0.22, 0.016, 0.008], LIGHT, name='Equipment')
    s.beam('cutter_rod', [0.4, 1.244, -0.22], [cx + 0.11, 1.244, -0.22], 0.009)
    s.line('retained_leader', [[0, 0.7, -0.55], [0, 1.254, -0.214]], 0.18, BLUE, visible=not any((p['connected'] for p in parts.values())), width_axis=[1, 0, 0])
