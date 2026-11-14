import {equipmentPartName} from '@/lib/replay/deviceDisplayName'
import {structuralPart} from '@/lib/replay/primaryDevices'
import { Box3, Color, Material, Mesh, Object3D, Vector3 } from 'three'

export const DEVICE_SELECTION_COLOR = '#f0c16a'
function structuralMesh(object:Object3D,root:Object3D){
 for(let o:Object3D|null=object;o;o=o.parent){
  if(o!==root&&o.userData.equipmentUnit)return true
  const recordedBody=root.userData.equipmentUnit&&(o===root||(o.parent===root&&o.name.startsWith('dependency-part-')))
  if(!recordedBody&&(structuralPart(o.name)||structuralPart(o.userData.deviceDisplayName??'')))return true
  if(o===root)break
 }
 return false
}

/** Independent materials prevent a selection from tinting other shared equipment. */
export function highlightDevice(root: Object3D) {
  const changed: { mesh: Mesh; original: Material | Material[]; selected: Material | Material[] }[] = []
  root.traverse(object => {
    if (!(object instanceof Mesh)||structuralMesh(object,root)) return
    const original = object.material
    const tint = (material: Material) => {
      const copy = material.clone()
      if ('color' in copy) (copy.color as Color).set(DEVICE_SELECTION_COLOR)
      return copy
    }
    const selected = Array.isArray(original) ? original.map(tint) : tint(original)
    object.material = selected
    changed.push({ mesh: object, original, selected })
  })
  return () => {
    for (const { mesh, original, selected } of changed) {
      if (mesh.material === selected) mesh.material = original
      for (const material of Array.isArray(selected) ? selected : [selected]) material.dispose()
    }
  }
}

/** Stable equipment centre, never the pointer intersection. Follows replay poses. */
export function deviceBadgePosition(object: Object3D, target: Vector3, bounds = new Box3(), above = false) {
  object.updateWorldMatrix(true, true)
  bounds.makeEmpty()
  object.traverse(child => {
    if (!(child instanceof Mesh)||structuralMesh(child,object)) return
    for (let p: Object3D | null = child; p; p = p.parent) if (!p.visible) return
    if (!child.geometry.boundingBox) child.geometry.computeBoundingBox()
    if (child.geometry.boundingBox) bounds.union(child.geometry.boundingBox.clone().applyMatrix4(child.matrixWorld))
  })
  if (bounds.isEmpty()) object.getWorldPosition(target)
  else {bounds.getCenter(target);if(above)target.y=bounds.max.y}
  target.y += .13
  return target
}

const functionalEquipmentName=(name:string)=>/gripper|clamp|cylinder|servo|motor|carriage|conveyor|belt|lift|fork|rotary|turntable|probe|sensor|roller|drum|reel|spool|door|stopper|tool|pump|valve|tank|nozzle|head|cradle/i.test(name)

/** A composite cell is never itself an equipment selection boundary. */
export function equipmentSelectionTarget(hit:Object3D,root:Object3D) {
 const path:Object3D[]=[];for(let o:Object3D|null=hit;o&&o!==root;o=o.parent)path.push(o)
 if(path.some(o=>o.userData.selectionDisabled))return undefined
 // A support face cannot select a functional ancestor behind it.
 for(const o of path){
  if(o.userData.equipmentUnit||(o.parent?.userData.equipmentUnit&&o.name.startsWith('dependency-part-')))break
  if(structuralPart(o.name)||structuralPart(o.userData.deviceDisplayName??''))return undefined
  if(o.userData.selectionDeviceId||o.userData.deviceDisplayName)break
 }
 for(const o of path)if(o.userData.equipmentUnit)return o
 for(const o of path)if(o.userData.selectionDeviceId||o.userData.deviceDisplayName)return structuralPart(o.userData.deviceDisplayName??'')?undefined:o
 for(const o of path){
  const name=equipmentPartName(o.name)
  if(!name||!functionalEquipmentName(name)||structuralPart(name)||structuralPart(o.name))continue
  let furniture=false;o.traverse(c=>{if(/bench-top|table-top|tabletop|table-underframe|fixed-deck/.test(c.name))furniture=true})
  if(!furniture)return o
 }
 return undefined
}

/** Position a single badge over all components of the selected equipment. */
export function equipmentGroupBadgePosition(objects:Object3D[],target:Vector3,bounds=new Box3(),above=false){
 bounds.makeEmpty()
 const partBounds=new Box3()
 for(const object of objects){deviceBadgePosition(object,target,partBounds);bounds.union(partBounds)}
 if(bounds.isEmpty()){objects[0]?.getWorldPosition(target);target.y+=.13}
 else {bounds.getCenter(target);if(above)target.y=bounds.max.y;target.y+=.13}
 return target
}
