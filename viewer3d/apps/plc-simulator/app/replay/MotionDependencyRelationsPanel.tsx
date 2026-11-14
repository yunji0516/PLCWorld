import type { MotionHardState } from '@/lib/replay/adapter'

type Coupling = NonNullable<NonNullable<MotionHardState['dependency']>['coupling']>
export function MotionDependencyRelationsPanel({value}:{value:Coupling;english?:boolean}) {
  const rows=(items:Coupling['states'])=>items.map(row=><div key={row.id} data-condition={row.id} data-status={row.status} className="flex items-start gap-2 py-1">
    <span aria-hidden className={`mt-1 h-1.5 w-1.5 shrink-0 rounded-full ${row.status==='ready'||row.status==='recorded'?'bg-emerald-600':'bg-slate-400'}`}/>
    <div><span className="font-medium">{row.label}</span><div className="text-text-muted">{row.value}</div></div>
  </div>)
  return <section data-testid="motion-coupling-state" className="border-b border-border px-3 py-3 text-[11px] leading-relaxed">
    {value.purpose&&<p className="text-text-muted">{value.purpose}</p>}
    {value.states.length>0&&<><p className="mt-3 text-[10px] text-text-subtle">Physical state at end of scan</p>{rows(value.states)}</>}
    {value.results.length>0&&<><p className="mt-3 text-[10px] text-text-subtle">Completion history</p>{rows(value.results)}</>}
  </section>
}
