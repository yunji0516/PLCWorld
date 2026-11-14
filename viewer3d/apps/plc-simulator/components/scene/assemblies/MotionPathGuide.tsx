'use client'

import {useEffect,useMemo} from 'react'
import {BufferGeometry,Float32BufferAttribute,Vector3,Quaternion} from 'three'
import type {MotionHardState} from '@/lib/replay/adapter'
import {FINISH,Part,RoundPart} from './Parts'
import {useIndexEquipmentColor,useIndustrialSurface} from './IndexEquipmentPalette'
import {SocketBolt} from '../IndustrialDetails'


export type TransportPath = {
 revision:number;shape:string;radius:number;
 station_frames:Record<string,{pos:[number,number,number];quaternion:[number,number,number,number]}>;
 samples:{s:number;pos:[number,number,number];quaternion:[number,number,number,number]}[];
 supports:{pos:[number,number,number];quaternion:[number,number,number,number]}[];
}

/** Short closed rail sections follow the same arc-length geometry as the plant. */
function GuideStrip({path,offset,width,bottom,height,name,color}:{path:TransportPath;offset:number;width:number;bottom:number;height:number;name:string;color:string}){
 const finish=useIndexEquipmentColor(color),surface=useIndustrialSurface(color)
 const continuous=useMemo(()=>{
  const corners=path.samples.map(sample=>[[-width/2,bottom],[width/2,bottom],[width/2,bottom+height],[-width/2,bottom+height]].map(([z,y])=>new Vector3(0,y,offset+z).applyQuaternion(new Quaternion(...sample.quaternion)).add(new Vector3(...sample.pos)).toArray()))
  const vertices:number[]=[],indices:number[]=[]
  // Separate vertices at profile edges, shared vertices along each continuous face.
  // No coincident end caps at every sample; those caused faceted curved joints.
  for(let side=0;side<4;side++){
   const base=vertices.length/3
   for(const c of corners)vertices.push(...c[side],...c[(side+1)%4])
   for(let i=0;i<corners.length-1;i++){const a=base+i*2;indices.push(a,a+3,a+1,a,a+2,a+3)}
  }
  for(const end of [0,corners.length-1]){const b=vertices.length/3;vertices.push(...corners[end].flat());indices.push(...(end===0?[b,b+1,b+2,b,b+2,b+3]:[b,b+2,b+1,b,b+3,b+2]))}
  const g=new BufferGeometry();g.setAttribute('position',new Float32BufferAttribute(vertices,3));g.setIndex(indices);g.computeVertexNormals();return g
 },[path,offset,width,bottom,height])
 useEffect(()=>()=>continuous?.dispose(),[continuous])
 return <mesh name={name} geometry={continuous} castShadow receiveShadow><meshStandardMaterial color={finish} {...surface}/></mesh>
}

export function MotionPathGuide({layout}:{layout:NonNullable<MotionHardState['process']>['layout']}){
 const path=layout.transport_path!
 return <group name="path-guide-fixed" position={[0,layout.rail_y,0]}>
  <GuideStrip path={path} name="path-guide-bed" offset={0} width={.42} bottom={-.0336} height={.0672} color={FINISH.alloy}/>
  <GuideStrip path={path} name="path-linear-motor-stator" offset={0} width={.07} bottom={.0336} height={.018} color={FINISH.dark}/>
  {[-1,1].map(side=><GuideStrip key={side} path={path} name={`path-guide-rail-${side}`} offset={side*.1176} width={.0504} bottom={.0434} height={.0364} color={FINISH.steel}/>)}
  {[-1,1].map(side=><group key={side}>
    <GuideStrip path={path} name={`path-rail-seat-${side}`} offset={side*.1176} width={.06552} bottom={.0336} height={.0098} color={FINISH.alloy}/>
   </group>)}
  <group name="motion-path-bed-fasteners">
   {path.samples.filter((_,i)=>i%Math.max(1,Math.ceil(path.samples.length/24))===0).map((p,i)=><group key={i} position={p.pos} quaternion={p.quaternion}>
    {[-1,1].map(side=><SocketBolt key={side} top position={[0,.034,side*.181]} radius={.005}/>)}
   </group>)}
  </group>
  {path.supports.map((p,i)=><group key={i} position={p.pos} quaternion={p.quaternion} name="path-guide-support">
   <Part name="track-support" position={[0,-layout.rail_y/2,0]} size={[.16,layout.rail_y,.24]} color={FINISH.dark}/>
   <Part name="track-foot" position={[0,-layout.rail_y+.04,0]} size={[.5,.08,.65]} color={FINISH.dark}/>
   <Part name="rail-seat-crossbar" position={[0,.036,0]} size={[.09,.012,.34]} color={FINISH.alloy}/>
  </group>)}
 </group>
}

/** Pivoted short bogies follow the curve; a rigid deck carries the original fork. */
export function PathBogie(){return <group name="path-pivot-bogie">
 <Part name="bogie-crossmember" position={[0,.1025,0]} size={[.085,.05,.16]} color={FINISH.steel}/>
 {[-1,1].map(side=><group key={side}>
  <Part name="bogie-outer-bearing-cheek" position={[0,.10125,side*.16]} size={[.085,.0525,.03]}/><RoundPart name="load-roller-axle" position={[0,.0998,side*.12]} radius={.006} length={.08} axis="z"/>
  <RoundPart name="guide-load-roller" position={[0,.0998,side*.1176]} radius={.02} length={.046} axis="z" color={FINISH.dark}/>
  {[-1,1].map(edge=><group key={edge}><RoundPart name="side-roller-pin" position={[0,.08,side*.1176+edge*.0442]} radius={.0045} length={.04} axis="y"/><RoundPart name="guide-side-roller" position={[0,.06,side*.1176+edge*.0442]} radius={.019} length={.028} axis="y" color={FINISH.dark}/></group>)}
 </group>)}
 <RoundPart name="bogie-swivel-bearing" position={[0,.13875,0]} radius={.04} length={.0225} axis="y"/>
</group>}

export function PathCarriage(){return <group name="path-carriage-deck">
 <Part name="servo-carriage-deck" position={[0,.1636,0]} size={[.34,.0272,.3864]}/>
 <Part name="servo-tooling-plate" position={[0,.2072,0]} size={[.22,.06,.3024]} color={FINISH.blue}/>
</group>}
