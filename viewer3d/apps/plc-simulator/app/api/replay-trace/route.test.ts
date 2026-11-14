import { afterEach, expect, it, vi } from 'vitest'
import { mkdtemp, mkdir, readFile, rm, writeFile as writeActual } from 'node:fs/promises'
import os from 'node:os'
import path from 'node:path'
import { gunzipSync } from 'node:zlib'

async function writeFile(filename: string, data: string) {
  await writeActual(filename, data)
  if (filename.endsWith('original-replay.catalog.json')) {
    const bundle = JSON.parse(data)
    const tasks = Object.fromEntries(Object.entries(bundle.tasks).map(([id, task]:[string,any]) =>
      [id,{runs:Object.fromEntries(Object.entries(task.runs).map(([label,run]:[string,any]) =>
        [label,{label,goal:run.goal,verdict:run.verdict,frames:[],il:'',viol:[]}]))}]))
    await writeActual(filename.replace('.catalog.json','.index.json'), JSON.stringify({...bundle,tasks}))
  }
}

let temporary = ''

it('loads source-bound contact machinery without changing archived verdicts', async () => {
  const { GET } = await import('./route')
  for (const id of ['MAT-H06','MAT-H14']) {
    const response = await GET(new Request(`http://localhost/api/replay-trace?material_task=${id}`, {headers:{'accept-encoding':'gzip'}}))
    expect(response.status).toBe(200)
    const task = await responseJson(response)
    const archive = JSON.parse(gunzipSync(await readFile(path.resolve(process.cwd(), `../../../replay/viewer/tasks/${id}.json.gz`))).toString('utf8'))
    const [label,run] = Object.entries(task.runs)[0] as [string,any]
    expect(run.recorded_geometry.nodes.length).toBeGreaterThan(200)
    expect(run.recorded_geometry.frames.length).toBe(run.frames.length)
    for (const i of [0, Math.floor(run.frames.length / 2), run.frames.length - 1]) {
      expect(run.recorded_geometry.frames[i].scan).toBe(run.frames[i].k)
      expect(run.recorded_geometry.frames[i].t).toBeCloseTo(run.frames[i].time_ms / 1000, 8)
    }
    expect(run.goal).toBe(archive.runs[label].goal)
    expect(run.verdict).toBe(archive.runs[label].verdict)
    expect(run.viol).toEqual(archive.runs[label].viol)
    expect(run.frames.length).toBe(archive.runs[label].frames.length)
    expect(task.presentation_bounds.width).toBeGreaterThan(3)
    expect(run.frames[0].world.material_hard.contact.inventory).toBeDefined()
    expect(run.frames[1].world.material_hard.contact.inventory).toBeUndefined()
    expect(run.frames[0].y).toEqual(archive.runs[label].frames[0].y)
    if(id==='MAT-H06') {
      expect(run.frames[0].world.material_hard.contact.web_path.length).toBeGreaterThan(10)
      expect(run.frames[0].world.material_hard.contact.poses.dancer).toBeDefined()
    } else expect(run.frames[0].world.material_hard.contact.poses['carriage_-1.25']).toBeDefined()
  }
}, 60000)

async function responseJson(response: Response) {
  const data = Buffer.from(await response.arrayBuffer())
  return JSON.parse((response.headers.get('content-encoding') === 'gzip'
    ? gunzipSync(data) : data).toString('utf8'))
}

afterEach(async () => {
  delete process.env.PLCWORLD_GENERATED_DIR
  vi.resetModules()
  if (temporary) await rm(temporary, { recursive: true, force: true })
  temporary = ''
})

