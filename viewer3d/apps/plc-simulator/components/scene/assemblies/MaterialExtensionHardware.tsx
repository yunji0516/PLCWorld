'use client'
import {ServiceEnclosure} from './ServiceEnclosure'

import { useFrame } from '@react-three/fiber'
import { useEffect, useMemo, useRef } from 'react'
import * as THREE from 'three'
import type { DeviceProps } from '../devices'
import {MaterialTableLegs} from './MaterialTableLegs'
import { Part, RoundPart } from './Parts'
import { SocketBolt } from '../IndustrialDetails'
import { SafeServiceTube } from './SafeServiceTube'
import { Foot, Profile, Rail, Drive, Hose, LabelPlate, BoredHub, CabinetFace } from './MaterialV6Details'

type V3=[number,number,number]
const Box=({p,s,c='#9cabb6',name}:{p:V3;s:V3;c?:string;name?:string})=><Part name={name} position={p} size={s} color={c}/>
function Legs({x,z,h=.61,centerX=0}:{x:number;z:number;h?:number;centerX?:number}) {
 return <MaterialTableLegs x={centerX} halfX={x} halfZ={z} top={h+.05}/>
}
/** Bolts are outside the cover surface; no overlaid coplanar decoration. */
function Cover({p,w,h}:{p:V3;w:number;h:number}) {
 return <group name="v7-bolted-service-cover" position={p}>
  <Box p={[0,0,0]} s={[w,h,.008]} c="#b7c3ca"/>
  {[-1,1].flatMap(x=>[-1,1].map(y=><SocketBolt key={`${x}:${y}`} position={[x*(w/2-.012),y*(h/2-.012),.005]} radius={.004}/>))}
 </group>
}
function Nest({x,z,w=.28,d=.27}:{x:number;z:number;w?:number;d?:number}) {
 return <group name="v7-support-nest"><Box p={[x,.70,z]} s={[w,.04,d]} c="#466474"/>
  {[-1,1].map(k=><Box key={k} name="v7-nest-end-stop" p={[x,.732,z+k*(d/2+.006)]} s={[w,.024,.012]} c="#bbc3c8"/>)}</group>
}
function Jaw({side,grip,compactSlider=false}:{side:number;grip:React.RefObject<THREE.Group|null>;compactSlider?:boolean}) {
 return <group name="v7-jaw-finger" ref={grip} position={[side*.129,0,0]}><Box name="v7-jaw-slider" p={[0,.012,0]} s={[compactSlider?.052:.082,.034,.15]} c="#465f70"/><Box name="v7-jaw-back" p={[0,-.0425,0]} s={[.028,.085,.17]} c="#768b98"/>
  <Box name="v7-jaw-contact-pad" p={[-side*.021,-.075,0]} s={[.016,.030,.14]} c="#252e34"/>
  <SocketBolt position={[0,-.04,.089]} radius={.006}/></group>
}

