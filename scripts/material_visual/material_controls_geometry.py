import copy, importlib, math, types
from .material_station_geometry import STEEL, FRAME, DRIVE, A, BLUE, LIGHT, add
OLD = {'H02': 'material_h02_fifo_geometry', 'H04': 'material_h04_pouch_geometry', 'H05': 'material_h05_index_geometry', 'H06': 'material_h06_web_geometry', 'H07': 'material_h07_wind_geometry', 'H08': 'material_h08_skeleton_geometry', 'H11': 'material_h11_faces_geometry', 'H13': 'material_wrap_geometry', 'H15': 'material_h15_stack_geometry'}

def gantry(s, key, x0, x1, z0, z1, y):
    if not hasattr(s, 'gantries'):
        s.gantries = {}
    s.gantries[key] = (x0, x1, z0, z1, y)
    for x in [x0, x1]:
        for z in [z0, z1]:
            s.box(f'{key}_column{x}_{z}', [x, y / 2, z], [0.05, y, 0.05], FRAME)
        s.box(f'{key}_zrail{x}', [x, y, z0 + (z1 - z0) / 2], [0.065, 0.065, z1 - z0 + 0.1], FRAME)
    s.cyl(key + '_drive', [x1 + 0.1, y, z1], 0.045, 0.12, DRIVE, 'x')

def bridge(s, frame, key, z):
    x0, x1, z0, z1, y = s.gantries[frame]
    assert z0 - 1e-08 <= z <= z1 + 1e-08, (frame, z)
    s.box(key + '_crossrail', [(x0 + x1) / 2, y - 0.07, z], [x1 - x0 + 0.065, 0.06, 0.065], FRAME)
    for side, x in enumerate([x0, x1]):
        s.box(key + '_bearing' + str(side), [x, y - 0.05, z], [0.1, 0.07, 0.14], DRIVE)
    s.cyl(key + '_xdrive', [x1 + 0.055, y - 0.07, z], 0.025, 0.09, DRIVE, 'x')

def head(s, key, p, y, width=0.22, depth=0.25):
    s.box(key, p, [width, 0.04, depth], DRIVE)
    s.beam(key + '_rod', [p[0], y, p[2]], [p[0], p[1] + 0.02, p[2]], 0.014)
    s.box(key + '_slide', [p[0], y, p[2]], [0.16, 0.07, 0.13], DRIVE)

def hide(s, *keys):
    for k in keys:
        if k in s.nodes:
            if s.dynamic:
                s.poses.setdefault(k, copy.deepcopy(s.nodes[k]))['visible'] = False
            else:
                s.nodes.pop(k, None)

def shift_pose(s, key, dy):
    if key in s.poses:
        s.poses[key]['p'][1] += dy
    elif key in s.nodes:
        s.nodes[key]['p'][1] += dy

