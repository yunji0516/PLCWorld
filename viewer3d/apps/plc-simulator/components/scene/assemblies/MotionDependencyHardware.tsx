'use client'
import {dependencyEquipment} from '@/lib/replay/dependencyEquipment'
import {RecordedCylinderBody} from './MotionRecordedMachining'

import { memo, useRef, useMemo, useEffect } from 'react'
import { useFrame } from '@react-three/fiber'
import type { Group, Mesh, MeshStandardMaterial } from 'three'
import { BufferGeometry, Float32BufferAttribute, CylinderGeometry, TorusGeometry, Shape, Path, ExtrudeGeometry } from 'three'
import type { DeviceProps } from '../devices'
import type { MotionHardState } from '@/lib/replay/adapter'
import { SocketBolt, MachinedBoxGeometry } from '../IndustrialDetails'
import { satinFinish } from '../surfaceFinish'
import {motionEquipmentColor} from './motionEquipmentFinish'
import {FittedMaterialDrive} from './FittedMaterialDrive'
import { FINISH, Part } from './Parts'
import {useMotionPresentation} from './MotionPresentation'
import {useIndustrialSurface,useIndexEquipmentColor} from './IndexEquipmentPalette'
import {TABLE_FINISH,tablePartRole} from './tableFinish'
import {MaterialTableLegs} from './MaterialTableLegs'
import {MotionBoxFittings} from './MotionRealism'
import {isDisplayPlinth, displayGroundOffset, groundedInstallationPart, mediumMountingPlate} from './displayPlinth'

import {joinedBoxSurfaces} from './joinedBoxSurfaces'
import {seatedDependencyPart,isJoinedInstallation,redundantDependencyPart} from './dependencyInstallation'

type RecordedGeometry=NonNullable<MotionHardState['dependency']>['parts'][number]
/** Surface fittings follow the same recorded transform as their parent part. */
function AlignmentDetails({part}:{part:RecordedGeometry}) {
  const [w,h,d]=part.size
  if(part.shape==='cylinder'&&part.style==='motor')return <group name="alignment-motor-end-fittings">
    {[-1,1].map(s=><mesh key={s} position={[s*.507,0,0]} rotation={[0,0,Math.PI/2]}>
      <cylinderGeometry args={[.42,.42,.014,24]}/><meshStandardMaterial color={FINISH.steel} metalness={.65} roughness={.62}/>
    </mesh>)}
    {[-.3,-.1,.1,.3].map(x=><mesh key={x} position={[x,0,0]} rotation={[0,0,Math.PI/2]}>
      <cylinderGeometry args={[.515,.515,.018,24]}/><meshStandardMaterial color={FINISH.dark}/>
    </mesh>)}
  </group>
  if(part.shape!=='box')return null
  const rail=part.style==='rail'&&Math.max(w,d)>.5&&h>.025
  const longX=w>d
  const post=part.name.startsWith('Support frame')
  return <group name="alignment-machining-details">
    {rail&&[-1,1].map(s=><mesh key={s} position={longX?[0,0,s*.507]:[s*.507,0,0]}>
      <boxGeometry args={longX?[.94,.18,.014]:[.014,.18,.94]}/><meshStandardMaterial color={FINISH.dark} roughness={.6}/>
    </mesh>)}
    {rail&&part.name.startsWith('Longitudinal')&&Array.from({length:9},(_,i)=><mesh key={i} position={[(i/8-.5)*.90,.51,0]}>
      <cylinderGeometry args={[.055,.055,.018,6]}/><meshStandardMaterial color={FINISH.dark}/>
    </mesh>)}
    {post&&[-1,1].map(s=><mesh key={s} position={[s*.507,0,0]}>
      <boxGeometry args={[.014,.88,.16]}/><meshStandardMaterial color={FINISH.seal}/>
    </mesh>)}
  </group>
}
/** The same machined metal/rail/motor vocabulary as ServoAssembly and CylinderAssembly.
 * Details fit in each recorded bounding box and add no simulated actuator or sensor. */
