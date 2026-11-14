import { expect, it } from 'vitest'
import { CylinderGeometry, Group, Mesh, OrthographicCamera, PerspectiveCamera, Vector3, type Camera } from 'three'
import { createPhotoeyeWidthLimiter } from './photoeyeProjection'
import { PHOTOEYE_STYLE } from './photoeyeStyle'

// Independently sample diameters of the two end caps in screen coordinates.
function diameter(mesh: Mesh<CylinderGeometry>, camera: Camera, width = 1000, height = 700) {
  mesh.updateWorldMatrix(true, false)
  let largest = 0
  const { radiusTop: radius, height: length } = mesh.geometry.parameters
  for (const y of [-length / 2, length / 2]) for (let i = 0; i < 12; i++) {
    const theta = i * Math.PI / 6
    const a = new Vector3(radius * Math.sin(theta), y, radius * Math.cos(theta)).applyMatrix4(mesh.matrixWorld).project(camera)
    const b = new Vector3(-radius * Math.sin(theta), y, -radius * Math.cos(theta)).applyMatrix4(mesh.matrixWorld).project(camera)
    largest = Math.max(largest, Math.hypot((a.x - b.x) * width / 2, (a.y - b.y) * height / 2))
  }
  return largest
}

it('caps actual near-end diameter during oblique zoom, preserving length and position', () => {
  const mesh = new Mesh(new CylinderGeometry(.0025, .0025, 1, 12))
  mesh.rotation.x = Math.PI / 2
  mesh.scale.y = .8
  const camera = new PerspectiveCamera(42, 1000 / 700, .01, 200)
  const fit = createPhotoeyeWidthLimiter()
  for (const distance of [.65, 1, 3, 9, 3, .65]) {
    camera.position.set(distance * .3, distance * .15, distance)
    camera.lookAt(0, 0, 0); camera.updateMatrixWorld()
    fit(mesh, camera, 1000, 700)
    expect(diameter(mesh, camera)).toBeLessThanOrEqual(PHOTOEYE_STYLE.rayMaxPixels + .001)
    expect(mesh.scale.x).toBeLessThanOrEqual(1)
    expect(mesh.scale.z).toBe(mesh.scale.x)
    expect(mesh.scale.y).toBe(.8)
    expect(mesh.position.toArray()).toEqual([0, 0, 0])
  }
})

it('measures actual geometry after replacement, including an old wider cylinder', () => {
  const parent = new Group(); parent.scale.set(2, 1, 3)
  const mesh = new Mesh(new CylinderGeometry(.0025, .0025, 1, 12)); parent.add(mesh)
  mesh.rotation.x = Math.PI / 2
  const camera = new PerspectiveCamera(42, 1000 / 700, .01, 200)
  camera.position.set(2, 1, 4); camera.lookAt(0, 0, 0); camera.updateMatrixWorld()
  const fit = createPhotoeyeWidthLimiter()
  for (const radius of [.0032, .0025, .011, .0055]) {
    mesh.geometry.dispose(); mesh.geometry = new CylinderGeometry(radius, radius, 1, 12)
    fit(mesh, camera, 1000, 700)
    expect(diameter(mesh, camera)).toBeLessThanOrEqual(PHOTOEYE_STYLE.rayMaxPixels + .001)
  }
})

it('allows distant rays to shrink and handles orthographic zoom', () => {
  const mesh = new Mesh(new CylinderGeometry(.0025, .0025, .4, 12))
  mesh.rotation.x = Math.PI / 2
  const camera = new PerspectiveCamera(42, 1000 / 700, .01, 200)
  const fit = createPhotoeyeWidthLimiter()
  camera.position.set(10, 2, 2); camera.lookAt(0, 0, 0); camera.updateMatrixWorld()
  fit(mesh, camera, 1000, 700)
  const first = diameter(mesh, camera)
  camera.position.multiplyScalar(2); camera.updateMatrixWorld()
  fit(mesh, camera, 1000, 700)
  expect(mesh.scale.x).toBe(1)
  expect(diameter(mesh, camera)).toBeLessThan(first * .6)
  const ortho = new OrthographicCamera(-1, 1, .7, -.7, .01, 200)
  ortho.position.set(2, 1, 3); ortho.lookAt(0, 0, 0); ortho.updateMatrixWorld()
  for (const zoom of [1, 5, .1]) {
    ortho.zoom = zoom; ortho.updateProjectionMatrix()
    fit(mesh, ortho, 1000, 700)
    expect(diameter(mesh, ortho)).toBeLessThanOrEqual(PHOTOEYE_STYLE.rayMaxPixels + .001)
    expect(mesh.scale.x).toBeLessThanOrEqual(1)
  }
})
