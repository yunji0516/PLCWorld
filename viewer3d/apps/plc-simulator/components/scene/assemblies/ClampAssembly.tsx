import { useRef } from 'react'
import { useFrame } from '@react-three/fiber'
import type { Group } from 'three'
import type { DeviceProps } from '../devices'
import { clampGeometry } from '../deviceGeometry'
import { SocketBolt } from '../IndustrialDetails'
import { BoredPlate, FINISH, Part, RoundPart } from './Parts'

export function ClampAssembly({ device, plant }: DeviceProps) {
  const jaws = useRef<(Group | null)[]>([])
  const [w, , d] = device.size
  const jaw = clampGeometry(0)
  // The smallest clamp also needs enough rail for the full, unchanged jaw stroke.
  const railLength = Math.max(w + .20, 2 * (jaw.jawCenter + .07))
  useFrame(() => {
    const x = clampGeometry(plant.state(device.id).pos).jawCenter
    jaws.current.forEach((g, i) => { if (g) g.position.x = (i === 0 ? -1 : 1) * x })
  })
  return <group name="assembly-clamp-v1">
    <Part name="clamp-mount-plate" size={[Math.max(w + .62, railLength + .08), .05, d * 1.08]} position={[0, -.115, 0]} color={FINISH.dark} />
    <Part size={[railLength + .06, .025, d]} position={[0, -.0775, 0]} />
    {[-1, 1].map(side => <group key={side}>
      <RoundPart name="clamp-guide-rod" radius={.0125} length={railLength} axis="x" position={[0, -.045, side * d * .28]} />
      {[-1, 1].map(end => <group key={end} rotation={[0, Math.PI / 2, 0]} position={[end * (railLength / 2 + .0125), -.041, side * d * .28]}>
        <BoredPlate name="clamp-guide-end" size={[.052, .048, .025]} position={[0, 0, 0]} holes={[{ x: 0, y: -.004, radius: .0125 }]} />
      </group>)}
    </group>)}
    <Part name="clamp-rear-drive-bridge" size={[.30, .025, .09]} position={[0, -.0525, d / 2 + .025]} color={FINISH.dark} />
    <Part name="clamp-actuator-housing" size={[.34, .18, .16]} position={[0, .015, d / 2 + .10]} color={FINISH.dark} radius={.01} />
    <Part name="clamp-actuator-end-cap" size={[.34, .18, .02]} position={[0, .015, d / 2 + .19]} radius={.005} />
    {/* Existing magnetic sensor mounting surface and height are unchanged. */}
    <Part name="clamp-sensor-slot" size={[.025, .004, .14]} position={[0, .106, d / 2 + .11]} color={FINISH.seal} radius={.001} />
    {[-1, 1].flatMap(x => [-1, 1].map(y => <SocketBolt key={`${x}:${y}`} position={[x * .13, .015 + y * .06, d / 2 + .203]} />))}
    {[-1, 1].map(side => <RoundPart key={side} radius={.014} length={.025} position={[side * .065, .015, d / 2 + .2125]} color={FINISH.steel} segments={6} />)}
    {[-1, 1].map((side, i) => <group key={side} ref={g => { jaws.current[i] = g }} name={`clamp-moving-jaw-${side}`} position={[side * jaw.jawCenter, 0, 0]}>
      {/* Lower slide really has two through-bores around the fixed guide rods. */}
      <group rotation={[0, Math.PI / 2, 0]} position={[0, -.045, 0]}>
        <BoredPlate name="clamp-bored-slider" size={[.30, .04, .10]} position={[0, 0, 0]} corner={.003}
          holes={[-1, 1].map(s => ({ x: s * d * .28, y: 0, radius: .0135 }))} />
      </group>
      {/* Partition the original .10-wide jaw, keeping its inner contact face. */}
      <Part name="clamp-jaw-carrier" size={[.088, .16, .30]} position={[side * .006, .055, 0]} radius={.004} />
      <Part name="clamp-replaceable-contact-pad" size={[.012, .16, .30]} position={[-side * .044, .055, 0]} color={FINISH.dark} radius={.001} />
      {[-1, 1].map(z => <SocketBolt key={z} position={[side * .012, .138, z * .10]} top radius={.008} />)}
    </group>)}
  </group>
}
