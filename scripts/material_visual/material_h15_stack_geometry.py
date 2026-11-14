from .material_station_geometry import STEEL, FRAME, DRIVE, A, BLUE
from .material_process_housings import plinth, backboard, guides

def layout(s):
    for side, x in [('a', -0.45), ('b', 0.45)]:
        plinth(s, 'plate_supply_cell_' + side, x, -0.86, 0.37, 0.92)
        guides(s, 'plate_supply_' + side, x, -0.86, 0.27, 0.87)
        plinth(s, 'stack_lift_cell_' + side, x, 0.45, 0.41, 0.48, top=0.56)
        plinth(s, 'bundle_receiving_cell_' + side, x, 1.45, 0.36, 0.39, top=0.64)
    plinth(s, 'fork_drive_cell', 0, 2.09, 1.54, 0.28, top=0.53)
    for side, x in [('a', -0.45), ('b', 0.45)]:
        s.bed('feed_' + side, x, -0.85, 0.92, 0.28, 0.85, 'z')
        s.box('stack_base_' + side, [x, 0.12, 0.45], [0.4, 0.24, 0.48], FRAME)
        for dx in [-0.15, 0.15]:
            s.beam('stack_guide_' + side + str(dx), [x + dx, 0.2, 0.59], [x + dx, 0.88, 0.59], 0.018, STEEL)
        s.beam('stack_screw_' + side, [x, 0.22, 0.62], [x, 0.88, 0.62], 0.014, DRIVE)
        s.cyl('stack_motor_' + side, [x, 0.31, 0.62], 0.045, 0.14, DRIVE)
        for j, dx in enumerate([-0.09, 0.09]):
            s.box('receiver_' + side + str(j), [x + dx, 0.835, 1.45], [0.03, 0.03, 0.3], STEEL)
            for z in [1.33, 1.57]:
                s.box('receiver_leg_' + side + str(j) + str(z), [x + dx, 0.39, z], [0.03, 0.78, 0.035], FRAME)
        s.box('receiver_cross_' + side, [x, 0.78, 1.45], [0.25, 0.05, 0.045], FRAME)
    for x in [-0.8, 0.8]:
        for z in [-1.15, 0.78]:
            s.box('gantry_post' + str(x) + str(z), [x, 0.92, z], [0.05, 1.84, 0.05], FRAME)
        s.box('gantry_zrail' + str(x), [x, 1.8, -0.185], [0.07, 0.07, 2.0], FRAME)
    for x in [-0.8, 0.8]:
        s.box('fork_railpost' + str(x), [x, 0.33, 2.09], [0.06, 0.66, 0.06], FRAME)
    s.box('fork_xrail', [0, 0.66, 2.09], [1.66, 0.07, 0.08], FRAME)
    s.beam('fork_xscrew', [-0.8, 0.71, 2.09], [0.8, 0.71, 2.09], 0.012, STEEL)
    s.cyl('fork_xmotor', [-0.9, 0.71, 2.09], 0.045, 0.13, DRIVE, 'x')
    s.cabinet('controls', [1.02, 0.52, -0.23])

def draw(s, f):
    q = f['plant']['physical']
    h = q['head']
    s.box('head_xrail', [0, 1.73, h[2]], [1.66, 0.065, 0.07], FRAME)
    s.box('head_carriage', [h[0], 1.68, h[2]], [0.19, 0.08, 0.17], DRIVE)
    s.beam('head_zrod', [h[0], 1.64, h[2]], [h[0], h[1] + 0.02, h[2]], 0.013, STEEL)
    s.box('head_pad', h, [0.16, 0.04, 0.11], DRIVE, name='Equipment')
    for side, x in [('a', -0.45), ('b', 0.45)]:
        y = q['orders'][side]['support']
        for j, dx in enumerate([-0.09, 0.09]):
            s.box('support_' + side + str(j), [x + dx, y - 0.015, 0.45], [0.03, 0.03, 0.26], STEEL)
        s.box('support_carriage_' + side, [x, y - 0.11, 0.59], [0.35, 0.12, 0.06], DRIVE)
        for dx in [-0.09, 0.09]:
            s.box('support_arm_' + side + str(dx), [x + dx, y - 0.055, 0.52], [0.03, 0.08, 0.12], FRAME)
    pos = q['fork']['pos']
    x, y, z = pos
    for j, dx in enumerate([-0.04, 0.04]):
        s.box('fork_tine' + str(j), [x + dx, y - 0.0075, z], [0.035, 0.015, 0.32], STEEL, name='Equipment')
    s.box('fork_spine', [x, y - 0.0075, z + 0.19], [0.25, 0.015, 0.06], DRIVE)
    s.box('fork_zslide', [x, 0.73, (z + 2.0) / 2], [0.055, 0.05, 2.0 - z + 0.06], FRAME)
    s.box('fork_lift', [x, (y + 0.73) / 2, z + 0.19], [0.065, y - 0.73, 0.055], DRIVE)
    s.box('fork_xcarriage', [x, 0.7, 2.09], [0.2, 0.09, 0.18], DRIVE)
    for i, p in f['plant']['parts'].items():
        s.box('part' + str(i), [p[k] for k in 'xyz'], p['size'], A if p['kind'] == 1 else BLUE, material=True, name=('R' if p['kind'] == 1 else 'B') + 'Equipment' + str(i))
