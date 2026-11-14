import math
from .material_station_geometry import STEEL, FRAME, DRIVE, A, BLUE, LIGHT

def layout(s):
    for name, y in [('upper', 0.85), ('lower', 0.35)]:
        s.bed(name, 0, 0, 1.916, 0.3, y, 'x', legs=False)
    for x in [-0.82, 0, 0.82]:
        for z in [-0.22, 0.22]:
            s.box('framepost' + str(x) + str(z), [x, 0.39, z], [0.045, 0.78, 0.045], FRAME)
        for y in [0.25, 0.75]:
            s.box('framebeam' + str(x) + str(y), [x, y, 0], [0.045, 0.05, 0.48], FRAME)
    for side, x in [('left', -1.2), ('right', 1.2)]:
        s.box(side + '_base', [x, 0.08, 0], [0.6, 0.16, 0.6], FRAME)
        for xx in [x - 0.28, x + 0.28]:
            s.beam(side + '_guide' + str(xx), [xx, 0.17, 0.26], [xx, 1.18, 0.26], 0.023, STEEL)
        s.beam(side + '_screw', [x, 0.18, 0.28], [x, 1.18, 0.28], 0.016, DRIVE)
        s.box(side + '_bridge', [x, 1.17, 0.26], [0.62, 0.05, 0.07], FRAME)
        s.cyl(side + '_drive', [x, 1.27, 0.28], 0.06, 0.16, DRIVE)
    s.bed('product_source', -1.2, -0.85, 1.2, 0.23, 0.85, 'z')
    s.bed('product_exit', 0.6, 1.0, 1.2, 0.23, 0.85, 'z')
    for name, x, z0, z1 in [('input', -1.2, -0.61, 0.3), ('output', 0.6, -0.3, 0.61)]:
        for z in [z0, z1]:
            s.box(name + '_post' + str(z), [x + 0.25, 0.875, z], [0.05, 1.75, 0.05], FRAME)
        s.box(name + '_rail', [x, 1.7, (z0 + z1) / 2], [0.09, 0.09, z1 - z0 + 0.16], FRAME)
        for z in [z0, z1]:
            s.box(name + '_arm' + str(z), [x + 0.1, 1.72, z], [0.35, 0.07, 0.08], FRAME)
    s.box('inspection_post', [-0.4, 0.74, -0.26], [0.05, 1.48, 0.05], FRAME)
    s.box('inspection_arm', [-0.4, 1.45, -0.12], [0.2, 0.06, 0.3], FRAME)
    s.cyl('inspection_body', [-0.4, 1.31, 0], 0.035, 0.22, DRIVE)
    s.cabinet('controls', [1.43, 0.51, -0.65])

def draw(s, f):
    q = f['plant']['physical']
    for side, x in [('left', -1.2), ('right', 1.2)]:
        y = q['lifts'][side]['y']
        s.box(side + '_deck', [x, y - 0.055, 0], [0.46, 0.03, 0.36], STEEL, name='Equipment')
        s.box(side + '_carriage', [x, y - 0.08, 0.25], [0.59, 0.1, 0.075], DRIVE)
        s.box(side + '_saddle', [x, y - 0.06, 0.1], [0.38, 0.06, 0.25], FRAME)
        for z in [-0.165, 0.165]:
            s.box(side + '_bearingrail' + str(z), [x, y - 0.028, z], [0.46, 0.035, 0.025], STEEL)
        for dx in [-0.15, -0.075, 0, 0.075, 0.15]:
            s.cyl(side + '_roller' + str(dx), [x + dx, y - 0.012, 0], 0.012, 0.33, DRIVE, 'z')
        for sign in [-1, 1]:
            s.box(side + '_stop' + str(sign), [x + sign * 0.205, y - 0.045 + 0.055 * q['lifts'][side]['stop'], 0], [0.025, 0.02, 0.24], DRIVE)
    for name in ['input', 'output']:
        tool = q['tools'][name]
        s.box(name + '_carriage', [tool[0], 1.66, tool[2]], [0.17, 0.06, 0.15], DRIVE)
        s.beam(name + '_rod', [tool[0], 1.63, tool[2]], [tool[0], tool[1] + 0.025, tool[2]], 0.017)
        s.cyl(name + '_pad', tool, 0.045, 0.04, DRIVE, name='Equipment')
        s.beam(name + '_hose', [tool[0] + 0.04, 1.64, tool[2]], [tool[0] + 0.04, tool[1] + 0.02, tool[2]], 0.006, BLUE)
    j = q['inspection']
    a = j['age'] / q['inspection_duration'] if j else 0.0
    y = 1.13 - 0.1 * math.sin(math.pi * min(1, a)) if j else 1.13
    s.cyl('inspection_head', [-0.4, y, 0], 0.022, 0.025, STEEL)
    s.beam('inspection_rod', [-0.4, 1.21, 0], [-0.4, y + 0.0125, 0], 0.011)
    for i, p in f['plant']['parts'].items():
        key = 'part' + str(i)
        pos = [p[k] for k in 'xyz']
        jig = int(i) > 100
        s.box(key, pos, p['size'], STEEL if jig else A if int(i) % 2 else BLUE, material=True, name=('Equipment' if jig else 'Equipment') + str(i))
        if jig:
            for z in [-0.1, 0.1]:
                s.box(key + '_locator' + str(z), [p['x'], p['y'] + 0.05, p['z'] + z], [0.18, 0.03, 0.015], DRIVE, material=True)
