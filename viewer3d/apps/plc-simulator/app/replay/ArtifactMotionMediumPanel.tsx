import type { Frame } from '@/lib/replay/adapter'

type State = NonNullable<NonNullable<Frame['world']>['motion_medium']>

const titles: Record<string, string> = {
  gear: 'Synchronized rotation and parking',
  hoist: 'Hoist travel and sway-controlled stop',
  counterbalance: 'Counterweight tilt and brake support',
  table_slide: 'Rotary table and approach slide',
}

function valueLabel(value: number | boolean | null): string {
  if (value === null) return 'not available'
  if (typeof value === 'boolean') return value ? 'yes' : 'no'
  return value.toFixed(2)
}

export function ArtifactMotionMediumPanel({ value }: { value: State }) {
  return <section data-testid="motion-medium-state" className="mt-2 space-y-1 rounded-md border border-border px-2.5 py-2 text-[11px] leading-relaxed">
    <div className="font-semibold">{titles[value.mode] ?? value.mode.replaceAll('_', ' ')}</div>
    {Object.entries(value.axes).map(([id, axis]) => {
      const rotary = axis.actual_deg !== undefined
      const unit = rotary ? '°' : ' mm'
      const actual = rotary ? axis.actual_deg : axis.actual_mm
      const target = rotary ? axis.target_deg : axis.target_mm
      const speed = rotary ? axis.velocity_deg_s : axis.velocity_mm_s
      const name = value.mechanism?.axis_labels?.[id] ?? (id === 's' ? 'Driven axis' : id === 'u' ? 'Reference axis' : `Axis ${id.toUpperCase()}`)
      return <div key={id}>
        {name} · actual {(actual ?? 0).toFixed(2)}{unit}
        {target != null && <> · target {target.toFixed(2)}{unit}</>}
        {' · '}speed {(speed ?? 0).toFixed(2)}{unit}/s
      </div>
    })}
    {value.diagnostics && <div className="text-text-muted">
      {Object.entries(value.diagnostics).slice(0, 6).map(([key, diagnostic]) => <span key={key} className="mr-2 inline-block">
        {key.replaceAll('_', ' ')}: {valueLabel(diagnostic)}
      </span>)}
    </div>}
    <div>Result hold: {value.result_age_ms.toFixed(0)} / 100 ms</div>
    <div>{value.success ? 'Task complete' : value.result_asserted ? 'Checking result hold' : 'Task in progress'}</div>
    {value.violations.length > 0 && <div className="text-rose-600">{value.violations[0].replaceAll('_', ' ')}</div>}
  </section>
}
