'use client'
import { ArticulatedLink, RobotPedestal, JointCap, RotaryIndexBase, TelescopicPedestal, TubeCollar, BoltCircle, BoomEndEye } from './MotionEasyRefined'
import {FittedMaterialDrive} from './FittedMaterialDrive'

import { useEffect, useMemo, useRef, type ReactNode } from 'react'
import { useFrame } from '@react-three/fiber'
import { DoubleSide, ExtrudeGeometry, Path, Shape, type Group, type Mesh } from 'three'
import type { DeviceProps } from '../devices'
import type { MotionMechanism } from '@/lib/replay/adapter'
import { FINISH, Part, RoundPart } from './Parts'
import { counterbalanceLayout } from './counterbalanceLayout'
import {useMotionProcessDetail} from './MotionPresentation'
import {RotaryDriveDetails,RotaryFaceDetails,BalanceDriveDetails,Flange} from './MotionProcessDetails'
import {SocketBolt} from '../IndustrialDetails'

type Reader = { motionMechanism(): MotionMechanism | undefined; motionEasyMode?(): string | undefined; motionHardInstance?(): boolean }
type Vector = [number, number, number]


/** Recorded local transforms, including rewind. No renderer-side motion controller. */
function Moving({ reader, mode, node, children }: { reader: Reader; mode: string; node: string; children: ReactNode }) {
  const group = useRef<Group>(null)
  useFrame(() => {
    const p = reader.motionMechanism()?.poses[node], g = group.current
    if (!p || !g) return
    g.position.fromArray(p.pos); g.quaternion.fromArray(p.quaternion)
    g.scale.fromArray(p.scale ?? [1, 1, 1])
  })
  const names:Record<string,string>=mode==='telescopic'
    ? {boom:'Boom base stage',middle:'Boom middle stage',inner:'Boom inner stage',tip:'Boom end eye'}
    : mode==='mobile'?{body:'Mobile robot',wheel_l:'Left traction wheel',wheel_r:'Right traction wheel'}:{}
  const articulated:Record<string,string>={upper:'shoulder',forearm:'elbow',elbow:'elbow',wrist:'wrist',tool:'wrist',tool_stem:'wrist',receiver:'receiver',receiver_base:'receiver',receiver_rod:'receiver'}
  const unit=mode==='articulated'?(articulated[node]??node):mode==='table_slide'&&['cantilever','tongue'].includes(node)?'slide':node
  const labels:Record<string,string>={shoulder:'Shoulder axis',elbow:'Elbow axis',wrist:'Wrist/tool axis',receiver:'Receiver slide',slide:'Transfer slide',pin:'Locking pin'}
  const inherited=mode==='telescopic'||(['index_pin','table_slide'].includes(mode)&&node==='table')
  return <group ref={group} name={`motion-v08-${mode}-${node}`} userData={inherited?undefined:{equipmentUnit:true,equipmentGroup:`mechanism:${unit}`,deviceDisplayName:names[node]??labels[unit]??unit.replace(/_/g,' ')}}>{children}</group>
}
function Foot({ width = 1.2, depth = .9 }: { width?: number; depth?: number }) {
  return <group name="foundation">
    <Part name="anchor-plate" position={[0, .045, 0]} size={[width, .09, depth]} color={FINISH.dark} radius={.015} />
  </group>
}
function Bar({ color = FINISH.blue }: { color?: string }) {
  const detail=useMotionProcessDetail()
  return <group><Part name="rigid-link" size={[1, 1, 1]} radius={.025} color={color} />
    {detail&&[-1,1].map(s=><Part key={s} name="link-side-recess" position={[0,0,s*.503]} size={[.44,.78,.006]} radius={.005} color={FINISH.steel}/>)}
  </group>
}
function Sleeve({ length, width, height, position = [0, 0, 0], color = FINISH.blue }: { length: number; width: number; height: number; position?: Vector; color?: string }) {
  const t = .014
  return <group position={position} name="telescoping-sleeve">
    {[-1,1].map(k=><group key={k}>
      <Part position={[0,k*(height-t)/2,0]} size={[length,t,width]} color={color} radius={.002} />
      <Part position={[0,0,k*(width-t)/2]} size={[length,height-2*t,t]} color={color} radius={.002} />
    </group>)}
  </group>
}
function IndexPlate() {
  const geometry = useMemo(() => {
    const s = new Shape(); s.absarc(0,0,.62,0,Math.PI*2,false)
    for(let k=0;k<4;k++){const h=new Path();h.absarc(.48*Math.cos(k*Math.PI/2),.48*Math.sin(k*Math.PI/2),.024,0,Math.PI*2,true);s.holes.push(h)}
    const g=new ExtrudeGeometry(s,{depth:.065,bevelEnabled:false,curveSegments:64});g.translate(0,0,-.0325);return g
  },[])
  useEffect(()=>()=>geometry.dispose(),[geometry])
  return <group>
    <mesh name="index-plate-with-four-through-holes" rotation={[-Math.PI/2,0,0]} castShadow receiveShadow>
      <primitive object={geometry} attach="geometry" />
      <meshStandardMaterial color="#8998a5" side={DoubleSide} transparent={false} opacity={1} depthWrite metalness={.3} roughness={.72}/>
    </mesh>
    <Part name="radial-index-key" position={[.23,.039,0]} size={[.25,.01,.025]} color="#d7a33f"/>
  </group>
}
function Strut({ reader, node }: { reader: Reader; node: string }) {
  const barrel=useRef<Mesh>(null),rod=useRef<Mesh>(null)
  useFrame(()=>{
    const l=reader.motionMechanism()?.poses[node]?.scale?.[1] ?? 1
    if(barrel.current){barrel.current.position.y=-.5+.175/l;barrel.current.scale.y=.35/l}
    if(rod.current){rod.current.position.y=.15/l;rod.current.scale.y=(l-.30)/l}
  })
  return <>
    <mesh ref={barrel} name="fixed-length-strut-barrel" castShadow><cylinderGeometry args={[.045/.065,.045/.065,1,16]}/><meshStandardMaterial color={FINISH.alloy} metalness={.6} roughness={.4}/></mesh>
    <mesh ref={rod} name="exposed-strut-rod" castShadow><cylinderGeometry args={[.022/.065,.022/.065,1,16]}/><meshStandardMaterial color={FINISH.alloy} metalness={.7} roughness={.3}/></mesh>
  </>
}

