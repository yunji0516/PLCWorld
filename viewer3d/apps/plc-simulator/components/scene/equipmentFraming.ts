import {Box3,Matrix4,Vector3,type Object3D,type PerspectiveCamera} from 'three'
export type EquipmentBounds={min:[number,number,number];max:[number,number,number]}
export type FloorEnvelope={x:number;z:number;width:number;depth:number}
export type FramingView='iso'|'front'|'side'|'top'

/** Inspect only the equipment subtree, never walls, floor paint or HTML labels. */
export function visibleEquipmentBounds(root:Object3D):EquipmentBounds|undefined {
 root.updateWorldMatrix(true,true)
 const result=new Box3(),instance=new Matrix4(),box=new Box3()
 root.traverseVisible(o=>{
  const mesh=o as any
  if(!mesh.isMesh||!mesh.geometry||mesh.userData.excludeFromFraming)return
  const mats=Array.isArray(mesh.material)?mesh.material:[mesh.material]
  if(mats.every((m:any)=>!m||m.visible===false||(m.transparent&&m.opacity<.15)))return
  mesh.geometry.computeBoundingBox()
  const local=mesh.geometry.boundingBox
  if(!local||local.isEmpty())return
  if(mesh.isInstancedMesh){
   for(let i=0;i<mesh.count;i++){
    mesh.getMatrixAt(i,instance)
    if(Math.abs(instance.determinant())<1e-12)continue
    instance.premultiply(mesh.matrixWorld)
    box.copy(local).applyMatrix4(instance)
    if(box.max.y>=-.5)result.union(box)
   }
  }else result.union(box.copy(local).applyMatrix4(mesh.matrixWorld))
 })
 if(result.isEmpty()||![...result.min.toArray(),...result.max.toArray()].every(Number.isFinite))return
 return {min:result.min.toArray() as EquipmentBounds['min'],max:result.max.toArray() as EquipmentBounds['max']}
}
export function mergeEquipmentBounds(a:EquipmentBounds|undefined,b:EquipmentBounds|undefined):EquipmentBounds|undefined {
 if(!a)return b;if(!b)return a
 return {min:a.min.map((v,i)=>Math.min(v,b.min[i])) as EquipmentBounds['min'],max:a.max.map((v,i)=>Math.max(v,b.max[i])) as EquipmentBounds['max']}
}
/** A drawing margin, independent of the benchmark's safety predicates. */
export function equipmentFloor(bounds:EquipmentBounds, envelope?:FloorEnvelope):FloorEnvelope {
 let left=bounds.min[0]-.65,right=bounds.max[0]+.65,back=bounds.min[2]-.65,front=bounds.max[2]+.65
 if(envelope){left=Math.min(left,envelope.x-envelope.width/2);right=Math.max(right,envelope.x+envelope.width/2);back=Math.min(back,envelope.z-envelope.depth/2);front=Math.max(front,envelope.z+envelope.depth/2)}
 return {x:(left+right)/2,z:(back+front)/2,width:Math.max(1.8,right-left),depth:Math.max(1.6,front-back)}
}
export function equipmentFront(machine:{floorFrontSign?:1|-1;geometry:{view:{frontSign?:1|-1}}}):1|-1 {
 return machine.geometry.view.frontSign??machine.floorFrontSign??1
}
export function framingCorners(bounds:EquipmentBounds,floor?:FloorEnvelope){
 const points:Vector3[]=[]
 for(const x of [bounds.min[0],bounds.max[0]])for(const y of [bounds.min[1],bounds.max[1]])for(const z of [bounds.min[2],bounds.max[2]])points.push(new Vector3(x,y,z))
 if(floor)for(const x of [-1,1])for(const z of [-1,1])points.push(new Vector3(floor.x+x*(floor.width/2+.06),0,floor.z+z*(floor.depth/2+.06)))
 return points
}
/** Fit in camera space, using the actual canvas aspect ratio, not the page width. */
export function fitEquipment(camera:PerspectiveCamera,bounds:EquipmentBounds,floor:FloorEnvelope|undefined,view:FramingView,front:1|-1,orientation?:{target:Vector3;direction:Vector3}){
 const target=orientation?.target.clone()??new Vector3(...bounds.min).add(new Vector3(...bounds.max)).multiplyScalar(.5)
 const direction=orientation?.direction.clone().normalize()??new Vector3(...(view==='front'?[0,.28,front]:view==='side'?[1,.28,0]:view==='top'?[0,1,.001*front]:[.46,.5,.78*front]) as [number,number,number]).normalize()
 const right=new Vector3(0,1,0).cross(direction).normalize(),up=direction.clone().cross(right)
 const tangent=Math.tan(camera.fov*Math.PI/360),horizontal=tangent*camera.aspect
 let distance=1.5
 for(const point of framingCorners(bounds,floor)){
  const p=point.sub(target),depth=p.dot(direction)
  distance=Math.max(distance,depth+Math.abs(p.dot(right))/(horizontal*.89),depth+Math.abs(p.dot(up))/(tangent*.89))
 }
 camera.position.copy(target).addScaledVector(direction,distance);camera.lookAt(target);camera.updateMatrixWorld(true);camera.updateProjectionMatrix()
 return {target,distance}
}

/** World-space trace anchors only; nested station-local poses are excluded. */
export function recordedTravelBounds(frames:readonly any[]=[]):EquipmentBounds|undefined {
 const box=new Box3()
 const include=(p:any,size?:any)=>{
  if(!Array.isArray(p)||p.length!==3||!p.every(Number.isFinite)||p[1]<-.5)return
  const half=Array.isArray(size)&&size.length===3?size.map((v:number)=>Math.max(.12,Math.abs(v)/2)):[.22,.22,.22]
  box.expandByPoint(new Vector3(p[0]-half[0],p[1]-half[1],p[2]-half[2]));box.expandByPoint(new Vector3(p[0]+half[0],p[1]+half[1],p[2]+half[2]))
 }
 for(const frame of frames){
  const w=frame.world;if(!w)continue
  for(const poses of [w.material_hard?.poses,w.material_hard?.contact?.poses,w.motion_hard?.poses,w.motion_medium?.mechanism?.poses,w.motion_easy_unit?.mechanism?.poses]){
   for(const p of Object.values(poses??{}) as any[])include(p.pos,p.size)
  }
  for(const parts of [w.parts,w.material_hard?.parts])for(const p of Object.values(parts??{}) as any[]){
   if(p.visible===false)continue
   include(p.pos??[p.x,p.y,p.z],p.size??p.dimensions)
  }
 }
 return box.isEmpty()?undefined:{min:box.min.toArray() as EquipmentBounds['min'],max:box.max.toArray() as EquipmentBounds['max']}
}
