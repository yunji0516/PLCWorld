import type {Node} from './ReviewCanvas'

/** Keep cabinets behind the rewinder, filling and tool-exchange cells, clear of the working envelope. */
export function reviewCabinetLayout(nodes:Node[]){
 const rewinder=nodes.some(n=>n.id==='waste_roll1_cradle'||n.id==='waste_carriage')&&nodes.some(n=>n.id==='waste_roll2_cradle')
 return nodes.filter(n=>/^controls?$/.test(n.id)&&n.shape==='box').map(n=>{
  const obstacles=nodes.filter(o=>!o.material&&!/^controls?(?:_|$)/.test(o.id)&&o.shape==='box'&&o.p[1]+o.size[1]/2>.15&&o.p[1]-o.size[1]/2<1.4)
  if(rewinder||nodes.some(o=>o.id==='nozzle_slide_a'||o.id==='tool_service_bearing0')){
   const rear=Math.min(...obstacles.map(o=>o.p[2]-o.size[2]/2))-.55
   return {id:n.id,x:n.p[0],z:rear}
  }
  for(const radius of [0,.25,.5,.75,1])for(const [dx,dz] of [[0,1],[1,0],[-1,0],[0,-1]]){
   const x=n.p[0]+dx*radius,z=n.p[2]+dz*radius
   if(!obstacles.some(o=>Math.abs(o.p[0]-x)<o.size[0]/2+.27&&Math.abs(o.p[2]-z)<o.size[2]/2+.34))return {id:n.id,x,z}
  }
  return {id:n.id,x:n.p[0],z:n.p[2]}
 })
}
