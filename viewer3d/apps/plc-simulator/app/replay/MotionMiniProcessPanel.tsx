import type {MotionHardState} from '@/lib/replay/adapter'
import {MOTION_HARD_REASONS} from './MotionHardPanel'
export function MotionMiniProcessPanel({value:v}:{value:MotionHardState}){
 const p=v.process!
 return <section data-testid="motion-hard-state" className="mt-2 space-y-2 rounded-md border border-border px-2.5 py-2 text-[11px] leading-relaxed">
  <div className="font-semibold">{p.layout.labels[1]} → shuttle → {p.layout.labels[2]} → {p.layout.labels[3]} → return</div>
  {v.requests.map(j=><div key={j.id} data-request-id={j.id}><span className="font-medium">{j.lane===0?'A':'B'} · request {j.id}</span> · {j.phase}</div>)}
  <div className="border-t border-border pt-1">Shuttle · {v.shared.holding_id?`request ${v.shared.holding_id}`:'empty'}<br/>
   {['3','4'].map(id=><div key={id}>{p.layout.cells[id].label} · {p.stages[id].owner?`request ${p.stages[id].owner} · ${p.stages[id].served?'ready to retract and return':'operating'}`:'empty'}</div>)}
  </div>
  <div className="text-text-muted">Shuttle {v.axes.a.actual.toFixed(0)} mm · fork {v.axes.b.actual.toFixed(0)} mm<br/>Lifts A/B {v.axes.c.actual.toFixed(0)} / {v.axes.d.actual.toFixed(0)} mm</div>
  {Object.entries(p.metrics).flatMap(([id,metrics])=>Object.entries(metrics).filter(([k])=>!k.endsWith('_ms')).map(([key,value])=><div key={id+key} className="text-text-muted">{p.layout.cells[id].label} · {({skew_mm:'Skew mm',moment_nm:'Moment Nm',sway_deg:'Sway °',relative_mm:'Relative position mm',relative_mm_s:'Relative speed mm/s',tracking_error_deg:'Tracking error °'} as Record<string,string>)[key]??key} {value.toFixed(2)}</div>))}
  <div>Completion held {Math.min(100,v.result_age_ms).toFixed(0)} / 100 ms</div>
  {v.violations.length>0&&<div className="text-rose-600">{MOTION_HARD_REASONS[v.violations[0]]??v.violations[0]}</div>}
 </section>
}
