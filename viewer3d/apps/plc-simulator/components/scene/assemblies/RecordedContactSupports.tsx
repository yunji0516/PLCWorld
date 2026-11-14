'use client'
import {useRef} from 'react'
import {useFrame} from '@react-three/fiber'
import {Group} from 'three'
import type {MaterialHardState} from '@/lib/replay/adapter'
import {B,C,Foot} from './MaterialMiniProcessHardware'
import {FittedMaterialDrive} from './FittedMaterialDrive'
import {MaterialTableLegs} from './MaterialTableLegs'
import {RotaryPedestal} from './MaterialIndexDetail'
import {FINISH} from './Parts'
import {toolSupport,deckSupport,type Travel,type V} from './recordedContactLayout'
type Reader={materialHardState():MaterialHardState|undefined}

/** Fixed bridge ways, translating saddle and a separate telescoping quill. */
export function RecordedToolSupport({r,id,travel}:{r:Reader;id:string;travel:Travel}){
 const s=toolSupport(travel),bridge=useRef<Group>(null),saddle=useRef<Group>(null),quill=useRef<Group>(null)
 useFrame(()=>{
  const p=r.materialHardState()?.contact?.poses[id]
  for(const g of [bridge.current,saddle.current,quill.current])if(g)g.visible=!!p
  if(!p)return
  bridge.current?.position.set((s.left+s.right)/2,s.top,p.pos[2])
  saddle.current?.position.set(p.pos[0],s.top,p.pos[2])
  const lower=p.pos[1]+.18,upper=s.top-.07
  if(quill.current){quill.current.position.set(p.pos[0],(lower+upper)/2,p.pos[2]);quill.current.scale.y=Math.max(.01,upper-lower)}
 })
 return <group name={`recorded-supported-axis-${id}`} userData={{equipmentUnit:true,equipmentGroup:`actuator:${id}`,deviceDisplayName:id.replace(/_/g,' '),recordedPoseId:id}}>
  {[s.left,s.right].map(x=><group key={x}>
   {[s.rear,s.front].map(z=><Foot key={z} x={x} z={z} h={s.top-.055}/>)}
   <B name="gantry-longitudinal-way" position={[x,s.top,(s.rear+s.front)/2]} size={[.09,.11,s.front-s.rear+.12]} color={FINISH.dark}/>
   <B name="gantry-machined-guide" position={[x,s.top+.062,(s.rear+s.front)/2]} size={[.035,.014,s.front-s.rear]} color={FINISH.steel}/>
  </group>)}
  <group ref={bridge}>
   <B name="gantry-cross-slide" size={[s.right-s.left+.1,.12,.1]} color={FINISH.alloy}/>
   {[-1,1].map(k=><B key={k} name="gantry-bearing-block" position={[k*(s.right-s.left)/2,.07,0]} size={[.13,.04,.17]} color={FINISH.blue}/>)}
  </group>
  <group ref={saddle}>
   <B name="tool-axis-saddle" size={[.23,.16,.23]} color={FINISH.blue}/>
   <B name="tool-axis-drive-flange" position={[0,.09,0]} size={[.13,.02,.13]} color={FINISH.steel}/>
   <FittedMaterialDrive position={[0,.19,0]} size={[.13,.18,.13]} axis="y"/>
  </group>
  <group ref={quill}><C name="tool-polished-quill" radius={.035} length={1} axis="y" color={FINISH.steel}/></group>
 </group>
}

export function RecordedDeckSupport({r,id,travel}:{r:Reader;id:string;travel:Travel}){
 const jack=useRef<Group>(null),slide=useRef<Group>(null),{alongX,w,d,cx,cz,top}=deckSupport(travel)
 useFrame(()=>{const p=r.materialHardState()?.contact?.poses[id];if(!jack.current)return;jack.current.visible=!!p;if(p){slide.current?.position.set(alongX?p.pos[0]:cx,top+.055,alongX?cz:p.pos[2]);const low=top+.075,high=p.pos[1]-.0325;jack.current.position.set(p.pos[0],(low+high)/2,p.pos[2]);jack.current.scale.y=Math.max(.01,high-low)}})
 return <group name={`recorded-deck-bed-${id}`} userData={{equipmentUnit:true,equipmentGroup:`actuator:${id}`,deviceDisplayName:id.replace(/_/g,' '),recordedPoseId:id}}>
  <group position={[cx,0,cz]}><MaterialTableLegs halfX={w/2-.035} halfZ={d/2-.035} top={top-.035}/></group>
  {[-1,1].map(k=><B key={k} name="transfer-bearing-rail" position={alongX?[cx,top,cz+k*(d/2-.05)]:[cx+k*(w/2-.05),top,cz]} size={alongX?[w,.07,.07]:[.07,.07,d]} color={FINISH.dark}/>)}
  {[-1,1].map(k=><B key={k} name="transfer-bed-end" position={alongX?[cx+k*(w/2-.035),top,cz]:[cx,top,cz+k*(d/2-.035)]} size={alongX?[.07,.07,Math.max(.07,d-.14)]:[Math.max(.07,w-.14),.07,.07]} color={FINISH.alloy}/>)}
  <group ref={slide}><B name="transfer-guided-cross-saddle" size={alongX?[.24,.04,d]:[w,.04,.24]} color={FINISH.blue}/></group>
  <group ref={jack}><C name="lift-guided-ram" radius={.065} length={1} axis="y" color={FINISH.steel}/></group>
 </group>
}

/** Round equipment gets a casting, not a table through its rotating center. */
export function RecordedRotaryBase({position:p}:{position:V}){return <group position={[p[0],0,p[2]]}><RotaryPedestal top={Math.max(.15,p[1]-.045)}/></group>}
