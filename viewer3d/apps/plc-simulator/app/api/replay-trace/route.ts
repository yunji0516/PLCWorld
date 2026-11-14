import { readFile, readdir } from 'node:fs/promises'
import path from 'node:path'
import { gunzipSync } from 'node:zlib'
import { REPLAY_RENDERER_HEADER, REPLAY_RENDERER_REVISION } from '@/lib/replay/rendererRevision'

export const dynamic = 'force-dynamic'

const catalogPath = path.resolve(process.cwd(), '../../../replay/viewer/catalog.json')
const sidecarPath = path.resolve(process.cwd(), '../../../replay/viewer/tasks')
const geometryPath = path.resolve(process.cwd(), '../../../replay/viewer/geometry')
const presentationPath = path.resolve(process.cwd(), '../../../replay/viewer/presentation')
const generatedPath = process.env.PLCWORLD_GENERATED_DIR
  ? path.resolve(process.env.PLCWORLD_GENERATED_DIR)
  : path.resolve(process.cwd(), '../../../outputs/generated')

// Let the HTTP server negotiate compression. Route-handler Content-Encoding
// headers are filtered by Next.js, so returning precompressed bytes is unsafe.
function replayJson(value: unknown): Response {
  return Response.json(value, { headers: {
    'cache-control': 'no-store',
    [REPLAY_RENDERER_HEADER]: REPLAY_RENDERER_REVISION,
  } })
}

export async function GET(request: Request) {
  const query = new URL(request.url).searchParams
  if (query.has('hard_task') || query.has('motion_hard_task')) {
    return Response.json({ error: 'This task is not in the local demo catalog.' }, { status: 404 })
  }
  try {
    const catalog = JSON.parse(await readFile(catalogPath, 'utf8'))
    const requested = query.get('motion_task') ?? query.get('material_task')
    let selectedCompressed: Buffer | undefined
    if (requested !== null) {
      if (!/^(?:MOT-[A-Z][0-9]{2}|MAT-(?:EASY15-E[0-9]{2}|V[0-9]-D[0-9]{2}|M18-TAPE-R1|H(?:0[1-9]|1[0-5])))$/.test(requested)
          || !catalog.tasks[requested]) {
        return Response.json({ error: 'This task has no local full replay.' }, { status: 404 })
      }
      if (catalog.tasks[requested].replay_deferred) selectedCompressed = await readFile(path.join(sidecarPath, `${requested}.json.gz`))
    }
    // Generated run catalogs are written only after the sealed evaluator and
    // adapter have checked their ST and trace hashes. The viewer reads them.
    const entries = await readdir(generatedPath, { withFileTypes: true }).catch(() => [])
    const needsContact = requested !== null && /^MAT-H(?:0[2-6]|0[89]|1[0-5])$/.test(requested)
    if (requested !== null && selectedCompressed) {
      catalog.tasks[requested] = JSON.parse(gunzipSync(selectedCompressed).toString('utf8'))
      if (needsContact) {
        const contact = JSON.parse(gunzipSync(await readFile(path.join(presentationPath, `${requested}.json.gz`))).toString('utf8'))
        const run = catalog.tasks[requested].runs[contact.label]
        catalog.tasks[requested].presentation_bounds = contact.bounds
        if (!run || run.frames.length !== contact.frames.length) throw new Error('Contact projection length mismatch')
        for (let i = 0; i < run.frames.length; i++) {
          const state = run.frames[i].world?.material_hard
          if (!state) throw new Error('Missing recorded material state')
          state.contact = i === 0 ? { ...contact.frames[i], inventory: contact.inventory } : contact.frames[i]
        }
      }
    }
    if (requested !== null && /^MAT-H(?:0[2-9]|1[0-5])$/.test(requested)) {
      const geometry = JSON.parse(gunzipSync(await readFile(path.join(geometryPath, `${requested}.json.gz`))).toString('utf8'))
      const run = catalog.tasks[requested].runs[geometry.label]
      if (!run || run.frames.length !== geometry.frames.length
          || geometry.frames.some((frame: {scan:number;t:number}, i:number) => frame.scan !== run.frames[i].k || Math.abs(frame.t * 1000 - run.frames[i].time_ms) > 0.001)) {
        throw new Error('Recorded geometry does not match the replay scans')
      }
      run.recorded_geometry = geometry
    }
    for (const entry of entries) {
      if (!entry.isDirectory() || !/^[a-z0-9-]{1,100}$/.test(entry.name)) continue
      try {
        const directory = path.join(generatedPath, entry.name)
        const manifest = await readFile(path.join(directory, 'run.json'), 'utf8')
          .then(text => JSON.parse(text)).catch(() => null)
        if (requested !== null && manifest?.task && manifest.task !== requested
            && manifest.task !== catalog.tasks[requested].evaluation_task) continue
        let extra
        if (requested === null) {
          extra = await readFile(path.join(directory, 'original-replay.index.json'), 'utf8')
            .then(text => JSON.parse(text)).catch(() => null)
          // Older generated runs already have compact evaluator summaries.
          // Discover them without opening their full replay catalogs.
          if (!extra && manifest?.original_3d_catalog === 'original-replay.catalog.json') {
            const taskId = Object.keys(catalog.tasks).find(id => id === manifest.task || catalog.tasks[id].evaluation_task === manifest.task)
            if (taskId) {
              const runs: Record<string, unknown> = {}
              for (const result of manifest.results ?? []) {
                if (!result.replay_available) continue
                const label = `My runs · ${entry.name} · condition ${result.scenario}`
                runs[label] = {label,category:'generated',model:manifest.model,
                  goal:result.task_success,verdict:result.task_success && !result.safety_violation ? 'PASS' : 'FAIL',
                  reason:'Final evaluator result',frames:[],il:'',viol:[]}
              }
              extra = {schema_version:catalog.schema_version,tasks:{[taskId]:{runs}}}
            }
          }
          if (!extra) continue
        } else {
          extra = JSON.parse(await readFile(path.join(directory, 'original-replay.catalog.json'), 'utf8'))
        }
        if (extra.schema_version !== catalog.schema_version || !extra.tasks) continue
        for (const [taskId, task] of Object.entries(extra.tasks) as [string, { runs?: Record<string, unknown> }][]) {
          if (!catalog.tasks[taskId] || (requested !== null && taskId !== requested)) continue
          for (const [name, run] of Object.entries(task.runs ?? {})) {
            if (!name.startsWith(`My runs · ${entry.name} ·`)) continue
            // The index exposes run names and verdicts, but deferred tasks load
            // their frames only when selected, just like archived recordings.
            const recording = run as { frames?: unknown[] }
            catalog.tasks[taskId].runs[name] = requested === null
              ? { ...recording, recorded_geometry: undefined, frames: [] }
              : run
            if (requested === null) catalog.tasks[taskId].replay_deferred = true
          }
        }
      } catch {
        // Ignore incomplete or invalid generated-run catalogs.
      }
    }
    return replayJson(requested === null ? catalog : catalog.tasks[requested])
  } catch {
    return Response.json({ error: 'Local replay catalog is unavailable.' }, { status: 404 })
  }
}
