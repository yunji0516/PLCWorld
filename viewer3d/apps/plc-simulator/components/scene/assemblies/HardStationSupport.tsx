import {useMemo} from 'react'
import type {DeviceProps} from '../devices'
import type {Node,V3} from '@/app/replay/hard-processes/ReviewCanvas'
import {supportPresentation,supportRole} from '@/app/replay/hard-processes/supportPresentation'
import {Part,FINISH} from './Parts'

export function isHardStationSupport({device,plant}:DeviceProps){
 return /^MAT-H01(?:\s|$)/.test(plant.machine.title)&&/^(?:[AB]_(?:POST_|REAR_POST_|SIDE_SILL_|COLUMN$|HEAD_BRIDGE$|TOP_RAIL$|DOOR_RAIL$)|GAUGE_(?:COLUMN|CROSSHEAD)$)/.test(device.id)
}
export function HardStationSupport({device,plant}:DeviceProps){
 const node=useMemo(()=>{
  const nodes:Node[]=plant.machine.devices.map(d=>({id:d.id,name:d.id,shape:'box',p:d.pos as V3,size:d.size as V3,r:0,color:FINISH.dark,visible:true}))
  const n=supportPresentation(nodes).find(n=>n.id===device.id)!
  if(/^[AB]_HEAD_BRIDGE$/.test(n.id)){
   const column=nodes.find(o=>o.id===n.id[0]+'_COLUMN')!,front=column.p[2]-column.size[2]/2
   const cut=Math.max(0,n.p[2]+n.size[2]/2-front)
   return {...n,fragments:[{p:[0,0,-cut/2/n.size[2]] as V3,size:[1,1,1-cut/n.size[2]] as V3}]}
  }
  return n
 },[device.id,plant.machine.devices])
 const pieces=node.fragments??[{p:[0,0,0] as V3,size:[1,1,1] as V3}]
 return <group name="hard-station-straight-support">{pieces.map((f,i)=><Part key={i} name="station-support-member" position={f.p.map((v,k)=>v*node.size[k]) as V3} size={f.size.map((v,k)=>v*node.size[k]) as V3} color={supportRole(node)==='rail'?FINISH.alloy:FINISH.dark} radius={.002}/>)}</group>
}
