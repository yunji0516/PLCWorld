"""Detailed display poses from recorded scans, without executing any controller."""
import copy
from types import SimpleNamespace
from .scene import Scene
from . import collection_transport, station_transport, corner_transport, jig_transport, priority_geometry
from .material_conveyor_geometry import upgrade
from .material_transport_contracts import names

def stop_catalog(frames):
    result = {}
    for f in frames:
        for name, d in f['plant']['physical'].get('transport', {}).items():
            if name == 'deck':
                continue
            entry = result.setdefault(name, {'axis': d['axis'], 'stops': {}})
            for stop in d.get('stops', []):
                entry['stops'][stop['id']] = dict(stop, closed=False)
    return result

def project(task, frames, *, parameters=None):
    ident = task.removeprefix('MAT-')
    normalized = [{'plant': f.get('plant', f.get('state_after')), 'scan': f['scan'],
                   'time_ms': f.get('time_ms', f.get('time_end_ms'))} for f in frames]
    if any(f['plant'] is None for f in normalized):
        raise ValueError('Missing recorded physical state')
    stops = stop_catalog(normalized)
    if ident == 'H07':
        layout, draw = priority_geometry.h07_layout, priority_geometry.h07_draw
    elif ident == 'H03':
        jig_transport.CAT = stops
        layout, draw = jig_transport.old.layout, jig_transport.draw
    elif ident in ['H09', 'H14']:
        mode = 'liquid' if ident == 'H09' else 'weigh'
        layout, draw = getattr(station_transport, 'layout_' + mode), getattr(station_transport, 'draw_' + mode)
    elif ident in ['H10', 'H12']:
        mode = 'magazine' if ident == 'H10' else 'scrap'
        corner_transport.CATALOG[mode] = stops
        layout = lambda s: corner_transport.layout(s, mode)
        draw = lambda s, f: corner_transport.draw(s, f, mode)
    else:
        collection_transport.STOP_CATALOG = stops
        g = collection_transport.geometry(SimpleNamespace(ID=ident))
        layout, draw = g.layout, g.draw
    s = Scene()
    layout(s)
    s.dynamic = True
    projected = []
    for f in normalized:
        # Geometry helpers never mutate the caller's archived frame.
        f = copy.deepcopy(f)
        q = f['plant']['physical']
        if ident == 'H09':
            cap = q['capper']
            poses = {'capper': {'pos': capper_position(cap, (parameters or {}).get('cap_s', 1.6))}}
            for side, x in [('a', -1.3), ('b', 1.3)]:
                poses['nozzle_' + side] = {'pos': [x, 1.53 - .34 * q['nozzles'][side], 0]}
                poses['clamp_' + side] = {'pos': [x + .23 - .07 * q['clamps'][side], .97, 0]}
            f['plant']['material_hard']['poses'] = poses
        s.poses = {}
        draw(s, f)
        projected.append({'t': f['time_ms'] / 1000, 'scan': f['scan'], 'phase': '',
                          'poses': copy.deepcopy(s.poses), 'belt_motion': belt_motion(ident, q), 'raw': {}, 'received': [], 'requests': []})
    run = {'nodes': list(s.nodes.values()), 'frames': projected}
    if ident != 'H07':
        upgrade(run, ident)
    labels = names(ident)
    for node in run['nodes']:
        node['name'] = node['id'].replace('_', ' ').strip()
    run['nodes'] = [n for n in run['nodes'] if n['shape'] != 'label']
    devices = [{'id': n['id'], 'label': n['name'], 'kind': 'static', 'ui': 'fixture',
                'pos': n['p'], 'size': n['size'], 'visual_variant': 'cell3-priority-anchor'}
               for n in run['nodes'] if n['id'] in labels]
    compacted = compact_frames(run['frames'])
    return {'schema': 'recorded-material-geometry/2', 'task': task,
            'devices': devices, 'nodes': run['nodes'], **compacted}


def belt_motion(ident, physical):
    transport = physical.get('transport', {})
    motion = {}
    for name, state in transport.items():
        if 'distance' not in state or 'velocity' not in state:
            continue
        node = ('unit_supply' if name == 'units' else name) + '_surface'
        if ident == 'H09':
            node = 'supply_fill_receive_' + name + '_surface'
        elif ident in ('H10', 'H12'):
            prefix = 'consumer_pickup_' if ident == 'H10' else 'external_pickup_'
            node = (prefix if name.startswith('exit') else 'product_input_') + name[-1] + '_surface'
        elif ident == 'H14':
            node = {'source': 'rail_-4.05_surface', 'accept': 'exit1_surface', 'hold': 'exit2_surface'}.get(name, node)
        motion[node] = dict(distance=state['distance'], velocity=state['velocity'])
    if ident == 'H02':
        for node, state in list(motion.items()):
            if node.startswith('slot'):
                target = node.split('_')[0] + '_surface'
                if state['velocity'] or target not in motion:
                    motion[target] = state
    if ident == 'H06':
        if 'receiver_waste_surface' in motion:
            motion['waste_cross_surface'] = motion.pop('receiver_waste_surface')
        motion['exit_surface'] = next((v for k,v in motion.items() if k in ('receiver_a_surface','receiver_b_surface') and v['velocity']), dict(distance=0, velocity=0))
    if ident == 'H13' and 'exit_surface' in motion:
        motion['takeaway_surface'] = motion['exit_surface']
    if ident == 'H14':
        for name, state in physical['carriages'].items():
            motion['cross_' + name + '_surface'] = dict(distance=state['belt_distance'], velocity=state['belt_velocity'])
    return motion


def compact_frames(frames):
    """Intern repeated poses; every scan retains its complete visible state."""
    import json
    pool, indices, output = [], {}, []
    for frame in frames:
        poses = {}
        for node, pose in frame['poses'].items():
            key = json.dumps(pose, sort_keys=True, separators=(',', ':'))
            index = indices.get(key)
            if index is None:
                index = len(pool)
                indices[key] = index
                pool.append(pose)
            poses[node] = index
        output.append({**frame, 'poses': poses})
    return {'frames': output, 'pose_table': pool}


def capper_position(capper, duration):
    """Recover head height from the recorded service clock and case calibration."""
    job = capper.get('job')
    elapsed = job['t'] if job else 0.0
    down = max(0.0, min(1.0, elapsed / .4, (duration - elapsed) / .4)) if job else 0.0
    return [capper['x'], 1.45 - .25 * down, -1.0]