def layout(s, ident):
    g = importlib.import_module('.' + OLD[ident], __package__)
    g.layout(s)
    if ident == 'H02':
        s.bed('box_lane', 2.25, 0.72, 4.12, 0.64, 0.8, 'z')
        gantry(s, 'packing', 0.28, 2.67, 0.4, 2.3, 1.93)
        s.cyl('box_clamp_drive', [2.7, 0.95, 0.6], 0.045, 0.25, DRIVE, 'x')
    elif ident == 'H04':
        gantry(s, 'separator', -0.84, -0.46, 0.34, 1.12, 1.5)
        s.box('separator_return_bed', [-0.65, 0.835, 0.9], [0.23, 0.03, 0.38], STEEL)
        s.cyl('align_side_drive', [0.19, 0.884, -0.55], 0.023, 0.13, DRIVE, 'x')
        s.cyl('align_front_drive', [0, 0.884, -0.79], 0.023, 0.12, DRIVE, 'z')
    elif ident == 'H05':
        hide(s, 'insert_stage', 'insert_stage_post')
        s.bed('repair_bed', -0.9, -0.9, 0.24, 0.23, 0.85)
        gantry(s, 'repair_transfer', -1.14, 0.68, -1.14, 0.19, 2.1)
        s.cyl('repair_drive', [-1.13, 0.94, -0.9], 0.035, 0.16, DRIVE, 'x')
        s.box('repair_tool_post', [-1.33, 0.895, -0.9], [0.035, 1.79, 0.035], FRAME)
        s.box('repair_tool_rail', [-1.08, 1.79, -0.9], [0.535, 0.055, 0.055], FRAME)
    elif ident == 'H06':
        for k in list(s.nodes):
            if k.startswith(('source_', 'unwind_', 'label_unwind')):
                hide(s, k)
        s.bed('reel_exchange', -2.0, -0.65, 1.8, 0.52, 0.54, 'z')
        s.frame('reel_a_stand', -1.2, 0, 0.36, 0.44, 0.54)
        s.box('reel_a_deck', [-1.2, 0.535, 0.0], [0.36, 0.07, 0.44], STEEL)
        s.box('splice_bed', [-0.72, 0.928, 0], [0.32, 0.035, 0.15], STEEL)
        gantry(s, 'splice', -0.94, -0.49, -0.18, 0.18, 1.36)
        s.bed('waste_x', 1.96, 0, 1.0, 0.15, 0.9345, 'x')
        s.bed('waste_cross', 2.4, -0.55, 1.3, 1.2, 0.9345, 'z')
    elif ident == 'H07':
        for dx in [-0.045, 0.045]:
            s.box('core_feed_rail' + str(dx), [0.45 + dx, 0.95 - math.sqrt(0.05 ** 2 - dx ** 2) - 0.009, 0.9], [0.012, 0.018, 1.26], STEEL)
        s.frame('core_feed_stand', 0.45, 0.98, 0.28, 1.3, 0.82)
        gantry(s, 'tail_tape', 0.1, 1.12, -0.55, 0.53, 1.55)
        s.cyl('tail_tape_reel', [0.9, 1.48, 0.4], 0.06, 0.05, A, 'z')
        s.box('tail_tape_prep', [0.9, 1.273, 0.35], [0.12, 0.012, 0.14], STEEL)
    elif ident == 'H08':
        hide(s, 'rewinder_guard_panel', 'recovery_post')
        s.frame('reel_swap_stand', 0.4, 0.32, 0.37, 1.1, 0.56)
        for x in [0.25, 0.55]:
            s.beam('waste_zrail' + str(x), [x, 0.58, -0.52], [x, 0.58, 0.8], 0.017)
        for z in [-0.6, -0.3]:
            s.beam('waste_xrail' + str(z), [0.2, 0.56, z], [1.45, 0.56, z], 0.017)
        s.frame('waste_receiving', 1.2, -0.73, 0.4, 0.86, 0.6)
        for z in [-0.08, 0.08]:
            s.box('edge_backing' + str(z), [0.26, 0.833, z], [0.08, 0.034, 0.045], STEEL)
    elif ident == 'H11':
        s.bed('tool_rack', -1.8, -0.25, 0.88, 0.36, 1.09, 'z')
        for k in list(s.nodes):
            if k.startswith(('head_zrail', 'head_post')):
                hide(s, k)
            if k.startswith(('a_probe_arm', 'b_probe_arm', 'a_probe_post', 'b_probe_post', 'a_probe_body', 'b_probe_body')):
                s.nodes[k]['p'][2] -= 0.12
        gantry(s, 'tool_service', -2.12, 1.48, -0.8, 1.57, 2.25)
        for k in list(s.nodes):
            if k.startswith('product_supply_guide') or k.startswith('finished_product_guide'):
                s.nodes[k]['p'][2] = 1.055
                s.nodes[k]['size'][2] = 0.81
            if k.startswith(('product_supply_mount', 'finished_product_mount')) and s.nodes[k]['p'][2] < 0.65:
                hide(s, k)
    elif ident == 'H13':
        for k, n in s.nodes.items():
            if k.startswith(('bundle_output_guide', 'bundle_output_mount')):
                n['p'][2] += 0.05 if n['p'][2] > -1.5 else -0.05
        s.bed('unit_supply', 4.65, 2.5, 5.75, 0.2, 0.95, 'x')
        s.bed('unit_feed_nose', 1.6725, 2.5, 0.205, 0.2, 0.95, 'x', False)
        s.bed('formation_table', 1.25, 2.34, 0.98, 0.64, 0.95, 'z')
        gantry(s, 'formation', -0.39, 1.67, 2.0, 3.02, 2.22)
    elif ident == 'H15':
        for k in list(s.nodes):
            if k.startswith('receiver_') and (not k.startswith('receiver_cross')):
                s.nodes[k]['p'][1] -= 0.03
        s.nodes['fork_xrail']['p'][0] = -0.3
        s.nodes['fork_xrail']['size'][0] = 2.26
        s.nodes['fork_xscrew']['points'][0][0] = -1.45
        for dx in [-0.12, 0.12]:
            s.box('pallet_supply' + ('' if dx < 0 else '_right'), [-1.2 + dx, 0.805, 2.9], [0.03, 0.03, 1.15], STEEL)
        s.frame('pallet_stand', -1.2, 2.9, 0.4, 1.2, 0.77)

