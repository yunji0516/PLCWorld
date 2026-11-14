import copy, gzip, hashlib, json, math
from pathlib import Path
SCALE = 1.0
STEEL = '#83949b'
FRAME = '#384f5a'
DRIVE = '#407e88'
BELT = '#394c55'
A = '#c99a54'
BLUE = '#629ba4'
LIGHT = '#d3dcdf'

def vec(p):
    return [round(float(x) * SCALE, 6) for x in p]

def add(a, b):
    return [x + y for x, y in zip(a, b)]

def toward(a, b, step):
    return a + max(-step, min(step, b - a))

def along(points, fraction):
    lengths = [math.dist(a, b) for a, b in zip(points, points[1:])]
    left = max(0.0, min(1.0, fraction)) * sum(lengths)
    for a, b, length in zip(points, points[1:], lengths):
        if left <= length:
            return [x + (y - x) * left / max(length, 1e-09) for x, y in zip(a, b)]
        left -= length
    return points[-1]

class Scene:

    def __init__(self):
        self.nodes = {}
        self.poses = {}
        self.dynamic = False
        self.supports = []
        self.anchors = {}

    def node(self, key, p, size, color=STEEL, shape='box', name=None, **kw):
        visible = kw.pop('visible', True)
        points = kw.pop('points', None)
        if key not in self.nodes:
            self.nodes[key] = dict(id=key, name=name or key, p=vec(p), r=0, size=vec(size), color=color, shape=shape, visible=visible if not self.dynamic else False, **kw)
            if points:
                self.nodes[key]['points'] = [vec(q) for q in points]
        if self.dynamic:
            pose = dict(p=vec(p), r=kw.get('r', 0), s=vec(size), visible=visible)
            if points:
                pose['points'] = [vec(q) for q in points]
            self.poses[key] = pose
        return key

    def box(self, key, p, size, color=STEEL, **kw):
        return self.node(key, p, size, color, **kw)

    def cyl(self, key, p, r, h, color=STEEL, axis='y', **kw):
        return self.node(key, p, [r, h, r], color, 'cylinder', axis=axis, **kw)

    def beam(self, key, a, b, r=0.018, color=STEEL, **kw):
        return self.node(key, a, [r, max(1e-05, math.dist(a, b)), r], color, 'beam', points=[a, b], **kw)

    def line(self, key, points, width=0.02, color=DRIVE, **kw):
        return self.node(key, [0, 0, 0], [0.004, width, 0.004], color, 'ribbon', points=points, **kw)

    def label(self, key, text, p):
        self.node('label_' + key, p, [0.01, 0.01, 0.01], LIGHT, 'label', name=text)

    def frame(self, key, x, z, w, d, top):
        for i, xx in enumerate([x - w / 2 + 0.045, x + w / 2 - 0.045]):
            for j, zz in enumerate([z - d / 2 + 0.045, z + d / 2 - 0.045]):
                self.box(f'{key}_leg{i}{j}', [xx, (top - 0.1 + 0.05) / 2, zz], [0.055, top - 0.15, 0.055], FRAME)
                self.box(f'{key}_foot{i}{j}', [xx, 0.025, zz], [0.1, 0.05, 0.1], FRAME)
        self.box(key + '_beam', [x, top - 0.075, z], [w, 0.075, d], FRAME)

    def bed(self, key, x, z, length, width, top, axis='x', legs=True):
        size = [length, 0.035, width] if axis == 'x' else [width, 0.035, length]
        self.box(key + '_surface', [x, top - 0.0175, z], size, BELT, name=key + ' driven support')
        self.supports.append(dict(id=key + '_surface', top=top, x=x, z=z, width=size[0], depth=size[2]))
        if legs:
            self.frame(key, x, z, size[0] + 0.1, size[2] + 0.1, top - 0.035)
        self.cyl(key + '_motor', [x, top - 0.15, z + (width / 2 + 0.1 if axis == 'x' else 0)], 0.06, 0.14, DRIVE, axis='z' if axis == 'x' else 'x')
        at = [x - length / 2 + 0.045, top - 0.05, z] if axis == 'x' else [x, top - 0.05, z - length / 2 + 0.045]
        self.cyl(key + '_roller', at, 0.032, width + 0.025, STEEL, axis='z' if axis == 'x' else 'x')

    def sensor(self, key, p, axis='z'):
        self.box(key + '_post', [p[0], p[1] - 0.085, p[2]], [0.024, 0.17, 0.024], STEEL)
        self.box(key, p, [0.055, 0.07, 0.055], DRIVE, name=key + ' detector')
        self.cyl(key + '_lens', add(p, [0, 0, -0.03]), 0.015, 0.009, '#daa568', 'z')

    def tray(self, key, p, size, color=A):
        w, h, d = size
        t = 0.018
        self.box(key + '_base', add(p, [0, -h / 2 + t / 2, 0]), [w, t, d], color, material=True)
        for sign in [-1, 1]:
            self.box(key + '_wallx' + str(sign), add(p, [sign * (w - t) / 2, t / 2, 0]), [t, h - t, d], color, material=True)
            self.box(key + '_wallz' + str(sign), add(p, [0, t / 2, sign * (d - t) / 2]), [w - 2 * t, h - t, t], color, material=True)

    def cabinet(self, key, p):
        self.box(key, p, [0.4, 0.55, 0.25], LIGHT, name='control cabinet')
        self.box(key + '_panel', add(p, [0, 0.12, 0.135]), [0.24, 0.16, 0.012], DRIVE)
        self.beam(key + '_conduit', add(p, [0, -0.275, 0]), [p[0], 0.12, p[2]], 0.014, FRAME)

