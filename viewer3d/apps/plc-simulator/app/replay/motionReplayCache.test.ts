import { expect, it } from 'vitest'
import type { Trace, TraceTask } from '@/lib/replay/adapter'
import { withActiveMotionReplay } from './motionReplayCache'
import { withHardProcessModels } from './hardProcessCatalog'

it('keeps the 14 redesigned catalogue entries when H01 loads, without fetching legacy ST traces for them', async () => {
  const { withActiveMaterialReplay } = await import('./motionReplayCache')
  const h01 = {suite:'material',difficulty:'hard',runs:{normal:{frames:[{k:0}],goal:true,viol:[]}}} as unknown as TraceTask
  const catalogue = withHardProcessModels({'MAT-H01':h01})
  const loaded = withActiveMaterialReplay(catalogue,'MAT-H01',h01)
  expect(Object.keys(loaded)).toHaveLength(15)
  for (let n=2;n<=15;n++) {
    const id=`MAT-H${String(n).padStart(2,'0')}`
    expect(loaded[id]).toBe(catalogue[id])
    // Published replacements defer their own trace; loading H01 must preserve
    // that flag as well as the unimplemented review entries' metadata.
    expect(loaded[id].replay_deferred).toBe(catalogue[id].replay_deferred)
    expect(loaded[id].runs).toEqual({})
  }
  expect(loaded['MAT-H01']).toBe(h01)
})

it('keeps sealed final-evaluator Material Hard tasks instead of archived review demos', () => {
  const final = {suite:'material',difficulty:'hard',evaluation_release:'plcworld-evaluation/5.2.6',
    replay_deferred:true,runs:{'Paper sample · model repeat 1 · condition 0':{frames:[{k:0}]}}} as unknown as TraceTask
  const catalog = withHardProcessModels({'MAT-H02':final,'MAT-H07':final,'MAT-H15':final})
  expect(catalog['MAT-H02']).toBe(final)
  expect(catalog['MAT-H07']).toBe(final)
  expect(catalog['MAT-H15']).toBe(final)
})

it('releases previous Motion Hard frames while preserving other suites and replay metadata', () => {
  const first = {suite:'motion', difficulty:'hard', runs:{normal:{goal:true,frames:[{k:0},{k:1},{k:2}],viol:[]}}} as unknown as TraceTask
  const material = {...first, suite:'material'} as TraceTask
  const medium = {...first,difficulty:'medium'} as TraceTask
  const previous:Trace = {'MOT-H01':first,'MAT-H01':material,'MOT-M01':medium}
  const loaded = withActiveMotionReplay(previous,'MOT-H02',first)
  expect(loaded['MOT-H02']).toBe(first)
  expect(loaded['MOT-H01'].replay_deferred).toBe(true)
  expect(loaded['MOT-H01'].runs.normal.frames).toEqual([{k:0}])
  expect(loaded['MOT-H01'].runs.normal.goal).toBe(true)
  expect(loaded['MOT-H01'].runs.normal.viol).toBe(first.runs.normal.viol)
  expect(loaded['MAT-H01']).toBe(material)
  expect(loaded['MOT-M01']).toBe(medium)
  expect(previous['MOT-H01'].runs.normal.frames).toHaveLength(3)
  const restored=withActiveMotionReplay(loaded,'MOT-H01',first)
  expect(restored['MOT-H01'].runs.normal.frames).toHaveLength(3)
  expect(restored['MOT-H02'].runs.normal.frames).toHaveLength(1)
})

it('releases inactive Material Hard executions and restores one while keeping Medium and Motion intact', async () => {
  const { withActiveMaterialReplay } = await import('./motionReplayCache')
  const task = {suite:'material', difficulty:'hard', devices:[{id:'CELL',visual_variant:'cell3-mini-index'}], runs:{normal:{goal:true,frames:[{k:0},{k:1},{k:2}],viol:[]}}} as unknown as TraceTask
  const medium = {...task,difficulty:'medium'} as TraceTask
  const motion = {...task,suite:'motion'} as TraceTask
  const previous = {'MAT-H05':task,'MAT-M18':medium,'MOT-H01':motion}
  const loaded=withActiveMaterialReplay(previous,'MAT-H06',task)
  expect(loaded['MAT-H05'].runs.normal.frames).toHaveLength(1)
  expect(loaded['MAT-H05'].devices).toBe(task.devices)
  expect(loaded['MAT-H05'].replay_deferred).toBe(true)
  expect(loaded['MAT-M18']).toBe(medium)
  expect(loaded['MOT-H01']).toBe(motion)
  const restored=withActiveMaterialReplay(loaded,'MAT-H05',task)
  expect(restored['MAT-H05']).toBe(task)
  expect(restored['MAT-H06'].replay_deferred).toBe(true)
})

it('releases detailed geometry when a Material task becomes inactive', async () => {
  const {withActiveMaterialReplay}=await import('./motionReplayCache')
  const geometry={schema:'test',task:'MAT-H09',nodes:[],devices:[],frames:[]}
  const old={suite:'material',difficulty:'hard',runs:{normal:{frames:[{k:0},{k:1}],recorded_geometry:geometry,goal:true,viol:[]}}} as unknown as TraceTask
  const next=withActiveMaterialReplay({'MAT-H09':old},'MAT-H10',{...old})
  expect(next['MAT-H09'].runs.normal.recorded_geometry).toBeUndefined()
  expect(next['MAT-H09'].runs.normal.frames).toHaveLength(1)
  expect(next['MAT-H10'].runs.normal.recorded_geometry).toBe(geometry)
  expect(old.runs.normal.recorded_geometry).toBe(geometry)
})
