import { useFrame } from '@react-three/fiber'
import { useRef } from 'react'
import type { Group } from 'three'
import type { DeviceProps } from '../devices'
import { SocketBolt } from '../IndustrialDetails'
import { gripperAssemblyGeometry } from './geometry'
import { FINISH, Part, RoundPart } from './Parts'
import { GRIPPER_FINISH } from './gripperFinish'

/** Parallel pneumatic gripper. Guide cassette, sliders, fingers and inserts are separate parts. */
export function GripperAssembly({ device, plant }: DeviceProps) {
  const left = useRef<Group>(null), right = useRef<Group>(null)
  const wide = device.visualVariant === 'wide-stroke'
  const shape = gripperAssemblyGeometry(wide, 0)
  // Match the Material actuator housing; long stroke is carried by separate guide wings.
  const housingWidth = gripperAssemblyGeometry(false, 0).bodyWidth
  // Material nests need positive clearance below the finger, including their fasteners.
  // Keep the upper slider joint and lateral workpiece contact faces unchanged.
  const raisedNest = plant.machine.devices.some(d => d.visualVariant === 'hard-locator-surround')
  const toeRelief = plant.machine.replaySuite === 'material' ? (raisedNest ? .035 : .010) : 0
  const fingerHeight = .2 - toeRelief, fingerY = -.16 + toeRelief / 2
  useFrame(() => {
    const next = gripperAssemblyGeometry(wide, plant.state(device.id).pos)
    if (left.current) left.current.position.x = -next.jawCenter
    if (right.current) right.current.position.x = next.jawCenter
  })
  return <group name="assembly-gripper-v1">
    <group name="gripper-fixed-housing">
      {wide&&[-1,1].map(side=><group key={side} name="gripper-extended-guide-cassette">
        <Part name="gripper-guide-wing" size={[(shape.guideWidth-housingWidth)/2,.035,.126]}
          position={[side*(shape.guideWidth+housingWidth)/4,-.0075,-.007]} color={FINISH.alloy}/>
        <Part name="gripper-guide-wing-cover" size={[(shape.guideWidth-housingWidth)/2,.009,.14]}
          position={[side*(shape.guideWidth+housingWidth)/4,.0145,0]} color={FINISH.steel}/>
        {[-1,1].map(z=><SocketBolt key={z} top position={[side*(shape.guideWidth/2-.035),.020,z*.042]} radius={.004}/>)}
      </group>)}
      {/* Partition at y=.068: the lid must not be embedded with its top coplanar to the housing. */}
      <Part name="gripper-actuator-body" size={[housingWidth, .093, .126]} position={[0, .0215, -.007]} radius={.009} color={GRIPPER_FINISH.housing} />
      {/* Front plane is still z=.070, supporting the existing slot sensors at z=.077. */}
      <Part name="gripper-sensor-face" size={[housingWidth, .118, .014]} position={[0, .009, .063]} radius={.003} color={GRIPPER_FINISH.housing} />
      <Part name="gripper-top-cover" size={[housingWidth, .012, .14]} position={[0, .074, 0]} color={FINISH.steel} radius={.002} />
      {[-1, 1].map(side => <group key={side}>
        <Part name="gripper-guide-rail" size={[shape.guideWidth - .044, .033, .018]} position={[0, -.0465, side * .064]} color={FINISH.dark} />
        <Part name="gripper-guide-endcap" size={[.022, .041, .146]} position={[side * (shape.guideWidth / 2 - .011), -.041, 0]} color={FINISH.steel} />
        <SocketBolt position={[side * (housingWidth / 2 - .016), .055, .0718]} radius={.006} />
      </group>)}
      {[-1,1].flatMap(x=>[-1,1].map(z=><SocketBolt key={`lid-${x}-${z}`} top position={[x*(housingWidth/2-.025),.0818,z*.044]} radius={.006}/>))}
      {/* Pneumatic inlet; the real lid joint replaces the old overlaid decorative seam. */}
      <RoundPart name="gripper-air-fitting" position={[0, .034, -.077]} radius={.012} length={.016} segments={6} />
      <RoundPart position={[0, .034, -.09]} radius={.008} length={.01} color={FINISH.seal} />
    </group>
    {([-1, 1] as const).map(side => <group name={`gripper-moving-jaw-${side}`} key={side}
      ref={side < 0 ? left : right} position={[side * shape.jawCenter, 0, 0]}>
      <Part name="gripper-slider" size={[wide ? .086 : .066, .027, .108]} position={[0, -.0465, 0]} color={FINISH.steel} />
      <Part name="gripper-finger-back" size={[shape.fingerWidth - shape.padWidth, fingerHeight, .1]}
        position={[side * shape.padWidth / 2, fingerY, 0]} color={GRIPPER_FINISH.finger} radius={.003} />
      {/* Flat inner insert retains the original +/-X contact faces exactly. */}
      <Part name={`gripper-contact-insert-${side}`} size={[shape.padWidth, fingerHeight, .1]}
        position={[-side * (shape.fingerWidth - shape.padWidth) / 2, fingerY, 0]} color={GRIPPER_FINISH.contact} radius={.0003} />
      <SocketBolt position={[0, -.092, .0518]} radius={.006} />
      <SocketBolt position={[0, -.145, .0518]} radius={.006} />
    </group>)}
  </group>
}
