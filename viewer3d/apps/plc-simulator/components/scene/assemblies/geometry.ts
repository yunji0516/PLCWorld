import { ExtrudeGeometry, Path, Shape } from 'three'

export const servoPosition = (length: number, position: number) => (position - .5) * Math.max(.1, length - .3)

/** Connect to the rear of the fixed gripper housing, never to the finger/workpiece envelope. */
export function slideGripperMountGeometry(slideDepth: number, gripperZ: number) {
  const startZ = slideDepth * .35, endZ = gripperZ - .07
  return { startZ, endZ, depth: endZ - startZ, centerZ: (endZ + startZ) / 2,
    width: .16, height: .04, gripperRelativeY: .0275 }
}

export function servoAssemblyGeometry(length: number, height: number, width: number) {
  const carriageY = height * .38
  const carriageHeight = Math.max(.12, height * .55)
  return {
    length, width, baseHeight: Math.max(.06, height * .24),
    railY: height * .22, railHeight: Math.max(.035, height * .13), railWidth: width * .12,
    carriageY, carriageHeight, carriageTop: carriageY + carriageHeight / 2,
    toolingY: carriageY + Math.max(.09, height * .36),
  }
}

export function gripperAssemblyGeometry(wide: boolean, closed: number) {
  const fingerWidth = wide ? .06 : .04
  const jawCenter = wide ? .32 - closed * .2 : .15 - closed * .05
  return {
    bodyWidth: wide ? .74 : .2, guideWidth: wide ? .8 : .42,
    jawCenter, fingerWidth, padWidth: .008,
    contactX: jawCenter - fingerWidth / 2,
  }
}

/** Keep the moving rod hardware outside the gland even on the short-stroke modules. */
export function cylinderRodHardware(exposedAtMin: number) {
  const nutLength = Math.min(.018, Math.max(.002, (exposedAtMin - .015) * .5))
  const collarLength = Math.min(.008, exposedAtMin * .1)
  return {
    nutLength, nutCenter: .015 + nutLength / 2,
    collarLength, collarCenter: .015 + nutLength + collarLength / 2,
    rearExtent: .015 + nutLength + collarLength,
  }
}

/** A chamfered plate with genuine through-bores. Extrusion is along local Z. */
export function boredPlate(width: number, height: number, depth: number, corner: number,
  holes: { x: number; y: number; radius: number }[] = []) {
  const x = width / 2, y = height / 2, c = Math.min(corner, x * .4, y * .4)
  const points = [[-x + c, -y], [x - c, -y], [x, -y + c], [x, y - c],
    [x - c, y], [-x + c, y], [-x, y - c], [-x, -y + c]]
  const shape = new Shape()
  points.forEach(([px, py], i) => i ? shape.lineTo(px, py) : shape.moveTo(px, py))
  shape.closePath()
  for (const h of holes) {
    const hole = new Path()
    hole.absarc(h.x, h.y, h.radius, 0, 2 * Math.PI, true)
    shape.holes.push(hole)
  }
  const geometry = new ExtrudeGeometry(shape, { depth, bevelEnabled: false, curveSegments: 20 })
  geometry.translate(0, 0, -depth / 2)
  return geometry
}
