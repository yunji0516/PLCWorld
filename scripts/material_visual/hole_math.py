import math

def hole_z(amount, index):
    return (index - (amount - 1) / 2) * (0.135 if amount == 3 else 0.18)
