'use client'
import {useRef,useMemo} from 'react'
import {useFrame} from '@react-three/fiber'
import {Group,Mesh,Vector3} from 'three'
import type {DeviceProps} from '../devices'
import type {Plant} from '@/lib/machine/plant'
import {Part,BoredPlate,RoundPart,FINISH} from './Parts'

/** An actual hollow workpiece with a top test port; nominal envelope .16 m. */
export function PressureVessel({plant,id}:{plant:Plant;id:number}){
 const root=useRef<Group>(null)
 useFrame(()=>{const p=plant.parts.find(p=>p.id===id);if(p&&root.current)root.current.position.set(p.x,p.y??.68,p.z??0)})
 return <group ref={root} name={`pressure-workpiece-${id}`}>
  {[-1,1].map(s=><Part key={'x'+s} size={[.012,.136,.16]} position={[s*.074,0,0]} color="#d7a655"/>)}
  {[-1,1].map(s=><Part key={'z'+s} size={[.136,.136,.012]} position={[0,0,s*.074]} color="#d7a655"/>)}
  <Part size={[.16,.012,.16]} position={[0,-.074,0]} color="#d7a655"/>
  <group rotation={[Math.PI/2,0,0]} position={[0,.074,0]}>
   <BoredPlate name="test-port-flange" size={[.16,.16,.012]} position={[0,0,0]} holes={[{x:0,y:0,radius:.025}]} corner={.002} color="#d7a655"/>
  </group>
 </group>
}

/** Gasket bottom local Y=-.06 meets the test-port flange at the lower endpoint. */
export function PressureSealHead({device}:DeviceProps){
 const hose=useRef<Mesh>(null),up=useMemo(()=>new Vector3(0,1,0),[])
 useFrame(()=>{if(!hose.current)return
  const start=new Vector3(.105,.02,0),end=new Vector3(.43,.83,.22).sub(new Vector3(...device.pos)),delta=end.clone().sub(start)
  hose.current.position.copy(start).add(end).multiplyScalar(.5);hose.current.scale.y=delta.length();hose.current.quaternion.setFromUnitVectors(up,delta.normalize())
 })
 return <group name="pressure-sealing-head">
  <Part name="seal-head-body" size={[.14,.10,.14]} position={[0,.01,0]} radius={.008}/>
  <group rotation={[Math.PI/2,0,0]} position={[0,-.05,0]}>
   <BoredPlate name="sealing-gasket" size={[.10,.10,.02]} position={[0,0,0]} holes={[{x:0,y:0,radius:.027}]} color={FINISH.seal} corner={.018}/>
  </group>
  <RoundPart name="seal-air-fitting" radius={.013} length={.035} position={[.0875,.02,0]} axis="x" segments={6}/>
  <mesh ref={hose} name="seal-flexible-air-line" castShadow><cylinderGeometry args={[.007,.007,1,16]}/><meshStandardMaterial color="#38586c" roughness={.8}/></mesh>
 </group>
}

export function PressureTestModule({device,plant}:DeviceProps){
 const bar=useRef<Mesh>(null)
 useFrame(()=>{if(bar.current){const p=Math.max(0,Math.min(1,plant.state(device.id).pos));bar.current.scale.y=Math.max(.001,p);bar.current.position.y=.05+.10*p/2}})
 return <group name="pressure-test-module">
  <Part size={[.24,.34,.025]} position={[0,0,-.1075]} color={FINISH.dark}/>
  <Part size={[.24,.14,.21]} position={[0,.10,.0125]} color={FINISH.steel}/>
  <Part size={[.16,.105,.008]} position={[0,.10,.122]} color={FINISH.dark}/>
  <mesh ref={bar} name="pressure-gauge-bar" position={[0,.015,.128]}><boxGeometry args={[.10,.10,.006]}/><meshStandardMaterial color="#4fc5c9" roughness={.7}/></mesh>
  <Part size={[.24,.025,.24]} position={[0,-.1575,0]}/>
  <RoundPart radius={.014} length={.025} position={[0,0,.1325]} segments={6}/>
 </group>
}
export function TestAirValve({device,plant}:DeviceProps){
 const led=useRef<Mesh>(null)
 useFrame(()=>{if(led.current)led.current.visible=plant.state(device.id).pos>.5})
 return <group name="test-air-valve">
  <Part size={[.10,.06,.09]} position={[0,-.02,0]} radius={.004}/>
  <Part size={[.055,.04,.055]} position={[0,.03,0]} color={FINISH.dark} radius={.004}/>
  <mesh ref={led} position={[0,.051,0]}><boxGeometry args={[.014,.004,.014]}/><meshBasicMaterial color="#65d6a5"/></mesh>
 </group>
}
