from . import material_h03_jig_geometry as old
from .material_station_geometry import DRIVE,STEEL
from .stops import states
CAT={}
def draw(s, f):
    old.draw(s, f)
    for side, x in [('left', -1.2), ('right', 1.2)]:
        y = f['plant']['physical']['lifts'][side]['y']
        s.cyl(side + '_deck_motor', [x - 0.15, y - 0.05, -0.25], 0.035, 0.13, DRIVE, 'z', conveyor_hardware=True)
        s.beam(side + '_deck_driveshaft', [x - 0.15, y - 0.012, -0.31], [x - 0.15, y - 0.012, 0.2], 0.005, STEEL, conveyor_hardware=True)
        s.box(side + '_deck_motor_mount', [x - 0.15, y - 0.065, -0.21], [0.085, 0.025, 0.11], STEEL, conveyor_hardware=True)
    for name, d in states(f['plant']['physical'], CAT).items():
        axis = d['axis']
        sign = -1 if name == 'lower' else 1
        top = 0.35 if name == 'lower' else 0.85
        span = 0.26 if axis == 'x' else 0.15
        for a in d['stops']:
            face = a['face'] + sign * 0.006
            off = 0.0 if a['closed'] else 0.3

            def xyz(along, cross, y=top + 0.015):
                return [along, y, a['cross'] + cross] if axis == 'x' else [a['cross'] + cross, y, along]
            s.box(a['id'], xyz(face, off), [0.012, 0.025, span] if axis == 'x' else [span, 0.025, 0.012], DRIVE, conveyor_hardware=True)
            s.beam(a['id'] + '_rod', xyz(face, span / 2 + off), xyz(face, 0.46), 0.006, STEEL, conveyor_hardware=True)
            s.cyl(a['id'] + '_drive', xyz(face, 0.5), 0.02, 0.12, STEEL, 'z' if axis == 'x' else 'x', conveyor_hardware=True)
            s.box(a['id'] + '_mount', xyz(face, 0.32, top - 0.05), [0.014, 0.1, 0.28] if axis == 'x' else [0.28, 0.1, 0.014], STEEL, conveyor_hardware=True)
