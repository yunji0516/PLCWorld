import type { MotionHardState } from '@/lib/replay/adapter'

export function ArtifactMotionHardPanel({ value, playbackFinished = false }: {
  value: MotionHardState
  playbackFinished?: boolean
}) {
  const labels = value.dependency?.axis_labels ?? {}
  return <section data-testid="motion-dependency-state" className="mt-2 space-y-1 rounded-md border border-border px-2.5 py-2 text-[11px] leading-relaxed">
    <div className="font-semibold">{value.dependency?.task_number === 2 ? 'Rail-transfer task' : value.dependency?.task_number === 12 ? 'Jig-approach task' : 'Motion task'} · recorded physical state</div>
    {Object.entries(value.axes).map(([axis, state]) =>
      <div key={axis}>{labels[axis] ?? axis.toUpperCase()} · {state.actual.toFixed(2)} {state.unit} · {state.velocity.toFixed(1)} {state.unit}/s</div>)}
    <div className="border-t border-border pt-1">
      Objective · {value.shared.evaluation_complete || playbackFinished ? value.shared.task_success ? 'Achieved' : 'Not achieved' : 'In progress'}<br />
      Safety violation · {value.shared.safety_violation ? 'Yes' : 'No'}
    </div>
    <div>Completion hold · {Math.min(100, value.result_age_ms).toFixed(0)} / 100 ms</div>
    {value.violations.length > 0 && <div className="text-rose-600">{value.violations[0].replaceAll('_', ' ')}</div>}
  </section>
}
