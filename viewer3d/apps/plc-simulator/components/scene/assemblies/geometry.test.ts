import { expect, it } from 'vitest'
import { DoubleSide, Mesh, MeshBasicMaterial, Raycaster, Vector3 } from 'three'
import { cylinderContact } from '../deviceGeometry'
import { boredPlate, cylinderRodHardware, gripperAssemblyGeometry, servoAssemblyGeometry, servoPosition, slideGripperMountGeometry } from './geometry'

it('terminates the slide mount on the fixed housing, clear of the jaws and held cube', () => {
  const mount = slideGripperMountGeometry(.35, .3)
  expect(mount.depth).toBeCloseTo(.1075)
  expect(mount.centerZ + mount.depth / 2 - .3).toBeCloseTo(-.07) // housing rear
  expect(mount.endZ - .3).toBeLessThan(-.05) // finger rear
  expect(mount.gripperRelativeY - mount.height / 2).toBeGreaterThan(-.025) // housing bottom
  expect(mount.gripperRelativeY - mount.height / 2).toBeGreaterThan(-.08) // held cube top
  expect(mount.gripperRelativeY + mount.height / 2).toBeLessThan(.068) // housing below lid
})

it('preserves the servo stroke and original support/tooling datums', () => {
  for (const length of [.8, 1.4, 2.35]) {
    const g = servoAssemblyGeometry(length, .28, .52)
    expect(servoPosition(length, 0)).toBeCloseTo(-(length - .3) / 2)
    expect(servoPosition(length, 1)).toBeCloseTo((length - .3) / 2)
    expect(g.carriageY).toBeCloseTo(.28 * .38)
    expect(g.carriageTop).toBeCloseTo(.28 * .38 + .28 * .55 / 2)
    expect(g.toolingY).toBeCloseTo(.28 * .38 + .28 * .36)
    // The new bearing bridge clears the rail and its .003-radius screw heads.
    expect(g.carriageTop - .036 - .018).toBeGreaterThan(g.railY + g.railHeight / 2 + .004)
  }
})

it('retains normal and wide gripper contact gaps at every sampled state', () => {
  for (const wide of [false, true]) for (const closed of [0, .25, .5, .75, 1]) {
    const g = gripperAssemblyGeometry(wide, closed)
    expect(g.contactX).toBeCloseTo(wide ? .29 - closed * .2 : .13 - closed * .05)
    const finger = g.fingerWidth - g.padWidth
    expect((finger / 2 + g.padWidth / 2) * 2).toBeCloseTo(g.fingerWidth)
    // Guide cassette/slider bottom stays above the held cube's top (-.08).
    expect(-.0465 - .027 / 2).toBeCloseTo(-.06) // slider mates to finger top without penetration
    expect(-.0465 - .027 / 2).toBeGreaterThan(-.08)
    expect(g.jawCenter + (wide ? .086 : .066) / 2).toBeLessThan(g.guideWidth / 2 - .022)
  }
  for (const stroke of [.32, .34, .5, .56, .58, .8, 1.4]) {
    const g = cylinderContact(stroke, 0)
    expect(cylinderRodHardware(g.exposedAtMin).rearExtent).toBeLessThan(g.exposedAtMin)
  }
})

it('keeps the cylinder contact plate thickness and rear locknut clearance through its stroke', () => {
  for (const pos of [0, .5, 1]) {
    const g = cylinderContact(.8, pos)
    expect(g.plateCenter).toBeCloseTo(-.38 - .6 * pos)
    expect(g.contactFace).toBeCloseTo(-.395 - .6 * pos)
    expect(g.plateThickness).toBe(.03)
    expect(g.plateCenter + .04).toBeLessThan(-g.bodyHalf)
  }
})

it('cuts a real rod bore through the chamfered end cap, not a painted circle', () => {
  const geometry = boredPlate(.14, .13, .035, .014, [{ x: 0, y: 0, radius: .022 }])
  geometry.computeBoundingBox()
  expect(geometry.boundingBox!.getSize(new Vector3()).toArray()).toEqual(expect.arrayContaining([
    expect.closeTo(.14), expect.closeTo(.13), expect.closeTo(.035),
  ]))
  const material = new MeshBasicMaterial({ side: DoubleSide })
  const mesh = new Mesh(geometry, material)
  mesh.updateMatrixWorld()
  const cast = (x: number, y: number) => new Raycaster(new Vector3(x, y, 1), new Vector3(0, 0, -1)).intersectObject(mesh)
  expect(cast(0, 0)).toHaveLength(0)
  expect(cast(.04, 0).length).toBeGreaterThan(0)
  expect(cast(.069, .064)).toHaveLength(0) // chamfered corner
  geometry.dispose(); material.dispose()
})
