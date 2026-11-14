import math
from .material_station_geometry import STEEL, FRAME, DRIVE, A, BLUE
from .material_h11_faces_geometry import overlap_rx

def rotate(p, dx, dy, dz):
    a = p['yaw']
    return [p['x'] + dx * math.cos(a) - dz * math.sin(a), p['y'] + dy, p['z'] + dx * math.sin(a) + dz * math.cos(a)]

def body_solids(p):
    yield ('base', rotate(p, 0, -0.0225, 0), [0.14, 0.035, 0.14])
    for side, sign in [('left', -1), ('right', 1)]:
        yield (side, rotate(p, sign * 0.04875, 0.0175, 0), [0.0425, 0.045, 0.14])
    for side, sign in [('front', -1), ('back', 1)]:
        yield (side, rotate(p, 0, 0.0175, sign * 0.04875), [0.055, 0.045, 0.0425])

def material_boxes(raw):
    boxes = []
    for i, p in raw['plant']['parts'].items():
        if p['kind'] == 'body':
            boxes.extend(((str(i) + name, pos, size, p['yaw']) for name, pos, size in body_solids(p)))
        else:
            boxes.append((str(i), [p[k] for k in 'xyz'], p['size'], p['yaw']))
    return boxes
from .material_process_housings import plinth, backboard, guides

def layout(s):
    plinth(s, 'loader_cell', 1.12, 0, 0.64, 0.51)
    plinth(s, 'insert_supply_cell', 0, 1.01, 0.59, 0.56)
    plinth(s, 'inspection_cell', -0.72, 0, 0.34, 0.49)
    plinth(s, 'assembly_out_cell', 0, -1.38, 0.39, 1.16)
    guides(s, 'assembly_out', 0, -1.4, 0.2, 1.02)
    backboard(s, 'loader_guard', 1.12, 0.42, 0.75)
    backboard(s, 'insert_guard', 0, 1.4, 0.82)
    for j in range(8):
        a = j * math.pi / 4
        x = 0.49 * math.cos(a)
        z = 0.49 * math.sin(a)
        s.box('index_drive_panel' + str(j), [x, 0.38, z], [0.4, 0.54, 0.018], STEEL, r=-a + math.pi / 2)
        s.box('index_frame' + str(j), [0.53 * math.cos(a + math.pi / 8), 0.4, 0.53 * math.sin(a + math.pi / 8)], [0.035, 0.75, 0.035], FRAME)
    s.cyl('table_pedestal', [0, 0.39, 0], 0.25, 0.78, FRAME)
    s.cyl('stationary_hub', [0, 0.81, 0], 0.195, 0.08, STEEL)
    s.bed('body_supply', 1.1, 0, 0.61, 0.45, 0.85, 'x')
    s.bed('insert_supply', 0, 0.99, 0.5, 0.38, 0.85, 'x')
    s.bed('exit', 0, -1.3225, 1.395, 0.22, 0.85, 'z')
    s.box('insert_stage', [0, 1.145, 0.8], [0.11, 0.03, 0.11], STEEL)
    s.box('insert_stage_post', [0, 1.0, 0.8], [0.035, 0.26, 0.035], FRAME)
    for z in [-0.34, 0.34]:
        s.box('load_post' + str(z), [1.48, 0.77, z], [0.045, 1.54, 0.045], FRAME)
    s.box('load_crossbeam', [1.48, 1.51, 0], [0.055, 0.055, 0.75], FRAME)
    for z in [-0.27, 0.27]:
        s.box('load_xrail' + str(z), [0.9, 1.53, z], [1.25, 0.06, 0.045], FRAME)
    for x in [-0.35, 0.35]:
        s.box('insert_post' + str(x), [x, 0.79, 1.32], [0.045, 1.58, 0.045], FRAME)
        s.box('insert_zrail' + str(x), [x, 1.55, 0.79], [0.05, 0.06, 1.1], FRAME)
    s.box('probe_post', [-0.8, 0.67, 0], [0.05, 1.34, 0.05], FRAME)
    s.box('probe_arm', [-0.6, 1.31, 0], [0.44, 0.045, 0.08], FRAME)
    s.cyl('probe_body', [-0.42, 1.19, 0], 0.03, 0.18, DRIVE)
    s.box('eject_motor', [0, 0.9, -0.095], [0.1, 0.08, 0.11], DRIVE)
    s.box('eject_mount', [0, 0.865, -0.08], [0.13, 0.03, 0.14], STEEL)
    s.cyl('pin_body', [-0.22, 0.63, 0], 0.035, 0.15, DRIVE)
    s.cabinet('controls', [-0.95, 0.49, 0.68])

def draw(s, f):
    q = f['plant']['physical']
    angle = q['angle']
    s.node('table_ring', [0, 0.81, 0], [0.62, 0.08, 0.2], STEEL, 'tube', r=-angle)
    s.cyl('index_pin', [-0.22, 0.735 + 0.07 * q['lock'], 0], 0.014, 0.055, DRIVE)
    for j in range(4):
        a = angle + j * math.pi / 2
        x = 0.42 * math.cos(a)
        z = 0.42 * math.sin(a)
        for sign in [-1, 1]:
            s.box('pocket' + str(j) + 'guide' + str(sign), [x - sign * 0.084 * math.sin(a), 0.865, z + sign * 0.084 * math.cos(a)], [0.2, 0.03, 0.015], DRIVE, r=-a)
    for name in ['load', 'insert']:
        h = q['tools'][name]
        if name == 'load':
            s.box('load_carriage', [h[0], 1.46, h[2]], [0.17, 0.07, 0.15], DRIVE)
            s.box('load_yrail', [h[0], 1.49, 0], [0.05, 0.04, 0.61], FRAME)
        else:
            s.box('insert_carriage', [h[0], 1.46, h[2]], [0.13, 0.065, 0.12], DRIVE)
            s.box('insert_xrail', [0, 1.51, h[2]], [0.75, 0.045, 0.04], FRAME)
        offset = 0.04 if name == 'load' else 0.025
        s.beam(name + '_rod', [h[0], 1.42, h[2]], [h[0], h[1] + offset, h[2]], 0.012)
        s.cyl(name + '_pad', h, 0.045 if name == 'load' else 0.018, offset * 2, DRIVE)
    j = q['inspect_job']
    stroke = math.sin(math.pi * j['age'] / q['inspect_s']) if j else 0.0
    y = 1.1 - 0.165 * stroke
    s.cyl('probe', [-0.42, y, 0], 0.02, 0.02, STEEL)
    s.beam('probe_rod', [-0.42, 1.12, 0], [-0.42, y + 0.01, 0], 0.01)
    s.box('pusher', [0, 0.89, q['pusher']], [0.09, 0.06, 0.05], DRIVE)
    s.beam('pusher_rod', [0, 0.89, -0.15], [0, 0.89, q['pusher'] + 0.025], 0.016)
    for i, p in f['plant']['parts'].items():
        if p['kind'] == 'body':
            s.box('part' + str(i), [p[k] for k in 'xyz'], p['size'], A, material=True, visible=False)
            for name, pos, size in body_solids(p):
                s.box('body' + str(i) + name, pos, size, A, material=True, r=-p['yaw'])
        else:
            s.box('part' + str(i), [p[k] for k in 'xyz'], p['size'], BLUE, material=True, r=-p['yaw'], name='Equipment' + str(i))

def overlap_y(a, sa, ra, b, sb, rb):
    return overlap_rx([a[1], a[0], a[2]], [sa[1], sa[0], sa[2]], ra, [b[1], b[0], b[2]], [sb[1], sb[0], sb[2]], rb)
