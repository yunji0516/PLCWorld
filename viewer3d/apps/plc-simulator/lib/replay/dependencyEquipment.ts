import type {MotionHardState} from './adapter'
import {structuralPart} from './primaryDevices'
type Dependency=NonNullable<MotionHardState['dependency']>
/** Use recorded axis identity to associate its fixed drive and moving components. */
export function dependencyEquipment(part:Dependency['parts'][number],geometry:Dependency){
 if(part.node?.startsWith('protected'))return {selectionDisabled:true}
 if(part.style==='sensor')return {equipmentUnit:true,equipmentGroup:`sensor:${part.name}`,deviceDisplayName:part.name}
 const labels={...geometry.labels,...geometry.axis_labels}
 const token=part.name.toLowerCase().split(/[ _-]/)[0]
 // These assemblies encode axis ownership in their authored component names;
 // their pose node can instead identify the carrier on which an axis is mounted.
 let authored:string|undefined
 if(geometry.task_number===2&&labels.c?.includes('cart')){
  if(/^(Longitudinal rail|Beam travel motor) 0$|^End carriage 0$/.test(part.name))authored='a'
  if(/^(Longitudinal rail|Beam travel motor) 1\.8$|^End carriage 1$/.test(part.name))authored='b'
  if(/^(Empty cart|Cart |Wheel axle)/.test(part.name))authored='c'
  if(['Latch cylinder','Coupling pin'].includes(part.name))return {equipmentUnit:true,equipmentGroup:'rail-latch',deviceDisplayName:'Rail latch'}
  if(part.node==='bridge')return {equipmentUnit:true,equipmentGroup:'shared-beam',deviceDisplayName:'Shared moving beam'}
  if(['Fixed service rail','Fixed rail wheel flange'].includes(part.name))return {equipmentUnit:true,equipmentGroup:'fixed-service-rail',deviceDisplayName:'Fixed service rail'}
 }
 if(geometry.task_number===10&&labels.a?.includes('L-shaped')&&/^(path-[xz]-|cross-saddle)/.test(part.name))authored='a'
 if(geometry.task_number===13&&labels.b?.includes('tilt')&&/^tilt-/.test(part.name))authored='b'
 if(geometry.task_number===12&&part.name==='Empty approach head'&&labels.c)authored='c'
 if(authored)return {equipmentUnit:true,equipmentGroup:`axis:${authored}`,deviceDisplayName:labels[authored]}
 const candidates=Object.entries(labels).filter(([id,label])=>{
  const words=label.toLowerCase().split(/[\s·_-]+/).filter(Boolean)
  return token===id.toLowerCase()||token===words[0]||(token.length>=3&&token===words[1])
 })
 if(candidates.length===0&&part.node&&labels[part.node])candidates.push([part.node,labels[part.node]])
 if(candidates.length===1){const [id,label]=candidates[0];return {equipmentUnit:true,equipmentGroup:`axis:${id}`,deviceDisplayName:label}}
 if(part.style==='base'||structuralPart(part.name))return {selectionDisabled:true}
 return {deviceDisplayName:part.name}
}
