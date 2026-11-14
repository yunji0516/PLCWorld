'use client'
import {useRef} from 'react'
import {useFrame} from '@react-three/fiber'
import {Group} from 'three'
import type {DeviceProps} from '../devices'
import type {MaterialHardState} from '@/lib/replay/adapter'
import geometry from '@/lib/replay/materialReplenishmentGeometry.json'
import {Part,RoundPart} from './Parts'
type V=[number,number,number]
type Reader={materialHardState():MaterialHardState|undefined}
function Moving({r,id,scale=false,children}:{r:Reader;id:string;scale?:boolean;children:React.ReactNode}){
 const ref=useRef<Group>(null)
 useFrame(()=>{const p=r.materialHardState()?.poses[id];if(!ref.current)return;ref.current.visible=!!p;if(!p)return;ref.current.position.fromArray(p.pos);if(scale&&p.size)ref.current.scale.fromArray(p.size)})
 return <group ref={ref}>{children}</group>
}
function Extractor({r,s,x}:{r:Reader;s:string;x:number}){
 const moving=useRef<Group>(null),left=useRef<Group>(null),right=useRef<Group>(null)
 useFrame(()=>{const p=r.materialHardState()?.poses['feed_'+s];if(p){moving.current?.position.set(x,0,p.pos[2]);const opening=p.size?.[0]??1;left.current?.position.set(-.10*opening,0,0);right.current?.position.set(.10*opening,0,0)}})
 return <group ref={moving}>
  <Part name="extractor-moving-crossbar" position={[0,1.62,0]} size={[1.18,.06,.10]} color="#4c8193"/>
  {[-1,1].map(sign=><group key={sign} ref={sign<0?left:right}>
   <Part name="extractor-vertical-link" position={[sign*.40,1.385,0]} size={[.025,.41,.055]}/>
   <Part name="extractor-side-arm" position={[sign*.32,1.17,0]} size={[.18,.02,.07]}/>
   <Part name="edge-contact-jaw" position={[sign*.24,1.12,0]} size={[.02,.06,.07]} color="#344b57"/>

  </group>)}
  {[-.55,.55].map(dx=><Part key={dx} name="carriage-bearing" position={[dx,1.55,0]} size={[.10,.10,.14]} color="#4c8193"/>)}
 </group>
}
function LiftRod({r,s,x}:{r:Reader;s:string;x:number}){
 const ref=useRef<Group>(null)
 useFrame(()=>{const p=r.materialHardState()?.poses['lift_'+s];if(!p||!ref.current)return;const top=p.pos[1]-.03;ref.current.position.set(x,(top+.88)/2,0);ref.current.scale.y=top-.88})
 return <group ref={ref}><RoundPart name="continuous-magazine-lift-rod" position={[0,0,0]} radius={.023} length={1} axis="y"/></group>
}
export function MaterialReplenishmentHardware({plant}:DeviceProps){
 const r=plant as unknown as Reader
 return <group name="material-h08-replenishment-r7">
  {geometry.boxes.map((b,i)=><Part key={i} name={b.name} position={b.pos as V} size={b.size as V} color={b.color}/>)}
  {([-1.6,1.6] as const).map((x,i)=><group key={x}>
   <Moving r={r} id={'lift_'+(i?'b':'a')}><Part name="actual-magazine-lift-platform" size={[.52,.06,.54]} color="#4c8193"/></Moving>
   <LiftRod r={r} s={i?'b':'a'} x={x}/><Extractor r={r} s={i?'b':'a'} x={x}/>
   {[.325,1.22,5.12].map(z=><RoundPart key={z} name="belt-end-roller" position={[x,1.05,z]} radius={.045} length={z<1?.40:.59} axis="x"/>)}
   <RoundPart name="connected-belt-drive-shaft" position={[x+.37,1.04,1.55]} radius={.022} length={.22} axis="x"/>
  </group>)}
  <Moving r={r} id="cart">
   <Part name="powered-refill-carriage" size={[.67,.08,.56]} color="#4c8193"/>
   <Part name="carriage-drive" position={[.40,-.02,0]} size={[.16,.15,.18]} color="#344b57"/>
   <RoundPart name="carriage-drive-shaft" position={[.32,0,0]} radius={.018} length={.2} axis="x"/>
   {[-.18,.18].map(z=><RoundPart key={z} name="bundle-transfer-roller" position={[0,.015,z]} radius={.025} length={.61} axis="x"/>)}
  </Moving>
  <Moving r={r} id="bridge" scale><Part name="telescoping-powered-transfer-bridge" size={[1,1,1]} color="#8899a3"/></Moving>
  {Array.from({length:8},(_,i)=><Moving key={i} r={r} id={'part'+(i+1)} scale><Part name={'physical-sheet-'+(i+1)} size={[1,1,1]} color={i<2?'#d1a56b':i<4?'#7daaa4':'#bb986d'}/></Moving>)}
 </group>
}
