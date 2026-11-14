'use client'
import {createContext,useContext} from 'react'
import {SocketBolt} from '../IndustrialDetails'
import {isMotionProfile} from './MotionStructuralGeometry'
import {motionFittingLayout} from './motionFittingLayout'

export const MotionRealism=createContext(false)
export const useMotionRealism=()=>useContext(MotionRealism)
const metal='#89939b',dark='#303b45'
/** Cosmetic fittings only: they inherit the parent's transform and introduce no state. */
export function MotionBoxFittings({name='',size}:{name?:string;size:readonly number[]}) {
 const p=motionFittingLayout(name,size)
 if(!p||isMotionProfile(name,size))return null
 const {w,h,d,boltRadius:r,inset}=p
 if(p.kind==='foot')return <group name="motion-anchor-fasteners">
  {[-1,1].flatMap(x=>[-1,1].map(z=><SocketBolt key={`${x}:${z}`} top position={[x*(w/2-inset),h/2+.0005,z*(d/2-inset)]} radius={r}/>))}
 </group>
 if(p.kind==='post')return <group name="motion-column-machining">
  {[-1,1].map(s=><group key={s}>
   <mesh position={[0,0,s*(d/2+.0005)]}><boxGeometry args={[w*.15,h*.82,.001]}/><meshStandardMaterial color={dark} roughness={.8}/></mesh>
   <group rotation={[0,s<0?Math.PI:0,0]}>
    {[-1,1].map(y=><SocketBolt key={y} position={[w*.28,y*h*.4,d/2+.001]} radius={r*.7}/>)}
   </group>
  </group>)}
 </group>
 return <group name="motion-housing-machining">
  {/* A thin service cover and fasteners on the non-contact front face. */}
  <mesh position={[0,0,d/2+.001]}><boxGeometry args={[w*.72,h*.70,.002]}/><meshStandardMaterial color={metal} roughness={.58} metalness={.65}/></mesh>
  {[-1,1].flatMap(x=>[-1,1].map(y=><SocketBolt key={`${x}:${y}`} position={[x*w*.29,y*h*.27,d/2+.003]} radius={r}/>))}
  {p.kind==='motor'&&[-2,-1,0,1,2].map(i=><mesh key={i} position={[i*w*.13,0,-d/2-.0015]}>
   <boxGeometry args={[Math.min(.008,w*.025),h*.72,.003]}/><meshStandardMaterial color={dark} roughness={.7} metalness={.3}/>
  </mesh>)}
  {p.kind==='cabinet'&&<mesh position={[w*.20,0,d/2+.006]}><boxGeometry args={[Math.min(.018,w*.025),Math.min(.10,h*.24),.008]}/><meshStandardMaterial color={dark} roughness={.8}/></mesh>}
 </group>
}
export function MotionBearingFittings({name='',radius,length}:{name?:string;radius:number;length:number}) {
 if(!/(?:bearing|reducer|motor|pedestal)$/.test(name)||radius<.055||length<.04)return null
 return <group name="motion-bearing-fasteners">
  {[-1,1].map(s=><group key={s} position={[0,s*(length/2+.001),0]} rotation={[s>0?-Math.PI/2:Math.PI/2,0,0]}>
   <mesh><ringGeometry args={[radius*.75,radius*.96,32]}/><meshStandardMaterial color={metal} roughness={.5} metalness={.7}/></mesh>
   {[0,1,2,3].map(i=><SocketBolt key={i} position={[Math.cos(i*Math.PI/2)*radius*.83,Math.sin(i*Math.PI/2)*radius*.83,.001]} radius={Math.min(.008,radius*.065)}/>)}
  </group>)}
 </group>
}
