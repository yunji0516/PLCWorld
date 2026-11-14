import { useRef } from 'react'
import { useFrame } from '@react-three/fiber'
import type { Group, Mesh } from 'three'
import type { DeviceProps } from '../devices'
import type { Plant } from '@/lib/machine/plant'
import { BoredPlate, Part, RoundPart, FINISH } from './Parts'
import { TendingPlate } from './TendingHardware'

/** Opt-in spindle. Tool tip is exactly local Y=-.14. */
export function MachiningSpindle({ device, plant }: DeviceProps) {
  const spindle=useRef<Group>(null)
  useFrame(()=>{if(spindle.current)spindle.current.rotation.y=plant.state(device.id).pos})
  return <group name="assembly-machining-spindle-v1">
    <Part name="spindle-motor-housing" size={[.085,.14,.085]} position={[0,.08,0]} radius={.008}/>
    <Part name="spindle-rear-mount" size={[.07,.07,.02]} position={[0,.08,-.0525]} color={FINISH.dark}/>
    <group ref={spindle} name="spindle-rotating-tool">
      <RoundPart name="spindle-chuck" position={[0,-.015,0]} radius={.024} length={.05} axis="y"/>
      <RoundPart name="drill-cutting-envelope" position={[0,-.09,0]} radius={.009} length={.10} axis="y" color={FINISH.dark}/>
      <Part name="drill-flute-marker" size={[.003,.075,.003]} position={[.006,-.09,.004]} color={FINISH.steel} radius={.001}/>
    </group>
  </group>
}

/** Ideal blind-hole geometry. Uncut cores fill genuine bores, rather than painted black discs. */
export function MachinedWorkpiece({plant,id,tending=false}:{plant:Plant;id:number;tending?:boolean}) {
  const root=useRef<Group>(null),first=useRef<Mesh>(null),second=useRef<Mesh>(null)
  const color=tending ? (plant.parts.find(p=>p.id===id)?.color??'#d9ab55') : '#d9ab55'
  useFrame(()=>{
    const p=plant.parts.find(p=>p.id===id);if(!p||!root.current)return
    root.current.position.set(p.x,p.y??.68,p.z??0)
    for(const [i,ref] of [first,second].entries())if(ref.current){
      const depth=Math.max(0,Math.min(.06,p.machiningDepths?.[i]??0))
      ref.current.position.y=-depth/2;ref.current.scale.y=.16-depth
    }
  })
  return <group ref={root} name={`machined-workpiece-${id}`}>
    {tending && !/^MAT-H01(?:\s|$)/.test(plant.machine.title) && <TendingPlate label={`P${id}`} position={[0,0,-.0805]} size={[.09,.033]}/>}
    <group rotation={[Math.PI/2,0,0]}>
      <BoredPlate name="blank-with-machining-bores" size={[.16,.16,.16]} position={[0,0,0]} corner={.002}
        holes={[{x:-.04,y:0,radius:.010},{x:.04,y:0,radius:.010}]} color={color}/>
    </group>
    {[first,second].map((ref,i)=><mesh key={i} ref={ref} name={`remaining-stock-${i+1}`} position={[i===0?-.04:.04,0,0]} scale={[1,.16,1]} castShadow receiveShadow>
      <cylinderGeometry args={[.010,.010,1,40]}/><meshStandardMaterial color={color} roughness={.64} metalness={.65}/>
    </mesh>)}
  </group>
}
