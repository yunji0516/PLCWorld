import { useRef } from 'react'
import { useFrame } from '@react-three/fiber'
import type { Group } from 'three'
import type { DeviceProps } from '../devices'
import { SocketBolt } from '../IndustrialDetails'
import { FINISH, Part, RoundPart } from './Parts'
import { stopperPosition } from './storageGeometry'

export function StopperAssembly({ device, plant }: DeviceProps) {
  const moving = useRef<Group>(null)
  const [, h, d] = device.size
  useFrame(() => { if (moving.current) moving.current.position.y = stopperPosition(h, plant.state(device.id).pos) })
  return <group name="assembly-stopper-v1">
    {/* Two guide housings leave a real .065-wide slot around the .055 blade. */}
    {[-1, 1].map(s => <group key={s}>
      <Part name="stopper-fixed-guide" size={[.0575, h * .83, d * .72]} position={[s * .06125, -h * .685, 0]} color={FINISH.dark} />
      <Part name="stopper-guide-cap" size={[.0575, .016, d * .72]} position={[s * .06125, -h * .27 + .008, 0]} />
      <SocketBolt position={[s * .06125, -h * .27 + .019, 0]} top radius={.008} />
    </group>)}
    <Part name="stopper-lower-bridge" size={[.18, h * .05, d * .72]} position={[0, -h * 1.125, 0]} color={FINISH.dark} />
    <RoundPart name="stopper-air-port" position={[.06125, -h * .85, d * .36 + .012]} radius={.014} length={.024} segments={6} />
    <group name="stopper-moving-blade" ref={moving}>
      <Part name="stopper-contact-blade" size={[.055, h * .58, d]} radius={.003} color={FINISH.steel} />
      <Part name="stopper-ram-shoe" size={[.045, h * .21, d * .58]} position={[0, -h * .395, 0]} />
    </group>
  </group>
}
