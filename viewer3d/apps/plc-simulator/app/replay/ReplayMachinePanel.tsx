'use client'
import type {Frame,TraceTask} from '@/lib/replay/adapter'
import {deviceDisplayName} from '@/lib/replay/deviceDisplayName'
import {primaryDeviceList} from '@/lib/replay/primaryDevices'
import {type ReplayEquipment,useReplaySelection} from './ReplaySelection'
import {recordedDeviceState} from './replayDeviceState'
import {selectedReadings} from './replayPresentation'
import {MotionDependencyRelationsPanel} from './MotionDependencyRelationsPanel'

/** A common equipment inspector; only recorded values and explicit I/O bindings are shown. */
export function ReplayMachinePanel({task,frame,selectedId,onSelect}:{task:TraceTask;frame:Frame;selectedId:string|null;onSelect:(id:string|null)=>void}){
 const context=useReplaySelection()
 const equipment:ReplayEquipment[]=context?.equipment?.length?context.equipment:primaryDeviceList(task.devices).map(d=>({
  key:d.id,id:d.id,name:d.label??d.id,selected:selectedId===d.id,select:()=>onSelect(selectedId===d.id?null:d.id),
 }))
 const selected=equipment.find(d=>d.selected)
 const id=selected?.id??selectedId
 const composite=id==='CELL'||id==='TAPE_CELL'||id==='MATERIAL_CELL'
 const readings=selectedReadings(task,frame,composite?null:id)
 const state=recordedDeviceState(task,frame,id)
 const pose=selected?.poseId?frame.world?.material_hard?.contact?.poses[selected.poseId]?.pos:id&&!composite?frame.world?.devices?.[id]?.pos:undefined
 const coupling=frame.world?.motion_hard?.dependency?.coupling
 const hasRelations=!!task.relations?.length||!!(coupling&&(coupling.purpose||coupling.states.length||coupling.results.length))
 const number=(v:number)=>Number.isFinite(v)?String(Number(v.toFixed(3))):'Unavailable'
 return <section data-testid="replay-machine-panel" className="text-[11px] leading-relaxed">
  <div className="border-b border-border px-3 py-2.5"><h3 className="font-semibold">Devices</h3><p className="mt-1 text-text-muted">Select equipment here or in the 3D scene to inspect its recorded state.</p></div>
  <div data-testid="machine-devices" className="max-h-64 overflow-y-auto border-b border-border">
   {equipment.length?equipment.map(d=><button key={d.key} type="button" aria-pressed={d.selected} onClick={d.select} className={`block w-full border-b border-border/40 px-3 py-2 text-left ${d.selected?'bg-surface-2 text-accent':'hover:bg-surface-2/60'}`}>{deviceDisplayName(d.name)}</button>):<p className="px-3 py-2 text-text-muted">No selectable equipment is available yet.</p>}
  </div>
  <section className="border-b border-border px-3 py-3" data-testid="machine-selected-state">
   <h3 className="font-semibold">Selected device</h3>
   {id?<><p className="mt-1 font-medium">{deviceDisplayName(selected?.name??context?.selection?.name??id)}</p>
    <h4 className="mt-3 text-text-subtle">Recorded state · scan {frame.k}</h4>
    {state!==null&&<p>{state}</p>}
    {pose&&<p>Position: {pose.map(number).join(', ')}</p>}
    {state===null&&!pose&&<p className="text-text-muted">No separate state is recorded for this device.</p>}
    <h4 className="mt-3 text-text-subtle">Linked I/O</h4>
    {readings.length?readings.map(r=><p key={r.address}><code>{r.address}</code> · {r.label}: <strong>{number(r.value)}</strong></p>):<p className="text-text-muted">No explicit I/O binding is provided for this device.</p>}
   </>:<p className="mt-1 text-text-muted">Select a device to see its state and linked I/O.</p>}
  </section>
  {hasRelations&&<section data-testid="machine-relationships"><h3 className="px-3 pt-3 font-semibold">Device relationships</h3>
   {coupling&&<MotionDependencyRelationsPanel value={coupling}/>}
   {!!task.relations?.length&&<ul className="space-y-1 px-3 py-3">{task.relations.map((rel,i)=><li key={i}>{deviceDisplayName(rel.type)} · {rel.child??rel.device??rel.rule}{rel.parent?` → ${rel.parent}`:''}</li>)}</ul>}
  </section>}
 </section>
}
