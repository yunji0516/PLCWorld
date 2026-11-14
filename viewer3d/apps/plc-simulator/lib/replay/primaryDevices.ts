/** Display/interaction policy only; the full device list stays in the trace. */
type Device = {id:string;kind?:string;ui?:string;label?:string;visualVariant?:string;visual_variant?:string}
export const structuralPart = (name:string) => /(?:^|[_\s-])(?:tabletop|workbench|floor|leg\d*|foot\w*|column|post\w*|pedestal|crossbeam|bracket|mount\w*|bearing|bolt|screw|handle|vent\w*|panel|cover|guard|frame|chassis|support|bench|underframe|base|baseplate|coupling)(?:$|[_\s-]|\d)/i.test(name)

export function primaryDevice(device:Device, devices:Device[]) : {id:string;label:string;members:string[]} | undefined {
 const variant=device.visualVariant??device.visual_variant??'',kind=device.ui??device.kind
 if(/(?:ribbon|strip|target|pouch|liquid|liquid-level)$/.test(variant))return undefined
 if(variant==='hard-control-cabinet'||/^controls?$/.test(device.id))return undefined
 if(kind==='support_frame')return undefined
 if(kind==='platform'&&!/hard-(spindle|probe|feed-belt|control-cabinet|fixture-clamp)/.test(variant))return undefined
 if(structuralPart(device.id)||structuralPart(device.label??''))return undefined
 if(variant==='hard-workbench'||/^(BASE|FRAME|TABLE)$/.test(device.id))return undefined
 const label=device.label??device.id
 const repeated=devices.filter(d=>(d.label??d.id)===label).length>1
 return {id:device.id,label:repeated?`${label} · ${device.id}`:label,members:[device.id]}
}

export function primaryDeviceList<T extends Device>(devices:T[]) {
 const seen=new Set<string>(),result:T[]=[]
 for(const d of devices){if(['CELL','TAPE_CELL','MATERIAL_CELL'].includes(d.id)||(d.visualVariant??d.visual_variant)==='cell3-mini-anchor')continue;const p=primaryDevice(d,devices);if(!p||seen.has(p.id))continue;seen.add(p.id);result.push(devices.find(item=>item.id===p.id)??d)}
 return result
}

export function primaryReviewNode(node:{id:string;name:string;shape:string;material?:boolean}, registeredIds:Set<string>){
 if(node.material||node.shape==='label'||structuralPart(node.id)||structuralPart(node.name))return false
 return registeredIds.has(node.id)||/Supply roll|Nip roller|Winding shaft|Stopper|Pusher|Applicator head|Cutting support|Suction head|Gripper|Gripper|Conveyor|Pump|Valve|Tank|Nozzle|Cylinder|Inspection head|Clamp|Rotary table|Lift platform|Control cabinet|Cradle/i.test(node.name)
}
