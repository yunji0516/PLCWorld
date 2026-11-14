import math
TOP = 0.8505
LEADER = 1.4
TOTAL = 3.2
R = 0.07
GR = 0.035

def sections(stored):
    fixed = 0.465 + 0.375 + math.pi * GR + math.pi * R
    h = (LEADER + stored - fixed) / 2
    y = TOP - GR - h
    return [('line', 0.465, [-0.65, TOP], [-0.185, TOP]), ('arc', math.pi * GR / 2, [-0.185, TOP - GR, GR], [math.pi / 2, 0]), ('line', h, [-0.15, TOP - GR], [-0.15, y]), ('arc', math.pi * R, [-0.08, y, R], [math.pi, 2 * math.pi]), ('line', h, [-0.01, y], [-0.01, TOP - GR]), ('arc', math.pi * GR / 2, [0.025, TOP - GR, GR], [math.pi, math.pi / 2]), ('line', 0.375, [0.025, TOP], [0.4, TOP])]

def along_path(distance, stored):
    if distance < 0:
        return [-0.65 + distance, TOP, 0.0]
    for kind, length, a, b in sections(stored):
        if distance <= length + 1e-09:
            t = max(0, min(1, distance / length))
            if kind == 'line':
                return [a[0] + (b[0] - a[0]) * t, a[1] + (b[1] - a[1]) * t, 0.0]
            angle = b[0] + (b[1] - b[0]) * t
            return [a[0] + a[2] * math.cos(angle), a[1] + a[2] * math.sin(angle), 0.0]
        distance -= length
    return [0.4, TOP, 0.0]
