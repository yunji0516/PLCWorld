import type { Trace, TraceTask } from '@/lib/replay/adapter'
import reviewHolds from './taskReviewHolds.json'
import { MATERIAL_MEDIUM20 } from './materialCatalog'

/** Design acceptance follows the confirmed task roster, independently of model-score provenance. */
export function withTaskAdmission(id: string, task: TraceTask): TraceTask {
  // Final evaluator metadata is authoritative; legacy design holds must not override it.
  if (task.evaluation_release === 'plcworld-evaluation/5.2.6') return task
  if (id==='MOT-M12' && task.task_version==='priority-redesign/1.1') {
    return {...task, review_hold:undefined, candidate_status:'design_accepted', design_accepted:true,
      evaluation_status:'admitted', score_role:'core', evaluation_family:'MOT-M12'}
  }
  if (task.task_version === 'priority-redesign/1' && ['MOT-M02','MAT-H07','MOT-M12'].includes(id)) {
    const variant=id==='MOT-M12'
    return {...task, review_hold:undefined, candidate_status:'design_accepted', design_accepted:true, evaluation_status:variant?'variant':'admitted', ...(variant?{score_role:'implementation_variant',evaluation_family:'MOT-M15'}:{})}
  }
  const hold = reviewHolds[id as keyof typeof reviewHolds]
  if (hold) return {...task, candidate_status:'review_pending', evaluation_status:'on_hold', review_hold:hold, design_accepted:false}
  const confirmedMaterial = task.suite === 'material' && (
    (task.difficulty === 'medium' && Object.hasOwn(MATERIAL_MEDIUM20, id)) ||
    (task.difficulty === 'hard' && /^MAT-H(0[1-9]|1[0-5])$/.test(id))
  )
  return confirmedMaterial ? {...task, candidate_status:'design_accepted', design_accepted:true} : task
}
export function withCatalogAdmission(trace: Trace): Trace {
  return Object.fromEntries(Object.entries(trace).map(([id, task]) => [id, withTaskAdmission(id, task)]))
}
