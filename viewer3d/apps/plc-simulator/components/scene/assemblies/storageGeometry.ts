import { ExtrudeGeometry, Shape } from 'three'

export const forkPosition = (p: number) => -p * .18
export const stopperPosition = (height: number, p: number) => -height * .58 + p * height * .78

/** Keep the flat supporting face; only relieve the underside of the insertion tip. */
export function forkTineGeometry(stroke: number) {
  const front = -Math.max(.24, stroke) + .06, rear = .04
  const shape = new Shape()
  shape.moveTo(front, -.0525); shape.lineTo(rear, -.0525)
  shape.lineTo(rear, -.1075); shape.lineTo(front + .10, -.1075)
  shape.quadraticCurveTo(front + .055, -.1075, front, -.0645)
  shape.closePath()
  const g = new ExtrudeGeometry(shape, { depth: .055, bevelEnabled: false, curveSegments: 16 })
  g.translate(0, 0, -.0275); g.rotateY(-Math.PI / 2)
  return g
}

/** A thin shelf pan, with actual corner clearances around the four .09 posts. */
export function rackShelfGeometry(w: number, d: number) {
  const x = w / 2, z = d / 2, c = .095
  const points = [[-x + c, -z], [x - c, -z], [x - c, -z + c], [x, -z + c],
    [x, z - c], [x - c, z - c], [x - c, z], [-x + c, z],
    [-x + c, z - c], [-x, z - c], [-x, -z + c], [-x + c, -z + c]]
  const s = new Shape()
  points.forEach(([a, b], i) => i ? s.lineTo(a, b) : s.moveTo(a, b)); s.closePath()
  const g = new ExtrudeGeometry(s, { depth: .018, bevelEnabled: false })
  g.rotateX(-Math.PI / 2); g.translate(0, .017, 0)
  return g // Original upper load face is still local Y +.035.
}
