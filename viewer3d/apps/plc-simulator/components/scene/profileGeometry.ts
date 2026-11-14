import { ExtrudeGeometry, Path, Shape } from 'three'

/** Four recessed slots and a central bore, not a painted box face. */
export function makeSlottedProfile(edge: number, length: number) {
  const half = edge / 2, slot = edge * .12, recess = edge * .16
  const face = [[-half, half], [-slot, half], [-slot, half - recess],
    [slot, half - recess], [slot, half], [half, half]]
  const shape = new Shape()
  for (let side = 0; side < 4; side++) {
    const angle = -side * Math.PI / 2
    for (let i = 0; i < face.length; i++) {
      const [x, y] = face[i]
      const px = x * Math.cos(angle) - y * Math.sin(angle)
      const py = x * Math.sin(angle) + y * Math.cos(angle)
      if (side === 0 && i === 0) shape.moveTo(px, py)
      else shape.lineTo(px, py)
    }
  }
  shape.closePath()
  const bore = new Path()
  bore.absarc(0, 0, edge * .13, 0, Math.PI * 2, false)
  shape.holes.push(bore)
  const geometry = new ExtrudeGeometry(shape, { depth: length, bevelEnabled: false, curveSegments: 12, steps: 1 })
  geometry.rotateX(-Math.PI / 2)
  geometry.translate(0, -length / 2, 0)
  geometry.computeBoundingBox()
  return geometry
}
