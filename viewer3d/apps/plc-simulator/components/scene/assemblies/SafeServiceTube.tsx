'use client'
import { useFrame,useThree } from '@react-three/fiber'
import { useContext,useEffect,useMemo,useRef } from 'react'
import { EssentialMaterialServices } from '../MaterialServiceScope'
import * as THREE from 'three'
import type { Plant } from '@/lib/machine/plant'
import { contains,distance,firstHit,inflate,route,sub,terminal,type V3,type Solid } from '@/lib/geometry/serviceRouting'
let serial=0
const worlds=new WeakMap<THREE.Scene,{frame:number,solids:Solid[],signature:string}>()
function obstacles(scene:THREE.Scene,frame:number){
 const old=worlds.get(scene);if(old?.frame===frame)return old.solids
 const solids:Solid[]=[];scene.updateMatrixWorld(true)
 scene.traverse(o=>{
  const m=o as THREE.Mesh;if(!m.isMesh||!m.geometry)return
  let p:THREE.Object3D|null=m,device=false,skip=false
  while(p){if(p.name.startsWith('device-')||p.userData.serviceCabinet)device=true;if(p.name==='v8-fluid-volume'||p.userData.serviceTube||p.name.includes('service-hose')||p.name.includes('service-loop')||p.name.includes('flex-hose')||p.name==='v7-nozzle-hose')skip=true;p=p.parent}
  if(!device||skip||m.geometry.type==='TubeGeometry'||m.geometry.type==='PlaneGeometry')return
  if(m.name==='buffer-continuous-ribbon'){
   const pos=m.geometry.getAttribute('position'),index=m.geometry.index,n=index?.count??pos.count
   for(let i=0;i<n;i+=3){const box=new THREE.Box3();for(let j=0;j<3;j++)box.expandByPoint(new THREE.Vector3().fromBufferAttribute(pos,index?index.getX(i+j):i+j).applyMatrix4(m.matrixWorld));solids.push({id:'part-surface-'+m.uuid+'-'+i,min:box.min.toArray() as V3,max:box.max.toArray() as V3})}
   return
  }
  if(!m.geometry.boundingBox)m.geometry.computeBoundingBox();if(!m.geometry.boundingBox)return
  const box=m.geometry.boundingBox.clone().applyMatrix4(m.matrixWorld)
  solids.push({id:m.uuid,min:box.min.toArray() as V3,max:box.max.toArray() as V3})
 })
 const plant=scene.userData.materialServicePlant as Plant|undefined
 for(const part of plant?.parts??[]){if(part.visible===false)continue;const d=part.materialDimensions??[.16,.16,.16],box=new THREE.Box3(new THREE.Vector3(...d).multiplyScalar(-.5),new THREE.Vector3(...d).multiplyScalar(.5));const matrix=new THREE.Matrix4().compose(new THREE.Vector3(part.x,part.y??0,part.z??0),new THREE.Quaternion().setFromEuler(new THREE.Euler(...(part.rotation??[0,0,0]))),new THREE.Vector3(1,1,1));box.applyMatrix4(matrix);solids.push({id:'part-'+part.id,min:box.min.toArray() as V3,max:box.max.toArray() as V3})}
 worlds.set(scene,{frame,solids,signature:solids.map(b=>b.id+':'+[...b.min,...b.max].map(v=>v.toFixed(5)).join(',')).join(';')});return solids
}
function rounded(points:V3[],bendRadius=.012){
 const curve=new THREE.CurvePath<THREE.Vector3>();let previous=new THREE.Vector3(...points[0])
 for(let i=1;i<points.length-1;i++){
  const a=new THREE.Vector3(...points[i-1]),b=new THREE.Vector3(...points[i]),c=new THREE.Vector3(...points[i+1]),r=Math.min(bendRadius,a.distanceTo(b)*.2,b.distanceTo(c)*.2)
  const entry=b.clone().add(a.clone().sub(b).normalize().multiplyScalar(r)),exit=b.clone().add(c.clone().sub(b).normalize().multiplyScalar(r))
  curve.add(new THREE.LineCurve3(previous,entry));curve.add(new THREE.QuadraticBezierCurve3(entry,b,exit));previous=exit
 }
 curve.add(new THREE.LineCurve3(previous,new THREE.Vector3(...points.at(-1)!)));return curve
}
/** Cable/air/fluid service drawn around actual solids. Connectors, not whole devices, may touch. */
type ServiceTubeProps={points:V3[]|(()=>V3[]);radius?:number;color?:string;name?:string;purpose?:'detail'|'functional';bendRadius?:number;followHints?:boolean}
export function SafeServiceTube(props:ServiceTubeProps){
 const essentialOnly=useContext(EssentialMaterialServices)
 if(essentialOnly&&props.purpose!=='functional')return null
 return <RoutedServiceTube {...props}/>
}
function RoutedServiceTube({points,radius=.005,color='#293e4c',name='service-tube',bendRadius=.012,followHints=false}:ServiceTubeProps){
 const {scene,gl}=useThree(),group=useRef<THREE.Group>(null),mesh=useRef<THREE.Mesh>(null),ports=useRef<THREE.Group>(null)
 const order=useMemo(()=>++serial,[]),last=useRef(''),checked=useRef(''),history=useRef<V3[]>([])
 const data=useMemo(()=>({serviceTube:true,order,radius}),[order,radius])
 const geometry=useMemo(()=>new THREE.BufferGeometry(),[])
 useEffect(()=>()=>geometry.dispose(),[geometry])
 useFrame(()=>{
  if(!group.current||!mesh.current)return
  group.current.updateWorldMatrix(true,false)
  const local=typeof points==='function'?points():points;if(local.length<2)return
  const nominal=local.map(p=>new THREE.Vector3(...p).applyMatrix4(group.current!.matrixWorld).toArray() as V3)
  const solid=obstacles(scene,gl.info.render.frame),margin=radius+.026
  let checkKey=nominal.flat().map(v=>v.toFixed(5)).join(',')+'|'+worlds.get(scene)!.signature
  scene.traverse(o=>{if(o.userData.serviceTube&&o.userData.order<order)checkKey+='|'+o.uuid+':'+(o.userData.revision??0)})
  if(checked.current===checkKey&&(group.current.userData.centers||group.current.userData.routingFailure))return
  checked.current=checkKey
  const cableBoxes:Solid[]=[]
  // Uniform samples avoid large diagonal AABBs that falsely seal adjacent ports.
  scene.traverse(o=>{const u=o.userData;if(!u.serviceTube||u.order>=order||!u.centers)return;const c=u.centers as V3[]
   for(let i=1;i<c.length;i++){
    if([c[i-1],c[i]].some(p=>distance(p,nominal[0])<.025||distance(p,nominal.at(-1)!)<.025))continue
    cableBoxes.push({id:'wire-'+o.uuid+'-'+i,min:c[i].map((v,k)=>Math.min(v,c[i-1][k])-radius-u.radius-.006) as V3,max:c[i].map((v,k)=>Math.max(v,c[i-1][k])+radius+u.radius+.006) as V3})
   }
  })
  const start=terminal(nominal[0],sub(nominal[1],nominal[0]),solid,margin,cableBoxes),end=terminal(nominal.at(-1)!,sub(nominal.at(-2)!,nominal.at(-1)!),solid,margin,cableBoxes)
  for(const t of [start,end])if(t.host&&distance(t.port,t.escape)>1e-6){
   const host=scene.getObjectByProperty('uuid',t.host) as THREE.Mesh|undefined
   if(host){const origin=new THREE.Vector3(...t.escape),ray=new THREE.Raycaster(origin,new THREE.Vector3(...t.port).sub(origin).normalize(),0,.35),contact=ray.intersectObject(host,false)[0];if(contact&&contact.point.distanceTo(new THREE.Vector3(...t.port))<.02)t.port=contact.point.toArray() as V3}
  }
  const boxes=[...solid.map(b=>inflate(b,margin)),...cableBoxes]
  const key=[...(followHints?nominal.flat():[]),...start.port,...end.port,...group.current.matrixWorld.elements].map(n=>n.toFixed(5)).join(',')
  if(group.current.userData.centers&&key===last.current&&history.current.length&&history.current.slice(1).every((p,i)=>!firstHit(history.current[i],p,boxes)))return
  let planned:V3[]|null=null
  // Keep the previous topology when a moving terminal can stretch its final legs safely.
  if(!followHints&&history.current.length){const p=history.current.map(v=>[...v] as V3);p[0]=start.escape;p[p.length-1]=end.escape;if(p.slice(1).every((q,i)=>!firstHit(p[i],q,boxes)))planned=p}
  if(!planned){
   const hints=nominal.slice(1,-1).filter(p=>!boxes.some(b=>contains(b,p))),targets=[start.escape,...hints,end.escape],joined:V3[]=[]
   let ok=true;for(let i=1;i<targets.length;i++){const leg=route(targets[i-1],targets[i],boxes);if(!leg){ok=false;break}joined.push(...(i===1?leg:leg.slice(1)))}
   if(ok)planned=joined
  }
  if(!planned)planned=route(start.escape,end.escape,boxes)
  if(!planned){mesh.current.visible=false;if(ports.current)ports.current.visible=false;group.current.userData.routingFailure={name,start,end,blockedStart:boxes.filter(b=>contains(b,start.escape)),blockedEnd:boxes.filter(b=>contains(b,end.escape))};return}
  mesh.current.visible=true;if(ports.current)ports.current.visible=true
  delete group.current.userData.routingFailure;history.current=planned;last.current=key
  const full=[start.port,...planned,end.port].filter((p,i,a)=>!i||distance(p,a[i-1])>1e-6),curve=rounded(full,bendRadius)
  const count=Math.max(16,Math.ceil(curve.getLength()/.015)),centers=curve.getSpacedPoints(count).map(v=>v.toArray() as V3)
  const inv=group.current.matrixWorld.clone().invert(),localCurve=rounded(full.map(p=>new THREE.Vector3(...p).applyMatrix4(inv).toArray() as V3),bendRadius)
  const next=new THREE.TubeGeometry(localCurve,count,radius,8,false);geometry.copy(next);next.dispose()
  Object.assign(group.current.userData,{serviceTube:true,order,radius,revision:(group.current.userData.revision??0)+1,centers,ports:[start,end],route:planned})
  if(ports.current){for(let i=0;i<2;i++){const port=[start,end][i],o=ports.current.children[i];o.position.copy(new THREE.Vector3(...port.port).applyMatrix4(inv));const dir=new THREE.Vector3(...port.escape).sub(new THREE.Vector3(...port.port)).transformDirection(inv);if(dir.lengthSq())o.quaternion.setFromUnitVectors(new THREE.Vector3(0,1,0),dir)}}
 })
 return <group ref={group} name={name} userData={data}><mesh ref={mesh} geometry={geometry}><meshStandardMaterial color={color} roughness={.7}/></mesh><group ref={ports}>{[0,1].map(i=><mesh key={i}><cylinderGeometry args={[radius*1.5,radius*1.5,.009,12]}/><meshStandardMaterial color="#6f8792" metalness={.6} roughness={.5}/></mesh>)}</group></group>
}
