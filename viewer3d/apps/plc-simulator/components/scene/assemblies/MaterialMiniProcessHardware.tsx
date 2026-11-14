'use client'
import { SuctionCup } from './SuctionCup'

import {useMemo,useRef,type ReactNode,type ComponentProps} from 'react'
import {useFrame} from '@react-three/fiber'
import {Group,Quaternion,Vector3} from 'three'
import type {DeviceProps} from '../devices'
import type {MaterialHardState} from '@/lib/replay/adapter'
import {Part,RoundPart,FINISH} from './Parts'
import {MaterialContactHardware} from './MaterialContactHardware'
import {BoredHub} from './MaterialV6Details'

type V=[number,number,number]
export type Reader={materialHardState():MaterialHardState|undefined}
const blue='#4b798e',dark='#354c59',silver='#b5c2c9',amber='#bd9559'
export function B({opacity,...p}:ComponentProps<typeof Part>&{opacity?:number}){
 if(opacity===undefined)return <Part {...p}/>
 return <mesh name={p.name} position={p.position}><boxGeometry args={p.size}/><meshStandardMaterial color={p.color} transparent opacity={opacity} depthWrite={false}/></mesh>
}
export function C({position=[0,0,0],...p}:Omit<ComponentProps<typeof RoundPart>,'position'>&{position?:V}){return <RoundPart position={position} {...p}/>}

export function Moving({r,id,scale=false,axis='y',children}:{r:Reader;id:string;scale?:boolean;axis?:'y'|'z';children:ReactNode}){
 const ref=useRef<Group>(null)
 useFrame(()=>{const p=r.materialHardState()?.poses[id],g=ref.current;if(!g)return;g.visible=!!p;if(!p)return;g.position.fromArray(p.pos);g.rotation.set(0,0,0);g.rotation[axis]=p.yaw??0;if(scale&&p.size)g.scale.fromArray(p.size)})
 return <group ref={ref} name={'mini-pose-'+id} userData={id.startsWith('part')?{selectionDisabled:true}:{equipmentUnit:true,deviceDisplayName:id.replace(/_/g,' ')}}>{children}</group>
}
export function Rod({a,b,r=.02,color=silver,name='fixed-pipe'}:{a:V;b:V;r?:number;color?:string;name?:string}){
 const [mid,q,len]=useMemo(()=>{const x=new Vector3(...a),y=new Vector3(...b),d=y.clone().sub(x);return [x.add(y).multiplyScalar(.5),new Quaternion().setFromUnitVectors(new Vector3(0,1,0),d.clone().normalize()),d.length()] as const},[...a,...b])
 return <group position={mid} quaternion={q}><C name={name} radius={r} length={len} axis="y" color={color}/></group>
}
export function Foot({x,z,h=.78}:{x:number;z:number;h?:number}){
 return <group><B name="leveling-foot" position={[x,.035,z]} size={[.24,.07,.24]} color={dark}/><B name="structural-column" position={[x,(h+.07)/2,z]} size={[.075,h-.07,.075]} color={silver}/></group>
}
export function Belt({a,b,width=.42,top=.9}:{a:V;b:V;width?:number;top?:number}){
 const dx=b[0]-a[0],dz=b[2]-a[2],length=Math.hypot(dx,dz),yaw=-Math.atan2(dz,dx)
 return <group userData={{equipmentUnit:true,deviceDisplayName:'Conveyor'}}><group position={[(a[0]+b[0])/2,top,(a[2]+b[2])/2]} rotation={[0,yaw,0]}>
  <B name="conveyor-belt-support" position={[0,-.052,0]} size={[length,.07,width]} color={dark}/>
  <B name="conveyor-supported-contact-surface" position={[0,-.008,0]} size={[length,.016,width-.04]} color="#7c9097"/>
  {[-1,1].map(k=><group key={k}><B name="conveyor-frame-channel" position={[0,-.09,k*(width/2+.015)]} size={[length,.11,.035]} color={silver}/><C name="belt-roller-shaft" position={[k*(length/2-.035),-.035,0]} radius={.028} length={width+.09} color={silver}/><B name="conveyor-bearing" position={[k*(length/2-.035),-.035,width/2+.05]} size={[.085,.075,.05]} color={blue}/></group>)}
  <B name="gear-motor-housing" position={[-length/2+.1,-.055,width/2+.15]} size={[.19,.14,.18]} color={blue}/>
 </group>{[.16,.84].map(t=><Foot key={t} x={a[0]+dx*t} z={a[2]+dz*t} h={top-.08}/>)}</group>
}
export function Solids({r,count,liquid=false}:{r:Reader;count:number;liquid?:boolean}){
 return <>{Array.from({length:count},(_,j)=>{const i=j+1,part=r.materialHardState()?.parts[String(i)],col=part?.kind===2?amber:part?.kind===3?silver:blue
  return <group key={i}><Moving r={r} id={'part'+i} scale>{liquid?<group>
   <B name={'vessel-'+i+'-bottom'} position={[0,-.48,0]} size={[1,.04,1]} color={silver}/>
   {[-1,1].map(k=><group key={k}><B name="vessel-wall" position={[k*.485,0,0]} size={[.03,1,1]} color="#a9c5cb" opacity={.22}/><B name="vessel-wall" position={[0,0,k*.485]} size={[.94,1,.03]} color="#a9c5cb" opacity={.22}/><B name="vessel-top-rim" position={[k*.48,.49,0]} size={[.05,.03,1]} color={silver}/></group>)}
  </group>:<B name={'workpiece-'+i} size={[1,1,1]} color={col}/>}
  <B name="workpiece-id-mark" position={liquid?[0,.12,.504]:[0,.506,0]} size={liquid?[.27,.16,.008]:[.27,.01,.22]} color={liquid?blue:'#e3e9eb'}/>
 </Moving>{liquid&&<Moving r={r} id={'level'+i} scale><B name={'vessel-liquid-'+i} size={[1,1,1]} color="#68a9aa" opacity={.78}/></Moving>}</group>
 })}</>
}

