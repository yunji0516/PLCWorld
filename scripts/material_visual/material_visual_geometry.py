"""Open fork channels and real punched apertures, projected from v15 raw states."""
import math
from . import material_station_geometry as g
from .material_station_geometry import STEEL, FRAME, DRIVE, A, BLUE, BELT, add
from .hole_math import hole_z

def remove(s, *prefixes):
    for k in list(s.nodes):
        if any((k.startswith(p) for p in prefixes)):
            if s.dynamic:
                s.poses.setdefault(k, dict(p=s.nodes[k]['p'], r=0, s=s.nodes[k]['size']))['visible'] = False
            else:
                s.nodes.pop(k)

def plate(s, key, c, size, holes, color, material=False):
    w, h, d = size
    xs = sorted(set([-w / 2, w / 2] + [v for x, z, a, b in holes for v in [x - a / 2, x + a / 2]]))
    zs = sorted(set([-d / 2, d / 2] + [v for x, z, a, b in holes for v in [z - b / 2, z + b / 2]]))
    for i, (x0, x1) in enumerate(zip(xs, xs[1:])):
        for j, (z0, z1) in enumerate(zip(zs, zs[1:])):
            x = (x0 + x1) / 2
            z = (z0 + z1) / 2
            if any((abs(x - hx) < a / 2 - 1e-09 and abs(z - hz) < b / 2 - 1e-09 for hx, hz, a, b in holes)):
                continue
            s.box(f'{key}_{i}_{j}', add(c, [x, 0, z]), [x1 - x0, h, z1 - z0], color, material=material)

def belt_hardware(s):
    for key, motor in list(s.nodes.items()):
        if not key.endswith('_motor'):
            continue
        base = key[:-6]
        surface = s.nodes.get(base + '_surface')
        if not surface:
            continue
        x, y, z = surface['p']
        w, h, d = surface['size']
        top = y + h / 2
        mx, my, mz = motor['p']
        s.box(base + '_motor_mount', [mx, (my + top - 0.035) / 2, mz], [0.055, top - 0.035 - my, 0.055], STEEL)
        if abs(mz - z) > d / 2:
            edge = z + d / 2
            s.box(base + '_motor_ear', [mx, top - 0.0475, (edge + mz) / 2], [0.09, 0.025, mz - edge + 0.055], STEEL)
        along_x = w > d
        for sign in [-1, 1]:
            if along_x:
                s.box(base + '_frame_channel' + str(sign), [x, top - 0.065, z + sign * (d / 2 - 0.01)], [w, 0.06, 0.02], STEEL)
            else:
                s.box(base + '_frame_channel' + str(sign), [x + sign * (w / 2 - 0.01), top - 0.065, z], [0.02, 0.06, d], STEEL)

