import {TABLE_FINISH} from './tableFinish'
import { useFrame } from '@react-three/fiber'
import { useEffect, useMemo, useRef } from 'react'
import { InstancedMesh, Object3D } from 'three'
import type { DeviceProps } from '../devices'
import { SlottedProfileGeometry, SocketBolt } from '../IndustrialDetails'
import { satinFinish } from '../surfaceFinish'
import { beltDimensions, beltSurfacePose, wrappedBeltGeometry } from './transportGeometry'
import { FINISH, Part, RoundPart } from './Parts'
import { noseBeltDimensions, noseBeltGeometry, noseBeltPose, STOPPER_NOSE } from './noseBeltGeometry'

function BeltLoop({ device, plant, length, width, travelLength, nose }: DeviceProps & { length: number; width: number; travelLength: number; nose?: 'left' | 'right' }) {
  const left = nose === 'left' ? STOPPER_NOSE.radius : .08, right = nose === 'right' ? STOPPER_NOSE.radius : .08
  const g = nose ? noseBeltDimensions(length, left, right) : beltDimensions(length)
  const geometry = useMemo(() => nose ? noseBeltGeometry(length, width, left, right) : wrappedBeltGeometry(length, width), [length, width, nose, left, right])
  useEffect(() => () => geometry.dispose(), [geometry])
  const marks = useRef<InstancedMesh>(null)
  const dummy = useMemo(() => new Object3D(), [])
  const count = Math.ceil(g.perimeter / .32)
  useFrame(() => {
    if (!marks.current) return
    const distance = plant.state(device.id).spin / (2 * Math.PI) * travelLength
    for (let i = 0; i < count; i++) {
      const phase = distance + i * g.perimeter / count
      const pose = nose ? noseBeltPose(length, left, right, phase) : beltSurfacePose(length, phase)
      dummy.position.set(pose.x, pose.y, 0); dummy.rotation.z = pose.angle; dummy.updateMatrix()
      marks.current.setMatrixAt(i, dummy.matrix)
    }
    marks.current.instanceMatrix.needsUpdate = true
  })
  return <group>
    <mesh name="conveyor-continuous-belt" castShadow receiveShadow>
      <primitive object={geometry} attach="geometry" />
      <meshStandardMaterial color="#252e34" roughness={.94} metalness={.02} />
    </mesh>
    <instancedMesh name="conveyor-trace-driven-markers" ref={marks} args={[undefined, undefined, count]}>
      <boxGeometry args={[.025, .001, width * .22]} />
      <meshStandardMaterial color="#45535e" roughness={.94} metalness={.02} />
    </instancedMesh>
  </group>
}