function SurfaceDetails({part}:{part:RecordedGeometry}) {
 const [w,h,d]=part.size,style=part.style
 if(!style||style==='actuator'||part.node?.startsWith('protected')||!['rail','plate','carriage','actuator'].includes(style))return null
 const r=Math.min(.006,w*.045,d*.045)
 if(r<.001)return null
 // Physical-size screw heads stay round even on a long or very thin recorded part.
 const n=Math.max(2,Math.ceil(Math.max(w,d)/.28))
 const bolts: [number,number][] = style==='rail'
  ? Array.from({length:n},(_,i)=>w>d?[(i/(n-1)-.5)*w*.85,0]:[0,(i/(n-1)-.5)*d*.85])
  : [-1,1].flatMap(x=>[-1,1].map(z=>[x*w*.34,z*d*.32] as [number,number]))
 return <group name="recorded-part-material-fasteners" scale={[1/w,1/h,1/d]}>
  {bolts.filter(([x,z])=>!part.holes?.some(hole=>Math.hypot(x/w-hole.x,z/d-hole.z)<hole.radius+r/Math.min(w,d))).map(([x,z],i)=><SocketBolt key={i} top position={[x,h/2+r*.3,z]} radius={r}/>)}
 </group>
}

function PartGeometry({part,mechanical,surface}:{part:RecordedGeometry;mechanical:boolean;surface:ReturnType<typeof joinedBoxSurfaces>}) {
  const holeKey=JSON.stringify(part.holes??[])
  const geometry=useMemo(()=>{
    if(surface) {
      const g=new BufferGeometry()
      g.setAttribute('position',new Float32BufferAttribute(surface.positions,3))
      g.setAttribute('normal',new Float32BufferAttribute(surface.normals,3))
      return g
    }
    if(part.shape==='bored_disc') {
      const shape=new Shape();shape.absarc(0,0,.5,0,Math.PI*2,false)
      for(const h of JSON.parse(holeKey) as {x:number;z:number;radius:number}[]) {
        const hole=new Path();hole.absarc(h.x,-h.z,h.radius,0,Math.PI*2,true);shape.holes.push(hole)
      }
      const g=new ExtrudeGeometry(shape,{depth:1,bevelEnabled:false,curveSegments:32})
      g.translate(0,0,-.5);g.rotateX(-Math.PI/2);return g
    }
    if(part.shape!=='cylinder'&&part.shape!=='ring')return null
    // Cylinder Y and torus Z are baked into the requested axis so mesh.scale remains XYZ bounds.
    const axis=part.axis??'y'
    if(part.shape==='ring') {
      const g=new TorusGeometry(.40,.10,10,32)
      if(axis==='y')g.rotateX(Math.PI/2)
      else if(axis==='x')g.rotateY(Math.PI/2)
      g.computeBoundingBox();const b=g.boundingBox!
      g.scale(1/(b.max.x-b.min.x),1/(b.max.y-b.min.y),1/(b.max.z-b.min.z))
      return g
    }
    const g=new CylinderGeometry(.5,.5,1,32)
    if(axis==='z')g.rotateX(Math.PI/2)
    else if(axis==='x')g.rotateZ(Math.PI/2)
    return g
  },[part.shape,part.axis,holeKey,surface])
  useEffect(()=>()=>geometry?.dispose(),[geometry])
  if((part.style==='motor'||part.style==='actuator')&&!part.node?.startsWith('protected'))return <bufferGeometry/>
  if(geometry)return <primitive object={geometry} attach="geometry"/>
  return mechanical?<MachinedBoxGeometry args={[1,1,1]} detailed radius={.025}/>:<boxGeometry args={[1,1,1]}/>
}

