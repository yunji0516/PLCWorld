import { useRef } from 'react'
import { useFrame } from '@react-three/fiber'
import type { Group, Mesh } from 'three'
import type { DeviceProps } from '../devices'
import { SocketBolt } from '../IndustrialDetails'
import { BoredPlate, FINISH, Part, RoundPart } from './Parts'

export const pressTravel = (h: number, p: number, maxTravel = h * .72) => -p * maxTravel
export function PressAssembly({ device, plant }: DeviceProps) {
  const ram = useRef<Group>(null), rod = useRef<Mesh>(null)
  const [w, h, d] = device.size
  const glandBottom = h * .29 - .026
  useFrame(() => {
    const y = pressTravel(h, plant.state(device.id).pos, device.pressMaxTravel)
    if (ram.current) ram.current.position.y = y
    // Extend the piston rod from the fixed gland to the moving pressure plate.
    const plateTop = y - h * .18 + .06
    if (rod.current) { rod.current.position.y = (glandBottom + plateTop) / 2; rod.current.scale.y = Math.max(.005, glandBottom - plateTop) }
  })
  return <group name="assembly-press-v1">
    <group rotation={[Math.PI / 2, 0, 0]} position={[0, h * .5, 0]}>
      <BoredPlate name="press-bored-head" size={[w, d, h * .42]} position={[0, 0, 0]} holes={[{ x: 0, y: 0, radius: .074 }]} color={FINISH.dark} corner={.018} />
    </group>
    <Part name="press-sealed-head-cover" size={[w * .94, .024, d * .94]} position={[0, h * .71 + .012, 0]} color={FINISH.steel} radius={.008} />
    {[-1, 1].flatMap(x => [-1, 1].map(z => <SocketBolt key={`lid:${x}:${z}`} top radius={.007}
      position={[x * w * .36, h * .71 + .026, z * d * .36]} />))}
    <group rotation={[Math.PI / 2, 0, 0]} position={[0, h * .29 - .013, 0]}>
      <BoredPlate name="press-guide-gland" size={[.20, .20, .026]} position={[0, 0, 0]} holes={[{ x: 0, y: 0, radius: .071 }]} />
    </group>
    {[-1, 1].map(s => <group key={s}>
      {/* Rear posts stop at the head underside rather than passing through its lid. */}
      <Part name="press-rear-column" size={[.08, h * 1.04 - .022, .08]} position={[s * (w / 2 - .06), -h * .23 + .011, -d / 2 + .06]} color={FINISH.dark} radius={.008} />
      <Part name="press-column-foot" size={[.12, .022, .14]} position={[s * (w / 2 - .06), -h * .75 + .011, -d / 2 + .06]} />
      {[-1, 1].map(y => <SocketBolt key={y} position={[s * w * .4, h * .5 + y * h * .13, d / 2 + .003]} radius={.01} />)}
    </group>)}
    <mesh name="press-extending-rod" ref={rod} castShadow><cylinderGeometry args={[.07, .07, 1, 40]} /><meshStandardMaterial color={FINISH.steel} roughness={.68} metalness={.6} /></mesh>
    <group name="press-moving-ram" ref={ram}>
      <Part name="press-pressure-plate" size={[w * .62, .09, d * .62]} position={[0, -h * .18 + .015, 0]} radius={.007} />
      <Part name="press-replaceable-die" size={[w * .62, .03, d * .62]} position={[0, -h * .18 - .045, 0]} color={FINISH.dark} radius={.002} />
      {[-1, 1].flatMap(x => [-1, 1].map(z => <SocketBolt key={`${x}:${z}`} top radius={.006}
        position={[x * w * .22, -h * .18 + .063, z * d * .22]} />))}
    </group>
    <RoundPart name="press-service-fitting" position={[0, h * .59, d / 2 + .014]} radius={.018} length={.028} segments={6} />
  </group>
}
