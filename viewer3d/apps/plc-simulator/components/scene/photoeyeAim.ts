import { Box3, Euler, Quaternion, Ray, Vector3 } from 'three'
import { PHOTOEYE_LENS_FRONT } from './deviceGeometry'

type V3 = readonly [number, number, number]

/** Aim the optical axis, including the lens's 20 mm housing offset. */
export function aimPhotoeye(position: V3, target: V3, parentYaw = 0) {
  const center = new Vector3(...position), goal = new Vector3(...target)
  const rotation = new Quaternion(), forward = new Vector3(0,0,-1)
  const offset = new Vector3(), direction = goal.clone().sub(center).normalize()
  for (let i=0;i<8;i++) {
    rotation.setFromUnitVectors(forward,direction)
    offset.set(0,.02,0).applyQuaternion(rotation)
    direction.copy(goal).sub(center).sub(offset).normalize()
  }
  rotation.setFromUnitVectors(forward,direction)
  const origin = new Vector3(0,.02,-PHOTOEYE_LENS_FRONT).applyQuaternion(rotation).add(center)
  const localRotation = new Quaternion().setFromAxisAngle(new Vector3(0,1,0),-parentYaw).multiply(rotation)
  return { origin, direction, localRotation }
}

/** Clip to actual oriented thin material, not a generic cube around it. */
export function aimedPhotoeyeLength(aim: ReturnType<typeof aimPhotoeye>, fullLength: number,
  parts: readonly {x:number;y?:number;z?:number;visible?:boolean;rotation?:[number,number,number];materialDimensions?:[number,number,number]}[], defaultY: number) {
  let nearest = Math.max(0,fullLength-PHOTOEYE_LENS_FRONT)
  for (const part of parts) {
    if (part.visible === false) continue
    const inverse = new Quaternion().setFromEuler(new Euler(...(part.rotation ?? [0,0,0]))).invert()
    const origin = aim.origin.clone().sub(new Vector3(part.x,part.y ?? defaultY,part.z ?? 0)).applyQuaternion(inverse)
    const ray = new Ray(origin,aim.direction.clone().applyQuaternion(inverse))
    const half = new Vector3(...(part.materialDimensions ?? [.16,.16,.16])).multiplyScalar(.5)
    // A tangent ray does not pass through material volume. Replay coordinates
    // may round a fully cleared trailing edge onto the optical plane.
    if (['x','y','z'].some(axis => {
      const k = axis as 'x'|'y'|'z'
      return Math.abs(ray.direction[k]) < 1e-10 && Math.abs(origin[k]) >= half[k]-1e-9
    })) continue
    const hit = ray.intersectBox(new Box3(half.clone().negate(),half),new Vector3())
    if (hit) nearest = Math.min(nearest,origin.distanceTo(hit))
  }
  return nearest
}
