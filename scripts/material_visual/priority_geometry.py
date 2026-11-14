import math, copy
STEEL = '#83949b'
FRAME = '#384f5a'
DRIVE = '#407e88'
LIGHT = '#d3dcdf'
DARK = '#394c55'

def h07_layout(s):
    from . import material_controls_geometry as g
    g.layout(s, 'H07')
    for k, n in s.nodes.items():
        if k.startswith('core_feed_rail'):
            n['p'][1] = 0.95 - math.sqrt(0.05 ** 2 - 0.039 ** 2) - 0.009
    for k in list(s.nodes):
        if k.startswith(('fixed_receiver-', 'receiver_leg-')):
            s.nodes.pop(k)
    for key in ['mandrel_stand', 'mandrel_slide']:
        s.nodes[key]['p'][2] += 0.68
    for sign in [-1, 1]:
        for i in range(15):
            zz = -0.68 - i * 0.085
            s.cyl(f'exit_v_roller{sign}_{i}', [0.45 + sign * 0.045, 0.86, zz], 0.025, 0.034, STEEL, 'z')
            s.box(f'exit_roller_foot{sign}_{i}', [0.45 + sign * 0.045, 0.74, zz], [0.025, 0.19, 0.025], FRAME)
    s.frame('exit_support', 0.45, -1.25, 0.34, 1.4, 0.65)
    s.box('exit_linear_rail', [0.68, 0.9, -0.92], [0.035, 0.035, 0.68], STEEL)
    s.cyl('exit_linear_motor', [0.68, 0.9, -0.52], 0.035, 0.12, DRIVE, 'z')
    s.sensor('core_seated_sensor', [0.62, 1.03, 0.4])
    s.sensor('exit_occupied_sensor', [0.64, 1.03, -0.7])
    s.sensor('exit_clear_sensor', [0.64, 1.03, -1.1])

def h07_draw(s, f):
    from . import material_controls_geometry as g
    g.draw(s, f, 'H07')
    stop = f['plant']['physical']['extension']['stop']
    s.box('core_stop', [0.45 + 0.16 * (1 - stop), 0.94, 0.323], [0.08, 0.025, 0.025], DRIVE)
    q = f['plant']['physical']
    r = q.get('receiver')
    p = f['plant']['parts'].get(str(r['id'])) if r else None
    zz = q['exit_pusher_z']
    s.box('exit_pusher_slide', [0.68, 0.9, zz], [0.08, 0.065, 0.1], DRIVE)
    s.box('exit_axial_pusher', [q['exit_pusher_x'], 0.95, zz], [0.18, 0.045, 0.008], DRIVE)
    s.beam('mandrel_drive_rod', [0.45, 0.95, 0.2 + 0.3 * q['mandrel']], [0.45, 0.95, 1.68], 0.025, STEEL)