def reel_projection(stock, c, waypoints, fraction=1.0, tail=False):

    def path(r):
        gx, gy, gz = waypoints[0]
        dx, dy = (gx - c[0], gy - c[1])
        d = math.hypot(dx, dy)
        a = math.atan2(dy, dx) + math.acos(min(1, r / d))
        return [[c[0] + r * math.cos(a), c[1] + r * math.sin(a), c[2]]] + waypoints
    lo, hi = (0.05, 0.15)
    for _ in range(45):
        r = (lo + hi) / 2
        pts = path(r)
        length = sum((math.dist(a, b) for a, b in zip(pts, pts[1:])))
        leader = min(stock, length * fraction)
        w = math.pi * (r * r - 0.05 ** 2) / 0.001
        if w + leader > stock:
            hi = r
        else:
            lo = r
    r = (lo + hi) / 2
    pts = path(r)
    total = sum((math.dist(a, b) for a, b in zip(pts, pts[1:])))
    wanted = min(stock, total * fraction)
    skip = total - wanted if tail else 0.0
    remaining = wanted
    out = []
    for a, b in zip(pts, pts[1:]):
        length = math.dist(a, b)
        if skip >= length:
            skip -= length
            continue
        start = [x + (y - x) * skip / length for x, y in zip(a, b)]
        take = min(remaining, length - skip)
        if not out:
            out.append(start)
        out.append([x + (y - x) * (skip + take) / length for x, y in zip(a, b)])
        remaining -= take
        skip = 0
        if remaining < 1e-10:
            break
    return (r, out, wanted, math.pi * (r * r - 0.05 ** 2) / 0.001)

