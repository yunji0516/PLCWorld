'use client'

import {useMemo,useRef} from 'react'
import {useFrame} from '@react-three/fiber'
import {Group} from 'three'
import type {DeviceProps} from '../devices'
import type {Frame,MaterialHardState} from '@/lib/replay/adapter'
import {B,C,Belt,Foot,Rod} from './MaterialMiniProcessHardware'

import {FittedMaterialDrive} from './FittedMaterialDrive'
import {MaterialTableLegs} from './MaterialTableLegs'
import {SuctionCup} from './SuctionCup'
import {FINISH} from './Parts'
import {SocketBolt} from '../IndustrialDetails'
import {recordedContactTravel} from './recordedContactLayout'
import {RecordedToolSupport,RecordedDeckSupport,RecordedRotaryBase} from './RecordedContactSupports'
type V=[number,number,number]
type Reader={materialHardState():MaterialHardState|undefined}
const steel=FINISH.alloy,blue=FINISH.blue,dark=FINISH.dark

function Actuator({r,id,kind,size}:{r:Reader;id:string;kind:string;size?:V}){
 const ref=useRef<Group>(null)
 useFrame(()=>{const poses=r.materialHardState()?.contact?.poses,p=poses?.[id],g=ref.current;if(!g)return;g.visible=!!p;if(p){g.position.fromArray(p.pos);g.rotation.set(kind==='cradle'?p.yaw:0,kind==='cradle'?0:p.yaw,0); if(kind==='reel'){const active=poses?.active_reel;const same=active&&Math.hypot(...p.pos.map((v,i)=>v-active.pos[i]))<.01;const radius=p.size?.[0]??(same?active.size?.[0]:undefined)??.10;g.scale.set(radius,radius,1)}}})
 return <group ref={ref} name={`recorded-actuator-${id}`} userData={kind==='box'||kind==='pallet'?{selectionDisabled:true}:{equipmentUnit:true,equipmentGroup:`actuator:${id}`,deviceDisplayName:id.replace(/_/g,' '),recordedPoseId:id}}>
  {kind==='table'?<><C name="rotary-index-table" radius={.72} length={.09} axis="y" color={steel}/>{[0,1,2,3].map(i=><B key={i} name="table-pocket" position={[.52*Math.cos(i*Math.PI/2),.06,.52*Math.sin(i*Math.PI/2)]} size={[.22,.035,.22]} color={blue}/>)}</>
   :kind==='reel'?<><C name="recorded-reel" radius={1} length={.18} axis="z" color="#bd9559"/><C name="reel-hub" radius={.35} length={.21} axis="z" color={steel}/></>
   :kind==='cradle'?<><B name="flip-cradle-backbone" position={[0,-.04,-.18]} size={[.42,.075,.05]} color={steel}/>{[-1,1].map(k=><B key={k} name="cradle-side-arm" position={[k*.19,-.04,0]} size={[.045,.075,.4]} color={steel}/>)}<C name="cradle-vacuum-pad" position={[0,-.035,0]} radius={.065} length={.025} axis="y" color={dark}/></>
   :kind==='roller'?<C name="dancer-contact-roller" radius={.045} length={.24} axis="z" color={steel}/>
   :kind==='box'?<B name="packing-box" size={size??[.6,.05,.5]} color="#bd9559"/>
   :kind==='pallet'?<><B name="recorded-pallet-deck" size={[.6,.045,.5]} color="#bd9559"/>{[-1,1].map(k=><B key={k} name="pallet-runner" position={[k*.2,-.035,0]} size={[.07,.035,.48]} color={dark}/>)}</>
   :kind==='deck'||kind==='fork'?<><B name="moving-support-deck" size={[.54,.065,.42]} color={steel}/><B name="carriage-bearing-plate" position={[0,-.043,0]} size={[.26,.02,.24]} color={dark}/></>
   :<><B name="servo-tool-carriage" position={[0,.13,0]} size={[.24,.10,.22]} color={blue}/>
    <B name="tool-cover-plate" position={[0,.185,0]} size={[.24,.01,.22]} color={steel}/>
    {[-1,1].flatMap(x=>[-1,1].map(z=><SocketBolt key={`${x}:${z}`} top position={[x*.09,.192,z*.08]} radius={.005}/>))}
    {/nozzle/.test(id)?<><C name="metering-nozzle-neck" position={[0,.047,0]} radius={.022} length={.066} axis="y" color={steel}/><C name="metering-nozzle-tip" position={[0,.007,0]} radius={.011} length={.014} axis="y" color={steel}/></>
     :/stroke|capper/.test(id)?<><C name="press-tool-stem" position={[0,.05,0]} radius={.035} length={.06} axis="y" color={steel}/><C name="press-tool-face" position={[0,.01,0]} radius={.06} length={.02} axis="y" color={dark}/></>
     :<><B name="vacuum-manifold" position={[0,.06,0]} size={[.18,.04,.15]} color={steel}/>{[-1,1].map(k=><SuctionCup key={k} name="recorded-contact-vacuum-cup" position={[k*.055,.02,0]} radius={.035} height={.04}/>)}</>}
   </>}
 </group>
}

