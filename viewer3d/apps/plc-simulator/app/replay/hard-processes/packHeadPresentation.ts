import type {Frame,Pose,V3} from './ReviewCanvas'

const distance=(a:V3,b:V3)=>Math.hypot(...a.map((v,i)=>v-b[i]))
const mix=(a:V3,b:V3,t:number)=>a.map((v,i)=>v+(b[i]-v)*t) as V3
/** Fill omitted empty-head approach/return paths, without moving held products or changing event times. */
export function packHeadPresentation(frames:Frame[]):Frame[]{
 const home:V3=[2.25,1.72,.6]
 if(!frames.some(f=>f.poses.pack_head&&f.poses.pack_head_rod))return frames
 const positions=new Map<number,V3>()
 for(let i=1;i<frames.length;i++){
  const a=frames[i-1].poses.pack_head?.p,b=frames[i].poses.pack_head?.p
  if(!a||!b||distance(a,b)<.25)continue
  if(distance(a,home)<.001){
   let start=i-1
   while(start>0&&frames[i].t-frames[start-1].t<=1.6&&distance(frames[start-1].poses.pack_head?.p??home,home)<.001)start--
   const duration=frames[i].t-frames[start].t
   for(let j=start;j<i;j++){
    const t=(frames[j].t-frames[start].t)/duration,above:V3=[b[0],home[1],b[2]]
    positions.set(j,t<.75?mix(home,above,t/.75):mix(above,b,(t-.75)/.25))
   }
  }else if(distance(b,home)<.001){
   let end=i
   while(end<frames.length-1&&frames[end+1].t-frames[i-1].t<=1.6&&distance(frames[end+1].poses.pack_head?.p??home,home)<.001)end++
   const duration=frames[end].t-frames[i-1].t
   for(let j=i;j<=end;j++){
    const t=(frames[j].t-frames[i-1].t)/duration,above:V3=[a[0],home[1],a[2]]
    positions.set(j,t<.35?mix(a,above,t/.35):mix(above,home,(t-.35)/.65))
   }
  }
 }
 return frames.map((f,i)=>{
  const p=positions.get(i);if(!p)return f
  const poses={...f.poses},set=(id:string,p:V3,points?:V3[])=>{if(poses[id])poses[id]={...poses[id],p,...(points?{points}:{} )} as Pose}
  const original=f.poses.pack_head.p
  for(const id of Object.keys(poses).filter(id=>id.startsWith('pack_pad'))){
   const old=poses[id].p;set(id,old.map((v,k)=>v+p[k]-original[k]) as V3)
  }
  set('pack_head',p)
  const top:V3=[p[0],1.86,p[2]],bottom:V3=[p[0],p[1]+.02,p[2]]
  set('pack_head_rod',top,[top,bottom]);set('pack_head_slide',top)
  for(const id of ['pack_head_crossrail','pack_head_bearing0','pack_head_bearing1','pack_head_xdrive']){
   const old=poses[id];if(old)set(id,[old.p[0],old.p[1],p[2]])
  }
  return {...f,poses}
 })
}