it('merges a generated MOT-E01 run into the original 3D replay catalog', async () => {
  temporary = await mkdtemp(path.join(os.tmpdir(), 'plcworld-runs-'))
  const runId = 'mot-e01-test-run'
  const runDirectory = path.join(temporary, runId)
  await mkdir(runDirectory)
  const base = JSON.parse(await readFile(path.resolve(process.cwd(), '../../../replay/viewer/catalog.json'), 'utf8'))
  const name = `My runs · ${runId} · condition 0`
  const extra = {
    schema_version: base.schema_version,
    tasks: { 'MOT-E01': { runs: { [name]: base.tasks['MOT-E01'].runs['Reference · condition 0'] } } },
  }
  await writeFile(path.join(runDirectory, 'original-replay.catalog.json'), JSON.stringify(extra))
  process.env.PLCWORLD_GENERATED_DIR = temporary
  const { GET } = await import('./route')
  const response = await GET(new Request('http://localhost/api/replay-trace'))
  expect(response.status).toBe(200)
  const catalog = await responseJson(response)
  expect(Object.keys(catalog.tasks['MOT-E01'].runs)).toContain(name)
  expect(catalog.tasks['MOT-E01'].runs[name].frames).toHaveLength(0)
  expect(catalog.tasks['MOT-E01'].replay_deferred).toBe(true)
  const full = await responseJson(await GET(new Request('http://localhost/api/replay-trace?motion_task=MOT-E01')))
  expect(full.runs[name].frames).toHaveLength(159)
})

it('merges generated runs into their own task without changing other tasks', async () => {
  temporary = await mkdtemp(path.join(os.tmpdir(), 'plcworld-runs-'))
  const runId = 'mot-e02-test-run'
  const runDirectory = path.join(temporary, runId)
  await mkdir(runDirectory)
  const base = JSON.parse(await readFile(path.resolve(process.cwd(), '../../../replay/viewer/catalog.json'), 'utf8'))
  const name = `My runs · ${runId} · condition 0`
  const extra = {
    schema_version: base.schema_version,
    tasks: { 'MOT-E02': { runs: { [name]: base.tasks['MOT-E02'].runs['Reference · condition 0'] } } },
  }
  await writeFile(path.join(runDirectory, 'original-replay.catalog.json'), JSON.stringify(extra))
  process.env.PLCWORLD_GENERATED_DIR = temporary
  const { GET } = await import('./route')
  const response = await GET(new Request('http://localhost/api/replay-trace'))
  expect(response.status).toBe(200)
  const catalog = await responseJson(response)
  expect(Object.keys(catalog.tasks['MOT-E02'].runs)).toContain(name)
  expect(Object.keys(catalog.tasks['MOT-E01'].runs)).not.toContain(name)
  expect(catalog.tasks['MOT-E02'].runs[name].frames).toHaveLength(0)
})

it('loads a full grounded-motion trace only for the selected local task', async () => {
  const { GET } = await import('./route')
  const indexResponse = await GET(new Request('http://localhost/api/replay-trace'))
  const index = await responseJson(indexResponse)
  expect(index.tasks['MOT-M06'].replay_deferred).toBe(true)
  expect(index.tasks['MOT-M06'].runs['Reference · condition 0'].frames).toHaveLength(1)

  const fullResponse = await GET(new Request('http://localhost/api/replay-trace?motion_task=MOT-M06'))
  expect(fullResponse.status).toBe(200)
  const full = await responseJson(fullResponse)
  expect(full.task).toBe('MOT-M06')
  expect(full.runs['Reference · condition 0'].frames).toHaveLength(1510)
  expect(full.runs['Reference · condition 0'].frames[0].world.motion_hard.dependency.parts.length).toBeGreaterThan(40)
})

it('loads a full Hard trace with its task-specific 3D mechanism', async () => {
  const { GET } = await import('./route')
  const response = await GET(new Request('http://localhost/api/replay-trace?motion_task=MOT-H01'))
  expect(response.status).toBe(200)
  const task = await responseJson(response)
  expect(task.task).toBe('MOT-H01')
  expect(task.runs['Reference · condition 0'].frames).toHaveLength(3219)
  const first = task.runs['Reference · condition 0'].frames[0]
  expect(first.world.motion_hard.mechanisms).toBeDefined()
  expect(first.world.motion_hard.poses).toBeDefined()
})

