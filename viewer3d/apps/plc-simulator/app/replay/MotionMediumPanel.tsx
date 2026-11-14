import type { Frame } from '@/lib/replay/adapter'

export const readableEvent = (name: string) => name.replaceAll('_', ' ').replace(/^./, first => first.toUpperCase())

export const MOTION_MEDIUM_REASONS: Record<string, string> = new Proxy({
  passed: 'Requested operation completed; path and settling confirmed',
  table_slide_collision: 'The rotating receiver collided with the slide tool',
  travel_limit: 'Actual travel limit exceeded',
  premature_completion: 'Completion asserted before physical settling',
  result_not_held: 'Final position or stopped state was not maintained',
}, { get: (labels, name: string) => labels[name as keyof typeof labels] ?? readableEvent(name) })

export function MotionMediumPanel({ value }: { value: NonNullable<NonNullable<Frame['world']>['motion_medium']> }) {
  const labels: Record<string, string> = value.mechanism?.axis_labels ?? {}
  return <section data-testid="motion-medium-state" className="mt-2 space-y-1 rounded-md border border-border px-2.5 py-2 text-[11px] leading-relaxed">
    <div className="font-semibold">{readableEvent(value.mode)} · physical motion and settling</div>
    {Object.entries(value.axes).map(([id, axis]) => {
      const rotary = axis.actual_deg !== undefined
      const unit = rotary ? 'deg' : 'mm'
      const actual = (rotary ? axis.actual_deg : axis.actual_mm) ?? 0
      const target = rotary ? axis.target_deg : axis.target_mm
      const velocity = (rotary ? axis.velocity_deg_s : axis.velocity_mm_s) ?? 0
      return <div key={id}>{labels[id] ?? id.toUpperCase()} · actual {actual.toFixed(2)} {unit}{target == null ? '' : ` / target ${target.toFixed(2)} ${unit}`} · speed {velocity.toFixed(2)} {unit}/s</div>
    })}
    {value.diagnostics && <div className="text-text-muted">{Object.entries(value.diagnostics).map(([name, reading]) => <span key={name} className="mr-2 inline-block">{readableEvent(name)}: {reading == null ? 'pending' : typeof reading === 'boolean' ? reading ? 'yes' : 'no' : reading.toFixed(2)}</span>)}</div>}
    <div>Final state held {Math.min(30, value.stable_ms).toFixed(0)} / 30 ms · completion held {Math.min(100, value.result_age_ms).toFixed(0)} / 100 ms</div>
    {value.violations.length > 0 && <div className="text-rose-600">{MOTION_MEDIUM_REASONS[value.violations[0]]}</div>}
  </section>
}