function Index({r}:{r:Reader}){
 const a=5*Math.PI/3
 return <>
  <B name="index-machine-plinth" position={[0,.09,0]} size={[1.45,.18,1.45]} color={dark}/><C name="index-transmission" position={[0,.49,0]} radius={.43} length={.63} axis="y" color={blue}/>
  <Moving r={r} id="table"><C name="common-six-pocket-table" radius={1.46} length={.09} axis="y" color={silver}/><C name="rotary-central-cover" position={[0,.06,0]} radius={.28} length={.025} axis="y" color={dark}/>
  {Array.from({length:6},(_,j)=>{const t=j*Math.PI/3;return <group key={j} position={[1.22*Math.cos(t),.064,1.22*Math.sin(t)]} rotation={[0,-t,0]}>{[-1,1].map(k=><B key={k} name="open-ended-pocket-guide" position={[0,0,k*.16]} size={[.34,.035,.028]} color={blue}/>)}<B name="pocket-position-marker" position={[-.24,-.01,0]} size={[.065,.012,.11]} color={j%2?amber:blue}/></group>})}</Moving>
  {(['a','b'] as const).map((s,j)=>{const sign=j===0?1:-1;return <group key={s}>
   <Belt a={[sign*1.46,.9,0]} b={[sign*3.85,.9,0]} width={.4}/>
   <B name="infeed-servo-drive" position={[sign*1.72,.79,.40]} size={[.22,.20,.20]} color={blue}/>
   <Rod a={[sign*1.72,.84,.17]} b={[sign*1.72,.84,.37]} r={.025}/>

  </group>})}
  {(['a','b'] as const).map((s,j)=>{const t=(j===0?1:4)*Math.PI/3,x=1.22*Math.cos(t),z=1.22*Math.sin(t),ox=1.88*Math.cos(t),oz=1.88*Math.sin(t);return <group key={s}>
   <Foot x={ox-.2} z={oz} h={2.02}/><Foot x={ox+.2} z={oz} h={2.02}/>
   <B name="local-station-column-crossmember" position={[ox,1.98,oz]} size={[.48,.12,.12]} color={dark}/>
   <Rod a={[ox,1.98,oz]} b={[x,1.98,z]} r={.075} color={dark}/><B name="local-station-servo" position={[x,1.83,z]} size={[.19,.32,.19]} color={blue}/>
   <Moving r={r} id={'head_'+s}><B name="service-foot" size={[.20,.13,.20]} color={dark}/></Moving>
   <RecordedRod r={r} id={'head_'+s} anchor={[x,1.69,z]} offset={[0,.065,0]} radius={.028}/>

  </group>})}
  <Belt a={[1.46*Math.cos(a),.9,1.46*Math.sin(a)]} b={[5.9*Math.cos(a),.9,5.9*Math.sin(a)]} width={.41}/>
  <group position={[.6*Math.cos(a),.98,.6*Math.sin(a)]} rotation={[0,-a,0]}><B name="radial-ejector-housing" size={[.35,.13,.16]} color={blue}/></group>
  <Moving r={r} id="ejector"><B name="radial-ejector-shoe" size={[.055,.13,.25]} color={silver}/></Moving>
  <RecordedRod r={r} id="ejector" anchor={[.78*Math.cos(a),.98,.78*Math.sin(a)]}/>
  <Solids r={r} count={6}/>
 </>
}
export function RecordedRod({r,id,anchor,offset=[0,0,0],radius=.019}:{r:Reader;id:string;anchor:V;offset?:V;radius?:number}){
 const ref=useRef<Group>(null)
 useFrame(()=>{const p=r.materialHardState()?.poses[id],g=ref.current;if(!p||!g)return;const a=new Vector3(...anchor),b=new Vector3(...p.pos).add(new Vector3(...offset)),d=b.clone().sub(a);g.position.copy(a.add(b).multiplyScalar(.5));g.quaternion.setFromUnitVectors(new Vector3(0,1,0),d.clone().normalize());g.scale.y=Math.max(.001,d.length())})
 return <group ref={ref}><C name="connected-actuator-rod" radius={radius} length={1} axis="y" color={silver}/></group>
}
function WebSpan({r,index}:{r:Reader;index:number}){
 const ref=useRef<Group>(null)
 useFrame(()=>{const ps=r.materialHardState()?.web_path,g=ref.current;if(!ps||!g||!ps[index+1])return;const a=ps[index],b=ps[index+1];g.position.set((a[0]+b[0])/2,(a[1]+b[1])/2,0);g.rotation.z=Math.atan2(b[1]-a[1],b[0]-a[0]);g.scale.x=Math.hypot(b[0]-a[0],b[1]-a[1])})
 return <group ref={ref}><B name="continuous-stored-web" size={[1,.007,.28]} color={amber}/></group>
}
export function Web({r,endX=5.55,count=4}:{r:Reader;endX?:number;count?:number}){
 return <>
  <Foot x={-3.35} z={-.30} h={1.05}/><B name="roll-bearing-housing" position={[-3.35,1.05,-.25]} size={[.20,.18,.16]} color={blue}/><Rod a={[-3.35,1.05,-.33]} b={[-3.35,1.05,.24]} r={.05}/>
  <Moving r={r} id="source" scale axis="z"><C name="unwind-material-roll" radius={1} length={1} color={amber}/>{[-1,1].map(k=><C key={k} position={[0,0,k*.53]} radius={1.06} length={.035} color={silver}/>)}<B position={[.5,0,.56]} size={[.75,.04,.02]} color={dark}/></Moving>
  <Belt a={[-3.05,.9,0]} b={[-1.4,.9,0]} width={.44}/><B name="web-infeed-span" position={[-2.28,.908,0]} size={[1.55,.007,.28]} color={amber}/>
  <B name="feed-linear-guide" position={[-2.25,1.11,-.29]} size={[1.1,.08,.08]} color={blue}/><B name="feed-drive-motor" position={[-2.85,1.11,-.29]} size={[.20,.14,.15]} color={blue}/>
  <Moving r={r} id="feed"><B name="feed-crosshead" position={[0,.05,-.12]} size={[.18,.065,.35]} color={silver}/><B name="feed-grip-cylinder" position={[0,.13,0]} size={[.10,.16,.10]} color={blue}/></Moving>
  <FeedGripRod r={r}/>
  <Moving r={r} id="feed_grip"><B name="moving-web-grip" size={[.16,.04,.33]} color={blue}/></Moving>
  {[-.52,.52].map(x=><Foot key={x} x={x} z={-.32} h={2.17}/>)}<B position={[0,2.17,-.32]} size={[1.16,.1,.1]} color={dark}/>
  {[-.25,.25].map(x=><group key={x}><Rod a={[x,1.95,-.32]} b={[x,1.95,.20]} r={.017}/><C position={[x,1.95,0]} radius={.03} length={.34} color={silver}/></group>)}
  <Moving r={r} id="dancer"><B name="dancer-crosshead" position={[0,0,-.30]} size={[1.05,.075,.1]} color={blue}/>{[-.216,.216].map(x=><group key={x}><Rod a={[x,0,-.3]} b={[x,0,.18]} r={.017}/><C name="dancer-roller" position={[x,0,0]} radius={.03} length={.34} color={silver}/></group>)}</Moving>
  {Array.from({length:19},(_,i)=>i).map(i=><WebSpan key={i} r={r} index={i}/>)}
  <Ribbon a={[-1.4,.908,0]} b={[-.25,1.95,0]}/><Ribbon a={[.25,1.95,0]} b={[1.25,.908,0]}/>
  <Belt a={[1.0,.9,0]} b={[endX,.9,0]} width={.43}/>
  {[-1,1].map(k=><group key={k}><Foot x={1.8} z={k*.33} h={1.55}/><B position={[1.8,1.5,k*.23]} size={[.32,.1,.20]} color={dark}/></group>)}
  <B name="cutting-crossbeam" position={[1.8,1.55,0]} size={[.30,.12,.76]} color={blue}/>
  <B name="hold-down-support-arm" position={[1.64,1.50,0]} size={[.36,.07,.12]} color={silver}/>
  <B name="hold-down-cylinder" position={[1.55,1.32,0]} size={[.105,.30,.105]} color={blue}/>
  <B name="cutting-cylinder" position={[1.8,1.41,0]} size={[.12,.23,.12]} color={blue}/>
  <RecordedRod r={r} id="holder" anchor={[1.55,1.18,0]} offset={[0,.03,0]}/>
  <RecordedRod r={r} id="blade" anchor={[1.8,1.31,0]} offset={[0,.07,0]}/>
  <Moving r={r} id="holder"><B name="actual-web-hold-down" size={[.14,.06,.35]} color={dark}/></Moving>
  <Moving r={r} id="blade"><B name="guided-cutting-blade" size={[.018,.14,.33]} color={silver}/></Moving>
  <C name="draw-nip-lower" position={[1.25,.867,0]} radius={.032} length={.35} color={silver}/><C name="draw-nip-upper" position={[1.25,.944,0]} radius={.032} length={.35} color={dark}/>
  <B position={[1.25,.89,.33]} size={[.17,.15,.19]} color={blue}/><Rod a={[1.25,.867,.16]} b={[1.25,.867,.32]} r={.015}/>
  <Moving r={r} id="strip" scale><B name="uncut-projected-web" size={[1,1,1]} color={amber}/></Moving>

  <Solids r={r} count={count}/>
 </>
}
function Ribbon({a,b}:{a:V;b:V}){
 const angle=Math.atan2(b[1]-a[1],b[0]-a[0]);return <group position={[(a[0]+b[0])/2,(a[1]+b[1])/2,0]} rotation={[0,0,angle]}><B name="supported-web-connection" size={[Math.hypot(b[0]-a[0],b[1]-a[1]),.007,.28]} color={amber}/></group>
}
function FeedGripRod({r}:{r:Reader}){
 const ref=useRef<Group>(null)
 useFrame(()=>{const s=r.materialHardState(),p=s?.poses.feed_grip,feed=s?.poses.feed;if(!p||!feed||!ref.current)return;const top=feed.pos[1]+.06,bottom=p.pos[1]+.02;ref.current.position.set(p.pos[0],(top+bottom)/2,0);ref.current.scale.y=Math.max(.001,top-bottom)})
 return <group ref={ref}><C name="feed-grip-connected-piston" radius={.014} length={1} axis="y" color={silver}/></group>
}
function TankSight({r}:{r:Reader}){
 const ref=useRef<Group>(null)
 useFrame(()=>{const p=r.materialHardState()?.poses.tank_level;if(!p||!ref.current)return;const h=p.size?.[1]??.01;ref.current.position.set(.399,.35+h/2,1.35);ref.current.scale.y=h})
 return <><B name="tank-sight-gauge-backing" position={[.405,.76,1.35]} size={[.055,.86,.06]} color={silver}/><group ref={ref}><B name="tank-liquid-level-sight" size={[.010,1,.034]} position={[.035,0,0]} color="#438e93"/></group>{[.36,1.16].map(y=><Rod key={y} a={[.33,y,1.35]} b={[.46,y,1.35]} r={.013}/>)}</>
}
function Liquid({r}:{r:Reader}){
 return <>
  <B name="tank-skid" position={[0,.08,1.75]} size={[1.3,.16,2.1]} color={dark}/>
  <group position={[0,.35,1.35]}><BoredHub p={[0,.42,0]} outer={.38} inner={.34} height={.84}/><C position={[0,0,0]} radius={.38} length={.03} axis="y" color={silver}/><C position={[0,.87,0]} radius={.40} length={.045} axis="y" color={silver}/></group>
  <TankSight r={r}/>
  <C name="refill-reservoir" position={[0,1.2,2.5]} radius={.38} length={1.35} axis="y" color={silver}/><Foot x={-.28} z={2.5} h={.6}/><Foot x={.28} z={2.5} h={.6}/>
  <Rod a={[0,1.70,2.5]} b={[0,1.70,1.35]} r={.024}/><Rod a={[0,1.70,1.35]} b={[0,1.20,1.35]} r={.024}/><B name="refill-valve-body" position={[0,1.70,1.95]} size={[.14,.13,.19]} color={blue}/>
  {(['a','b'] as const).map((s,j)=>{const x=j===0?-1.3:1.3,px=j===0?-.65:.65;return <group key={s}>
   <Belt a={[x,.8,2.4]} b={[x,.8,-3.7]} width={.44} top={.8}/>
   <B name="pump-mount" position={[px,.24,.92]} size={[.45,.30,.55]} color={dark}/><C name="independent-metering-pump" position={[px,.49,.92]} radius={.15} length={.36} axis="z" color={blue}/>
   <Rod a={[0,.43,1.35]} b={[px,.43,1.35]} r={.022}/><Rod a={[px,.43,1.35]} b={[px,.49,1.1]} r={.022}/>
   <Rod a={[px,.49,.73]} b={[px,1.73,.73]} r={.015} color="#769496"/><Rod a={[px,1.73,.73]} b={[x,1.73,.73]} r={.015} color="#769496"/>
   <Foot x={x+.35} z={.28} h={1.82}/><B name="nozzle-supported-overarm" position={[x+.175,1.78,.28]} size={[.50,.10,.09]} color={silver}/><Rod a={[x,1.73,.15]} b={[x,1.09,.15]} r={.009}/><NozzlePiston r={r} node={'nozzle_'+s}/><B name="nozzle-guided-slide" position={[x,1.78,.24]} size={[.16,.12,.5]} color={blue}/>
   <Moving r={r} id={'nozzle_'+s}><B name="nozzle-carriage" position={[0,.08,.15]} size={[.16,.14,.16]} color={blue}/><C name="rigid-nozzle" position={[0,0,0]} radius={.018} length={.19} axis="y" color={silver}/><Rod a={[0,.08,.15]} b={[0,.085,0]} r={.014}/></Moving>
   <FlexibleService r={r} node={'nozzle_'+s} x={x}/>
   <B name="fixture-fixed-jaw" position={[x-.21,.97,0]} size={[.10,.13,.24]} color={dark}/><B name="fixture-side-cylinder" position={[x+.36,.97,0]} size={[.18,.12,.12]} color={blue}/>
   <B name="fixture-fixed-jaw-mount" position={[x-.275,.855,0]} size={[.055,.13,.16]} color={silver}/>
   <Moving r={r} id={'clamp_'+s}><B name="fixture-moving-jaw" size={[.045,.13,.24]} color={dark}/></Moving>
   <RecordedRod r={r} id={'clamp_'+s} anchor={[x+.28,.97,0]} offset={[.0225,0,0]} radius={.014}/>
   <B name="fixture-cylinder-mount" position={[x+.36,.845,0]} size={[.13,.13,.16]} color={silver}/>
   <B name="fixture-mount-outrigger" position={[x+.23,.76,0]} size={[.39,.065,.20]} color={silver}/>
   <Moving r={r} id={'flow_'+s} scale><B name="nozzle-liquid-stream" size={[1,1,1]} color="#79aaa7" opacity={.6}/></Moving>

  </group>})}
  <Solids r={r} count={4} liquid/>
 </>
}
function NozzlePiston({r,node}:{r:Reader;node:string}){
 const ref=useRef<Group>(null)
 useFrame(()=>{const p=r.materialHardState()?.poses[node];if(!p||!ref.current)return;const lower=p.pos[1]+.15,upper=1.73;ref.current.position.set(p.pos[0],(lower+upper)/2,.15);ref.current.scale.y=Math.max(.001,upper-lower)})
 return <group ref={ref}><C name="nozzle-connected-lift-piston" radius={.015} length={1} axis="y" color={silver}/></group>
}
function FlexibleService({r,node,x}:{r:Reader;node:string;x:number}){
 // Short articulated service loop outside the nozzle travel/fixture volumes.
 const refs=[useRef<Group>(null),useRef<Group>(null),useRef<Group>(null)]
 useFrame(()=>{const p=r.materialHardState()?.poses[node];if(!p)return;const pts:V[]=[[x,1.73,.73],[x+.12,1.93,.63],[x+.12,p.pos[1]+.20,.39],[x,p.pos[1]+.08,.15]];refs.forEach((ref,i)=>{const g=ref.current;if(!g)return;const a=new Vector3(...pts[i]),b=new Vector3(...pts[i+1]),v=b.clone().sub(a);g.position.copy(a.add(b).multiplyScalar(.5));g.quaternion.setFromUnitVectors(new Vector3(0,1,0),v.clone().normalize());g.scale.y=v.length()})})
 return <>{refs.map((ref,i)=><group key={i} ref={ref}><C name="local-flexible-fluid-service" radius={.009} length={1} axis="y" color="#577d83"/></group>)}</>
}
function Stack({r}:{r:Reader}){
 return <>
  {[-1.3,0,1.3].map((x,j)=><group key={x}>
   <Belt a={[x,.9,-2.75]} b={[x,.9,-2.05]} width={.51}/>
   {[-1,1].map(k=><group key={k}><Foot x={x+k*.26} z={-2.55} h={1.3}/><B name="magazine-side-guide" position={[x+k*.23,1.06,-2.4]} size={[.025,.31,.38]} color={silver}/></group>)}

  </group>)}
  {[-1.85,1.85].map(x=><group key={x}><Foot x={x} z={-2.6} h={2.2}/><Foot x={x} z={-1.0} h={2.2}/><B name="feed-gantry-longitudinal-rail" position={[x,2.2,-1.8]} size={[.09,.12,1.8]} color={blue}/></group>)}
  <FeedBridge r={r}/>
  <Moving r={r} id="feed_head"><B name="single-sheet-vacuum-tool" size={[.28,.04,.20]} color={blue}/>{[-.08,.08].map(x=><SuctionCup key={x} name="sheet-tool-suction-pad" position={[x,-.017,0]} radius={.035} height={.012}/>)}</Moving>
  <Belt a={[0,.9,-1.1]} b={[0,.9,-.56]} width={.45}/><C name="supported-Y-junction-transfer-deck" position={[0,.875,-.25]} radius={.34} length={.046} axis="y" color={silver}/><Foot x={0} z={-.25} h={.84}/>
  {[-1.3,1.3].map((x,j)=>{const s=j===0?'a':'b';return <group key={s}>
   <Belt a={[x*.25,.9,-.05]} b={[x,.9,.55]} width={.44}/><Belt a={[x,.9,.55]} b={[x,.9,.70]} width={.44}/>
   <B name="stack-lift-base" position={[x,.08,1]} size={[.70,.16,.70]} color={dark}/><B name="stack-lift-cylinder" position={[x,.36,1]} size={[.22,.40,.22]} color={blue}/>
   <Moving r={r} id={'lift_'+s}><B name="stack-support-deck" size={[.60,.07,.55]} color={silver}/></Moving>
   <RecordedRod r={r} id={'lift_'+s} anchor={[x,.55,1]} offset={[0,-.035,0]} radius={.04}/>
   <Moving r={r} id={'pallet_'+s}><B name="material-pallet-deck" size={[.54,.06,.48]} color={blue}/>{[-.16,.16].map(k=><B key={k} name="pallet-runner" position={[k,-.04,0]} size={[.055,.02,.46]} color={dark}/>)}</Moving>
   <Belt a={[x,.66,1.30]} b={[x,.66,2.3]} width={.6} top={.66}/>

  </group>})}
  <Belt a={[-1.75,.61,2.3]} b={[5.15,.61,2.3]} width={.62} top={.61}/>
  {[4.1,4.8].map(x=><Belt key={x} a={[x,.66,2.3]} b={[x,.66,3.75]} width={.6} top={.66}/>)}
  {[-1.3,1.3,2.8,4.1,4.8].map(x=><group key={x}><B name="cross-transfer-drive-housing" position={[x,.43,2.72]} size={[.24,.20,.20]} color={blue}/><Rod a={[x,.53,2.52]} b={[x,.53,2.68]} r={.025}/></group>)}
  <Solids r={r} count={8}/>
 </>
}
function FeedBridge({r}:{r:Reader}){
 const beam=useRef<Group>(null),slide=useRef<Group>(null),rod=useRef<Group>(null)
 useFrame(()=>{const p=r.materialHardState()?.poses.feed_head;if(!p)return;beam.current?.position.set(0,2.19,p.pos[2]);slide.current?.position.set(p.pos[0],2.19,p.pos[2]);if(rod.current){const len=2.15-p.pos[1]-.025;rod.current.position.set(p.pos[0],p.pos[1]+.025+len/2,p.pos[2]);rod.current.scale.y=Math.max(.01,len)}})
 return <><group ref={beam}><B name="gantry-crossbeam" size={[3.78,.12,.12]} color={silver}/></group><group ref={slide}><B name="feed-servo-slide" size={[.23,.22,.22]} color={blue}/></group><group ref={rod}><C name="connected-vacuum-axis" radius={.023} length={1} axis="y" color={silver}/></group></>
}

