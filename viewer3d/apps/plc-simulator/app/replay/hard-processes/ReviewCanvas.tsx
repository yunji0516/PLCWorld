'use client'
import {EquipmentLabel} from '@/components/scene/EquipmentLabel'
import {useEquipmentBounds} from '@/components/scene/useEquipmentBounds';
import {equipmentFloor,equipmentFront,type FramingView} from '@/components/scene/equipmentFraming';
import {EquipmentCamera} from '@/components/scene/EquipmentCamera';
import {replacedStackTransfer} from '@/components/scene/assemblies/StackTransferMounts'
import {replacedActuatorHardware} from '@/components/scene/assemblies/ReviewActuatorRefinement'
import {replacedStationHardware} from '@/components/scene/assemblies/ReviewStationRedesign'
import {WorkshopReflections} from '@/components/scene/WorkshopReflections'
import {supportPresentation} from './supportPresentation'
import {presentationCorrections} from './presentationCorrections'
import {replacedInspectionFrame} from '@/components/scene/assemblies/InspectionStationFrame'
import {ReviewAttachedHardware} from '@/components/scene/assemblies/ReviewAttachedHardware'
import {reviewFurniture} from './reviewFurniture'
import {ReviewFurniture} from '@/components/scene/assemblies/ReviewFurniture'
import {RotaryPedestal} from '@/components/scene/assemblies/MaterialIndexDetail';
import {ReviewPhotoeyes,replacedPhotoeye} from '@/components/scene/assemblies/ReviewPhotoeyes';
import { primaryReviewNode, primaryDeviceList } from '@/lib/replay/primaryDevices';
import { isSuctionHead, SUCTION_FINISH } from '@/components/scene/assemblies/suctionHeadGeometry';
import { DeviceNameBadge } from '@/components/scene/DeviceNameBadge';
import { deviceDisplayName } from '@/lib/replay/deviceDisplayName';
import { Canvas, useFrame, useThree } from '@react-three/fiber';
import { OrbitControls, Html } from '@react-three/drei';
import { useEffect, useMemo, useRef, useState, type RefObject } from 'react';
import * as THREE from 'three';
import { beltDimensions, beltSurfacePose } from '@/components/scene/assemblies/transportGeometry';
import { CONVEYOR_BELT_TOP_Y } from '@/components/scene/deviceGeometry';
import { hardwareGeometry, hardwareFinish, hardwareOpacity, isWorkbenchDeck } from './reviewHardware';
import { isConveyorHolder } from './conveyorPresentation';
import { Stage } from '@/components/scene/Scene3D';
import { toMachine } from '@/lib/replay/adapter';
import type { LaidOutMachine } from '@/lib/machine/layout';
import { factoryCellBounds } from '@/components/scene/factoryFloor';
import type {FloorBounds} from './reviewBounds';
import {IndexStationNodeDetail,indexToolGeometry,IndexReworkSupports} from '@/components/scene/assemblies/MaterialIndexDetail';
import {IndexEquipmentPalette,industrialEquipmentColor,useIndustrialSurface} from '@/components/scene/assemblies/IndexEquipmentPalette';
export type V3 = [number, number, number];
export type Pose = {p:V3; r:number; rx?:number; rz?:number; s?:V3; points?:V3[]; visible?:boolean};
export type Node = Pose & {presentationFixed?:boolean;id:string; name:string; size:V3; color:string; shape:string; axis?:string; opacity?:number; material?:boolean; width_axis?:V3|null; conveyor?:{axis:string;radius:number;belt_width:number;length:number;source:string}; bearing_axis?:string; bore_radius?:number; motor_detail?:boolean; conveyor_hardware?:boolean; fixed_transfer?:boolean; anchor?:string; label_offset?:V3; fragments?:{p:V3;size:V3}[]};
export type Frame = {belt_motion?:Record<string,{distance:number;velocity:number}>;t:number;phase:string;poses:Record<string,Pose>;raw:Record<string,unknown>;received:string[];requests:{id:string;state:string;arrival:number}[]};
export type Run = {nodes:Node[];frames:Frame[];events:{t:number;label:string;kind:string}[];failure:string|null;duration:number;received:string[];label?:string};
export type Review = {id:string;title:string;primary:string;nodes:Node[];runs:Record<string,Run>;scope:string;benchmark_accepted:false;novelty?:string;source_ids?:string[];redesign_review?:string;validation_note?:string;execution?:string;coordinate_scale?:number;geometry_revision?:string};
const indexReplacedHardware=new Set(['repair_drive','repair_tool_post','repair_tool_rail','repair_grip_rod','repair_grip_slide'])
// One continuous strip with shared mitered sections: adjacent boxes formerly
// overlapped at every bend, producing seam flicker on film and web paths.
function Ribbon({node,frame}:{node:Node;frame:RefObject<Frame>}) {
  const ref=useRef<THREE.Mesh>(null)
  const lastPoints=useRef<V3[]|null>(null)
  const count=Math.max(2,node.points?.length ?? 2)
  const geometry=useMemo(()=>{
    const g=new THREE.BufferGeometry()
    g.setAttribute('position',new THREE.BufferAttribute(new Float32Array(count*108),3))
    return g
  },[count])
  useEffect(()=>()=>geometry.dispose(),[geometry])
  useFrame(()=>{
    const pose=node.presentationFixed?node:frame.current.poses[node.id],raw=pose?.points || node.points || []
    if(!ref.current)return
    if(lastPoints.current===raw){ref.current.visible=(pose?.visible ?? node.visible ?? true) && geometry.drawRange.count>0;return}
    lastPoints.current=raw
    const points=raw.filter((p,i)=>i===0 || Math.hypot(...p.map((v,k)=>v-raw[i-1][k]))>1e-8).map(p=>new THREE.Vector3(...p))
    if(!ref.current)return
    ref.current.visible=(pose?.visible ?? node.visible ?? true) && points.length>1
    if(points.length<2){geometry.setDrawRange(0,0);return}
    const bounds=new THREE.Box3().setFromPoints(points),span=bounds.getSize(new THREE.Vector3()).toArray()
    const axis=node.width_axis ? new THREE.Vector3(...node.width_axis) : new THREE.Vector3(...([0,1,2].map(k=>k===span.indexOf(Math.min(...span))?1:0) as V3))
    const tangents=points.slice(1).map((p,i)=>p.clone().sub(points[i]).normalize())
    const closed=points[0].distanceToSquared(points[points.length-1])<1e-14
    const sections=points.map((point,i)=>{
      const seam=closed && (i===0 || i===points.length-1)
      const before=tangents[seam?tangents.length-1:Math.max(0,i-1)],after=tangents[seam?0:Math.min(i,tangents.length-1)]
      const tangent=before.clone().add(after).normalize()
      const width=axis.clone().addScaledVector(tangent,-axis.dot(tangent)).normalize()
      if(width.lengthSq()<.5)width.set(1,0,0).addScaledVector(tangent,-tangent.x).normalize()
      const normal=tangent.clone().cross(width).normalize()
      const faceNormal=after.clone().cross(width).normalize()
      const miter=Math.min(3,1/Math.max(.333,Math.abs(normal.dot(faceNormal))))
      return [[-1,-1],[1,-1],[1,1],[-1,1]].map(([a,b])=>point.clone().addScaledVector(normal,a*node.size[0]*.5*miter).addScaledVector(width,b*node.size[1]*.5))
    })
    // Film paths grow from one point to a complete loop. Grow the vertex
    // buffer too; a buffer sized at the first frame truncates later faces.
    const required=(sections.length-1)*24+12
    if(geometry.getAttribute('position').count<required){
      geometry.setAttribute('position',new THREE.BufferAttribute(new Float32Array(required*3),3))
      geometry.deleteAttribute('normal')
    }
    const positions=geometry.getAttribute('position') as THREE.BufferAttribute
    let offset=0
    const triangle=(a:THREE.Vector3,b:THREE.Vector3,c:THREE.Vector3)=>{for(const p of [a,b,c])positions.setXYZ(offset++,p.x,p.y,p.z)}
    for(let i=0;i<sections.length-1;i++)for(let j=0;j<4;j++){
      const next=(j+1)%4,a=sections[i][j],b=sections[i][next],c=sections[i+1][next],d=sections[i+1][j]
      triangle(a,b,c);triangle(a,c,d)
    }
    for(const [section,flip] of (closed?[]:[[sections[0],false],[sections[sections.length-1],true]]) as [THREE.Vector3[],boolean][]){
      const [a,b,c,d]=section;triangle(a,flip?c:b,flip?b:c);triangle(a,flip?d:c,flip?c:d)
    }
    geometry.setDrawRange(0,offset);positions.needsUpdate=true;geometry.computeVertexNormals();geometry.computeBoundingSphere()
  })
  return <mesh ref={ref} geometry={geometry}><meshStandardMaterial color={node.color} roughness={.7} side={THREE.DoubleSide}/></mesh>
}
function Panel({node}:{node:Node}) {
  const geometry=useMemo(()=>{
    const g=new THREE.BufferGeometry(),points=node.points || []
    g.setAttribute('position',new THREE.Float32BufferAttribute(points.flat(),3))
    g.setIndex(Array.from({length:Math.max(0,points.length-2)},(_,i)=>[0,i+1,i+2]).flat());g.computeVertexNormals();return g
  },[node])
  useEffect(()=>()=>geometry.dispose(),[geometry])
  return <mesh geometry={geometry} castShadow={!/^scrap_chute_/.test(node.id)} receiveShadow><meshStandardMaterial color={node.color} roughness={.6} side={THREE.DoubleSide}/></mesh>
}
function Beam({node,frame}:{node:Node;frame:RefObject<Frame>}) {
  const ref=useRef<THREE.Mesh>(null)
  useFrame(()=>{
    const pose=node.presentationFixed?undefined:frame.current.poses[node.id],points=pose?.points || node.points || []
    if(!ref.current || points.length<2)return
    const a=new THREE.Vector3(...points[0]),b=new THREE.Vector3(...points[1]),delta=b.clone().sub(a)
    const length=delta.length(),radius=(pose?.s || node.size)[0]
    ref.current.visible=(pose?.visible ?? node.visible ?? true) && length>1e-7
    ref.current.position.copy(a).add(b).multiplyScalar(.5)
    if(length>1e-7)ref.current.quaternion.setFromUnitVectors(new THREE.Vector3(0,1,0),delta.multiplyScalar(1/length))
    ref.current.scale.set(radius,length,radius)
  })
  return <mesh ref={ref} castShadow receiveShadow><cylinderGeometry args={[1,1,1,16]}/><meshStandardMaterial {...hardwareFinish(node)}/></mesh>
}
function boxFragments(node:Node) {
  if(!node.fragments)return null
  const positions:number[]=[],normals:number[]=[]
  for(const part of node.fragments){
    // Cut extrusions retain their machined profile. A panel's CSG fragments
    // are a decomposition of one face, not separate bevelled metal strips.
    const actual=part.size.map((v,i)=>v*node.size[i]) as V3
    const profile=/(?:frame|post|leg|upright|gantry|bridge|profile)/.test(node.id)
    const machined=node.fragments.length===1 || profile ? hardwareGeometry({...node,size:actual,fragments:undefined}) : null
    const source=machined || new THREE.BoxGeometry(1,1,1)
    const box=source.index?source.toNonIndexed():source
    box.scale(...part.size);box.translate(...part.p)
    if(box!==source)source.dispose()
    positions.push(...box.getAttribute('position').array);normals.push(...box.getAttribute('normal').array);box.dispose()
  }
  const g=new THREE.BufferGeometry();g.setAttribute('position',new THREE.Float32BufferAttribute(positions,3));g.setAttribute('normal',new THREE.Float32BufferAttribute(normals,3));return g
}
function ReviewSelectedBadge({node,root}:{node:Node;root:RefObject<THREE.Group|null>}) {
 const [object,setObject]=useState<THREE.Group|null>(null)
 useFrame(()=>{if(root.current&&root.current!==object)setObject(root.current)})
 const anchor=useMemo(()=>object?{id:node.id,name:node.name,object}:undefined,[object,node.id,node.name])
 return <DeviceNameBadge id={node.id} name={node.name} anchor={anchor}/>
}
function Device({node,frame,selectedDevice,onSelectDevice,indexDetails=false,selectable=true}:{node:Node;selectable?:boolean;frame:RefObject<Frame>;selectedDevice?:string|null;onSelectDevice?:(id:string|null)=>void;indexDetails?:boolean}) {
  const ref=useRef<THREE.Group>(null);const selectionRoot=useRef<THREE.Group>(null);const mesh=useRef<THREE.Mesh>(null);const [localSelected,setSelected]=useState(false);
  const selected=selectable && (onSelectDevice ? selectedDevice===node.id : localSelected);
  const finish=hardwareFinish(node)
  const equipmentColor=finish.color
  const industrialSurface=useIndustrialSurface(equipmentColor)
  const color=indexDetails&&['insert_supply_surface','body_supply_surface'].includes(node.id)?'#454b50'
    :!node.material?industrialEquipmentColor(equipmentColor):finish.color
  const fragments=useMemo(()=>boxFragments(node),[node]);
  const machined=useMemo(()=>isSuctionHead(node)?hardwareGeometry(node):(indexDetails?indexToolGeometry(node):null)??hardwareGeometry(node),[node,indexDetails]);
  useEffect(()=>()=>machined?.dispose(),[machined]);
  useEffect(()=>()=>fragments?.dispose(),[fragments]);
  // Keep the physical bore radius while a wound roll's outer radius changes.
  const tube=useMemo(()=>{
    if(node.shape!=='tube')return null;
    const geometry=new THREE.LatheGeometry([new THREE.Vector2(.5,-.5),new THREE.Vector2(1,-.5),new THREE.Vector2(1,.5),new THREE.Vector2(.5,.5),new THREE.Vector2(.5,-.5)],32);
    const positions=geometry.getAttribute('position');const inner:{i:number;x:number;z:number}[]=[];
    for(let i=0;i<positions.count;i++){const x=positions.getX(i),z=positions.getZ(i);if(Math.hypot(x,z)<.75)inner.push({i,x:x*2,z:z*2});}
    return {geometry,inner,ratio:-1};
  },[node.shape]);
  useEffect(()=>()=>tube?.geometry.dispose(),[tube]);
  useFrame(()=>{
    const p=node.presentationFixed?node:frame.current.poses[node.id] || node;
    if(ref.current){ref.current.position.fromArray(p.p);ref.current.rotation.set(p.rx ?? 0,p.r,p.rz ?? 0);}
    if(tube){const size=p.s || node.size;const ratio=size[2]/Math.max(size[0],1e-9);if(Math.abs(tube.ratio-ratio)>1e-9){const positions=tube.geometry.getAttribute('position');for(const v of tube.inner){positions.setX(v.i,v.x*ratio);positions.setZ(v.i,v.z*ratio);}positions.needsUpdate=true;tube.geometry.computeBoundingSphere();tube.ratio=ratio;}}
    if(mesh.current){const size=p.s || node.size;mesh.current.scale.fromArray(node.shape==='tube'?[size[0],size[1],size[0]]:size);mesh.current.visible=p.visible ?? node.visible ?? true;}
  });
  if(['ribbon','beam','panel'].includes(node.shape)) {
    const displayed={...node,color}
    return <group ref={selectionRoot} onClick={e=>{if((e.nativeEvent.target as HTMLElement)?.closest?.('[data-device-label], [data-device-name]'))return;e.stopPropagation();if(!selectable){onSelectDevice?.(null);return;}if(onSelectDevice)onSelectDevice(selected?null:node.id);else setSelected(!selected)}}>
      {node.shape==='ribbon'?<Ribbon node={displayed} frame={frame}/>:node.shape==='beam'?<Beam node={displayed} frame={frame}/>:<Panel node={displayed}/>}
      {selected && <ReviewSelectedBadge node={node} root={selectionRoot}/>}
    </group>
  }
  return <group ref={ref} position={node.p} rotation={[node.rx ?? 0,node.r,node.rz ?? 0]} onClick={e=>{if((e.nativeEvent.target as HTMLElement)?.closest?.('[data-device-label], [data-device-name]'))return;e.stopPropagation();if(!selectable){onSelectDevice?.(null);return;}if(onSelectDevice)onSelectDevice(selected?null:node.id);else setSelected(!selected);}}>
    {indexDetails&&!isSuctionHead(node)&&<IndexStationNodeDetail node={node} frame={frame}/>}
    <mesh ref={mesh} name={isSuctionHead(node)?'suction-head-'+node.id:'review-source-'+node.id} userData={{nodeId:node.id,material:!!node.material}} scale={node.size} rotation={node.shape==='cylinder'?(node.axis==='x'?[0,0,Math.PI/2]:node.axis==='z'?[Math.PI/2,0,0]:[0,0,0]):[0,0,0]} castShadow receiveShadow>
      {fragments?<primitive object={fragments} attach="geometry"/>:node.shape==='cylinder' && machined?<primitive object={machined} attach="geometry"/>:node.shape==='cylinder'?<cylinderGeometry args={[1,1,1,40,1,(node.opacity ?? 1)<1]}/>:tube?<primitive object={tube.geometry} attach="geometry"/>:machined?<primitive object={machined} attach="geometry"/>:<boxGeometry/>}
      {isSuctionHead(node) ? SUCTION_FINISH.map((finish,i)=><meshStandardMaterial key={i} attach={`material-${i}`} {...finish} color={finish.color}/>) : <meshStandardMaterial {...finish} {...(!node.material?industrialSurface:{})} {...(node.id==='table_ring'||isWorkbenchDeck(node)?{roughness:.88,metalness:.18,envMapIntensity:.25}:{})} color={color} transparent={hardwareOpacity(node)<1} opacity={hardwareOpacity(node)} depthWrite={hardwareOpacity(node)>=1}/>}
    </mesh>
    {selected && <ReviewSelectedBadge node={node} root={ref}/>}
  </group>;
}
function View({cameraView,nodes,resetKey=0,matchStandardView=false,floorBounds}:{cameraView:string;nodes:Node[];resetKey?:number;matchStandardView?:boolean;floorBounds?:FloorBounds}) {
  const {camera,size}=useThree()
  const framing=useMemo(()=>{
    const box=new THREE.Box3(),points:THREE.Vector3[]=[]
    const expand=(point:THREE.Vector3)=>{points.push(point);box.expandByPoint(point)}
    for(const node of nodes){
      if(node.shape==='ribbon' || node.shape==='beam' || node.shape==='panel'){
        for(const p of node.points || [])expand(new THREE.Vector3(...p))
        continue
      }
      let extent=node.size.slice() as V3
      if(node.shape==='cylinder' || node.shape==='tube'){
        extent=[2*node.size[0],node.size[1],2*node.size[0]]
        if(node.axis==='x')extent=[extent[1],extent[0],extent[2]]
        if(node.axis==='z')extent=[extent[0],extent[2],extent[1]]
      }
      for(const x of [-1,1])for(const y of [-1,1])for(const z of [-1,1]){
        const p=new THREE.Vector3(x*extent[0]/2,y*extent[1]/2,z*extent[2]/2)
        p.applyEuler(new THREE.Euler(node.rx ?? 0,node.r,node.rz ?? 0)).add(new THREE.Vector3(...node.p));expand(p)
      }
    }
    if(floorBounds)for(const x of [-1,1])for(const z of [-1,1])expand(new THREE.Vector3(floorBounds.x+x*(floorBounds.width/2+.05),.008,floorBounds.z+z*(floorBounds.depth/2+.05)))
    return {bounds:box,points}
  },[nodes,floorBounds])
  const bounds=framing.bounds
  const target=useMemo(()=>bounds.getCenter(new THREE.Vector3()).toArray() as V3,[bounds])
  useEffect(()=>{
    const offset:V3=matchStandardView
      ? cameraView==='top'?[.01,1,.01]:cameraView==='front'?[0,.24,1]:cameraView==='side'?[1,.24,0]:[.46,.5,.78]
      : cameraView==='top'?[0,1,.0001]:cameraView==='front'?[0,0,1]:cameraView==='side'?[1,0,0]:[1,.78,1]
    const direction=new THREE.Vector3(...offset).normalize()
    const right=new THREE.Vector3(0,1,0).cross(direction).normalize(),vertical=direction.clone().cross(right)
    const extent=bounds.getSize(new THREE.Vector3())
    const projection=(axis:THREE.Vector3)=>Math.abs(axis.x)*extent.x+Math.abs(axis.y)*extent.y+Math.abs(axis.z)*extent.z
    const tangent=Math.tan(THREE.MathUtils.degToRad((camera as THREE.PerspectiveCamera).fov/2))
    let distance=projection(direction)/2+1.12*Math.max(projection(vertical)/(2*tangent),projection(right)/(2*tangent*size.width/Math.max(1,size.height)))
    if(matchStandardView){
      // Fit equipment and painted operating boundary with H01's view angles.
      const anchor=new THREE.Vector3(...target),horizontal=tangent*size.width/Math.max(1,size.height)
      distance=1.5
      for(const point of framing.points){
        const relative=point.clone().sub(anchor),depth=relative.dot(direction)
        distance=Math.max(distance,depth+Math.abs(relative.dot(right))/(horizontal*.91),depth+Math.abs(relative.dot(vertical))/(tangent*.91))
      }
    }
    camera.position.copy(new THREE.Vector3(...target)).addScaledVector(direction,distance);camera.lookAt(...target);camera.updateProjectionMatrix()
  },[camera,cameraView,bounds,target,size.width,size.height,resetKey,matchStandardView,framing])
  return <OrbitControls makeDefault target={target} minDistance={matchStandardView?1.5:1.3} maxDistance={matchStandardView?Math.max(40,bounds.getSize(new THREE.Vector3()).length()*4):15}/>
}
function DrivenBeltMarkers({node,frame}:{node:Node;frame:RefObject<Frame>}) {
 const ref=useRef<THREE.InstancedMesh>(null),dummy=useMemo(()=>new THREE.Object3D(),[])
 const c=node.conveyor!,g=beltDimensions(c.length,c.radius),count=Math.ceil(g.perimeter/.32)
 useFrame(()=>{
  if(!ref.current)return
  const drive=frame.current.belt_motion?.[c.source],pose=frame.current.poses[node.id]
  ref.current.visible=!!drive && (pose?.visible ?? node.visible ?? true)
  if(!drive)return
  const origin=pose?.p ?? node.p,top=origin[1]+c.radius
  for(let i=0;i<count;i++){
   const p=beltSurfacePose(c.length,drive.distance+i*g.perimeter/count,.00002,c.radius)
   dummy.position.set(origin[0]+(c.axis==='x'?p.x:0),top+p.y-CONVEYOR_BELT_TOP_Y,origin[2]+(c.axis==='z'?p.x:0))
   dummy.rotation.set(c.axis==='z'?-p.angle:0,0,c.axis==='x'?p.angle:0);dummy.updateMatrix();ref.current.setMatrixAt(i,dummy.matrix)
  }
  ref.current.instanceMatrix.needsUpdate=true
 })
 return <instancedMesh ref={ref} name="shared-belt-drive-markers" args={[undefined,undefined,count]}><boxGeometry args={c.axis==='x'?[.016,.00002,c.belt_width*.22]:[c.belt_width*.22,.00002,.016]}/><meshStandardMaterial color="#45535e" roughness={.94}/></instancedMesh>
}
// Labels follow the same raw pose as their hardware; a moving gripper must
// not leave its device name behind at the initial frame position.
function DeviceLabel({node,frame}:{node:Node;frame:RefObject<Frame>}) {
  const ref=useRef<THREE.Group>(null)
  useFrame(()=>{
    if(!ref.current)return
    const pose=node.anchor ? frame.current.poses[node.anchor] : undefined
    const offset=node.label_offset ?? [0,0,0]
    ref.current.position.set(...(pose ? pose.p.map((v,i)=>v+offset[i]) as V3 : node.p))
    ref.current.visible=pose?.visible ?? node.visible ?? true
  })
  return <group ref={ref} position={node.p}><Html center style={{pointerEvents:'none'}}><span data-device-label={node.anchor ?? node.id} style={{display:'block',whiteSpace:'nowrap',background:'rgba(247,250,251,.93)',border:'1px solid #b9cbd1',color:'#264b5a',padding:'4px 7px',fontSize:10,borderRadius:3}}>{node.name}</span></Html></group>
}
export default function ReviewCanvas(props: Parameters<typeof ReviewContents>[0]) {
 return <Canvas data-conveyor-renderer="axis-contract-v17" shadows={{type:THREE.PCFShadowMap}} camera={{position:[3.7,3,4],fov:42,near:.05,far:200}} dpr={[1,1.5]} gl={{antialias:true,toneMapping:THREE.ACESFilmicToneMapping,preserveDrawingBuffer:true}} onPointerMissed={event=>{if((event.target as HTMLElement)?.closest?.('[data-device-label], [data-device-name]'))return;props.onSelectDevice?.(null)}}><ReviewContents {...props}/></Canvas>
}
function ReviewContents({nodes,frame,cameraView,showLabels=false,machine,selectedDevice,onSelectDevice,cameraResetKey=0,floorBounds:providedFloorBounds,indexDetails=false,registeredOnly=false}:{nodes:Node[];frame:RefObject<Frame>;cameraView:string;showLabels?:boolean;machine?:LaidOutMachine;selectedDevice?:string|null;onSelectDevice?:(id:string|null)=>void;cameraResetKey?:number;floorBounds?:FloorBounds;indexDetails?:boolean;registeredOnly?:boolean}) {
  const stageMachine=useMemo(()=>machine || toMachine({title:'Mini process',aim:'',req:'',suite:'material',io:{},observed:[],runs:{},devices:nodes.filter(n=>n.shape==='box').map(n=>({id:n.id,label:n.name,kind:'static',ui:'fixture',pos:n.p,size:n.size,visual_variant:'cell3-priority-anchor'}))},'Mini process'),[machine,nodes])
  const floorBounds=useMemo(()=>providedFloorBounds ?? factoryCellBounds(nodes.filter(n=>n.shape==='box').map(n=>({pos:n.p,size:n.size,rot:n.r}))),[nodes,providedFloorBounds])
  // Hide the complete repeated conveyor holder assemblies in every Hard task.
  // Their recorded states remain intact; frame visibility cannot reveal omitted nodes.
  const corrected=useMemo(()=>supportPresentation(presentationCorrections(nodes)),[nodes])
  const furniture=useMemo(()=>reviewFurniture(corrected),[corrected])
  const displayedNodes=useMemo(()=>[...corrected.filter(n=>!furniture.hidden.has(n.id)),...furniture.upper].filter(n=>!/^controls?(?:_|$)/.test(n.id)&&!((indexDetails)&&(/^(index_drive_panel|index_frame\d+$|table_pedestal)/.test(n.id)))&&(!isConveyorHolder(n)||(corrected.some(o=>o.id==='leader_grip')&&(n.anchor??n.id)==='core_stop'))&&(!indexDetails||!indexReplacedHardware.has(n.id))).map(n=>({...n,name:deviceDisplayName(corrected.some(o=>o.id==='leader_grip')&&n.name!==n.id?n.name:stageMachine.devices.find(d=>d.id===n.id)?.label ?? n.name)})),[corrected,stageMachine,indexDetails,furniture])
  const equipmentRoot=useRef<THREE.Group>(null)
  const measured=useEquipmentBounds(equipmentRoot,nodes)
  const fittedFloor=useMemo(()=>measured?equipmentFloor(measured,floorBounds):floorBounds,[measured,floorBounds])
  const primaryIds=new Set((registeredOnly?primaryDeviceList(stageMachine.devices):stageMachine.devices).map(d=>d.id))
  return <>
    <color attach="background" args={['#e4e9e8']}/><fog attach="fog" args={['#e4e9e8',18,42]}/>
    <Stage machine={stageMachine} bounds={fittedFloor} lightTheme/>
    <WorkshopReflections/>
    <group ref={equipmentRoot} name="replay-equipment"><IndexEquipmentPalette.Provider value="industrial">
    <ReviewFurniture furniture={furniture.furniture} posts={furniture.posts}/>
    {indexDetails&&<RotaryPedestal top={.77}/>}
    {<ReviewPhotoeyes nodes={corrected}/>}
    {displayedNodes.filter(n=>!replacedPhotoeye(corrected,n.id)&&!replacedInspectionFrame(corrected,n.id)&&!replacedStationHardware(corrected,n.id)&&!replacedActuatorHardware(corrected,n.id)&&!replacedStackTransfer(corrected,n.id)&&n.shape!=='label'&&!/^(flex_hose_|tank_pipe_|refill_pipe$)/.test(n.id)).map(n=><Device key={n.id} selectable={(registeredOnly?primaryIds.has(n.id):primaryReviewNode(n,primaryIds))} node={n} frame={frame} selectedDevice={selectedDevice} onSelectDevice={onSelectDevice} indexDetails={indexDetails}/>)}
    <ReviewAttachedHardware nodes={corrected} frame={frame}/>
    {indexDetails&&<IndexReworkSupports frame={frame}/>}
    </IndexEquipmentPalette.Provider>
    {corrected.filter(n=>n.conveyor).map(n=><DrivenBeltMarkers key={'drive-'+n.id} node={n} frame={frame}/>)}
    {showLabels&&displayedNodes.filter(n=>(registeredOnly?primaryIds.has(n.id):primaryReviewNode(n,primaryIds))&&n.id!==selectedDevice).map(n=><EquipmentLabel key={'label-'+n.id} id={n.id} name={n.name} position={n.p} resolve={()=>equipmentRoot.current?.getObjectByName('review-source-'+n.id)??equipmentRoot.current?.getObjectByName('suction-head-'+n.id)} onSelect={()=>onSelectDevice?.(n.id)}/>)}
    </group>
    {measured?<EquipmentCamera bounds={measured} floor={fittedFloor} view={cameraView as FramingView} front={equipmentFront(stageMachine)} resetKey={cameraResetKey}/>:<View cameraView={cameraView} nodes={displayedNodes} resetKey={cameraResetKey} matchStandardView={!!machine} floorBounds={fittedFloor}/>}
  </>;
}
