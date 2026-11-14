STOP_CENTRES = [-3.9, -3.4, -2.9, -2.0, -1.0, 0.0, 0.6, 1.2, 1.8]
from . import material_station_geometry as g
old_layout=dict(g.LAYOUT)
old_draw=dict(g.DRAW)
def remove(s, prefix):
    for key in list(s.nodes):
        if key.startswith(prefix):
            del s.nodes[key]

def side_stop(s, key, axis, x, y, z, closed):
    pos = [x + (0.0 if closed else 0.35), y, z] if axis == 'z' else [x, y, z + (0.0 if closed else 0.43)]
    size = [0.29, 0.035, 0.02] if axis == 'z' else [0.02, 0.035, 0.38]
    s.box(key, pos, size, g.DRIVE, name='Equipment', conveyor_hardware=True)
    end = [x + 0.44, y, z] if axis == 'z' else [x, y, z + 0.51]
    s.beam(key + '_rod', g.add(pos, [0.145, 0, 0] if axis == 'z' else [0, 0, 0.19]), end, 0.008, g.STEEL, conveyor_hardware=True)
    body = [x + 0.45, y, z] if axis == 'z' else [x, y, z + 0.51]
    s.cyl(key + '_cylinder', body, 0.024, 0.14, g.STEEL, 'x' if axis == 'z' else 'z', conveyor_hardware=True)
    mount = [x + 0.31, y - 0.07, z] if axis == 'z' else [x, y - 0.07, z + 0.38]
    s.box(key + '_mount', mount, [0.3, 0.1, 0.06] if axis == 'z' else [0.06, 0.1, 0.32], g.STEEL, conveyor_hardware=True)

def arrival_clamp(s, key, x, y, z, half, closed, axis='z'):
    for sign in (-1, 1):
        span = half + 0.012 + (0.0 if closed else 0.1)
        p = [x + sign * span, y, z] if axis == 'z' else [x, y, z + sign * span]
        s.box(key + '_jaw' + str(sign), p, [0.024, 0.05, 0.13] if axis == 'z' else [0.13, 0.05, 0.024], g.DRIVE, name='Equipment', conveyor_hardware=True)
        end = [x + sign * (half + 0.2), y, z] if axis == 'z' else [x, y, z + sign * (half + 0.2)]
        s.beam(key + '_rod' + str(sign), p, end, 0.008, g.STEEL, conveyor_hardware=True)
        s.cyl(key + '_cylinder' + str(sign), end, 0.025, 0.1, g.STEEL, 'x' if axis == 'z' else 'z', conveyor_hardware=True)
        mount = [x + sign * (half + 0.11), y - 0.085, z] if axis == 'z' else [x, y - 0.085, z + sign * (half + 0.11)]
        s.box(key + '_mount' + str(sign), mount, [0.22, 0.12, 0.07] if axis == 'z' else [0.07, 0.12, 0.22], g.STEEL, conveyor_hardware=True)

def layout_liquid(s):
    old_layout['liquid'](s)
    remove(s, 'batch_exchange')
    remove(s, 'refill_pipe')
    s.frame('batch_exchange', 0, 2.9, 1.3, 1.3, 1.0)
    s.box('batch_exchange_surface', [0, 0.98, 2.9], [1.23, 0.035, 1.23], g.STEEL, name='Equipment')
    s.cyl('batch_exchange_spindle', [0, 1.055, 2.9], 0.07, 0.16, g.STEEL)
    s.box('batch_exchange_drive', [0.18, 1.03, 2.9], [0.2, 0.1, 0.14], g.DRIVE)
    s.line('refill_pipe', [[0, 1.11, 1.35], [0, 1.3, 1.35], [0, 1.4, 2.18]], 0.022, g.BLUE)
    s.box('batch_coupler_support', [0, 1.26, 2.16], [0.16, 0.28, 0.14], g.STEEL)

