import {MachineMountRedesign} from './MachineMountRedesign'
import {StackTransferMounts} from './StackTransferMounts'
import {ReviewActuatorRefinement} from './ReviewActuatorRefinement'
import {ReviewStationRedesign} from './ReviewStationRedesign'
import {ReviewClampMounts} from './ReviewClampMounts'
import {ReviewConnectedMounts,FluidHose} from './ReviewConnectedMounts'
import {useMemo,useRef,type RefObject} from 'react'
import {useFrame} from '@react-three/fiber'
import {Group,Quaternion,Vector3} from 'three'
import type {Node,Frame} from '@/app/replay/hard-processes/ReviewCanvas'
import {reviewCabinetLayout} from '@/app/replay/hard-processes/reviewCabinetLayout'
import {FloorControlCabinet} from './FloorControlCabinet'
import {Part,RoundPart} from './Parts'
import {DeviceNameBadge} from '../DeviceNameBadge'

function ServiceCabinet({id,x,z,selected,onSelect,showLabel}:{id:string;x:number;z:number;selected:boolean;showLabel:boolean;onSelect?:()=>void}){
 const ref=useRef<Group>(null),object=ref.current?.getObjectByName('control-box-equipment')
 return <group ref={ref} name={'review-control-'+id} onClick={e=>{e.stopPropagation();onSelect?.()}}>
  <group position={[x,0,z]}><FloorControlCabinet/></group>
  {(selected||showLabel)&&<DeviceNameBadge id={id} name="Control cabinet" position={[x,.68,z]} anchor={selected&&object?{id,object,name:'Control cabinet'}:undefined}/>}
 </group>
}

export function ReviewServiceEnclosures({nodes,selectedDevice,onSelectDevice,showLabels=false}:{nodes:Node[];showLabels?:boolean;selectedDevice?:string|null;onSelectDevice?:(id:string|null)=>void}){
 const cabinets=useMemo(()=>reviewCabinetLayout(nodes),[nodes])
 return <>{cabinets.map(c=><ServiceCabinet key={c.id} {...c} selected={selectedDevice===c.id} showLabel={showLabels} onSelect={()=>onSelectDevice?.(selectedDevice===c.id?null:c.id)}/>)}</>
}

function CradlePadLink({frame,nodes}:{frame:RefObject<Frame>;nodes:Node[]}){
 const ref=useRef<Group>(null),q=useMemo(()=>new Quaternion(),[])
 useFrame(()=>{
  const pad=frame.current.poses.cradle_pad??nodes.find(n=>n.id==='cradle_pad'),base=frame.current.poses.cradle_crossbar??nodes.find(n=>n.id==='cradle_crossbar')
  if(!ref.current||!pad||!base)return
  ref.current.visible=pad.visible??true
  const rot=new Quaternion().setFromAxisAngle(new Vector3(1,0,0),base.rx??0)
  const a=new Vector3(0,.008,.05).applyQuaternion(rot).add(new Vector3(...base.p))
  const b=new Vector3(0,-.015,0).applyQuaternion(rot).add(new Vector3(...pad.p)),delta=b.clone().sub(a)
  ref.current.position.copy(a).add(b).multiplyScalar(.5);ref.current.quaternion.copy(q.setFromUnitVectors(new Vector3(0,1,0),delta.clone().normalize()));ref.current.scale.y=Math.max(.001,delta.length())
 })
 return <group ref={ref} name="cradle-pad-connected-mount"><Part size={[.045,1,.022]} color="#303b45"/></group>
}
function ProbeLink({side,frame,nodes}:{side:string;frame:RefObject<Frame>;nodes:Node[]}){
 const ref=useRef<Group>(null),rod=useRef<Group>(null)
 useFrame(()=>{
  const p=frame.current.poses[side+'_probe']??nodes.find(n=>n.id===side+'_probe'),body=nodes.find(n=>n.id===side+'_probe_body')
  if(!p||!body||!ref.current||!rod.current)return
  const y=p.p[1]+.02,top=body.p[1]-body.size[1]/2
  ref.current.position.set(p.p[0],y,(p.p[2]+body.p[2])/2);ref.current.visible=p.visible??true
  rod.current.position.set(p.p[0],(top+y)/2,body.p[2]);rod.current.scale.y=Math.max(.001,top-y);rod.current.visible=(p.visible??true)&&top>y
 })
 return <><group ref={ref} name={side+'-probe-connected-toe'}><Part size={[.035,.025,.14]} color="#7f8f9c"/></group><group ref={rod} name={side+'-probe-connected-rod'}><RoundPart position={[0,0,0]} radius={.009} length={1} axis="y"/></group></>
}
export function ReviewAttachedHardware({nodes,frame}:{nodes:Node[];frame:RefObject<Frame>}){
 const machining=nodes.some(n=>n.id==='b_keeper')&&nodes.some(n=>n.id==='cradle_pad')
 return <><MachineMountRedesign nodes={nodes} frame={frame}/><StackTransferMounts nodes={nodes} frame={frame}/><ReviewActuatorRefinement nodes={nodes} frame={frame}/><ReviewStationRedesign nodes={nodes} frame={frame}/><ReviewClampMounts nodes={nodes} frame={frame}/><ReviewConnectedMounts nodes={nodes} frame={frame}/>{nodes.filter(n=>n.shape==='ribbon'&&/^(flex_hose_|tank_pipe_|refill_pipe$)/.test(n.id)).map(n=><FluidHose key={n.id} node={n} frame={frame}/>)}{machining&&<group name="machining-connected-mounts">
  <Part name="b-keeper-fixed-mount" position={[.8625,.8285,0]} size={[.125,.057,.08]} color="#303b45"/>
  <CradlePadLink frame={frame} nodes={nodes}/>

 </group>} </>
}
