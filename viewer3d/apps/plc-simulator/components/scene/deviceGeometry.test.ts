import { describe, expect, it } from 'vitest'
import { Vector3 } from 'three'
import {
  clampGeometry,
  CONVEYOR_BELT_TOP_Y,
  cylinderContact,
  feederOutlet,
  feederStackOffset,
  WORKPIECE_SIZE,
  PHOTOEYE_LENS_FRONT,
  photoeyeVisibleLength,
  turnoverGripGeometry,
  SINGLE_VACUUM_CUP,
} from './deviceGeometry'

describe('replay device contact geometry', () => {
  it('fits the single vacuum sealing lip entirely on the E02/E04 workpiece', () => {
    const cup = SINGLE_VACUUM_CUP
    expect(cup.radius).toBeLessThan(WORKPIECE_SIZE / 2)
    expect(cup.centerY - cup.height / 2).toBeCloseTo(cup.lipY)
    expect(cup.lipY).toBeCloseTo(cup.partOffsetY + WORKPIECE_SIZE / 2)
  })
  it('keeps both E14 pads flush with the held workpiece through a full turnover', () => {
    const g = turnoverGripGeometry(1)
    expect(2 * (g.padCenterX - g.padThickness / 2)).toBeCloseTo(WORKPIECE_SIZE)
    expect(g.fingerCenterX - g.fingerWidth / 2).toBeCloseTo(g.padCenterX + g.padThickness / 2)
    expect(g.fingerCenterZ - g.fingerDepth / 2).toBeCloseTo(.04) // palm front
    expect(g.padHeight).toBeLessThanOrEqual(WORKPIECE_SIZE)
    expect(g.padDepth).toBeLessThanOrEqual(WORKPIECE_SIZE)
    for (let degrees = 0; degrees <= 180; degrees++) {
      const angle = degrees * Math.PI / 180
      for (const side of [-1, 1]) {
        const padFace = new Vector3(side * (g.padCenterX - g.padThickness / 2), 0, g.partCenterZ)
        const partFace = new Vector3(side * WORKPIECE_SIZE / 2, 0, g.partCenterZ)
        const axis = new Vector3(0, 0, 1)
        padFace.applyAxisAngle(axis, angle)
        partFace.applyAxisAngle(axis, angle)
        expect(padFace.distanceTo(partFace)).toBeLessThan(1e-12)
      }
    }
  })

  it('moves the E14 contact pads apart when the gripper opens', () => {
    expect(turnoverGripGeometry(0).contactX).toBeGreaterThan(WORKPIECE_SIZE / 2)
    expect(turnoverGripGeometry(2)).toEqual(turnoverGripGeometry(1))
    expect(turnoverGripGeometry(-1)).toEqual(turnoverGripGeometry(0))
  })

  it('keeps the pusher plate outside its body and moves a fixed travel', () => {
    const start = cylinderContact(0.8, 0)
    const end = cylinderContact(0.8, 1)
    expect(start.plateCenter).toBeLessThan(-start.bodyHalf)
    expect(start.contactFace - end.contactFace).toBeCloseTo(start.travel)
    expect(start.plateThickness).toBe(end.plateThickness)
  })

  it('can move a cylinder body back without moving its contact face', () => {
    const original = cylinderContact(0.8, 0)
    const extendedRod = cylinderContact(0.8, 0, 0.14)
    expect(extendedRod.contactFace).toBeCloseTo(original.contactFace - 0.14)
    expect(extendedRod.travel).toBe(original.travel)
  })

  it('keeps remaining magazine stock raised until the separator returns', () => {
    expect(feederStackOffset(2, 1)).toBe(0)
    expect(feederStackOffset(2, 0.2)).toBe(0)
    expect(feederStackOffset(2, 0)).toBe(-0.18)
    expect(feederStackOffset(3, 0)).toBe(0)
  })

  it('closes clamp jaws onto, not through, a 0.16 workpiece', () => {
    expect(clampGeometry(1).innerGap).toBeCloseTo(WORKPIECE_SIZE)
    expect(clampGeometry(0).innerGap).toBeGreaterThan(WORKPIECE_SIZE)
    const jaw = clampGeometry(1)
    expect(jaw.jawHeight).toBeGreaterThan(WORKPIECE_SIZE)
    expect(jaw.jawWidth).toBeGreaterThanOrEqual(0.10)
    expect(0.68 + jaw.jawCenterY - jaw.jawHeight / 2).toBeCloseTo(0.615)
  })

  it('keeps conveyor markings below the carried workpiece', () => {
    const workpieceBottomLocal = 0.665 - 0.48 - WORKPIECE_SIZE / 2
    expect(workpieceBottomLocal).toBeGreaterThan(CONVEYOR_BELT_TOP_Y)
    expect(workpieceBottomLocal).toBeGreaterThan(0.1025)
  })

  it('places the feeder outlet above the conveyor instead of through it', () => {
    const outlet = feederOutlet(1.0, 0.68)
    const conveyorTopWorld = 0.48 + CONVEYOR_BELT_TOP_Y
    expect(outlet.bottomY).toBeGreaterThan(conveyorTopWorld)
    expect(outlet.topY).toBeCloseTo(1.0 - 0.68 / 2)
  })
})

describe('photoeye diagnostic beam occlusion', () => {
  const sensor = [0, 0.68, 0.44] as const
  const part = { x: 0, y: 0.68, z: 0 }
  const length = (parts: typeof part[]) => photoeyeVisibleLength(sensor, 0, 0.56, parts, 0.68)

  it('retains the configured range when nothing blocks it', () => {
    expect(length([])).toBeCloseTo(0.56 - PHOTOEYE_LENS_FRONT)
  })

  it('stops before the near face, not the centre or far face', () => {
    const visible = length([part])
    expect(visible).toBeCloseTo(0.44 - PHOTOEYE_LENS_FRONT - 0.086)
    expect(sensor[2] - PHOTOEYE_LENS_FRONT - visible).toBeGreaterThanOrEqual(0.08)
  })

  it('selects the nearest of multiple workpieces regardless of order', () => {
    const closer = { ...part, z: 0.2 }
    expect(length([part, closer])).toBeCloseTo(length([closer, part]))
    expect(length([closer, part])).toBeLessThan(length([part]))
  })

  it('does not clip for workpieces behind, beside, above or beyond the ray', () => {
    expect(length([{ ...part, z: 0.9 }, { ...part, x: 0.3 }, { ...part, y: 1 }, { ...part, z: -1 }]))
      .toBeCloseTo(length([]))
  })

  it('respects sensor rotation, including E10 looking along +Z', () => {
    expect(photoeyeVisibleLength([0, 0.68, -0.44], Math.PI, 0.56, [part], 0.68))
      .toBeCloseTo(length([part]))
    expect(photoeyeVisibleLength([0.44, 0.68, 0], Math.PI / 2, 0.56, [part], 0.68))
      .toBeCloseTo(length([part]))
  })

  it('follows a sensor and workpiece mounted on the same moving carrier', () => {
    expect(photoeyeVisibleLength([1.8, 0.68, 0.44], 0, 0.56, [{ ...part, x: 1.8 }], 0.68))
      .toBeCloseTo(length([part]))
  })

  it('uses the legacy line renderer height when a part has no Y/Z', () => {
    expect(photoeyeVisibleLength(sensor, 0, 0.56, [{ x: 0 }], 0.68)).toBeCloseTo(length([part]))
  })

  it('hides a ray originating inside a workpiece', () => {
    expect(length([{ ...part, z: 0.4 }])).toBe(0)
  })
})
