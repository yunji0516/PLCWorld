import math
from .material_station_geometry import STEEL, FRAME, DRIVE, A, BLUE
from .scrap_math import TOP, LEADER, TOTAL, along_path, sections

def regions():
    yield ('leader', 0, LEADER, 0.0, 0.2)
    for sign in [-1, 1]:
        yield ('side' + str(sign), LEADER, TOTAL, sign * 0.08, 0.04)
    cursor = LEADER
    for i in range(1, 7):
        u = LEADER + (i - 0.5) * 0.3
        yield ('bridge' + str(i), cursor, u - 0.09, 0.0, 0.12)
        cursor = u + 0.09
    yield ('bridge_end', cursor, TOTAL, 0.0, 0.12)

def strip(s, key, points, width):
    s.node(key, [0, 0, 0], [0.001, width, 0.001], A, 'ribbon', points=points, width_axis=[0, 0, 1], material=True, visible=len(points) > 1)

def samples(a, b, step=0.006):
    n = max(1, math.ceil((b - a) / step))
    return [a + (b - a) * i / n for i in range(n + 1)] if b - a > 1e-08 else []

def region_points(q, a, b, z, wound):
    if wound:
        b = min(b, q['recovered'])
        r = q['reel_radius']
        points = []
        for u in samples(a, b, 0.003):
            ru = math.sqrt(0.05 ** 2 + 0.001 * u / math.pi)
            theta = math.pi / 2 + 2 * math.pi / 0.001 * (r - ru)
            points.append([0.4 + ru * math.cos(theta), TOP - r + ru * math.sin(theta), z])
        return points
    a = max(a, q['recovered'])
    points = []
    for u in samples(a, b):
        point = along_path(LEADER + max(q['fed'], q['recovered']) - u, q['stored'])
        point[2] = z
        points.append(point)
    return points
from .material_process_housings import plinth, backboard, guides

def layout(s):
    plinth(s, 'stock_feed_station', -1.55, 0, 1.75, 0.34)
    guides(s, 'stock_feed', -1.55, 0, 0.245, 1.7, axis='x')
    plinth(s, 'die_station', -0.5, -0.06, 0.35, 0.48, top=0.56)
    plinth(s, 'product_receiver_station', -0.5, 0.98, 0.35, 1.02)
    guides(s, 'product_receiver', -0.5, 0.98, 0.215, 1.0)
    plinth(s, 'rewinder_station', 0.4, 0.1, 0.38, 0.43, top=0.3)
    backboard(s, 'rewinder_guard', 0.4, 0.35, 0.45, lower=0.35, upper=1.05)
    s.cyl('source_pressure_roll', [-0.72, 0.881, 0], 0.03, 0.24, DRIVE, 'z')
    s.cyl('source_nip_motor', [-0.72, 0.881, 0.3], 0.045, 0.14, DRIVE, 'z')
    s.beam('source_nip_shaft', [-0.72, 0.881, -0.15], [-0.72, 0.881, 0.24], 0.014)
    for z in [-0.2, 0.2]:
        s.box('source_nip_post' + str(z), [-0.72, 0.84, z], [0.045, 0.48, 0.045], FRAME)
    s.box('source_nip_bridge', [-0.72, 1.08, 0], [0.065, 0.04, 0.45], FRAME)
    s.bed('source', -1.55, 0, 1.8, 0.25, 0.85, 'x')
    s.bed('exit', -0.5, 0.86, 1.38, 0.25, 0.85, 'z')
    for z in [-0.08, 0.08]:
        s.box('web_side_support' + str(z), [-0.425, 0.8325, z], [0.45, 0.035, 0.035], FRAME)
    for x in [-0.63, -0.37]:
        s.box('bed_bridge' + str(x), [x, 0.8325, 0], [0.04, 0.035, 0.125], STEEL)
    s.box('bed_base', [-0.5, 0.24, 0], [0.3, 0.48, 0.27], FRAME)
    s.cyl('bed_cylinder', [-0.5, 0.64, 0], 0.025, 0.25, DRIVE)
    for side, x, angle in [('left', -0.185, 0), ('right', 0.025, 0)]:
        s.cyl('fixed_guide_' + side, [x, TOP - 0.035, 0], 0.0344, 0.22, DRIVE, 'z')
        s.beam('fixed_guide_shaft_' + side, [x, TOP - 0.035, 0], [x, TOP - 0.035, 0.21], 0.012)
    for x in [-0.25, 0.09]:
        s.beam('dancer_rail' + str(x), [x, 0.3, 0.18], [x, 0.81, 0.18], 0.014)
        s.box('dancer_post' + str(x), [x, 0.4, 0.23], [0.035, 0.8, 0.035], FRAME)
    s.box('recovery_base', [0.4, 0.12, 0.1], [0.35, 0.24, 0.42], FRAME)
    s.box('recovery_post', [0.4, 0.52, 0.22], [0.05, 0.7, 0.05], FRAME)
    for x in [-0.75, -0.25]:
        s.box('tool_post' + str(x), [x, 0.74, -0.3], [0.04, 1.48, 0.04], FRAME)
    s.box('die_xbeam', [-0.5, 1.45, -0.3], [0.56, 0.06, 0.07], FRAME)
    for x in [-0.68, -0.32]:
        s.box('die_zrail' + str(x), [x, 1.38, -0.16], [0.035, 0.04, 0.42], FRAME)
    s.box('pick_bridge', [-0.5, 1.53, 0.07], [0.08, 0.07, 0.62], FRAME)
    s.box('pick_support', [-0.78, 1.51, 0.05], [0.52, 0.045, 0.06], FRAME)
    s.cabinet('controls', [-1.03, 0.48, 0.56])

