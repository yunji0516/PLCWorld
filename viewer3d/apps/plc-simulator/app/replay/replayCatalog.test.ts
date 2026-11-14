import { expect, it } from 'vitest'
import type { TraceTask } from '@/lib/replay/adapter'
import { MATERIAL_MEDIUM20 } from './materialCatalog'
import { mergePublishedReplayCatalog } from './replayCatalog'

it('keeps published M18/M14/M15 and fills all 20 Medium tasks without replacing Motion or Hard', () => {
  const task = (title: string, suite = 'material', difficulty = 'medium') => ({title, suite, difficulty, runs:{}} as TraceTask)
  const archived = Object.fromEntries(Object.keys(MATERIAL_MEDIUM20).map(id => [id, task('archived')]))
  const m18 = task('tape separation candidate'), m14 = task('current M14'), m15 = task('current M15')
  const hard = {...task('mini-process', 'material', 'hard'), replay_deferred:true}
  const motion = task('motion', 'motion')
  const base = {'MAT-V8-D23':task('retired key matching'), 'MAT-M18-TAPE-R1':m18, 'MAT-V8-D19':m14, 'MAT-V8-D20':m15, 'MAT-H05':hard, 'MOT-M01':motion, 'MAT-M01-V5':task('retired')}
  const result = mergePublishedReplayCatalog(base, [archived])
  expect(Object.keys(result).filter(id => id in MATERIAL_MEDIUM20)).toHaveLength(20)
  expect(result['MAT-M18-TAPE-R1']).toBe(m18)
  expect(result['MAT-V8-D19']).toBe(m14)
  expect(result['MAT-V8-D20']).toBe(m15)
  expect(result['MAT-H05']).toBe(hard)
  expect(result['MOT-M01']).toBe(motion)
  expect(result['MAT-M01-V5']).toBeUndefined()
  expect(base['MAT-M01-V5']).toBeDefined()
  expect(result['MAT-V8-D23']).toBeUndefined()
})