it('loads final Material traces under their stable renderer aliases', async () => {
  const { GET } = await import('./route')
  for (const [id, count] of [['MAT-EASY15-E01', 1600], ['MAT-V6-D03', 2600]] as const) {
    const response = await GET(new Request(`http://localhost/api/replay-trace?material_task=${id}`, {
      headers: { 'accept-encoding': 'gzip' },
    }))
    expect(response.status).toBe(200)
    expect(response.headers.get('content-encoding')).toBeNull()
    const task = await responseJson(response)
    expect(task.evaluation_task).toMatch(/^MAT-/)
    expect(task.runs['Reference · condition 0'].frames).toHaveLength(count)
    expect(task.runs['Reference · condition 0'].frames[0].world.devices).toBeDefined()
  }
})

it('loads successful Medium and Hard reference recordings', async () => {
  const { GET } = await import('./route')
  for (const [id, source] of [['MAT-M18-TAPE-R1', 'MAT-M18'], ['MAT-H01', 'MAT-H01'], ['MAT-H07', 'MAT-H07']] as const) {
    const response = await GET(new Request(`http://localhost/api/replay-trace?material_task=${id}`, {
      headers: { 'accept-encoding': 'gzip' },
    }))
    expect(response.status).toBe(200)
    expect(response.headers.get('content-encoding')).toBeNull()
    const task = await responseJson(response)
    expect(task.evaluation_task).toBe(source)
    const names = Object.keys(task.runs)
    expect(names).toHaveLength(1)
    expect(names[0]).toBe('Reference · condition 0')
    const frames = task.runs[names[0]].frames
    expect(frames.length).toBeGreaterThan(1)
    expect(task.runs[names[0]].category).toBe('reference')
    expect(task.runs[names[0]].goal).toBe(true)
    expect(task.runs[names[0]].verdict).toBe('PASS')
    expect(id === 'MAT-H07' ? frames[0].world.material_hard.poses : frames[0].world.devices).toBeDefined()
  }
}, 20000)

it('merges a generated Material run into the selected final-evaluator task', async () => {
  temporary = await mkdtemp(path.join(os.tmpdir(), 'plcworld-material-runs-'))
  const runId = 'mat-e01-test-run'
  const runDirectory = path.join(temporary, runId)
  await mkdir(runDirectory)
  const base = JSON.parse(await readFile(path.resolve(process.cwd(), '../../../replay/viewer/catalog.json'), 'utf8'))
  const id = 'MAT-EASY15-E01'
  const name = `My runs · ${runId} · condition 0`
  const extra = {
    schema_version: base.schema_version,
    tasks: { [id]: { runs: { [name]: base.tasks[id].runs['Reference · condition 0'] } } },
  }
  await writeFile(path.join(runDirectory, 'original-replay.catalog.json'), JSON.stringify(extra))
  process.env.PLCWORLD_GENERATED_DIR = temporary
  const { GET } = await import('./route')
  const response = await GET(new Request(`http://localhost/api/replay-trace?material_task=${id}`))
  expect(response.status).toBe(200)
  const task = await responseJson(response)
  expect(Object.keys(task.runs)).toContain(name)
}, 20000)


