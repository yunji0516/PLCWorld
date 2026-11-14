import { ExtrudeGeometry, Path, Shape } from 'three'

// Preserve the public replay's opposed-leaf travel and 60-degree index angle.
export const doorTravel = (width: number, position: number) => position * (width / 2 - .08)
export const indexAngle = (position: number) => -position * Math.PI / 3

export function doorDimensions(width: number, height: number, depth: number) {
  return { leafWidth: width / 2, leafHeight: height - .12, stile: .035,
    glassDepth: Math.min(.008, depth * .25),
    railLength: width + 2 * doorTravel(width, 1) + .16 }
}

/** Real tooling bores; no discs painted on top of a solid plate. Axis is Y. */
export function indexPlateGeometry(width: number, height: number) {
  const shape = new Shape()
  shape.absarc(0, 0, width / 2, 0, Math.PI * 2, false)
  for (let i = 0; i < 12; i++) {
    const a = i * Math.PI / 6, hole = new Path()
    hole.absarc(Math.cos(a) * width * .27, Math.sin(a) * width * .27,
      .012, 0, Math.PI * 2, true)
    shape.holes.push(hole)
  }
  const geometry = new ExtrudeGeometry(shape, { depth: height, bevelEnabled: false, curveSegments: 48 })
  geometry.translate(0, 0, -height / 2)
  geometry.rotateX(-Math.PI / 2)
  return geometry
}
