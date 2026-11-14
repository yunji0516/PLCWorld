import { useEffect, useMemo, useRef } from 'react'
import { useFrame } from '@react-three/fiber'
import type { Group } from 'three'
import type { DeviceProps } from '../devices'
import { SocketBolt } from '../IndustrialDetails'
import { satinFinish } from '../surfaceFinish'
import { FINISH, Part, RoundPart } from './Parts'
import { indexAngle, indexPlateGeometry } from './workcellGeometry'

export function TurntableAssembly({ device, plant }: DeviceProps) {
  const disc = useRef<Group>(null)
  const [w, h] = device.size
  const geometry = useMemo(() => indexPlateGeometry(w, h), [w, h])
  useEffect(() => () => geometry.dispose(), [geometry])
  const pedestalTop = -.16, pedestalBottom = -device.pos[1] + .07
  const housingTop = -h / 2 - .018
  useFrame(() => { if (disc.current) disc.current.rotation.y = device.visualVariant === 'quarter-turn-base' ? plant.state(device.id).pos*Math.PI/2 : indexAngle(plant.state(device.id).pos) })
  return <group name="assembly-turntable-v1">
    <RoundPart name="index-base-flange" radius={w * .34} length={.07} position={[0, -device.pos[1] + .035, 0]} axis="y" color={FINISH.dark} segments={64} />
    <RoundPart name="index-pedestal" radius={w * .24} length={Math.max(.03, pedestalTop - pedestalBottom)} position={[0, (pedestalTop + pedestalBottom) / 2, 0]} axis="y" color={FINISH.dark} segments={64} />
    <RoundPart name="index-fixed-gearcase" radius={w / 2 + .065} length={housingTop + .16} position={[0, (housingTop - .16) / 2, 0]} axis="y" color={FINISH.dark} segments={64} />
    {/* Thin bearing shoulder, fully below the original rotating plate bottom. */}
    <RoundPart name="index-bearing-shoulder" radius={w * .43} length={.018} position={[0, -h / 2 - .009, 0]} axis="y" segments={64} />
    {Array.from({ length: 6 }, (_, i) => {
      const a = i * Math.PI / 3
      return <SocketBolt key={i} position={[Math.cos(a) * w * .295, -device.pos[1] + .073, Math.sin(a) * w * .295]} top radius={.013} />
    })}
    <group name="index-moving-disc" ref={disc}>
      <mesh name="index-bored-tooling-plate" castShadow receiveShadow>
        <primitive attach="geometry" object={geometry} />
        <meshStandardMaterial color={FINISH.alloy} {...satinFinish(.7, .60)} />
      </mesh>
      {device.visualVariant !== 'quarter-turn-base' && <RoundPart name="index-central-cover" radius={w * .135} length={.018} position={[0, h / 2 + .009, 0]} axis="y" segments={48} />}
      {Array.from({ length: 8 }, (_, i) => <SocketBolt key={i} position={[Math.cos(i * Math.PI / 4) * w * .2, h / 2 + .003, Math.sin(i * Math.PI / 4) * w * .2]} top radius={.010} />)}
      {/* Retain the six original index marker positions and envelope. */}
      {!['single-pocket-index','quarter-turn-base'].includes(device.visualVariant ?? '') && Array.from({ length: 6 }, (_, i) => <Part key={i} name="index-station-marker" size={[.1, .03, .1]}
        position={[Math.cos(i * Math.PI / 3) * w * .36, h / 2 + .02, Math.sin(i * Math.PI / 3) * w * .36]} color={FINISH.blue} />)}
    </group>
  </group>
}