def layout_liquid(s):
    for side, x in [('a', -1.3), ('b', 1.3)]:
        s.bed('supply_fill_receive_' + side, x, 0.15, 8.55, 0.39, 0.8, 'z')
        for z in [0.6, 0, -1.0, -2.0]:
            s.sensor('photo_' + side + str(z), [x + 0.27, 1.0, z])
        s.box('nozzle_post_' + side, [x + 0.36, 0.99, 0.22], [0.055, 1.98, 0.055], FRAME)
        s.box('nozzle_top_' + side, [x + 0.18, 1.97, 0.11], [0.42, 0.06, 0.28], FRAME)
        s.cyl('nozzle_actuator_' + side, [x, 1.83, 0], 0.055, 0.23, DRIVE)
        s.cyl('clamp_actuator_' + side, [x + 0.4, 0.97, 0], 0.045, 0.28, DRIVE, 'x')
        s.box('clamp_backstop_' + side, [x - 0.16, 0.97, 0], [0.05, 0.1, 0.2], STEEL)
        s.frame('pump_base_' + side, x / 2, 0.8, 0.45, 0.45, 0.5)
        s.cyl('pump_' + side, [x / 2, 0.57, 0.8], 0.08, 0.25, DRIVE, 'z')
        s.line('tank_pipe_' + side, [[0, 0.48, 1.35], [x / 2, 0.48, 1.35], [x / 2, 0.57, 0.8]], 0.024, BLUE)
    s.frame('tank_stand', 0, 1.35, 0.7, 0.7, 0.35)
    s.cyl('tank_shell', [0, 0.73, 1.35], 0.255, 0.76, LIGHT, opacity=0.22)
    for y in [0.355, 1.105]:
        s.cyl('tank_ring' + str(y), [0, y, 1.35], 0.264, 0.025, STEEL)
    s.line('refill_pipe', [[0, 1.4, 2.5], [0, 1.25, 2.5], [0, 1.25, 1.35], [0, 1.11, 1.35]], 0.022, BLUE)
    s.bed('batch_exchange', 0, 2.7, 1.3, 1.15, 1.15)
    for x in [-1.7, 1.7]:
        s.box('capper_column' + str(x), [x, 0.98, -1.0], [0.06, 1.96, 0.06], FRAME)
    s.box('capper_gantry', [0, 1.95, -1.0], [3.48, 0.09, 0.14], FRAME)
    for z in [-1.05, -0.95]:
        s.beam('capper_rail' + str(z), [-1.6, 1.88, z], [1.6, 1.88, z], 0.015)
    s.cyl('capper_drive', [1.77, 1.9, -1.0], 0.075, 0.18, DRIVE, 'x')
    s.cabinet('controls', [0.5, 0.58, -0.1])

