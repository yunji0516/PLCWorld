import type { MotionHardState } from '@/lib/replay/adapter'
import { readableEvent, MOTION_MEDIUM_REASONS } from './MotionMediumPanel'
import { MotionMiniProcessPanel } from './MotionMiniProcessPanel'

export const MOTION_DEPENDENCY_REASONS: Record<string, string> = new Proxy({
  passed: 'Single-task result and hold condition confirmed',
  geometry_interference: 'Physical geometry interference',
  premature_completion: 'Completion declared before the physical result',
}, { get: (labels, name: string) => labels[name as keyof typeof labels] ?? readableEvent(name) })

export const MOTION_HARD_REASONS: Record<string, string> = new Proxy({
  ...MOTION_MEDIUM_REASONS,
  passed: 'All requests completed while shared conditions were maintained',
  shared_table_collision: 'Table and tool swept geometries collided',
  request_deadline_missed: 'A request deadline was missed',
}, { get: (labels, name: string) => labels[name as keyof typeof labels] ?? readableEvent(name) })

export function MotionHardPanel({ value, playbackFinished = false }: { value: MotionHardState; playbackFinished?: boolean }) {
  if (value.mode === 'mini_process') return <MotionMiniProcessPanel value={value} />
  const done = value.shared.evaluation_complete || playbackFinished
  return <section data-testid={value.dependency ? 'motion-dependency-state' : 'motion-hard-state'} className="mt-2 space-y-1 rounded-md border border-border px-2.5 py-2 text-[11px] leading-relaxed">
    <div className="font-semibold">{value.dependency ? 'Task dependencies and physical results' : 'Independent requests and shared resources'}</div>
    {value.requests.map(request => <div key={request.id} data-request-id={request.id}>Request {request.id} · {request.phase ?? request.status}</div>)}
    {Object.entries(value.axes).map(([name, axis]) => <div key={name}>{value.dependency?.axis_labels?.[name] ?? name.toUpperCase()} · actual {axis.actual.toFixed(2)} {axis.unit} · speed {axis.velocity.toFixed(1)} {axis.unit}/s</div>)}
    {value.dependency && value.shared.contract_revision >= 5 && <div>Objective: {done ? value.shared.task_success ? 'success' : 'failure' : 'in progress'} · safety violation: {value.shared.safety_violation ? 'yes' : 'no so far'}</div>}
    <div>Completion held {Math.min(100, value.result_age_ms).toFixed(0)} / 100 ms</div>
    {value.violations.length > 0 && <div className="text-rose-600">{(value.dependency ? MOTION_DEPENDENCY_REASONS : MOTION_HARD_REASONS)[value.violations[0]]}</div>}
  </section>
}