export function ConveyorAssembly({ device, plant }: DeviceProps) {
  const [length, , width] = device.size
  const g = beltDimensions(length), legHeight = Math.max(.04, device.pos[1] - .13)
  const carriedByLift = plant.machine.devices.some(d => d.id === device.mountedOn && d.kind === 'lift') ||
    (plant.machine.replaySuite === 'material' && device.mountedOn === 'ROTARY_BASE' && !!device.replayPoseRotation)
  // Only split a belt where a declared, aligned vertical stopper crosses its path.
  // Small nose rollers keep the unpowered span shorter than the .16 workpiece.
  const station = plant.machine.devices.filter(d => d.kind === 'stopper').map(d => {
    const dx = d.pos[0] - device.pos[0], dz = d.pos[2] - device.pos[2]
    return { d, x: dx * Math.cos(device.rot) - dz * Math.sin(device.rot),
      z: dx * Math.sin(device.rot) + dz * Math.cos(device.rot) }
  }).find(({ d, x, z }) => Math.abs(Math.sin(d.rot - device.rot)) < .001 &&
    Math.abs(z) < .01 && Math.abs(x) + .4 < length / 2 && Math.abs(d.pos[1] - device.pos[1]) < .25)
  const segments = station ? [
    { length: length / 2 + station.x - STOPPER_NOSE.gap / 2, x: (-length / 2 + station.x - STOPPER_NOSE.gap / 2) / 2 },
    { length: length / 2 - station.x - STOPPER_NOSE.gap / 2, x: (length / 2 + station.x + STOPPER_NOSE.gap / 2) / 2 },
  ] : [{ length, x: 0 }]
  return <group name="assembly-conveyor-v1">
    {segments.map((s, i) => <group key={i} position={[s.x, 0, 0]} name={station ? 'conveyor-stop-station-loop' : undefined}>
      <BeltLoop device={device} plant={plant} length={s.length} width={width} travelLength={length} nose={station ? (i === 0 ? 'right' : 'left') : undefined} />
    </group>)}
    {station && <group name="conveyor-stopper-clearance" position={[station.x, 0, 0]}>
      {[-1, 1].map(s => <group key={s}>
        <RoundPart name="conveyor-inner-drum" position={[s * .055, .08, 0]} radius={.015} length={width + .012} />
        <RoundPart name="conveyor-inner-drum-shaft" position={[s * .055, .08, 0]} radius={.007} length={width + .19} />
        {[-1, 1].map(z => <Part key={z} name="conveyor-nose-bearing" size={[.035, .06, .026]}
          position={[s * .055, .065, z * (width / 2 + .088)]} color={FINISH.dark} radius={.008} />)}
      </group>)}
    </group>}
    {[-1, 1].map(side => <group key={side}>
      <Part name="conveyor-side-rail" size={[length, .14, .06]} position={[0, -.02, side * (width / 2 + .045)]} radius={.006} />
      <Part name="conveyor-rail-channel" size={[length * .82, .013, .006]}
        position={[0, -.025, side * (width / 2 + .078)]} color={FINISH.dark} radius={.001} />
      {[-1, 1].map(end => <group key={end}>
        <Part name="conveyor-bearing-housing" size={[.11, .09, .026]}
          position={[end * g.halfStraight, g.centerY, side * (width / 2 + .088)]} radius={.02} color={FINISH.dark} />
        <RoundPart name="conveyor-bearing-cover" position={[end * g.halfStraight, g.centerY, side * (width / 2 + .107)]}
          radius={.031} length={.012} />
        <RoundPart name="conveyor-tension-screw" position={[end * (g.halfStraight - .08), -.04, side * (width / 2 + .045)]}
          radius={.007} length={.06} axis="x" />
        <group position={[end * g.halfStraight, g.centerY, side * (width / 2 + .116)]} rotation={[0, side < 0 ? Math.PI : 0, 0]}>
          <SocketBolt position={[0, 0, 0]} radius={.011} />
        </group>
      </group>)}
    </group>)}
    {[-1, 1].map(end => <group key={end}>
      <RoundPart name="conveyor-end-drum" position={[end * g.halfStraight, g.centerY, 0]}
        radius={g.radius - g.thickness - .002} length={width + .012} />
      <RoundPart name="conveyor-roller-shaft" position={[end * g.halfStraight, g.centerY, 0]}
        radius={.018} length={width + .19} />
    </group>)}
    <Part name="conveyor-reduction-gearbox" size={[.13, .13, .07]}
      position={[-g.halfStraight, g.centerY, -width / 2 - .14]} color={FINISH.steel} radius={.018} />
    <RoundPart name="conveyor-drive-motor" position={[-g.halfStraight, g.centerY, -width / 2 - .255]}
      radius={.055} length={.16} color={FINISH.dark} />
    <RoundPart name="conveyor-fan-cover" position={[-g.halfStraight, g.centerY, -width / 2 - .345]}
      radius={.058} length={.02} color={FINISH.dark} />
    {!carriedByLift && [-1, 1].map(end => <group key={end}>
      <Part name="conveyor-leg-crossmember" size={[.055, .06, width + .02]}
        position={[end * (length / 2 - .25), -device.pos[1] * .6, 0]} color={FINISH.steel} />
      {[-1, 1].map(side => <group key={side} position={[end * (length / 2 - .25), 0, side * (width / 2 + .045)]}>
        <mesh name="conveyor-support-leg" position={[0, -.09 - legHeight / 2, 0]} castShadow>
          <SlottedProfileGeometry edge={.07} length={legHeight} />
          <meshStandardMaterial color={TABLE_FINISH.leg} roughness={TABLE_FINISH.roughness} metalness={TABLE_FINISH.metalness} envMapIntensity={TABLE_FINISH.envMapIntensity} />
        </mesh>
        <RoundPart name="conveyor-leveling-foot" position={[0, -device.pos[1] + .016, 0]}
          radius={.055} length={.032} axis="y" color={FINISH.dark} />
        <RoundPart name="conveyor-foot-thread" position={[0, -device.pos[1] + .036, 0]}
          radius={.014} length={.008} axis="y" />
      </group>)}
    </group>)}
  </group>
}
