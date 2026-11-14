import {FittedMaterialDrive} from './FittedMaterialDrive'
import { useFrame } from '@react-three/fiber'
import { useRef } from 'react'
import type { Group, MeshStandardMaterial } from 'three'
import type { DeviceProps } from '../devices'
import { FINISH, Part, RoundPart } from './Parts'

/** Synthetic single drive module: fixed bearings support a continuously rotating shaft. */
export function MotionEasyHardware({ device, plant }: DeviceProps) {
  const rotor = useRef<Group>(null)
  const led = useRef<MeshStandardMaterial>(null)
  useFrame(() => {
    const state = plant.state(device.id)
    if (rotor.current) rotor.current.rotation.x = state.pos
    if (led.current) led.current.emissiveIntensity = state.pos > .5 ? 1.5 : .05
  })
  if (device.visualVariant === 'motion-reference-dog') return <group name="home-moving-dog">
    <Part name="home-metal-target" size={[.02,.024,.074]} radius={.001} color={FINISH.steel} />
  </group>
  if (device.visualVariant === 'motion-home-probe') return <group name="home-fixed-probe">
    <Part name="home-probe-foot" size={[.06,.008,.06]} position={[0,-.2134,.016]} color={FINISH.dark} radius={.002} />
    <Part name="home-probe-post" size={[.016,.2014,.012]} position={[0,-.1087,.019]} radius={.001} />
    <RoundPart name="home-inductive-barrel" position={[0,0,0]} radius={.008} length={.05} axis="z" />
    <mesh name="home-probe-tip" position={[0,0,-.0255]}>
      <circleGeometry args={[.007,20]} />
      <meshStandardMaterial color="#2b323b" />
    </mesh>
    <mesh position={[0,.0085,0]} rotation={[-Math.PI/2,0,0]}>
      <circleGeometry args={[.003,12]} />
      <meshStandardMaterial ref={led} color="#eaaa36" emissive="#eaaa36" />
    </mesh>
  </group>
  return <group name="motion-easy-roll-assembly">
    {[-1,1].map(side => <group key={side} name={`roller-bearing-${side}`}>
      <Part name="roller-bearing-foot" size={[.19,.05,.35]} position={[side*.43,-.285,0]} color={FINISH.dark} radius={.006} />
      <Part name="roller-bearing-pedestal" size={[.095,.195,.14]} position={[side*.43,-.1775,0]} radius={.006} />
      <mesh name="roller-bearing-ring" position={[side*.43,0,0]} rotation={[0,Math.PI/2,0]} castShadow>
        <torusGeometry args={[.065,.022,12,32]} />
        <meshStandardMaterial color={FINISH.steel} metalness={.65} roughness={.35} />
      </mesh>
    </group>)}
    <Part name="roller-motor-mount" size={[.21,.05,.30]} position={[-.625,-.285,0]} color={FINISH.dark} radius={.004} />
    <Part name="roller-motor-stand" size={[.09,.12,.12]} position={[-.625,-.20,0]} radius={.003} />
    <FittedMaterialDrive size={[.19,.30,.30]} position={[-.625,-.05,0]}/>
    <group ref={rotor} name="motion-easy-rotor">
      <RoundPart name="roller-shaft" position={[0,0,0]} radius={.035} length={1.07} axis="x" />
      <RoundPart name="roller-drum" position={[0,0,0]} radius={.19} length={.70} axis="x" color="#87969f" segments={48} />
      <Part name="roller-rotation-mark" size={[.56,.003,.024]} position={[0,.191,0]} color="#d6a048" radius={.001} />
    </group>
  </group>
}
