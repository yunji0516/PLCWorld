def states(physical, catalog):
    current = physical.get('transport', {})
    result = {}
    for name, entry in catalog.items():
        d = current.get(name, {})
        present = {s['id']: s for s in d.get('stops', [])}
        result[name] = dict(d, axis=entry['axis'], stops=[present.get(k, s) for k, s in entry['stops'].items()])
    return result
