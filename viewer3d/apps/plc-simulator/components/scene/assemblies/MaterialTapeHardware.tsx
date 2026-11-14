'use client'

import {useMemo,useRef,type ReactNode} from 'react'
import {useFrame} from '@react-three/fiber'
import {Group,Quaternion,Vector3} from 'three'
import type {DeviceProps} from '../devices'
import type {MaterialHardState} from '@/lib/replay/adapter'
import geometry from '@/lib/replay/materialTapeGeometry.json'
import {MaterialTableLegs} from './MaterialTableLegs'
import {Part,RoundPart} from './Parts'

const tapeNames:Record<string,string>={ROLL:'Raw material supply roll',STOCK:'Remaining leading-edge stopper',FEED:'Reciprocating feed gripper',CUTTER:'Guided cutter',PICKUP:'Lift pickup and horizontal slide',RECEIVER:'Cut-piece receiving support'}
const selection=(id:string)=>({selectionDeviceId:id,deviceDisplayName:tapeNames[id]})
type V=[number,number,number]
type Reader={materialHardState():MaterialHardState|undefined}
const silver='#afbec6',dark='#344b57',blue='#4c8193',tape='#c4995e'
function Box({name,p=[0,0,0],s,c=silver}:{name:string;p?:V;s:V;c?:string}){
 return <Part name={name} position={p} size={s} color={c}/>
}
function Shaft({name,p,r,l,axis='z',c=silver}:{name:string;p:V;r:number;l:number;axis?:'x'|'y'|'z';c?:string}){
 return <RoundPart name={name} position={p} radius={r} length={l} axis={axis} color={c}/>
}
function Moving({r,id,scaled=false,children}:{r:Reader;id:string;scaled?:boolean;children:ReactNode}){
 const ref=useRef<Group>(null)
 useFrame(()=>{const p=r.materialHardState()?.poses[id],g=ref.current;if(!g)return;g.visible=!!p;if(!p)return;g.position.fromArray(p.pos);if(scaled&&p.size)g.scale.fromArray(p.size)})
 return <group ref={ref} name={'tape-moving-'+id} userData={selection(({clamp:'STOCK',grip:'FEED',blade:'CUTTER',pad:'PICKUP'} as Record<string,string>)[id]??'')}>{children}</group>
}
function Link({name,a,b,radius=.012,c=silver}:{name:string;a:V;b:V;radius?:number;c?:string}){
 const [mid,q,l]=useMemo(()=>{const x=new Vector3(...a),y=new Vector3(...b),d=y.clone().sub(x);return [x.add(y).multiplyScalar(.5),new Quaternion().setFromUnitVectors(new Vector3(0,1,0),d.clone().normalize()),d.length()] as const},[...a,...b])
 return <group position={mid} quaternion={q}><Shaft name={name} p={[0,0,0]} r={radius} l={l} axis="y" c={c}/></group>
}
function PickupDrive({r}:{r:Reader}){
 const slide=useRef<Group>(null),stem=useRef<Group>(null)
 useFrame(()=>{const p=r.materialHardState()?.poses.pad;if(!p)return;slide.current?.position.set(p.pos[0],0,0)
  if(stem.current){const lo=p.pos[1]+.062,hi=1.48;stem.current.position.set(p.pos[0],(lo+hi)/2,0);stem.current.scale.y=hi-lo}})
 return <>
  <group ref={slide} name="tape-pickup-carriage">
   <Box name="gantry-saddle" p={[0,1.65,-.38]} s={[.19,.13,.17]} c={blue}/>
   <Box name="cantilever-arm" p={[0,1.62,-.14]} s={[.085,.07,.38]} c={silver}/>
   <Box name="lift-cylinder-body" p={[0,1.49,0]} s={[.105,.27,.105]} c={blue}/>
   <Shaft name="lift-top-cap" p={[0,1.635,0]} r={.037} l={.02} axis="y" c={dark}/>
  </group>
  <group ref={stem}><Shaft name="continuous-lift-rod" p={[0,0,0]} r={.016} l={1} axis="y"/></group>
 </>
}
function FeedDrive({r}:{r:Reader}){
 const ref=useRef<Group>(null)
 useFrame(()=>{const p=r.materialHardState()?.poses.grip;if(p)ref.current?.position.set(p.pos[0],0,0)})
 return <group ref={ref} name="tape-feed-carriage">
  {[.20,.40].map(z=><Box key={z} name="linear-bearing-saddle" p={[0,.849,z]} s={[.07,.045,.055]} c={blue}/>)}
  {[.20,.40].map(z=><Box key={'riser'+z} name="carriage-side-riser" p={[0,.813,z]} s={[.045,.027,.05]} c={dark}/>)}
  <Box name="under-bed-feed-bridge" p={[0,.791,0]} s={[.065,.018,.87]} c={dark}/>
  <Box name="lower-grip-tongue" p={[0,.808,0]} s={[.065,.024,.062]} c={silver}/>
  <Box name="grip-cylinder" p={[0,.846,-.40]} s={[.065,.07,.22]} c={blue}/>
  <Box name="grip-cylinder-mount" p={[0,.81,-.40]} s={[.06,.025,.08]} c={dark}/>
 </group>
}
function CylinderLink({r,id,z}:{r:Reader;id:string;z:number}){
 const ref=useRef<Group>(null)
 useFrame(()=>{const p=r.materialHardState()?.poses[id];if(!p||!ref.current)return;const bottom=p.pos[1]+.018,top=1.035;ref.current.position.set(p.pos[0],(bottom+top)/2,z);ref.current.scale.y=top-bottom})
 return <group ref={ref}><Shaft name={id+'-connected-rod'} p={[0,0,0]} r={.010} l={1} axis="y"/></group>
}
function GripRod({r}:{r:Reader}){
 const ref=useRef<Group>(null)
 useFrame(()=>{const p=r.materialHardState()?.poses.grip;if(!p||!ref.current)return;const end=p.pos[2]-.08,start=-.42;ref.current.position.set(p.pos[0],p.pos[1],(start+end)/2);ref.current.scale.z=end-start})
 return <group ref={ref}><Shaft name="horizontal-grip-rod" p={[0,0,0]} r={.01} l={1} axis="z"/></group>
}
function CutterDrive({r}:{r:Reader}){
 const ref=useRef<Group>(null)
 useFrame(()=>{const p=r.materialHardState()?.poses.blade;if(!p||!ref.current)return;const lo=p.pos[1]+.1325,hi=1.73;ref.current.position.set(p.pos[0],(lo+hi)/2,0);ref.current.scale.y=hi-lo})
 return <group ref={ref}><Shaft name="continuous-cutter-rod" p={[0,0,0]} r={.017} l={1} axis="y"/></group>
}
function FlatWeb(){
 const a=new Vector3(-1.36705,1.21044,0),b=new Vector3(-1.15,.823,0),d=b.clone().sub(a)
 return <group position={a.add(b).multiplyScalar(.5)} rotation={[0,0,Math.atan2(d.y,d.x)]}><Box name="roll-web-tangent" s={[d.length(),.006,.14]} c={tape}/></group>
}
export function MaterialTapeHardware({plant}:DeviceProps){
 const r=plant as unknown as Reader
 return <group name="material-tape-cell-r1">
  <MaterialTableLegs x={-.20} halfX={1.58} halfZ={.43} top={.70}/>
  {geometry.boxes.filter(b=>!['table-leg','leveling-foot','table-stretcher'].includes(b.name)).map((b,i)=><Box key={i} name={b.name} p={b.pos as V} s={b.size as V} c={b.color}/>)}
  <group userData={selection('ROLL')}><Shaft name="supply-roll" p={[-1.60,1.08,0]} r={.267} l={.16} c={tape}/></group>
  {[-.093,.093].map(z=><group key={z}><Shaft name="roll-flange" p={[-1.60,1.08,z]} r={.286} l={.009}/><Shaft name="roll-flange-hub" p={[-1.60,1.08,z*1.17]} r={.062} l={.034} c={blue}/></group>)}
  <Shaft name="roll-axle" p={[-1.60,1.08,0]} r={.027} l={.48}/>
  <FlatWeb/>
  <Moving r={r} id="leader" scaled><Box name="remaining-stock-web" s={[1,1,1]} c={tape}/></Moving>
  <Moving r={r} id="strip" scaled><Box name="actual-connected-or-separated-strip" s={[1,1,1]} c={tape}/></Moving>
  <Moving r={r} id="clamp"><Box name="stock-clamp-foot" s={[.07,.04,.16]} c={dark}/><Box name="stock-clamp-link" p={[0,.018,-.135]} s={[.07,.02,.22]}/></Moving>
  <Moving r={r} id="grip"><Box name="feed-grip-jaw" s={[.065,.04,.16]} c={dark}/></Moving>
  <FeedDrive r={r}/><GripRod r={r}/><CylinderLink r={r} id="clamp" z={-.20}/>
  <Moving r={r} id="blade"><Box name="guillotine-blade" p={[0,.055,0]} s={[.012,.11,.18]}/><Box name="blade-holder" p={[0,.12,0]} s={[.07,.025,.25]} c={dark}/></Moving>
  <CutterDrive r={r}/><PickupDrive r={r}/>
  <Moving r={r} id="pad">
   <Box name="vacuum-pickup-block" p={[0,.044,0]} s={[.095,.04,.075]} c={blue}/>
   <Box name="vacuum-contact-pad" p={[0,.012,0]} s={[.08,.024,.06]} c={dark}/>
   <Shaft name="local-vacuum-port" p={[.055,.046,0]} r={.009} l={.035} axis="x"/>
   <Link name="local-fixed-vacuum-tube" a={[.07,.046,0]} b={[.07,.09,0]} radius={.006} c={dark}/>
   <Link name="local-fixed-vacuum-tube" a={[.07,.09,0]} b={[.015,.09,0]} radius={.006} c={dark}/>
   <Shaft name="pad-port-manifold" p={[.015,.075,0]} r={.012} l={.03} axis="y" c={blue}/>
  </Moving>
  {[-.68,1.34].flatMap(x=>[-.018,.018].map(dx=><Shaft key={x+dx} name="gantry-foot-bolt" p={[x+dx,.788,-.38]} r={.007} l={.012} axis="y" c={dark}/>))}
 </group>
}
