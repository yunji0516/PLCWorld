from .material_station_geometry import STEEL, FRAME, DRIVE, A, BLUE

def walls(p):
    x, y, z = [p[k] for k in 'xyz']
    h = p['aperture']
    bottom = 0.85
    return [('bottom', [x, bottom + 0.0005, z], [0.124, 0.001, 0.36]), ('top', [x, bottom + 0.001 + h + 0.0005, z], [0.124, 0.001, 0.36]), ('left', [x - 0.0615, bottom + 0.001 + h / 2, z], [0.001, h, 0.36]), ('right', [x + 0.0615, bottom + 0.001 + h / 2, z], [0.001, h, 0.36]), ('back', [x, bottom + 0.001 + h / 2, z + 0.1795], [0.122, h, 0.001])]

def material_solids(f):
    solids = []
    for i, p in f['plant']['parts'].items():
        if p['kind'] == 'pouch':
            solids.extend(((str(i) + '_' + name, pos, size) for name, pos, size in walls(p)))
        else:
            solids.append((str(i), [p[k] for k in 'xyz'], p['size']))
    return solids
from .material_process_housings import plinth, backboard, guides

def layout(s):
    plinth(s, 'pouch_supply_cell', -0.65, 1.09, 0.39, 1.65)
    guides(s, 'pouch_magazine', -0.65, 1.11, 0.19, 1.45)
    plinth(s, 'content_supply_cell', 0.7, -0.72, 0.68, 0.72)
    plinth(s, 'insertion_cell', 0, -0.56, 0.24, 0.78)
    plinth(s, 'package_receiver', 0, 1.1, 0.38, 1.62)
    guides(s, 'package_out', 0, 1.12, 0.19, 1.43)
    backboard(s, 'content_guard', 0.7, -1.17, 0.83)
    s.bed('pouch_feed', -0.65, 1.07, 1.71, 0.24, 0.85, 'z')
    s.bed('exit', 0, 1.07, 1.71, 0.24, 0.85, 'z')
    s.bed('insertion_support', 0, -0.495, 0.63, 0.125, 0.851, 'z')
    for x in [-0.9, 0.25]:
        for z in [-0.13, 0.13]:
            s.box('cart_leg' + str(x) + str(z), [x, 0.35, z], [0.045, 0.7, 0.045], FRAME)
    for z in [-0.13, 0.13]:
        s.beam('cart_rail' + str(z), [-0.9, 0.72, z], [0.25, 0.72, z], 0.019, STEEL)
    s.beam('cart_screw', [-0.9, 0.7, 0], [0.25, 0.7, 0], 0.012, DRIVE)
    s.cyl('cart_motor', [-0.97, 0.7, 0], 0.045, 0.12, DRIVE, 'x')
    for i in range(4):
        x = 0.55 + 0.3 * (i % 2)
        z = -0.55 - 0.36 * (i // 2)
        s.bed('content_pocket' + str(i), x, z, 0.28, 0.16, 0.851, 'z')
    for x in [-0.18, 1.13]:
        for z in [-1.12, -0.31]:
            s.box('pick_post' + str(x) + str(z), [x, 0.85, z], [0.035, 1.7, 0.035], FRAME)
        s.box('pick_zrail' + str(x), [x, 1.66, -0.72], [0.045, 0.05, 0.9], FRAME)
    s.box('pusher_body', [0, 0.87, -0.98], [0.09, 0.08, 0.24], DRIVE)
    s.cyl('pusher_motor', [0, 0.87, -1.13], 0.04, 0.12, DRIVE, 'z')
    s.cabinet('controls', [-1.01, 0.52, -0.57])

def draw(s, f):
    q = f['plant']['physical']
    x = q['cart']
    s.box('pouch_deck', [x, 0.835, 0.0155], [0.27, 0.03, 0.389], STEEL)
    s.box('pouch_carriage', [x, 0.78, 0.0155], [0.23, 0.08, 0.31], DRIVE)
    for side, dx in [('left', -0.045), ('right', 0.045)]:
        outside = -0.16 if side == 'left' else 0.16
        s.box('vac_post_' + side, [x + outside, 0.94, 0], [0.025, 0.24, 0.035], FRAME)
        s.box('vac_arm_' + side, [x + (outside + dx) / 2, 1.05, -0.14], [abs(outside - dx) + 0.025, 0.025, 0.045], FRAME)
        p = f['plant']['parts'].get(str(q['pouch']), f['plant']['parts'].get(q['pouch'])) if q['pouch'] else None
        top = 0.852 + (p['aperture'] if p else 0.002)
        y = top + 0.01
        s.cyl('vac_' + side, [x + dx, y, -0.14], 0.018, 0.02, DRIVE)
        s.beam('vac_rod_' + side, [x + dx, 1.05, -0.14], [x + dx, y + 0.01, -0.14], 0.008)
    h = q['tool']
    s.box('pick_xrail', [(1.13 - 0.18) / 2, 1.6, h[2]], [1.37, 0.05, 0.045], FRAME)
    s.box('pick_carriage', [h[0], 1.54, h[2]], [0.13, 0.07, 0.12], DRIVE)
    s.beam('pick_rod', [h[0], 1.5, h[2]], [h[0], h[1] + 0.015, h[2]], 0.011)
    s.box('content_pad', h, [0.07, 0.03, 0.1], DRIVE)
    s.box('pusher', [0, 0.862, q['pusher']], [0.08, 0.02, 0.025], DRIVE)
    s.beam('pusher_rod', [0, 0.862, -0.87], [0, 0.862, q['pusher'] - 0.0125], 0.008)
    for i, p in f['plant']['parts'].items():
        if p['kind'] == 'pouch':
            s.box('part' + str(i), [p[k] for k in 'xyz'], p['size'], A, material=True, visible=False)
            for name, pos, size in walls(p):
                s.box('pouch' + str(i) + '_' + name, pos, size, A, material=True, opacity=0.45 if name == 'top' else 1.0, name='Equipment' + str(i) + ' ' + name)
        else:
            s.box('part' + str(i), [p[k] for k in 'xyz'], p['size'], BLUE, material=True, name='Equipment' + str(p['order']))
