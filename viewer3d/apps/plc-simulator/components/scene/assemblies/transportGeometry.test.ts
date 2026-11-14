import { expect, it } from 'vitest'
import { DoubleSide, Mesh, MeshBasicMaterial, Raycaster, Vector3, type BufferGeometry } from 'three'
import { beltDimensions, beltSurfacePose, wrappedBeltGeometry, bellowsCupGeometry, sleeveGeometry,
  slideCarriagePosition, liftDeckPosition, liftDeckGeometry, slideBodyDimensions } from './transportGeometry'

function hit(g: BufferGeometry, origin: number[], direction: number[]) {
  const m = new MeshBasicMaterial({ side: DoubleSide }), mesh = new Mesh(g, m)
  mesh.updateMatrixWorld()
  const hits = new Raycaster(new Vector3(...origin), new Vector3(...direction)).intersectObject(mesh)
  m.dispose(); return hits
}

it.each([1.1, 1.4, 2.4, 4.4])('wraps a %s belt within its original length and preserves the +.100 load surface', length => {
  const g = wrappedBeltGeometry(length, .72)
  g.computeBoundingBox()
  expect(g.boundingBox!.max.y).toBeCloseTo(.1)
  expect(g.boundingBox!.max.x - g.boundingBox!.min.x).toBeCloseTo(length)
  expect(g.boundingBox!.max.z - g.boundingBox!.min.z).toBeCloseTo(.72)
  expect(hit(g, [0, 1, 0], [0, -1, 0])[0].point.y).toBeCloseTo(.1)
  expect(hit(g, [0, .02, 1], [0, 0, -1])).toHaveLength(0) // hollow return path
  g.dispose()
})

it('moves belt markers continuously around both drums and back to their initial recorded phase', () => {
  const { perimeter, halfStraight, radius } = beltDimensions(2.4)
  expect(beltSurfacePose(2.4, 0)).toEqual(beltSurfacePose(2.4, perimeter))
  const tip = beltSurfacePose(2.4, 2 * halfStraight + Math.PI * radius / 2, 0)
  expect(tip.x).toBeCloseTo(1.2)
  expect(tip.angle).toBeCloseTo(-Math.PI / 2)
  for (let i = 0; i < 100; i++) {
    const a = beltSurfacePose(2.4, perimeter * i / 100), b = beltSurfacePose(2.4, perimeter * i / 100 + .0001)
    expect(Math.hypot(a.x - b.x, a.y - b.y)).toBeLessThan(.00011)
  }
})

it('models the bellows wall with a genuine open cavity and the original lip height/radius', () => {
  const g = bellowsCupGeometry(); g.computeBoundingBox()
  expect(g.boundingBox!.min.y).toBeCloseTo(.045)
  expect(g.boundingBox!.max.y).toBeCloseTo(.105)
  expect(g.boundingBox!.max.x).toBeCloseTo(.06)
  expect(hit(g, [0, -.1, 0], [0, 1, 0])).toHaveLength(0)
  expect(hit(g, [.057, -.1, 0], [0, 1, 0])[0].point.y).toBeCloseTo(.045)
  g.dispose()
})

it.each([false, true])('leaves a real guide bore in the %s bearing', square => {
  const g = sleeveGeometry(square ? .0475 : .042, square ? .0335 : .026, .03, square)
  expect(hit(g, [0, 1, 0], [0, -1, 0])).toHaveLength(0)
  expect(hit(g, [square ? .04 : .034, 1, 0], [0, -1, 0]).length).toBeGreaterThan(0)
  g.dispose()
})

it('relieves lift plate corners while keeping the load datum and existing stroke', () => {
  const g = liftDeckGeometry(.95, .78)
  expect(hit(g, [0, 1, 0], [0, -1, 0])[0].point.y).toBeCloseTo(.035)
  expect(hit(g, [.40, 1, -.32], [0, -1, 0])).toHaveLength(0)
  expect(liftDeckPosition(1.2, 0)).toBeCloseTo(-.5)
  expect(liftDeckPosition(1.2, 1)).toBeCloseTo(.5)
  expect(slideCarriagePosition(1.2, 0)).toBeCloseTo(-.324)
  expect(slideCarriagePosition(1.2, 1)).toBeCloseTo(.324)
  expect(slideBodyDimensions(.35).front).toBeCloseTo(.35 * .35)
  g.dispose()
})