function Stop({r,id,position,axis}:{r:Reader;id:string;position:V;axis:string}){
 const ref=useRef<Group>(null),stem=useRef<Group>(null),side=axis==='x'?[0,0,.23]:[.23,0,0]
 useFrame(()=>{const stop=r.materialHardState()?.contact?.stops.find(s=>s.id===id);if(ref.current)ref.current.position.y=position[1]+(stop?.closed ? .055 : -.07);if(stem.current){stem.current.visible=!!stop?.closed;stem.current.position.set(position[0],position[1]-.0225,position[2])}})
 return <group name={`recorded-stop-${id}`} userData={{equipmentUnit:true,deviceDisplayName:`${id.replace(/_/g,' ')} stopper`}}>
  <Foot x={position[0]+side[0]} z={position[2]+side[2]} h={Math.max(.1,position[1]-.18)}/>
  <B name="stop-actuator-seat" position={[position[0]+side[0]/2,position[1]-.155,position[2]+side[2]/2]} size={axis==='x'?[.10,.05,.33]:[.33,.05,.10]} color={steel}/>
  <C name="stop-cylinder-body" position={[position[0],position[1]-.09,position[2]]} radius={.035} length={.08} axis="y" color={blue}/>
  <group ref={stem}><C name="stop-piston-rod" radius={.012} length={.055} axis="y" color={steel}/></group>
  <group ref={ref} position={position}><B name="pneumatic-stop-finger" size={axis==='x'?[.035,.10,.32]:[.32,.10,.035]} color="#d9ab46"/></group>
 </group>
}

function WebSegments({r,count}:{r:Reader;count:number}){
 const refs=useRef<(Group|null)[]>([])
 useFrame(()=>{const path=r.materialHardState()?.contact?.web_path??[];refs.current.forEach((g,i)=>{if(!g)return;const a=path[i],b=path[i+1];g.visible=!!a&&!!b;if(a&&b){g.position.set((a[0]+b[0])/2,(a[1]+b[1])/2,(a[2]+b[2])/2);g.lookAt(...b);g.scale.z=Math.hypot(b[0]-a[0],b[1]-a[1],b[2]-a[2])}})})
 return <>{Array.from({length:count},(_,i)=><group key={i} ref={g=>{refs.current[i]=g}} name="recorded-web-contact-segment"><B size={[.16,.008,1]} color="#bd9559"/></group>)}</>
}

function Station({id,p,task}:{id:string;p:V;task:string}){
 const name=id.toLowerCase(), reel=/reel|exchange/.test(name)&&task!=='MAT-H10',fluid=/tank|batch|pump/.test(name)&&task==='MAT-H09',head=/head|pack|die|capper|nozzle|tool|press|cut|inspect|input|output|separate|form_transfer/.test(name)
 if(head&&!reel&&!fluid)return <group name={`contact-station-${id}`} userData={{equipmentUnit:true,deviceDisplayName:`${id.replace(/_/g,' ')} station`}}>
  <Foot x={p[0]-.4} z={p[2]-.25} h={p[1]+.10}/>
  <B name="station-cantilever-arm" position={[p[0]-.17,p[1]+.05,p[2]-.25]} size={[.46,.10,.10]} color={steel}/>
  <B name="station-tool-mount" position={[p[0],p[1]+.05,p[2]-.14]} size={[.18,.10,.12]} color={blue}/>
  <C name="station-tool-cartridge" position={[p[0],p[1]+.05,p[2]]} radius={.055} length={.10} axis="y" color={steel}/>
  <B name="station-tool-mount-tongue" position={[p[0],p[1]+.05,p[2]-.065]} size={[.10,.08,.03]} color={steel}/>
 </group>
 const supportY=reel?p[1]-.16:p[1]
 return <group name={`contact-station-${id}`} userData={{equipmentUnit:true,deviceDisplayName:`${id.replace(/_/g,' ')} station`}}>
  <group position={[p[0],0,p[2]]}><MaterialTableLegs halfX={.285} halfZ={.235} top={Math.max(.12,supportY-.135)}/></group>
  <B name="station-frame" position={[p[0],supportY-.075,p[2]]} size={[.65,.12,.55]} color={steel}/>
  {reel?<><B name="reel-bearing-pedestal" position={[p[0],p[1]-.12,p[2]-.14]} size={[.16,.08,.07]} color={dark}/><C name="reel-bearing" position={p} radius={.075} length={.35} axis="z" color={steel}/><FittedMaterialDrive position={[p[0],p[1],p[2]-.255]} size={[.18,.18,.16]} axis="z"/></>
   :fluid?<><C name="process-vessel" position={[p[0],p[1]+.25,p[2]]} radius={/pump/.test(name)?.12:.30} length={.5} axis="y" color={blue}/><Rod a={[p[0],p[1],p[2]]} b={[p[0],p[1],p[2]-.45]} name="process-pipe"/></>
   :<>{[-1,1].map(k=><B key={k} name="fixture-side-guide" position={[p[0]+k*.22,p[1]+.015,p[2]]} size={[.035,.075,.46]} color={blue}/>)}</>}
  {task==='MAT-H06'&&id==='DANCER'&&<><Rod a={[p[0],.15,p[2]-.16]} b={[p[0],1.15,p[2]-.16]} r={.028}/><C name="fixed-web-guide-roller" position={[p[0]-.1,.9,p[2]]} radius={.035} length={.24} axis="z" color={steel}/></>}
  {task==='MAT-H10'&&['DOCK','SPARE'].includes(id)&&[-1,1].map(k=><B key={k} name="magazine-docking-guide" position={[p[0]+k*.24,p[1]+.12,p[2]]} size={[.055,.75,.46]} color={steel}/>)}
  {task==='MAT-H13'&&id==='FORMER'&&<><B name="forming-mandrel" position={[p[0],p[1]+.12,p[2]]} size={[.35,.22,.30]} color={blue}/><B name="forming-side-press" position={[p[0]-.25,p[1]+.12,p[2]]} size={[.1,.27,.32]} color={steel}/></>}
  {task==='MAT-H14'&&['PRE','POST'].includes(id)&&<><B name="weighing-pan" position={[p[0],p[1]+.02,p[2]]} size={[.45,.05,.42]} color={steel}/><B name="scale-indicator-stalk" position={[p[0],p[1]+.105,p[2]-.27]} size={[.025,.24,.025]} color={steel}/><B name="scale-indicator" position={[p[0],p[1]+.24,p[2]-.27]} size={[.24,.14,.06]} color={dark}/></>}
  {task==='MAT-H15'&&['A','B','PALLET','FORK'].includes(id)&&<B name="lift-cylinder-housing" position={[p[0],.32,p[2]]} size={[.18,.55,.18]} color={blue}/>}
 </group>
}