def draw_liquid(s, f):
    z = f['plant']['physical']
    poses = f['plant']['material_hard']['poses']
    for i, p in f['plant']['parts'].items():
        xyz = [p[k] for k in 'xyz']
        key = 'part' + str(i)
        bottom = p['y'] - 0.175
        s.cyl(key, xyz, 0.135, 0.35, '#dbe8df', opacity=0.28, material=True, name='Equipment' + str(i))
        s.cyl(key + '_base', [p['x'], bottom + 0.012, p['z']], 0.128, 0.024, STEEL, material=True)
        s.cyl(key + '_rim', [p['x'], bottom + 0.347, p['z']], 0.137, 0.018, LIGHT, material=True)
        level = max(0.0005, p['received'] / 100 * 0.28)
        s.cyl(key + '_liquid', [p['x'], bottom + 0.025 + level / 2, p['z']], 0.113, level, BLUE, visible=p['received'] > 0.01, material=True)
        s.cyl(key + '_cap', [p['x'], bottom + 0.368, p['z']], 0.141, 0.036, DRIVE, visible=p['capped'], material=True)
    level = 0.72 * z['tank'] / 160
    s.cyl('tank_level', [0, 0.37 + level / 2, 1.35], 0.239, max(0.001, level), BLUE)
    for side, x in [('a', -1.3), ('b', 1.3)]:
        p = poses['nozzle_' + side]['pos']
        jaw = poses['clamp_' + side]['pos']
        s.beam('nozzle_rod_' + side, [x, 1.73, 0], [x, p[1] + 0.06, 0], 0.019)
        s.beam('nozzle_tip_' + side, add(p, [0, 0.06, 0]), add(p, [0, -0.04, 0]), 0.012)
        s.box('nozzle_slide_' + side, [x + 0.1, p[1] + 0.08, 0.14], [0.24, 0.09, 0.1], DRIVE)
        s.line('flex_hose_' + side, [[x / 2, 0.57, 0.8], [x / 2, 1.68, 0.6], [x, 1.68, 0.3], add(p, [0, 0.05, 0])], 0.018, BLUE)
        s.box('clamp_' + side, jaw, [0.05, 0.1, 0.2], DRIVE)
        s.beam('clamp_rod_' + side, [x + 0.27, 0.97, 0], jaw, 0.012)
    cap = poses['capper']['pos']
    x = cap[0]
    s.box('capper_carriage', [x, 1.87, -1.0], [0.28, 0.08, 0.23], DRIVE)
    s.cyl('capper_cylinder', [x, 1.68, -1.0], 0.055, 0.25, DRIVE)
    s.beam('capper_rod', [x, 1.56, -1.0], add(cap, [0, 0.04, 0]), 0.018)
    s.cyl('capper_head', cap, 0.092, 0.028, STEEL)
    for j in range(3):
        index = z['batch_index']
        active = j == index
        removed = j < index
        progress = f.get('_batch_progress')
        pos = [-0.45, 1.39, 2.5 + 0.4 * j] if removed else [0, 1.39, 2.5] if active else [0.45, 1.39, 2.5 + 0.4 * (j - 1)]
        if progress is not None:
            if j == index:
                pos = [-0.45 * min(1, progress * 2), 1.39, 2.5 + 0.4 * j * min(1, progress * 2)]
            elif j == index + 1:
                alpha = max(0.0, progress * 2 - 1)
                pos = [0.45 * (1 - alpha), 1.39, 2.5 + 0.4 * (j - 1) * (1 - alpha)]
        s.box('batch' + str(j), pos, [0.28, 0.48, 0.3], LIGHT, name='Equipment' + str(j + 1))
        s.box('batch_fill' + str(j), add(pos, [0, 0, -0.156]), [0.2, 0.34 * (z['batch_remaining'] / 160 if active else 0 if removed else 1) + 0.001, 0.014], BLUE)

def layout_weigh(s):
    y = 1.22
    for x, length in [(-4.05, 3.5), (-1.66, 0.48), (1.72, 0.54), (2.68, 0.54)]:
        s.bed('rail_' + str(x), x, 0, length, 0.42, y, legs=True)
    for name, x in [('pre', -2.1), ('post', 2.2)]:
        s.frame(name + '_frame', x, 0, 0.62, 0.62, 0.98)
        for z in [-0.16, 0.16]:
            s.box(name + '_support_rail' + str(z), [x, y - 0.025, z], [0.45, 0.05, 0.065], BELT)
        s.box(name + '_loadcell', [x, 1.05, 0], [0.2, 0.08, 0.2], DRIVE)
        for dx in [-0.1, 0.1]:
            s.cyl(name + '_guide' + str(dx), [x + dx, 1.12, 0], 0.014, 0.2)
        s.sensor(name + '_photo', [x, 1.36, 0.3])
    for x in [-1.25, 1.25, 3.15]:
        s.bed('cross_' + str(x), x, 0, 2.14, 0.44, y, 'z')
    for n, z in [(1, -0.85), (2, 0.85)]:
        s.bed('kit_lane' + str(n), 0, z, 2.9, 0.44, y)
        s.box('kit_hopper' + str(n), [0, 1.92, z + 0.32], [0.34, 0.42, 0.34], LIGHT)
        s.box('kit_post' + str(n), [0.34, 1.04, z + 0.4], [0.05, 2.08, 0.05], FRAME)
        s.box('kit_arm' + str(n), [0.17, 2.08, z + 0.23], [0.38, 0.07, 0.4], FRAME)
        s.beam('kit_drop' + str(n), [0, 1.72, z + 0.32], [0, 1.52, z], 0.038, STEEL)
        s.bed('exit' + str(n), 4.36, z, 2.55, 0.44, y)
    s.cabinet('control', [-0.8, 0.52, 1.5])

