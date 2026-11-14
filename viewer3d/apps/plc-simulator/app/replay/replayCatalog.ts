import type { Trace } from '@/lib/replay/adapter'
import { MATERIAL_MEDIUM20 } from './materialCatalog'

// These previews have been published. Old links should open the full current list.
export const PUBLISHED_CANDIDATE_ALIASES = [
  'motion-grounded-v5', 'motion-grounded-v6', 'motion-grounded-v7',
  'motion-v07', 'material-v6', 'material-v7', 'material-v8',
  'material-hard-priority', 'material-hard-miniprocess', 'material-m18-visual', 'material-m18-tape', 'material-hard-replenishment',
]

/** Active server entries win; archived Medium releases only fill missing tasks. */
export function mergePublishedReplayCatalog(base: Trace, fallbacks: Trace[]): Trace {
  const tasks = Object.fromEntries(Object.entries(base).filter(([id, task]) =>
    task.suite !== 'material' || task.difficulty !== 'medium' || id in MATERIAL_MEDIUM20))
  for (const fallback of fallbacks) {
    for (const [id, task] of Object.entries(fallback)) {
      if (id in MATERIAL_MEDIUM20 && task.suite === 'material' && task.difficulty === 'medium' && !(id in tasks)) {
        tasks[id] = task
      }
    }
  }
  return tasks
}
