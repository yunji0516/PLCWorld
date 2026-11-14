import { useEffect, useMemo } from 'react'
import type { DeviceProps } from '../devices'
import { SocketBolt } from '../IndustrialDetails'
import { bellowsCupGeometry } from './transportGeometry'
import { BoredPlate, FINISH, Part, RoundPart } from './Parts'

function BellowsCup({ x = 0, single }: { x?: number; single: boolean }) {
  const geometry = useMemo(() => bellowsCupGeometry(single ? .06 : .065, single ? .06 : .07), [single])
  useEffect(() => () => geometry.dispose(), [geometry])
  const top = single ? .105 : .115
  return <group position={[x, 0, 0]}>
    <mesh name="vacuum-sealing-cup" castShadow receiveShadow>
      <primitive object={geometry} attach="geometry" />
      <meshStandardMaterial color="#29343b" roughness={.88} metalness={.02} />
    </mesh>
    <RoundPart name="vacuum-cup-stem" position={[0, (top + .14) / 2, 0]} radius={.018} length={.14 - top} axis="y" />
    <RoundPart name="vacuum-cup-retainer" position={[0, .132, 0]} radius={.025} length={.016} axis="y" segments={6} />
  </group>
}

export function VacuumAssembly({ device }: DeviceProps) {
  const single = device.visualVariant === 'single-vacuum-cup'
  return <group name="assembly-vacuum-v1">
    <Part name="vacuum-manifold-body" size={[.34, .09, .22]} position={[0, .185, 0]} radius={.008} />
    <group position={[0, .245, 0]} rotation={[-Math.PI / 2, 0, 0]}>
      <BoredPlate name="vacuum-manifold-lid" size={[.34, .22, .03]} position={[0, 0, 0]}
        holes={[{ x: 0, y: 0, radius: .0355 }]} color={FINISH.steel} />
    </group>
    <RoundPart name="vacuum-mounting-shank" position={[0, .395, 0]} radius={.035} length={.27} axis="y" />
    <RoundPart name="vacuum-shank-locknut" position={[0, .277, 0]} radius={.045} length={.034} axis="y" segments={6} />
    {[-1, 1].map(side => <SocketBolt key={side} position={[side * .13, .2, .113]} radius={.009} />)}
    {/* The pressure switch stays in its trace-specified position; the air inlet is just hardware. */}
    <RoundPart name="vacuum-air-inlet" position={[0, .195, -.12]} radius={.016} length={.02} segments={6} />
    <RoundPart position={[0, .195, -.134]} radius={.010} length={.008} color={FINISH.seal} />
    {single ? <group name="single-vacuum-cup"><BellowsCup single /></group>
      : [-.11, .11].map(x => <BellowsCup key={x} x={x} single={false} />)}
  </group>
}