def draw_weigh(s, f):
    z = f['plant']['physical']
    for name, x in [('pre', -2.1), ('post', 2.2)]:
        rise = 0.06 * z['pans'][name]
        top = 1.22 + rise
        s.box(name + '_pan', [x, top - 0.02, 0], [0.235, 0.04, 0.235], STEEL, name='Equipment')
        s.beam(name + '_piston', [x, 1.09, 0], [x, top - 0.04, 0], 0.027)
    for i, p in f['plant']['parts'].items():
        xyz = [p[k] for k in 'xyz']
        key = 'part' + str(i)
        s.tray(key, xyz, p['size'], A if int(i) % 2 else BLUE)
        for j in range(3):
            s.box(key + '_kit' + str(j), [p['x'] + (j - 1) * 0.085, p['y'] - 0.0145, p['z']], [0.07, 0.055, 0.22], LIGHT, material=True, visible=j < len(p['contents']))

def layout_scrap(s):
    for side, x in [('a', -1.25), ('b', 1.25)]:
        s.bed('product_line_' + side, x, 0, 4.8, 0.52, 1.09, 'z')
        for xx in [x - 0.34, x + 0.34]:
            s.box('press_post' + str(xx), [xx, 0.97, 0], [0.055, 1.94, 0.055], FRAME)
        s.box('press_bridge_' + side, [x, 1.93, 0], [0.76, 0.11, 0.4], FRAME)
        s.cyl('press_body_' + side, [x, 1.74, 0], 0.08, 0.27, DRIVE)
        endpoint_z = 0.57 if side == 'a' else 0.73
        panel = [[x - 0.1, 1.118, 0], [x + 0.1, 1.118, 0], [0.28 if side == 'a' else 0.12, 0.718, endpoint_z], [-0.28, 0.718, endpoint_z]]
        s.node('scrap_chute_' + side, [0, 0, 0], [0.004, 0.5, 1.0], BELT, 'panel', points=panel, name='Equipment' + side.upper())
        for xx in [-0.29, 0.29]:
            s.beam('chute_stay_' + side + str(xx), [xx, 0.07, endpoint_z], [xx, 0.7, endpoint_z], 0.022, FRAME)
        s.bed('external_pickup_' + side, x + 0.5, -2.0, 1.5, 0.5, 1.09)
        s.cyl('discharge_drive_' + side, [x, 0.95, 0.2], 0.065, 0.23, DRIVE, 'x')
    s.bed('bin_exchange', -0.38, 0.65, 5.1, 0.6, 0.4)
    s.cabinet('control', [0, 0.55, -0.7])

def draw_scrap(s, f):
    z = f['plant']['physical']
    for side, x in [('a', -1.25), ('b', 1.25)]:
        j = z['jobs'][side]
        depth = 0.5 - 0.5 * math.cos(2 * math.pi * j['elapsed']) if j else 0
        py = 1.56 - 0.26 * depth
        s.box('punch_' + side, [x, py, 0], [0.33, 0.1, 0.32], STEEL)
        s.beam('punch_rod_' + side, [x, 1.61, 0], [x, py + 0.05, 0], 0.03)
    swapped = bool(z['used_bins'])
    positions = {101: z['return_x'] if swapped else 0.0, 102: z['bin_x'] if swapped else 1.8}
    for bid, x in positions.items():
        for sign in [-1, 1]:
            s.box('bin_side' + str(bid) + str(sign), [x + sign * 0.265, 0.55, 0.65], [0.02, 0.16, 0.44], DRIVE)
            s.box('bin_end' + str(bid) + str(sign), [x, 0.55, 0.65 + sign * 0.21], [0.51, 0.16, 0.02], DRIVE)
        s.box('bin_floor' + str(bid), [x, 0.45, 0.65], [0.52, 0.04, 0.4], STEEL)
        for zz in [0.49, 0.81]:
            s.cyl('bin_wheel' + str(bid) + str(zz), [x, 0.415, zz], 0.015, 0.42, STEEL, 'x')
    for i, p in f['plant']['parts'].items():
        xyz = [p[k] for k in 'xyz']
        if int(i) < 100:
            for sign in [-1, 1]:
                s.box('part' + str(i) + '_x' + str(sign), add(xyz, [sign * 0.17, 0, 0]), [0.08, 0.12, 0.42], A, material=True)
                s.box('part' + str(i) + '_z' + str(sign), add(xyz, [0, 0, sign * 0.17]), [0.26, 0.12, 0.08], A, material=True)
            has_cut = any((p2.get('batch') == int(i) and int(k) > 100 for k, p2 in f['plant']['parts'].items()))
            s.box('part' + str(i) + '_blank', xyz, [0.26, 0.12, 0.26], A, material=True, visible=not has_cut)
        else:
            s.box('part' + str(i), xyz, p['size'], '#b6b0a4', material=True, name='Equipment' + str(i))