def layout_magazine(s):
    g.layout_magazine(s)
    remove(s, 'magazine_exchange', 'undock_cross', 'undock_return', 'empty_return', 'cell_a', 'cell_b', 'shuttle_rail', 'extract_rail', 'exit_photo', 'assembly_', 'cap_hopper', 'cap_stock')
    for sign in [-1, 1]:
        s.bed('cassette_rail' + str(sign), sign * 0.2, 1.0, 2.8, 0.06, 0.98, 'z', False)
        s.bed('cassette_cross' + str(sign), -0.5, 1.0 + sign * 0.2, 1.42, 0.06, 0.98, 'x', False)
        s.bed('cassette_return' + str(sign), -1.0 + sign * 0.2, 1.4, 1.2, 0.06, 0.98, 'z', False)
        s.bed('cassette_out' + str(sign), -1.5, 1.8 + sign * 0.2, 2.1, 0.06, 0.98, 'x', False)
    for x, z in [(-0.3, 2.1), (0.3, 2.1), (-0.3, -0.25), (0.3, -0.25), (-2.45, 1.5), (-2.45, 2.1), (-1.3, 1.05)]:
        s.box('cassette_leg' + str((x, z)), [x, 0.5, z], [0.05, 1.0, 0.05], FRAME)
    for sign in [-1, 1]:
        s.box('shuttle_xrail' + str(sign), [0, 0.815, -0.65 + sign * 0.055], [3.15, 0.03, 0.025], STEEL)
        s.box('shuttle_zrail' + str(sign), [sign * 0.055, 0.815, -0.325], [0.025, 0.03, 0.65], STEEL)
    s.box('shuttle_base', [0, 0.765, -0.65], [3.15, 0.07, 0.19], FRAME)
    for x in [-1.5, 1.5]:
        s.box('shuttle_leg' + str(x), [x, 0.38, -0.65], [0.06, 0.76, 0.09], FRAME)
    for side, x in [('a', -1.3), ('b', 1.3)]:
        s.sensor('exit_photo_' + side, [x, 1.12, -2.08])
        s.box('assembly_post_' + side, [x + 0.3, 0.93, -1.3], [0.05, 1.86, 0.05], FRAME)
        s.box('assembly_arm_' + side, [x + 0.15, 1.86, -1.3], [0.35, 0.06, 0.08], FRAME)
        s.cyl('assembly_drive_' + side, [x, 1.66, -1.3], 0.048, 0.24, DRIVE)
        s.box('cap_hopper_' + side, [x + 0.38, 1.42, -1.3], [0.22, 0.26, 0.26], STEEL)
        for sign in [-1, 1]:
            s.bed('split_cell_' + side + str(sign), x + sign * 0.16, -1.24, 0.64, 0.06, 0.99, 'z', False)
        s.bed('cell_output_' + side, x, -1.89, 0.68, 0.45, 0.99, 'z', False)
        for dx in [-0.26, 0.26]:
            for z in [-1.95, -0.86]:
                s.box('cell_leg' + side + str((dx, z)), [x + dx, 0.47, z], [0.045, 0.94, 0.045], FRAME)
        for sign in [-1, 1]:
            s.box('cell_fork_guide' + side + str(sign), [x + sign * 0.055, 0.815, -1.0], [0.025, 0.03, 0.8], STEEL)
    belt_hardware(s)

def draw_magazine(s, f):
    g.draw_magazine(s, f)
    q = f['plant']['physical']
    p = q['shuttle_xyz']
    for key, pose in list(s.poses.items()):
        if key.startswith(('assembly_', 'cap_stock')):
            pose['p'][2] -= 0.7
            if 'points' in pose:
                for point in pose['points']:
                    point[2] -= 0.7
        if key.startswith('mag') and '_foot' in key:
            pose['p'][1] = 1.0225
            pose['s'][1] = 0.085
        if key.startswith('mag') and ('_end0.21.08' in key or '_end-0.21.08' in key):
            pose['p'][1] = 1.185
    for k in ['shuttle_support', 'shuttle']:
        s.poses[k]['visible'] = False
    for sign in [-1, 1]:
        s.box('transfer_fork' + str(sign), add(p, [sign * 0.09, -0.075, 0]), [0.035, 0.05, 0.34], STEEL)
    s.box('transfer_fork_spine', add(p, [0, -0.075, 0.185]), [0.25, 0.05, 0.06], DRIVE)
    s.box('transfer_fork_lift', add(p, [0, -0.15, 0.185]), [0.085, 0.11, 0.06], DRIVE)
    s.box('transfer_fork_shoe', [p[0], 0.845, p[2] + 0.185], [0.12, 0.06, 0.12], STEEL)

