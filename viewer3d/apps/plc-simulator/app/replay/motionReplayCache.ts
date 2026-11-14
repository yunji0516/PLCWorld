import { hydrateMotionProcessLayouts, type Trace, type TraceTask } from '@/lib/replay/adapter'

/** Keep one full Motion Hard execution; the other entries retain their first frame. */
export function withActiveMotionReplay(previous: Trace, id: string, full: TraceTask): Trace {
  if (full.replay_shared_motion_layout) for (const run of Object.values(full.runs)) hydrateMotionProcessLayouts(run.frames)
  const admittedMedium = full.evaluation_status === 'admitted' && full.difficulty === 'medium'
  const groundedReview = full.task_version === 'motion-medium-grounded-v3-dev' || full.task_version === 'motion-medium-grounded-v4-dev'
  if (full.suite !== 'motion' || (full.difficulty !== 'hard' && !groundedReview && !admittedMedium)) return { ...previous, [id]: full }
  const next = { ...previous, [id]: full }
  for (const [otherId, task] of Object.entries(next)) {
    if (otherId === id || task.suite !== 'motion' || (admittedMedium ? task.evaluation_status !== 'admitted' || task.difficulty !== 'medium' : groundedReview ? task.task_version !== full.task_version : task.difficulty !== 'hard') || task.replay_deferred) continue
    next[otherId] = {
      ...task,
      replay_deferred: true,
      runs: Object.fromEntries(Object.entries(task.runs).map(([label, run]) => [label, { ...run, recorded_geometry: undefined, frames: run.frames.slice(0, 1) }])),
    }
  }
  return next
}

/** Release inactive Material Hard traces without changing any task's geometry or metadata. */
export function withActiveMaterialReplay(previous: Trace, id: string, full: TraceTask): Trace {
  if (full.suite !== 'material' || full.difficulty !== 'hard') return { ...previous, [id]: full }
  const next = { ...previous, [id]: full }
  for (const [otherId, task] of Object.entries(next)) {
    if (otherId === id || task.suite !== 'material' || task.difficulty !== 'hard' || task.replay_deferred || task.family === 'material_hard_process_review') continue
    next[otherId] = {
      ...task,
      replay_deferred: true,
      runs: Object.fromEntries(Object.entries(task.runs).map(([label, run]) => [label, { ...run, recorded_geometry: undefined, frames: run.frames.slice(0, 1) }])),
    }
  }
  return next
}