function Workpiece({r,id}:{r:Reader;id:string}){
 const ref=useRef<Group>(null)
 const magazine=r.materialHardState()?.parts[id]?.kind==='magazine'
 useFrame(()=>{const p=r.materialHardState()?.parts[id],g=ref.current;if(!g)return;g.visible=!!p;if(p){g.position.set(p.x,p.y,p.z);g.rotation.set(p.rx??0,p.ry??p.yaw??0,p.rz??0);g.scale.fromArray(p.size??[.2,.1,.2])}})
 return <group ref={ref} name={`recorded-stock-${id}`} userData={{selectionDisabled:true}}>{magazine?<>{[-1,1].flatMap(x=>[-1,1].map(z=><B key={`${x}:${z}`} name="magazine-cage-rail" position={[x*.47,0,z*.47]} size={[.06,1,.06]} color={steel}/>))}<B name="magazine-bottom" position={[0,-.48,0]} size={[1,.04,1]} color={blue}/></>:<B name="recorded-workpiece" size={[1,1,1]} color={Number(id)%2?'#bd9559':'#84a5ad'}/>}</group>
}

/** Schematic hardware at final task anchors; motion uses recorded scans only. */
export function MaterialContactHardware({plant}:DeviceProps){
 const r=plant as unknown as Reader & {frames?:Frame[]},state=r.materialHardState(),contact=state?.contact
 const travel=useMemo(()=>recordedContactTravel(r.frames??[],contact),[r,r.frames])
 const inventory=contact?.inventory??contact?.poses??{}
 const ids=Array.from(new Set([...Object.keys(inventory),...Object.keys(travel)])).filter(id=>id!=='active_reel'||!Object.keys(inventory).some(key=>key.startsWith('rolls_')))
 const task=plant.machine.title.match(/^MAT-H\d{2}/)?.[0]??''
 return <group name="final-recorded-contact-machinery">
  {plant.machine.devices.filter(d=>d.id!=='MATERIAL_CELL'&&d.pos&&!['TABLE','CRADLE'].includes(d.id)&&!travel[d.id.toLowerCase()]).map(d=><Station key={d.id} id={d.id} p={d.pos!} task={task}/>)}
  {contact?.lanes.map(l=><Belt key={l.id} a={l.a} b={l.b} top={l.a[1]} width={.46}/>)}
  {contact?.stops.map(s=><Stop key={s.id} r={r} id={s.id} position={s.pos} axis={s.axis}/>)}
  {ids.map(id=>{const t=travel[id];if(!t)return null
   return t.kind==='tool'?<RecordedToolSupport key={id} r={r} id={id} travel={t}/>
    :t.kind==='deck'||t.kind==='fork'?<RecordedDeckSupport key={id} r={r} id={id} travel={t}/>
    :t.kind==='table'||t.kind==='cradle'?<RecordedRotaryBase key={id} position={t.min}/>:null
  })}
  {ids.map(id=><Actuator key={id} r={r} id={id} kind={inventory[id]?.kind??travel[id]?.kind??'tool'} size={inventory[id]?.size}/>)}
  {!!contact?.web_path.length&&<WebSegments r={r} count={Math.max(512,contact.web_path.length)}/>}
  {Object.keys(state?.parts??{}).filter(id=>/^\d+$/.test(id)).map(id=><Workpiece key={id} r={r} id={id}/>)}
 </group>
}