export function MaterialMiniProcessHardware({device,plant}:DeviceProps){
 const r=plant as unknown as Reader,mode=device.visualVariant?.replace('cell3-mini-','')
 if(r.materialHardState()?.contact)return <MaterialContactHardware device={device} plant={plant}/>
 const poses=r.materialHardState()?.poses??{}
 const hasRigPose=Object.keys(poses).some(key=>!/^part\d+$/.test(key))
 const canonicalMode=hasRigPose||mode==='web'?mode:'recorded-transport'
 return <group name={'material-miniprocess-'+mode}>
  {canonicalMode==='index'?<Index r={r}/>:canonicalMode==='web'?<Web r={r}/>:canonicalMode==='liquid'?<Liquid r={r}/>:canonicalMode==='stack'?<Stack r={r}/>:<RecordedTransport r={r} plant={plant}/>}
 </group>
}

function RecordedTransportStock({r,id}:{r:Reader;id:string}){
 const ref=useRef<Group>(null)
 useFrame(()=>{const pose=r.materialHardState()?.poses[`part${id}`],g=ref.current;if(!g)return;g.visible=!!pose;if(pose){g.position.fromArray(pose.pos);g.scale.fromArray(pose.size??[.20,.10,.20])}})
 return <group ref={ref} name={`recorded-hard-stock-${id}`}><B name="physical-workpiece" size={[1,1,1]} color={Number(id)%2?'#c4a46a':'#84a5ad'}/></group>
}

function RecordedTransport({r,plant}:{r:Reader;plant:DeviceProps['plant']}){
 const stations=plant.machine.devices.filter(device=>device.id!=='MATERIAL_CELL'&&device.pos)
 const ids=Object.keys(r.materialHardState()?.parts??{}).filter(id=>/^\d+$/.test(id))
 return <group name="recorded-transport-layout">
  {stations.map(station=><group key={station.id} position={station.pos}>
   <B name={`station-${station.id}`} position={[0,-.04,0]} size={[.38,.08,.38]} color="#658291"/>
   <B name="support-column" position={[0,-.43,0]} size={[.07,.78,.07]} color="#455d6b"/>
  </group>)}
  {ids.map(id=><RecordedTransportStock key={id} r={r} id={id}/>)}
 </group>
}
