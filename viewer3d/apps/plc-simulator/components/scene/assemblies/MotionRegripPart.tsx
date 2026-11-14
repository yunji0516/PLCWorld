import { useFrame } from '@react-three/fiber'
import { useRef } from 'react'
import type { Group } from 'three'
import type { Plant } from '@/lib/machine/plant'

/** Public synthetic part: lower clamp flats and six upper grasp faces.
 * The Easy machines are unchanged. The mark makes the retained 60° orientation visible.
 */
export function MotionRegripPart({ id, plant }: { id: number; plant: Plant }) {
  const group = useRef<Group>(null)
  useFrame(() => {
    const part = plant.parts.find(p => p.id === id)
    if (!group.current || !part) return
    group.current.position.set(part.x, part.y ?? 0, part.z ?? 0)
    group.current.rotation.set(...(part.rotation ?? [0, 0, 0] as [number, number, number]))
  })
  return <group ref={group} name="motion-regrip-workpiece">
    <mesh position={[0, -.12, 0]} castShadow><boxGeometry args={[.16, .15, .16]} /><meshStandardMaterial color="#d5a54d" roughness={.6} /></mesh>
    <mesh position={[0, -.005, 0]} castShadow><cylinderGeometry args={[.04, .04, .08, 24]} /><meshStandardMaterial color="#a17936" roughness={.6} /></mesh>
    <mesh position={[0, .115, 0]} castShadow><cylinderGeometry args={[.18 / Math.sqrt(3), .18 / Math.sqrt(3), .16, 6]} /><meshStandardMaterial color="#e7ab42" roughness={.6} /></mesh>
    <mesh position={[.091, .115, 0]}><boxGeometry args={[.002, .075, .055]} /><meshStandardMaterial color="#324b69" /></mesh>
  </group>
}
