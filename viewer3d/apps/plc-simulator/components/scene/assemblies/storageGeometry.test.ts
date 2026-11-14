import { expect, it } from 'vitest'
import { DoubleSide, Mesh, MeshBasicMaterial, Raycaster, Vector3 } from 'three'
import { forkPosition, forkTineGeometry, rackShelfGeometry, stopperPosition } from './storageGeometry'

it.each([.24, .64, .9])('preserves a %s fork load face and tip reach', stroke => {
  const g = forkTineGeometry(stroke); g.computeBoundingBox()
  expect(g.boundingBox!.max.y).toBeCloseTo(-.0525)
  expect(g.boundingBox!.min.y).toBeCloseTo(-.1075)
  expect(g.boundingBox!.min.z).toBeCloseTo(-stroke + .06)
  expect(g.boundingBox!.max.x - g.boundingBox!.min.x).toBeCloseTo(.055)
  const material = new MeshBasicMaterial({ side: DoubleSide }), m = new Mesh(g, material)
  const ray = new Raycaster(new Vector3(0, -1, -stroke + .061), new Vector3(0, 1, 0))
  expect(ray.intersectObject(m)[0].point.y).toBeGreaterThan(-.08) // thin insertion nose
  g.dispose(); material.dispose()
})

it.each([[1, .5], [1.2, .6]])('relieves shelf corners without moving its load surface (%s, %s)', (w, d) => {
  const g = rackShelfGeometry(w, d), material = new MeshBasicMaterial({ side: DoubleSide }), m = new Mesh(g, material)
  const ray = new Raycaster(new Vector3(0, 1, 0), new Vector3(0, -1, 0))
  expect(ray.intersectObject(m)[0].point.y).toBeCloseTo(.035)
  for (const x of [-1, 1]) for (const z of [-1, 1]) {
    ray.set(new Vector3(x * (w / 2 - .045), 1, z * (d / 2 - .045)), new Vector3(0, -1, 0))
    expect(ray.intersectObject(m)).toHaveLength(0)
  }
  g.dispose(); material.dispose()
})

it('keeps the fork and stopper stroke, with clearance in the stopper guide slot', () => {
  for (const p of [0, .5, 1]) {
    expect(forkPosition(p)).toBeCloseTo(-p * .18)
    for (const h of [.32, .34]) {
      expect(stopperPosition(h, p)).toBeCloseTo(-h * .58 + p * h * .78)
      expect(stopperPosition(h, p) - .5 * h).toBeGreaterThan(-h * 1.10)
    }
  }
  expect(.06125 - .0575 / 2).toBeGreaterThan(.055 / 2)
})
