import type {Node,V3} from './ReviewCanvas'
export type SupportRole='column'|'beam'|'rail'
/** Machine supports only. Furniture, guards, workpieces and gripper fingers retain their own design. */
export function supportRole(n:Node):SupportRole|undefined{
 if(n.material||n.shape!=='box'||Math.min(...n.size)<.015)return
 const id=n.id.toLowerCase()
 if(/guard|photo|sensor|_leg|_foot|surface|bearing|roller|chassis|fixture|pocket|_stand|supply_beam|frame_beam|rack_beam|bed_beam|side_rail|support_rail|receiver_rail|drive_|stock|index_frame|table/.test(id))return
 if(/(?:post|column|upright)/.test(id)&&n.size[1]>Math.max(n.size[0],n.size[2])*2)return 'column'
 if(/(?:[xyz]rail|gantry_rail|gantry_zrail|tool_rail|input_rail|output_rail|door_rail)/.test(id))return 'rail'
 if(/(?:_arm|_bridge|crossbeam|[xyz]beam|gantry_end|gantry$|pick_support|top_rail|crosshead|^nozzle_top_|^die_cross_|^receiver_cross_)/.test(id))return 'beam'
}
type Box={lo:V3;hi:V3}
function bounds(n:Node):Box{
 const parts=n.fragments??[{p:[0,0,0] as V3,size:[1,1,1] as V3}]
 return {lo:n.p.map((v,i)=>v+Math.min(...parts.map(f=>f.p[i]-f.size[i]/2))*n.size[i]) as V3,hi:n.p.map((v,i)=>v+Math.max(...parts.map(f=>f.p[i]+f.size[i]/2))*n.size[i]) as V3}
}
function stationary(n:Node){return n.visible!==false&&!n.r&&!n.rx&&!n.rz}
function longest(n:Node){return n.size.indexOf(Math.max(...n.size))}
/** Shorten a member at the mating face, preserving its other end and existing cutouts. */
function trim(n:Node,axis:number,lo:number,hi:number):Node{
 const old=bounds(n),parts=n.fragments??[{p:[0,0,0] as V3,size:[1,1,1] as V3}]
 const fragments=parts.flatMap(f=>{
  const min=n.p.map((v,i)=>v+(f.p[i]-f.size[i]/2)*n.size[i]) as V3
  const max=n.p.map((v,i)=>v+(f.p[i]+f.size[i]/2)*n.size[i]) as V3
  min[axis]=Math.max(min[axis],lo);max[axis]=Math.min(max[axis],hi)
  if(max[axis]-min[axis]<1e-6)return []
  return [{p:min.map((v,i)=>((v+max[i])/2-n.p[i])/n.size[i]) as V3,size:min.map((v,i)=>(max[i]-v)/n.size[i]) as V3}]
 })
 return lo<=old.lo[axis]+1e-7&&hi>=old.hi[axis]-1e-7?n:{...n,fragments}
}
export function supportPresentation(nodes:Node[]):Node[]{
 // H03 has the measured replacement assemblies, including real screw bores.
 if(nodes.some(n=>n.id==='inspection_body'))return nodes
 function pass(input:Node[],columns:boolean){
 const members=input.filter(n=>supportRole(n)&&stationary(n))
 return input.map(n=>{
  const role=supportRole(n);if(!role||!stationary(n)||(role==='column')!==columns)return n
  const axis=role==='column'?1:longest(n),b=bounds(n);let lo=b.lo[axis],hi=b.hi[axis]
  for(const other of members){
   if(n===other)continue
   const otherRole=supportRole(other)!,o=bounds(other)
   // Columns end at overhead members. Beams butt against columns and running rails.
   if(role==='column'&&otherRole==='column')continue
   if(role==='rail')continue
   if(role==='beam'&&otherRole==='beam')continue
   const transverse=[0,1,2].filter(i=>i!==axis)
   if(!transverse.every(i=>Math.min(b.hi[i],o.hi[i])-Math.max(b.lo[i],o.lo[i])>1e-6))continue
   if(o.hi[axis]<=lo||o.lo[axis]>=hi)continue
   if(role==='column'){
    // Only top joints; never cut a column at an intermediate moving stage.
    if(o.lo[1]>b.hi[1]-Math.min(.18,n.size[1]*.2))hi=Math.min(hi,o.lo[1])
   }else{
    const endZone=Math.min(.2,n.size[axis]*.3)
    if(o.lo[axis]<=lo+1e-6&&o.hi[axis]<lo+endZone)lo=Math.max(lo,o.hi[axis])
    if(o.hi[axis]>=hi-1e-6&&o.lo[axis]>hi-endZone)hi=Math.min(hi,o.lo[axis])
   }
  }
  return hi-lo>n.size[axis]*.5?trim(n,axis,lo,hi):n
 })
 }
 // Column tops are resolved first so their supporting beams retain a full seating face.
 return pass(pass(nodes,true),false)
}
