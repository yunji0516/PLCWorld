'use client'
import {useMemo,useEffect} from 'react'
import {Shape,ExtrudeGeometry} from 'three'
import {SocketBolt} from '../IndustrialDetails'
import {Part,FINISH} from './Parts'
import {MotionRealism} from './MotionRealism'
import {useIndexEquipmentColor,useIndustrialSurface} from './IndexEquipmentPalette'
type V=[number,number,number]
/** Fixed equipment foundations. Top and floor datums are supplied by the installation. */
export function MotionMachineBase({size,position=[0,0,0],kind='skid'}:{size:V;position?:V;kind?:'skid'|'casting'}){
 const [w,h,d]=size,cap=Math.min(.055,h/2),bottom=Math.min(.035,h/2),body=h-cap-bottom
 const color=useIndexEquipmentColor(FINISH.dark),surface=useIndustrialSurface(FINISH.dark)
 const casting=useMemo(()=>{
  if(h<=.12||kind!=='casting')return null
  const s=new Shape();s.moveTo(-w*.47,bottom);s.lineTo(w*.47,bottom);s.lineTo(w*.41,h-cap);s.lineTo(-w*.41,h-cap);s.closePath()
  const g=new ExtrudeGeometry(s,{depth:d*.82,bevelEnabled:false});g.translate(0,0,-d*.41);return g
 },[w,h,d,bottom,cap,kind])
 useEffect(()=>()=>casting?.dispose(),[casting])
 return <MotionRealism.Provider value={false}><group position={position} name={'heavy-machine-base-'+kind}>
  <Part name="machine-machined-mounting-deck" position={[0,h-cap/2,0]} size={[w,cap,d]} color={h<=.12?FINISH.dark:FINISH.steel} radius={.004}/>
  {h<=.12?<Part name="machine-ground-plinth" position={[0,(h-cap)/2,0]} size={[w-.025,h-cap,d-.025]} color={FINISH.dark} radius={.004}/>:kind==='casting'?<>
   <Part name="casting-anchor-flange" position={[0,bottom/2,0]} size={[w,bottom,d]} color={FINISH.dark}/>
   <mesh name="tapered-machine-casting" geometry={casting!} castShadow receiveShadow><meshStandardMaterial color={color} {...surface}/></mesh>
   <Part name="casting-inspection-cover" position={[0,bottom+body*.52,d*.41+.004]} size={[Math.min(w*.44,.55),body*.56,.008]} color={FINISH.blue} radius={.009}/>
   {[-1,1].flatMap(x=>[-1,1].map(y=><SocketBolt key={`${x}:${y}`} position={[x*Math.min(w*.18,.22),bottom+body*(.52+y*.21),d*.41+.009]} radius={.005}/>))}
  </>:<>
   {[-1,1].map(z=><group key={z}>
    <Part name="welded-box-girder" position={[0,bottom+body/2,z*(d/2-.13)]} size={[w-.06,body,.20]} color={FINISH.dark} radius={.006}/>
    <Part name="girder-floor-flange" position={[0,bottom/2,z*(d/2-.13)]} size={[w,bottom,.26]} color={FINISH.steel}/>
    {[-1,1].flatMap(x=>[-1,1].map(edge=><SocketBolt key={`${x}:${edge}`} top position={[x*w*.40,bottom+.001,z*(d/2-.13)+edge*.113]} radius={.007}/>))}
   </group>)}
   {[-1,1].map(x=><Part key={x} name="welded-cross-diaphragm" position={[x*w*.30,bottom+body/2,0]} size={[.10,body,Math.max(.02,d-.46)]} color={FINISH.dark}/>)}
  </>}
  {kind==='casting'&&h>.12&&[-1,1].flatMap(x=>[-1,1].map(z=><SocketBolt key={`${x}:${z}`} top position={[x*w*.42,bottom+.001,z*d*.46]} radius={.008}/>))}
 </group></MotionRealism.Provider>
}
