





export const WORKPIECE_SIZE = 0.16
export const WORKPIECE_HALF = WORKPIECE_SIZE / 2

/** Material E14: two opposed pads contact the cube's local +/-X faces. */
export function turnoverGripGeometry(closed: number) {
  const padThickness = 0.024
  const fingerWidth = 0.030
  const opening = (1 - Math.min(1, Math.max(0, closed))) * 0.08
  const contactX = WORKPIECE_HALF + opening
  return {
    contactX,
    padThickness,
    padHeight: 0.14,
    padDepth: 0.12,
    padCenterX: contactX + padThickness / 2,
    partCenterZ: 0.18,
    fingerWidth,
    fingerCenterX: contactX + padThickness + fingerWidth / 2,
    fingerCenterZ: 0.16,
    fingerDepth: 0.24,
    fingerHeight: 0.10,
  }
}

/** The photoeye lens is centred at local z=-.04 with radius .018. */
export const PHOTOEYE_LENS_FRONT = 0.058

/**
 * Visible diagnostic ray, not PLC feedback. Parts are the same axis-aligned
 * 0.16 cubes drawn by Scene3D. Clip even during the one-scan feedback delay.
 * A small radius clearance prevents the beam cylinder grazing through edges.
 */
export function photoeyeVisibleLength(
  sensor: readonly [number, number, number],
  rotation: number,
  fullLength: number,
  parts: readonly { x: number; y?: number; z?: number; renderVariant?: string }[],
  defaultPartY: number,
) {
  const direction = [-Math.sin(rotation), 0, -Math.cos(rotation)]
  const origin = [
    sensor[0] + direction[0] * PHOTOEYE_LENS_FRONT,
    sensor[1] + 0.02,
    sensor[2] + direction[2] * PHOTOEYE_LENS_FRONT,
  ]
  let nearest = Math.max(0, fullLength - PHOTOEYE_LENS_FRONT)
  const half = WORKPIECE_HALF + 0.006
  for (const part of parts) {
    const center = [part.x, part.y ?? defaultPartY, part.z ?? 0]
    let near = 0
    let far = nearest
    for (let axis = 0; axis < 3; axis++) {
      // M20 beams are deliberately aligned to the continuous top deck, never
      // the fork pockets. Other tasks retain the previous cube occlusion.
      const pallet = part.renderVariant === 'slotted-pallet'
      const extent = pallet ? [.30, .0125, .32][axis] : half
      const offset = pallet && axis === 1 ? .0575 : 0
      const low = center[axis] + offset - extent
      const high = center[axis] + offset + extent
      const d = direction[axis]
      if (Math.abs(d) < 1e-9) {
        if (origin[axis] < low || origin[axis] > high) {
          far = -1
          break
        }
      } else {
        const first = (low - origin[axis]) / d
        const second = (high - origin[axis]) / d
        near = Math.max(near, Math.min(first, second))
        far = Math.min(far, Math.max(first, second))
      }
      if (near > far) break
    }
    if (near <= far) nearest = Math.min(nearest, near)
  }
  return nearest
}

// E02/E04's 0.16-wide cube: the entire sealing lip fits on its top face.
export const SINGLE_VACUUM_CUP = {
  radius: .06, topRadius: .025, height: .06, centerY: .075,
  lipY: .045, partOffsetY: -.035,
} as const

export function cylinderContact(stroke: number, position: number, rodBaseExtension = 0) {
  const bodyHalf = stroke * 0.75 / 2
  const exposedAtMin = stroke * 0.10 + Math.max(0, rodBaseExtension)
  const travel = stroke * 0.75
  const plateThickness = 0.03
  const exposed = exposedAtMin + position * travel
  const plateCenter = -bodyHalf - exposed
  return {
    bodyHalf,
    exposedAtMin,
    travel,
    exposed,
    plateCenter,
    contactFace: plateCenter - plateThickness / 2,
    plateThickness,
  }
}

export function clampGeometry(position: number) {
  const jawWidth = 0.10
  const jawHeight = 0.20
  const jawDepth = 0.30


  const jawCenterY = 0.035

  const closedCenter = WORKPIECE_HALF + jawWidth / 2
  const jawCenter = closedCenter + (1 - position) * 0.16
  return {
    jawWidth,
    jawHeight,
    jawDepth,
    jawCenterY,
    jawCenter,
    innerGap: 2 * (jawCenter - jawWidth / 2),
  }
}

export const CONVEYOR_BELT_CENTER_Y = 0.07
export const CONVEYOR_BELT_HEIGHT = 0.06
export const CONVEYOR_BELT_TOP_Y = CONVEYOR_BELT_CENTER_Y + CONVEYOR_BELT_HEIGHT / 2

export function feederOutlet(deviceY: number, feederHeight: number) {
  const height = 0.07
  const centerY = deviceY - feederHeight / 2 - height / 2
  return { height, centerY, bottomY: centerY - height / 2, topY: centerY + height / 2 }
}





export function feederStackOffset(stock: number, actuatorPosition: number) {
  return stock < 3 && actuatorPosition <= 0.015 ? -0.18 : 0
}
