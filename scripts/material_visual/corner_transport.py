from . import material_visual_geometry as old
from .material_station_geometry import DRIVE, STEEL
from .stops import states
CATALOG={}
old_layout={"magazine":old.layout_magazine,"scrap":old.layout_scrap}
old_draw={"magazine":old.draw_magazine,"scrap":old.draw_scrap}
def layout(s, mode):
    old_layout[mode](s)
    xs = [-1.3, 1.3] if mode == 'magazine' else [-1.25, 1.25]
    z = -1.8 if mode == 'magazine' else -2.0
    top = 0.99 if mode == 'magazine' else 1.147
    for side, x in zip('ab', xs):
        s.frame('transverse_pusher_' + side, x - 0.6, z, 0.3, 0.25, top - 0.11)
    if mode == 'scrap':
        for side, x in zip('ab', xs):
            for z in [0.2, 0.27]:
                s.cyl('press_feed_nip_' + side + str(z), [x, 1.132, z], 0.015, 0.44, STEEL, 'x')
                for sign in [-1, 1]:
                    s.box('press_feed_bearing_' + side + str(z) + str(sign), [x + sign * 0.24, 1.13, z], [0.025, 0.04, 0.045], STEEL)
            s.cyl('press_feed_drive_' + side, [x + 0.29, 1.13, 0.27], 0.035, 0.08, DRIVE, 'x')

def draw(s, f, mode):
    old_draw[mode](s, f)
    top = 0.99 if mode == 'magazine' else 1.147
    for name, d in states(f['plant']['physical'], CATALOG[mode]).items():
        for a in d['stops']:
            axis = d['axis']
            sign = -1 if axis == 'z' else 1
            span = 0.32 if mode == 'magazine' else 0.44
            travel = span + 0.03
            y = top + 0.016

            def at(along, across, height=y):
                return [along, height, a['cross'] + across] if axis == 'x' else [a['cross'] + across, height, along]
            face = a['face'] + sign * 0.006
            off = 0 if a['closed'] else travel
            s.box(a['id'], at(face, off), [0.012, 0.025, span] if axis == 'x' else [span, 0.025, 0.012], DRIVE, conveyor_hardware=True)
            far = span / 2 + travel + 0.03
            s.beam(a['id'] + '_rod', at(face, span / 2 + off), at(face, far), 0.006, STEEL, conveyor_hardware=True)
            s.cyl(a['id'] + '_drive', at(face, far + 0.05), 0.019, 0.13, STEEL, 'z' if axis == 'x' else 'x', conveyor_hardware=True)
            w = far - span / 2 + 0.08
            s.box(a['id'] + '_mount', at(face, span / 2 + 0.025 + w / 2, top - 0.045), [0.016, 0.085, w] if axis == 'x' else [w, 0.085, 0.016], STEEL, conveyor_hardware=True)
        if name.startswith('exit'):
            side = name[-1]
            origin = [-1.3 if side == 'a' else 1.3, 1.04, -1.8] if mode == 'magazine' else [-1.25 if side == 'a' else 1.25, 1.15, -2.0]
            p = d.get('pusher', dict(origin=origin, body_half=0.15 if mode == 'magazine' else 0.21, offset=0.0))
            x, y, z = p['origin']
            face = x - p['body_half'] - 0.006 + p['offset']
            h = 0.045 if mode == 'magazine' else 0.004
            key = name + '_transverse_pusher'
            s.box(key, [face, y, z], [0.012, h, 0.18 if mode == 'magazine' else 0.28], DRIVE, conveyor_hardware=True, name='Equipment')
            s.beam(key + '_rod', [x - 0.5, y, z], [face - 0.006, y, z], 0.006, STEEL, conveyor_hardware=True)
            s.cyl(key + '_drive', [x - 0.62, y, z], 0.026, 0.24, STEEL, 'x', conveyor_hardware=True)
            s.box(key + '_mount', [x - 0.62, top - 0.035, z], [0.12, 0.1, 0.15], STEEL, conveyor_hardware=True)
