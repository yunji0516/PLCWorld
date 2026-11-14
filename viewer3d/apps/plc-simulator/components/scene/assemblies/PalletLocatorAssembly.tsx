import { useRef } from 'react'
import { useFrame } from '@react-three/fiber'
import type { Group, Mesh } from 'three'
import type { DeviceProps } from '../devices'
import { BoredPlate, FINISH, Part, RoundPart } from './Parts'
import { SocketBolt } from '../IndustrialDetails'

// Same datums as material_m08_locate.py. Opt-in M08 only; no legacy geometry changes.
export const LOCATE_GEOMETRY = {
  rootY: .35, homeTop: .575, stroke: .06, plateThickness: .03,
  beltTop: .6, palletThickness: .05, pinRadius: .008, boreRadius: .010,
  pinHeight: .015, pins: [[-.11, -.07], [.11, .07]] as [number, number][],
}

export function PalletLocatorAssembly({ plant, device }: DeviceProps) {
  const plate = useRef<Group>(null)
  const rods = useRef<Group>(null)
  const g = LOCATE_GEOMETRY
  useFrame(() => {
    const rise = Math.max(0, Math.min(1, plant.state(device.id).pos)) * g.stroke
    if (plate.current) plate.current.position.y = g.homeTop - g.rootY - g.plateThickness / 2 + rise
    if (rods.current) rods.current.scale.y = 1 + rise / .065
  })
  return <group name="assembly-pallet-locator">
    <Part name="locator-base" size={[.36,.02,.26]} position={[0,-.01,0]} color={FINISH.dark} />
    <Part name="locator-pneumatic-body" size={[.10,.13,.10]} position={[0,.065,0]} radius={.015} />
    <RoundPart name="locator-gland" position={[0,.14,0]} radius={.038} length={.02} axis="y" />
    {/* Rod bottoms remain at the fixed glands; tops follow the moving plate. */}
    <group ref={rods} position={[0,.13,0]}>
      <RoundPart name="locator-drive-rod" position={[0,.0325,0]} radius={.018} length={.065} axis="y" />
      {[-1,1].flatMap(x=>[-1,1].map(z=><RoundPart key={`${x}:${z}`} name="locator-guide-rod"
        position={[x*.135,.0325,z*.085]} radius={.010} length={.065} axis="y" />))}
    </group>
    {[-1,1].flatMap(x=>[-1,1].map(z=><group key={`${x}:${z}`}>
      <RoundPart name="locator-guide-body" position={[x*.135,.065,z*.085]} radius={.019} length={.13} axis="y" />
      <RoundPart name="locator-guide-bushing" position={[x*.135,.125,z*.085]} radius={.022} length={.01} axis="y" color={FINISH.dark} />
      <SocketBolt top position={[x*.155,.003,z*.105]} radius={.005} />
    </group>))}
    <group ref={plate} name="locator-moving-plate" position={[0,.21,0]}>
      <Part name="locator-support-face" size={[.34,.03,.24]} radius={.004} />
      {g.pins.map(([x,z],i)=><RoundPart key={i} name="locator-pin" position={[x,.0225,z]}
        radius={g.pinRadius} length={g.pinHeight} axis="y" color={FINISH.dark} />)}
    </group>
    <RoundPart name="locator-air-fitting" position={[0,.035,-.062]} radius={.010} length={.025} segments={6} />
  </group>
}

export function LocatorPalletAssembly() {
  const g = LOCATE_GEOMETRY
  return <group name="assembly-locator-pallet">
    <group rotation={[-Math.PI/2,0,0]}>
      <BoredPlate name="pallet-bored-plate" size={[.4,.64,.05]} position={[0,0,0]} corner={.008}
        holes={g.pins.map(([x,z])=>({x,y:-z,radius:g.boreRadius}))} />
    </group>
    {/* A shallow passive nest secures the .16 workpiece; no hidden clamp sensor. */}
    {[-1,1].map(s=><group key={s}>
      <Part name="pallet-nest-x" size={[.018,.025,.20]} position={[s*.089,.0375,0]} color={FINISH.dark} radius={.002} />
      <Part name="pallet-nest-z" size={[.16,.025,.018]} position={[0,.0375,s*.089]} color={FINISH.dark} radius={.002} />
    </group>)}
    <Part name="pallet-proximity-flag" size={[.012,.016,.030]} position={[.19,0,.328]} color={FINISH.steel} radius={.002} />
  </group>
}

/** Trace-driven contact gauge; housing is fixed to the C-frame, not the pallet. */
export function ContactHeightGaugeAssembly({ plant, device }: DeviceProps) {
  const shaft=useRef<Mesh>(null),tip=useRef<Mesh>(null)
  useFrame(()=>{
    const tipY=1.02-.25*Math.max(0,Math.min(1,plant.state(device.id).pos))
    if(tip.current)tip.current.position.y=tipY+.006-device.pos[1]
    if(shaft.current){
      shaft.current.position.y=(1.06+tipY+.012)/2-device.pos[1]
      shaft.current.scale.y=1.06-tipY-.012
    }
  })
  return <group name="assembly-contact-height-gauge">
    <Part name="gauge-fixed-housing" size={[.12,.20,.12]} radius={.012}/>
    <Part name="gauge-front-panel" size={[.08,.10,.008]} position={[0,.02,.064]} color={FINISH.dark}/>
    <RoundPart name="gauge-cable-connector" radius={.012} length={.024} position={[.069,.045,0]} axis="x" segments={6}/>
    <mesh name="gauge-stylus-shaft" ref={shaft} castShadow>
      <cylinderGeometry args={[.004,.004,1,24]}/><meshStandardMaterial color="#9aa7ae" roughness={.6} metalness={.5}/>
    </mesh>
    <mesh name="gauge-contact-ball" ref={tip} castShadow>
      <sphereGeometry args={[.006,24,16]}/><meshStandardMaterial color="#b33138" roughness={.45} metalness={.1}/>
    </mesh>
  </group>
}
