import { expect, it } from 'vitest'
import { DoubleSide, Mesh, MeshBasicMaterial, Raycaster, Vector3 } from 'three'
import { RoundedBoxGeometry } from 'three/examples/jsm/geometries/RoundedBoxGeometry.js'
import { makeSlottedProfile } from './profileGeometry'

it('retains the original post envelope while cutting actual slots and a central bore', () => {
  const geometry = makeSlottedProfile(.1, 1.8)
  const size = geometry.boundingBox!.getSize(new Vector3())
  expect(size.x).toBeCloseTo(.1)
  expect(size.y).toBeCloseTo(1.8)
  expect(size.z).toBeCloseTo(.1)
  const material = new MeshBasicMaterial({ side: DoubleSide })
  const mesh = new Mesh(geometry, material)
  mesh.updateMatrixWorld()
  const cast = (x: number, z: number) => new Raycaster(new Vector3(x, 2, z), new Vector3(0, -1, 0)).intersectObject(mesh)
  expect(cast(0, 0)).toHaveLength(0) // central through bore
  expect(cast(0, .049)).toHaveLength(0) // recessed slot, not a stripe on a cube
  expect(cast(.03, .03).length).toBeGreaterThan(0)
  const side = new Raycaster(new Vector3(0, 0, 1), new Vector3(0, 0, -1)).intersectObject(mesh)[0]
  expect(side.point.z).toBeCloseTo(.034)
  geometry.dispose(); material.dispose()
})

it('rounds cast housings without moving their outer contact bounds', () => {
  const geometry = new RoundedBoxGeometry(.18, .7, .18, 2, .055)
  geometry.computeBoundingBox()
  const size = geometry.boundingBox!.getSize(new Vector3())
  expect(size.x).toBeCloseTo(.18)
  expect(size.y).toBeCloseTo(.7)
  expect(size.z).toBeCloseTo(.18)
  geometry.dispose()
})
