import {presentationCorrections} from './presentationCorrections'
import {Euler,Vector3} from 'three'
import type {Node, Pose, Review, V3} from './ReviewCanvas'

export type FloorBounds = {x:number;z:number;width:number;depth:number}

/** Fixed painted operating envelope, shared by all replay variants and scans.
 * Drawing margins are not certified personnel safety clearances.
 */
export function reviewFloorBounds(review:Review|null):FloorBounds|undefined {
  if(!review)return undefined
  let minX=Infinity,maxX=-Infinity,minZ=Infinity,maxZ=-Infinity
  const point=(p:V3,dx=0,dz=dx)=>{
    minX=Math.min(minX,p[0]-dx);maxX=Math.max(maxX,p[0]+dx)
    minZ=Math.min(minZ,p[2]-dz);maxZ=Math.max(maxZ,p[2]+dz)
  }
  const include=(node:Node,pose:Pose=node)=>{
    if(/^controls?(?:_|$)/.test(node.id)||node.shape==='label' || !(pose.visible ?? node.visible ?? true))return
    const size=pose.s || node.size
    if(['ribbon','panel','beam'].includes(node.shape)){
      // These geometries use world-space vertices, not node group transforms.
      const pad=node.shape==='beam'?size[0]:node.shape==='ribbon'?node.size[1]/2+1.5*node.size[0]:0
      for(const p of pose.points || node.points || [])point(p,pad)
      return
    }
    let extent:V3=[...size]
    if(node.shape==='cylinder'){
      extent=[2*size[0],size[1],2*size[2]]
      if(node.axis==='x')extent=[extent[1],extent[0],extent[2]]
      if(node.axis==='z')extent=[extent[0],extent[2],extent[1]]
    }else if(node.shape==='tube')extent=[2*size[0],size[1],2*size[0]]
    const euler=new Euler(pose.rx ?? 0,pose.r,pose.rz ?? 0)
    for(const x of [-1,1])for(const y of [-1,1])for(const z of [-1,1]){
      const v=new Vector3(x*extent[0]/2,y*extent[1]/2,z*extent[2]/2).applyEuler(euler)
      point([pose.p[0]+v.x,pose.p[1]+v.y,pose.p[2]+v.z])
    }
  }
  const runs=Object.entries(review.runs).filter(([key,run])=>['normal','alternate'].includes(key) && !run.failure)
  for(const [,run] of runs){
    const corrected=presentationCorrections(run.nodes)
    const nodes=new Map(corrected.map(n=>[n.id,n]))
    corrected.forEach(n=>include(n))
    for(const frame of run.frames)for(const [id,pose] of Object.entries(frame.poses)){
      const node=nodes.get(id);if(node&&!node.presentationFixed)include(node,pose)
    }
  }
  if(!runs.length)review.nodes.forEach(n=>include(n))
  if(!Number.isFinite(minX))return undefined
  // Keep H05's .22 m operator band clear of equipment feet and cabinet plinths;
  // its inner edge lies .35 m inside the outline. Guard footprints are omitted.
  const margin=review.id==='H05'?.65:.35
  return {x:(minX+maxX)/2,z:(minZ+maxZ)/2,width:maxX-minX+2*margin,depth:maxZ-minZ+2*margin}
}
