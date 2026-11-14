import { Vector3, type BufferGeometry, type Camera, type Mesh } from 'three'
import { PHOTOEYE_STYLE } from './photoeyeStyle'

/** Fit the actual cylinder cross-sections, including the nearer endpoint.
 * Center-depth estimates understate width for oblique/close-up views.
 * Each sensor owns its scratch buffers; no per-frame geometry allocations.
 */
export function createPhotoeyeWidthLimiter() {
  let geometry: BufferGeometry | undefined
  let rings: Vector3[][] = []
  const point = new Vector3()
  const screen: number[] = []

  function projectedWidth(mesh: Mesh, camera: Camera, width: number, height: number) {
    mesh.updateWorldMatrix(true, false)
    let widest = 0
    for (const ring of rings) {
      screen.length = 0
      for (const vertex of ring) {
        point.copy(vertex).applyMatrix4(mesh.matrixWorld).project(camera)
        if (!Number.isFinite(point.x) || !Number.isFinite(point.y) || point.z < -1 || point.z > 1) continue
        screen.push(point.x * width / 2, point.y * height / 2)
      }
      for (let i = 0; i < screen.length; i += 2) for (let j = i + 2; j < screen.length; j += 2)
        widest = Math.max(widest, Math.hypot(screen[i] - screen[j], screen[i + 1] - screen[j + 1]))
    }
    return widest
  }

  return (mesh: Mesh, camera: Camera, width: number, height: number) => {
    if (width <= 0 || height <= 0) return
    if (geometry !== mesh.geometry) {
      geometry = mesh.geometry
      const positions = geometry.getAttribute('position')
      const byHeight = new Map<number, Vector3[]>()
      for (let i = 0; i < positions.count; i++) {
        const y = positions.getY(i)
        if (!byHeight.has(y)) byHeight.set(y, [])
        const ring = byHeight.get(y)!
        const vertex = new Vector3().fromBufferAttribute(positions, i)
        if (!ring.some(p => p.equals(vertex))) ring.push(vertex)
      }
      rings = [...byHeight.values()]
    }
    camera.updateWorldMatrix(true, false)
    // Reset radial scale only: preserve longitudinal clipping/length exactly.
    mesh.scale.x = mesh.scale.z = 1
    for (let pass = 0; pass < 4; pass++) {
      const pixels = projectedWidth(mesh, camera, width, height)
      if (pixels <= PHOTOEYE_STYLE.rayMaxPixels) break
      const ratio = PHOTOEYE_STYLE.rayMaxPixels / pixels * .999
      mesh.scale.x *= ratio
      mesh.scale.z *= ratio
    }
    mesh.updateWorldMatrix(false, false)
  }
}
