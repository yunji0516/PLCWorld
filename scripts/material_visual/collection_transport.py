import types
from types import SimpleNamespace
from . import material_controls_geometry as c
from .material_station_geometry import DRIVE,STEEL
from .stops import states
STOP_CATALOG={}
def old_geometry(m):
 return SimpleNamespace(layout=lambda s:c.layout(s,m.ID),draw=lambda s,f:c.draw(s,f,m.ID))
def geometry(m):
    original = old_geometry(m)
    stop_catalog = STOP_CATALOG

    def layout(s):
        original.layout(s)
        if m.ID == 'H06':
            from .material_controls_geometry import gantry
            gantry(s, 'waste_transfer', 0.2, 3.2, -0.25, 0.25, 1.35)
            for z in [-0.25, 0.25]:
                s.box('waste_transfer_xrail' + str(z), [1.7, 1.35, z], [3.065, 0.065, 0.065], STEEL)
            s.beam('waste_transfer_xscrew', [0.2, 1.3, 0.25], [3.28, 1.3, 0.25], 0.008, STEEL)
            s.nodes['waste_transfer_drive']['p'] = [3.3, 1.3, 0.25]
        if m.ID == 'H13':
            for k in list(s.nodes):
                if k.startswith('exit_'):
                    del s.nodes[k]
            s.bed('exit', 0, -1.5, 0.68, 1.0, 0.95, 'x')
            for x in [1.47, 1.55]:
                s.cyl('unit_nose_drum' + str(x), [x, 0.932, 2.5], 0.018, 0.145, STEEL, 'z')
                s.cyl('unit_nose_shaft' + str(x), [x, 0.932, 2.5], 0.006, 0.235, STEEL, 'z')
                for sign in [-1, 1]:
                    s.box('unit_nose_bearing' + str(x) + str(sign), [x, 0.932, 2.5 + sign * 0.103], [0.05, 0.044, 0.025], STEEL)
            s.box('unit_nose_drive', [1.55, 0.923, 2.675], [0.09, 0.065, 0.105], DRIVE)

    def draw(s, f):
        original.draw(s, f)
        if m.ID == 'H02':
            q = f['plant']['physical']
            x = q['cart_x']
            s.nodes['deck'].update(shape='conveyor_belt', size=[0.38, 0.05, 0.36], conveyor=dict(axis='z', radius=0.025, belt_width=0.33, length=0.36, source='deck_surface'), conveyor_hardware=True)
            s.poses['deck'].update(p=[x, 0.825, 0], s=[0.38, 0.05, 0.36])
            s.poses['deck_belt_motor'].update(p=[x + 0.25, 0.825, 0.155])
            for old_z, sign in [(-0.145, -1), (0.145, 1)]:
                s.poses['deck_belt_roller' + str(old_z)].update(p=[x, 0.825, sign * 0.155], s=[0.018, 0.33, 0.018])
            for sign in [-1, 1]:
                s.box('deck_side_rail' + str(sign), [x + sign * 0.187, 0.815, 0], [0.028, 0.05, 0.36], STEEL, conveyor_hardware=True)
                s.box('deck_cross_mount' + str(sign), [x, 0.79, sign * 0.12], [0.38, 0.02, 0.035], STEEL, conveyor_hardware=True)
                s.cyl('deck_shaft' + str(sign), [x, 0.825, sign * 0.155], 0.005, 0.56 if sign > 0 else 0.42, STEEL, 'x', conveyor_hardware=True)
        if m.ID == 'H04':
            q = f['plant']['physical']
            n = q['nip']
            x = q['cart']
            y = n['y']
            z = 0.16
            s.cyl('pouch_nip', [x, y, z], 0.014, 0.1, DRIVE, 'x', conveyor_hardware=True, name='Equipment')
            for sign in [-1, 1]:
                s.box('nip_lift_guide' + str(sign), [x + sign * 0.105, 0.94, z], [0.028, 0.18, 0.045], STEEL, conveyor_hardware=True)
                s.box('nip_bearing' + str(sign), [x + sign * 0.09, y, z], [0.03, 0.035, 0.035], STEEL, conveyor_hardware=True)
            s.cyl('nip_shaft', [x, y, z], 0.004, 0.17, STEEL, 'x', conveyor_hardware=True)
            s.box('nip_motor', [x + 0.16, y, z], [0.09, 0.06, 0.06], DRIVE, conveyor_hardware=True)
        if m.ID == 'H06':
            from .material_controls_geometry import bridge
            h = f['plant']['physical'].get('waste_gripper') or dict(x=0.65, y=1.1, z=0.0, grip=0.0)
            x, y, z = (h['x'], h['y'], h['z'])
            gap = 0.12 * (1 - h['grip'])
            s.box('waste_grip_carriage', [x, 1.29, 0], [0.12, 0.07, 0.55], DRIVE, conveyor_hardware=True)
            for rail_z in [-0.25, 0.25]:
                s.box('waste_grip_bearing' + str(rail_z), [x, 1.325, rail_z], [0.16, 0.08, 0.1], DRIVE, conveyor_hardware=True)
            s.beam('waste_grip_lift', [x, 1.255, 0.2], [x, y + 0.07, 0.2], 0.012, STEEL, conveyor_hardware=True)
            s.box('waste_grip_bridge', [x, y + 0.07, 0], [0.07, 0.035, 0.45], STEEL, conveyor_hardware=True)
            for sign in [-1, 1]:
                zz = sign * (0.072 + gap)
                s.box('waste_edge_jaw' + str(sign), [x, y, zz], [0.055, 0.03, 0.024], DRIVE, conveyor_hardware=True)
                s.box('waste_edge_stem' + str(sign), [x, y + 0.035, zz], [0.055, 0.04, 0.024], STEEL, conveyor_hardware=True)
                s.beam('waste_edge_rod' + str(sign), [x, y + 0.035, zz], [x, y + 0.035, sign * 0.24], 0.006, STEEL, conveyor_hardware=True)
            for name, d in states(f['plant']['physical'], stop_catalog).items():
                for a in d['stops']:
                    sign = 1 if name == 'receiver_a' else -1
                    xx = a['cross']
                    zz = a['face'] + sign * 0.006
                    off = 0 if a['closed'] else -0.22
                    s.box(a['id'], [xx + off, 0.9471, zz], [0.12, 0.025, 0.012], DRIVE, conveyor_hardware=True)
                    height = 0.8 if name == 'receiver_waste' else 0.9471
                    s.beam(a['id'] + '_rod', [xx - 0.3, height, zz], [xx - 0.06 + off, height, zz], 0.006, STEEL, conveyor_hardware=True)
                    if name == 'receiver_waste':
                        s.box(a['id'] + '_riser', [xx - 0.06 + off, (height + 0.9471) / 2, zz], [0.012, 0.9471 - height, 0.012], STEEL, conveyor_hardware=True)
                    s.cyl(a['id'] + '_drive', [xx - 0.35, height, zz], 0.018, 0.16, STEEL, 'x', conveyor_hardware=True)
                    s.box(a['id'] + '_mount', [xx - 0.25, height - 0.0471, zz], [0.36, 0.05, 0.028], STEEL, conveyor_hardware=True)
            return
        for name, d in states(f['plant']['physical'], stop_catalog).items():
            for a in d['stops']:
                axis = d['axis']
                sign = -1 if name in ('source', 'units', 'pouch_feed') or name.endswith('_reverse') or m.ID == 'H05' else 1
                span = (0.52 if name == 'source' else 0.6 if name == 'exit' else 0.16) if m.ID == 'H13' else 0.27
                span = 0.64 if name == 'box_lane' else span
                top = 0.8 if name == 'box_lane' else 0.95 if m.ID == 'H13' else 0.85
                travel = span + 0.04
                off = 0 if a['closed'] else travel
                y = top + 0.0126

                def xyz(along, across, height=y):
                    return [along, height, a['cross'] + across] if axis == 'x' else [a['cross'] + across, height, along]
                thickness = 0.036 if m.ID == 'H04' and name == 'pouch_feed' and (abs(a['face'] + 0.18) < 1e-07) else 0.012
                face = a['face'] + sign * thickness / 2
                size = [thickness, 0.025, span] if axis == 'x' else [span, 0.025, thickness]
                s.box(a['id'], xyz(face, off), size, DRIVE, conveyor_hardware=True, name='Equipment')
                far = span / 2 + travel + 0.025
                actuator_y = top - 0.14 if m.ID == 'H02' else y
                s.beam(a['id'] + '_rod', xyz(face, span / 2 + off, actuator_y), xyz(face, far, actuator_y), 0.005, STEEL, conveyor_hardware=True)
                s.cyl(a['id'] + '_cylinder', xyz(face, far + 0.04, actuator_y), 0.012, 0.12, STEEL, 'z' if axis == 'x' else 'x', conveyor_hardware=True)
                if m.ID == 'H02':
                    s.box(a['id'] + '_riser', xyz(face, span / 2 + off, (actuator_y + y) / 2), [thickness, y - actuator_y, 0.006] if axis == 'x' else [0.006, y - actuator_y, thickness], STEEL, conveyor_hardware=True)
                mountspan = far - span / 2 + 0.09
                centre = span / 2 + 0.022 + mountspan / 2
                s.box(a['id'] + '_mount', xyz(face, centre, top - 0.043), [0.012, 0.075, mountspan] if axis == 'x' else [mountspan, 0.075, 0.012], STEEL, conveyor_hardware=True)
    return types.SimpleNamespace(**{**vars(original), 'draw': draw, 'layout': layout})
