import {scrapFallPresentation} from './scrapFallPresentation'
import type {Frame,Pose,V3} from './ReviewCanvas'
import {auxiliaryMotionPresentation} from './auxiliaryMotionPresentation'
import {packHeadPresentation} from './packHeadPresentation'
const distance=(a:V3,b:V3)=>Math.hypot(...a.map((v,i)=>v-b[i]))
const mix=(a:V3,b:V3,t:number)=>a.map((v,i)=>v+(b[i]-v)*t) as V3
const heads=[
 {id:'separator_pad',rod:'separator_pad_rod',cups:''},
 {id:'return_head',rod:'return_head_rod',cups:'return_vacuum'},
 {id:'assembly_head_a',rod:'assembly_rod_a',cups:''},
 {id:'assembly_head_b',rod:'assembly_rod_b',cups:''},
]
/** Complete only omitted empty-tool travel. Contact frames, carried parts, PLC signals and timing are retained. */
export function reviewMotionPresentation(input:Frame[]):Frame[]{
 let frames=packHeadPresentation(input)
 for(const {id,rod,cups} of heads){
  const initial=frames[0]?.poses[id];if(!initial)continue
  const homeY=initial.p[1],positions=new Map<number,V3>()
  for(let i=1;i<frames.length;i++){
   const a=frames[i-1].poses[id]?.p,b=frames[i].poses[id]?.p,dt=frames[i].t-frames[i-1].t
   if(!a||!b||dt<=0||distance(a,b)<.08||distance(a,b)/dt<2)continue
   const window=Math.min(1.6,Math.max(.6,distance(a,b)/1.2))
   if(Math.abs(a[1]-homeY)<.001&&b[1]<a[1]-.08){
    let start=i-1
    while(start>0&&frames[i].t-frames[start-1].t<=window&&distance(frames[start-1].poses[id]?.p??a,a)<.001)start--
    const duration=frames[i].t-frames[start].t
    for(let j=start;j<i;j++){
     const t=(frames[j].t-frames[start].t)/duration,above:V3=[b[0],a[1],b[2]],horizontal=Math.hypot(a[0]-b[0],a[2]-b[2])
     positions.set(j,horizontal<.001?mix(a,b,t):t<.65?mix(a,above,t/.65):mix(above,b,(t-.65)/.35))
    }
   }else if(Math.abs(b[1]-homeY)<.001&&a[1]<b[1]-.08){
    let end=i
    while(end<frames.length-1&&frames[end+1].t-frames[i-1].t<=window&&distance(frames[end+1].poses[id]?.p??b,b)<.001)end++
    const duration=frames[end].t-frames[i-1].t
    for(let j=i;j<=end;j++){
     const t=(frames[j].t-frames[i-1].t)/duration,above:V3=[a[0],b[1],a[2]],horizontal=Math.hypot(a[0]-b[0],a[2]-b[2])
     positions.set(j,horizontal<.001?mix(a,b,t):t<.35?mix(a,above,t/.35):mix(above,b,(t-.35)/.65))
    }
   }
  }
  if(!positions.size)continue
  frames=frames.map((f,i)=>{
   const p=positions.get(i);if(!p)return f
   const original=f.poses[id].p,delta=p.map((v,k)=>v-original[k]) as V3,poses={...f.poses}
   const move=(key:string,axes:number[])=>{const old=poses[key];if(!old)return;poses[key]={...old,p:old.p.map((v,k)=>v+(axes.includes(k)?delta[k]:0)) as V3}}
   move(id,[0,1,2]);move(id+'_slide',[0,2])
   for(const suffix of ['_crossrail','_bearing0','_bearing1','_xdrive'])move(id+suffix,[2])
   if(cups)for(const key of Object.keys(poses))if(key.startsWith(cups))move(key,[0,1,2])
   const oldRod=poses[rod]
   if(oldRod?.points){const points=oldRod.points.map((v,index)=>v.map((value,k)=>value+((index===oldRod.points!.length-1||k!==1)?delta[k]:0)) as V3);poses[rod]={...oldRod,p:points[0],points} as Pose}
   return {...f,poses}
  })
 }
 return scrapFallPresentation(auxiliaryMotionPresentation(frames))
}