/** Service loop stays behind/above the beam and terminates on the moving saddle. */
function TravelService({plant,sender=false}:{plant:DeviceProps['plant'];sender?:boolean}) {
 return <group><Box p={sender?[-.12,1.14,-.32]:[0,1.55,-.635]} s={[.10,.08,.05]} c="#445d6d"/>
 <SafeServiceTube name="v7-moving-service-loop" points={()=>{const x=plant.machine.devices.find(d=>d.id===(sender?'SENDER':'CARRIAGE'))?.pos[0]??0;return sender?[[-.12,1.14,-.345],[-.12,1.4,-.48],[x,1.135,-.18]]:[[0,1.55,-.66],[0,1.96,-.85],[x+.115,1.70,0]]}}/>
 </group>
}
/** New synthetic mechanisms only. All global poses and contents come from replay. */
export function MaterialExtensionHardware({device,plant}:DeviceProps) {
 const v=device.visualVariant??'',a=useRef<THREE.Group>(null),b=useRef<THREE.Group>(null),rod=useRef<THREE.Group>(null)
 const receiverLiftA=useRef<THREE.Group>(null),receiverLiftB=useRef<THREE.Group>(null)
 const flex=useRef<THREE.Mesh>(null),lastHoseY=useRef(-1)
 const flexGeometry=useMemo(()=>new THREE.TubeGeometry(new THREE.CatmullRomCurve3([new THREE.Vector3(-.04,1.12,0),new THREE.Vector3(.10,1.58,-.22),new THREE.Vector3(.50,1.65,-.18),new THREE.Vector3(.65,1.57,0)]),32,.013,8,false),[])
 useFrame(()=>{
  const f=plant.state(device.id).pos
  if(v==='v7-head'||v==='v7-sender'){
   if(a.current)a.current.position.x=-.129-.040*(1-f)
   if(b.current)b.current.position.x=.129+.040*(1-f)
  }
  if(v==='v7-receiver'){
   // The automatic receiver first raises its open fingers after docking,
   // then closes them. At rest every finger clears the incoming part below.
   const lift=Math.min(1,Math.max(0,f/.45)),close=Math.min(1,Math.max(0,(f-.45)/.55))
   // A floating jaw pair takes up the public ±3 mm docking tolerance.
   const received=plant.parts[0],offset=Math.max(-.003,Math.min(.003,(received?.x??.65)-.65))*close
   if(a.current)a.current.position.x=-.129-.040*(1-close)+offset
   if(b.current)b.current.position.x=.129+.040*(1-close)+offset
   if(receiverLiftA.current)receiverLiftA.current.position.y=-.065*(1-lift)
   if(receiverLiftB.current)receiverLiftB.current.position.y=-.065*(1-lift)
  }
  if(v==='v7-liquid'&&a.current){a.current.scale.y=Math.max(.001,f);a.current.position.y=.12*f}
  if(v==='v7-tank'&&a.current){a.current.scale.y=Math.max(.001,f);a.current.position.y=-.165+.265*f}
  if(v==='v7-valve'&&a.current)a.current.rotation.y=f*Math.PI/2
  if(v==='v7-carriage'&&rod.current){const length=.035+.4*(1-f);rod.current.scale.y=length;rod.current.position.y=-length/2-.04}
  if(v==='v7-nozzle'&&rod.current){const length=1.58-(f+.0625);rod.current.scale.y=length;rod.current.position.y=.0625+length/2}
  if(v==='v7-pitch-receiver'){
   if(a.current)a.current.position.z=-f/2
   if(b.current)b.current.position.z=f/2
  }
  if(v==='v7-dose-base'&&flex.current){
   // One continuous hose follows the actual nozzle; no disconnected segments.
   const y=plant.state('NOZZLE').pos
   if(y!==lastHoseY.current){lastHoseY.current=y;const curve=new THREE.CatmullRomCurve3([new THREE.Vector3(-.04,1.12,0),new THREE.Vector3(.10,1.58,-.22),new THREE.Vector3(.50,1.65,-.18),new THREE.Vector3(.65,y+.15,0)])
    const next=new THREE.TubeGeometry(curve,32,.013,8,false);flex.current.geometry.copy(next);next.dispose()}
  }
 })
 if(v==='v7-dose-base')return <group name="v7-dose-assembly">
  <Legs x={1.08} z={.42}/><Box name="v7-tabletop" p={[0,.69,0]} s={[2.35,.06,1.0]}/>

  <Profile p={[.93,1.14,-.30]} length={.84}/><Box p={[.78,1.56,-.16]} s={[.36,.07,.32]}/>
  <RoundPart name="v7-nozzle-cylinder" position={[.78,1.84,-.14]} radius={.042} length={.46} axis="y" color="#60798a"/>
  {[1.595,2.085].map(y=><Box key={y} p={[.78,y,-.14]} s={[.11,.03,.10]} c="#4d6d80"/>)}
  <Box p={[-.50,.75375,0]} s={[.12,.0675,.14]} c="#5c7584"/>
  <RoundPart position={[-.4525,.85,0]} radius={.014} length={.025} axis="x"/>
  <Box p={[-.15,.735,-.22]} s={[.13,.03,.12]}/>
  <Profile p={[-.15,.89,-.22]} length={.28} edge={.035}/>
  <Box p={[-.15,1.05,-.11]} s={[.10,.04,.27]}/>
  <group position={[-.15,1.12,0]} rotation={[0,0,Math.PI/2]}><BoredHub p={[0,0,0]} outer={.05} inner={.0455} height={.04}/></group>
  <Box p={[-.30,.85,0]} s={[.28,.26,.30]} c="#567c8f"/><Cover p={[-.30,.85,.154]} w={.24} h={.22}/><Drive p={[-.50,.85,0]} axis="x"/>
  <RoundPart position={[-.9,.80,.26]} radius={.023} length={.045}/>
  <RoundPart position={[-.30,.85,.16]} radius={.023} length={.035}/>
  <Hose purpose="functional" points={[[-.9,.80,.2825],[-.80,.84,.34],[-.4,.85,.34],[-.30,.85,.1775]]} radius={.013}/>
  <Hose purpose="functional" points={[[-.30,.98,0],[-.36,1.04,0],[-.36,1.12,0],[-.26,1.12,0]]} radius={.013}/>
  <SafeServiceTube purpose="functional" name="v7-nozzle-hose" radius={.006} color="#4c6c75" points={()=>{const y=plant.machine.devices.find(d=>d.id==='NOZZLE')?.pos[1]??1.42;return [[-.04,1.12,0],[.10,1.58,-.22],[.65,y+.15,0]]}}/>
  <BoredHub p={[.65,.853,0]} outer={.19} inner={.175} height={.25}/>
  <Box p={[.65,.724,0]} s={[.35,.008,.35]} c="#c6d2d4"/>
  <LabelPlate text="METERED TRANSFER" p={[0,.688,.502]} width={.45}/>
  <ServiceEnclosure x={-.60} z={.365} top={.66}/>
  <LabelPlate text="RECEIVED / mL" p={[-.60,.50,.502]} width={.31}/>
 </group>
 if(v==='v7-tank')return <group>
  <BoredHub p={[0,.10,0]} outer={.25} inner={.235} height={.54}/>
  <RoundPart position={[0,-.175,0]} radius={.25} length={.01} axis="y"/>
  <RoundPart position={[0,.38,0]} radius={.26} length={.02} axis="y"/>
  <group ref={a}><mesh><cylinderGeometry args={[.232,.232,.53,48]}/><meshStandardMaterial color="#5faaa8" transparent opacity={.7}/></mesh></group>
  <RoundPart position={[0,.404,0]} radius={.075} length={.028} axis="y" color="#557083"/>
  {Array.from({length:8},(_,i)=>{const a=i*Math.PI/4;return <SocketBolt key={i} top position={[Math.cos(a)*.245,.391,Math.sin(a)*.245]} radius={.005}/>})}
  {[-.04,.04].map(x=><Box key={x} p={[x,.437,0]} s={[.012,.04,.015]} c="#607c8e"/>)}
  <Box p={[0,.460,0]} s={[.092,.012,.015]} c="#607c8e"/>
  <LabelPlate text="SUPPLY" p={[0,.04,.252]} width={.22}/>
 </group>
 if(v==='v7-liquid')return <group ref={a}><mesh><cylinderGeometry args={[.165,.165,.24,48]}/><meshStandardMaterial color="#6db5b1" metalness={.15} roughness={.25}/></mesh></group>
 if(v==='v7-valve')return <group><RoundPart position={[0,0,0]} radius={.045} length={.22} axis="x"/>
  <Box p={[0,.055,0]} s={[.08,.05,.08]} c="#3e5462"/><group ref={a}><Box p={[0,.085,0]} s={[.16,.018,.025]} c="#a2644b"/></group></group>
 if(v==='v7-nozzle')return <group><RoundPart position={[0,0,0]} radius={.019} length={.30} axis="y"/>
  <RoundPart position={[0,.10,0]} radius={.032} length={.04} axis="y" color="#527989"/>
  <group ref={rod}><RoundPart name="v7-nozzle-piston" position={[.13,0,-.14]} radius={.016} length={1} axis="y"/></group>
  <Box name="v7-nozzle-mount" p={[.125,.04,-.11]} s={[.25,.045,.24]} c="#7c95a4"/>
  <Box p={[.28,.04,-.25]} s={[.06,.12,.06]} c="#5d7c8e"/></group>
 if(v==='v7-selective-base')return <group name="v7-selective-pedestal-assembly">
  <Box p={[0,.03,-.55]} s={[.64,.06,.52]} c="#385e73"/>
  <Profile p={[0,.76,-.55]} length={1.40} edge={.12}/>
  <Box p={[0,1.52,-.55]} s={[2.24,.12,.12]} c="#597b8b" name="v7-fixed-travel-beam"/>
  <Rail p={[0,1.56,-.466]} length={1.9}/><Drive p={[-1.20,1.52,-.55]}/>
  <RoundPart name="v7-travel-drive-coupling" position={[-1.1425,1.52,-.55]} radius={.018} length={.045} axis="x"/>
  {[-.75,.75].map(x=><group key={x}>
    <MaterialTableLegs x={x} halfX={.17} halfZ={.50} top={.62}/>
    <Box name="v7-tabletop" p={[x,.65,0]} s={[.46,.06,1.12]}/>
    {[-1,0,1].map(i=><Nest key={i} x={x} z={i*.34}/>)}
    <LabelPlate text={x<0?'RETURN':'SELECTED'} p={[x,.648,.562]} width={.28}/>
  </group>)}

  <LabelPlate text="3-HEAD PARTITION" p={[0,.45,-.329]} width={.30}/>

 </group>
 if(v==='v7-pitch-base')return <group name={v+'-assembly'}>
  <Legs x={1.03} z={.62} h={.57}/><Box name="v7-tabletop" p={[0,.65,0]} s={[2.30,.06,1.40]}/>
  {[-1.03,1.03].map(x=><Profile key={x} p={[x,1.07,-.55]} length={.78} edge={.09}/>)}
  <Box p={[0,1.52,-.55]} s={[2.24,.12,.12]} c="#597b8b" name="v7-fixed-travel-beam"/>
  <Rail p={[0,1.56,-.466]} length={1.9}/><Drive p={[-1.20,1.52,-.55]}/>
  <RoundPart name="v7-travel-drive-coupling" position={[-1.1425,1.52,-.55]} radius={.018} length={.045} axis="x"/>

  <Box p={[-.75,.70,0]} s={[.32,.04,.85]} c="#527283"/>
  <LabelPlate text="PAIR SPACING" p={[0,.648,.702]} width={.46}/>
  <ServiceEnclosure x={.65} top={.62} z={.52}/>
 </group>
 if(v==='v7-carriage')return <group>
  <Box name="v7-travel-saddle" p={[0,.04,-.33]} s={[.23,.10,.38]} c="#7994a5"/>
  <Box p={[0,.02,-.07]} s={[.20,.14,.14]} c="#486b7f"/>
  <RoundPart name="v7-lift-barrel" position={[0,.18,0]} radius={.043} length={.38} axis="y"/>
  {[-.025,.385].map(y=><Box key={y} p={[0,y,0]} s={[.15,.03,.13]} c="#567688"/>)}
  {[-1,1].flatMap(x=>[-1,1].map(z=><group key={`${x}:${z}`}>
    <RoundPart name="v7-cylinder-tie-rod" position={[x*.059,.18,z*.046]} radius={.004} length={.38} axis="y"/>
    <SocketBolt top position={[x*.059,.401,z*.046]} radius={.005}/>
  </group>))}
  <Cover p={[0,.02,.004]} w={.16} h={.105}/>
  <RoundPart name="v7-carriage-service-port" position={[.079,.20,0]} radius={.011} length={.072} axis="x"/>
  <group ref={rod} name="v7-lift-piston"><RoundPart position={[0,0,0]} radius={.022} length={1} axis="y"/>
    {[-.052,.052].map(x=><RoundPart key={x} position={[x,0,0]} radius={.007} length={1} axis="y"/>)}</group>
 </group>
 if(v==='v7-pitch-crosshead'||v==='v7-selective-crosshead')return <group>
  <Box name="v7-crosshead-beam" p={[0,0,0]} s={[.12,.05,v==='v7-pitch-crosshead'?.78:.97]} c="#6c8798"/>
  {[-1,1].map(k=><RoundPart key={k} position={[k*.042,-.036,0]} radius={.010} length={v==='v7-pitch-crosshead'?.74:.90}/>) }
  {v==='v7-pitch-crosshead'? <>
    <group position={[0,0,.48]} rotation={[0,Math.PI,0]}><Drive p={[0,0,0]} axis="z"/>
    <RoundPart name="v7-pitch-drive-coupling" position={[0,0,.0625]} radius={.016} length={.055}/></group>
  </>:<Box p={[.11,0,-.38]} s={[.10,.06,.18]} c="#4d6d80"/>}
 </group>
 if(v==='v7-receiver')return <group>
  <Box name="v7-receiver-housing" p={[0,-.2475,0]} s={[.40,.125,.20]} c="#5c877e"/><Cover p={[0,-.2475,.104]} w={.35} h={.10}/>
  {[-1,1].map(side=><group key={side} ref={side<0?a:b} name="v7-receiver-finger">
    <Box name="v7-receiver-slider" p={[0,-.190,0]} s={[.08,.03,.15]} c="#46665f"/>
    {[-.05,.05].map(z=><BoredHub key={z} p={[0,-.174,z]} outer={.010} inner={.0065} height={.016}/>)}
    <group name="v7-receiver-lift" ref={side<0?receiverLiftA:receiverLiftB} position={[0,-.065,0]}>
      {[-.05,.05].map(z=><RoundPart key={z} name="v7-receiver-lift-rod" position={[0,-.165,z]} radius={.006} length={.14} axis="y"/>)}
      <Box name="v7-receiver-back" p={[0,-.08,0]} s={[.028,.04,.17]}/>
      <Box name="v7-receiver-contact-pad" p={[-side*.021,-.07,0]} s={[.016,.030,.14]} c="#252e34"/>
    </group>
  </group>)}
 </group>
 if(v==='v7-head'||v==='v7-sender')return <group>
  {/* Sender opens across the travel axis so a released part clears both fingers during return. */}
  {v==='v7-sender'&&<Box name="v7-sender-rail-saddle" p={[0,.085,-.135]} s={[.16,.04,.09]} c="#7994a5"/>}
  <group rotation={[0,v==='v7-sender'?Math.PI/2:0,0]}>
  <group name="v7-gripper-housing">
   <Box name="v7-gripper-top-cover" p={[0,.071,0]} s={[.40,.028,.18]} c="#aebec7"/>
   <Box name="v7-gripper-central-actuator" p={[0,.031,0]} s={[.16,.052,.15]} c="#4a6678"/>
   {[-1,1].map(side=><group key={side}>
    <Box name="v7-gripper-side-cheek" p={[0,.031,side*.084]} s={[.40,.052,.012]} c="#557180"/>
    {[-1,1].map(z=><SocketBolt key={z} top position={[side*.147,.0865,z*.045]} radius={.005}/>)}
   </group>)}
  </group>
  <Cover p={[0,.045,.094]} w={.35} h={.065}/>
  {[-1,1].map(side=><Box key={side} name="v7-jaw-guide-track" p={[0,.004,side*.081]} s={[.38,.006,.006]} c="#324957"/>)}
  {v==='v7-head'? <>
    <Box name="v7-head-mount" p={[0,.125,0]} s={[.10,.08,.10]} c="#899da9"/>
    <RoundPart position={[.205,.045,0]} radius={.01} length={.025} axis="x"/>
    <RoundPart name="v7-head-upper-service-port" position={[.056,.14,0]} radius={.006} length={.012} axis="x"/>
    <Hose points={[[.2175,.045,0],[.26,.09,0],[.25,.19,0],[.062,.14,0]]} radius={.004}/>
  </>:null}
  <Jaw side={-1} grip={a} compactSlider={v==='v7-sender'}/><Jaw side={1} grip={b} compactSlider={v==='v7-sender'}/>
  </group>
 </group>
 if(v==='v7-pitch-receiver')return <group>
  <group ref={a}><Nest x={0} z={0} w={.28} d={.20}/></group>
  <group ref={b}><Nest x={0} z={0} w={.28} d={.20}/></group>
 </group>
 if(v==='v7-magazine-base')return <group name="v7-magazine-assembly">
  <Legs centerX={-.48} x={.57} z={.37} h={.43}/><Box name="v7-tabletop" p={[-.48,.51,0]} s={[1.32,.06,.91]}/>
  <Box p={[.70,.03,-.03]} s={[.72,.06,.80]} c="#4b6e81"/>
  {[-.37,.37].map(z=><Box key={z} p={[.605,.51,z]} s={[.85,.06,.06]}/>)}
  {[-.80,-.25,.10].map(x=><Box key={x} name="v7-feed-bridge-stand" p={[x,.61,0]} s={[.08,.14,.24]}/>)}
  {[-.80,.10].map(x=><Box key={x} p={[x,.647,-.30]} s={[.075,.214,.10]}/>)}
  <Box p={[-.23,.765,-.30]} s={[1.64,.022,.10]}/>
  <Box p={[-.28,.70,0]} s={[1.16,.04,.29]} c="#6a8798"/>
  {[-.18,.18].map(z=><Box key={z} p={[-.23,.745,z]} s={[1.26,.05,.025]}/>)}
  <Box p={[-.92,.69,-.30]} s={[.20,.22,.16]} c="#4d778c"/>
  <Rail p={[-.23,.79,-.30]} length={1.64}/><Drive p={[-1.10,.69,-.30]}/>
  <RoundPart position={[-1.0425,.69,-.30]} radius={.016} length={.045} axis="x"/>
  <Profile p={[.70,.81,-.36]} length={1.50} edge={.08}/>
  <RoundPart position={[.70,.9175,-.29]} radius={.016} length={1.175} axis="y"/>
  <Box p={[.70,.1175,-.29]} s={[.08,.035,.055]} c="#486c80"/>
  <RoundPart name="v7-rack-lift-motor" position={[.70,.20,-.29]} radius={.026} length={.13} axis="y" color="#486c80"/>
  <Box p={[.70,.2775,-.29]} s={[.08,.025,.055]}/>
  <RoundPart position={[.70,.31,-.29]} radius={.021} length={.04} axis="y"/>
  <LabelPlate text="SLOT MAGAZINE" p={[0,.505,.456]} width={.42}/>
  <Box p={[.70,.56,.385]} s={[.06,.04,.055]}/>
  <Box p={[.70,.62,.40]} s={[.10,.08,.07]} c="#516b7b"/>
 </group>
 if(v==='v7-rack')return <group>
  {[0,1,2,3].map(i=><group key={i}><Box p={[.70,.70+i*.16,0]} s={[.50,.04,.43]} c="#6b899c"/>
   {[-1,1].map(side=><group key={side}>
    <Box name="v7-rack-side-stiffener" p={[.72,.684+i*.16,side*.229]} s={[.52,.04,.027]} c="#485f71"/>
    {[.50,.92].map(x=><group key={x} position={[x,.686+i*.16,side*.244]} rotation={side<0?[0,Math.PI,0]:[0,0,0]}><SocketBolt position={[0,0,0]} radius={.004}/></group>)}
   </group>)}
   <LabelPlate text={`${i+1}`} p={[.96,.72+i*.16,.247]} width={.05}/></group>)}
  {[-.255,.255].map(z=><Box key={z} p={[.99,.94,z]} s={[.055,.60,.045]}/>)}
  <Box p={[.70,.94,-.25]} s={[.10,.52,.05]}/>
  <BoredHub p={[.70,.94,-.29]} outer={.033} inner={.017} height={.10}/>
 </group>
 if(v==='v7-pusher')return <group><Box name="v7-pusher-bearing" p={[0,.0725,-.30]} s={[.20,.06,.10]} c="#466474"/><Box p={[0,0,0]} s={[.16,.10,.24]} c="#7394a7"/>
  <Box name="magazine-pusher-bearing-arm" p={[0,.04,-.185]} s={[.14,.055,.13]}/><Box p={[.083,-.02,0]} s={[.006,.07,.22]} c="#29343e"/>
 </group>
 if(v==='v7-handshake-base')return <group name="v7-handshake-assembly">
  <Legs x={.98} z={.40} h={.54}/><Box name="v7-tabletop" p={[0,.61,0]} s={[2.22,.06,1.0]}/>
  <Profile p={[-.92,.85,-.25]} length={.42} edge={.08}/>
  <Profile p={[.38,.85,-.25]} length={.42} edge={.08}/>
  <Box p={[-.12,1.10,-.25]} s={[1.70,.08,.10]} c="#597e94"/>
  <Rail p={[-.12,1.14,-.17]} length={1.60}/><Drive p={[-1.10,1.10,-.25]}/>
  <RoundPart name="v7-travel-drive-coupling" position={[-1.0175,1.10,-.25]} radius={.018} length={.095} axis="x"/>
  <Box p={[.65,.65,0]} s={[.34,.02,.42]}/>
  <Profile p={[.65,.6875,0]} length={.055} edge={.10}/>
  <Box name="v7-receiver-mount" p={[.65,.7275,0]} s={[.20,.025,.30]}/>
  <Box name="v7-front-cable-tray" p={[.08,.70,.46]} s={[1.40,.04,.045]} c="#4d6575"/>
  {[-.45,.60].map(x=><Box key={x} p={[x,.66,.46]} s={[.06,.04,.045]}/>)}
  {[-.40,.10,.60].map(x=><Box key={x} p={[x,.734,.46]} s={[.024,.028,.028]} c="#354c59"/>)}

  <LabelPlate text="OFFER / ACCEPT" p={[-.65,.81,.386]} width={.24}/>
  <Hose points={[[-.53,.735,.46],[.60,.735,.46],[.82,.75,.43],[.82,.815,.28],[.65,.815,.1225]]}/>
  <RoundPart position={[.65,.815,.11]} radius={.012} length={.025}/>

  <TravelService plant={plant} sender/>
  <LabelPlate text="CUSTODY TRANSFER" p={[0,.61,.502]} width={.44}/>
 </group>
 return null
}
