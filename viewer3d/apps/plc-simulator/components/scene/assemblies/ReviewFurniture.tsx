import {MaterialTableLegs} from './MaterialTableLegs'
import {Foot,Profile} from './MaterialV6Details'
import {Part} from './Parts'
import type {Furniture} from '@/app/replay/hard-processes/reviewFurniture'

/** Inset panels leave a visible reveal around the structural frame. */
export function ReviewFurniture({furniture,posts=[]}:{furniture:Furniture[];posts?:{id:string;x:number;z:number;bottom:number;top:number;edge:number}[]}){return <group name="review-common-furniture">
 {posts.map(p=><group key={p.id} name={'common-support-'+p.id}>
  {p.bottom<.06&&<Foot p={[p.x,0,p.z]}/>}
  <Profile p={[p.x,(p.top+p.bottom)/2,p.z]} length={p.top-p.bottom} edge={p.edge}/>
 </group>)}
 {furniture.map(b=>{
  const hx=b.w/2-.0275,hz=b.d/2-.0275,bottom=.06,height=b.top-bottom-.014
  return <group key={b.id} name={'furniture-'+b.id} position={[b.x,0,b.z]}>
   {b.preserveLegs?<>
    {b.floorFeet?.map(([x,z],i)=><group key={i} position={[x,0,z]} scale={[1,.05/.042,1]}><Foot p={[0,0,0]}/></group>)}
    {[-1,1].map(k=><Part key={k} name="bench-stretcher" position={[0,Math.min(.25,b.top*.42),k*hz]} size={[Math.max(.01,2*hx-.055),.035,.028]} color="#303b45"/>)}
   </>:<MaterialTableLegs halfX={hx} halfZ={hz} top={b.enclosed?b.top-.012:b.top-.05}/>}
   {!b.enclosed&&<>
    {[-1,1].map(k=><group key={k}>
     <Part name="bench-top-longitudinal" position={[0,b.top-.025,k*hz]} size={[b.w,.05,.055]} color="#35434e"/>
     <Part name="bench-top-crossmember" position={[k*hx,b.top-.025,0]} size={[.055,.05,Math.max(.01,b.d-.11)]} color="#35434e"/>
    </group>)}
   </>}
   {b.enclosed&&<>
    {[-1,1].map(k=><group key={k}>
     <Part name="service-cover-side" position={[k*(hx-.0285),bottom+height/2,0]} size={[.012,height,Math.max(.02,b.d-.10)]} color="#a3afb9"/>
     <Part name="service-cover-door" position={[0,bottom+height/2,k*(hz-.0285)]} size={[Math.max(.02,b.w-.10),height,.012]} color="#a3afb9"/>
     {b.w>.26&&<Part name="service-cover-handle" position={[Math.min(.12,b.w*.23),bottom+height*.65,k*(hz-.0155)]} size={[.012,Math.min(.09,height*.45),.014]} color="#303b45"/>}
    </group>)}
    <Part name="service-cover-bottom" position={[0,bottom-.006,0]} size={[Math.max(.02,b.w-.10),.012,Math.max(.02,b.d-.10)]} color="#303b45"/>
    <Part name="bench-top" position={[0,b.top-.006,0]} size={[b.w,.012,b.d]} color="#a3afb9"/>
   </>}
  </group>
 })}
 </group>}
