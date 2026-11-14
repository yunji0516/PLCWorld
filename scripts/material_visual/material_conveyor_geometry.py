import copy, math
from .material_transport_contracts import FIXED as SUPPORTS
FIXED = {h: {k + '_surface' for k in roles} for h, roles in SUPPORTS.items()}

def upgrade(run, ident):
    original = run['nodes']
    nodes = {n['id']: n for n in original}
    new = []
    removed = set()
    records = []

    def box(key, p, size, color='#a3afb9', **kw):
        return dict(id=key, name=key, p=p, r=0.0, size=size, color=color, shape='box', visible=True, conveyor_hardware=True, **kw)
    for fixed in FIXED.get(ident, set()):
        if fixed in nodes:
            nodes[fixed]['fixed_transfer'] = True
            nodes[fixed]['support_kind'] = 'fixed'
            nodes[fixed]['color'] = '#a3afb9'
            nodes[fixed]['name'] = SUPPORTS[ident][fixed.removesuffix('_surface')]
            removed.update((k for k in [fixed.removesuffix('_surface') + '_motor', fixed.removesuffix('_surface') + '_roller'] if k in nodes))
    for n in list(original):
        key = n['id']
        base = key.removesuffix('_surface')
        if not key.endswith('_surface') or n.get('material') or (not n.get('visible', True)) or (base + '_motor' not in nodes) or (key in FIXED.get(ident, set())):
            continue
        if any((key in f['poses'] for f in run['frames'])):
            continue
        x, y, z = n['p']
        w, h, d = n['size']
        top = y + h / 2
        axis = {'z': 'x', 'x': 'z'}[nodes[base + '_roller']['axis']]
        pieces = n.get('fragments') or [dict(p=[0, 0, 0], size=[1, 1, 1])]
        segments = []
        for piece_index, f in enumerate(pieces):
            pos = [n['p'][j] + f['p'][j] * n['size'][j] for j in range(3)]
            size = [f['size'][j] * n['size'][j] for j in range(3)]
            length = size[0 if axis == 'x' else 2]
            width = size[2 if axis == 'x' else 0]
            if length < 0.05 or width < 0.028:
                new.append(box(key + '_transfer_plate' + str(piece_index), pos, size, '#7f8f9c'))
                continue
            segments.append((pos, size, length, width))
        if not segments:
            continue
        removed.add(key)
        for suffix in ['_beam', '_roller', '_motor_mount', '_motor_ear']:
            if base + suffix in nodes:
                removed.add(base + suffix)
        removed.update((k for k in nodes if k.startswith(base + '_frame_channel')))
        for index, (pos, size, length, width) in enumerate(segments):
            sid = key if index == 0 else key + '_segment' + str(index)
            radius = min(0.04, length * 0.12)
            height = 2 * radius
            edge = min(0.018, width * 0.12)
            bw = width - 2 * edge - 0.004
            if bw <= 0.008:
                bw = width * 0.65
            p = [pos[0], top - radius, pos[2]]
            s = [size[0], height, size[2]]
            loop = box(sid, p, s, '#252e34')
            loop.update(shape='conveyor_belt', conveyor=dict(axis=axis, radius=radius, belt_width=bw, length=length, source=key), name=n['name'])
            loop['support_kind'] = 'belt'
            new.append(loop)

            def at(along, yy, across):
                return [p[0] + (along if axis == 'x' else across), yy, p[2] + (across if axis == 'x' else along)]

            def dims(a, b, c):
                return [a, b, c] if axis == 'x' else [c, b, a]
            a = length / 2 - radius
            for sign in [-1, 1]:
                rail = box(sid + '_side_rail' + str(sign), at(0, top - radius, sign * (width / 2 - edge / 2)), dims(length, radius * 1.65, edge))
                new.append(rail)
                channel = box(sid + '_rail_channel' + str(sign), at(0, top - radius, sign * (width / 2 + 0.001)), dims(length * 0.82, 0.006, 0.002), '#35434e')
                new.append(channel)
                for end in [-1, 1]:
                    cy = top - radius
                    rr = min(radius * 0.66, 0.026)
                    sz = min(edge * 0.9, 0.014)
                    new.append(box(sid + '_bearing' + str((sign, end)), at(end * a, cy, sign * (width / 2 - edge / 2)), dims(min(0.09, length * 0.18), rr * 2, sz), '#a5b4bc', bearing_axis='z' if axis == 'x' else 'x', bore_radius=min(0.006, radius * 0.2)))
                    new.append(dict(**box(sid + '_bearing_cover' + str((sign, end)), at(end * a, cy, sign * (width / 2 - edge * 0.15)), [rr * 0.72, edge * 0.2, rr * 0.72], '#7f8f9c'), axis='z' if axis == 'x' else 'x', shape_override='cylinder'))
            for end in [-1, 1]:
                drum = box(sid + '_drum' + str(end), at(end * a, top - radius, 0), [max(0.002, radius - 0.01), bw, max(0.002, radius - 0.01)], '#7f8f9c')
                drum.update(shape='cylinder', axis='z' if axis == 'x' else 'x')
                new.append(drum)
                shaft = box(sid + '_drum_shaft' + str(end), at(end * a, top - radius, 0), [min(0.005, radius * 0.15), width, min(0.005, radius * 0.15)], '#bcc6ca')
                shaft.update(shape='cylinder', axis='z' if axis == 'x' else 'x')
                new.append(shaft)
            records.append(dict(id=sid, source=key, length=length, width=width, belt_width=bw, top=top, axis=axis, loop_radius=radius))
        motor = nodes[base + '_motor']
        motor['motor_detail'] = True
        mx, my, mz = motor['p']
        edge_z = min(z + d / 2, max(z - d / 2, mz))
        edge_x = min(x + w / 2, max(x - w / 2, mx))
        new.append(box(base + '_drive_mount', [(mx + edge_x) / 2, top - 0.062, (mz + edge_z) / 2], [abs(mx - edge_x) + 0.04, 0.025, abs(mz - edge_z) + 0.04], '#7f8f9c'))
        new.append(box(base + '_drive_bracket', [mx, (my + top - 0.05) / 2, mz], [0.04, max(0.01, top - 0.05 - my), 0.04], '#7f8f9c'))
        for k, v in nodes.items():
            if k.startswith(base + '_foot') and v['shape'] == 'box':
                v['shape'] = 'leveling_foot'
    rails = [n for n in new if '_side_rail' in n['id']]
    for leg in original:
        if '_leg' not in leg['id'] or leg['shape'] != 'box' or (not leg.get('visible', True)):
            continue
        if leg.get('fragments'):
            pieces = leg['fragments']
            actual = [dict(p=[leg['p'][j] + f['p'][j] * leg['size'][j] for j in range(3)], size=[leg['size'][j] * f['size'][j] for j in range(3)]) for f in pieces]
            if len(actual) == 1:
                leg['p'] = actual[0]['p']
                leg['size'] = actual[0]['size']
                leg.pop('fragments')
            else:
                tip = max(actual, key=lambda v: v['p'][1] + v['size'][1] / 2)
                leg = box(leg['id'] + '_upper_post', [tip['p'][0], tip['p'][1] + tip['size'][1] / 2, tip['p'][2]], [tip['size'][0], 1e-05, tip['size'][2]])
                new.append(leg)
        bottom = leg['p'][1] - leg['size'][1] / 2
        oldtop = leg['p'][1] + leg['size'][1] / 2
        choices = []
        for rail in rails:
            rp = rail['p']
            rs = rail['size']
            low = rp[1] - rs[1] / 2
            if not low - 0.22 <= oldtop <= rp[1] + rs[1] / 2 - 0.012:
                continue
            axis = 0 if rs[0] > rs[2] else 2
            cross = 2 if axis == 0 else 0
            target = rp[:]
            target[axis] = min(rp[axis] + rs[axis] / 2 - 0.018, max(rp[axis] - rs[axis] / 2 + 0.018, leg['p'][axis]))
            distance = math.hypot(target[0] - leg['p'][0], target[2] - leg['p'][2])
            if distance < 0.13:
                choices.append((distance + abs(oldtop - low) * 0.1, rail, target, low))
        if not choices:
            continue
        _, rail, target, low = min(choices, key=lambda v: v[0])
        top = max(oldtop, low + 0.005)
        leg['p'][1] = (bottom + top) / 2
        leg['size'][1] = top - bottom
        cap = box(leg['id'] + '_chassis_joint', [(leg['p'][0] + target[0]) / 2, top - 0.01, (leg['p'][2] + target[2]) / 2], [abs(leg['p'][0] - target[0]) + 0.03, 0.03, abs(leg['p'][2] - target[2]) + 0.03], '#7f8f9c')
        cap['support_joint'] = {'post': leg['id'], 'rail': rail['id']}
        new.append(cap)
    connected = {n['support_joint']['post'] for n in new if n.get('support_joint')}
    retired = []
    for leg in original:
        if '_leg' not in leg['id'] or leg['shape'] != 'box' or leg.get('fragments'):
            continue
        own = [r for r in rails if r['id'].startswith(leg['id'].split('_leg')[0] + '_surface')]
        if not own or leg['id'] in connected or leg['id'] + '_upper_post' in connected:
            continue
        touches = lambda rail: all((abs(leg['p'][j] - rail['p'][j]) <= (leg['size'][j] + rail['size'][j]) / 2 + 1e-08 for j in range(3)))
        if any((touches(r) for r in own)):
            continue
        removed.add(leg['id'])
        removed.add(leg['id'].replace('_leg', '_foot'))
        retired.append(leg['id'])
    for n in new:
        if n.pop('shape_override', None) == 'cylinder':
            n['shape'] = 'cylinder'
    run['nodes'] = [n for n in original if n['id'] not in removed] + new
    run['conveyor_review'] = records
    if retired:
        run['conveyor_retired_supports'] = retired
    return records
