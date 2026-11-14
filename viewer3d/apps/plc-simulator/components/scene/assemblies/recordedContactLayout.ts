import type {Frame, MaterialHardState} from '@/lib/replay/adapter'
export type V = [number, number, number]
export type Travel = {min:V; max:V; kind:string}
/** Display envelope only. Never edits a scan, command, contact or score. */
export function recordedContactTravel(frames:Pick<Frame,'world'>[], initial?:MaterialHardState['contact']) {
 const result:Record<string,Travel>={}
 const add=(poses:NonNullable<MaterialHardState['contact']>['poses'])=>{
  for(const [id,p] of Object.entries(poses)){
   if(!p.pos.every(Number.isFinite))continue
   const entry=result[id]??(result[id]={min:[...p.pos],max:[...p.pos],kind:p.kind})
   for(let i=0;i<3;i++){entry.min[i]=Math.min(entry.min[i],p.pos[i]);entry.max[i]=Math.max(entry.max[i],p.pos[i])}
  }
 }
 if(initial)add(initial.inventory??initial.poses)
 for(const f of frames)if(f.world?.material_hard?.contact)add(f.world.material_hard.contact.poses)
 return result
}
/** Columns remain outside the swept tool envelope; only the quill telescopes. */
export function toolSupport(t:Travel){
 return {left:t.min[0]-.42,right:t.max[0]+.42,rear:t.min[2]-.34,front:t.max[2]+.34,top:t.max[1]+.65}
}

export function deckSupport(t:Travel){
 const dx=t.max[0]-t.min[0],dz=t.max[2]-t.min[2]
 return {alongX:dx>=dz,w:dx+.64,d:dz+.52,cx:(t.min[0]+t.max[0])/2,cz:(t.min[2]+t.max[2])/2,top:Math.max(.09,t.min[1]-.12)}
}
