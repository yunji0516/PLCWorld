'use client'
import { GRIPPER_FINISH } from './gripperFinish'
import {ServiceEnclosure} from './ServiceEnclosure'
import {MaterialTableLegs} from './MaterialTableLegs'
import { SuctionCup } from './SuctionCup'

import { useFrame } from '@react-three/fiber'
import { useRef } from 'react'
import type { Group } from 'three'
import type { DeviceProps } from '../devices'
import { Part, RoundPart, CornerWeb } from './Parts'
import { StandardBeltDeck } from './StandardBeltDeck'
import { SocketBolt } from '../IndustrialDetails'
import {useMaterialPresentation} from './MaterialPresentation'
import {useIndexEquipmentColor} from './IndexEquipmentPalette'
import { BoredHub, CabinetFace, CylinderBarrel, Drive, Hose, LabelPlate, Profile, SensorBracket } from './MaterialV6Details'

type V3 = [number, number, number]

function Box({ p, s, color = '#99aab7', name }: { p: V3; s: V3; color?: string; name?: string }) {
  return <Part name={name} position={p} size={s} color={color}/>
}

function Round({ p, r, h, color = '#6d899a' }: { p: V3; r: number; h: number; color?: string }) {
  const finish=useIndexEquipmentColor(color)
  return <mesh position={p} castShadow receiveShadow><cylinderGeometry args={[r, r, h, 32]} />
    <meshStandardMaterial color={finish} metalness={.65} roughness={.35} /></mesh>
}

function Stand({ x, z = 0, width = .52, depth = .5, color = '#497486', capLower = 0 }: { x: number; z?: number; width?: number; depth?: number; color?: string; capLower?: number }) {
  const top=.72-capLower
  return <group name="material-table-frame">
    <Part name="bench-top" position={[x,top-.035,z]} size={[width,.07,depth]} color="#a1a5a7"/>
    <MaterialTableLegs x={x} z={z} halfX={width/2-.06} halfZ={depth/2-.06} top={top-.07}/>
  </group>
}

/** Independent synthetic mechanisms. Moving groups consume the canonical
 * replay pose or actuator fraction; no elapsed render-time animation. */