/** Open guide channels leave room for the scissor links and endpoint rollers. */
function ScissorTrack({ upper = false, z }: { upper?: boolean; z: number }) {
  return <group name={upper ? 'upper-open-roller-track' : 'lower-open-roller-track'}>
    <Part name="roller-track-web" position={[0,upper?.006:.1825,z]} size={[1.65,upper?.008:.015,.31]} color={FINISH.dark}/>
    {[-1,1].map(side=><Part key={side} name="roller-track-side" position={[0,upper?-.0315:.24,z+side*.145]} size={[1.65,upper?.067:.12,.02]} color={FINISH.dark}/>)}
  </group>
}

export function MotionDiverseHardware({ device, plant }: DeviceProps) {
  const processDetail=useMotionProcessDetail()
  const mode=device.visualVariant!.slice('motion-v08-'.length),reader=plant as unknown as Reader
  const hard = !!reader.motionHardInstance?.()
  const refinedEasy = true
  const easy = !!reader.motionEasyMode?.() || hard
  const boundary = reader.motionMechanism()?.boundary_revision === '0.9'
  const balance = counterbalanceLayout(reader)
  const contactRevision = (reader.motionMechanism()?.clearance_revision ?? 0) >= 8
  const M=useMemo(()=>function BoundMoving({ node, children }: {node: string; children: ReactNode}) { return <Moving reader={reader} mode={mode} node={node}>{children}</Moving> },[reader,mode])
  const pivot=(reader.motionMechanism()?.initial.pivot ?? 350)/1000
  let assembly: ReactNode
  switch(mode){
    case 'articulated': assembly=<>
      <Foot width={.8} depth={.8}/>{refinedEasy ? <RobotPedestal/> : <><RoundPart name="robot-pedestal" position={[0,.42,0]} radius={.2} length={.65} axis="y" color={FINISH.blue}/>
      <RoundPart name="shoulder-bearing" position={[0,.82,0]} radius={.16} length={.22} axis="y"/></>}
      {processDetail&&!refinedEasy&&<group name="robot-base-drive-details">
        <RoundPart name="shoulder-flange" position={[0,.697,0]} radius={.18} length={.026} axis="y"/>
        {Array.from({length:8},(_,i)=>{const a=i*Math.PI/4;return <SocketBolt key={i} position={[.15*Math.cos(a),.712,.15*Math.sin(a)]} radius={.008} top/>})}
      </group>}
      <M node="upper">{refinedEasy?<ArticulatedLink size={reader.motionMechanism()?.poses.upper.scale??[.16,.9,.16]} color={FINISH.alloy}/>:<Bar/>}</M><M node="forearm">{refinedEasy?<ArticulatedLink size={reader.motionMechanism()?.poses.forearm.scale??[.13,.7,.13]} color={FINISH.alloy}/>:<Bar color={FINISH.alloy}/>}</M>
      <M node="elbow"><RoundPart name="elbow-reducer" position={[0,0,0]} radius={.115} length={(reader.motionMechanism()?.clearance_revision??0)>=7?.39:.20} axis="y" color={FINISH.dark}/></M>
      <M node="wrist"><RoundPart name="wrist-reducer" position={[0,0,0]} radius={.09} length={.18} axis="y"/></M>
      {refinedEasy&&<><M node="elbow"><JointCap radius={.115} height={(reader.motionMechanism()?.clearance_revision??0)>=7?.39:.20}/></M><M node="wrist"><JointCap radius={.09} height={.18}/></M></>}
      {processDetail&&!refinedEasy&&<>
        <M node="elbow"><group rotation={[-Math.PI/2,0,0]}><Flange radius={.12} z={.21}/></group></M>
        <M node="wrist"><group rotation={[-Math.PI/2,0,0]}><Flange radius={.094} z={.102}/></group></M>
      </>}
      <M node="tool">{hard ? <Part name="empty-compact-contact-tool" size={[.12,.06,.12]} color={FINISH.dark}/> : <><Part name="empty-directional-tool" position={[.14,boundary?0:.015,0]} size={[.28,.06,.07]} color={FINISH.dark}/>{boundary ? <Part name="empty-tool-tongue" position={[.24,-.1,0]} size={[.12,.1,.06]} color={FINISH.alloy}/> : <Part position={[.27,.04,.055]} size={[.035,.1,.18]} color={FINISH.blue}/>}</>}</M>
      {reader.motionMechanism()?.poses.tool_stem&&<M node="tool_stem"><Bar color={FINISH.alloy}/></M>}
      {boundary && <>
        <M node="receiver_base"><Part name="receiver-slide-pedestal" size={[.4,.28,.32]} color={FINISH.blue}/><RoundPart name="receiver-slide-guide" position={[0,.15,0]} radius={.042} length={.08} axis="y"/></M>
        <M node="receiver_rod"><RoundPart name="receiver-moving-rod" position={[0,0,0]} radius={.5} length={1} axis="y"/></M>
        <M node="receiver">
          {[-1,1].map(k=><group key={k}>
            <Part name="receiver-long-wall" position={[0,0,k*.067]} size={[.244,.1,.05]} color={FINISH.alloy}/>
            <Part name="receiver-end-wall" position={[k*.097,0,0]} size={[.05,.1,.084]} color={FINISH.alloy}/>
          </group>)}
          <Part name="receiver-bottom-plate" position={[0,-.065,0]} size={[.244,.03,.184]} color={FINISH.dark}/>
        </M>
      </>}
    </>;break
    case 'table_slide': assembly=<>
      <Foot width={1.15} depth={1}/><RotaryIndexBase/>
      <M node="table"><IndexPlate/>
        {processDetail&&<RotaryFaceDetails/>}
        {[0,1,2,3].map(index=><group key={index} name={`table-slide-receiver-${index}`} rotation={[0,-index*Math.PI/2,0]}>
          {[-1,1].map(sign=><Part key={sign} name={`table-slide-jaw-${index}-${sign}`} position={[.48,.1325,sign*.0725]} size={[.28,.20,.04]} color={FINISH.blue}/>)}
          <Part name={`table-slide-back-${index}`} position={[.32,.1325,0]} size={[.04,.20,.185]} color={FINISH.dark}/>
        </group>)}
      </M>
      <M node="cantilever"><Part name="slide-mounted-cantilever" size={[.45,.06,.05]} color={FINISH.alloy}/></M>
      <M node="tongue"><Part name="empty-slide-tongue" size={[.14,.07,.07]} color={FINISH.dark}/></M>
    </>;break
    case 'index_pin': assembly=<>
      <Foot width={1.15} depth={1}/>{refinedEasy?<RotaryIndexBase/>:<><Part name="gearbox-housing" position={[0,.34,0]} size={[.58,.48,.58]} color={FINISH.blue}/>
      <RoundPart name="table-spindle" position={[0,.7,0]} radius={.18} length={.26} axis="y"/></>}
      {!easy && <><Part name="pin-actuator-bracket" position={[.30,.54,0]} size={[.65,.10,.18]} color={FINISH.dark}/>
      <Part name="pin-guide-housing" position={[.48,.66,0]} size={[.10,.18,.12]} color={FINISH.blue}/>
      <M node="pin"><RoundPart name="shot-pin" position={[0,0,0]} radius={.016} length={.20} axis="y" color={FINISH.alloy}/></M></>}
      <M node="table"><IndexPlate/>{refinedEasy&&<BoltCircle radius={.14} y={.034} bolt={.006}/>}</M>
    </>;break
    case 'scissor': assembly=<>
      <Foot width={.76} depth={1.1}/>
      {[-1,1].map(k=>contactRevision?<ScissorTrack key={k} z={k*.42}/>:<Part key={k} name="lower-roller-track" position={[0,.21,k*.42]} size={[1.65,.08,.26]} color={FINISH.dark}/>)}
      <Sleeve length={.76} width={.24} height={.17} position={[0,.16,0]}/>
      <M node="outriggers"><Part name="exposed-outrigger-span" size={[1,.08,.13]}/></M>
      {[-1,1].map(k=><group key={k}>
        <M node={`leg${k}a`}><Bar/></M><M node={`leg${k}b`}><Bar color={FINISH.alloy}/></M>
        <M node={`joint${k}`}><RoundPart name="scissor-central-hinge" position={[0,0,0]} radius={contactRevision?.035:.06} length={contactRevision?.26:.28} axis="z" color={FINISH.dark}/></M>
        {contactRevision&&[-1,1].flatMap(end=>['lower','upper'].map(level=><M key={`${level}-${end}`} node={`${level}_roller_${k}_${end}`}><RoundPart name="scissor-endpoint-roller" position={[0,0,0]} radius={.05} length={.26} axis="z" color={FINISH.steel}/></M>))}
        <M node={`foot${k}`}><Part name="outrigger-foot" size={[.19,.1,.34]} color={FINISH.dark}/><RoundPart position={[0,.06,0]} radius={.04} length={.10} axis="y"/></M>
      </group>)}
      <M node="table"><Part name="lift-platform" position={[0,.08,0]} size={[1.7,.14,1.16]} color={FINISH.alloy}/>{[-1,1].map(k=>contactRevision?<ScissorTrack key={k} upper z={k*.42}/>:<Part key={k} position={[0,-.01,k*.42]} size={[1.65,.06,.26]} color={FINISH.dark}/>)}
        {processDetail&&[-1,1].flatMap(x=>[-1,1].map(z=><SocketBolt key={`${x}-${z}`} position={[x*.70,.152,z*.48]} radius={.013} top/>))}
        {processDetail&&[-1,1].map(s=><Part key={s} name="lift-platform-edge-stiffener" position={[0,.065,s*.587]} size={[1.57,.07,.014]} color={FINISH.steel}/>)}
        {contactRevision&&<><Part name="common-beam-bearing-seat" position={[0,.185,0]} size={[.16,.07,.16]} color={FINISH.blue}/><RoundPart name="common-beam-support-bearing" position={[0,.24,0]} radius={.04} length={.12} axis="z" color={FINISH.steel}/></>}
      </M>
    </>;break
    case 'door_recovery': assembly=<>
      {[-.06,1.16,2.28].map(x=><Part key={x} name="door-track-post" position={[x,1.1,.10]} size={[.09,2.2,.10]} color={FINISH.dark}/>)}
      <Part name="rack-drive-top-track" position={[1.11,2.2,.09]} size={[2.4,.13,.2]} color={FINISH.blue}/>
      <Part name="door-lower-guide" position={[1.1,.055,.10]} size={[2.4,.11,.16]} color={FINISH.steel}/>
      <RoundPart name="rack-drive-pinion" position={[2.05,2.08,.15]} radius={.07} length={.18} axis="z"/>
      <M node="panel">
        <mesh name="guard-window" castShadow><boxGeometry args={[1.02,1.9,.025]}/><meshStandardMaterial color="#b3c6ce" transparent opacity={.3} metalness={.1} roughness={.3}/></mesh>
        {[-1,1].map(k=><group key={k}><Part name="door-edge-frame" position={[k*.525,0,0]} size={[.05,2,.06]} color={FINISH.blue}/><Part position={[0,k*.975,0]} size={[1.1,.05,.06]} color={FINISH.blue}/></group>)}
        <Part name="door-rack" position={[0,.99,.07]} size={[1.1,.035,.025]} color={FINISH.steel}/>
      </M>
      <Part name="external-jig-track" position={[.14,.05,-.65]} size={[.31,.1,1.8]} color={FINISH.dark}/>
      <M node="obstacle"><Part name="external-maintenance-jig" size={[.22,.8,.8]} color={FINISH.alloy}/></M>
      {[-1,1].map(k=><group key={k}><Part name="photoeye-post" position={[.55+k*.6,.25,-.3]} size={[.035,.5,.035]} color={FINISH.dark}/><Part name={k<0?'through-beam-emitter':'through-beam-receiver'} position={[.55+k*.6,.5,-.3]} size={[.04,.04,.04]} color={FINISH.blue}/><RoundPart name="photoeye-lens" position={[.55+k*.578,.5,-.3]} radius={.008} length={.006} axis="x" color="#873626"/><mesh name={`photoeye-front-optical-face-${k<0?"left":"right"}`} position={[.55+k*.575,.5,-.3]} rotation={[0,-k*Math.PI/2,0]}><circleGeometry args={[.008,12]}/><meshStandardMaterial color="#873626" polygonOffset polygonOffsetFactor={-1}/></mesh></group>)}
      <mesh name="essential-photoeye-optical-axis" position={[.55,.5,-.3]} rotation={[0,0,-Math.PI/2]}><cylinderGeometry args={[.0013,.0013,1.15,6]}/><meshBasicMaterial color="#c44332" transparent opacity={.25}/></mesh>
    </>;break
    case 'telescopic': assembly=<>
      <Foot width={.9} depth={.9}/>{refinedEasy?<TelescopicPedestal/>:<><Part name="slewing-pedestal" position={[0,.47,0]} size={[.4,.74,.4]} color={FINISH.blue}/><RoundPart name="slew-bearing" position={[0,.93,0]} radius={.25} length={.12} axis="y"/></>}
      <M node="boom"><Sleeve length={.7} width={.14} height={.18} position={[.35,0,0]}/>{refinedEasy&&<><TubeCollar x={.66} width={.14} height={.18}/><Part name="boom-root-end-cover" position={[.008,0,0]} size={[.016,.152,.112]} color={FINISH.steel}/></>}</M>
      <M node="middle"><Sleeve length={.75} width={.105} height={.135} color={refinedEasy?FINISH.alloy:FINISH.blue}/>{refinedEasy&&<TubeCollar x={.34} width={.105} height={.135}/>}</M><M node="inner"><Part name="inner-boom-stage" size={[.75,.09,.07]} color={FINISH.alloy}/></M>
      <M node="tip">{refinedEasy?<BoomEndEye/>:<RoundPart name="empty-boom-end-eye" position={[0,0,0]} radius={.065} length={.08} axis="z" color={FINISH.dark}/>}</M>
      {!easy && <><RoundPart name="protected-column" position={[1.2,1,0]} radius={.1} length={2} axis="y" color={FINISH.dark}/><Part position={[1.2,.045,0]} size={[.35,.09,.35]} color={FINISH.steel}/></>}
    </>;break
    case 'mobile': assembly=<>
      {!hard && [-1,1].map(k=><Part key={k} name="corridor-wall" position={[0,.2,k*.52]} size={[1,.4,.08]} color={FINISH.dark}/>)}
      <M node="body">
        <Part name="mobile-chassis" size={[.5,.26,.62]} color={FINISH.blue} radius={.035}/><Part name="battery-cover" position={[0,.15,0]} size={[.36,.04,.48]} color={FINISH.alloy}/><Part name="docking-nose" position={[.25,0,0]} size={[.035,.16,.38]} color={FINISH.dark}/>
        {['l','r'].map(k=><M key={k} node={'wheel_'+k}><RoundPart name="traction-wheel" position={[0,0,0]} radius={.125} length={.08} axis="z" color={FINISH.seal}/><Part name="wheel-spoke" position={[0,0,k==='l'?-.043:.043]} size={[.16,.025,.01]} color={FINISH.alloy}/></M>)}
        {[-1,1].map(k=><RoundPart key={k} name="support-caster" position={[k*.2,-.2,0]} radius={.08} length={.045} axis="z" color={FINISH.seal}/>)}
      </M>
    </>;break
    case 'hoist': assembly=<>
      {[-1,1].map(k=><group key={k}><Part name="crane-column" position={[k*1.5,1.4,0]} size={[.16,2.8,.24]} color={FINISH.blue}/><Part position={[k*1.5,.06,0]} size={[.5,.12,.7]} color={FINISH.dark}/></group>)}
      <Part name="trolley-running-beam" position={[0,2.8,0]} size={[3.15,.20,.22]} color={FINISH.blue}/>
      {processDetail&&<group name="hoist-structural-fittings">
        {[-1,1].map(s=><group key={s}>
          <Part name="beam-flange" position={[0,2.8+s*.108,0]} size={[3.17,.016,.30]} color={FINISH.steel}/>
          <Part name="column-cap-connection" position={[s*1.5,2.69,0]} size={[.29,.025,.32]} color={FINISH.alloy}/>
          {[-1,1].flatMap(x=>[-1,1].map(z=><SocketBolt key={`${x}-${z}`} position={[s*1.5+x*.17,.122,z*.24]} radius={.014} top/>))}
        </group>)}
      </group>}
      <M node="trolley"><Part name="hoist-drum-housing" size={[.3,.19,.30]} color={FINISH.alloy}/><RoundPart name="wire-drum" position={[0,-.04,0]} radius={.09} length={.34} axis="z" color={FINISH.dark}/>
        {processDetail&&<group name="hoist-drive-fittings">
          <RoundPart name="hoist-motor" position={[0,0,.245]} radius={.075} length={.15} axis="z" color={FINISH.steel}/>
          <Part name="hoist-gearbox" position={[0,0,.17]} size={[.16,.17,.04]} color={FINISH.blue}/>
          {[-1,1].map(s=><Part key={s} name="drum-bearing-cover" position={[s*.155,0,0]} size={[.012,.15,.24]} color={FINISH.steel}/>)}
        </group>}
      </M>
      <M node="cable"><RoundPart name="taut-wire-rope" position={[0,0,0]} radius={.5} length={1} axis="y" color={FINISH.dark}/></M>
      <M node="hook"><Part name="hook-swivel" position={[0,-.028,0]} size={[.038,.075,.045]} color={FINISH.steel}/><mesh name="empty-forged-hook" position={[.041,-.096,0]} rotation={[0,0,.45]} castShadow><torusGeometry args={[.064,.018,8,24,Math.PI*1.65]}/><meshStandardMaterial color={FINISH.steel} metalness={.7} roughness={.35}/></mesh></M>
    </>;break
    case 'counterbalance': assembly=<>
      {processDetail&&<BalanceDriveDetails/>}
      <Foot width={hard ? 1.3 : balance.span + .2} depth={.85}/><Part name="common-support-pedestal" position={[0,.30,0]} size={[.25,.4,.35]} color={FINISH.blue}/>
      <RoundPart name="common-base-support-bearing" position={[0,.48,0]} radius={.12} length={.36} axis="z"/>
      <Part name="counterweight-guide" position={[0,balance.y,0]} size={[balance.span,.07,.14]} color={FINISH.dark}/>
      {!hard && <group name="counterbalance-display-v2" userData={{geometryRevision: balance.revision}}>
        {[-1,1].map(k=><group key={k}>
          <Part name="balance-end-support" position={[k*balance.end,.35,0]} size={[.09,.52,.38]} color={FINISH.blue}/>
          <Part name="balance-axis-endplate" position={[k*balance.end,balance.y-.02,0]} size={[.045,.19,.30]} color={FINISH.blue}/>
          <RoundPart name="balance-linear-guide" position={[0,balance.y-.03,k*.125]} radius={.016} length={balance.span+.02} axis="x"/>
        </group>)}
        <FittedMaterialDrive position={[-balance.end-.12,balance.y-.02,0]} size={[.19,.14,.15]}/>
        <RoundPart name="balance-drive-coupling" position={[-balance.end-.025,balance.y-.02,0]} radius={.025} length={.05} axis="x"/>
      </group>}
      {[-1,1].map(k=><group key={k}><Part name="gimbal-bearing-post" position={[0,.75,k*.27]} size={[.13,.5,.10]} color={FINISH.blue}/><RoundPart position={[0,1,k*.27]} radius={.10} length={.12} axis="z" color={FINISH.steel}/></group>)}
      <M node="cradle"><RoundPart name="tilting-trunnion" position={[0,0,0]} radius={.07} length={.62} axis="z"/><Part name="head-cg-offset-arm" position={[0,.15,0]} size={[.10,.30,.12]} color={FINISH.dark}/><Part name="empty-tilting-head" position={[0,.3,0]} size={[.25,.24,.35]} color={FINISH.alloy}/>
        {processDetail&&<group name="tilting-head-machined-cover">
          <Part name="head-end-cover" position={[0,.30,.18]} size={[.21,.20,.01]} color={FINISH.blue}/>
          {[-1,1].flatMap(x=>[-1,1].map(y=><RoundPart key={`${x}-${y}`} position={[x*.077,.30+y*.07,.19]} radius={.009} length={.01} segments={6} color={FINISH.dark}/>))}
        </group>}
      </M>
      <M node="weight"><Part name="sliding-counterweight" position={[0,balance.dy,0]} size={[.17,.18,.3]} color={FINISH.steel}/></M>
      {boundary && <>
        <RoundPart name="head-brake-disk" position={[0,1,.36]} radius={.145} length={.025} axis="z" color={FINISH.alloy}/>
        <M node="head_brake">{[-1,1].map(k=><Part key={k} name="head-brake-pad" position={[.075,0,k*.036]} size={[.11,.16,.046]} color={FINISH.dark}/>)}</M>
        <Part name="head-brake-caliper" position={[.16,1,.36]} size={[.06,.21,.18]} color={FINISH.blue}/>
      </>}
    </>;break
    case 'crank': assembly=<>
      <Foot width={1.4} depth={1}/>
      {[-1,1].map(k=><group key={k}><Part name="press-column" position={[k*.60,1.35,0]} size={[.16,2.6,.28]} color={FINISH.blue}/><Part name="ram-guide" position={[k*.27,1.10,.30]} size={[.065,1.45,.08]} color={FINISH.dark}/></group>)}
      <Part name="press-crown" position={[0,2.6,0]} size={[1.4,.2,.65]} color={FINISH.blue}/><Part name="empty-press-bed" position={[0,.28,.12]} size={[1.12,.2,.65]} color={FINISH.steel}/>
      <RoundPart name="clutch-brake-housing" position={[0,2,-.45]} radius={.18} length={.35} axis="z" color={FINISH.dark}/>
      <M node="drive_flywheel"><RoundPart name="continuously-driven-flywheel" position={[0,0,0]} radius={.48} length={.07} axis="z" color={FINISH.steel}/><Part name="drive-flywheel-spoke" position={[0,0,-.04]} size={[.06,.88,.012]} color={FINISH.dark}/></M>
      <M node="flywheel"><RoundPart name="crank-disk" position={[0,0,0]} radius={.49} length={.08} axis="z" color={FINISH.alloy}/><RoundPart name="crank-pin" position={[0,.45,.19]} radius={.04} length={.38} axis="z" color={FINISH.dark}/><Part position={[0,.23,.045]} size={[.04,.45,.01]} color={FINISH.blue}/></M>
      <M node="rod"><Bar color={FINISH.steel}/></M><M node="ram"><Part name="guided-ram" size={[.46,.22,.28]} color={FINISH.alloy}/><Part name="empty-upper-tool" position={[0,-.15,0]} size={[.24,.08,.20]} color={FINISH.dark}/></M>
    </>;break
    default: assembly=<>
      <RoundPart name="hexapod-base" position={[0,.075,0]} radius={.73} length={.15} axis="y" color={FINISH.dark}/>
      {Array.from({length:6},(_,k)=><M key={k} node={'leg'+k}><Strut reader={reader} node={'leg'+k}/></M>)}
      <M node="platform"><RoundPart name="hexapod-platform" position={[0,.065,0]} radius={.48} length={.10} axis="y" color={FINISH.alloy}/><Part name="remote-point-stylus" position={[0,(pivot+.115)/2,0]} size={[.015,pivot-.115,.015]} color={FINISH.dark}/></M>
      <M node="pivot"><mesh name="requested-remote-point" ><sphereGeometry args={[.016,12,8]}/><meshStandardMaterial color={FINISH.blue}/></mesh></M>
    </>;break
  }
  return <group name={`motion-diverse-hardware-${mode}`} userData={{equipmentScope:true,deviceId:device.id,mechanism:mode,...(['telescopic','index_pin','table_slide'].includes(mode)?{equipmentUnit:true,deviceDisplayName:`${mode==='telescopic'?'Telescopic boom':'Indexing table'} ${device.id==='CELL'?'':device.id}`.trim()}:{} )}}>{assembly}</group>
}
