import { ExtrudeGeometry, Path, Shape } from 'three'

export const STOPPER_NOSE = { gap: .07, radius: .02, thickness: .004 }
export function noseBeltDimensions(length: number, left: number, right: number) {
  const x0 = -length / 2 + left, x1 = length / 2 - right
  const y0 = .1 - left, y1 = .1 - right, straight = x1 - x0
  const lowerAngle = 2 * Math.atan2(y1 - y0, straight) - Math.PI / 2
  const rightArc = right * (Math.PI / 2 - lowerAngle), leftArc = left * (lowerAngle + 3 * Math.PI / 2)
  return { x0, x1, y0, y1, straight, lowerAngle, rightArc, leftArc, perimeter: 2 * straight + rightArc + leftArc }
}
export function noseBeltGeometry(length: number, width: number, left: number, right: number) {
  const g = noseBeltDimensions(length, left, right), t = STOPPER_NOSE.thickness
  const shape = new Shape(), hole = new Path()
  shape.moveTo(g.x0, .1); shape.lineTo(g.x1, .1)
  shape.absarc(g.x1, g.y1, right, Math.PI / 2, g.lowerAngle, true)
  shape.lineTo(g.x0 + left * Math.cos(g.lowerAngle), g.y0 + left * Math.sin(g.lowerAngle))
  shape.absarc(g.x0, g.y0, left, g.lowerAngle, -3 * Math.PI / 2, true); shape.closePath()
  hole.moveTo(g.x0, .1 - t)
  hole.absarc(g.x0, g.y0, left - t, Math.PI / 2, g.lowerAngle + 2 * Math.PI, false)
  hole.lineTo(g.x1 + (right - t) * Math.cos(g.lowerAngle), g.y1 + (right - t) * Math.sin(g.lowerAngle))
  hole.absarc(g.x1, g.y1, right - t, g.lowerAngle, Math.PI / 2, false); hole.closePath()
  shape.holes.push(hole)
  const geometry = new ExtrudeGeometry(shape, { depth: width, bevelEnabled: false, curveSegments: 40 })
  geometry.translate(0, 0, -width / 2)
  return geometry
}
export function noseBeltPose(length: number, left: number, right: number, distance: number) {
  const g = noseBeltDimensions(length, left, right), offset = .0015
  let s = ((distance % g.perimeter) + g.perimeter) % g.perimeter
  if (s <= g.straight) return { x: g.x0 + s, y: .1 + offset, angle: 0 }
  s -= g.straight
  if (s <= g.rightArc) {
    const a = Math.PI / 2 - s / right
    return { x: g.x1 + (right + offset) * Math.cos(a), y: g.y1 + (right + offset) * Math.sin(a), angle: a - Math.PI / 2 }
  }
  s -= g.rightArc
  if (s <= g.straight) {
    const k = s / g.straight, a = g.lowerAngle
    return { x: (1 - k) * (g.x1 + right * Math.cos(a)) + k * (g.x0 + left * Math.cos(a)) + offset * Math.cos(a),
      y: (1 - k) * (g.y1 + right * Math.sin(a)) + k * (g.y0 + left * Math.sin(a)) + offset * Math.sin(a), angle: a - Math.PI / 2 }
  }
  s -= g.straight
  const a = g.lowerAngle - s / left
  return { x: g.x0 + (left + offset) * Math.cos(a), y: g.y0 + (left + offset) * Math.sin(a), angle: a - Math.PI / 2 }
}
