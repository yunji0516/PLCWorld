import math
from .material_station_geometry import STEEL, FRAME, DRIVE, A, BLUE
from .material_process_housings import plinth, backboard, guides

def layout(s):
    plinth(s, 'product_supply_cell', -1.15, 0.9, 0.4, 1.13)
    guides(s, 'product_supply', -1.15, 0.9, 0.285, 1.0)
    for side, x in [('a', -0.65), ('b', 0.65)]:
        plinth(s, 'face_service_cell_' + side, x, 0, 0.35, 0.28)
    plinth(s, 'turnover_cell', 0, 0, 0.61, 0.53, top=0.5)
    plinth(s, 'finished_product_cell', 1.15, 0.91, 0.4, 1.16)
    guides(s, 'finished_product', 1.15, 0.93, 0.285, 1.06)
    s.bed('source', -1.15, 0.9, 1.1, 0.3, 0.85, 'z')
    s.bed('exit', 1.15, 0.87, 1.22, 0.3, 0.85, 'z')
    for side, x in [('a', -0.65), ('b', 0.65)]:
        s.bed(side + '_fixture', x, 0, 0.31, 0.12 if side == 'b' else 0.22, 0.85, 'x')
        if side == 'b':
            x += 0.1
        s.box(side + '_probe_post', [x, 0.68, -0.25], [0.045, 1.36, 0.045], FRAME)
        s.box(side + '_probe_arm', [x, 1.33, -0.22], [0.1, 0.045, 0.2], FRAME)
        s.cyl(side + '_probe_body', [x, 1.21, -0.22], 0.032, 0.19, DRIVE)
    s.box('cradle_base', [0, 0.14, 0], [0.59, 0.28, 0.5], FRAME)
    for x in [-0.22, 0.22]:
        s.box('cradle_column' + str(x), [x, 0.67, 0], [0.055, 0.79, 0.11], FRAME)
        s.cyl('cradle_bearing' + str(x), [x, 1.1, 0], 0.055, 0.045, STEEL, 'x')
        sign = 1 if x > 0 else -1
        s.beam('cradle_stub' + str(x), [x, 1.1, 0], [sign * 0.15, 1.1, 0], 0.023, STEEL)
    s.cyl('cradle_motor', [-0.34, 1.1, 0], 0.07, 0.15, DRIVE, 'x')
    for x in [-1.48, 1.48]:
        for z in [-0.34, 1.57]:
            s.box('head_post' + str(x) + str(z), [x, 0.92, z], [0.05, 1.84, 0.05], FRAME)
        s.box('head_zrail' + str(x), [x, 1.8, 0.615], [0.07, 0.07, 2.0], FRAME)
    s.cabinet('controls', [-0.58, 0.5, 0.68])

