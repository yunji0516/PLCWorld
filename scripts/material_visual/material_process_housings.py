from .material_station_geometry import FRAME, STEEL, DRIVE, LIGHT

def plinth(s, key, x, z, width, depth, top=0.72):
    y = (top + 0.12) / 2
    height = top - 0.12
    for sign in [-1, 1]:
        s.box(key + '_side' + str(sign), [x + sign * (width / 2 - 0.009), y, z], [0.018, height, depth], LIGHT)
        s.box(key + '_door' + str(sign), [x, y, z + sign * (depth / 2 - 0.009)], [width - 0.04, height, 0.018], LIGHT)
        s.box(key + '_handle' + str(sign), [x + width * 0.27, y + 0.06, z + sign * (depth / 2 + 0.008)], [0.014, 0.13, 0.018], FRAME)
    s.box(key + '_door_seam', [x, y, z + depth / 2 + 0.001], [0.007, height - 0.04, 0.004], FRAME)
    for n in range(4):
        s.box(key + '_vent' + str(n), [x - width * 0.23, 0.23 + n * 0.035, z + depth / 2 + 0.003], [width * 0.27, 0.009, 0.005], FRAME)
    for dx in [-width * 0.38, width * 0.38]:
        for dz in [-depth * 0.38, depth * 0.38]:
            s.cyl(key + '_foot' + str(dx) + str(dz), [x + dx, 0.055, z + dz], 0.033, 0.09, FRAME)

def backboard(s, key, x, z, width, lower=0.82, upper=1.55):
    for sign in [-1, 1]:
        s.box(key + '_upright' + str(sign), [x + sign * width / 2, (lower + upper) / 2, z], [0.035, upper - lower, 0.035], FRAME)
    s.box(key + '_cross', [x, upper, z], [width + 0.035, 0.035, 0.04], FRAME)
    s.box(key + '_rear_guard', [x, (lower + upper) / 2, z], [width - 0.035, upper - lower - 0.06, 0.01], STEEL, opacity=0.22)

def guides(s, key, x, z, width, length, top=0.85, axis='z'):
    for sign in [-1, 1]:
        p = [x + sign * width / 2, top + 0.065, z] if axis == 'z' else [x, top + 0.065, z + sign * width / 2]
        size = [0.014, 0.035, length] if axis == 'z' else [length, 0.035, 0.014]
        s.box(key + '_guide' + str(sign), p, size, STEEL)
        for along in [-length * 0.35, length * 0.35]:
            at = [p[0], top + 0.025, z + along] if axis == 'z' else [x + along, top + 0.025, p[2]]
            s.box(key + '_mount' + str(sign) + str(along), at, [0.026, 0.045, 0.026], FRAME)
