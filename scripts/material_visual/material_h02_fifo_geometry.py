import math
from .material_station_geometry import STEEL, FRAME, DRIVE, A, BLUE, LIGHT
from .material_process_housings import plinth, backboard, guides

def layout(s):
    plinth(s, 'fifo_cell', -1.1, 1.55, 0.43, 1.85)
    guides(s, 'fifo', -1.1, 1.48, 0.27, 2.1)
    for j, x in enumerate([-0.55, 0.0]):
        plinth(s, 'bypass_cell' + str(j), x, 0.47, 0.39, 0.53)
        guides(s, 'bypass' + str(j), x, 0.47, 0.27, 0.5)
    for side, x in [('a', 0.55), ('b', 1.1)]:
        plinth(s, 'assembly_cell_' + side, x, 0.54, 0.43, 0.58)
        backboard(s, 'assembly_guard_' + side, x, 0.7, 0.44, lower=1.13, upper=1.72)
        plinth(s, 'receiver_cell_' + side, x, 1.77, 0.43, 1.05)
        guides(s, 'kit_receiving_' + side, x, 1.77, 0.28, 0.98)
    s.bed('source', -1.1, 1.42, 2.46, 0.32, 0.85, 'z')
    for j, x in enumerate([-0.55, 0.0]):
        s.bed('slot' + str(j), x, 0.46, 0.54, 0.32, 0.85, 'z')
    for side, x in [('a', 0.55), ('b', 1.1)]:
        s.bed('out_' + side, x, 1.25, 2.12, 0.32, 0.85, 'z')
        s.box('joiner_post_' + side, [x + 0.225, 0.775, 0.42], [0.045, 1.55, 0.055], FRAME)
        s.box('joiner_arm_' + side, [x + 0.105, 1.525, 0.42], [0.285, 0.05, 0.16], FRAME)
        s.cyl('joiner_cylinder_' + side, [x, 1.36, 0.42], 0.04, 0.24, DRIVE)
    for z in [-0.13, 0.13]:
        s.beam('deck_rail' + str(z), [-1.4, 0.72, z], [1.4, 0.72, z], 0.022, STEEL)
        for x in [-1.4, 1.4]:
            s.box('deck_post' + str(x) + str(z), [x, 0.36, z], [0.06, 0.72, 0.06], FRAME)
    s.cyl('deck_drive', [-1.49, 0.72, 0], 0.07, 0.16, DRIVE, 'x')
    s.beam('deck_ballscrew', [-1.41, 0.69, 0], [1.38, 0.69, 0], 0.016, DRIVE)
    s.cabinet('controls', [-1.5, 0.52, -0.43])

def draw(s, f):
    q = f['plant']['physical']
    x = q['cart_x']
    s.box('deck', [x, 0.825, 0], [0.38, 0.05, 0.36], STEEL, name='Equipment')
    s.box('deck_saddle', [x, 0.755, 0], [0.25, 0.07, 0.3], DRIVE)
    s.cyl('deck_belt_motor', [x + 0.23, 0.79, 0.145], 0.038, 0.1, DRIVE, 'x', name='Equipment')
    for z in [-0.145, 0.145]:
        s.cyl('deck_belt_roller' + str(z), [x, 0.812, z], 0.034, 0.38, STEEL, 'x')
    for side, x in [('a', 0.55), ('b', 1.1)]:
        age = q['kits'][side]['close_age']
        duration = q['close_duration'][side]
        stroke = math.sin(math.pi * min(1, age / duration)) if age is not None else 0.0
        y = 1.18 - 0.2175 * stroke
        s.box('head_' + side, [x, y, 0.42], [0.24, 0.025, 0.4], DRIVE, name=side.upper() + 'Equipment')
        s.beam('head_rod_' + side, [x, 1.24, 0.42], [x, y + 0.0125, 0.42], 0.015)
    for i, p in f['plant']['parts'].items():
        s.box('part' + str(i), [p[k] for k in 'xyz'], p['size'], A if p['kind'] == 1 else BLUE, material=True, name=('R' if p['kind'] == 1 else 'B') + 'Equipment' + str(i))