def draw(s, f):
    q = f['plant']['physical']
    y = q['bed']
    s.box('product_pad', [-0.5, y - 0.018, 0], [0.18, 0.036, 0.12], STEEL)
    s.beam('bed_rod', [-0.5, 0.7, 0], [-0.5, y - 0.018, 0], 0.016)
    for j, z in enumerate([-0.08, 0.08]):
        s.box('clamp' + str(j), [-0.5, 0.861 + 0.07 * (1 - q['clamp']), z], [0.16, 0.02, 0.035], DRIVE)
    c = q['cutter']
    age = c['age'] if c else 0.0
    dy = 1.12
    dz = -0.28
    if c:
        if age < 0.1:
            dz = -0.28 * (1 - age / 0.1)
        elif age < 0.5:
            dz = 0.0
            dy = 1.12 - 0.2495 * math.sin(math.pi * (age - 0.1) / 0.4)
        else:
            dz = -0.28 * min(1, (age - 0.5) / 0.1)
    for j, dx in enumerate([-0.0905, 0.0905]):
        s.box('die_x' + str(j), [-0.5 + dx, dy, dz], [0.001, 0.04, 0.122], STEEL)
    for j, zz in enumerate([-0.0605, 0.0605]):
        s.box('die_z' + str(j), [-0.5, dy, dz + zz], [0.18, 0.04, 0.001], STEEL)
    for x in [-0.62, -0.38]:
        s.box('die_frame' + str(x), [x, dy + 0.06, dz], [0.025, 0.1, 0.2], FRAME)
    s.box('die_back', [-0.5, dy + 0.06, dz - 0.09], [0.22, 0.1, 0.02], FRAME)
    s.box('die_carriage', [-0.5, 1.33, dz], [0.42, 0.06, 0.14], DRIVE)
    h = q['head']
    s.cyl('vacuum_pad', h, 0.04, 0.05, DRIVE)
    s.beam('vacuum_rod', [h[0], 1.48, h[2]], [h[0], h[1] + 0.025, h[2]], 0.012)
    s.box('pick_carriage', [h[0], 1.48, h[2]], [0.15, 0.055, 0.13], DRIVE)
    dancer = sections(q['stored'])[2][3][1]
    s.cyl('dancer_roll', [-0.08, dancer, 0], 0.0694, 0.22, DRIVE, 'z')
    s.beam('dancer_axle', [-0.08, dancer, -0.13], [-0.08, dancer, 0.23], 0.014)
    s.box('dancer_carriage', [-0.08, dancer, 0.2], [0.39, 0.05, 0.04], FRAME)
    r = q['reel_radius']
    s.node('recovery_core', [0.4, TOP - r, 0], [0.0495, 0.22, 0.035], STEEL, 'tube', rx=math.pi / 2)
    s.beam('recovery_shaft', [0.4, TOP - r, -0.13], [0.4, TOP - r, 0.25], 0.024)
    s.cyl('recovery_drive', [0.4, TOP - r, 0.28], 0.06, 0.1, DRIVE, 'z')
    for key, a, b, z, width in regions():
        strip(s, 'moving_' + key, region_points(q, a, b, z, False), width)
        strip(s, 'wound_' + key, region_points(q, a, b, z, True), width)
    for i, p in f['plant']['parts'].items():
        s.box('part' + str(i), [p[k] for k in 'xyz'], p['size'], BLUE, material=True, name='Equipment' + str(i))

def material_solids(f):
    return [(i, [p[k] for k in 'xyz'], p['size']) for i, p in f['plant']['parts'].items()]