def boundary(distance):
    w = 0.508
    d = 0.428
    per = 2 * (w + d)
    lap = 2.0 - per
    q = min(2.0, max(0.0, distance))
    extra = max(0.0, q - per)
    q = q if q <= per else extra
    if q <= d:
        return [-w / 2, 0, -d / 2 + q]
    q -= d
    if q <= w:
        return [-w / 2 + q, 0, d / 2]
    q -= w
    if q <= d:
        return [w / 2, 0, d / 2 - q]
    return [w / 2 - (q - d), 0, -d / 2]

def band_points(length, p):
    milestones = [0.0, 0.428, 0.936, 1.364, 1.872, 2.0]
    distance = max(0.0, min(2.0, length / 500))
    pts = []
    for d in [v for v in milestones if v < distance] + [distance]:
        q = boundary(d)
        q[1] = p[1]
        q[0] += p[0]
        q[2] += p[2]
        if d > 1.872:
            q[0] -= 0.006
        pts.append(q)
    return pts

def layout_wrap(s):
    s.bed('bundle_infeed', 0, 2.3, 2.72, 0.54, 0.95, 'z')
    s.bed('bundle_exit', 0, -1.6, 1.32, 0.54, 0.95, 'z')
    s.bed('external_pickup', 0.95, -2.0, 2.35, 0.54, 0.95)
    s.frame('fixture', 0, 0, 0.52, 0.48, 0.91)
    s.box('fixture_surface', [0, 0.93, 0], [0.54, 0.04, 0.5], BELT)
    s.cyl('feed_bridge_actuator', [1.7, 0.89, 0.6], 0.045, 0.5, DRIVE, 'x')
    s.box('feed_bridge_guide', [1.1, 0.855, 0.6], [1.25, 0.045, 0.16], FRAME)
    s.cyl('orbital_motor', [0, 0.48, 0], 0.12, 0.3, DRIVE)
    s.cyl('orbital_bearing', [0, 0.72, 0], 0.15, 0.1, STEEL)
    s.box('fixture_back', [-0.28, 0.975, 0], [0.06, 0.05, 0.32], STEEL)
    s.box('clamp_housing', [0.52, 0.93, 0], [0.26, 0.06, 0.12], DRIVE)
    s.bed('reel_exchange', 1.35, -0.7, 0.5, 0.85, 0.995)
    for zz in [-0.9, -0.5]:
        s.cyl('reel_dock' + str(zz), [1.35, 1.08, zz], 0.02, 0.17, STEEL)
    for zz in [-1.08, 0.52]:
        s.box('reel_gantry_post' + str(zz), [1.65, 1.18, zz], [0.045, 2.36, 0.045], FRAME)
    s.box('reel_gantry_z', [1.65, 2.34, -0.28], [0.065, 0.065, 1.66], FRAME)
    s.frame('tape_table', -0.9, -0.6, 0.65, 0.6, 0.96)
    s.box('tape_tabletop', [-0.9, 0.95, -0.6], [0.65, 0.02, 0.6], STEEL)
    s.cyl('tape_reel', [-1.0, 1.2, -0.7], 0.11, 0.14, BLUE, 'z')
    s.box('tape_guide', [-0.85, 0.98, -0.85], [0.4, 0.04, 0.1], FRAME)
    s.cyl('tape_actuator', [-1.08, 1.05, -0.85], 0.045, 0.22, DRIVE, 'x')
    for x in [-0.53, 0.53]:
        s.box('outgrip_post' + str(x), [x, 0.9, -1.0], [0.05, 1.8, 0.05], FRAME)
    for x in [-0.44, 0.44]:
        s.box('outgrip_rail' + str(x), [x, 1.8, -1.0], [0.045, 0.065, 2.35], FRAME)
    for zz in [-2.15, 0.15]:
        s.box('outgrip_cross' + str(zz), [0, 1.8, zz], [0.88, 0.065, 0.045], FRAME)
    s.box('cutter_mount', [-0.36, 1.39, -0.12], [0.045, 0.88, 0.06], FRAME)
    s.box('cutter_bracket', [-0.32, 1.79, -0.12], [0.12, 0.05, 0.1], FRAME)
    s.cyl('cutter_body', [-0.305, 1.68, -0.12], 0.035, 0.17, DRIVE)
    s.cabinet('control', [1.05, 0.5, 1.0])