def draw_liquid(s, f):
    old_draw['liquid'](s, f)
    physical = f['plant']['physical']
    states = physical.get('transport', {})
    exchange = physical['batch_exchange']
    angle = exchange['angle']
    s.cyl('batch_carousel', [0, 1.125, 2.9], 0.58, 0.05, g.STEEL, name='Equipment', conveyor_hardware=True)
    s.beam('batch_coupler', [0, 1.4, 2.16], [0, 1.4, exchange['coupler_z']], 0.018, g.DRIVE, conveyor_hardware=True)
    for j in range(3):
        a = angle + j * 2 * g.math.pi / 3
        x = 0.4 * g.math.sin(a)
        z = 2.9 - 0.4 * g.math.cos(a)
        key = 'batch' + str(j)
        s.box(key, [x, 1.39, z], [0.28, 0.48, 0.3], g.LIGHT, name='Equipment' + str(j + 1), material=True)
        s.nodes[key]['material'] = True
        s.poses[key]['r'] = -a
        level = physical['batch_remaining'] / 160 if j == physical['batch_index'] else 0 if j < physical['batch_index'] else 1
        fill = [x + 0.156 * g.math.sin(a), 1.39, z - 0.156 * g.math.cos(a)]
        s.box('batch_fill' + str(j), fill, [0.2, 0.34 * level + 0.001, 0.014], g.BLUE)
        s.poses['batch_fill' + str(j)]['r'] = -a
        for sign in [-1, 1]:
            xx = x + sign * 0.152 * g.math.cos(a)
            zz = z + sign * 0.152 * g.math.sin(a)
            holder = 'batch_locator' + str(j) + '_' + str(sign)
            s.box(holder, [xx, 1.175, zz], [0.024, 0.05, 0.26], g.DRIVE, conveyor_hardware=True)
            s.poses[holder]['r'] = -a
    for side, x in [('a', -1.3), ('b', 1.3)]:
        st = states.get(side, {})
        gates = {a['id']: a for a in st.get('stops', [])}
        for index, target in enumerate(STOP_CENTRES):
            side_stop(s, side + '_stop_' + str(index), 'z', x, 0.857, target - 0.145, gates.get('stop_' + str(index), {}).get('closed', False))
        held = {c['id'] for c in st.get('clamps', [])}
        for index in range(3):
            arrival_clamp(s, side + '_arrival_' + str(index), x, 0.87, 3.0 + index * 0.6, 0.135, 'arrival_' + str(index) in held)

def layout_weigh(s):
    old_layout['weigh'](s)
    for x in [-1.25, 1.25, 3.15]:
        remove(s, 'cross_' + str(x))
        key = 'cross_' + str(x)
        s.frame(key + '_stand', x, 0, 0.62, 2.25, 0.86)
        for sign in [-1, 1]:
            s.box(key + '_guide' + str(sign), [x + sign * 0.24, 0.98, 0], [0.04, 0.05, 2.16], g.STEEL)
        s.beam(key + '_screw', [x, 0.91, -1.05], [x, 0.91, 1.05], 0.012)
        s.cyl(key + '_drive', [x, 0.91, 1.13], 0.055, 0.16, g.DRIVE, 'z')
    remove(s, 'rail_-1.66')
    s.bed('rail_-1.66', -1.68, 0, 0.44, 0.42, 1.22)
    for n, z in [(1, -0.85), (2, 0.85)]:
        remove(s, 'kit_lane' + str(n))
        s.bed('kit_lane' + str(n), 0, z, 2.06, 0.44, 1.22)
        remove(s, 'exit' + str(n))
        s.bed('exit' + str(n), 4.595, z, 2.47, 0.44, 1.22)

