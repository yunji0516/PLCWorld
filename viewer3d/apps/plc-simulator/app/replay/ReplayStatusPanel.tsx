'use client'
import type {ReactNode} from 'react'
import type {Frame,TraceTask} from '@/lib/replay/adapter'
import {deviceDisplayName} from '@/lib/replay/deviceDisplayName'
import {primaryDeviceList} from '@/lib/replay/primaryDevices'
import {useReplaySelection} from './ReplaySelection'
import {selectedReadings,recordedParts} from './replayPresentation'
import {replayUiText,type ReplayLocale} from './replayUiText'
import styles from './replay.module.css'
export function ReplayStatusPanel({locale,open,task,frame,selectedId,message,violations,onClear,children}:{locale?:ReplayLocale;open:boolean;task:TraceTask;frame:Frame;selectedId:string|null;message:string;violations:string[];onClear:()=>void;children?:ReactNode}){
 const t=replayUiText(locale),context=useReplaySelection(),selection=context?.selection
 const device=task.devices.find(d=>d.id===selectedId),parts=recordedParts(frame),io=selectedReadings(task,frame,selectedId)
 const devices=context?.equipment?.length?context.equipment.map(d=>({id:d.id,label:d.name,key:d.key})):primaryDeviceList(task.devices).map(d=>({...d,key:d.id}))
 const aggregate=(id:string)=>['CELL','TAPE_CELL','MATERIAL_CELL'].includes(id)
 const number=(v:number)=>Number.isFinite(v)?String(Number(v.toFixed(3))):t.unavailable
 return <section id="replay-status" hidden={!open} className={styles.unifiedStatus} aria-label={t.status} data-testid="replay-status-panel">
  <div className={styles.statusHeading}><strong>{selectedId?t.selected:t.all}{selectedId&&<> · {deviceDisplayName(selection?.name??device?.label??selectedId)}</>}</strong>{selectedId&&<button type="button" className={styles.button} onClick={onClear}>{t.clear}</button>}</div>
  <div className={styles.statusGrid}>
   <section><h3>{t.process}</h3><p>{message}</p></section>
   <section><h3>{selectedId?t.io:t.devices}</h3>{selectedId?<>
    {!aggregate(selectedId)&&frame.s[selectedId]!==undefined&&<p>{t.position}: {number(frame.s[selectedId])}</p>}
    {io.length?io.map(r=><p key={r.address}><code>{r.address}</code> · {r.label}: <strong>{number(r.value)}</strong></p>):<p>{t.noIo}</p>}
   </>:<div className={styles.statusValues}>{devices.map(d=><span className={styles.statusChip} key={d.key}>{deviceDisplayName(d.label??d.id)}{!aggregate(d.id)&&frame.s[d.id]!==undefined?`: ${number(frame.s[d.id])}`:''}</span>)}{!devices.length&&<p>{t.unavailable}</p>}</div>}</section>
   <section><h3>{t.parts}</h3>{parts.length?parts.map(p=><p key={p.id}>{p.id} · {[p.owner,p.status].filter(Boolean).join(' · ')||t.unavailable}</p>):<p>{t.noParts}</p>}</section>
   <section><h3>{t.violation}</h3><p data-tone={violations.length?'failure':'idle'}>{violations.length?violations.join(' · '):t.none}</p></section>
  </div>
  {!selectedId&&children&&<details className={styles.taskReadings}><summary>{t.details}</summary><div className={styles.readingFlow}>{children}</div></details>}
 </section>
}