type Reader = { motionHardState(): MotionHardState | undefined }
function RecordedPart({reader,index,surface}:{reader:Reader;index:number;surface:ReturnType<typeof joinedBoxSurfaces>}) {
  const refined=useMotionPresentation()
  const root=useRef<Group>(null),mesh=useRef<Mesh>(null),material=useRef<MeshStandardMaterial>(null)
  const dependency=reader.motionHardState()?.dependency
  const initial=dependency?.parts[index]
  const floorOffset=dependency?displayGroundOffset(dependency.parts):0
  const sourceColor=initial?(initial.node?.startsWith('protected')?initial.color:motionEquipmentColor(initial.name,initial.color,initial.style)):FINISH.alloy
  const finish=useIndexEquipmentColor(sourceColor)
  const industrialSurface=useIndustrialSurface(sourceColor)
  const role=tablePartRole(initial?.name)
  const displayColor=role?TABLE_FINISH[role]:finish
  const mechanical=reader.motionHardState()?.dependency?.version==='motion-grounded-geometry/4.1'
  useFrame(()=>{
    const state=reader.motionHardState(),part=state?.dependency?.parts[index]
    if(!state||!part||!root.current||!mesh.current)return
    const pose=part.node?state.poses[part.node]:undefined
    root.current.position.fromArray(pose?.pos??[0,0,0])
    root.current.quaternion.fromArray(pose?.quaternion??[0,0,0,1])
    root.current.scale.fromArray(pose?.scale??[1,1,1])
    const displayPart=seatedDependencyPart(groundedInstallationPart(part,state.dependency!.task_number,floorOffset),state.dependency!.task_number)
    mesh.current.position.fromArray(displayPart.pos)
    mesh.current.scale.fromArray(displayPart.size)
    material.current?.color.set(displayColor)
  })
  if(!initial)return null
  const sharedBench=dependency?.parts.some(p=>p.name==='Machine base')
  if(sharedBench&&/^(Support frame|Leveling foot)/.test(initial.name))return null
  if(initial.name==='Machine base'){
    const [w,h,d]=initial.size
    const display=seatedDependencyPart(groundedInstallationPart(initial,dependency!.task_number,floorOffset),dependency!.task_number)
    return <group ref={root} name="recorded-material-workbench"><mesh ref={mesh}>
      <bufferGeometry/><meshStandardMaterial ref={material}/>
      <group scale={[1/w,1/h,1/d]}>
        <Part name="bench-top" position={[0,h/2-.02,0]} size={[w,.04,d]} color={TABLE_FINISH.top}/>
        <group position={[0,-display.pos[1],0]}><MaterialTableLegs halfX={w/2-.08} halfZ={d/2-.08} top={display.pos[1]+h/2-.04}/></group>
      </group>
    </mesh></group>
  }
  return <group ref={root} name={`dependency-pose-${initial.name}`} userData={dependencyEquipment(initial,dependency!)}>
    <mesh ref={mesh} name={`dependency-part-${initial.name}`} castShadow receiveShadow>
      <PartGeometry part={initial} mechanical={mechanical} surface={surface}/>
      <meshStandardMaterial ref={material} color={displayColor} {...(role?{metalness:TABLE_FINISH.metalness,roughness:TABLE_FINISH.roughness}:{...satinFinish(.64,.65),...industrialSurface})}/>
      {initial.style==='motor'&&!initial.node?.startsWith('protected')&&<group scale={[1/initial.size[0],1/initial.size[1],1/initial.size[2]]}>
       <FittedMaterialDrive size={initial.size} axis={(initial.axis??(['x','y','z'][initial.size.indexOf(Math.max(...initial.size))])) as 'x'|'y'|'z'}/>
      </group>}
      {initial.style==='actuator'&&!initial.node?.startsWith('protected')&&<RecordedCylinderBody size={initial.size}/>}
      {initial.shape==='box'&&<SurfaceDetails part={initial}/>}
      {refined&&initial.style!=='motor'&&initial.style!=='rail'&&<AlignmentDetails part={initial}/>}
      {!initial.node?.startsWith('protected')&&initial.shape==='box'&&initial.style!=='motor'&&initial.style!=='actuator'&&<group scale={[1/initial.size[0],1/initial.size[1],1/initial.size[2]]}><MotionBoxFittings name={initial.name} size={initial.size}/></group>}
    </mesh>
  </group>
}

