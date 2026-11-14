import {FittedMaterialDrive} from './FittedMaterialDrive'
import { useFrame } from '@react-three/fiber'
import { useRef } from 'react'
import type { Group } from 'three'
import type { DeviceProps } from '../devices'
import { SocketBolt } from '../IndustrialDetails'
import { servoAssemblyGeometry, servoPosition } from './geometry'
import { FINISH, Part, RoundPart } from './Parts'
import {useMotionRealism} from './MotionRealism'
import {useMotionPresentation} from './MotionPresentation'

/** Generic covered linear module. Decorative drive parts do not introduce new plant state. */
export function ServoAssembly({ device, plant, staticOnly = false, carriageOnly = false, driveOffsetZ = 0 }: DeviceProps & {staticOnly?:boolean;carriageOnly?:boolean;driveOffsetZ?:number}) {
  const presentation=useMotionPresentation(),realism=useMotionRealism()
  const refined=presentation||realism
  const carriage = useRef<Group>(null)
  const [length, height, width] = device.size
  const g = servoAssemblyGeometry(length, height, width)
  const orientation: [number, number, number] = device.motionAxis === 'y' ? [0, 0, Math.PI / 2]
    : device.motionAxis === 'z' ? [0, -Math.PI / 2, 0] : [0, 0, 0]
  useFrame(() => {
    if (carriage.current) carriage.current.position.x = servoPosition(length, plant.state(device.id).pos)
  })
  const deckHeight = .036
  const deckBottom = g.carriageTop - deckHeight
  const bearingBottom = g.railY - g.railHeight / 2 + .004
  const bearingHeight = deckBottom - .018 - bearingBottom
  const railTop = g.railY + g.railHeight / 2
  const screwCount = Math.max(3, Math.ceil(length / .3))
  return <group name="assembly-servo-v1" rotation={orientation} userData={{equipmentUnit:true,equipmentGroup:`axis:${device.id}`,deviceDisplayName:`Servo axis ${device.id}`}}>
    {!carriageOnly && <group name="servo-fixed-bed">
      <Part name="servo-bed" size={[length - .15, g.baseHeight, width]} radius={.009} />
      <Part name="servo-drive-cover" size={[length * .93, .018, width * .23]}
        position={[0, g.baseHeight / 2 + .009, 0]} color={FINISH.dark} />
      {[-1, 1].map(side => <group key={side}>
        <Part name="servo-side-channel" size={[length * .91, g.baseHeight * .35, .009]}
          position={[0, 0, side * (width / 2 + .002)]} color={FINISH.dark} radius={.002} />
        <Part name="servo-rail-seat" size={[length * .96, Math.max(.01, g.railY - g.railHeight / 2 - g.baseHeight / 2), g.railWidth * 1.3]}
          position={[0, (g.baseHeight / 2 + g.railY - g.railHeight / 2) / 2, side * width * .28]} />
        <Part name="servo-linear-rail" size={[length * .96, g.railHeight, g.railWidth]}
          position={[0, g.railY, side * width * .28]} color={FINISH.steel} radius={.002} />
        {Array.from({ length: screwCount }, (_, i) => <SocketBolt key={i}
          position={[(i / (screwCount - 1) - .5) * length * .86, railTop + .001, side * width * .28]} radius={.003} top />)}
        {/* End covers stay below the carriage sweep, including at the two end positions. */}
        <Part name="servo-end-cover" size={[.075, g.baseHeight, width]}
          position={[side * (length / 2 - .0375), 0, 0]} color={FINISH.steel} />
      </group>)}
      {/* Side-mounted drive package leaves the carriage sweep and front sensor face clear. */}
      <Part name="servo-drive-bracket" size={[.24, .01, .1 + Math.abs(driveOffsetZ)]}
        position={[-length / 2 + .13, -.0275, -width / 2 - .025 + driveOffsetZ / 2]} color={FINISH.steel} />
      <group position={[0,0,driveOffsetZ]}>
      {realism?<FittedMaterialDrive position={[-length/2+.11,.025,-width/2-.073]} size={[.20,.095,.105]} axis="x"/>:<>
      <Part name="servo-motor-housing" size={[.18, .095, .105]}
        position={[-length / 2 + .12, .025, -width / 2 - .073]} color={FINISH.dark} radius={.015} />
      <RoundPart name="servo-motor-endcap" position={[-length / 2 + .02, .025, -width / 2 - .073]}
        radius={.042} length={.02} axis="x" />
      </>}
      <Part name="servo-drive-transmission-cover" size={[.065, .0975, .18]}
        position={[-length / 2 + .2425, .02625, -width / 2 - .033]} color={FINISH.steel} radius={.015} />
      {!realism&&<RoundPart name="servo-cable-connector" position={[-length / 2 + .1, .081, -width / 2 - .073]}
        radius={.011} length={.018} axis="y" color={FINISH.seal} />}
      </group>
    </group>}
    {!staticOnly && <group name="servo-moving-carriage" ref={carriage} position={[servoPosition(length, 0), g.carriageY, 0]}>
      {/* U-shaped bearings straddle each rail; unlike a solid block they leave the rail channel open. */}
      {[-1, 1].map(side => <group key={side} name="servo-bearing-block">
        {[-1, 1].map(edge => <Part key={edge} name="servo-bearing-cheek" size={[.26, bearingHeight, .022]}
          position={[0, bearingBottom + bearingHeight / 2 - g.carriageY, side * width * .28 + edge * (g.railWidth / 2 + .014)]}
          color={FINISH.steel} radius={.003} />)}
        <Part name="servo-bearing-bridge" size={[.26, .018, g.railWidth + .052]}
          position={[0, deckBottom - .009 - g.carriageY, side * width * .28]} color={FINISH.steel} />
        {[-1, 1].flatMap(end => [-1, 1].map(edge => <Part key={`${end}:${edge}`} name="servo-bearing-wiper"
          size={[.009, bearingHeight, .022]} position={[end * .1345, bearingBottom + bearingHeight / 2 - g.carriageY,
            side * width * .28 + edge * (g.railWidth / 2 + .014)]} color={FINISH.seal} radius={.001} />))}
      </group>)}
      <Part name="servo-carriage-deck" size={[.30, deckHeight, width * .92]}
        position={[0, g.carriageTop - deckHeight / 2 - g.carriageY, 0]} radius={.007} />
      <Part name="servo-tooling-plate" size={[.22, .06, width * .72]}
        position={[0, g.toolingY - g.carriageY, 0]} color={FINISH.blue} radius={.004} />
      {refined&&[-1,1].map(s=><Part key={s} name="saddle-machined-recess" size={[.16,.012,.002]} position={[0,g.toolingY-g.carriageY,s*(width*.36+.0015)]} color={FINISH.dark} radius={.001}/>)}
      {[-1, 1].flatMap(x => [-1, 1].map(z => <SocketBolt key={`${x}:${z}`}
        position={[x * .075, g.toolingY - g.carriageY + .031, z * width * .24]} radius={.007} top />))}
    </group>}
  </group>
}
