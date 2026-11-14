'use client'

import { failureFrameIndex } from './replayPresentation'
import { ReplayToolbar } from './ReplayToolbar'
import { ReplayStatusPanel } from './ReplayStatusPanel'
import { ReplayRunPanel } from './ReplayRunPanel'
import { ReplaySelectionContext, type ReplaySelection, type ReplayEquipment } from './ReplaySelection'

import { ReplayMachinePanel } from './ReplayMachinePanel'
import { withCatalogAdmission } from './taskAdmission'
import { ReplayNavigation } from './ReplayNavigation'
import { HARD_PROCESS_FAMILY, STATION_PROCESS_FAMILY, withHardProcessModels } from './hardProcessCatalog'
import MaterialHardProcess from './MaterialHardProcess'
import {recordedGeometryFrames} from '@/lib/replay/recordedGeometry'
import StationReplayScene from './StationReplayScene'
import type { Review } from './hard-processes/ReviewCanvas'
import { MaterialHardPriorityPanel, MATERIAL_PRIORITY_REASONS } from './MaterialHardPriorityPanel'
import dynamic from 'next/dynamic'
import { REPLAY_RENDERER_HEADER, replayRendererMatches } from '@/lib/replay/rendererRevision'
import { useCallback, useEffect, useMemo, useRef, useState, type CSSProperties } from 'react'
import { PanelLeftClose, PanelLeftOpen } from 'lucide-react'
import { SceneBoundary } from '@/components/scene/SceneBoundary'
import { ReplaySceneRecovery } from './ReplaySceneRecovery'
import { SceneDiagnostics } from './SceneDiagnostics'
import type { CameraView } from '@/components/scene/Scene3D'
import { TracePlant, toReplayMachine, type Trace, type TraceBundle, type TraceTask, type Frame } from '@/lib/replay/adapter'
import styles from './replay.module.css'
import { MATERIAL_MEDIUM20, materialDisplayId, materialInternalId } from './materialCatalog'
import { motionDisplayId, motionInternalId } from './motionCatalog'
import { withActiveMotionReplay, withActiveMaterialReplay } from './motionReplayCache'
import { PUBLISHED_CANDIDATE_ALIASES } from './replayCatalog'
import { ResizeHandle } from './ResizeHandle'
import { SignalTimeline } from './SignalTimeline'
import { TendingQualityPanel } from './TendingQualityPanel'
import { PrecisionPanel } from './PrecisionPanel'
import { MotionEasyPanel, MOTION_EASY_REASONS } from './MotionEasyPanel'
import { MotionEasyUnitPanel, MOTION_UNIT_REASONS } from './MotionEasyUnitPanel'
import { MotionHardPanel, MOTION_HARD_REASONS, MOTION_DEPENDENCY_REASONS } from './MotionHardPanel'
import { ArtifactMotionHardPanel } from './ArtifactMotionHardPanel'
import { MotionMediumPanel, MOTION_MEDIUM_REASONS } from './MotionMediumPanel'
import { ArtifactMotionMediumPanel } from './ArtifactMotionMediumPanel'
import { MaterialV8Readout } from './MaterialV8Readout'
import { MaterialEasyReadout } from './MaterialEasyReadout'
import { MaterialV7Readout } from './MaterialV7Readout'
import { MaterialV6Readout } from './MaterialV6Readout'
import { precisionReason } from './precisionLabels'
import { latestReplayEvent } from './eventHistory'
import { clampSize, fitPanelWidths, MIN_SCENE_WIDTH, signalHeightLimit } from './panelSizing'
import { taskObjective } from './objective'

const Scene3D = dynamic(() => import('@/components/scene/Scene3D'), {
  ssr: false,
  loading: () => <div className="grid h-full place-items-center text-xs text-text-subtle">Loading 3D scene…</div>,
})

// API data and the loaded 3D code must belong to the same renderer release.
function ensureReplayRenderer(response: Response) {
  const server = response.headers.get(REPLAY_RENDERER_HEADER)
  if (replayRendererMatches(server)) return
  const key = `plc-renderer-reload:${server}`
  if (sessionStorage.getItem(key) !== '1') {
    sessionStorage.setItem(key, '1')
    const url = new URL(window.location.href)
    url.searchParams.set('renderer', server!)
    window.location.replace(url.href)
  }
  throw new Error('The 3D renderer has changed. Reloading the page; refresh manually if this persists.')
}


const REASON_LABELS: Record<string, string> = {
  passed: 'Objective achieved; no safety violation',
}

const SUITE_NAMES: Record<string, string> = {
  motion: 'Motion',
  material: 'Material',
}

const DIFFICULTY_NAMES: Record<string, string> = {
  easy: 'Easy',
  medium: 'Medium',
  hard: 'Hard',
}

const DIFFICULTY_ORDER = ['easy', 'medium', 'hard']
const SUITE_ORDER = ['motion', 'material'] as const

function runLabel(name: string): string {
  return name
    .replace(' · I1 · ', ' · physical handoff · ')
    .replace(' · I0 · ', ' · immediate-command handoff · ')
}

function modelLabel(model?: string): string {
  if (!model) return ''
  if (model.startsWith('synthetic-material-stations-v7-')) return 'v7 mini-process · closed-loop ST'
  if (model.startsWith('synthetic-inter-task-priority-v5-')) {
    const modes: Record<string, string> = {
      index: 'Shared indexing, operation, and physical outfeed',
      web: 'Feed, pull, and stored-web conservation',
      vacuum: 'Shared vacuum and physical support transfer',
      stack: 'Order ownership, layer sequence, and physical seating',
    }
    return modes[model.replace('synthetic-inter-task-priority-v5-', '')] ?? 'Independent tasks with physical material handoff'
  }
  return model.replaceAll('-', ' ')
}

function ownerLabel(owner?: string | null): string {
  const labels: Record<string, string> = {
    fixture: 'Fixture', source_fixture: 'Source fixture', target_fixture: 'Target fixture',
    transport: 'Transport', tool: 'Tool', gripper: 'Gripper', vacuum: 'Vacuum pickup',
    carrier: 'Carrier', base: 'Lift base', floor: 'Floor',
    stage1: 'First device', transfer_fixture: 'Transfer fixture', stage2: 'Second device',
    magazine: 'Magazine', separator: 'Separator', receiver_fixture: 'Receiving fixture',
    index_table: 'Index table',
  }
  return owner ? (labels[owner] ?? owner) : 'none'
}

