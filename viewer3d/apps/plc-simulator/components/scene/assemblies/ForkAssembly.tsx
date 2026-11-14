import { useEffect, useMemo, useRef } from 'react'
import { useFrame } from '@react-three/fiber'
import type { Group } from 'three'
import type { DeviceProps } from '../devices'
import { SocketBolt } from '../IndustrialDetails'
import { satinFinish } from '../surfaceFinish'
import { FINISH, Part } from './Parts'
import { forkPosition, forkTineGeometry } from './storageGeometry'

export function ForkAssembly({ device, plant }: DeviceProps) {
  const moving = useRef<Group>(null)
  const g = useMemo(() => forkTineGeometry(device.size[2]), [device.size])
  useEffect(() => () => g.dispose(), [g])
  useFrame(() => { if (moving.current) moving.current.position.z = forkPosition(plant.state(device.id).pos) })
  return <group name="assembly-fork-v1"><group name="fork-moving-carriage" ref={moving}>
    {/* Frame around a genuine central opening, retaining the original mounting envelope. */}
    {[-1, 1].map(s => <group key={s}>
      <Part name="fork-carriage-cheek" size={[.06, .30, .12]} position={[s * .14, .04, .10]} color={FINISH.dark} />
      {/* The lower beam starts at -.10: MAT-E13's lift body ends there. */}
      <Part name="fork-carriage-crossbar" size={[.22, s < 0 ? .03 : .04, .12]} position={[0, s < 0 ? -.085 : .17, .10]} color={FINISH.dark} />
      {[-1, 1].map(y => <SocketBolt key={y} position={[s * .14, .04 + y * .11, .163]} radius={.009} />)}
      <Part name="fork-heel" size={[.055, .10, .025]} position={[s * .105, -.0025, .0275]} />
      <mesh name="fork-tapered-tine" position={[s * .105, 0, 0]} castShadow receiveShadow>
        <primitive object={g} attach="geometry" />
        <meshStandardMaterial color={FINISH.steel} {...satinFinish(.72, .65)} />
      </mesh>
      <Part name="fork-lock-block" size={[.04, .018, .06]} position={[s * .105, .199, .10]} color={FINISH.steel} />
      <SocketBolt position={[s * .105, .211, .10]} top radius={.008} />
    </group>)}
  </group></group>
}
