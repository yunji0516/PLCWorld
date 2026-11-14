import { ExtrudeGeometry, LatheGeometry, Path, QuadraticBezierCurve, Shape, Vector2 } from 'three'
import { CONVEYOR_BELT_TOP_Y, SINGLE_VACUUM_CUP } from '../deviceGeometry'

export function beltDimensions(length: number, radiusLimit = .08) {
  const radius = Math.min(radiusLimit, length * .12)
  const halfStraight = length / 2 - radius
  return { radius, halfStraight, centerY: CONVEYOR_BELT_TOP_Y - radius,
    perimeter: 4 * halfStraight + 2 * Math.PI * radius, thickness: radiusLimit === .08 ? .009 : Math.min(.009, radius * .25) }
}

export function wrappedBeltGeometry(length: number, width: number, radiusLimit = .08) {
  const g = beltDimensions(length, radiusLimit), a = g.halfStraight, cy = g.centerY, r = g.radius
  const shape = new Shape()
  shape.moveTo(-a, cy + r); shape.lineTo(a, cy + r)
  shape.absarc(a, cy, r, Math.PI / 2, -Math.PI / 2, true)
  shape.lineTo(-a, cy - r)
  shape.absarc(-a, cy, r, -Math.PI / 2, -3 * Math.PI / 2, true)
  shape.closePath()
  const hole = new Path(), inner = r - g.thickness
  hole.moveTo(a, cy + inner); hole.lineTo(-a, cy + inner)
  hole.absarc(-a, cy, inner, Math.PI / 2, 3 * Math.PI / 2, false)
  hole.lineTo(a, cy - inner)
  hole.absarc(a, cy, inner, -Math.PI / 2, Math.PI / 2, false)
  hole.closePath(); shape.holes.push(hole)
  const geometry = new ExtrudeGeometry(shape, { depth: width, bevelEnabled: false, curveSegments: 32 })
  geometry.translate(0, 0, -width / 2)
  return geometry
}

/** Distance along the closed belt, driven from recorded plant spin (no free-running animation). */
export function beltSurfacePose(length: number, distance: number, offset = .0015, radiusLimit = .08) {
  const { halfStraight: a, radius: r, centerY: cy, perimeter } = beltDimensions(length, radiusLimit)
  let s = ((distance % perimeter) + perimeter) % perimeter
  if (s <= 2 * a) return { x: -a + s, y: cy + r + offset, angle: 0 }
  s -= 2 * a
  if (s <= Math.PI * r) {
    const theta = Math.PI / 2 - s / r
    return { x: a + (r + offset) * Math.cos(theta), y: cy + (r + offset) * Math.sin(theta), angle: theta - Math.PI / 2 }
  }
  s -= Math.PI * r
  if (s <= 2 * a) return { x: a - s, y: cy - r - offset, angle: -Math.PI }
  s -= 2 * a
  const theta = -Math.PI / 2 - s / r
  return { x: -a + (r + offset) * Math.cos(theta), y: cy + (r + offset) * Math.sin(theta), angle: theta - Math.PI / 2 }
}

/** Closed rubber wall with an open central cavity and an annular sealing lip. */
export function bellowsCupGeometry(radius: number = SINGLE_VACUUM_CUP.radius, height: number = SINGLE_VACUUM_CUP.height) {
  const outer = [[1, 0], [1, .07], [.70, .20], [.88, .34], [.60, .47], [.80, .61], [.44, .80], [.42, 1]]
  const inner = [...outer].reverse().map(([r, y]) => [r - .10, y])
  const roundWall = (wall: number[][]) => {
    const points = wall.map(([r, y]) => new Vector2(r * radius, SINGLE_VACUUM_CUP.lipY + y * height))
    return points.flatMap((p, i) => i === 0 || i === points.length - 1 ? [p]
      : new QuadraticBezierCurve(p.clone().lerp(points[i - 1], .22), p, p.clone().lerp(points[i + 1], .22)).getPoints(4))
  }
  const points = [...roundWall(outer), ...roundWall(inner), new Vector2(radius, SINGLE_VACUUM_CUP.lipY)]
  return new LatheGeometry(points, 48)
}

export const slideCarriagePosition = (height: number, pos: number) => (pos - .5) * height * .54
export const liftDeckPosition = (height: number, pos: number) => -height / 2 + .1 + pos * (height - .2)

export function slideBodyDimensions(depth: number) {
  const front = depth * .35, rear = -.047
  return { front, rear, depth: front - rear, centerZ: (front + rear) / 2, bodyHeight: .14 }
}

export function sleeveGeometry(outer: number, inner: number, height: number, square = false) {
  const shape = new Shape(), hole = new Path()
  if (square) {
    shape.moveTo(-outer, -outer); shape.lineTo(outer, -outer); shape.lineTo(outer, outer); shape.lineTo(-outer, outer); shape.closePath()
    hole.moveTo(-inner, -inner); hole.lineTo(-inner, inner); hole.lineTo(inner, inner); hole.lineTo(inner, -inner); hole.closePath()
  } else {
    shape.absarc(0, 0, outer, 0, 2 * Math.PI, false)
    hole.absarc(0, 0, inner, 0, 2 * Math.PI, true)
  }
  shape.holes.push(hole)
  const geometry = new ExtrudeGeometry(shape, { depth: height, bevelEnabled: false, curveSegments: 24 })
  geometry.translate(0, 0, -height / 2); geometry.rotateX(Math.PI / 2)
  return geometry
}

/** Rear corner reliefs let the square guides pass without changing load surface height. */
export function liftDeckGeometry(width: number, depth: number) {
  const a = width * .43, b = depth * .43
  const innerX = Math.min(a, width / 2 - .05 - .034)
  const frontZ = Math.max(-b, -depth / 2 + .05 + .034)
  const shape = new Shape()
  const points = [[-a, b], [a, b], [a, frontZ], [innerX, frontZ], [innerX, -b],
    [-innerX, -b], [-innerX, frontZ], [-a, frontZ]]
  points.forEach(([x, z], i) => i ? shape.lineTo(x, z) : shape.moveTo(x, z))
  shape.closePath()
  const geometry = new ExtrudeGeometry(shape, { depth: .07, bevelEnabled: false })
  geometry.translate(0, 0, -.035); geometry.rotateX(Math.PI / 2)
  return geometry
}