def draw(s, f, ident):
    g = importlib.import_module('.' + OLD[ident], __package__)
    g.draw(s, f)
    q = f['plant']['physical']
    e = q['extension']
    ps = f['plant']['parts']
    if ident == 'H02':
        j = e['head']
        p = add(j['pos'], [0, 0.09, 0]) if j else [2.25, 1.72, 0.6]
        head(s, 'pack_head', p, 1.86, 0.19, 0.36)
        for z in [-0.1, 0.1]:
            s.cyl('pack_pad' + str(z), add(p, [0, -0.025, z]), 0.055, 0.03, DRIVE)
        s.box('box_jaw', [2.25 + 0.33 + 0.11 * (1 - e['clamp']), 0.95, 0.6], [0.04, 0.12, 0.42], DRIVE)
        for b in e['boxes']:
            key = 'box' + str(b['id'])
            p = [b[k] for k in 'xyz']
            s.box(key + '_base', p, b['size'], A, material=True)
            for sign in [-1, 1]:
                s.box(key + '_side' + str(sign), add(p, [sign * 0.291, 0.1, 0]), [0.018, 0.15, 0.5], A, material=True)
                s.box(key + '_end' + str(sign), add(p, [0, 0.1, sign * 0.241]), [0.564, 0.15, 0.018], A, material=True)
    elif ident == 'H04':
        j = e['separator']
        p = ps.get(str(j['id'])) if j else None
        position = [p[k] for k in 'xyz'] if p else [-0.65, 1.3, 0.48]
        head(s, 'separator_pad', add(position, [0, 0.022, 0]), 1.43, 0.08, 0.16)
        s.box('separator_hold', [-0.65, 0.844 - 0.05 * (1 - e['hold']), 0.345], [0.1, 0.012, 0.055], DRIVE)
        content = ps.get(str(q['content'])) if q['content'] else None
        right = 0.057 + 0.04 * (1 - e['side'])
        front = -0.6775 - 0.04 * (1 - e['front'])
        if content and content['owner'] == 'prepared':
            yaw = content.get('yaw', 0.0)
            right = max(right, content['x'] + (0.1 * abs(math.cos(yaw)) + 0.24 * abs(math.sin(yaw))) / 2 + 0.007)
            front = min(front, content['z'] - (0.24 * abs(math.cos(yaw)) + 0.1 * abs(math.sin(yaw))) / 2 - 0.0075)
        s.box('align_side', [right, 0.875, -0.55], [0.014, 0.035, 0.2], DRIVE)
        s.box('align_front', [0, 0.875, front], [0.08, 0.035, 0.015], DRIVE)
        for i, p in ps.items():
            if p['kind'] == 'pouch':
                dy = p['y'] - p['size'][1] / 2 - 0.85
                for name, _, _ in g.walls(p):
                    shift_pose(s, 'pouch' + str(i) + '_' + name, dy)
            else:
                s.poses['part' + str(i)]['r'] = p.get('yaw', 0.0)
    elif ident == 'H05':
        p = ps.get(str(e['body'])) if e['body'] else None
        i = ps.get(str(e['insert'])) if e['insert'] else None
        s.box('repair_clamp', [-1.0 - 0.04 * (1 - e['clamp']), 0.91, -0.9], [0.04, 0.08, 0.14], DRIVE)
        grip = e.get('tool', [-1.2, 1.7, -0.9])
        head(s, 'repair_grip', grip, 1.79, 0.05, 0.05)
        moving = p and p['owner'] in ['rework_transfer', 'returning']
        position = add([p[k] for k in 'xyz'], [0, 0.07, 0]) if moving else [-0.9, 1.94, -0.9]
        head(s, 'return_head', position, 2.03, 0.11, 0.13)
        for z in [-0.05, 0.05]:
            s.box('return_vacuum' + str(z), add(position, [0, -0.025, z]), [0.1, 0.01, 0.025], DRIVE)
    elif ident == 'H06':
        hide(s, 'source_core', 'source_wound', 'source_flange-0.072', 'source_flange0.072', 'source_lead')
        s.box('spare_carriage', [-2.0, 0.575, e['spare_z']], [0.36, 0.07, 0.35], DRIVE)
        for name, stock, c, points, fraction, tail in [('a', e['roll_a_mm'] / 1000, [-1.2, 0.8, 0.0], [[-0.82, 0.95, 0.0], [-0.65, 0.95, 0.0]], 1.0, True), ('b', e['roll_b_mm'] / 1000, [-2.0, 0.8, e['spare_z']], [[-2.0, 1.1, e['spare_z']], [-0.9, 1.1, 0.0], [-0.72, 0.951, 0.0], [-0.65, 0.951, 0.0]], e['thread'], False)]:
            r, pts, lead, wound = reel_projection(stock, c, points, fraction, tail)
            s.cyl('source_' + name + '_core', c, 0.0495, 0.16, STEEL, 'z')
            s.node('source_' + name + '_stock', c, [r, 0.12, 0.05], A if name == 'a' else BLUE, 'tube', rx=math.pi / 2, material=True, visible=wound > 1e-08)
            if pts:
                s.line('source_' + name + '_leader', pts, 0.12, A if name == 'a' else BLUE, material=True, width_axis=[0, 0, 1], visible=lead > 1e-08)
            s.beam('source_' + name + '_spindle', add(c, [0, 0, -0.11]), add(c, [0, 0, 0.27]), 0.019)
            s.box('source_' + name + '_pedestal', add(c, [0, -0.13, 0.14]), [0.075, 0.26, 0.07], FRAME)
            s.box('source_' + name + '_mount', add(c, [0, -0.23, 0.1]), [0.18, 0.08, 0.15], STEEL)
            s.box('source_' + name + '_bearing', add(c, [0, 0, 0.14]), [0.11, 0.11, 0.055], DRIVE)
            s.cyl('source_' + name + '_drive', add(c, [0, 0, 0.26]), 0.045, 0.11, DRIVE, 'z')
            for sign in [-1, 1]:
                s.cyl('source_' + name + '_flange' + str(sign), add(c, [0, 0, sign * 0.07]), 0.095, 0.008, STEEL, 'z')
        s.line('splice_feed_leader', [[-0.65, 0.95, 0.0], [-0.36, 0.95, 0.0], [-0.105, 0.935, 0.0]], 0.12, A, material=True, width_axis=[0, 0, 1])
        for name, x, z in [('old', -0.8, 0.0), ('new', -0.7, 0.0)]:
            s.box('splice_' + name + '_hold', [x, 0.964 + 0.06 * (1 - e[name + '_hold']), z], [0.06, 0.025, 0.14], DRIVE)
        s.box('splice_press', [-0.62, 0.978 + 0.12 * (1 - e['press']), 0], [0.075, 0.05, 0.14], DRIVE)
        s.beam('splice_press_rod', [-0.62, 1.3, 0], [-0.62, 1.01 + 0.12 * (1 - e['press']), 0], 0.014)
        for i, p in ps.items():
            if p['side'] == 'waste':
                s.nodes['part' + str(i)]['color'] = '#c37763'
    elif ident == 'H07':
        s.box('core_stop', [0.45, 0.94, 0.315 - 0.09 * (1 - e['stop'])], [0.08, 0.025, 0.025], DRIVE)
        t = e['tape']
        head(s, 'tail_tape_head', add(t['head'], [0, 0.0205, 0]), 1.5, 0.09, 0.055)
        s.box('tail_tape_knife', [0.85, 1.34, 0.35], [0.006, 0.035, 0.06], STEEL)
        s.box('tail_tape_prepared', t['head'], [max(0.001, t['length']), 0.001, 0.05], A, material=True, visible=t['length'] > 1e-08)
        for strip in t['strips']:
            p = ps[str(strip['roll'])]
            points = []
            for j in range(33):
                a = math.pi / 2 - strip['length'] / p['radius'] / 2 + j * strip['length'] / p['radius'] / 32
                points.append([p['x'] + (p['radius'] + 0.0005) * math.cos(a), p['y'] + (p['radius'] + 0.0005) * math.sin(a), p['z']])
            s.line('tail_tape_roll' + str(strip['id']), points, 0.05, A, material=True, width_axis=[0, 0, 1])
    elif ident == 'H08':
        for k in list(s.nodes):
            if k.startswith('wound_') or k in ['recovery_core', 'recovery_shaft', 'recovery_drive']:
                hide(s, k)
        for r in e['rolls']:
            length = r['u1'] - r['u0']
            radius = math.sqrt(0.05 ** 2 + 0.001 * length / math.pi)
            c = r['pos']
            key = 'waste_roll' + str(r['id'])
            s.node(key + '_core', c, [0.0495, 0.22, 0.035], STEEL, 'tube', rx=math.pi / 2)
            s.beam(key + '_shaft', add(c, [0, 0, -0.13]), add(c, [0, 0, 0.13]), 0.023)
            for region, a, b, z, width in g.regions():
                lo = max(a, r['u0'])
                hi = min(b, r['u1'])
                pts = []
                for u in g.samples(lo, hi, 0.003):
                    ru = math.sqrt(0.05 ** 2 + 0.001 * (u - r['u0']) / math.pi)
                    theta = math.pi / 2 + 2 * math.pi / 0.001 * (radius - ru)
                    pts.append([c[0] + ru * math.cos(theta), c[1] + ru * math.sin(theta), c[2] + z])
                g.strip(s, key + '_' + region, pts, width)
            s.box(key + '_cradle', add(c, [0, -radius - 0.022, 0]), [0.2, 0.035, 0.26], DRIVE)
        roll = e['rolls'][min(e['index'], 1)]
        s.box('waste_carriage', add(roll['pos'], [0, -0.15, 0]), [0.26, 0.08, 0.28], DRIVE)
        for k, name in enumerate(['left', 'right']):
            z = -0.08 if k == 0 else 0.08
            s.box('edge_hold_' + name, [0.26, 0.863 + 0.045 * (1 - e['hold']), z], [0.08, 0.025, 0.045], DRIVE)
            s.box('edge_knife_' + name, [0.31, 0.868 if not e['connections'][k] else 0.95, z], [0.004, 0.035, 0.045], STEEL)
            if e['index'] == 1 and (not e['connections'][k]):
                s.box('thread_slide_' + name, [0.25 + 0.14 * e['thread'][k], 0.848, z], [0.035, 0.005, 0.036], DRIVE)
    elif ident == 'H11':
        angle = q['angle']
        c, t = (math.cos(angle), math.sin(angle))
        s.box('cradle_crossbar', [0, 1.1 - 0.1 * c + 0.2 * t, -0.1 * t - 0.2 * c], [0.8, 0.03, 0.1], FRAME, rx=angle)
        for sign in [-1, 1]:
            key = 'cradle_sidearm' + str(sign * 0.16)
            s.box(key, [sign * 0.38, 1.1 - 0.05 * c + 0.2 * t, -0.05 * t - 0.2 * c], [0.025, 0.1, 0.07], FRAME, rx=angle)
            s.beam('cradle_wide_stub' + str(sign), [sign * 0.15, 1.1, 0], [sign * 0.38, 1.1, 0], 0.014)
            s.beam('cradle_offset_arm' + str(sign), [sign * 0.38, 1.1, 0], [sign * 0.38, 1.1 + 0.2 * t, -0.2 * c], 0.014)
        h = q['head']
        tool = e['tools'][e['tool'] - 1] if e['tool'] else None
        for k in ['edge_bridge', 'edge_grip0', 'edge_grip1', 'edge_finger0', 'edge_finger1']:
            hide(s, k)
        s.box('head_xrail', [-0.32, 2.18, h[2]], [3.65, 0.07, 0.07], FRAME)
        s.box('head_carriage', [h[0], 2.1, h[2]], [0.16, 0.08, 0.16], DRIVE)
        s.beam('head_rod', [h[0], 2.06, h[2]], [h[0], h[1] + 0.225, h[2]], 0.012)
        s.box('tool_coupler', add(h, [0, 0.205, 0]), [0.1, 0.04, 0.1], STEEL)
        for t in e['tools']:
            p = t['pos']
            closed = t['owner'] == 'rack' or bool(q['held'] or (q['job'] and q['job']['phase'] == 'pickup'))
            span = t['width'] / 2 + 0.015 + (0 if closed else 0.04)
            key = 'tool' + str(t['id'])
            s.box(key + '_bridge', add(p, [0, 0.17, 0]), [0.64, 0.03, t['width'] + 0.12], DRIVE, material=True)
            for sign in [-1, 1]:
                for sx in [-1, 1]:
                    tag = str(sign) + '_' + str(sx)
                    s.box(key + '_jaw' + tag, add(p, [sx * 0.09, 0.01, sign * span]), [0.04, 0.04, 0.03], DRIVE, material=True)
                    s.box(key + '_arm' + tag, add(p, [sx * 0.195, 0.04, sign * span]), [0.25, 0.02, 0.025], STEEL, material=True)
                    s.box(key + '_finger' + tag, add(p, [sx * 0.3, 0.1, sign * span]), [0.02, 0.14, 0.022], STEEL, material=True)
        for k in s.nodes:
            if k.startswith('face_'):
                s.nodes[k]['annotation'] = True
        for side, x in [('a', -0.65), ('b', 0.65)]:
            width = e[side + '_width']
            offset = width / 2 + 0.01 + (0.04 * (1 - q['b_clamp']) if side == 'b' else 0)
            for j, sign in enumerate([-1, 1]):
                s.box('b_jaw' + str(j) if side == 'b' else 'adjust_a_jaw' + str(j), [x, 0.86, sign * offset], [0.1, 0.04, 0.02], DRIVE)
            s.box('adjust_' + side + '_jaw', [x, 0.76, 0], [0.12, 0.06, width + 0.1], DRIVE)
    elif ident == 'H13':
        draw_former(s, f)
    elif ident == 'H15':
        for k in list(s.poses):
            if k.startswith(('support_', 'fork_tine', 'fork_spine')):
                shift_pose(s, k, -0.03)
        x, y, z = q['fork']['pos']
        s.box('fork_zslide', [x, 0.7, (z + 2.7) / 2], [0.055, 0.05, abs(2.7 - z) + 0.1], FRAME)
        hide(s, 'fork_lift')
        s.box('empty_pallet_lift', [x + 0.23, (y + 0.7 - 0.03) / 2, z + 0.19], [0.045, max(0.01, y - 0.73), 0.045], DRIVE)
        s.box('fork_side_arm', [x + 0.14, y - 0.0375, z + 0.19], [0.24, 0.015, 0.045], DRIVE)
        for p in e['pallets']:
            key = 'pallet' + str(p['id'])
            s.box(key, p['pos'], [0.3, 0.03, 0.24], A, material=True, name='Equipment' + str(p['id']))
    mounts = {'H02': ('packing', 'pack_head'), 'H04': ('separator', 'separator_pad'), 'H05': ('repair_transfer', 'return_head'), 'H07': ('tail_tape', 'tail_tape_head'), 'H13': ('formation', 'formation_head')}
    if ident in mounts:
        frame, key = mounts[ident]
        bridge(s, frame, key, s.poses[key]['p'][2])
    if ident == 'H06':
        bridge(s, 'splice', 'splice_mount', 0.0)
    if ident == 'H11':
        for side, x in enumerate([-2.12, 1.48]):
            s.box('tool_service_bearing' + str(side), [x, 2.215, q['head'][2]], [0.11, 0.08, 0.14], DRIVE)