def draw(s, f):
    q = f['plant']['physical']
    angle = q['angle']
    keeper_x = 0.83 - 0.08 * q['keeper']
    if q['windowed_keeper']:
        for j, z in enumerate([-0.045, 0.045]):
            s.box('b_keeper' + ('' if j == 0 else '_window'), [keeper_x, 0.88, z], [0.04, 0.02, 0.025], DRIVE)
    else:
        s.box('b_keeper', [keeper_x, 0.88, 0], [0.04, 0.02, 0.1], DRIVE)
    s.cyl('b_keeper_cylinder', [0.89, 0.88, 0], 0.023, 0.08, DRIVE, 'x')
    s.beam('b_keeper_rod', [0.85, 0.88, 0], [keeper_x + 0.02, 0.88, 0], 0.008, STEEL)
    for j, sign in enumerate([-1, 1]):
        s.box('b_jaw' + str(j), [0.65, 0.86, sign * (0.13 - 0.04 * q['b_clamp'])], [0.1, 0.04, 0.02], DRIVE)
        s.box('b_jaw_guide' + str(j), [0.65, 0.78, sign * 0.13], [0.13, 0.04, 0.13], FRAME)

    def rotor(key, p, size, color=STEEL):
        x, y, z = p
        c = math.cos(angle)
        t = math.sin(angle)
        s.box(key, [x, 1.1 + y * c - z * t, y * t + z * c], size, color, rx=angle)
    rotor('cradle_crossbar', [0, -0.1, 0], [0.34, 0.03, 0.1], FRAME)
    for x in [-0.16, 0.16]:
        rotor('cradle_sidearm' + str(x), [x, -0.05, 0], [0.025, 0.1, 0.07], FRAME)
    py = -0.02 - 0.06 * (1 - q['pad'])
    rotor('cradle_pad', [0, py, 0], [0.09, 0.02, 0.065], DRIVE)
    rotor('cradle_pad_actuator', [0, (py - 0.01 - 0.085) / 2, 0], [0.026, max(0.006, py - 0.01 + 0.085), 0.026], STEEL)
    h = q['head']
    s.box('head_xrail', [0, 1.73, h[2]], [3.02, 0.07, 0.07], FRAME)
    s.box('head_carriage', [h[0], 1.68, h[2]], [0.16, 0.08, 0.16], DRIVE)
    s.beam('head_rod', [h[0], 1.64, h[2]], [h[0], h[1] + 0.24, h[2]], 0.012)
    s.box('edge_bridge', [h[0], h[1] + 0.23, h[2]], [0.13, 0.04, 0.29], DRIVE)
    for j, sign in enumerate([-1, 1]):
        offset = 0.095 if q['held'] or (q['job'] and q['job']['phase'] == 'pickup') else 0.135
        s.box('edge_grip' + str(j), [h[0], h[1] + 0.01, h[2] + sign * offset], [0.1, 0.04, 0.03], DRIVE)
        s.box('edge_finger' + str(j), [h[0], h[1] + 0.125, h[2] + sign * offset], [0.022, 0.19, 0.022], STEEL)
    for side, x in [('a', -0.65), ('b', 0.65)]:
        if side == 'b':
            x += 0.1
        j = q['services'][side]
        stroke = math.sin(math.pi * min(1, j['age'] / q['durations'][side])) if j else 0.0
        y = 1.04 - 0.13 * stroke
        z = -0.22 * (1 - min(1, stroke * 4))
        s.cyl(side + '_probe', [x, y, z], 0.012 if side == 'b' else 0.022, 0.02, STEEL)
        s.beam(side + '_probe_slide', [x, y, -0.22], [x, y, z], 0.009)
    for i, p in f['plant']['parts'].items():
        pos = [p[k] for k in 'xyz']
        s.box('part' + str(i), pos, p['size'], A, rx=p['rx'], material=True, name='Equipment' + str(i))
        for face, sign, color in [('a', 1, A), ('b', -1, BLUE)]:
            dy = sign * 0.0106
            s.box('face_' + str(i) + face, [p['x'], p['y'] + dy * math.cos(p['rx']), p['z'] + dy * math.sin(p['rx'])], [0.16, 0.001, 0.09], color, rx=p['rx'], material=True)

def overlap_rx(a, sa, ra, b, sb, rb):
    if abs(a[0] - b[0]) >= (sa[0] + sb[0]) / 2 - 1e-06:
        return False
    ca, ta, cb, tb = (math.cos(ra), math.sin(ra), math.cos(rb), math.sin(rb))
    ay, az = ((ca, ta), (-ta, ca))
    by, bz = ((cb, tb), (-tb, cb))
    delta = (b[1] - a[1], b[2] - a[2])
    dot = lambda x, y: x[0] * y[0] + x[1] * y[1]
    for axis in [ay, az, by, bz]:
        reach = (sa[1] * abs(dot(axis, ay)) + sa[2] * abs(dot(axis, az)) + sb[1] * abs(dot(axis, by)) + sb[2] * abs(dot(axis, bz))) / 2
        if abs(dot(delta, axis)) >= reach - 1e-06:
            return False
    return True