def layout_scrap(s):
    for side, x in [('a', -1.25), ('b', 1.25)]:
        s.bed('product_input_' + side, x, 1.365, 2.27, 0.52, 1.147, 'z', False)
        s.bed('product_output_' + side, x, -1.365, 2.27, 0.52, 1.147, 'z', False)
        n = 3 if side == 'a' else 2
        holes = [(0, hole_z(n, i), 0.124, 0.124) for i in range(n)]
        plate(s, 'through_die_' + side, [x, 1.117, 0], [0.52, 0.06, 0.5], holes, STEEL)
        for xx in [x - 0.34, x + 0.34]:
            s.box('press_post' + str(xx), [xx, 0.97, -0.32], [0.055, 1.94, 0.055], FRAME)
        s.box('press_bridge_' + side, [x, 1.93, -0.16], [0.76, 0.11, 0.82], FRAME)
        for z in [-0.24, 0.24]:
            s.box('die_cross_' + side + str(z), [x, 0.995, z], [0.72, 0.08, 0.035], FRAME)
        for zz in [-2.3, 2.3]:
            for xx in [x - 0.3, x + 0.3]:
                s.box('line_leg' + str((xx, zz)), [xx, 0.54, zz], [0.05, 1.08, 0.05], FRAME)
        for i in range(n):
            slot = n - 1 - i if side == 'a' else 3 + i
            end = [0.16 * (slot % 3 - 1), 0.74 if side == 'a' else 0.59, 0.57 + 0.16 * (slot // 3)]
            start = [x, 0.79 if side == 'a' else 0.64, hole_z(n, i)]
            s.line('scrap_chute_' + side + str(i), [start, end], 0.14, BELT, width_axis=[0, 0, 1])
            low = 0.805 if side == 'a' else 0.655
            high = 1.087
            zz = hole_z(n, i)
            for sign in [-1, 1]:
                s.box('die_throat_x' + side + str((i, sign)), [x + sign * 0.064, (low + high) / 2, zz], [0.004, high - low, 0.132], STEEL)
                s.box('die_throat_z' + side + str((i, sign)), [x, (low + high) / 2, zz + sign * 0.064], [0.124, high - low, 0.004], STEEL)
        s.box('press_zrail_' + side, [x, 1.86, 0], [0.15, 0.045, 0.58], STEEL)
        s.bed('external_pickup_' + side, x + 0.5, -2.0, 1.5, 0.5, 1.147)
        s.label(side, 'Equipment' + side.upper(), [x, 2.1, 0])
    s.bed('bin_exchange', -0.38, 0.65, 5.1, 0.6, 0.4)
    s.cabinet('control', [0, 0.55, -0.7])
    belt_hardware(s)

def draw_scrap(s, f):
    q = f['plant']['physical']
    parts = f['plant']['parts']
    for side, x in [('a', -1.25), ('b', 1.25)]:
        z = q['tool_z'][side]
        py = 1.4 - 0.25 * q['stroke'][side]
        s.box('press_slide_' + side, [x, 1.82, z], [0.19, 0.055, 0.13], DRIVE)
        s.cyl('press_body_' + side, [x, 1.66, z], 0.055, 0.27, DRIVE)
        s.box('punch_' + side, [x, py, z], [0.118, 0.08, 0.118], STEEL)
        s.beam('punch_rod_' + side, [x, 1.525, z], [x, py + 0.04, z], 0.02)
    swapped = bool(q['used_bins'])
    positions = {101: q['return_x'] if swapped else 0.0, 102: q['bin_x'] if swapped else 1.8}
    for bid, x in positions.items():
        for sign in [-1, 1]:
            s.box('bin_side' + str(bid) + str(sign), [x + sign * 0.265, 0.54, 0.65], [0.02, 0.12, 0.44], DRIVE)
            s.box('bin_end' + str(bid) + str(sign), [x, 0.54, 0.65 + sign * 0.21], [0.51, 0.12, 0.02], DRIVE)
        s.box('bin_floor' + str(bid), [x, 0.477, 0.65], [0.52, 0.04, 0.4], STEEL)
        for zz in [0.49, 0.81]:
            s.cyl('bin_wheel' + str(bid) + str(zz), [x, 0.4285, zz], 0.0285, 0.42, STEEL, 'x')
    for i, p in parts.items():
        pos = [p[k] for k in 'xyz']
        if int(i) < 100:
            n = 2 if p['side'] == 'b' else 3
            holes = [(0, hole_z(n, int(k) - 100 - int(i) * 10), 0.12, 0.12) for k, r in parts.items() if int(k) > 100 and r['batch'] == int(i)]
            remove(s, 'plate' + i + '_')
            plate(s, 'plate' + i, pos, p['size'], holes, A, True)
        else:
            s.box('part' + i, pos, p['size'], A, material=True)