def draw_wrap(s, f):
    z = f['plant']['physical']
    parts = f['plant']['parts']
    current = next((p for p in parts.values() if p['owner'] == 'station'), None)
    for i, p in parts.items():
        xyz = [p[k] for k in 'xyz']
        s.box('part' + str(i), xyz, p['size'], A, material=True, name='Equipment' + str(i))
        for j in [-0.07, 0.035]:
            s.box('layer_edge' + str(i) + str(j), [p['x'], p['y'] + j, p['z'] + 0.212], [0.48, 0.005, 0.005], STEEL, material=True)
        points = band_points(p['wrapped'], xyz)
        s.line('band' + str(i), points, 0.18, '#ac976b', visible=len(points) > 1 and p['wrapped'] > 0, width_axis=[0, 1, 0])
        s.box('tape' + str(i), [p['x'] - 0.262, p['y'], p['z'] - 0.1], [0.006, 0.16, 0.085], DRIVE, visible=p['taped'], material=True)
    bx = f['_bridge_x']
    s.box('feed_bridge', [bx, 0.93, 0.6], [0.5, 0.04, 0.7], STEEL)
    s.beam('feed_bridge_rod', [1.45, 0.89, 0.6], [bx + 0.25, 0.89, 0.6], 0.015)
    wrapped = current['wrapped'] if current else max((p['wrapped'] for p in parts.values()), default=0)
    angle = f['_arm_angle']
    arm = [0.68 * math.cos(angle), 1.1, 0.68 * math.sin(angle)]
    s.beam('orbital_arm', [0, 0.76, 0], [arm[0], 0.76, arm[2]], 0.037, FRAME)
    s.beam('orbital_post', [arm[0], 0.76, arm[2]], [arm[0], 1.34, arm[2]], 0.024)
    s.cyl('reel_seat', [arm[0], 0.9825, arm[2]], 0.09, 0.025, STEEL)
    progress = f.get('_reel_progress')
    old = arm if z['reel_index'] == 0 else [1.35, 1.1, -0.5]
    new = arm if z['reel_index'] == 1 else [1.35, 1.1, -0.9]
    if progress is not None:
        old = along([arm, [arm[0], 1.98, arm[2]], [1.35, 1.98, -0.5], [1.35, 1.1, -0.5]], (progress - 0.1) / 0.3)
        new = along([[1.35, 1.1, -0.9], [1.35, 1.98, -0.9], [arm[0], 1.98, arm[2]], arm], (progress - 0.6) / 0.3)
    for index, pos in enumerate([old, new]):
        remaining = z['remaining'] if index == z['reel_index'] else 2000 if index > z['reel_index'] else 0
        s.cyl('reel' + str(index), pos, 0.065 + 0.085 * math.sqrt(remaining / 2000), 0.21, A, name='Equipment' + str(index + 1))
    anchor = boundary(1.0)
    angle = math.atan2(anchor[2], anchor[0])
    park = [0.68 * math.cos(angle), 1.7, 0.68 * math.sin(angle)]
    tool = park
    if progress is not None:
        if progress < 0.1:
            tool = along([park, arm], progress / 0.1)
        elif progress < 0.4:
            tool = old
        elif progress < 0.6:
            tool = along([[1.35, 1.1, -0.5], [1.35, 1.98, -0.5], [1.35, 1.98, -0.9], [1.35, 1.1, -0.9]], (progress - 0.4) / 0.2)
        elif progress < 0.9:
            tool = new
        else:
            tool = along([arm, park], (progress - 0.9) / 0.1)
    s.box('reel_exchange_cross', [1.03, 2.28, tool[2]], [1.26, 0.055, 0.07], FRAME)
    s.box('reel_exchange_carriage', [tool[0], 2.23, tool[2]], [0.14, 0.06, 0.14], DRIVE)
    s.beam('reel_exchange_vertical', [tool[0], 2.2, tool[2]], [tool[0], tool[1] + 0.14, tool[2]], 0.017)
    s.cyl('reel_exchange_chuck', add(tool, [0, 0.13, 0]), 0.034, 0.05, STEEL)
    if current and current['connected']:
        p = [current[k] for k in 'xyz']
        end = add(boundary(current['wrapped'] / 500), p)
        s.line('live_film', [arm, end], 0.18, '#c2b89d', width_axis=[0, 1, 0])
    else:
        s.line('live_film', [arm, add(arm, [0.07, 0.0, 0.08])], 0.18, '#c2b89d', width_axis=[0, 1, 0])
    s.box('clamp_jaw', [0.34 - 0.06 * z['clamp'], 0.975, 0], [0.06, 0.05, 0.28], DRIVE)
    s.beam('clamp_rod', [0.4, 0.93, 0], [0.34 - 0.06 * z['clamp'], 0.93, 0], 0.012)
    s.box('clamp_clevis', [0.34 - 0.06 * z['clamp'], 0.9475, 0], [0.028, 0.045, 0.06], STEEL)
    for sign in [-1, 1]:
        s.box('film_hold' + str(sign), [-0.31 + sign * (0.035 - 0.018 * z['hold']), 1.1, -0.12], [0.022, 0.18, 0.1], STEEL)
    cut = z['cut_job']
    progress = max(0.0, min(1.0, cut['age'] / 0.3, (0.8 - cut['age']) / 0.3)) if cut else 0
    s.box('cutter_blade', [-0.305, 1.4 - 0.2 * progress, -0.12], [0.008, 0.19, 0.12], STEEL)
    s.beam('cutter_rod', [-0.305, 1.6, -0.12], [-0.305, 1.49 - 0.2 * progress, -0.12], 0.016)
    tape_present = bool(z['tape_slot'])
    s.box('pickup_tape', [-0.72, 1.0075, -0.85], [0.06, 0.015, 0.1], BLUE, visible=tape_present, material=True)
    zz, grip_y, grip_x = f['_grip']
    s.box('outgrip_carriage', [0, 1.74, zz], [0.3, 0.07, 0.3], DRIVE)
    s.beam('outgrip_rod', [0, 1.7, zz], [0, grip_y + 0.15, zz], 0.019)
    s.box('outgrip_finger_mount', [0, grip_y + 0.13, zz], [2 * grip_x + 0.03, 0.04, 0.12], DRIVE)
    for sign in [-1, 1]:
        s.box('outgrip_jaw' + str(sign), [sign * grip_x, grip_y, zz], [0.028, 0.22, 0.28], STEEL)

