'use client'
import {MaterialTableLegs} from './MaterialTableLegs'

import { useFrame } from '@react-three/fiber'
import { useRef } from 'react'
import type { Group } from 'three'
import type { DeviceProps } from '../devices'
import type { Plant } from '@/lib/machine/plant'
import { Part, RoundPart } from './Parts'
import { SocketBolt } from '../IndustrialDetails'
import { TendingPlate } from './TendingHardware'
import { MaterialHard15V4Hardware } from './MaterialHard15V4Hardware'

type V3=[number,number,number]
const B=({p,s,c='#a7b2b8',name}:{p:V3;s:V3;c?:string;name?:string})=><Part name={name} position={p} size={s} color={c}/>
const R=({p,r,l,axis='z',c='#a7b2b8'}:{p:V3;r:number;l:number;axis?:'x'|'y'|'z';c?:string})=><RoundPart position={p} radius={r} length={l} axis={axis} color={c}/>
const bolts=(xs:number[],z:number,y:number)=>xs.map(x=><SocketBolt key={`${x}:${y}:${z}`} top position={[x,y,z]} radius={.006}/>)

/** All articulation reads replay poses. No independent wall-clock animation. */
export function MaterialHard15Hardware({device,plant}:DeviceProps){
 const a=useRef<Group>(null),b=useRef<Group>(null),moving=useRef<Group>(null)
 const [w,h,d]=device.size,v=device.visualVariant
 useFrame(()=>{
  const q=plant.state(device.id).pos
  if(v==='cell3-gripper'){
   if(a.current)a.current.position.x=-.17+.08*q
   if(b.current)b.current.position.x=.17-.08*q
  }
  if(v==='cell3-lift'&&moving.current){
   const y=plant.machine.devices.find(p=>p.id==='TOOL')?.pos[1]??3
   const length=Math.max(.1,device.pos[1]-(y+.06))
   moving.current.position.y=-length/2;moving.current.scale.y=length
  }
  if(moving.current&&v==='cell3-residue')moving.current.visible=q>0
  else if(moving.current&&v==='cell3-wiper')moving.current.position.z=-.19+q*.27
  else if(moving.current&&v!=='cell3-lift'){moving.current.position.z=-Math.min(q,1)*.25}
 })
 if(v?.startsWith('cell3-bank-')||v?.endsWith('-v4')||['cell3-scara','cell3-arm-mast','cell3-rear-track','cell3-cantilever','cell3-z-saddle','cell3-roller-port','cell3-deck-port'].includes(v??''))return <MaterialHard15V4Hardware device={device} plant={plant}/>
 if(v==='cell3-post')return <group name="hard15-column">
  <B p={[0,0,0]} s={[w,h,d]} c="#486274"/>
  {[-1,1].map(k=><B key={k} p={[k*(w/2+.001),0,0]} s={[.003,h-.08,.018]} c="#263d49"/>)}
  <B p={[0,-h/2+.018,0]} s={[.30,.036,.30]} c="#71858e"/>
  {[-.105,.105].flatMap(z=>bolts([-.105,.105],z,-h/2+.037))}
 </group>
 if(v==='cell3-rail')return <group name="hard15-gantry-longitudinal-rail">
  <B p={[0,0,0]} s={[w,h,d]} c="#718c99"/>
  <B p={[0,h/2+.01,0]} s={[.045,.02,d-.08]} c="#b7c5cc"/>
  {Array.from({length:Math.ceil(d/.4)},(_,i)=><SocketBolt key={i} top position={[0,h/2+.021,-d/2+.15+i*.4]} radius={.004}/>)}
 </group>
 if(v==='cell3-bridge')return <group name="hard15-moving-crossbeam">
  <B p={[0,0,0]} s={[w,h,d]} c="#5f8194"/>
  {[-1,1].map(k=><B key={k} p={[0,-.012,k*(d/2+.012)]} s={[w-.08,.035,.024]} c="#c0c9ce"/>)}
  <B p={[w/2-.12,0,-.20]} s={[.18,.16,.18]} c="#344e5d"/>
  <R p={[w/2-.12,0,-.32]} r={.065} l={.11}/>
 </group>
 if(v==='cell3-carriage')return <group name="hard15-crossbeam-saddle">
  {/* Saddle cheeks leave an actual opening around the beam. */}
  <B p={[0,.145,0]} s={[.34,.035,.34]}/>
  {[-1,1].map(k=><B key={k} p={[0,.02,k*.145]} s={[.34,.22,.04]} c="#315b71"/>)}
  <B p={[0,-.115,0]} s={[.30,.045,.34]}/>
  <R p={[.23,.10,0]} r={.058} l={.15} axis="x" c="#314753"/>
  <B p={[.17,.06,0]} s={[.06,.12,.13]} c="#8098a6"/>
 </group>
 if(v==='cell3-lift')return <group name="hard15-telescopic-lift">
  <group ref={moving}>
   <B p={[0,0,0]} s={[.085,1,.085]} c="#b6c4cc"/>
   {[-1,1].map(k=><B key={k} p={[k*.027,0,-.045]} s={[.012,1,.008]} c="#5b727f"/>)}
  </group>
  <B p={[0,-.04,0]} s={[.125,.08,.125]} c="#486a7e"/>
 </group>
 if(v==='cell3-gripper')return <group name="hard15-connected-parallel-gripper">
  <B p={[0,0,0]} s={[.34,.12,.20]} c="#496b80"/>
  <B p={[0,.066,0]} s={[.12,.012,.12]} c="#bdc9d0"/>
  <R p={[0,-.06,0]} r={.009} l={.28} axis="x"/>
  {[a,b].map((ref,k)=><group ref={ref} key={k} position={[k?.17:-.17,0,0]}>
   <B name="jaw-slide" p={[0,-.075,0]} s={[.05,.03,.10]} c="#c6d0d5"/>
   <B name="jaw-connected-finger" p={[0,-.17,0]} s={[.02,.16,.08]} c="#9caeb9"/>
   <B name="jaw-contact-pad" p={[k?-.001:.001,-.25,0]} s={[.018,.08,.075]} c="#334751"/>
  </group>)}
  {bolts([-.12,.12],-.065,.061)}
  {/* Fixed local pneumatic fittings move with the head; no stretching tube. */}
  {[-.065,.065].map(x=><R key={x} p={[x,.025,.118]} r={.011} l={.035} c="#9b895f"/>)}
 </group>
 if(v==='cell3-bench'||v==='cell3-beltbench')return <group name="hard15-machine-pedestal">
  {v==='cell3-beltbench'?<>
   <B name="roller-bed-base" p={[0,h/2-.08,0]} s={[w,.04,d]} c="#6f8896"/>
   {Array.from({length:10},(_,i)=><R key={i} p={[0,h/2-.02,-d/2+.035+i*(d-.07)/9]} r={.02} l={w-.08} axis="x" c="#aabac4"/>)}
   {[-1,1].map(k=><B key={k} p={[k*(w/2-.015),h/2-.032,0]} s={[.03,.064,d]} c="#668799"/>)}
   <R p={[w/2+.04,h/2-.09,.22]} r={.045} l={.12} axis="x" c="#456174"/>
   <B p={[w/2-.015,h/2-.075,.22]} s={[.045,.07,.14]} c="#aabac4"/>
  </>:<B name="single-contact-deck" p={[0,h/2-.0225,0]} s={[w,.045,d]} c="#aeb9bf"/>}
  <group position={[0,-h/2,0]}><MaterialTableLegs halfX={w/2-.05} halfZ={d/2-.05} top={h-(v==='cell3-beltbench'?.10:.045)}/></group>
  <B name="front-sensor-support-crossbar" p={[0,h/2-.065,-d/2+.02]} s={[w-.10,.030,.040]} c="#8296a3"/>
  <B p={[0,.03,d/2-.06]} s={[w-.14,h*.55,.016]} c="#8499a5"/>
  <TendingPlate label={device.label} position={[0,h/2-.085,-d/2-.004]} size={[w-.025,.085]}/>
  {bolts([-.19,.19],-.25,h/2+.001)}
 </group>
 if(v==='cell3-locator')return <group name="hard15-open-stock-nest">
  {[-1,1].map(k=><B key={k} p={[k*.119,-.012,0]} s={[.022,.026,.25]} c="#617c8b"/>)}
  <B p={[0,-.012,.114]} s={[.216,.026,.022]} c="#617c8b"/>
 </group>
 if(v==='cell3-sensor-mount')return <group><B p={[0,0,0]} s={[w,h,d]} c="#6c8694"/><B p={[0,-h/2+.004,0]} s={[w+.026,.008,d+.02]}/></group>
 if(v==='cell3-reflector')return <group><B p={[0,0,0]} s={[w,h,d]} c="#dad4ac"/>{[-.015,0,.015].map(x=><B key={x} p={[x,0,-.0055]} s={[.001,h-.006,.001]} c="#a7a179"/>)}</group>
 if(v==='cell3-residue')return <group ref={moving} name="hard15-retained-residue">{Array.from({length:8},(_,i)=><B key={i} p={[(i%3-1)*.043,0,(Math.floor(i/3)-1)*.043]} s={[.024,.004,.022]} c="#b29a63"/>)}</group>
 if(v==='cell3-wiper')return <group name="hard15-driven-residue-scraper">
  <B p={[-.19,-.012,-.04]} s={[.045,.035,.43]} c="#7893a1"/>
  <R p={[-.19,.011,-.04]} r={.008} l={.43}/>
  <R p={[-.19,.011,.24]} r={.026} l={.075} c="#415f70"/>
  <B p={[-.19,-.01,.18]} s={[.09,.065,.035]} c="#7893a1"/>
  <group ref={moving} position={[0,0,-.19]}>
   <B p={[-.08,.04,0]} s={[.26,.03,.035]} c="#a9b8c1"/>
   <B p={[0,-.015,0]} s={[.13,.08,.022]} c="#ac965d"/>
   <B p={[0,-.080,0]} s={[.16,.045,.018]} c="#415461"/>
  </group>
 </group>
 const kind=v?.replace('cell3-','')
 if(kind==='chamber'||kind==='cage')return <group name={`hard15-${kind}-enclosure`}>
  <B name="rear-guard" p={[0,.13,.04]} s={[.55,.76,.045]} c={kind==='cage'?'#9b795b':'#9bacb5'}/>
  {[-1,1].map(k=><group key={k}>
   <B name="enclosure-upright" p={[k*.26,.13,-.62]} s={[.03,.76,.03]} c="#698694"/>
   <B name="enclosure-upper-side" p={[k*.26,.495,-.29]} s={[.03,.03,.69]} c="#698694"/>
   <mesh name="transparent-side-guard" position={[k*.26,.12,-.29]}><boxGeometry args={[.008,.70,.64]}/><meshStandardMaterial color="#94b4bd" transparent opacity={.18} depthWrite={false} roughness={.5}/></mesh>
  </group>)}
  <B name="front-lower-sill" p={[0,-.21,-.62]} s={[.49,.08,.025]} c="#698694"/>
  <B p={[0,.34,.007]} s={[.28,.14,.012]} c="#273f49"/>
  <TendingPlate label={kind==='cage'?'HOLD / ID':'BATCH / 2'} position={[0,.34,-.001]} size={[.25,.07]}/>
  <R p={[.13,-.08,-.005]} r={.025} l={.025} c="#b7a671"/>
 </group>

 if(['inspect','cell','chamber','magazine','cage','scale','cassette','pouch','can','carrier','kit','feed','out','reel','clean','waste'].includes(kind??''))return <group name={`hard15-${kind}-station-module`}>
  <B p={[0,-.14,0]} s={[.50,.22,.14]} c={kind==='cage'?'#9a674e':'#627f91'}/>
  {[-1,1].map(k=><B key={k} p={[k*.225,.08,0]} s={[.04,.24,.10]} c="#a5b6bf"/>)}
  <B p={[0,.21,0]} s={[.50,.025,.11]}/>
  {['inspect','cell','chamber','magazine'].includes(kind??'')&&<>
   <B p={[0,.045,.015]} s={[.38,.24,.075]} c="#b5c3ca"/>
   <group ref={moving}>
    <B name="service-head-connected-slide" p={[0,.12,-.08]} s={[.075,.045,.25]} c="#9db1bd"/>
    <R p={[0,.06,-.16]} r={.047} l={.075} axis="y" c="#516a78"/>
    <R p={[0,.012,-.16]} r={.019} l={.022} axis="y" c="#374e5b"/>
   </group>
   <B p={[.14,.10,-.035]} s={[.055,.075,.013]} c="#243f4c"/>
  </>}
  {kind==='cage'&&Array.from({length:8},(_,i)=><B key={i} p={[-.175+i*.05,.07,-.05]} s={[.008,.24,.01]} c="#bea980"/>)}
  {kind==='scale'&&<><B p={[0,.10,-.06]} s={[.24,.105,.02]} c="#263d46"/><TendingPlate label="kg / NET" position={[0,.10,-.071]} size={[.20,.065]}/></>}
  {['feed','out','can','pouch','cassette'].includes(kind??'')&&[-.12,0,.12].map(y=><R key={y} p={[0,y,-.078]} r={.025} l={.38} axis="x" c="#acbbc3"/>)}
  {kind==='reel'&&<><R p={[0,.02,-.085]} r={.145} l={.025}/><R p={[0,.02,-.108]} r={.036} l={.025} c="#506779"/></>}
  {kind==='clean'&&<group ref={moving}><B p={[0,.04,-.045]} s={[.30,.028,.022]} c="#d0b466"/><R p={[.15,.10,-.025]} r={.019} l={.12} axis="y"/></group>}
  {kind==='waste'&&<B p={[0,.06,-.056]} s={[.34,.16,.016]} c="#414e56"/>}
  <R p={[-.14,-.10,-.082]} r={.012} l={.028} c="#9b885d"/>
 </group>
 return <B p={[0,0,0]} s={[w,h,d]}/>
}

