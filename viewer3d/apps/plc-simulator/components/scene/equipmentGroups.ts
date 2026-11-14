import {Mesh,Object3D} from 'three'
import {equipmentSelectionTarget} from './deviceSelection'
import {equipmentPartName} from '@/lib/replay/deviceDisplayName'
export type EquipmentGroup={id:string;name:string;object:Object3D;objects:Object3D[]}
/** Keys identify a mechanism within an assembly instance, never a display name. */
export function collectEquipmentGroups(root:Object3D,id:string):EquipmentGroup[]{
 const groups=new Map<string,EquipmentGroup>()
 root.traverseVisible(hit=>{
  if(!(hit instanceof Mesh))return
  const object=equipmentSelectionTarget(hit,root);if(!object)return
  const name=object.userData.deviceDisplayName??equipmentPartName(object.name);if(!name)return
  let scope=object.parent
  while(scope&&scope!==root&&!scope.userData.equipmentScope)scope=scope.parent
  const key=object.userData.equipmentGroup?`${scope?.uuid??root.uuid}:${object.userData.equipmentGroup}`:object.uuid
  const group=groups.get(key)
  if(group){if(!group.objects.includes(object))group.objects.push(object)}
  else groups.set(key,{id:object.userData.selectionDeviceId??id,name,object,objects:[object]})
 })
 const rows=[...groups.values()],counts=new Map<string,number>(),seen=new Map<string,number>()
 for(const row of rows)counts.set(row.name,(counts.get(row.name)??0)+1)
 return rows.map(row=>{const name=row.name,n=(seen.get(name)??0)+1;seen.set(name,n);return (counts.get(name)??0)>1?{...row,name:`${name} ${n}`}:row})
}
