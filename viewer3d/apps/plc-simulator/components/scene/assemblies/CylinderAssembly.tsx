import { useFrame } from '@react-three/fiber'
import { useRef } from 'react'
import type { Group, Mesh } from 'three'
import type { DeviceProps } from '../devices'
import { cylinderContact } from '../deviceGeometry'
import { SocketBolt } from '../IndustrialDetails'
import { satinFinish } from '../surfaceFinish'
import { cylinderRodHardware } from './geometry'
import { BoredPlate, FINISH, Part, RoundPart } from './Parts'

/** Tie-rod pneumatic actuator with a bored gland and a separate, constant-thickness contact plate. */
export function CylinderAssembly({ device, plant }: DeviceProps) {
  const rod = useRef<Mesh>(null), plate = useRef<Group>(null)
  const stroke = device.size[2]
  const initial = cylinderContact(stroke, 0, device.rodBaseExtension)
  const hardware = cylinderRodHardware(initial.exposedAtMin)
  const rearSurface = stroke * .4 + .025
  const frontDepth = .035
  const rearDepth = rearSurface - initial.bodyHalf + .015
  const tubeLength = initial.bodyHalf * 2 - frontDepth - .015
  const tieHoles = [-1, 1].flatMap(x => [-1, 1].map(y => ({ x: x * .057, y: y * .043, radius: .005 })))
  useFrame(() => {
    const next = cylinderContact(stroke, plant.state(device.id).pos, device.rodBaseExtension)
    if (rod.current) {
      rod.current.position.z = -next.bodyHalf - next.exposed / 2
      rod.current.scale.y = next.exposed
    }
    if (plate.current) plate.current.position.z = next.plateCenter
  })
  return <group name="assembly-cylinder-v1">
    <group name="cylinder-fixed-body">
      <Part name="cylinder-extruded-tube" size={[.106, .106, tubeLength]}
        position={[0, 0, .01]} radius={.014} />
      {/* Two narrow shoulders support the original Material and Motion slot-sensor positions. */}
      <Part name="cylinder-top-sensor-track" size={[.025, .005, tubeLength]} position={[0, .0545, .01]} color={FINISH.dark} radius={.001} />
      <Part name="cylinder-side-sensor-track" size={[.025, .008, tubeLength]} position={[.054, .048, .01]} color={FINISH.dark} radius={.001} />
      <BoredPlate name="cylinder-front-cap" size={[.14, .13, frontDepth]}
        position={[0, 0, -initial.bodyHalf + frontDepth / 2]}
        holes={[{ x: 0, y: 0, radius: .022 }, ...tieHoles]} corner={.014} />
      <BoredPlate name="cylinder-rear-cap" size={[.14, .13, rearDepth]}
        position={[0, 0, rearSurface - rearDepth / 2]} holes={tieHoles} corner={.014} />
      <BoredPlate name="cylinder-rod-gland" size={[.062, .062, .008]}
        position={[0, 0, -initial.bodyHalf + .004]} corner={.014}
        holes={[{ x: 0, y: 0, radius: .0188 }]} color={FINISH.seal} />
      {tieHoles.map(({ x, y }) => <group key={`${x}:${y}`}>
        <RoundPart name="cylinder-tie-rod" position={[x, y, (rearSurface - initial.bodyHalf) / 2]}
          radius={.0045} length={rearSurface + initial.bodyHalf} />
        <SocketBolt position={[x, y, rearSurface + .002]} radius={.007} />
        <group position={[x, y, -initial.bodyHalf - .002]} rotation={[0, Math.PI, 0]}>
          <SocketBolt position={[0, 0, 0]} radius={.007} />
        </group>
      </group>)}
      {[-initial.bodyHalf + frontDepth / 2, rearSurface - rearDepth / 2].map(z => <group key={z}>
        <RoundPart name="cylinder-air-port" position={[.077, 0, z]} radius={.014} length={.02} axis="x" segments={6} />
        <RoundPart position={[.089, 0, z]} radius={.009} length={.009} axis="x" color={FINISH.seal} />
      </group>)}
    </group>
    <mesh name="cylinder-moving-rod" ref={rod} position={[0, 0, -initial.bodyHalf - initial.exposed / 2]}
      rotation={[Math.PI / 2, 0, 0]} scale={[1, initial.exposed, 1]} castShadow>
      <cylinderGeometry args={[.018, .018, 1, 32]} />
      <meshStandardMaterial color="#aebbc6" {...satinFinish(.62, .72)} />
    </mesh>
    <group name="cylinder-moving-contact" ref={plate} position={[0, 0, initial.plateCenter]}>
      {/* No fasteners project from the workpiece-facing surface at z=-.015. */}
      <Part name="cylinder-contact-plate" size={[.12, .14, initial.plateThickness]} radius={.003} />
      <RoundPart name="cylinder-rod-locknut" position={[0, 0, hardware.nutCenter]} radius={.027} length={hardware.nutLength} segments={6} />
      <RoundPart name="cylinder-rod-collar" position={[0, 0, hardware.collarCenter]} radius={.022} length={hardware.collarLength} />
    </group>
  </group>
}