def layout_magazine(s):
    s.bed('magazine_exchange', 0, 1.0, 2.8, 0.5, 1.04, 'z')
    s.bed('empty_return', -1.0, 1.8, 2.6, 0.5, 1.04)
    s.bed('undock_cross', -0.5, 1.0, 1.5, 0.5, 1.04)
    s.bed('undock_return', -1.0, 0.9, 1.85, 0.5, 1.04, 'z', False)
    s.bed('shuttle_rail', 0, 0.65, 3.4, 0.22, 0.83)
    s.bed('extract_rail', 0, 0.32, 0.95, 0.24, 0.83, 'z', False)
    for side, x in [('a', -1.3), ('b', 1.3)]:
        s.bed('cell_' + side, x, -0.7, 3.0, 0.45, 0.99, 'z')
        s.box('assembly_post_' + side, [x + 0.3, 0.93, -0.6], [0.05, 1.86, 0.05], FRAME)
        s.box('assembly_arm_' + side, [x + 0.15, 1.86, -0.6], [0.35, 0.06, 0.08], FRAME)
        s.cyl('assembly_drive_' + side, [x, 1.66, -0.6], 0.048, 0.24, DRIVE)
        s.box('cap_hopper_' + side, [x + 0.38, 1.42, -0.6], [0.22, 0.26, 0.26], LIGHT)
        s.bed('consumer_pickup_' + side, x + (0.85 if side == 'a' else 1.1), -1.8, 2.15 if side == 'a' else 2.7, 0.45, 0.99)
        s.sensor('exit_photo_' + side, [x + 0.29, 1.12, -1.8])
    s.cyl('lower_housing', [0.74, 1.1525, 0], 0.055, 0.28, DRIVE, 'x')
    s.cyl('upper_housing', [0.44, 1.48, 0], 0.055, 0.25, DRIVE, 'x')
    s.cabinet('control', [0.8, 0.5, 1.15])

