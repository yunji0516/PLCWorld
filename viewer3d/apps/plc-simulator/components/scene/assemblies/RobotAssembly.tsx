import { useRef } from 'react'
import { useFrame } from '@react-three/fiber'
import type { Group } from 'three'
import { Vector3 } from 'three'
import type { DeviceProps } from '../devices'
import { SocketBolt } from '../IndustrialDetails'
import { BoredPlate, FINISH, Part, RoundPart } from './Parts'

/** Generic two-joint visual linkage, not a manufacturer model or a new robot solver. */
export function RobotAssembly({ device, plant }: DeviceProps) {
  return device.visualVariant === 'material-taught-arm'
    ? <MaterialTaughtArm device={device} plant={plant} />
    : <LegacyRobotAssembly device={device} plant={plant} />
}

function LegacyRobotAssembly({ device, plant }: DeviceProps) {
  const shoulder = useRef<Group>(null), elbow = useRef<Group>(null)
  useFrame(() => {
    const p = plant.state(device.id).pos
    if (shoulder.current) shoulder.current.rotation.y = -.9 + p * 1.8
    if (elbow.current) elbow.current.rotation.z = -.6 + p * .9
  })
  return <group name="assembly-robot-v1">
    <RoundPart name="robot-base-flange" radius={.28} length={.045} position={[0, .0225, 0]} axis="y" color={FINISH.dark} segments={48} />
    <RoundPart name="robot-fixed-reducer" radius={.225} length={.195} position={[0, .1425, 0]} axis="y" color={FINISH.dark} segments={48} />
    {Array.from({ length: 6 }, (_, i) => <SocketBolt key={i} top position={[.251 * Math.cos(i * Math.PI / 3), .048, .251 * Math.sin(i * Math.PI / 3)]} radius={.009} />)}
    <group name="robot-shoulder" ref={shoulder} position={[0, .24, 0]}>
      <RoundPart radius={.16} length={.09} position={[0, .045, 0]} axis="y" color={FINISH.steel} segments={48} />
      {/* Hollow mounting window and tapered joint transitions distinguish the cast link. */}
      <BoredPlate name="robot-upright-link" size={[.18, .47, .15]} position={[0, .345, 0]} corner={.035}
        holes={[{ x: 0, y: -.11, radius: .025 }, { x: 0, y: .11, radius: .025 }]} />
      <RoundPart name="robot-link-heel" radius={.105} length={.17} position={[0, .10, 0]} />
      <RoundPart name="robot-fixed-elbow-seat" radius={.105} length={.17} position={[0, .595, 0]} />
      <group name="robot-elbow" ref={elbow} position={[0, .7, 0]}>
        <RoundPart name="robot-elbow-reducer" radius={.125} length={.22} position={[0, 0, 0]} color={FINISH.dark} segments={48} />
        {[-1, 1].map(s => <group key={s} position={[0, 0, s * .116]} rotation={[0, s < 0 ? Math.PI : 0, 0]}>
          <RoundPart radius={.091} length={.012} position={[0, 0, 0]} />
          {Array.from({ length: 6 }, (_, i) => <SocketBolt key={i} position={[.065 * Math.cos(i * Math.PI / 3), .065 * Math.sin(i * Math.PI / 3), .009]} radius={.006} />)}
        </group>)}
        <Part name="robot-forearm" size={[.455, .14, .14]} position={[.3425, 0, 0]} radius={.036} />
        <Part name="robot-service-cover" size={[.27, .048, .009]} position={[.35, 0, .0745]} radius={.008} color={FINISH.dark} />
        <RoundPart name="robot-wrist-collar" radius={.085} length={.09} axis="x" position={[.615, 0, 0]} color={FINISH.dark} />
        <RoundPart name="robot-wrist-flange" radius={.075} length={.018} axis="x" position={[.669, 0, 0]} />
        {/* Preserve the old end-effector mount's lowest datum (-.14). */}
        <Part name="robot-tool-mount" size={[.032, .16, .16]} position={[.694, -.06, 0]} color={FINISH.dark} radius={.01} />
      </group>
    </group>
  </group>
}

/** Visual linkage to trace-specified TOOL flange. Not a six-axis robot solver.
 * Opt-in Material variant: no geometry or motion changes to legacy/Motion arms.
 */
function MaterialTaughtArm({ device, plant }: DeviceProps) {
  const upper = useRef<Group>(null), lower = useRef<Group>(null)
  const elbow = useRef<Group>(null), wrist = useRef<Group>(null)
  const a = 1.15, b = 1.05
  useFrame(() => {
    const tool = plant.machine.devices.find(d => d.id === 'TOOL' && d.mountedOn === device.id)
    if (!tool) return
    const origin = new Vector3(0, .45, 0)
    const target = new Vector3(...tool.pos).sub(new Vector3(...device.pos))
    target.y += tool.kind === 'vacuum' ? .53 : .08
    const direction = target.clone().sub(origin), distance = direction.length()
    direction.normalize()
    const reach = Math.min(a + b - 1e-6, Math.max(Math.abs(a - b) + 1e-6, distance))
    const along = (a*a - b*b + reach*reach) / (2*reach)
    const perpendicular = new Vector3(0, 1, 0).addScaledVector(direction, -direction.y).normalize()
    const joint = origin.clone().addScaledVector(direction, along)
      .addScaledVector(perpendicular, Math.sqrt(Math.max(0, a*a - along*along)))
    for (const [ref, start, end] of [[upper, origin, joint], [lower, joint, target]] as const) {
      if (!ref.current) continue
      ref.current.position.copy(start).add(end).multiplyScalar(.5)
      ref.current.quaternion.setFromUnitVectors(new Vector3(0, 1, 0), end.clone().sub(start).normalize())
    }
    if (elbow.current) elbow.current.position.copy(joint)
    if (wrist.current) wrist.current.position.copy(target)
  })
  return <group name="assembly-material-taught-arm">
    <RoundPart name="robot-base-flange" radius={.28} length={.05} position={[0,.025,0]} axis="y" color={FINISH.dark} />
    <RoundPart name="robot-pedestal" radius={.19} length={.30} position={[0,.20,0]} axis="y" />
    <RoundPart name="robot-shoulder-joint" radius={.16} length={.22} position={[0,.45,0]} color={FINISH.dark} />
    <group ref={upper} name="robot-upper-link">
      <Part name="robot-upper-casting" size={[.16,a-.18,.18]} position={[0,0,0]} radius={.035} />
      <Part name="robot-upper-cover" size={[.12,a-.36,.018]} position={[0,0,.099]} radius={.015} color={FINISH.dark} />
    </group>
    <group ref={elbow} name="robot-elbow-joint">
      <RoundPart radius={.14} length={.22} position={[0,0,0]} color={FINISH.dark} />
      <RoundPart radius={.10} length={.025} position={[0,0,.125]} />
    </group>
    <group ref={lower} name="robot-lower-link">
      <Part name="robot-forearm-casting" size={[.13,b-.13,.14]} position={[0,0,0]} radius={.025} />
      <Part name="robot-forearm-cover" size={[.09,b-.3,.015]} position={[0,0,.0775]} radius={.012} color={FINISH.dark} />
    </group>
    <group ref={wrist} name="robot-trace-tool-flange">
      <RoundPart radius={.075} length={.04} position={[0,.02,0]} axis="y" color={FINISH.dark} />
      {[-1,1].map(s => <SocketBolt key={s} top position={[s*.052,.044,0]} radius={.006} />)}
    </group>
  </group>
}
