import { expect, it } from 'vitest'
import type { TraceTask } from '@/lib/replay/adapter'
import { MATERIAL_MEDIUM20 } from './materialCatalog'
import { withTaskAdmission } from './taskAdmission'
import { withActiveMotionReplay } from './motionReplayCache'

it('preserves final evaluator admission instead of applying legacy review holds', () => {
  for (const id of ['MOT-M02', 'MAT-H07', 'MOT-M12']) {
    const task = {evaluation_release:'plcworld-evaluation/5.2.6',candidate_status:'design_accepted',runs:{}} as TraceTask
    expect(withTaskAdmission(id, task)).toBe(task)
  }
})

it('honors the confirmed Material roster without changing observations, programs or verdicts', () => {
  for (const [id, difficulty] of [...Object.keys(MATERIAL_MEDIUM20).map(id => [id,'medium']), ...Array.from({length:15},(_,i)=>[`MAT-H${String(i+1).padStart(2,'0')}`,'hard'])]) {
    const task = {suite:'material',difficulty,candidate_status:'review_pending',runs:{normal:{code:'PROGRAM P',frames:[{k:0}],goal:true}}} as unknown as TraceTask
    const result=withTaskAdmission(id,task)
    expect(result.candidate_status).toBe(id==='MAT-H07'?'review_pending':'design_accepted')
    expect(result.runs).toBe(task.runs)
    if(id==='MAT-H07') expect(result.evaluation_status).toBe('on_hold')
    else expect(result.evaluation_status).toBeUndefined()
    expect(task.candidate_status).toBe('review_pending')
  }
  const retired={suite:'material',difficulty:'medium',candidate_status:'review_pending'} as TraceTask
  expect(withTaskAdmission('MAT-V8-D23',retired)).toBe(retired)
})

it('evicts and reloads admitted Motion Medium runs without reviving candidate metadata', () => {
  const task={suite:'motion',difficulty:'medium',candidate_status:'design_accepted',evaluation_status:'admitted',evaluation_release:'motion-medium-release/1.0',runs:{normal:{frames:[{k:0},{k:1}],goal:true,viol:[]}}} as unknown as TraceTask
  const legacy={...task,evaluation_status:undefined} as TraceTask
  const next=withActiveMotionReplay({'MOT-M06':task,'MOT-M01':legacy},'MOT-M12',task)
  expect(next['MOT-M06'].replay_deferred).toBe(true)
  expect(next['MOT-M06'].evaluation_status).toBe('admitted')
  expect(next['MOT-M06'].runs.normal.frames).toHaveLength(1)
  expect(next['MOT-M01']).toBe(legacy)
  const back=withActiveMotionReplay(next,'MOT-M06',task)
  expect(back['MOT-M06'].runs.normal.frames).toHaveLength(2)
  expect(back['MOT-M12'].replay_deferred).toBe(true)
})


it('holds the three disputed tasks even when a deferred replay carries older acceptance metadata', () => {
  for (const id of ['MOT-M02','MAT-H07','MOT-M12']) {
    const task={suite:id.startsWith('MAT')?'material':'motion',difficulty:id==='MAT-H07'?'hard':'medium',candidate_status:'design_accepted',evaluation_status:'admitted',runs:{normal:{frames:[{k:0},{k:1}]}}} as unknown as TraceTask
    const held=withTaskAdmission(id,task)
    expect(held.evaluation_status).toBe('on_hold')
    expect(held.review_hold?.reason).toBeTruthy()
    expect(held.runs).toBe(task.runs)
  }
  const h04={suite:'material',difficulty:'hard',runs:{}} as TraceTask
  expect(withTaskAdmission('MAT-H04',h04).candidate_status).toBe('design_accepted')
  expect(withTaskAdmission('MAT-H13',h04).review_hold).toBeUndefined()
})

it('accepts only the new redesign revision and keeps M12 out of independent scoring', () => {
  for (const id of ['MOT-M02','MAT-H07','MOT-M12']) {
    const task={task_version:'priority-redesign/1',review_hold:{label:'stale',reason:'stale',kind:'taxonomy'},runs:{}} as TraceTask
    const admitted=withTaskAdmission(id,task)
    expect(admitted.review_hold).toBeUndefined()
    expect(admitted.evaluation_status).toBe(id==='MOT-M12'?'variant':'admitted')
    expect(admitted.runs).toBe(task.runs)
    if(id==='MOT-M12') expect(admitted.evaluation_family).toBe('MOT-M15')
    expect(withTaskAdmission(id,{...task,task_version:'14.0-control-expansion'}).evaluation_status).toBe('on_hold')
  }
})

it('admits the official M12 revision independently without reclassifying historical variants', () => {
  const runs={normal:{frames:[{k:0}],goal:true}}
  const task={task_version:'priority-redesign/1.1',evaluation_status:'variant',score_role:'implementation_variant',evaluation_family:'MOT-M15',runs} as unknown as TraceTask
  const admitted=withTaskAdmission('MOT-M12',task)
  expect(admitted.evaluation_status).toBe('admitted')
  expect(admitted.evaluation_family).toBe('MOT-M12')
  expect(admitted.score_role).not.toBe('implementation_variant')
  expect(admitted.review_hold).toBeUndefined()
  expect(admitted.runs).toBe(runs)
  expect(withTaskAdmission('MOT-M12',{...task,task_version:'priority-redesign/1'}).evaluation_status).toBe('variant')
})
