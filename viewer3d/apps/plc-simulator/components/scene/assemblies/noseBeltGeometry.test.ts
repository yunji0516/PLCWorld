import { expect, it } from 'vitest'
import { DoubleSide, Mesh, MeshBasicMaterial, Raycaster, Vector3 } from 'three'
import { noseBeltDimensions, noseBeltGeometry, noseBeltPose, STOPPER_NOSE } from './noseBeltGeometry'

it.each([[.08, .02], [.02, .08]])('makes a hollow, continuous %s/%s nose belt at the original load height', (left, right) => {
  const length = 1.265, g = noseBeltDimensions(length, left, right)
  const geometry = noseBeltGeometry(length, .7, left, right), material = new MeshBasicMaterial({ side: DoubleSide })
  const mesh = new Mesh(geometry, material), ray = new Raycaster(new Vector3(0, 1, 0), new Vector3(0, -1, 0))
  const hits = ray.intersectObject(mesh)
  expect(hits[0].point.y).toBeCloseTo(.1)
  expect(hits.some(hit => Math.abs(hit.point.y - .096) < 1e-6)).toBe(true)
  geometry.computeBoundingBox()
  expect(geometry.boundingBox!.min.x).toBeCloseTo(-length / 2, 4)
  expect(geometry.boundingBox!.max.x).toBeCloseTo(length / 2, 4)
  for (const s of [0, g.straight, g.straight + g.rightArc, 2 * g.straight + g.rightArc, g.perimeter]) {
    const a = noseBeltPose(length, left, right, s - 1e-7), b = noseBeltPose(length, left, right, s + 1e-7)
    expect(Math.hypot(a.x - b.x, a.y - b.y)).toBeLessThan(1e-5)
  }
  geometry.dispose(); material.dispose()
})
it('keeps the stopper clear and some powered support beneath the .16 m workpiece throughout crossing', () => {
  expect(STOPPER_NOSE.gap).toBeGreaterThan(.055)
  const halfSpan = STOPPER_NOSE.gap / 2 + STOPPER_NOSE.radius
  for (let x = -.3; x <= .3; x += .001) {
    const leftContact = Math.max(0, Math.min(x + .08, -halfSpan) - (x - .08))
    const rightContact = Math.max(0, x + .08 - Math.max(x - .08, halfSpan))
    expect(leftContact + rightContact).toBeGreaterThanOrEqual(.05 - 1e-8)
  }
  expect(.6 - STOPPER_NOSE.radius * 2).toBeGreaterThan(.58 - .32 * .27 + .016)
})