def draw_weigh(s, f):
    old_draw['weigh'](s, f)
    q = f['plant']['physical']
    for cid, c in q['carriages'].items():
        key = 'cross_' + cid
        x = c['x']
        z = c['z']
        top = c['top']
        s.node(key + '_surface', [x, top - 0.02, z], [0.38, 0.04, 0.4], '#252e34', 'conveyor_belt', name='Equipment', conveyor=dict(axis='x', radius=0.02, belt_width=0.37, length=0.38, source=key + '_surface'), conveyor_hardware=True)
        for sign in [-1, 1]:
            s.box(key + '_bearing' + str(sign), [x + sign * 0.24, 1.01, z], [0.07, 0.06, 0.38], g.DRIVE, conveyor_hardware=True)
            s.box(key + '_crossbar' + str(sign), [x, 1.01, z + sign * 0.15], [0.55, 0.06, 0.045], g.STEEL, conveyor_hardware=True)
            s.cyl(key + '_lift_body' + str(sign), [x + sign * 0.1, 0.93, z], 0.026, 0.14, g.DRIVE, conveyor_hardware=True)
            s.beam(key + '_lift_rod' + str(sign), [x + sign * 0.1, 1.0, z], [x + sign * 0.1, top - 0.045, z], 0.012, g.STEEL, conveyor_hardware=True)
            s.box(key + '_deckrail' + str(sign), [x, top - 0.032, z + sign * 0.218], [0.38, 0.065, 0.035], g.STEEL, conveyor_hardware=True)
            s.cyl(key + '_drum' + str(sign), [x + sign * 0.17, top - 0.02, z], 0.013, 0.37, g.STEEL, 'z', conveyor_hardware=True)
            s.cyl(key + '_shaft' + str(sign), [x + sign * 0.17, top - 0.02, z], 0.005, 0.47, g.STEEL, 'z', conveyor_hardware=True)
            jaw_z = z + sign * (0.187 + (0 if c['clamped'] else 0.09))
            s.box(key + '_jaw' + str(sign), [x, top + 0.045, jaw_z], [0.14, 0.045, 0.024], g.DRIVE, conveyor_hardware=True)
            s.beam(key + '_jaw_rod' + str(sign), [x, top + 0.045, jaw_z], [x, top + 0.045, z + sign * 0.34], 0.007, g.STEEL, conveyor_hardware=True)
            s.cyl(key + '_jaw_drive' + str(sign), [x, top + 0.045, z + sign * 0.35], 0.023, 0.1, g.STEEL, 'z', conveyor_hardware=True)
            s.box(key + '_jaw_mount' + str(sign), [x, top - 0.005, z + sign * 0.285], [0.07, 0.065, 0.17], g.STEEL, conveyor_hardware=True)
        s.box(key + '_belt_motor', [x - 0.17, top - 0.035, z - 0.31], [0.09, 0.065, 0.13], g.DRIVE, conveyor_hardware=True)
        s.beam(key + '_motor_shaft', [x - 0.17, top - 0.02, z - 0.25], [x - 0.17, top - 0.02, z - 0.38], 0.006, g.STEEL, conveyor_hardware=True)
    for name, axis, cross, centres in [('source', 'x', 0.0, [-4.5, -3.9, -3.3, -2.7, -2.1]), ('accept', 'x', -0.85, [3.6, 4.1, 4.6, 5.1, 5.6]), ('hold', 'x', 0.85, [3.6, 4.1, 4.6, 5.1, 5.6])]:
        state = q.get('transport', {}).get(name, {})
        gates = state.get('stops', [])
        for index, centre in enumerate(centres):
            closed = any((abs(st['face'] - (centre + 0.175)) < 1e-07 and st['closed'] for st in gates))
            side_stop(s, name + '_stop_' + str(index), 'x', centre + 0.185, 1.26, cross, closed)
        if name == 'source':
            held = {a['id'] for a in state.get('clamps', [])}
            for i in range(1, 5):
                arrival_clamp(s, 'source_arrival_' + str(i), -3.6 - 0.6 * (i - 1), 1.27, 0.0, 0.175, 'arrival_' + str(i) in held, 'x')