export default function ReplayPage() {
  const [trace, setTrace] = useState<Trace | null>(null)
  const [stationReview, setStationReview] = useState<(Review & {trace:TraceTask}) | null>(null)
  const [defaultScanMs, setDefaultScanMs] = useState(10)
  const [error, setError] = useState('')
  const [tid, setTid] = useState('')
  const [run, setRun] = useState('')
  const [k, setK] = useState(0)
  const [playing, setPlaying] = useState(false)
  const [fullScans, setFullScans] = useState(false)
  useEffect(() => { setFullScans(false) }, [tid, run])
  const [playbackRate, setPlaybackRate] = useState(1)
  const [sel, setSel] = useState<string | null>(null)
  const [rightTab, setRightTab] = useState<'machine' | 'io' | 'result'>('machine')
  const [activeSuite, setActiveSuite] = useState<string>('material')
  // Hide labels by default in crowded Hard scenes. They can be enabled from the toolbar.
  const [showSceneLabels, setShowSceneLabels] = useState(false)
  const [cameraView, setCameraView] = useState<CameraView>('front')
  const [activeCameraView, setActiveCameraView] = useState<CameraView | null>('iso')
  const [cameraResetKey, setCameraResetKey] = useState(0)
  const [sceneReloadKey, setSceneReloadKey] = useState(0)
  const pausePlayback = useCallback(() => setPlaying(false), [])
  const onCameraInteraction = useCallback(() => setActiveCameraView(null), [])
  const [codeOpen, setCodeOpen] = useState(true)
  const [compact, setCompact] = useState(false)
  const [mobilePanel, setMobilePanel] = useState<'code' | null>(null)
  const [timelineOpen, setTimelineOpen] = useState(true)
  const [statusOpen, setStatusOpen] = useState(false)
  const [selectionInfo,setSelectionInfo]=useState<ReplaySelection|null>(null)
  const [equipment,setEquipment]=useState<ReplayEquipment[]>([])
  useEffect(()=>{if(selectionInfo)setStatusOpen(true)},[selectionInfo])
  const [codeWidth, setCodeWidth] = useState<number | null>(null)
  const [detailsWidth, setDetailsWidth] = useState<number | null>(null)
  const [signalHeight, setSignalHeight] = useState<number | null>(null)
  const [layoutSize, setLayoutSize] = useState({ width: 1440, height: 800, toolbar: 40, playback: 50, viewportHeight: 900 })
  const workspaceRef = useRef<HTMLDivElement>(null)
  const toolbarRef = useRef<HTMLDivElement>(null)
  const playbackRef = useRef<HTMLDivElement>(null)
  const sceneCodeToggle = useRef<HTMLButtonElement>(null)
  const codePanel = useRef<HTMLElement>(null)
  const detailsPanel = useRef<HTMLElement>(null)
  const codeVisible = compact ? mobilePanel === 'code' : codeOpen
  const detailsVisible = !compact
  const widths = fitPanelWidths(layoutSize.width, codeWidth, detailsWidth, codeVisible, detailsVisible)
  const maxSignalHeight = signalHeightLimit(layoutSize.height, layoutSize.toolbar, layoutSize.playback)
  const defaultSignalHeight = layoutSize.viewportHeight <= 540 ? 60
    : compact && layoutSize.width <= 700 ? clampSize(layoutSize.viewportHeight * .16, 65, 130)
      : clampSize(layoutSize.viewportHeight * .2, 80, 190)
  const shownSignalHeight = clampSize(signalHeight ?? defaultSignalHeight, 40, maxSignalHeight)
  const closePanel = useCallback(() => {
    setMobilePanel(null)
    sceneCodeToggle.current?.focus()
  }, [])

  useEffect(() => {
    const media = window.matchMedia('(max-width: 1099px)')
    const update = () => { setCompact(media.matches); setMobilePanel(null) }
    update()
    media.addEventListener('change', update)
    return () => media.removeEventListener('change', update)
  }, [])

  useEffect(() => {
    if (!trace || !workspaceRef.current) return
    const measure = () => setLayoutSize({
      width: workspaceRef.current?.clientWidth ?? 1440,
      height: workspaceRef.current?.clientHeight ?? 800,
      toolbar: toolbarRef.current?.offsetHeight ?? 40,
      playback: playbackRef.current?.offsetHeight ?? 50,
      viewportHeight: window.innerHeight,
    })
    const observer = new ResizeObserver(measure)
    for (const element of [workspaceRef.current, toolbarRef.current, playbackRef.current]) {
      if (element) observer.observe(element)
    }
    measure()
    return () => observer.disconnect()
  }, [trace])

  useEffect(() => {
    if (!compact || !mobilePanel) return
    const panel = codePanel.current
    panel?.focus()
    const keydown = (event: KeyboardEvent) => {
      if (event.key === 'Escape') { event.preventDefault(); closePanel() }
      if (event.key !== 'Tab' || !panel) return
      const elements = [sceneCodeToggle.current, ...Array.from(panel.querySelectorAll<HTMLElement>(
        'button:not(:disabled), select, input, a[href], summary, [tabindex="0"]',
      ))].filter((element): element is HTMLElement => !!element && element.getClientRects().length > 0)
      const first = elements[0], last = elements[elements.length - 1]
      if (!first) { event.preventDefault(); return }
      if (event.shiftKey && (document.activeElement === first || document.activeElement === panel)) {
        event.preventDefault(); last.focus()
      } else if (!event.shiftKey && (document.activeElement === last || document.activeElement === panel)) {
        event.preventDefault(); first.focus()
      }
    }
    document.addEventListener('keydown', keydown)
    return () => document.removeEventListener('keydown', keydown)
  }, [compact, mobilePanel, closePanel])

  useEffect(() => {
    const requestedCandidate = new URLSearchParams(window.location.search).get('candidate')
    const load = async (endpoint: string) => {
        const r = await fetch(endpoint, { cache: 'no-store' })
        if (!r.ok) throw new Error((await r.json()).error ?? 'Could not read the replay trace.')
        ensureReplayRenderer(r)
        return r.json() as Promise<TraceBundle>
    }
    // The viewer always keeps the full catalogue when showing the Material
    // revision. An old candidate link must not hide Motion or other levels.
    const bundlePromise = !requestedCandidate || PUBLISHED_CANDIDATE_ALIASES.includes(requestedCandidate)
      ? load('/api/replay-trace')
      : load(`/api/replay-trace?candidate=${encodeURIComponent(requestedCandidate)}`)
    bundlePromise
      .then((bundle) => {
        if (bundle.schema_version !== 'canonical-replay-trace/0.2') {
          throw new Error(`Unsupported trace format: ${bundle.schema_version}`)
        }
        const t = withCatalogAdmission(withHardProcessModels(Object.fromEntries(Object.entries(bundle.tasks).filter(([id, task]) =>
          task.suite !== 'material' || task.difficulty !== 'medium' || id in MATERIAL_MEDIUM20 || (requestedCandidate === 'material-m18-tape' && id === 'MAT-M18-TAPE-R1')))))
        const params = new URLSearchParams(window.location.search)
        const requestedTask = motionInternalId(materialInternalId(params.get('task')))
        const first = requestedTask && t[requestedTask] ? requestedTask
          : Object.keys(MATERIAL_MEDIUM20).find(id => id in t) ?? Object.keys(t)[0]
        if (!first) throw new Error('No task is available for replay.')
        const runNames = Object.keys(t[first].runs)
        const requestedRun = params.get('run')
        const selectedRun = requestedRun
          ? (runNames.find((name) => name.includes(requestedRun)) ?? runNames[0])
          : runNames[0]
        setTrace(t)
        setDefaultScanMs(bundle.scan_ms)
        setTid(first)
        setRun(selectedRun ?? '')
        const requestedScan = Number(params.get('scan'))
        if (Number.isFinite(requestedScan) && requestedScan >= 0) setK(Math.floor(requestedScan))
        setShowSceneLabels(params.get('labels') === '1' || (params.get('labels') !== '0' && ['MOT-E02', 'MOT-E05'].includes(first)))
        const requestedView = params.get('view')
        if (requestedView === 'front' || requestedView === 'side' || requestedView === 'top') {
          setCameraView(requestedView)
          setActiveCameraView(requestedView)
        }
        setActiveSuite(t[first].suite ?? 'material')
        if (t[first].suite === 'motion' || (requestedCandidate && PUBLISHED_CANDIDATE_ALIASES.includes(requestedCandidate))) {
          params.set('task', motionDisplayId(materialDisplayId(first)))
          if (PUBLISHED_CANDIDATE_ALIASES.includes(requestedCandidate ?? '') || (requestedCandidate !== 'motion-grounded-v3' && requestedCandidate !== 'motion-grounded-v4' && requestedCandidate !== 'motion-grounded-v5' && requestedCandidate !== 'motion-grounded-v6' && requestedCandidate !== 'motion-grounded-v7')) params.delete('candidate')
          window.history.replaceState(null, '', `${window.location.pathname}?${params}`)
        }
      })
      .catch((e: unknown) => setError(e instanceof Error ? e.message : 'Could not read the replay trace.'))
  }, [])

  const task = trace && tid ? trace[tid] : null
  const scanMs = task?.scan_ms ?? defaultScanMs
  useEffect(() => {
    if (task?.family !== STATION_PROCESS_FAMILY || stationReview?.id === tid.replace('MAT-','')) return
    const controller = new AbortController()
    fetch(`/replay/hard-processes/data?task=${tid.replace('MAT-','')}`, {cache:'no-store',signal:controller.signal})
      .then(async response => {
        if (!response.ok) throw new Error('Could not read the ST execution and machinery trace.')
        const review = await response.json() as Review & {trace:TraceTask}
        if (controller.signal.aborted) return
        if (!review.trace?.runs.normal) throw new Error('The shared replay trace is not ready.')
        setStationReview(review)
        setTrace(previous => previous ? {...previous,[tid]:review.trace} : previous)
        const params=new URLSearchParams(window.location.search), requested=params.get('run')
        const selected=requested && review.trace.runs[requested] ? requested : 'normal'
        setRun(selected)
        const scan=Number(params.get('scan') || 0),frames=review.trace.runs[selected].frames
        const found=frames.findIndex(frame=>frame.k>=scan)
        setK(found<0?frames.length-1:found)
      }).catch(e=>{if(!controller.signal.aborted)setError(e instanceof Error?e.message:'ST Could not read the replay trace.')})
    return ()=>controller.abort()
  },[tid,task?.family,stationReview?.id])
  useEffect(() => {
    if (!task?.replay_deferred || !tid || task.family === HARD_PROCESS_FAMILY || task.family === STATION_PROCESS_FAMILY) return
    const controller = new AbortController()
    fetch(`/api/replay-trace?${task.suite==='material'?'material_task':task.suite==='motion'?'motion_task':'hard_task'}=${encodeURIComponent(tid)}${task.evaluation_release==='motion-medium-release/1.0'?'':task.replay_candidate==='motion-grounded-v7'?'&candidate=motion-grounded-v7':task.task_version==='motion-medium-grounded-v6-dev'?'&candidate=motion-grounded-v6':task.task_version==='motion-medium-grounded-v5-dev'?'&candidate=motion-grounded-v5':task.task_version==='motion-medium-grounded-v4-dev'?'&candidate=motion-grounded-v4':task.task_version==='motion-medium-grounded-v3-dev'?'&candidate=motion-grounded-v3':task.family==='material_redesign_r8'?'&candidate=material-hard-redesign':task.family==='material_flowcells_r9'?'&candidate=material-flowcells':''}`,{cache:'no-store',signal:controller.signal})
      .then(async response => {
        if (!response.ok) throw new Error('Could not load the replay trace.')
        ensureReplayRenderer(response)
        const full = await response.json() as TraceTask
        if (controller.signal.aborted) return
        setTrace(previous => previous ? (full.suite === 'material' ? withActiveMaterialReplay(previous,tid,full) : withActiveMotionReplay(previous,tid,full)) : previous)
      })
      .catch(e => {if (!controller.signal.aborted) setError(e instanceof Error?e.message:'Could not load the replay trace.')})
    return () => controller.abort()
  },[tid,task?.replay_deferred])
  const cur = task && run ? task.runs[run] : null
  const recordedReview = useMemo<Review | null>(() => {
    const geometry = cur?.recorded_geometry
    if (!geometry || !task) return null
    const frames = recordedGeometryFrames(geometry)
    return {id:tid.replace('MAT-',''), title:task.title, primary:run, nodes:geometry.nodes,
      scope:'Recorded plant geometry', benchmark_accepted:false, geometry_revision:geometry.schema,
      runs:{[run]:{nodes:geometry.nodes, frames, events:[], failure:null,
        duration:geometry.frames.at(-1)?.t ?? 0, received:[]}}}
  }, [cur, task, tid, run])
  const sceneReview = recordedReview ?? stationReview
  const displayTask = useMemo(() => task && cur?.recorded_geometry ? {...task,
    devices:cur.recorded_geometry.devices.map(device=>({...task.devices.find(item=>item.id===device.id),...device}))} : task, [task,cur])
  useEffect(() => { if (recordedReview) setEquipment([]) }, [recordedReview])
  const machine = useMemo(() => {
    if (!trace || !tid || task?.family === HARD_PROCESS_FAMILY) return null
    return toReplayMachine(trace, tid, cur?.recorded_geometry?.devices)
  }, [trace, tid, task, cur])
  const plant = useMemo(
    () => (machine && task && cur?.frames.length ? new TracePlant(machine, task.devices, cur.frames) : null),
    [machine, task, cur],
  )
  if (plant) plant.setFrame(k)

  const fullTotal = cur?.frames.length ?? 1
  const shortEnd = cur?.playback_end_index
  const canShorten = Number.isInteger(shortEnd) && (shortEnd ?? -1) >= 0 && (shortEnd ?? fullTotal) < fullTotal - 1
  const total = !fullScans && canShorten ? (shortEnd ?? fullTotal - 1) + 1 : fullTotal
  const displayedFrames = useMemo(() => cur?.frames.slice(0,total) ?? [], [cur,total])
  useEffect(() => {
    // Preserve deep links or explicit seeks into the retained observation tail.
    if (!task?.replay_deferred && canShorten && k >= total) setFullScans(true)
  }, [task?.replay_deferred, canShorten, k, total])
  useEffect(() => {
    if (!playing) return
    if ((task?.family?.startsWith('coordination_hard15_') || task?.family === 'motion_hard15' || task?.family === STATION_PROCESS_FAMILY) && cur) {
      const start = performance.now(), initial = Math.min(k, total-1)
      let index = initial
      const firstScan = cur.frames[initial].k
      const timer = setInterval(() => {
        const scan = firstScan + (performance.now()-start)*playbackRate/scanMs
        while(index < total-1 && cur.frames[index+1].k <= scan) index++
        setK(index)
      }, 16)
      return () => clearInterval(timer)
    }
    // Preserve the existing common presentation until a shared timing policy
    // is agreed. Do not give M08 a different meaning of 1x playback.
    const baseInterval = Math.max(30, Math.min(150, 8000 / total))
    const timer = setInterval(() => setK(v => Math.min(v + 1, total - 1)), baseInterval / playbackRate)
    return () => clearInterval(timer)
  }, [playing, playbackRate, total, tid, run, scanMs])

  useEffect(() => {
    if (k >= total - 1) setPlaying(false)
  }, [k, total])

  const pick = useCallback((id: string) => {
    setCameraView('front');setActiveCameraView('front');setCameraResetKey(key=>key+1)
    if (!trace) return
    setTid(id)
    setRun(Object.keys(trace[id].runs)[0] ?? '')
    setK(0)
    setPlaying(false)
    setSel(null)
    setSelectionInfo(null)
    setActiveSuite(trace[id].suite ?? 'other')
    const params = new URLSearchParams(window.location.search)
    params.set('task', motionDisplayId(materialDisplayId(id)))
    if (PUBLISHED_CANDIDATE_ALIASES.includes(params.get('candidate') ?? '')) {
      params.delete('candidate')
    }
    params.delete('run')
    params.delete('scan')
    params.delete('view')
    window.history.replaceState(null, '', `${window.location.pathname}?${params}`)
  }, [trace])

  if (error) return <div className="grid h-screen place-items-center text-sm text-danger">{error}</div>
  if (trace && task?.family === HARD_PROCESS_FAMILY) return <div className={styles.root}>
    <ReplayNavigation trace={trace} tid={tid} suite={activeSuite} pick={pick} setSuite={setActiveSuite}/>
    <MaterialHardProcess key={tid} id={tid.replace('MAT-','')}/>
  </div>
  if (!trace || !task || !cur || !machine || !plant || (task.family === STATION_PROCESS_FAMILY && stationReview?.id !== tid.replace('MAT-',''))) {
    return <div className="grid h-screen place-items-center text-sm text-text-muted">Loading replay trace…</div>
  }

  const frame = cur.frames[Math.min(k, cur.frames.length - 1)]
  const geometryFrame = recordedReview?.runs[run]?.frames[Math.min(k, cur.frames.length - 1)]
  const inspectorFrame = geometryFrame && frame.world ? {...frame, world:{...frame.world,
    devices:{...frame.world.devices, ...Object.fromEntries(Object.entries(geometryFrame.poses).map(([id,pose])=>[id,{pos:pose.p}]))}}} : frame
  const fail = cur.viol.length > 0 || !cur.goal
  const actualScan = (index:number) => task.family?.startsWith('coordination_hard15_') || task.family === 'motion_hard15' || task.family === STATION_PROCESS_FAMILY ? (cur.frames[Math.max(0,Math.min(index,total-1))]?.k ?? index) : index
  const reasonLabel = (name: string) => task.evaluation_release === 'plcworld-evaluation/5.2.6' ? (name === 'passed' ? 'Objective achieved; no safety violation' : name.replaceAll('_', ' ')) : frame.world?.motion_hard?.dependency ? (MOTION_DEPENDENCY_REASONS[name] ?? name) : task.family === STATION_PROCESS_FAMILY ? (MATERIAL_PRIORITY_REASONS[name] ?? REASON_LABELS[name] ?? name) : (task.task_version === '5.1-priority' || task.task_version === '6.0-miniprocess') ? (MATERIAL_PRIORITY_REASONS[name] ?? name) : task.family === 'motion_hard15' ? (MOTION_HARD_REASONS[name] ?? name) : task.family === 'motion_easy_unit' ? (MOTION_UNIT_REASONS[name] ?? name) : task.family === 'motion_medium_core' ? (MOTION_MEDIUM_REASONS[name] ?? name) : task.family === 'motion_easy_function' ? (MOTION_EASY_REASONS[name] ?? name) : task.family === 'motion_precision_cell' ? precisionReason(name) : (REASON_LABELS[name] ?? name)
  const why = task.evaluation_release === 'plcworld-evaluation/5.2.6'
    ? (fail ? (cur.viol.length ? [...new Set(cur.viol.map(v => reasonLabel(v.name)))].join(' · ') : 'Objective not reached') : 'Objective reached; no safety violation')
    : task.family === 'motion_easy_unit'
    ? (fail ? (cur.viol.length ? [...new Set(cur.viol.map(v => v.name.replaceAll('_', ' ')))].join(' · ') : 'Objective not reached') : 'Objective reached; no safety violation')
    : REASON_LABELS[cur.reason ?? ''] ?? (fail
      ? (cur.viol.length ? [...new Set(cur.viol.map((v) => reasonLabel(v.name)))].join(' · ') : 'Objective not reached')
      : REASON_LABELS.passed)
  const suite = activeSuite
  const difficulty = task.difficulty ?? 'easy'
  const suiteNames = SUITE_ORDER
  const difficultyNames = DIFFICULTY_ORDER.filter((level) =>
    Object.values(trace).some((item) => (item.suite ?? 'other') === suite && (item.difficulty ?? 'easy') === level),
  )
  const visibleTaskIds = Object.keys(trace).filter((id) =>
    (trace[id].suite ?? 'other') === suite && (trace[id].difficulty ?? 'easy') === difficulty,
  ).sort((a,b) => suite === 'material' ? materialDisplayId(a).localeCompare(materialDisplayId(b), undefined, { numeric: true }) : 0)
  const firstViolationScan = cur.viol[0]?.k
  const completionOutput = task.completion_output ?? 'Y2'
  const completionLabel = frame.world?.motion_hard?.dependency ? 'All work complete' : task.family === 'motion_hard15' ? 'All requests complete' : ['speed', 'gear', 'tracking', 'orientation', 'balance'].includes(frame.world?.motion_easy_unit?.mode ?? '')
    ? 'Function ready' : frame.world?.motion_easy?.mode === 'speed' ? 'Speed ready' : 'Completion output'
  const completionScan = cur.frames.findIndex((fr) => !!fr.y[completionOutput])
  // Locator-home starts ON; it is not the physical completion of this episode.
  const isPalletLocate = task.family === 'pallet_lift_and_locate'
  const processFeedback: Record<string, string> = { process_replenish: 'X22', process_zone: 'X23', process_batch: 'X26', process_pace: 'X22', diverse_index: 'X26', diverse_elevator: 'X23', diverse_turnover: 'X26', diverse_press: 'X24', diverse_drill: 'X29' }
  const isTending = task.family === 'shared_dual_machine_tending'
  // The open endpoint is initially ON; local acquisition completes on contact-qualified grip feedback.
  const isLocalRobotAcquire = task.family === 'robot_local_acquire'
  const palletSeatingFeedback = task.devices.some(d=>d.visual_variant==='material-pallet-rack')
    ? Object.entries(task.io).find(([, label])=>label.startsWith('Short descent complete; pallet seated'))?.[0] : undefined
  const primaryFeedback = task.family === 'motion_hard15' || task.family?.startsWith('coordination_hard15_') || (task.task_version === '5.0-portfolio' || (task.task_version?.startsWith('6.') || task.task_version?.startsWith('7.') || task.task_version?.startsWith('8.') || task.task_version?.startsWith('13.') || task.task_version?.startsWith('17.'))) || task.family === 'motion_precision_cell' || task.family === 'motion_easy_function' || task.family === 'motion_easy_unit' || task.family === 'motion_medium_core' ? undefined
    : isTending ? Object.entries(task.io).find(([,label])=>label==='all delivered')?.[0]
    : isLocalRobotAcquire ? 'X13' : palletSeatingFeedback ?? processFeedback[task.family ?? ''] ?? (isPalletLocate ? 'X27' : task.devices.find((device) => device.at_max)?.at_max)
  const feedbackLabel = isTending ? 'Four workpieces received' : isLocalRobotAcquire ? 'Grip confirmed' : palletSeatingFeedback ? 'Pallet seating confirmed' : task.family?.startsWith('diverse_') ? 'Result feedback' : processFeedback[task.family ?? ''] ? 'Receipt feedback' : isPalletLocate ? 'Exit detected' : 'Physical completion'
  const feedbackScan = primaryFeedback
    ? cur.frames.findIndex((fr) => !!fr.x[primaryFeedback])
    : -1
  const finalHolder = tid === 'E1' ? 'GRIPPER_B'
    : tid === 'E2' ? 'PRODUCT_GRIPPER'
      : tid === 'MAT-M01' ? 'GRIPPER_A'
        : tid === 'MAT-M02' ? 'RECEIVER_GRIPPER'
          : null
  const transferScan = cur.frames.findIndex((fr) => Object.values(fr.world?.parts ?? {}).some((p) =>
    finalHolder ? p.held_by === finalHolder : p.status === 'held',
  ))
  const eventScan = cur.frames.findIndex((fr) => (fr.world?.events?.length ?? 0) > 0)
  const focusScan = cur.viol[0]?.k
    ?? (transferScan >= 0 ? transferScan : eventScan >= 0 ? eventScan : completionScan >= 0 ? completionScan : 0)
  const devicePositions = Object.entries(frame.s).filter(([id]) =>
    task.devices.find((device) => device.id === id)?.kind !== 'static',
  )
  const part = Object.entries(frame.world?.parts ?? {})[0]
  const prematureCompletion = tid === 'E0' && !!frame.y.Y2 && !frame.x.X1
  const currentViolation = (
    firstViolationScan !== undefined && frame.k >= firstViolationScan
  ) || prematureCompletion
  const latestEvent = latestReplayEvent(cur.frames, k)
  const statusMessage = currentViolation ? `Failure: ${why}`
    : latestEvent
      ? `Event: ${latestEvent.events.map(event => event === 'workpiece_transferred' ? 'Workpiece transferred' : event.replaceAll('_', ' ')).join(' · ')} · scan ${actualScan(latestEvent.scan)}${latestEvent.scan < k ? ' · latest event' : ''}`
      : 'No events yet'

  return (
    <ReplaySelectionContext.Provider value={{selection:selectionInfo,setSelection:setSelectionInfo,equipment,setEquipment}}><div className={styles.root}>
      <ReplayNavigation trace={trace} tid={tid} suite={activeSuite} pick={pick} setSuite={setActiveSuite}/>

      {visibleTaskIds.length === 0 ? (
        <div className="grid flex-1 place-items-center bg-surface-1">
          <div className="rounded-lg border border-border bg-surface-2 px-10 py-8 text-center">
            <p className="text-sm font-semibold text-text">{SUITE_NAMES[suite] ?? suite} Suite</p>
            <p className="mt-2 text-xs text-text-muted">No tasks are registered.</p>
          </div>
        </div>
      ) : (
      <div ref={workspaceRef} className={styles.workspace} data-code-open={codeVisible} data-details-open={detailsVisible}
        style={{ '--code-width': `${widths.code}px`, '--details-width': `${widths.details}px`, '--signal-height': `${shownSignalHeight}px` } as CSSProperties}>
        {compact && mobilePanel && <button className={styles.backdrop} aria-label="Close panel" onClick={closePanel} tabIndex={-1} />}
        {!compact && codeVisible && <ResizeHandle label="Resize code panel" controls="replay-code" orientation="vertical"
          value={widths.code} min={240} max={Math.max(240, Math.min(layoutSize.width * .5, layoutSize.width - widths.details - MIN_SCENE_WIDTH))}
          className={`${styles.resizeHandle} ${styles.codeResize}`} onChange={setCodeWidth} onReset={() => setCodeWidth(null)} />}
        {!compact && detailsVisible && <ResizeHandle label="Resize machine panel" controls="replay-details" orientation="vertical" direction={-1}
          value={widths.details} min={220} max={Math.max(220, Math.min(layoutSize.width * .5, layoutSize.width - widths.code - MIN_SCENE_WIDTH))}
          className={`${styles.resizeHandle} ${styles.detailsResize}`} onChange={setDetailsWidth} onReset={() => setDetailsWidth(null)} />}
        <aside id="replay-code" ref={codePanel} hidden={!codeVisible} tabIndex={-1}
          role={compact ? 'dialog' : undefined} aria-modal={compact && codeVisible ? true : undefined} aria-label="Objective and code"
          className={`${styles.codePanel} min-h-0 overflow-y-auto overscroll-contain border-r border-border p-4 pb-16`}>
          <div className={styles.panelHeading}><span>Objective · Code</span></div>
          <p className="font-mono text-[10px] uppercase tracking-widest text-text-subtle">
            {task.family === 'composable_v1' ? 'Module composition experiment' : `Task${task.difficulty ? ` · ${DIFFICULTY_NAMES[task.difficulty] ?? task.difficulty}` : ''}`}
          </p>
          <h2 className="mt-1 text-sm font-semibold">{tid in MATERIAL_MEDIUM20 ? `${materialDisplayId(tid)} · ${task.title}` : task.title}</h2>
          {task.review_hold && <p data-testid="task-review-hold" className="mt-1 text-xs text-amber-700" title={task.review_hold.reason}>{task.review_hold.label}</p>}
          {!task.review_hold && task.candidate_status === 'design_accepted' && task.evaluation_release !== 'plcworld-evaluation/5.2.6' && <p className="mt-1 text-xs text-slate-500">{task.evaluation_status === 'variant' ? `${task.evaluation_family} mechanism variant · not scored independently` : task.evaluation_status === 'admitted' ? 'Evaluation task approved' : task.difficulty === 'easy' ? 'Easy design approved · synthetic local function' : 'Task design approved'}</p>}
          {!task.review_hold && task.candidate_status === 'review_pending' && <p className="mt-1 text-xs text-amber-600">{task.score_role === 'implementation_variant' ? 'Comparison variant · not scored independently' : 'Review candidate · not admitted to evaluation'}</p>}
          {task.family === STATION_PROCESS_FAMILY && stationReview?.validation_note && <p className="mt-2 rounded border border-amber-500/40 p-2 text-xs text-amber-700" aria-label="Mechanism review result">{stationReview.validation_note}</p>}
          {task.control_contract && (task.family === 'material_tape_separation' || task.task_version === '5.0-portfolio' || (task.task_version?.startsWith('6.') || task.task_version?.startsWith('7.') || task.task_version?.startsWith('8.') || task.task_version?.startsWith('13.') || task.task_version?.startsWith('17.'))) && <div className="mt-3 rounded-md border border-border bg-surface-2 p-2.5 text-xs leading-relaxed" aria-label="Task evaluation scope">
            {task.control_contract?.independent_score_status === 'pending_pose_family_comparison' && <p className="mb-1 text-amber-600">D03/D04 pose-transfer family · separate scoring under review</p>}
            <p><strong>Mechanism</strong> · {task.control_contract?.mechanism}</p>
            <p className="mt-1"><strong>Evaluation</strong> · {task.control_contract?.dependency_relation}</p>
            <p className="mt-1"><strong>Example failure</strong> · {task.control_contract?.minimal_counterexample}</p>
          </div>}
          {(task.task_version?.startsWith('6.') || task.task_version?.startsWith('7.') || task.task_version?.startsWith('8.') || task.task_version?.startsWith('13.') || task.task_version?.startsWith('17.')) && <p className="mt-2 text-xs text-text-subtle">Synthetic plant model; not validated against physical equipment.</p>}
          <section className="mt-3 rounded-md bg-surface-2 px-2.5 py-2 text-[11px] leading-relaxed text-text-muted" aria-label="Task objective">
            <p className="font-semibold uppercase tracking-wide text-text-subtle">Objective</p>
            <p className="mt-1" data-testid="task-objective">{taskObjective(task.req, task.aim)}</p>
          </section>
          <ReplayRunPanel locale="en" runs={task.runs} selected={run} loading={!!task.replay_deferred} reason={why}
            label={name=>runLabel(name)} focusScan={actualScan(fail?failureFrameIndex(cur):focusScan)} onSeek={()=>{setK(fail?failureFrameIndex(cur):focusScan);setPlaying(false)}}
            onSelect={name=>{setRun(name);setK(0);setPlaying(false);setSel(null);setSelectionInfo(null)}} />

          {cur.il ? <details open className="mt-5">
            <summary className="cursor-pointer font-mono text-[11px] text-text-muted">Submitted ST code</summary>
            <pre className="mt-1.5 min-w-0 overflow-x-auto rounded-md bg-surface-2 p-2.5 font-mono text-[11px] leading-relaxed">{cur.il}</pre>
          </details> : <p className="mt-5 text-[11px] text-text-subtle">Reference ST source is not bundled with this trace.</p>}
        </aside>

        <div className={styles.center}>
          <div ref={toolbarRef} className={styles.sceneHeader}>
          <div className={styles.sceneToolbar}>
            <div className={styles.sceneHeading}>
            <button ref={sceneCodeToggle} type="button" className={styles.titlePanelToggle}
              title={codeVisible ? 'Collapse code panel' : 'Expand code panel'}
              aria-label={codeVisible ? 'Collapse code panel' : 'Expand code panel'}
              aria-controls="replay-code" aria-expanded={codeVisible}
              onClick={() => compact ? setMobilePanel(codeVisible ? null : 'code') : setCodeOpen(open => !open)}>
              {codeVisible ? <PanelLeftClose size={15} aria-hidden="true" /> : <PanelLeftOpen size={15} aria-hidden="true" />}
            </button>
            <span className={styles.sceneTitle} title={task.title}>{motionDisplayId(materialDisplayId(tid))} · {task.title}</span>
            </div>
            <ReplayToolbar key={tid} locale="en" activeView={activeCameraView} showLabels={showSceneLabels} statusOpen={statusOpen}
              onView={view=>{setCameraView(view);setActiveCameraView(view);setCameraResetKey(key=>key+1)}}
              onLabels={()=>setShowSceneLabels(value=>!value)} onStatus={()=>setStatusOpen(value=>!value)}
              onReset={()=>{setCameraView('front');setActiveCameraView('front');setCameraResetKey(key=>key+1);setSel(null);setSelectionInfo(null)}}
              onReload={()=>{if(task.family===STATION_PROCESS_FAMILY)setStationReview(null);setSceneReloadKey(value=>value+1)}}
              diagnostics={<SceneDiagnostics task={tid}/>} />
          </div>
            <ReplayStatusPanel locale="en" open={statusOpen} task={task} frame={frame} selectedId={sel} message={statusMessage}
              violations={cur.viol.filter(v=>v.k<=frame.k).map(v=>reasonLabel(v.name))} onClear={()=>{setSel(null);setSelectionInfo(null)}}>
          {task.family === 'motion_precision_cell' && frame.world?.precision && <PrecisionPanel value={frame.world.precision} />}
          {task.family === 'motion_hard15' && frame.world?.motion_hard && (task.evaluation_release === 'plcworld-evaluation/5.2.6' ? <ArtifactMotionHardPanel value={frame.world.motion_hard} playbackFinished={!task.replay_deferred && k>=total-1} /> : <MotionHardPanel value={frame.world.motion_hard} playbackFinished={!task.replay_deferred && k>=total-1} />)}
          {task.family === 'motion_medium_core' && frame.world?.motion_medium && (task.evaluation_release === 'plcworld-evaluation/5.2.6' ? <ArtifactMotionMediumPanel value={frame.world.motion_medium} /> : <MotionMediumPanel value={frame.world.motion_medium} />)}
          {task.family === 'motion_easy_function' && frame.world?.motion_easy && <MotionEasyPanel value={frame.world.motion_easy} />}
          {task.family === 'motion_easy_unit' && frame.world?.motion_easy_unit && <MotionEasyUnitPanel value={frame.world.motion_easy_unit} />}
          {task.family?.startsWith('coordination_hard15_') && frame.world && !frame.world.material_hard && <div data-testid="hard15-workpiece-state" className="mt-2 space-y-1 rounded-md border border-border px-2.5 py-2 text-[11px] leading-relaxed">
            <div className="font-semibold">Shared transporter · current workpiece positions</div>
            {Object.entries(frame.world.parts).map(([id,p])=><div key={id}>{id.split('_').at(-1)} · {p.held_by ? 'Held by transfer gripper' : task.devices.find(d=>d.id===`ST${String(p.owner).padStart(2,'0')}`)?.label ?? p.owner}</div>)}
          </div>}
          {frame.world?.tending && <div data-testid="tending-cell-state" className="mt-2 space-y-1 rounded-md border border-border px-2.5 py-2 text-[11px] leading-relaxed">
            <div className="font-semibold">Shared resources and workpiece history · received {frame.world.tending.delivered}/4</div>
            {Object.entries(frame.world.tending.cells).map(([name,cell])=><div key={name}>Machine {name.toUpperCase()} · {cell.token ? `P${cell.token}` : 'empty'} · {cell.status}</div>)}
            <div>Robot: {frame.world.tending.robot ? `holding P${frame.world.tending.robot}` : 'empty'} · waiting fixture: {frame.world.tending.buffer ? `P${frame.world.tending.buffer}` : 'empty'}</div>
            <div>Inspection: {frame.world.tending.measuring ? 'measuring' : frame.world.tending.resultValid ? `valid result for P${frame.world.tending.resultToken}` : 'idle'}</div>
            {frame.world.tending.resultValid && <div>Depth {frame.world.tending.depths.map(d=>(d/1000).toFixed(2)).join(' / ')} mm · pass range 5.80–6.20 mm</div>}
          </div>}
          {frame.world?.coordination && <div data-testid="coordination-cell-state" className="mt-2 space-y-1 rounded-md border border-border px-2.5 py-2 text-[11px] leading-relaxed">
            <div className="font-semibold">Independent operations · shared resource state</div>
            {frame.world.coordination.kind==='merge' && <>
              <div>Downstream received {frame.world.coordination.accepted}/4 · merge zone {frame.world.coordination.zone?.length ? frame.world.coordination.zone.map(n=>`P${n}`).join(', ') : 'empty'}</div>
              <div>Awaiting supply {Object.entries(frame.world.coordination.waiting??{}).map(([s,n])=>`${s.toUpperCase()} ${n} items`).join(' · ')}</div>
              {frame.world.coordination.buffers && <>
                <div>Sorter destination: {frame.world.coordination.route}</div>
                {Object.entries(frame.world.coordination.buffers).map(([lane,b])=><div key={lane}>Destination {lane} · buffer {b.tokens.length?b.tokens.map(n=>`P${n}`).join(', '):'empty'} · receiver {b.ready?'ready':'waiting'} · received {b.accepted}</div>)}
              </>}
            </>}
            {frame.world.coordination.kind==='storage' && <>
              <div>Inbound stored {frame.world.coordination.inbound}/2 · outbound received {frame.world.coordination.outbound}/2</div>
              <div>Fork {frame.world.coordination.held ? `supporting P${frame.world.coordination.held}` : 'empty'}</div>
              <div>{Object.entries(frame.world.coordination.slots??{}).map(([s,n])=>`Slot ${s}: ${n?`P${n}`:'empty'}`).join(' · ')}</div>
              {frame.world.coordination.free_slots !== undefined && <>
                <div>Free storage slots {frame.world.coordination.free_slots} · P5/P6 are existing stock to retain</div>
                <div>Outbound dock {frame.world.coordination.dock?`P${frame.world.coordination.dock}`:'empty'} · receiver {frame.world.coordination.receiver_ready?'ready':'busy/waiting'}</div>
              </>}
            </>}
            {frame.world.coordination.kind==='kitting' && <>
              {Object.entries(frame.world.coordination.orders??{}).map(([s,o])=><div key={s}>Station {s.toUpperCase()} {o.order!==undefined?(o.order?`· order ${o.order}`:'· tray waiting'):''} · assembled {o.count}/3 · {o.accepted?'assembly confirmed':'awaiting assembly/receipt'}</div>)}
              {frame.world.coordination.trays ? <>
                <div>Finished trays physically received {frame.world.coordination.accepted}/4</div>
                {Object.entries(frame.world.coordination.trays).map(([id,t])=><div key={id}>Order {id} · {t.recipe.map(n=>n===1?'X':'Y').join('/')} · {({queued:'empty tray waiting',station:'assembling at station',outbound:'outbound',received:'physically received'} as Record<string,string>)[t.state]??t.state}</div>)}
                <div>Robot {frame.world.coordination.held?`holding P${frame.world.coordination.held}`:'empty'}</div>
              </> : <div>Robot {frame.world.coordination.held ? `holding P${frame.world.coordination.held}` : 'empty'} · tray receipt confirmed; later dispatch is out of scope</div>}
            </>}
          </div>}
          {frame.world?.inspection && <div data-testid="height-gauge-reading" className="mt-2 rounded-md border border-border px-2.5 py-2 text-[11px] leading-relaxed">
            <div>Contact height inspection · reference 160 ± 2 mm</div>
            <div>Latest contact measurement: {frame.world.inspection.height_mm == null ? 'none yet' : `${frame.world.inspection.height_mm.toFixed(1)} mm`}</div>
            <div>{frame.world.inspection.contact ? 'Probe in contact' : frame.x.X28 ? 'Probe at home' : 'Probe moving'}
              {frame.world.inspection.done ? (frame.world.inspection.good ? ' · accepted and retracted' : ' · inspection failed or interrupted') : ''}</div>
          </div>}

          {task.family === 'quality_leak' && frame.world?.quality && <div data-testid="pressure-test-reading" className="mt-2 rounded-md border border-border px-2.5 py-2 text-[11px] leading-relaxed">
            <div>Sealed-part pressure retention test · synthetic pressure model</div>
            <div>Internal pressure: {frame.world.quality.pressure_kpa.toFixed(2)} kPa</div>
            <div>Measured pressure drop: {frame.world.quality.drop_kpa == null ? 'not measured yet' : `${frame.world.quality.drop_kpa.toFixed(2)} kPa`}</div>
            <div>{frame.world.quality.done ? (frame.world.quality.good ? 'Measurement complete · part accepted' : 'Measurement complete · leaking part rejected') : 'Awaiting a valid measurement'} · Correctly classifying a leaking part still passes the control task.</div>
          </div>}

            {task.evaluation_release === 'plcworld-evaluation/5.2.6' && task.suite === 'material'
              ? <div className={styles.webReading} data-testid="artifact-material-state">
                  <strong>{Object.entries(frame.world?.material_hard?.parts ?? frame.world?.parts ?? {}).map(([id, part]) => `${id}: ${part.owner ?? 'unknown'}`).join(' · ') || 'No workpiece in this state'}</strong>
                  <span>Recorded physical state · {!frame.world?.material_hard && <>{Object.keys(frame.world?.devices ?? {}).length} devices · </>}{Object.keys(frame.world?.material_hard?.parts ?? frame.world?.parts ?? {}).length} workpieces</span>
                  {frame.world?.material_hard?.contact && <span>Schematic machinery · final task anchors · recorded actuator motion</span>}
                  <span>Numeric I/O · {Object.entries(frame.words ?? {}).map(([address, value]) => `${address}=${value}`).join(' · ') || 'none'}</span>
                </div>
              : <><MaterialEasyReadout id={tid} frame={frame} className={styles.webReading} />
                  <MaterialV8Readout id={tid} frame={frame} className={styles.webReading} />
                  <MaterialV7Readout id={tid} frame={frame} className={styles.webReading} />
                  <MaterialV6Readout id={tid} frame={frame} className={styles.webReading} /></>}
            {frame.world?.web_index && <div className={styles.webReading} data-testid="web-index-overlay">
              <strong>Requested {frame.world.web_index.request_mm.toFixed(1)} mm · actual web {frame.world.web_index.delivered_mm.toFixed(2)} mm</strong>
              <span>Carriage {frame.world.web_index.carriage_mm.toFixed(2)} mm · moving grip {frame.world.web_index.grip >= .999 ? 'closed' : frame.world.web_index.grip <= .001 ? 'open' : 'moving'} · receiver {frame.world.web_index.receiver >= .999 ? 'clamped' : 'not clamped'}</span>
              <span>Orange: web datum · yellow: requested position</span>
            </div>}
            {frame.world?.material_hard && <MaterialHardPriorityPanel value={frame.world.material_hard} />}
            {isTending && <TendingQualityPanel run={cur} scan={Math.min(k, total - 1)} onSeek={scan => { setK(scan); setPlaying(false) }} />}
            </ReplayStatusPanel>
          </div>
          <div className={styles.scene} data-testid="replay-scene"
            // Keep toolbar state in sync even when a controls start event is missed.
            // Capture observes input without preventing the camera's own handlers.
            onPointerMoveCapture={event => { if (event.buttons) onCameraInteraction() }}
            onWheelCapture={onCameraInteraction} onTouchMoveCapture={onCameraInteraction}>
            <ReplaySceneRecovery enabled reloadKey={sceneReloadKey} onContextLost={pausePlayback}>
            <SceneBoundary resetKey={`${tid}:${run}`}>
              {task.replay_deferred ? <div role="status" className="grid h-full place-items-center text-sm text-text-muted">Loading recorded 3D scene…</div>
              : sceneReview && (recordedReview || task.family === STATION_PROCESS_FAMILY) ? <StationReplayScene review={sceneReview} run={run} index={k} machine={machine}
                selectedDevice={sel} onSelectDevice={setSel} showLabels={showSceneLabels} cameraView={cameraView} cameraResetKey={cameraResetKey}/>
              : <Scene3D machine={machine} plant={plant as never} presentationBounds={task.presentation_bounds}
                selectedDevice={sel} onSelectDevice={setSel} showLabels={showSceneLabels}
                cameraView={cameraView} cameraResetKey={cameraResetKey} onCameraInteraction={onCameraInteraction}
                responsiveFraming lightTheme layoutMode="off" onTransform={() => {}} />}
            </SceneBoundary>
            </ReplaySceneRecovery>
          </div>

          {timelineOpen && <ResizeHandle label="Resize timeline" controls="replay-signals" orientation="horizontal" direction={-1}
            value={shownSignalHeight} min={40} max={maxSignalHeight}
            className={`${styles.resizeHandle} ${styles.timelineResize}`} onChange={setSignalHeight} onReset={() => setSignalHeight(null)} />}
          <div className={styles.timeline} data-open={timelineOpen}>
            <div ref={playbackRef} className={styles.playback}>
              <button disabled={!!task.replay_deferred} onClick={() => { if (!playing && k >= total - 1) setK(0); setPlaying((p) => !p) }} className="w-20 rounded-md border border-border px-3 py-1.5 text-xs hover:border-accent disabled:opacity-50">
                {playing ? '❚❚ Pause' : '▶ Play'}
              </button>
              <select value={playbackRate} onChange={(e) => setPlaybackRate(Number(e.target.value))}
                aria-label="Playback speed"
                className="rounded-md border border-border bg-surface px-2 py-1.5 text-xs text-text">
                <option value={0.5}>0.5×</option>
                <option value={1}>1×</option>
                <option value={2}>2×</option>
              </select>
              {canShorten&&<button className={styles.button} data-testid="replay-full-scans" aria-pressed={fullScans} title="Idle scans after completion are skipped by default; the full evaluation trace is retained." onClick={()=>{setPlaying(false);if(fullScans)setK(v=>Math.min(v,shortEnd??v));setFullScans(v=>!v)}}>{fullScans?'Active interval':'All scans'}</button>}
              <input aria-label="Replay scan" disabled={!!task.replay_deferred} type="range" min={0} max={total - 1} value={k} onChange={(e) => { setK(+e.target.value); setPlaying(false) }} className={styles.scrubber} />
              {task.replay_deferred
                ? <span role="status" className="text-xs text-text-muted">Loading trace…</span>
                : <span className="whitespace-nowrap font-mono text-[11px] tabular-nums text-text-muted">Scan {actualScan(k)} / {actualScan(total - 1)} · {actualScan(k) * scanMs}ms</span>}
              <button className={styles.button} aria-expanded={timelineOpen} aria-controls="replay-signals" onClick={() => setTimelineOpen(open => !open)}>Signals {timelineOpen ? 'Hide' : 'Show'}</button>
            </div>
            <div id="replay-signals" hidden={!timelineOpen} className={styles.signals}>
              {timelineOpen && <SignalTimeline task={task} frames={displayedFrames} violations={cur.viol} scan={k} />}
            </div>
          </div>
        </div>

        <aside id="replay-details" ref={detailsPanel} hidden={!detailsVisible} tabIndex={-1}
          aria-label="Machine and I/O information"
          className={`${styles.detailsPanel} min-h-0 flex-col border-l border-border`}>
          <div className={styles.panelHeading}><span>Machine · I/O · Result</span></div>
          <div className="flex shrink-0 border-b border-border">
            {([
              ['machine', 'Machine'],
              ['io', 'I/O'],
              ['result', 'Result'],
            ] as const).map(([id, label]) => (
              <button
                key={id}
                onClick={() => setRightTab(id)}
                className={`flex-1 px-2 py-2 text-xs ${rightTab === id ? 'border-b-2 border-accent text-text' : 'text-text-muted hover:text-text'}`}
              >
                {label}
              </button>
            ))}
          </div>

          <div className="flex-1 overflow-y-auto">


            {rightTab === 'machine' && <ReplayMachinePanel task={displayTask ?? task} frame={inspectorFrame} selectedId={sel} onSelect={setSel} />}

            {rightTab === 'io' && (
              <div>
                {(task.family === STATION_PROCESS_FAMILY || task.family === 'motion_hard15' || task.family === 'motion_precision_cell' || task.family === 'motion_easy_function' || task.family === 'motion_easy_unit' || task.family === 'motion_medium_core') && <p data-testid="precision-scan-boundary" className="border-b border-border px-3 py-2 text-[10px] leading-relaxed text-text-muted">
                  I/O inputs are sampled at scan start; the scene shows actual values at scan end.
                </p>}
                {Object.entries(task.io).map(([tag, desc]) => {
                  const value = frame.words && tag.startsWith('D') ? frame.words[tag] ?? 0
                    : tag.startsWith('X') ? frame.x[tag] ?? 0 : frame.y[tag] ?? 0
                  return (
                    <div key={tag} className="flex items-center gap-2 border-b border-border/60 px-3 py-2">
                      <span className={`h-2 w-2 rounded-full ${value ? 'bg-emerald-500' : 'bg-slate-600'}`} />
                      <code className="w-9 text-xs font-semibold text-text">{tag}</code>
                      <span className="min-w-0 flex-1 text-[10px] text-text-muted">{desc}</span>
                      <span className={`font-mono text-xs ${value ? 'text-emerald-400' : 'text-text-subtle'}`}>{value}</span>
                    </div>
                  )
                })}
              </div>
            )}

            {rightTab === 'result' && (
              <div className="space-y-3 p-3">
                <div className={`rounded-md border p-3 ${fail ? 'border-danger bg-red-950/20' : 'border-border bg-emerald-950/20'}`}>
                  <p className={`text-xs font-bold ${fail ? 'text-red-400' : 'text-emerald-400'}`}>{fail ? 'FAIL · Objective not reached' : 'PASS · Objective reached'}</p>
                  <p className="mt-1.5 text-[11px] leading-relaxed text-text-muted">{why}</p>
                </div>
                {(frame.world?.motion_hard?.shared.contract_revision??0)>=5&&<dl data-testid="motion-v5-final-verdict" className="grid grid-cols-2 gap-2 rounded border border-border p-2 text-[11px]">
                  <dt>Objective result (U)</dt><dd>{cur.frames[cur.frames.length-1].world?.motion_hard?.shared.task_success ? 'Success · 1' : 'Failure · 0'}</dd>
                  <dt>Safety violation (V)</dt><dd>{cur.frames[cur.frames.length-1].world?.motion_hard?.shared.safety_violation ? 'Yes · 1' : 'No · 0'}</dd>
                </dl>}
                {task.family === STATION_PROCESS_FAMILY && stationReview?.validation_note && <p className="rounded border border-amber-500/40 p-2 text-[11px] text-amber-700">{stationReview.validation_note}</p>}
                <dl className="grid grid-cols-[1fr_auto] gap-x-2 gap-y-1 text-[10px] text-text-subtle">
                  <dt>Plant model</dt><dd className="text-right text-text-muted">{task.family === 'motion_easy_unit' ? cur.model : modelLabel(cur.model)}</dd>
                  <dt>Current scan</dt><dd className="font-mono text-text-muted">{actualScan(k)} · {actualScan(k) * scanMs}ms</dd>
                  {completionScan >= 0 && <><dt>{completionOutput} {completionLabel}</dt><dd className="font-mono text-text-muted">{actualScan(completionScan)} scan</dd></>}
                  {feedbackScan >= 0 && <><dt>{primaryFeedback} {feedbackLabel}</dt><dd className="font-mono text-text-muted">{actualScan(feedbackScan)} scan</dd></>}
                  {transferScan >= 0 && <><dt>Workpiece acquired</dt><dd className="font-mono text-text-muted">{actualScan(transferScan)} scan</dd></>}
                </dl>
                <div className="rounded border border-border bg-surface-2 p-2.5 text-[10px] leading-relaxed text-text-muted">
                  <p>Difficulty: {task.family === 'composable_v1' ? 'Unclassified composition experiment' : task.difficulty ? DIFFICULTY_NAMES[task.difficulty] ?? task.difficulty : 'Unspecified'}</p>
                  <p>Source: {task.provenance}</p>
                  <p>The replay trace is read-only; this viewer does not recompute the score.</p>
                </div>
              </div>
            )}
          </div>
        </aside>
      </div>
      )}
    </div></ReplaySelectionContext.Provider>
  )
}
