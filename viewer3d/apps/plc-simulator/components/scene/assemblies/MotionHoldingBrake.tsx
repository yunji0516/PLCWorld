import { useFrame } from '@react-three/fiber'
import { useRef } from 'react'
import type { Group, MeshStandardMaterial } from 'three'
import type { DeviceProps } from '../devices'
import { FINISH, Part, RoundPart } from './Parts'

/** Synthetic holding brake accessory on the reused vertical slide. */
export function MotionHoldingBrake({ device, plant }: DeviceProps) {
  const pads = useRef<Group>(null)
  const light = useRef<MeshStandardMaterial>(null)
  useFrame(() => {
    const closed = plant.state(device.id).pos > .5
    if (pads.current) pads.current.scale.x = closed ? 1 : 1.3
    if (light.current) light.current.emissiveIntensity = closed ? 1.2 : .05
  })
  return <group name="motion-holding-brake">
    <Part name="brake-side-mount-flange" position={[-.0964,.083,0]} size={[.0128,.034,.12]} color={FINISH.steel}/>
    <Part size={[.18,.20,.15]} color={FINISH.dark} radius={.008} />
    <RoundPart position={[0,0,.085]} radius={.061} length={.025} axis="z" color={FINISH.steel} />
    <group ref={pads} name="brake-pads">
      {[-1,1].map(side => <Part key={side} position={[side*.055,0,.105]} size={[.025,.10,.018]} color={FINISH.blue} radius={.003} />)}
    </group>
    <mesh position={[0,.076,.076]}>
      <circleGeometry args={[.009,16]} />
      <meshStandardMaterial ref={light} color="#eaaa36" emissive="#eaaa36" />
    </mesh>
  </group>
}
