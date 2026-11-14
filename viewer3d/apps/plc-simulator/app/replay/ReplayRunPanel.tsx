'use client'
import type {TraceRun} from '@/lib/replay/adapter'
import {executionOutcome,replayGroup} from './replayPresentation'
import {replayUiText,type ReplayLocale} from './replayUiText'
import styles from './replay.module.css'
export function ReplayRunPanel({locale,runs,selected,loading,reason,onSelect,onSeek,focusScan,label}:{locale?:ReplayLocale;runs:Record<string,TraceRun>;selected:string;loading:boolean;reason:string;onSelect:(name:string)=>void;onSeek:()=>void;focusScan:number;label:(name:string)=>string}){
 const t=replayUiText(locale),current=runs[selected],outcome=current?executionOutcome(current,loading):'unavailable'
 return <section className={styles.executionPanel} data-testid="replay-execution">
  <h3>{t.runs}</h3><label>{t.choose}<select aria-label={t.choose} value={selected} onChange={e=>onSelect(e.target.value)}>
   {(['reference','mine','paper','other'] as const).map(group=>{const names=Object.keys(runs).filter(name=>replayGroup(name)===group);return names.length?<optgroup key={group} label={t[group]}>{names.map(name=><option key={name} value={name}>{runs[name].label||label(name)} · {executionOutcome(runs[name],loading)==='loading'?t.loading:executionOutcome(runs[name])==='unavailable'?t.empty:executionOutcome(runs[name])}</option>)}</optgroup>:null})}
  </select></label>
  <div className={styles.executionVerdict} data-outcome={outcome}><strong data-testid="replay-verdict">{outcome==='loading'?t.loading:outcome==='unavailable'?t.empty:outcome}</strong><p>{t.condition}</p>{outcome!=='loading'&&outcome!=='unavailable'&&<p>{t.reason}: {reason}</p>}</div>
  <button type="button" disabled={outcome==='loading'||outcome==='unavailable'} className={styles.button} onClick={onSeek}>{outcome==='FAIL'?t.failure:t.moment} · scan {focusScan}</button>
 </section>
}
