import type {Node} from './ReviewCanvas'

export type Furniture = {id:string;x:number;z:number;w:number;d:number;top:number;enclosed:boolean;preserveLegs?:boolean;floorFeet?:[number,number][]}
const overlap=(a:Furniture,b:Furniture)=>Math.abs(a.x-b.x)<(a.w+b.w)/2-.002 && Math.abs(a.z-b.z)<(a.d+b.d)/2-.002
const inside=(n:Node,b:Furniture)=>Math.abs(n.p[0]-b.x)<=b.w/2+.001 && Math.abs(n.p[2]-b.z)<=b.d/2+.001
/** Presentation-only replacement. Never changes replay data or moving equipment. */
export function reviewFurniture(nodes:Node[]) {
 const hidden=new Set<string>(),furniture:Furniture[]=[],upper:Node[]=[],posts:{id:string;x:number;z:number;bottom:number;top:number;edge:number}[]=[]
 for(const left of nodes.filter(n=>n.id.endsWith('_side-1')&&n.shape==='box'&&!n.material)){
  const prefix=left.id.slice(0,-7),right=nodes.find(n=>n.id===prefix+'_side1')
  if(!right || Math.abs(left.r)>.001 || left.p[1]+left.size[1]/2>1)continue
  furniture.push({id:prefix,x:(left.p[0]+right.p[0])/2,z:left.p[2],w:right.p[0]-left.p[0]+left.size[0],d:left.size[2],top:left.p[1]+left.size[1]/2,enclosed:true})
  for(const n of nodes)if(n.id.startsWith(prefix+'_')&&/^(side|door|handle|vent|foot)/.test(n.id.slice(prefix.length+1)))hidden.add(n.id)
 }
 // Adjacent service housings must not retain coincident skins in their overlap.
 let merged=true
 while(merged){merged=false;outer:for(let i=0;i<furniture.length;i++)for(let j=i+1;j<furniture.length;j++){
  const a=furniture[i],b=furniture[j];if(!overlap(a,b))continue
  const x0=Math.min(a.x-a.w/2,b.x-b.w/2),x1=Math.max(a.x+a.w/2,b.x+b.w/2),z0=Math.min(a.z-a.d/2,b.z-b.d/2),z1=Math.max(a.z+a.d/2,b.z+b.d/2)
  furniture[i]={...a,x:(x0+x1)/2,z:(z0+z1)/2,w:x1-x0,d:z1-z0,top:Math.max(a.top,b.top)};furniture.splice(j,1);merged=true;break outer
 }}
 // The independent roll receiver's blue deck sits on, rather than inside, its case.
 if(nodes.some(n=>n.id==='exit_support_beam')){
  const beam=nodes.find(n=>n.id==='exit_support_beam')!
  for(const b of furniture)if(b.id==='roll_receiving_station')b.top=beam.p[1]-beam.size[1]/2
 }
 // Join the case directly to its supported deck, eliminating intervening shim beams.
 for(const b of furniture){
  const decks=nodes.filter(n=>!n.material&&(n.conveyor||n.fixed_transfer||/_surface$/.test(n.id))&&Math.abs(n.p[0]-b.x)<(n.size[0]+b.w)/2-.02&&Math.abs(n.p[2]-b.z)<(n.size[2]+b.d)/2-.02&&n.p[1]-n.size[1]/2>b.top-.12&&n.p[1]-n.size[1]/2<b.top+.22)
  if(decks.length)b.top=Math.min(...decks.map(n=>n.p[1]-n.size[1]/2))
  // Legacy solid bases and shim beams inside the replacement enclosure are redundant.
  for(const n of nodes)if(!n.material&&/_(beam|base)(?:_[ab])?$/.test(n.id)&&n.shape==='box'&&n.p[1]+n.size[1]/2<=b.top+.002&&Math.abs(n.p[0]-b.x)+n.size[0]/2<=b.w/2+.08&&Math.abs(n.p[2]-b.z)+n.size[2]/2<=b.d/2+.08)hidden.add(n.id)

 }
 for(const n of nodes){
  if(!n.material&&/foot/.test(n.id)&&n.p[1]+n.size[1]/2<.16&&furniture.some(b=>inside(n,b))){hidden.add(n.id);continue}
  if((nodes.some(o=>o.id==='exit_support_beam')&&/^core_feed_stand_leg/.test(n.id))||/_guard.*_upright/.test(n.id)||n.material||n.shape!=='box'||Math.abs(n.r)>.001||!/(?:leg|post|upright)/.test(n.id)||n.size[1]<Math.max(n.size[0],n.size[2])*2)continue
  const cases=furniture.filter(b=>inside(n,b)),top=cases.length?Math.max(...cases.map(b=>b.top)):0
  if(!top||n.p[1]-n.size[1]/2>=top)continue
  hidden.add(n.id);const high=n.p[1]+n.size[1]/2
  if(high>top+.004)upper.push({...n,id:n.id+'-presentation-upper',p:[n.p[0],(high+top)/2,n.p[2]],size:[n.size[0],high-top,n.size[2]],fragments:undefined})
 }
 const groups=new Map<string,Node[]>()
 for(const n of nodes){
  const m=n.id.match(/^(.*)_leg[01][01]$/)??n.id.match(/^(.*_leg[ab]?)\(/)
  if(!m||n.material||n.shape!=='box'||hidden.has(n.id))continue
  const list=groups.get(m[1])??[];list.push(n);groups.set(m[1],list)
 }
 for(const [id,legs] of groups){
  if(legs.length!==4||legs.some(n=>Math.abs(n.r)>.001))continue
  const xs=legs.map(n=>n.p[0]),zs=legs.map(n=>n.p[2]),tops=legs.map(n=>n.p[1]+n.size[1]/2)
  if(Math.max(...tops)>1.6||Math.max(...tops)-Math.min(...tops)>.006)continue
  const x0=Math.min(...xs),x1=Math.max(...xs),z0=Math.min(...zs),z1=Math.max(...zs)
  if(x1-x0<.08||z1-z0<.08)continue
  const b={id,x:(x0+x1)/2,z:(z0+z1)/2,w:x1-x0+.055,d:z1-z0+.055,top:Math.min(...tops),enclosed:false,preserveLegs:legs.some(n=>n.fragments||n.p[1]-n.size[1]/2>.11),floorFeet:legs.filter(n=>n.p[1]-n.size[1]/2<=.11).map(n=>[n.p[0]-(x0+x1)/2,n.p[2]-(z0+z1)/2] as [number,number])}
  if(furniture.some(c=>overlap(b,c)))continue
  const decks=nodes.filter(n=>!n.material&&(n.conveyor||n.fixed_transfer)&&Math.abs(n.p[0]-b.x)<(n.size[0]+b.w)/2&&Math.abs(n.p[2]-b.z)<(n.size[2]+b.d)/2&&Math.abs(n.p[1]-n.size[1]/2-b.top)<.10)
  if(decks.length&&!b.preserveLegs)b.top=Math.min(...decks.map(n=>n.p[1]-n.size[1]/2))
  furniture.push(b);if(!b.preserveLegs){
   legs.forEach(n=>hidden.add(n.id))
   if(nodes.some(n=>n.id==='cross_1.25_surface'))for(const leg of legs)for(const part of nodes)if(part.id.startsWith(leg.id+'_'))hidden.add(part.id)
  }
  nodes.filter(n=>n.id.startsWith(id+'_foot')).forEach(n=>hidden.add(n.id))
 }
 // Legacy irregular conveyor supports use the same profile and adjustable foot.
 for(const n of nodes){
  if(hidden.has(n.id)||n.material||n.shape!=='box'||!/_leg/.test(n.id)||/_upper_post|_joint/.test(n.id)||n.size[1]<.2||Math.max(n.size[0],n.size[2])>.12||Math.abs(n.r)>.001)continue
  const bottom=n.p[1]-n.size[1]/2;if(bottom>.18)continue
  let top=n.p[1]+n.size[1]/2
  for(const ext of nodes)if(ext.id===n.id+'_upper_post'){top=Math.max(top,ext.p[1]+ext.size[1]/2);hidden.add(ext.id)}
  hidden.add(n.id)
  posts.push({id:n.id,x:n.p[0],z:n.p[2],bottom:Math.max(.04,bottom),top,edge:Math.min(n.size[0],n.size[2])})
  for(const foot of nodes)if(/foot/.test(foot.id)&&foot.p[1]<.12&&Math.abs(foot.p[0]-n.p[0])<.02&&Math.abs(foot.p[2]-n.p[2])<.02)hidden.add(foot.id)
 }
 // Receiver identifiers belong on the replacement door, not the old skin plane.
 for(const n of nodes){
  const mark=n.id.match(/^order_mark_([ab])$/)
  if(!mark||n.material)continue
  const b=furniture.find(b=>b.id==='order_receiver_'+mark[1]);if(!b)continue
  const side=n.p[2]>=b.z?1:-1,doorFace=b.z+side*(b.d/2-.05)
  hidden.add(n.id)
  upper.push({...n,id:n.id+'-presentation-door',p:[n.p[0],n.p[1],doorFace+side*(n.size[2]/2+.0005)],presentationFixed:true,fragments:undefined})
 }
 const cleanUpper=upper.filter(n=>n.presentationFixed||Math.min(...n.size)>.009)
 for(const n of nodes)if(/_upper_post(?:_chassis_joint)?$/.test(n.id)&&Math.min(...n.size)<.01)hidden.add(n.id)
 if(nodes.some(n=>n.id==='tool_service_bearing0'))for(const b of furniture)if(/^face_service_cell_[ab]$/.test(b.id))b.top=.73
 return {hidden,furniture,upper:cleanUpper,posts}
}
