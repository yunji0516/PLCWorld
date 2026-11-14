import {scrapPath,pathPoint,chuteHeight} from './scrapChutes'
import type {Frame,V3} from './ReviewCanvas'
/** H12: accelerate the final unsupported descent. Release/arrival frames, bin motion and PLC records remain unchanged. */
export function scrapFallPresentation(input:Frame[]):Frame[]{
 if(!input.some(f=>f.poses.bin_floor101&&f.poses.part110))return input
 const edits=new Map<number,Frame['poses']>()
 const routes=new Map<string,{side:'a'|'b';slot:number}>()
 for(const f of input)for(const [id,p] of Object.entries(f.poses))if(/^part1\d\d$/.test(id)&&p.visible!==false&&Math.abs(p.p[0])>1&&p.p[1]>1){
  const side=p.p[0]<0?'a':'b',slot=side==='a'?Math.round((p.p[2]+.135)/.135):p.p[2]<0?0:1
  if(slot>=0&&slot<(side==='a'?3:2))routes.set(id,{side,slot})
 }
 const ids=new Set(input.flatMap(f=>Object.keys(f.poses).filter(id=>/^part1\d\d$/.test(id))))
 for(const id of ids){
  for(let i=1;i<input.length-1;i++){
   const a=input[i-1].poses[id],b=input[i].poses[id]
   if(!a||!b||a.visible===false||b.visible===false||a.p[1]>.76||a.p[1]<=.501||Math.abs(a.p[0]-b.p[0])>1e-6||Math.abs(a.p[2]-b.p[2])>1e-6||b.p[1]>=a.p[1])continue
   const start=i-1;let end=i
   while(end+1<input.length){const p=input[end].poses[id],q=input[end+1].poses[id];if(!q||q.visible===false||Math.abs(q.p[0]-a.p[0])>1e-6||Math.abs(q.p[2]-a.p[2])>1e-6||q.p[1]>=p.p[1])break;end++}
   const last=input[end].poses[id];if(Math.abs(last.p[1]-.5)>.002){i=end;continue}
   const duration=input[end].t-input[start].t
   for(let j=start+1;j<end;j++){
    const f=input[j],old=f.poses[id],t=(f.t-input[start].t)/duration
    const poses=edits.get(j)??{...f.poses}
    poses[id]={...old,p:[a.p[0],a.p[1]+(last.p[1]-a.p[1])*t*t,a.p[2]] as V3};edits.set(j,poses)
   }
   i=end
  }
 }
 // Match the shared tray plane, then descend in its unobstructed drop column.
 return input.map((f,i)=>{
  let poses=edits.get(i)
  for(const [id,old] of Object.entries(f.poses)){
   const route=routes.get(id);if(!route||old.visible===false)continue
   const {side,slot}=route,high=side==='a'?.8:.65,low=side==='a'?.75:.60,endZ=side==='a'?.57:.73
   if(old.p[1]>high+.000001)continue
   const path=scrapPath(side,slot),end=path.at(-1)!,oldEndX=side==='a'?.16-slot*.16:-.16+slot*.16
   if(old.p[1]<=.500001){poses??={...f.poses};poses[id]={...old,p:[old.p[0]+end[0]-oldEndX,old.p[1],old.p[2]+end[2]-endZ]};continue}
   if(Math.abs(old.p[2]-endZ)>1e-6&&old.p[1]>=low-.000001){
    const u=Math.max(0,Math.min(1,(high-old.p[1])/.05)),point=pathPoint(path,u)
    poses??={...f.poses};poses[id]={...old,p:[point[0],point[1]+.01,point[2]]}
   }else if(Math.abs(old.p[2]-endZ)<1e-6&&Math.abs(old.p[0]-oldEndX)<1e-5&&old.p[1]<=low+.000001){
    const current=poses?.[id]??old,offset=chuteHeight(side,end[0])+.01-low
    if(Math.abs(offset)>1e-8){poses??={...f.poses};poses[id]={...current,p:[end[0],current.p[1]+offset*(current.p[1]-.5)/(low-.5),end[2]]}}
   }
  }
  return poses?{...f,poses}:f
 })
}
