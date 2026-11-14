'use client'

import {DoubleSide} from 'three'
import {Part,FINISH} from './Parts'
import {Profile} from './MaterialV6Details'
import {SocketBolt} from '../IndustrialDetails'
import {INDEX_GUARD,INDEX_GUARD_BAYS,INDEX_GUARD_POSTS,type GuardBay} from './indexGuardLayout'

function Pane({width,bottom,top,name}:{width:number;bottom:number;top:number;name:string}){
 return <mesh name={`index-cell-guard-glass-${name}`} position={[0,(bottom+top)/2,0]} raycast={()=>null}>
  <planeGeometry args={[width,top-bottom]}/>
  <meshStandardMaterial color="#c9dbe2" transparent opacity={.065} depthWrite={false} roughness={.32} metalness={0} side={DoubleSide}/>
 </mesh>
}
function Bay({bay}:{bay:GuardBay}){
 const dx=bay.b[0]-bay.a[0],dz=bay.b[1]-bay.a[1],span=Math.hypot(dx,dz),clear=span-.03
 const top=INDEX_GUARD.height-.03
 const rail=(y:number)=><Part name="index-cell-guard-rail" position={[0,y,0]} size={[clear,.025,.025]} color={FINISH.alloy}/>
 return <group name={`index-cell-guard-bay-${bay.id}`} position={[(bay.a[0]+bay.b[0])/2,0,(bay.a[1]+bay.b[1])/2]} rotation={[0,-Math.atan2(dz,dx),0]}>
  {rail(INDEX_GUARD.height-.015)}{!bay.outfeed&&rail(.1125)}
  {bay.outfeed?<>
   {/* The portal surrounds the complete conveyor module, including the
       cabinet below the belt: y=0..1.115, x=-.265...265. */}
   {rail(1.1275)}
   <Pane name="outfeed-upper" width={clear} bottom={1.14} top={top}/>
  </>:bay.door?<>
   {/* A closed leaf, inset from fixed posts: the seams, hinges and handle
       identify access without adding an unmodelled door operation. */}
   {[-1,1].map(side=><Part key={side} name="index-cell-guard-door-stile" position={[side*(clear/2-.014),1.2075,0]} size={[.02,2.115,.022]} color={FINISH.alloy}/>)}
   {[.14,2.275].map(y=><Part key={y} name="index-cell-guard-door-leaf-rail" position={[0,y,0]} size={[clear-.008,.02,.022]} color={FINISH.alloy}/>)}
   <Pane name={bay.id} width={clear-.048} bottom={.15} top={2.265}/>
   {[.43,1.94].map(y=><Part key={y} name="index-cell-guard-hinge" position={[-clear/2-.003,y,.023]} size={[.032,.065,.024]} color={FINISH.steel}/>)}
   {[.96,1.08].map(y=><Part key={y} name="index-cell-guard-handle-standoff" position={[clear/2-.014,y,.025]} size={[.02,.02,.028]} color={FINISH.dark}/>)}
   <Part name="index-cell-guard-door-handle" position={[clear/2-.014,1.02,.043]} size={[.018,.14,.018]} color={FINISH.dark}/>
  </>:<Pane name={bay.id} width={clear} bottom={.125} top={top}/>}
 </group>
}

export function IndexCellGuard(){return <group name="index-cell-perimeter-guard">
 {INDEX_GUARD_POSTS.map(([x,z])=><group key={`${x}:${z}`}>
  <Profile p={[x,1.18,z]} length={2.28} edge={.03}/>
  <Part name="index-cell-guard-anchor" position={[x,.02,z]} size={[.105,.04,.105]} color={FINISH.dark}/>
  {[-1,1].map(k=><SocketBolt key={k} top position={[x+k*.033,.041,z+k*.033]} radius={.005}/>)}
 </group>)}
 {INDEX_GUARD_BAYS.map(bay=><Bay key={bay.id} bay={bay}/>)}
</group>}
