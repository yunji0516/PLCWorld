import math
GUIDE = (-0.4, -0.55)

def rotate_yz(p, a):
    return (p[0] * math.cos(a) - p[1] * math.sin(a), p[0] * math.sin(a) + p[1] * math.cos(a))

def corners(depth=0.42):
    return [(-0.154, -depth / 2 - 0.004), (-0.154, depth / 2 + 0.004), (0.154, depth / 2 + 0.004), (0.154, -depth / 2 - 0.004)]

def tangent(a, depth=0.42):
    pts = [rotate_yz(v, a) for v in corners(depth)]
    for i, v in enumerate(pts):
        ray = (v[0] - GUIDE[0], v[1] - GUIDE[1])
        if all((ray[0] * (w[1] - GUIDE[1]) - ray[1] * (w[0] - GUIDE[0]) >= -1e-10 for w in pts)):
            return (i, pts)
    raise AssertionError('convex tangent not found')
