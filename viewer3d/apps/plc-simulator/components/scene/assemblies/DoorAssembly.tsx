import { useRef } from 'react'
import { useFrame } from '@react-three/fiber'
import type { Group } from 'three'
import type { DeviceProps } from '../devices'
import { SocketBolt } from '../IndustrialDetails'
import { FINISH, Part, RoundPart } from './Parts'
import { doorDimensions, doorTravel } from './workcellGeometry'

export function DoorAssembly({ device, plant }: DeviceProps) {
  const leaves = useRef<(Group | null)[]>([])
  const [w, h, d] = device.size
  const { leafWidth: lw, leafHeight: lh, stile: t, glassDepth, railLength } = doorDimensions(w, h, d)
  useFrame(() => {
    const travel = doorTravel(w, plant.state(device.id).pos)
    leaves.current.forEach((g, i) => { if (g) g.position.x = (i === 0 ? -1 : 1) * (w / 4 + travel) })
  })
  return <group name="assembly-door-v1">
    {[-1, 1].map(side => <group key={side}>
      {/* Fixed jambs sit behind the moving leaves, including during opening. */}
      <Part name="door-fixed-crossbar" size={[w + .12, .09, d + .05]} position={[0, side * h / 2, -d - .033]} color={FINISH.dark} />
      <Part name="door-fixed-jamb" size={[.09, h - .09, d + .05]} position={[side * (w / 2 + .06), 0, -d - .033]} color={FINISH.dark} />
      <Part name="door-rail-support" size={[.065, .12, .08]} position={[side * w * .42, h / 2 + .105, -d / 2 - .08]} color={FINISH.dark} />
      {/* Rail continues over the parking space, so an open leaf stays supported. */}
      <Part name="door-overhead-rail-cheek" size={[railLength, .12, .018]} position={[0, h / 2 + .105, side * (d / 2 + .031)]} />
      <Part size={[railLength, .018, .026]} position={[0, h / 2 + .054, side * (d / 2 + .009)]} color={FINISH.steel} />
      <Part size={[.03, .084, d + .044]} position={[side * (railLength / 2 - .015), h / 2 + .105, 0]} color={FINISH.dark} />
    </group>)}
    <Part name="door-rail-cap" size={[railLength, .018, d + .08]} position={[0, h / 2 + .174, 0]} />
    {[-1, 1].map((side, i) => <group key={side} name={`door-moving-leaf-${side}`} ref={g => { leaves.current[i] = g }} position={[side * w / 4, 0, 0]}>
      {/* Stiles/rails border a thin inset pane; no full-size overlapping glass slab. */}
      {[-1, 1].map(s => <group key={s}>
        <Part size={[t, lh, d]} position={[s * (lw / 2 - t / 2), 0, 0]} />
        <Part size={[lw - 2 * t, t, d]} position={[0, s * (lh / 2 - t / 2), 0]} />
        <SocketBolt position={[s * (lw / 2 - t / 2), lh / 2 - .018, d / 2 + .002]} radius={.005} />
      </group>)}
      <mesh name="door-inset-safety-pane">
        <boxGeometry args={[lw - 2 * t, lh - 2 * t, glassDepth]} />
        <meshStandardMaterial color="#a7c5ce" transparent opacity={.20} roughness={.65} metalness={0} depthWrite={false} />
      </mesh>
      {/* Pull handle attached to the inner stile, not floating on the pane. */}
      <RoundPart position={[-side * (lw / 2 - t / 2), 0, d / 2 + .047]} radius={.01} length={.22} axis="y" color={FINISH.dark} />
      {[-1, 1].map(y => <RoundPart key={y} position={[-side * (lw / 2 - t / 2), y * .09, d / 2 + .0235]} radius={.009} length={.047} color={FINISH.dark} />)}
      {[-1, 1].map(x => <group key={x} position={[x * lw * .29, 0, 0]}>
        <Part name="door-hanger" size={[.018, .17, .026]} position={[0, lh / 2 + .085, 0]} color={FINISH.steel} />
        <RoundPart name="door-carrier-wheel" position={[0, h / 2 + .105, 0]} radius={.041} length={d + .016} color={FINISH.dark} />
      </group>)}
    </group>)}
  </group>
}