export function MaterialV6Hardware({ device, plant }: DeviceProps) {
  const refined=useMaterialPresentation()
  const moving = useRef<Group>(null)
  const left = useRef<Group>(null)
  const right = useRef<Group>(null)
  const variant = device.visualVariant ?? ''
  const classification = plant.machine.devices.some(d => d.visualVariant === 'v6-classification-base')
  useFrame(() => {
    const fraction = plant.state(device.id).pos
    if ((variant === 'v6-z-slide' || variant === 'v6-datum-z-slide') && moving.current) {
      // D06 uses a low offset bracket below the rotary arm. Other lifts retain
      // their original tool mounting height and rod length.
      const length = (classification ? .705 : .58) - .55 * fraction
      moving.current.scale.y = length
      moving.current.position.y = -length / 2
    }
    if (variant === 'v6-sort-gripper') {
      const gap = .24 - .07 * fraction
      if (left.current) left.current.position.x = -gap
      if (right.current) right.current.position.x = gap
    }
    if (variant.startsWith('v6-align-') && moving.current) {
      const length = .015 + .12 * fraction
      if (variant === 'v6-align-x') {
        moving.current.scale.x = length
        moving.current.position.x = .0125 + length / 2
      } else {
        moving.current.scale.z = length
        moving.current.position.z = .0125 + length / 2
      }
    }
  })
  if (variant.endsWith('-base')) {
    const sort = variant === 'v6-classification-base'
    const datum = variant === 'v6-datum-base'
    return <group name={`synthetic-${variant}`} position={[0, -.85, 0]}>
      <group name="v6-mechanism-detail-layer">
        <SensorBracket kind={sort?'classification':datum?'datum':'orientation'}/>
        {sort?<>
          <Drive p={[0,1.20,-.15]} axis="z"/>
          <Hose points={[[0,1.25,-.15],[.13,1.10,-.17],[.12,.25,-.12],[.085,.22,-.065]]}/>
          {!refined&&<Box p={[0,.98,.083]} s={[.18,.075,.05]} color="#576f7e"/>}
          <LabelPlate text="ROTARY SORT" p={[0,.98,.109]} width={.17}/>
          {[-1,1].map(side=><group key={side}>
            <LabelPlate text={side<0?'ACCEPT':'REJECT'} p={[.92,.63,side*.60104+.245]} width={.35} color={side<0?'#397466':'#996c32'}/>
            {[-1,1].map(x=><SocketBolt key={x} top position={[.92+x*.43,.724,side*.60104+.21]} radius={.005}/>)}
          </group>)}
          <LabelPlate text="INSPECT" p={[-.85,.63,.21]} width={.27}/>
        </>:datum?<>
          <ServiceEnclosure x={.40} z={.36} top={.65}/>
          <Drive p={[-1.08,1.535,-.35]}/>
          {[-1,1].map(side=><CornerWeb key={side} position={[side*.92,.64,.36]} span={.15} side={-side}/>)}
          <Box p={[-.26,.76,.29]} s={[.12,.08,.10]} color="#526b79"/>
          <Hose color="#367ca1" points={[[-.36,.805,.025],[-.23,.85,.08],[-.23,.84,.23],[-.23,.80,.265]]}/>
          <Hose color="#367ca1" points={[[-.725,.805,.36],[-.60,.85,.39],[-.34,.84,.34],[-.29,.80,.315]]}/>
          <LabelPlate text="DATUM X / Z" p={[-.70,.65,.508]} width={.40}/>
          {Array.from({length:8},(_,i)=><Box key={i} p={[-.98+i*.035,.721,-.20]} s={[.002,.001,.020]} color="#52626d"/>)}
        </>:<>
          <Drive p={[-1.28,1.535,-.205]}/>
          {[-1,1].map(side=><group key={side}>
            <LabelPlate text={side<0?'PICKUP':'ORIENT / NEST'} p={[side*.75,.60,.254]} width={.40}/>
            {[-1,1].map(edge=><Box key={edge} p={[side*.75+edge*.24,.74,0]} s={[.018,.035,.45]} color="#546777"/>)}
          </group>)}
        </>}
      </group>
      {sort ? <>
        {refined?<group name="m04-anchored-drive-column">
          <Part name="m04-column-baseplate" position={[0,.035,0]} size={[.52,.07,.48]} color="#365867" radius={.006}/>
          <Part name="m04-rigid-column" position={[0,.700,0]} size={[.20,1.22,.20]} color="#7f8f9c" radius={.012}/>
          <Part name="m04-column-service-cover" position={[0,.53,.105]} size={[.14,.40,.010]} color="#35434e" radius={.004}/>
          {[-1,1].flatMap(a=>[-1,1].map(b=><group key={`${a}:${b}`}>
            <SocketBolt top position={[a*.21,.071,b*.18]} radius={.009}/>
            <SocketBolt position={[a*.051,.53+b*.16,.112]} radius={.004}/>
          </group>))}
        </group>:<><Round p={[0, .045, 0]} r={.26} h={.09} color="#385768"/><Round p={[0, .71, 0]} r={.09} h={1.30}/></>}
        <Round p={[0, 1.405, 0]} r={.17} h={.16} color={refined?'#7f8f9c':'#197e86'} />
        {refined&&<group name="sort-robot-fixed-drive-detail">
          <RoundPart position={[0,.09,0]} radius={.225} length={.055} axis="y" color="#a3afb9"/>
          <RoundPart position={[0,1.31,0]} radius={.14} length={.035} axis="y" color="#35434e"/>
          {Array.from({length:6},(_,i)=><SocketBolt key={i} top position={[.21*Math.cos(i*Math.PI/3),.119,.21*Math.sin(i*Math.PI/3)]} radius={.007}/>)}
        </group>}
        <Stand x={-.85} z={-.22} depth={.85} width={.49} capLower={.075} />
        <group position={[-.85,0,-.25]} rotation={[0,-Math.PI/2,0]}><StandardBeltDeck length={.83} width={.37} top={.720} plant={plant} drive/></group>
        {refined&&<group name="m04-source-retroreflector">
          {/* SOURCE_SENSOR optical axis: +X at Y=.735, Z=0.
              The .54 m ray ends at X=-.600; front face meets that endpoint.
              All supports stay outside the workpiece footprint. */}
          <Part name="m04-reflector-foot" position={[-.6375,.658,0]} size={[.145,.026,.10]} color="#a3afb9"/>
          <Part name="m04-reflector-upright" position={[-.575,.7205,0]} size={[.028,.099,.026]} color="#a3afb9"/>
          <Part name="m04-reflector-frame" position={[-.589,.735,0]} size={[.018,.078,.066]} color="#35434e"/>
          <Part name="m04-reflector-face" position={[-.599,.735,0]} size={[.002,.056,.046]} color="#e4e5df" radius={.0005}/>
          {[-1,1].map(s=><SocketBolt key={s} top position={[-.68,.672,s*.033]} radius={.0035}/>)}
        </group>}
        <Box p={[-1.10, .795, -.28]} s={[.05, .25, .05]} color="#c5d4dc" />
        <Box p={[-1.02, .94, -.28]} s={[.16, .04, .05]} />
        <Box p={[-.90, .93, -.28]} s={[.08, .08, .08]} color="#203c49" />
        {[-1, 1].map(side => <group key={side}>
          <Stand x={.92} z={side * .60104} width={1.10} depth={.48} capLower={.075} color={side < 0 ? '#397c73' : '#a27c46'} />
          <group position={[.92,0,side*.60104]}><StandardBeltDeck length={1.08} width={.43} top={.720} plant={plant} drive/></group>
          {[-1,1].map(edge => <Box key={edge} name="d06-receiver-guide" p={[.92, .729, side * .60104 + edge * .24]} s={[1.10, .018, .025]} />)}
        </group>)}
      </> : <>
        {datum ? <>
          <Box name="bench-top" p={[0,.685,.075]} s={[2.15,.07,.86]}/>
          <MaterialTableLegs z={.075} halfX={.94} halfZ={.34} top={.65}/>
          <Box p={[0, .76, -.42]} s={[.20, 1.44, .12]} color="#6d899a" />
          <Box p={[0,.035,-.42]} s={[.36,.07,.30]} color="#3f5664" />
          <Box name="v6-fixed-travel-beam" p={[0, 1.535, -.35]} s={[2.0, .12, .18]} />
          <Box p={[0, 1.535, -.2475]} s={[1.96, .035, .025]} color="#2c515f" />
        </> : <>
        <Stand x={-.75} />
        <Stand x={.75} depth={.50} width={.52} color="#728fa2" />
        {[-1,1].map(side => <group key={side}>
          <Profile p={[side*1.20,.775,-.205]} length={1.49} edge={.085}/>
          <Box p={[side * 1.20, .03, -.205]} s={[.24, .06, .30]} color="#3f5664" />
        </group>)}
        <Box name="v6-fixed-travel-beam" p={[0, 1.535, -.205]} s={[2.49, .12, .16]} />
        <Box p={[0, 1.535, -.11]} s={[2.2, .035, .03]} color="#2c515f" />
        </>}
        {datum && <>
          <Box p={[-.9175, .751, .045]} s={[.035, .062, .34]} color="#c2d4dd" />
          <Box p={[-.72, .751, -.1075]} s={[.36, .062, .035]} color="#c2d4dd" />
          <Box p={[-.36, .765, 0]} s={[.16, .08, .095]} color="#197e86" />
          <Box p={[-.75, .765, .33]} s={[.095, .08, .16]} color="#197e86" />
          <Box p={[.755, .723, -.105]} s={[.33, .006, .01]} color="#eac474" />
          <Box p={[.585, .723, 0]} s={[.01, .006, .23]} color="#eac474" />
        </>}
      </>}
    </group>
  }
  if (variant === 'v6-swing-arm') return <group name="material-v6-swing-link">
    <Part name="v6-rotary-arm-spine" position={[.3725, -.095, 0]} size={[.875, .10, refined?.16:.12]} radius={refined?.012:undefined}/>
    <Round p={[0, 0, 0]} r={.13} h={.13} color={refined?'#35434e':'#197e86'} />
    <BoredHub p={[.85,-.085,0]} outer={.10} inner={.028} height={.10}/>
    <BoredHub p={[.85,-.025,0]} outer={.045} inner={.023} height={.020}/>
    <Part name="sort-arm-service-cover" position={[.42,-.039,0]} size={[.58,.012,.08]} radius={.006} color="#35434e"/>
    {refined&&<group name="sort-robot-joint-detail">
      {[-1,1].map(s=><group key={`link-cover-${s}`}>
        <Part name="m04-link-side-recess" position={[.42,-.095,s*.0805]} size={[.52,.028,.002]} color="#7f8f9c" radius={.003}/>
        {[.20,.64].map(x=><group key={x} position={[x,-.095,s*.083]} rotation={[0,s<0?Math.PI:0,0]}><SocketBolt radius={.004} position={[0,0,0]}/></group>)}
      </group>)}
      <RoundPart name="sort-joint-reducer-cap" position={[0,.074,0]} radius={.108} length={.018} axis="y" color="#a3afb9"/>
      <RoundPart name="sort-joint-drive-cover" position={[0,.087,0]} radius={.07} length={.008} axis="y" color="#35434e"/>
      {Array.from({length:6},(_,i)=><SocketBolt key={i} top position={[.087*Math.cos(i*Math.PI/3),.084,.087*Math.sin(i*Math.PI/3)]} radius={.004}/>)}
      {[-1,1].map(s=><SocketBolt key={s} top position={[.42+s*.24,-.032,0]} radius={.004}/>)}
      {[-1,1].map(s=><SocketBolt key={`wrist-${s}`} top position={[.85,-.033,s*.070]} radius={.004}/>)}
    </group>}
    <RoundPart name="v6-swing-service-port" position={[.85,-.085,.105]} radius={.008} length={.01} axis="z"/>
    <Hose points={[[0,.065,.04],[.15,.01,.18],[.74,-.005,.18],[.85,-.085,.11]]}/>
    <SocketBolt top position={[0,.067,0]} radius={.012}/>
  </group>
  if ((variant === 'v6-z-slide' || variant === 'v6-datum-z-slide')) return <group name="material-v6-z-slide">
    <CylinderBarrel stroke={.55} backService={variant==='v6-datum-z-slide'}/>
    {variant === 'v6-datum-z-slide' && <Box p={[0, .025, -.135]} s={[.14, .08, .13]} />}
    <Box name="v6-lift-carriage-body" p={[0, .025, 0]} s={[.14, .08, .14]} color="#197e86" />
    {!classification && <Box p={[0,.055,variant==='v6-datum-z-slide'?-.2175:-.0775]} s={[.24,.09,.035]} color="#475e6c"/>}
    {[-1,1].map(side=><SocketBolt key={side} top position={[side*.05,.067,0]} radius={.005}/>)}
    <group ref={moving} name="v6-lift-piston"><RoundPart position={[0,0,0]} radius={.017} length={1} axis="y" color="#c9d4dd"/></group>
  </group>
  if (variant === 'v6-pocket-key') return <group name="material-v6-request-key">
    <Box p={[.185, .006, 0]} s={[.025, .008, .24]} color="#eac474" />
    <Box p={[.135, .006, -.14]} s={[.125, .008, .02]} color="#eac474" />
  </group>
  if (variant === 'v6-align-x' || variant === 'v6-align-z') return <group name="material-v6-datum-pusher">
    <Box p={[0, 0, 0]} s={variant.endsWith('-x') ? [.025, .06, .23] : [.33, .06, .025]} color="#cfdae0" />
    <group ref={moving}><Box p={[0, 0, 0]} s={variant.endsWith('-x') ? [1, .023, .023] : [.023, .023, 1]} color="#d9e2e8" /></group>
  </group>
  if (variant === 'v6-sort-gripper') return <group name="material-v6-sort-gripper">
    {/* Keep the workpiece contact pads on their canonical poses. The housing
        sits beside the lift, on a bracket that clears the arm at full lift. */}
    <Box name="d06-piston-mount" p={[0,.015,.095]} s={[.08,.02,.26]} color="#8098a8"/>
    <Box name="d06-housing-support" p={[0,.0525,.19]} s={[.075,.055,.075]}/>
    <Hose color="#4889a5" points={[[.09,.15,.24],[.12,.23,.28],[0,.25,.28],[0,.16,.24]]} radius={.004}/>
    <Box p={[0, .095, .19]} s={[.66, .045, .09]} color="#aebec9" name="material-v6-jaw-guide" />
    <Box name="d06-gripper-housing" p={[0, .13, .19]} s={[.28, .10, .10]} color={GRIPPER_FINISH.housing} />
    <Box p={[0, .19, .19]} s={[.07, .02, .07]} />
    {[-1,1].map(side=><group key={side} ref={side<0?left:right} name={side<0?'material-v6-left-jaw':'material-v6-right-jaw'}>
      <Box name="d06-jaw-back" p={[side*.035,.045,.19]} s={[.065,.11,.07]} color={GRIPPER_FINISH.finger}/>
      <Box name="d06-jaw-offset-link" p={[side*.035,.002,.095]} s={[.055,.020,.252]} color={GRIPPER_FINISH.finger}/>
      <Box name="d06-contact-pad" p={[0,-.015,0]} s={[.04,.028,.10]} color={GRIPPER_FINISH.contact}/>
    </group>)}
  </group>
  return <group name="material-v6-vacuum-head">
    <Hose color="#4486a1" points={[[.025,.165,.037],[.05,.195,.07],[.075,.14,.06],[.075,.0975,.04]]} radius={.004}/>
    {[-1,1].map(side=><SocketBolt key={side} top position={[side*.07,.102,-.036]} radius={.004}/>)}
    <Round p={[0, .14, 0]} r={.045} h={.08} color="#197e86" />
    <Box p={[0, .075, 0]} s={[.23, .045, .13]} />
    {[-1,1].map(side => <group key={side}>
      <Round p={[side * .08, .040, 0]} r={.012} h={.04} />
      <SuctionCup position={[side * .08, .012, 0]} radius={.027} height={.024}/>
    </group>)}
    <Box p={[.078, .101, 0]} s={[.047, .008, .11]} color="#eac474" />
  </group>
}