it('keeps generated deferred traces out of the index and loads all frames on selection', async () => {
  temporary = await mkdtemp(path.join(os.tmpdir(), 'plcworld-deferred-runs-'))
  const runId = 'mot-h01-test-run'
  const runDirectory = path.join(temporary, runId)
  await mkdir(runDirectory)
  const base = JSON.parse(await readFile(path.resolve(process.cwd(), '../../../replay/viewer/catalog.json'), 'utf8'))
  const name = `My runs · ${runId} · condition 0`
  const recording = base.tasks['MOT-H01'].runs['Reference · condition 0']
  const frames = Array.from({ length: 100 }, (_, k) => ({ ...recording.frames[0], k }))
  await writeFile(path.join(runDirectory, 'original-replay.catalog.json'), JSON.stringify({
    schema_version: base.schema_version,
    tasks: { 'MOT-H01': { runs: { [name]: { ...recording, frames } } } },
  }))
  await writeFile(path.join(runDirectory, 'run.json'), JSON.stringify({ task: 'MOT-H01' }))
  process.env.PLCWORLD_GENERATED_DIR = temporary
  const { GET } = await import('./route')
  const index = await responseJson(await GET(new Request('http://localhost/api/replay-trace')))
  expect(index.tasks['MOT-H01'].runs[name].frames).toHaveLength(0)
  const full = await responseJson(await GET(new Request('http://localhost/api/replay-trace?motion_task=MOT-H01')))
  expect(full.runs[name].frames).toHaveLength(100)
  expect(full.runs[name].verdict).toBe(recording.verdict)
  const other = await responseJson(await GET(new Request('http://localhost/api/replay-trace?motion_task=MOT-H02')))
  expect(other.runs[name]).toBeUndefined()
}, 20000)

it('keeps a generated Material run geometry and verdict separate from the reference', async () => {
  temporary = await mkdtemp(path.join(os.tmpdir(), 'plcworld-runs-'))
  const runId = 'mat-h07-geometry-test'
  const directory = path.join(temporary, runId)
  await mkdir(directory)
  const base = JSON.parse(await readFile(path.resolve(process.cwd(), '../../../replay/viewer/catalog.json'), 'utf8'))
  const name = `My runs · ${runId} · condition 0`
  const original = base.tasks['MAT-H07'].runs['Reference · condition 0']
  const recording = {...original, goal:false, verdict:'FAIL', recorded_geometry:{schema:'test',nodes:[],frames:[]}}
  await writeFile(path.join(directory, 'run.json'), JSON.stringify({task:'MAT-H07'}))
  await writeFile(path.join(directory, 'original-replay.catalog.json'), JSON.stringify({
    schema_version:base.schema_version,tasks:{'MAT-H07':{runs:{[name]:recording}}},
  }))
  process.env.PLCWORLD_GENERATED_DIR = temporary
  const {GET} = await import('./route')
  const index = await responseJson(await GET(new Request('http://localhost/api/replay-trace')))
  expect(index.tasks['MAT-H07'].runs[name].recorded_geometry).toBeUndefined()
  const task = await responseJson(await GET(new Request('http://localhost/api/replay-trace?material_task=MAT-H07')))
  expect(task.runs[name].recorded_geometry.schema).toBe('test')
  expect(task.runs[name].verdict).toBe('FAIL')
  expect(task.runs['Reference · condition 0'].verdict).toBe('PASS')
  expect(task.runs['Reference · condition 0'].recorded_geometry.nodes.length).toBeGreaterThan(200)
}, 60000)

it('discovers legacy runs from metadata without parsing their full recordings', async () => {
  temporary=await mkdtemp(path.join(os.tmpdir(),'plcworld-index-'))
  const id='legacy-index-test',directory=path.join(temporary,id)
  await mkdir(directory)
  await writeActual(path.join(directory,'run.json'),JSON.stringify({task:'MAT-H09',original_3d_catalog:'original-replay.catalog.json',results:[{scenario:3,replay_available:true,task_success:true,safety_violation:true}]}))
  await writeActual(path.join(directory,'original-replay.catalog.json'),'Must never be parsed for an index request')
  process.env.PLCWORLD_GENERATED_DIR=temporary
  const {GET}=await import('./route')
  const catalog=await responseJson(await GET(new Request('http://localhost/api/replay-trace')))
  const run=catalog.tasks['MAT-H09'].runs[`My runs · ${id} · condition 3`]
  expect(run.verdict).toBe('FAIL')
  expect(run.goal).toBe(true)
  expect(run.frames).toEqual([])
})