def draw_magazine(s, f):
    z = f['plant']['physical']
    parts = f['plant']['parts']
    for i, p in parts.items():
        xyz = [p[k] for k in 'xyz']
        if int(i) > 100:
            x, y, zz = xyz
            for dx in [-0.2, 0.2]:
                for dz in [-0.2, 0.2]:
                    s.box(f'mag{i}_post{dx}{dz}', [x + dx, y, zz + dz], [0.025, 0.8, 0.025], FRAME)
            for yy in [1.08, 1.84]:
                for dx in [-0.2, 0.2]:
                    s.box(f'mag{i}_side{dx}{yy}', [x + dx, yy, zz], [0.026, 0.03, 0.39], STEEL)
                for dz in [-0.2, 0.2]:
                    s.box(f'mag{i}_end{dz}{yy}', [x, yy, zz + dz], [0.39, 0.03, 0.026], STEEL)
            for dx in [-0.2, 0.2]:
                for dz in [-0.2, 0.2]:
                    s.box(f'mag{i}_foot{dx}{dz}', [x + dx, 1.0525, zz + dz], [0.05, 0.025, 0.05], STEEL)
            gate = 1 - z['lower'] if int(i) == z['docked'] else 0.0
            for sign in [-1, 1]:
                s.box(f'mag{i}_retainer{sign}', [x + sign * (0.12 + 0.12 * gate), 1.1525, zz], [0.06, 0.035, 0.34], STEEL)
            s.box('mag_tag' + str(i), [x, y + 0.22, zz + 0.222], [0.17, 0.07, 0.012], DRIVE)
        else:
            s.box('part' + str(i), xyz, p['size'], A if p['mag_id'] == 201 else BLUE, material=True, name=f"Equipment{i}Equipment{p['mag_id']}")
            for dx in [-0.11, 0.11]:
                for dz in [-0.11, 0.11]:
                    s.box(f'part{i}_boss{dx}{dz}', add(xyz, [dx, 0.07, dz]), [0.03, 0.04, 0.03], A if p['mag_id'] == 201 else BLUE, material=True)
            s.cyl('cap' + str(i), add(xyz, [0, 0.075, 0]), 0.11, 0.05, LIGHT, visible=p['assembled'], material=True)
    xyz = z['shuttle_xyz']
    s.box('shuttle', [xyz[0], xyz[1] - 0.083, xyz[2]], [0.38, 0.066, 0.38], DRIVE)
    s.box('shuttle_support', [xyz[0], 0.89, xyz[2]], [0.12, 0.08, 0.12], STEEL)
    s.box('lower_fork', [0.36 * (1 - z['lower']), 1.1525, 0], [0.14, 0.035, 0.34], STEEL)
    s.beam('lower_rod', [0.6, 1.1525, 0], [0.36 * (1 - z['lower']) + 0.07, 1.1525, 0], 0.014)
    for sign in [-1, 1]:
        s.box('upper_grip' + str(sign), [sign * (0.22 - 0.055 * z['upper']), 1.48, 0], [0.03, 0.25, 0.23], DRIVE)
    for side, x in [('a', -1.3), ('b', 1.3)]:
        p = next((p for p in parts.values() if p.get('owner') == 'cell_' + side), None)
        py = 1.17 if p and (not p['assembled']) else 1.45
        s.cyl('assembly_head_' + side, [x, py, -0.6], 0.09, 0.05, STEEL)
        s.beam('assembly_rod_' + side, [x, 1.54, -0.6], [x, py + 0.025, -0.6], 0.018)
        s.box('cap_stock_' + side, [x + 0.38, 1.3 + 0.018 * z['caps_used'][side], -0.6], [0.16, 0.1, 0.17], A, visible=z['caps_used'][side] < (3 if side == 'a' else 4))
LAYOUT = {'liquid': layout_liquid, 'weigh': layout_weigh, 'scrap': layout_scrap, 'wrap': layout_wrap, 'magazine': layout_magazine}
DRAW = {'liquid': draw_liquid, 'weigh': draw_weigh, 'scrap': draw_scrap, 'wrap': draw_wrap, 'magazine': draw_magazine}