export function HardStock({id,plant}:{id:number;plant:Plant}){
 const g=useRef<Group>(null),part=plant.parts.find(p=>p.id===id)
 useFrame(()=>{const p=plant.parts.find(p=>p.id===id);if(p&&g.current)g.current.position.set(p.x,p.y??.98,p.z??0)})
 const kind=part?.renderVariant?.replace('hard-stock-',''),color=part?.color??'#ad9159'
 return <group ref={g} name={`hard15-stock-${id}`}>
  {kind==='can'?<><R p={[0,0,0]} r={.078} l={.156} axis="y" c="#b1bcc2"/><R p={[0,.078,0]} r={.068} l={.004} axis="y" c={color}/></>:
   kind==='reel'?<><R p={[0,0,0]} r={.077} l={.13} c={color}/>{[-.073,.073].map(z=><R key={z} p={[0,0,z]} r={.08} l={.014} c="#b2bec4"/>)}</>:
   kind==='pouch'?<><B p={[0,-.005,0]} s={[.16,.15,.10]} c={color}/><B p={[0,.075,0]} s={[.16,.01,.105]} c="#bbc5c8"/>{[-1,1].map(x=><B key={x} p={[x*.04,.078,0]} s={[.022,.004,.04]} c="#929f9e"/>)}</>:
   kind==='component'?<><B p={[0,-.05,0]} s={[.16,.06,.16]} c="#a5b0b6"/>{id%2?<R p={[0,.02,0]} r={.068} l={.12} axis="y" c={color}/>:<><B p={[0,.02,0]} s={[.10,.12,.10]} c={color}/><R p={[0,.075,0]} r={.025} l={.01} axis="y" c="#b7c1c5"/></>}</>:
   kind==='carrier'?<><B p={[0,-.055,0]} s={[.16,.05,.16]} c="#a5b0b6"/>{[-1,1].map(x=><B key={x} p={[x*.065,.015,0]} s={[.03,.13,.15]} c={color}/>)}<B p={[0,.065,.06]} s={[.10,.025,.025]} c={color}/></>:
   <><B p={[0,0,0]} s={[.16,.16,.16]} c={color}/><B p={[0,.081,0]} s={[.13,.002,.13]} c="#c3ccd0"/>{kind==='pouch'&&[-1,1].map(x=><B key={x} p={[x*.078,0,0]} s={[.004,.16,.16]} c="#bbc4ca"/>)}</>}
  <TendingPlate label={`P${id}`} position={[0,.006,kind==='pouch'?-.051:-.081]} size={[.11,.055]}/>
 </group>
}