def draw_former(s, f):
    from .former_math import corners, tangent, rotate_yz
    q = f['plant']['physical']
    e = q['extension']
    parts = f['plant']['parts']
    depth = 0.56
    chosen = parts.get(str(q['held_token'])) if q['held_token'] else None
    if not chosen and abs(q['grip_xyz'][2]) < 0.2:
        chosen = parts.get(str(q['wrap_token']))
    if not chosen and q['grip_xyz'][2] > 1.0:
        chosen = next((p for p in parts.values() if p['owner'] == 'source'), None)
    if chosen:
        depth = chosen['size'][2]
    grip = q['grip_xyz']
    for x in [-0.17, 0.17]:
        s.box('transfer_jaw_guide' + str(x), [grip[0] + x, grip[1] + 0.33, grip[2]], [0.065, 0.045, 0.84], DRIVE)
        for sign in [-1, 1]:
            z = grip[2] + sign * (depth / 2 + 0.019 + 0.1 * (1 - q['grip']))
            key = f'transfer_finger{x}{sign}'
            s.box(key, [grip[0] + x, grip[1] + 0.11, z], [0.05, 0.44, 0.03], STEEL)
            s.box(key + '_pad', [grip[0] + x, grip[1] - 0.015, z - sign * 0.017], [0.05, 0.17, 0.004], DRIVE)
            s.beam(key + '_slide', [grip[0] + x, grip[1] + 0.33, grip[2]], [grip[0] + x, grip[1] + 0.33, z], 0.014)
            s.box(key + '_slider', [grip[0] + x, grip[1] + 0.33, z], [0.085, 0.06, 0.06], STEEL)
    for i, p in parts.items():
        hide(s, 'part' + str(i), *['layer' + str(i) + str(j) for j in [-0.1, 0, 0.1]])
        if p['owner'] in ['unformed', 'forming']:
            hide(s, 'film_band' + str(i), 'free_film' + str(i), 'tape_patch' + str(i))
            continue
        a = p['rx']
        idx, _ = tangent(a, p['size'][2])
        cs = corners(p['size'][2])
        steps = int((a + 1e-10) / (2 * math.pi)) * 4 + (idx - 3) % 4
        if a < 2 * math.pi - 1e-08 and idx == 3 and (a > math.pi):
            steps = 4

        def world(v):
            yy, zz = rotate_yz(v, a)
            return [p['x'], p['y'] + yy, p['z'] + zz]
        pts = [world(cs[(3 + k) % 4]) for k in range(steps + 1)]
        end = world(cs[idx])
        s.line('film_band' + str(i), pts, 0.18, BLUE, visible=len(pts) > 1, material=True, width_axis=[1, 0, 0])
        s.line('free_film' + str(i), [[0, 0.7, -0.55], end], 0.18, BLUE, visible=p['connected'], material=True, width_axis=[1, 0, 0])
    wrap = parts.get(str(q['wrap_token']))
    wd = wrap['size'][2] if wrap else 0.56
    for k in ['tape_head', 'prepared_tape']:
        if k in s.poses:
            s.poses[k]['p'][2] = 0.0
            s.poses[k]['p'][1] = 1.267 if k == 'tape_head' else 1.2535
    for i, p in parts.items():
        if 'tape_patch' + str(i) in s.poses:
            s.poses['tape_patch' + str(i)]['p'] = [p['x'], p['y'] + 0.152, p['z']]
    s.box('tape_actuator', [1.18, 1.267, 0.0], [0.26, 0.08, 0.12], DRIVE)
    s.beam('tape_rod', [1.05, 1.267, 0.0], [s.poses['tape_head']['p'][0] + 0.07, 1.267, 0.0], 0.014)
    s.box('cutter_body', [0.52, 1.244, -0.36], [0.24, 0.06, 0.055], DRIVE)
    s.poses['cutter_blade']['p'][2] = -wd / 2 - 0.01
    s.beam('cutter_rod', [0.4, 1.244, -wd / 2 - 0.01], [s.poses['cutter_blade']['p'][0] + 0.11, 1.244, -wd / 2 - 0.01], 0.009)
    for i, u in e['units'].items():
        s.box('unit' + str(i), u['pos'], u['size'], A, material=True, rx=u['rx'], name='Equipment' + str(i))
    h = e['head']
    count = len(e['held']) or len(e['loaded']) or e.get('jaw_count', 4)
    span = max(0.14, count * 0.14)
    head(s, 'formation_head', add(h, [0, 0.34, 0]), 2.15, 0.58, span + 0.25)
    s.box('formation_gripper_housing', add(h, [0, 0.275, 0]), [0.56, 0.09, span + 0.25], DRIVE)
    for x in [-0.21, 0.21]:
        s.box('formation_gripper_guide' + str(x), add(h, [x, 0.255, 0]), [0.028, 0.028, span + 0.25], STEEL)
    for sign in [-1, 1]:
        z = 2.5 + sign * (span / 2 + 0.0125 + 0.07 * (1 - e['grip']))
        s.box('formation_finger' + str(sign), [h[0], h[1] + 0.06, z + sign * 0.002], [0.45, 0.34, 0.021], STEEL)
        s.box('formation_contact_pad' + str(sign), [h[0], h[1], z - sign * 0.0105], [0.44, 0.22, 0.004], DRIVE)
        s.box('formation_jaw_slider' + str(sign), [h[0], h[1] + 0.225, z], [0.5, 0.07, 0.065], DRIVE)
    s.box('formation_stop', [0.963 - 0.08 * (1 - e['stop']), 1.025, 2.5], [0.024, 0.15, 0.14], DRIVE)
    s.box('formation_align', [1.25, 1.04, 2.795 + 0.18 * (1 - e['align'])], [0.5, 0.18, 0.03], DRIVE)
