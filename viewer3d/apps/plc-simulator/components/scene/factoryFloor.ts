type Footprint = { pos: [number, number, number]; size: [number, number, number]; rot: number }

// Fixed envelopes of the active synthetic Material Hard cells, in world X/Z.
// Includes outfeed endpoints and moving assemblies; not the placeholder CELL box.
// Evidence: results/material-hard10-strengthening/visual-before/inspection.json.
// The .75 m drawing margin is not a certified personnel safety distance.
const hardExtents: Record<string, [number, number, number, number]> = {
  'MAT-H01': [-2.88, -2.05, 4.16, 1.30],
  'MAT-H02': [-5.01, -1.91, 7.81, 2.14],
  'MAT-H03': [-5.65, -1.44, 2.48, 5.18],
  'MAT-H04': [-4.10, -3.67, 6.86, 1.40],
  'MAT-H05': [-3.86, -5.23, 3.86, 2.03],
  'MAT-H06': [-3.80, -.45, 9.66, 1.94],
  'MAT-H08': [-4.33, -.52, 3.24, 5.35],
  'MAT-H09': [-1.56, -3.71, 1.77, 2.88],
  'MAT-H14': [-5.75, -2.54, 5.54, 1.34],
  'MAT-H15': [-1.97, -2.76, 5.16, 3.76],
}
export function materialHardCellBounds(title = '') {
  const id = title.match(/^MAT-H\d{2}(?=\s|$)/)?.[0]
  const extent = id && hardExtents[id]
  if (!extent) return undefined
  const [left, back, right, front] = extent
  return { x: (left + right) / 2, z: (back + front) / 2,
    width: right - left + 1.5, depth: front - back + 1.5 }
}

/** Fixed paint position in cell-local Z, not tied to orbit/zoom. */
export function operatorBandZ(depth: number, frontSign: 1 | -1 = 1) {
  return frontSign * (depth / 2 - .24)
}

/** Visual floor paint only, not a collision boundary or safety evaluation zone. */
export function factoryCellBounds(devices: Footprint[]) {
  if (!devices.length) return { x: 0, z: 0, width: 3, depth: 2.6 }
  let left = Infinity, right = -Infinity, back = Infinity, front = -Infinity
  for (const d of devices) {
    const c = Math.abs(Math.cos(d.rot)), s = Math.abs(Math.sin(d.rot))
    const halfX = (d.size[0] * c + d.size[2] * s) / 2
    const halfZ = (d.size[0] * s + d.size[2] * c) / 2
    left = Math.min(left, d.pos[0] - halfX); right = Math.max(right, d.pos[0] + halfX)
    back = Math.min(back, d.pos[2] - halfZ); front = Math.max(front, d.pos[2] + halfZ)
  }
  return { x: (left + right) / 2, z: (back + front) / 2,
    width: Math.max(3, right - left + 1.2), depth: Math.max(2.6, front - back + 1.2) }
}
