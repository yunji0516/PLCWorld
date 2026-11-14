import math
from .material_station_geometry import STEEL, FRAME, DRIVE, A, BLUE
from .web_math import TOP, R, CUT_X, SURFACE

def strip(s, key, points, width, color, **kw):
    s.node(key, [0, 0, 0], [0.001, width, 0.001], color, 'ribbon', points=points, width_axis=[0, 0, 1], **kw)
from .material_process_housings import plinth

def layout(s):
    plinth(s, 'unwind_cell', -1.2, 0, 0.62, 0.54, top=0.65)
    for sign in [-1, 1]:
        s.box('dancer_side_skin' + str(sign), [sign * 0.275, 0.38, 0.02], [0.018, 0.52, 0.42], STEEL)
        s.box('dancer_lower_frame' + str(sign), [0, 0.105, 0.02 + sign * 0.21], [0.56, 0.05, 0.035], FRAME)
        s.box('dancer_inspection_window' + str(sign), [0, 0.435, 0.02 + sign * 0.21], [0.52, 0.6, 0.008], STEEL, opacity=0.12)
    plinth(s, 'cutter_cell', 0.38, 0, 0.34, 0.42, top=0.7)
    for side, sign in [('a', 1), ('b', -1)]:
        plinth(s, 'order_receiver_' + side, 0.955, sign * 0.745, 1.2, 1.05, top=0.76)
        s.box('order_mark_' + side, [0.955, 0.61, sign * 1.283], [0.25, 0.1, 0.008], A if side == 'a' else BLUE)
    s.box('source_base', [-1.2, 0.08, 0], [0.36, 0.16, 0.44], FRAME)
    s.box('source_post', [-1.2, 0.45, 0.14], [0.05, 0.74, 0.05], FRAME)
    s.beam('source_spindle', [-1.2, 0.8, -0.09], [-1.2, 0.8, 0.23], 0.02, STEEL)
    s.cyl('source_motor', [-1.2, 0.8, 0.27], 0.055, 0.12, DRIVE, 'z')
    for x in [-0.21, 0.21]:
        s.box('dancer_post' + str(x), [x, 0.51, 0.15], [0.04, 1.02, 0.04], FRAME)
        s.beam('dancer_guide' + str(x), [x, 0.15, 0.11], [x, 0.95, 0.11], 0.013, STEEL)
    for x in [-1.46, -0.95]:
        for z in [-0.2, 0.2]:
            s.box('unwind_guard_post' + str(x) + str(z), [x, 0.65, z], [0.035, 1.3, 0.035], FRAME)
        s.box('unwind_guard_top' + str(x), [x, 1.3, 0], [0.035, 0.035, 0.44], FRAME)
    s.box('unwind_back', [-1.205, 0.72, 0.23], [0.53, 0.88, 0.018], STEEL, opacity=0.35)
    s.box('dancer_base', [0, 0.075, 0.05], [0.54, 0.15, 0.38], FRAME)
    for name, x in [('feed', -0.105), ('pull', 0.105)]:
        s.cyl(name + '_roll', [x, TOP, 0], 0.0345, 0.15, DRIVE, 'z')
        s.cyl(name + '_motor', [x, TOP, 0.25], 0.045, 0.12, DRIVE, 'z')
        s.beam(name + '_shaft', [x, TOP, 0], [x, TOP, 0.21], 0.012, STEEL)
    s.cyl('feed_pressure', [-0.035, TOP, 0], 0.0345, 0.14, STEEL, 'z')
    s.cyl('pull_pressure', [0.19, SURFACE + 0.0355, 0], 0.0345, 0.14, STEEL, 'z')
    s.bed('fixed_web', 0.25, 0, 0.3, 0.15, SURFACE - 0.0005, 'x')
    s.bed('exit', 0.955, 0, 0.4, 1.13, SURFACE - 0.0005, 'z')
    for side, sign in [('a', 1), ('b', -1)]:
        s.bed('receiver_' + side, 0.955, sign * 0.745, 1.08, 1.13, SURFACE - 0.0005, 'z')
        s.box('receiver_end_' + side, [0.955, 1.015, sign * 1.29], [1.2, 0.15, 0.035], FRAME)
        for x in [0.34, 1.57]:
            s.box('receiver_rail_' + side + str(x), [x, 0.96, sign * 0.745], [0.025, 0.08, 1.08], STEEL)
    for z in [-0.12, 0.12]:
        s.box('cutter_post' + str(z), [CUT_X - 0.05, 1.0, z], [0.035, 0.3, 0.035], FRAME)
    s.box('cutter_bridge', [CUT_X, 1.15, 0], [0.1, 0.05, 0.29], FRAME)
    s.cyl('cutter_drive', [CUT_X, 1.23, 0], 0.035, 0.12, DRIVE)
    s.box('holder_support', [0.3, 1.09, -0.14], [0.035, 0.25, 0.04], FRAME)
    s.box('holder_arm', [0.3, 1.21, -0.04], [0.09, 0.05, 0.23], FRAME)
    s.cabinet('controls', [-0.72, 0.48, 0.68])

def draw(s, f):
    q = f['plant']['physical']
    r = q['reel']['radius']
    s.cyl('source_core', [-1.2, 0.8, 0], 0.05, 0.16, STEEL, 'z')
    s.cyl('source_wound', [-1.2, 0.8, 0], r, 0.12, A, 'z', material=True)
    for z in [-0.072, 0.072]:
        s.cyl('source_flange' + str(z), [-1.2, 0.8, z], 0.105, 0.009, STEEL, 'z')
    strip(s, 'source_lead', q['reel']['path'], 0.12, A, material=True)
    y = q['dancer_y']
    s.cyl('dancer_roll', [0, y, 0], R - 0.0005, 0.15, DRIVE, 'z')
    s.beam('dancer_axle', [0, y, -0.09], [0, y, 0.18], 0.014, STEEL)
    s.box('dancer_carriage', [0, y, 0.17], [0.46, 0.05, 0.05], FRAME)
    strip(s, 'stored_web', q['web'], 0.12, A, material=True)
    path = [[0.105 + 0.035 * math.cos(math.pi - i * math.pi / 64), TOP + 0.035 * math.sin(math.pi - i * math.pi / 64), 0] for i in range(33)] + [[CUT_X, SURFACE, 0]]
    strip(s, 'fixed_output_web', path, 0.12, A, material=True)
    hy = SURFACE + 0.0005 + 0.0125 + 0.065 * (1 - q['holder'])
    s.box('holder', [0.3, hy, 0], [0.06, 0.025, 0.14], DRIVE)
    s.beam('holder_rod', [0.3, 1.18, 0], [0.3, hy + 0.0125, 0], 0.009)
    age = q['cutter']['age'] if q['cutter'] else 0.0
    stroke = math.sin(math.pi * age / 0.6) if q['cutter'] else 0.0
    ky = 1.07 - 0.14 * stroke
    s.box('knife', [CUT_X, ky, 0], [0.003, 0.05, 0.15], STEEL)
    s.beam('knife_rod', [CUT_X, 1.16, 0], [CUT_X, ky + 0.025, 0], 0.012)
    for i, p in f['plant']['parts'].items():
        s.box('part' + str(i), [p[k] for k in 'xyz'], p['size'], A if p['side'] == 'a' else BLUE, material=True, visible=p['length'] > 1e-06, name='Equipment' + str(i))