/** Connect the relocated M13 tilt gearbox to its original coaxial flange.
 * The 4mm radius clears the offset C motor's 5mm inner radial clearance. */
function TiltDriveCoupling({reader}:{reader:Reader}) {
 const mesh=useRef<Mesh>(null)
 useFrame(()=>{
  const pose=reader.motionHardState()?.poses.b
  if(mesh.current&&pose)mesh.current.position.set(pose.pos[0],pose.pos[1],-.57025)
 })
 return <mesh ref={mesh} name="tilt-drive-coupling" rotation={[Math.PI/2,0,0]} castShadow>
  <cylinderGeometry args={[.004,.004,.1155,24]}/>
  <meshStandardMaterial color={FINISH.steel} roughness={.65} metalness={.6}/>
 </mesh>
}

/** Replay geometry only. Physical evaluation remains in the versioned Python plant. */
export const MotionDependencyHardware=memo(function MotionDependencyHardware(props:DeviceProps) {
  const refined=useMotionPresentation()
  const reader=props.plant as unknown as Reader,geometry=reader.motionHardState()?.dependency
  const surfaces=useMemo(()=>{
    if(!geometry)return []
    const offset=displayGroundOffset(geometry.parts)
    const parts=geometry.parts.map(p=>seatedDependencyPart(groundedInstallationPart(p,geometry.task_number,offset),geometry.task_number))
    // Omitted display slabs must not clip visible installation feet.
    const visible=parts.map(p=>isDisplayPlinth(p)||redundantDependencyPart(p,geometry.task_number)||!isJoinedInstallation(p,geometry.task_number)?{...p,shape:'hidden'}:p)
    return visible.map((_,i)=>joinedBoxSurfaces(visible,i))
  },[geometry])
  if(!geometry)return null
  const removePlinth=geometry.parts.some(isDisplayPlinth)
  const plate=mediumMountingPlate(geometry.task_number,geometry.parts.map(p=>seatedDependencyPart(p,geometry.task_number)))
  const groundOffset=displayGroundOffset(geometry.parts)
  return <group name="motion-hard-hardware-dependency" position={[0,groundOffset+(plate?.thickness??0),0]} userData={{equipmentScope:true,version:geometry.version,task:geometry.task_number}}>
    {plate&&<mesh name="medium-common-mounting-plate" position={[plate.x,-groundOffset-plate.thickness/2,plate.z]} castShadow receiveShadow>
      <MachinedBoxGeometry args={[plate.width,plate.thickness,plate.depth]} detailed radius={.003}/>
      <meshStandardMaterial color={TABLE_FINISH.leg} roughness={TABLE_FINISH.roughness} metalness={TABLE_FINISH.metalness}/>
    </mesh>}
    {geometry.task_number===13&&<TiltDriveCoupling reader={reader}/>}
    {refined&&<group name="alignment-fixed-supports">
      {/* Existing longitudinal rails sit 60 mm above the table. Fill that mounting gap,
          stopping below the moving bearing blocks; no change to their recorded travel. */}
      {[0,1.8].map(z=><group key={z}>
        <mesh position={[.75,.78,z]} castShadow receiveShadow><boxGeometry args={[1.65,.06,.14]}/><meshStandardMaterial color={FINISH.alloy} roughness={.55} metalness={.6}/></mesh>
        <mesh position={[-.15,.78,z]} castShadow><boxGeometry args={[.19,.06,.19]}/><meshStandardMaterial color={FINISH.steel}/></mesh>
      </group>)}
      {[-.22,1.52].map(x=><Part key={x} name="bench-side-stretcher" position={[x,.25,1.35]} size={[.028,.035,2.885]} color={TABLE_FINISH.leg}/>)}
    </group>}
    {geometry.parts.map((part,index)=>(removePlinth&&isDisplayPlinth(part))||redundantDependencyPart(part,geometry.task_number)?null:<RecordedPart key={`${geometry.task_number}-${part.name}`} reader={reader} index={index} surface={surfaces[index]??null}/>)}
  </group>
})
