import { motionDiverseLabel } from './motionDiverseLabels'
/**
 * Replay anonymized experiment records in the original 3D machinery viewer.
 * This layer projects saved frames without recomputing physical state.
 */
import type { DeviceSpec, MachineSpec, WebGeometry } from '../machine/infer'
import { layoutMachine, type LaidOutMachine } from '../machine/layout'
import type { DeviceState, Part } from '../machine/plant'
import { KIND_INFO, type DeviceKind } from '../machine/vocab'
import { MATERIAL_V6_BASES, materialV6Label } from './materialV6Labels'

export interface TraceDevice {
  label?: string
  web_geometry?: WebGeometry
  id: string
  kind: 'act' | 'carrier' | 'static'
  ui: DeviceKind
  drive?: string
  stroke_ms?: number
  at_max?: string | null
  at_min?: string | null
  slow?: string
  width?: number
  span?: number
  sensors?: [string, number][]
  pos?: [number, number, number]
  size?: [number, number, number]
  rot?: number
  motion_axis?: 'x' | 'y' | 'z'
  dynamic_world_position?: boolean
  dynamic_world_rotation?: boolean
  state_display?: { kind: 'count'; scale: number; label: string }
  actuator_ref?: string
  rod_base_extension?: number
  press_max_travel?: number
  sensor_visual?: 'photoeye' | 'limit' | 'slot' | 'pressure' | 'proximity'
  sensor_beam_length?: number
  sensor_target?: [number, number, number]
  sensor_receiver?: boolean
  sensor_purpose?: string
  visual_variant?: 'motion-hard-cell' | `cell3-${string}` | `easy15-${string}` | `v13-${string}` | 'turnover-drive' | 'turnover-jaws' | 'single-vacuum-cup' | 'wide-stroke' | 'material-taught-arm' | 'material-pallet-locator' | 'material-locator-pallet' | 'material-contact-height-gauge' | 'machining-spindle' | 'single-pocket-index' | 'compact-transfer-belt' | 'quarter-turn-base' | 'pressure-seal-head' | 'pressure-test-module' | 'test-air-valve' | 'material-sized-slot' | 'material-limit-sensor' | 'material-fork-clearance-rack' | 'material-rack-mast' | 'hard-workbench' | 'hard-sliding-door' | 'hard-locator-surround' | 'hard-fixture-clamp' | 'hard-spindle' | 'hard-probe' | 'hard-feed-belt' | 'hard-control-cabinet' | 'material-pallet-rack' | 'web-index-base' | 'web-feed-carriage' | 'web-moving-grip' | 'web-receiver-clamp' | 'web-meter-roll' | 'web-strip' | 'web-target' | 'material-vacuum-mast' | 'v6-orientation-base' | 'v6-datum-base' | 'v6-classification-base' | 'v6-vacuum-head' | 'v6-sort-gripper' | 'v6-z-slide' | 'v6-datum-z-slide' | 'v6-buffer-base' | 'v6-buffer-ribbon' | 'v6-buffer-dancer' | 'v6-buffer-spool' | 'v6-buffer-feeder' | 'v6-buffer-receiver' | 'v6-buffer-target' | 'v6-stack-base' | 'v6-stack-slide' | 'v6-stack-table' | 'v6-swing-arm' | 'v6-pocket-key' | 'v6-align-x' | 'v6-align-z' | 'motion-easy-roll' | 'motion-reference-dog' | 'motion-home-probe' | 'motion-holding-brake' | 'motion-v08-articulated' | 'motion-v08-index_pin' | 'motion-v08-table_slide' | 'motion-v08-scissor' | 'motion-v08-door_recovery' | 'motion-v08-telescopic' | 'motion-v08-mobile' | 'motion-v08-hoist' | 'motion-v08-counterbalance' | 'motion-v08-crank' | 'motion-v08-hexapod' | 'v7-dose-base' | 'v7-pitch-base' | 'v7-magazine-base' | 'v7-handshake-base' | 'v7-selective-base' | 'v7-nozzle' | 'v7-valve' | 'v7-liquid' | 'v7-tank' | 'v7-carriage' | 'v7-pitch-crosshead' | 'v7-selective-crosshead' | 'v7-head' | 'v7-pitch-receiver' | 'v7-rack' | 'v7-pusher' | 'v7-sender' | 'v7-receiver' | 'v8-aperture-base' | 'v8-balance-base' | 'v8-balance-head' | 'v8-balance-tray' | 'v8-board-pusher' | 'v8-bridge-base' | 'v8-carousel' | 'v8-carousel-base' | 'v8-carousel-pusher' | 'v8-content-line' | 'v8-conveyor-drive' | 'v8-diverter-valve' | 'v8-edge-web' | 'v8-edgeguide-base' | 'v8-gantry-carriage' | 'v8-intercept-base' | 'v8-lineidentity-base' | 'v8-liquid-level' | 'v8-mouth-pad' | 'v8-moving-pocket' | 'v8-netflow-base' | 'v8-pairjoin-base' | 'v8-pairjoin-base-v2' | 'v8-pair-transfer' | 'v8-pouch' | 'v8-receiver-nip' | 'v8-routing-drive' | 'v8-skeleton-base' | 'v8-small-pusher' | 'v8-steering-roll' | 'v8-support-bridge' | 'v8-vacuum-bed' | 'v8-scrap-platen' | 'v8-vacuum-head'
}

export interface TraceRelation {
  type: 'mounted_on' | 'holds' | 'works_at' | 'interlock'
  parent?: string
  child?: string
  device?: string
  part?: string
  rule?: string
}

export interface WorldPose {
  pos: [number, number, number]
  /** Present only on replay assemblies with rigid moving attachments. */
  quaternion?: [number, number, number, number]
}

export interface WorldPart extends WorldPose {
  rotation?: [number, number, number]
  orientation_marker?: boolean
  machining_depths?: [number, number]
  render_variant?: 'pressure-vessel' | 'slotted-pallet' | 'motion-regrip' | 'rack-load-pallet' | 'v8-can' | `hard-stock-${string}`
  motion_dimensions?: [number, number, number]
  material_dimensions?: [number, number, number]
  visible?: boolean
  owner?: string
  held_by?: string | null
  status?: 'idle' | 'held' | 'dropped'
  color?: string
}

export type MotionHardState = {
  mode: string;
  /** Opt-in candidate geometry; absent from all existing frozen tasks. */
  dependency?: {
    version: string; task_number: number; labels: Record<string,string>;
    axis_labels?: Record<string,string>; local_dwell_required?: boolean;
    coupling?: {purpose:string;states:{id:string;label:string;value:string;status:string}[];results:{id:string;label:string;value:string;status:string}[]};
    parts: {name:string;pos:[number,number,number];size:[number,number,number];color:string;node?:string;
      shape?:'box'|'cylinder'|'ring'|'bored_disc';axis?:'x'|'y'|'z';style?:string;
      holes?:{x:number;z:number;radius:number}[]}[];
  };
  rail_shift_z?:number;
  clearance_revision?:number;
  native_positions?:[number,number,number][];
  pocket_z?:number;
  cross_support_x?:number;
  axes: Record<string,{actual:number;velocity:number;target:number;unit:string}>;
  requests: {id:number;lane:number;target:number;aux:number;mark?:number;arrival_ms:number;deadline_ms:number;status:string;served:boolean;released?:boolean;returned?:boolean;phase?:string;location?:number;cancelled:boolean;progress:number;completed_ms:number|null}[];
  shared: Record<string,number>; routes:number[];
  poses: MotionMechanism['poses']; mechanisms: Record<string,MotionMechanism>;
  result_asserted:boolean;result_age_ms:number;success:boolean;violations:string[];available:boolean;
  process?: {
    slug:string;source_mode:string;
    layout:{transport_path?:import('@/components/scene/assemblies/MotionPathGuide').TransportPath;clearance_revision?:number;source:{position:[number,number,number];spread:number;foot_size?:[number,number,number];foot_offset_z?:number;rail_shift_z?:number};cells:Record<string,{mode:string;source:string;label:string;position:[number,number,number];dock_point:[number,number,number];assets:TraceTask['devices'];foot_size?:[number,number,number];foot_offset_z?:number;receiver_radius?:number;mount_extension_z?:number;rotation_y?:number;native_positions?:[number,number,number][];pocket_z?:number;pocket_homes?:number[][];pocket_branches?:number[];cross_support_x?:number;receiver_stand?:boolean}>;rails:number[];rail_y:number;jig_y:number;source_ids:string[];labels:string[]};
    cells:Record<string,MotionHardState & {mechanism?:MotionMechanism;device_poses?:MotionMechanism['poses'];device_states?:Record<string,number>}>;
    stages:Record<string,{served:boolean;owner:number;route:number}>;
    metrics:Record<string,Record<string,number>>;
  };
}
export type MaterialHardState = {
  contact?: {
    schema: string;
    poses: Record<string,{pos:[number,number,number];kind:string;yaw:number;size?:[number,number,number]}>;
    inventory?: Record<string,{pos:[number,number,number];kind:string;yaw:number;size?:[number,number,number]}>;
    lanes: {id:string;a:[number,number,number];b:[number,number,number]}[];
    stops: {id:string;pos:[number,number,number];closed:boolean;axis:string}[];
    web_path: [number,number,number][];
  };
  mode: 'r8-package' | 'r8-branch' | 'r8-carrier' | 'r8-measure' | 'index'|'web'|'vacuum'|'stack'|'liquid'|'tape' | 'replenish';
  poses: Record<string,{pos:[number,number,number];size?:[number,number,number];yaw?:number}>;
  requests: {id:string;label:string;progress:string;detail:string}[];
  shared: Record<string,string>;
  accepted: number[];
  parts: Record<string,{token:number;kind?:number|string;owner:string;x:number;y:number;z:number;size?:[number,number,number];rx?:number;ry?:number;rz?:number;yaw?:number;status?:string;side?:string}>;
  violations:string[];
  web_path?: [number,number,number][];
  wind_tape?: {
    source_a_radius: number; source_b_radius: number;
    source_a_path: [number,number,number][]; source_b_path: [number,number,number][];
    tape_head: [number,number,number]; tape_length: number; tape_severed: boolean;
    mandrel: number; support_y: number; exit_pusher_x: number; exit_pusher_z: number;
  };
}
export interface Frame {
  k: number
  y: Record<string, number>
  x: Record<string, number>
  s: Record<string, number>
  v: number
  words?: Record<string, number>
  world?: {
    devices: Record<string, WorldPose>
    parts: Record<string, WorldPart>
    events?: string[]
    motion_hard?: MotionHardState
    material_hard?: MaterialHardState
    motion_easy_unit?: {
      mode: string; function_id: string; primary_axis: string;
      axes: Record<string, { position: number; actual: number; velocity: number; target: number | null; unit: string }>;
      mechanism?: MotionMechanism | null;
      stable_ms: number; result_age_ms: number; observation_ms: number;
      result_asserted: boolean; success: boolean; error: number;
      diagnostics: Record<string, number>; violations: string[];
    }
    motion_medium?: {
      mode: "reference" | "dock" | "exchange" | "registration" | "brake" | "gantry" | "velocity_capture" | "gear" | "flying" | "stop_relative" | "articulated" | "index_pin" | "table_slide" | "scissor" | "door_recovery" | "telescopic" | "mobile" | "hoist" | "counterbalance" | "crank" | "hexapod";
      mechanism?: MotionMechanism;
      axes: Record<string,{ position:number; actual_mm?:number; velocity_mm_s?:number; target_mm?:number|null; actual_deg?:number; velocity_deg_s?:number; target_deg?:number|null }>;
      diagnostics?: Record<string,number|boolean|null>;
      referenced:boolean; home_busy:boolean; home_done:boolean; raw_count:number; captured_count:number|null;
      stable_ms:number; result_age_ms:number; result_asserted:boolean; success:boolean;
      min_gap_mm:number|null; violations:string[];
    }
    motion_easy?: {
      mode: 'position' | 'home' | 'stop' | 'speed'; actual: number; velocity: number; target: number;
      stable_ms: number; result_age_ms: number; active: boolean; result_asserted: boolean; success: boolean;
      referenced: boolean; raw_count: number; captured_count: number; capture_valid: boolean; reference_count: number | null;
      reference_error_mm: number | null; limit: number; stop_distance: number; violations: string[];
    }
    precision?: {
      axes: Record<string, { actual_mm: number; target_mm: number; error_mm: number; velocity_mm_s: number; settled: boolean; settle_ms: number }>
      minimum_gap_mm: number | null
      current_gap_mm: number | null
      overlap_scans: number
      collision: { pair: string; components: string[]; gap_mm: number } | null
      completed_functions: string[]
    }
    coordination?: { kind: 'merge' | 'storage' | 'kitting'; accepted?: number; zone?: number[]; waiting?: Record<string,number>; outbound?: number; inbound?: number; held?: number; slots?: Record<string,number>; orders?: Record<string,{accepted:boolean;count:number;order?:number}>; buffers?: Record<string,{tokens:number[];ready:boolean;accepted:number}>; route?: number; free_slots?: number; dock?: number; receiver_ready?: boolean; infeed?: Record<string,string>; trays?: Record<string,{state:string;side:string;recipe:number[];count:number}> }
    tending?: { cells: Record<string, { token: number; status: string }>; robot: number; buffer: number; resultToken: number; resultValid: boolean; measuring: boolean; depths: number[]; delivered: number }
    inspection?: { height_mm: number | null; contact: boolean; phase: string; good: boolean; done: boolean }
    web_index?: { carriage_mm: number; web_mm: number; delivered_mm: number; request_mm: number; grip: number; receiver: number }
    quality?: { pressure_kpa: number; drop_kpa: number | null; elapsed_ms: number; done: boolean; good: boolean; metal: boolean }
  }
}

export interface TraceRun {
  recorded_geometry?: import("./recordedGeometry").RecordedGeometry
  playback_end_index?: number
  omitted_idle_scans?: number
  full_evaluation_end_ms?: number
  label?: string
  frames: Frame[]
  il: string
  viol: { k: number; name: string }[]
  goal: boolean
  verdict?: 'PASS' | 'FAIL'
  reason?: string
  model?: string
}

export interface TraceTask {
  presentation_bounds?: {x:number;z:number;width:number;depth:number}
  scan_ms?: number
  replay_shared_motion_layout?: boolean
  replay_deferred?: boolean
  function_id?: string
  parent_medium?: string
  score_role?: 'core' | 'core_candidate' | 'implementation_variant' | 'family_subcase'
  task_version?: string
  replay_candidate?: string
  visual_revision?: string
  control_contract?: { independent_score_status?: string; mechanism?: string; primary_obligation_id?: string; minimal_counterexample?: string; dependency_relation?: string; decisive_observations?: string }
  evaluation_status?: 'admitted' | 'on_hold' | 'variant'
  evaluation_family?: string
  review_hold?: { label: string; reason: string; kind: string }
  evaluation_release?: string
  candidate_status?: 'review_pending' | 'design_accepted'
  design_accepted?: boolean
  completion_output?: string
  title: string
  aim: string
  req: string
  environment?: string
  suite?: 'motion' | 'material' | 'test'
  difficulty?: 'easy' | 'medium' | 'hard'
  family?: string
  io: Record<string, string>
  devices: TraceDevice[]
  relations?: TraceRelation[]
  observed: string[]
  runs: Record<string, TraceRun>
  provenance?: string
  /** Full-cycle framing for opt-in Motion assemblies. Does not move equipment. */
  assembly_view?: { dist: number; target: [number, number, number]; front_sign?: 1 | -1; cutaway?: boolean }
}

export type Trace = Record<string, TraceTask>

export interface TraceBundle {
  schema_version: 'canonical-replay-trace/0.2'
  contains_enterprise_data: false
  scan_ms: number
  tasks: Trace
}

export function toMachine(task: TraceTask, title: string): LaidOutMachine {
  const materialV6=task.suite==='material' && task.devices.some(d=>MATERIAL_V6_BASES.has(d.visual_variant??''))
  const devices: DeviceSpec[] = task.devices.map((d, i) => {
    const info = KIND_INFO[d.ui] ?? KIND_INFO.cylinder
    const presentation=materialV6?materialV6Label(d.visual_variant,d.id,d.pos?.[1]??0):undefined
    return {
      id: d.id,
      kind: info.kind,
      motion: info.motion,
      label: d.label ?? motionDiverseLabel(d.visual_variant) ?? presentation?.label ?? (task.evaluation_release === 'plcworld-evaluation/5.2.6' ? d.id.replaceAll('_', ' ') : `${info.label} ${d.id}`),
      ...(presentation ? {sceneLabelOffset:presentation.sceneLabelOffset} : {}),
      ...(d.visual_variant === 'motion-reference-dog' && task.evaluation_release === 'plcworld-evaluation/5.2.6' ? {sceneLabelOffset:[0,.28,0] as [number,number,number]} : {}),
      ...(d.visual_variant === 'motion-hard-cell' ? {sceneLabelOffset:[0,1.75,0] as [number,number,number]} : {}),
      ...(d.visual_variant?.startsWith('motion-v08-') ? {sceneLabelOffset:[0,1.3,0] as [number,number,number]} : {}),
      index: i + 1,
      drive: { fwd: d.drive },
      feedback: { atMax: d.at_max ?? undefined, atMin: d.at_min ?? undefined },
      strokeMs: d.stroke_ms ?? info.strokeMs,
      evidence: [`Experiment specification — ${task.aim}`],
      confidence: 1,
      color: info.color,
      pos: d.pos ?? [0, 0, 0],
      rot: d.rot ?? 0,
      size: d.size ?? [0.4, 0.4, 0.4],
      motionAxis: d.motion_axis,
      webGeometry: d.web_geometry,
      replayPoseRotation: d.dynamic_world_rotation,
      stateDisplay: d.state_display,
      actuatorRef: d.actuator_ref,
      mountedOn: task.relations?.find(r => r.type === 'mounted_on' && r.child === d.id)?.parent,
      rodBaseExtension: d.rod_base_extension,
      sensorVisual: d.sensor_visual,
      // Synthetic H02 has two .16 blocks at Y=.72/.88. Match the tool to
      // their .96 top, not the generic unloaded ram stroke through the stack.
      pressMaxTravel: d.press_max_travel ?? (task.family === 'dual_component_assembly' && d.id === 'JOIN_PRESS'
        ? (d.pos?.[1] ?? 1.38) - (d.size?.[1] ?? .68) * .18 - .06 - .96 : undefined),
      // The base block starts at .64; relieve the original .68 fixture top.
      fixtureTopOffset: task.family === 'dual_component_assembly' && d.id === 'ASSEMBLY_FIXTURE' ? -.04 : undefined,
      clipPhotoeyeBeam: task.suite === 'material',
      // Wide-stroke is a pure geometry variant independent of suite. Keep the
      // existing Material gate for the other Material-only variants.
      visualVariant: d.visual_variant === 'wide-stroke'
        ? d.visual_variant
        : task.suite === 'material' || (['motion_easy_function', 'motion_medium_core', 'motion_easy_unit', 'motion_hard15'].includes(task.family ?? '') && (d.visual_variant?.startsWith('motion-v08-') || ['motion-hard-cell', 'motion-easy-roll', 'motion-reference-dog', 'motion-home-probe', 'motion-holding-brake'].includes(d.visual_variant ?? ''))) ? d.visual_variant : undefined,
      sensorBeamLength: d.sensor_beam_length,
      sensorTarget: d.sensor_target,
      sensorReceiver: d.sensor_receiver,
      sensorPurpose: d.sensor_purpose,
    }
  })
  const spec: MachineSpec = { title, replaySuite: task.suite, devices, controls: [], unmatched: [], notes: [] }
  if (task.suite === 'material' && (task.family === 'shared_dual_machine_tending' || task.family?.startsWith('coordination_'))) {
    spec.floorFrontSign = task.assembly_view?.front_sign ?? -1
  }
  const transforms = Object.fromEntries(task.devices
    .filter((d) => d.pos || d.size || typeof d.rot === 'number')
    .map((d) => [d.id, { pos: d.pos, size: d.size, rot: d.rot }]))
  const machine = layoutMachine(spec, transforms)
  if (task.suite === 'motion' && task.assembly_view) {
    machine.geometry.view = { dist: task.assembly_view.dist, target: [...task.assembly_view.target], cutaway: task.assembly_view.cutaway,
      ...(['motion_easy_unit','motion_hard15'].includes(task.family ?? '') ? { frontSign: task.assembly_view.front_sign } : {}),
      ...(task.family === 'motion_medium_core' && task.devices.some(d => d.ui === 'fork') ? { frontSign: -1 as const } : {}) }
  }
  if (task.suite === 'material' && task.assembly_view) {
    machine.geometry.view = { dist: task.assembly_view.dist, target: [...task.assembly_view.target], frontSign: task.assembly_view.front_sign }
  }
  // The tending cell opens toward -Z; archived camera metadata used +Z.
  if (task.suite === 'material' && task.family === 'shared_dual_machine_tending') {
    machine.geometry.view.frontSign = -1
    machine.floorFrontSign = -1
  }
  return machine
}

/** E01/E02 share a pickup cell. Extra optical brackets must not shift the comparison view. */
export function toReplayMachine(trace: Trace, id: string, displayDevices?: TraceDevice[]): LaidOutMachine {
  const task = displayDevices ? {...trace[id], devices:displayDevices} : trace[id]
  const machine = toMachine(task, `${id} · ${trace[id].title}`)
  // Include the revised floor perimeter, not only the table, on initial entry.
  if (id === 'MOT-M02') machine.geometry.view = {
    ...machine.geometry.view, dist: machine.geometry.view.dist * 1.18,
  }
  if (id === 'MAT-E01' && trace['MAT-E02']) {
    const reference = toMachine(trace['MAT-E02'], 'pickup framing reference').geometry.view
    // Copy only the camera: do not move the jig, fingers, sensors, or recorded workpiece.
    machine.geometry.view = { dist: reference.dist, target: [...reference.target] }
  }
  return machine
}

const PART_COLOR = '#c98a3c'
const HELD_PART_COLOR = '#37b7f0'

export type MotionMechanism = {
  mode: string;
  boundary_revision?: string;
  clearance_revision?: number;
  poses: Record<string,{pos:[number,number,number];quaternion:[number,number,number,number];scale?:[number,number,number]}>;
  initial: Record<string,number>; axis_units: Record<string,string>; axis_labels: Record<string,string>;
}
/** Expand per-run static geometry references without copying the large layout. */
export function hydrateMotionProcessLayouts(frames: Frame[]) {
  const layout = frames[0]?.world?.motion_hard?.process?.layout
  if (!layout) return
  for (const frame of frames) {
    const process = frame.world?.motion_hard?.process
    if (process && !process.layout) process.layout = layout
  }
}

export class TracePlant {
  k = 0
  parts: Part[] = []
  private prev: Record<string, number> = {}
  private partIds = new Map<string, number>()
  private usedPartIds = new Set<number>()

  private partId(sourceId: string): number {
    const known = this.partIds.get(sourceId)
    if (known !== undefined) return known
    // A1 and B1 are different physical items. Preserve legacy numeric IDs
    // when available, and retain the full source-key mapping across seeks.
    let id = Number(sourceId.replace(/\D/g, '')) || 1
    while (this.usedPartIds.has(id)) id++
    this.partIds.set(sourceId, id)
    this.usedPartIds.add(id)
    return id
  }

  constructor(
    public machine: LaidOutMachine,
    public devices: TraceDevice[],
    public frames: Frame[],
  ) { hydrateMotionProcessLayouts(frames) }

  motionHardState(): MotionHardState | undefined { return this.frame().world?.motion_hard }
  materialHardState(): MaterialHardState | undefined { return this.frame().world?.material_hard }

  motionMechanism(): MotionMechanism | undefined { return this.frame().world?.motion_medium?.mechanism ?? this.frame().world?.motion_easy_unit?.mechanism ?? undefined }

  motionEasyMode(): string | undefined { return this.frame().world?.motion_easy_unit?.mode }

  motionState(): NonNullable<Frame['world']>['motion_medium'] {
    return this.frame().world?.motion_medium
  }

  private frame(): Frame {
    return this.frames[Math.min(Math.max(this.k, 0), this.frames.length - 1)]
  }

  /** Project the current frame's world coordinates and workpiece relations into Scene3D. */
  setFrame(k: number): void {
    this.k = k
    const world = this.frame().world
    if (!world) return

    for (const [id, pose] of Object.entries(world.devices)) {
      const device = this.machine.devices.find((d) => d.id === id)
      if (device) device.pos = [...pose.pos]
      if (device && (this.machine.replaySuite === 'motion' || device.replayPoseRotation) && pose.quaternion) {
        device.replayQuaternion = [...pose.quaternion]
      }
    }
    this.parts = Object.entries(world.parts).map(([id, p]) => ({
      id: this.partId(id),
      x: p.pos[0],
      y: p.pos[1],
      z: p.pos[2],
      blocked: p.status !== 'held',
      color: p.color ?? (p.status === 'dropped' ? '#c2362b' : p.status === 'held' ? HELD_PART_COLOR : PART_COLOR),
      heldBy: p.held_by ?? null,
      status: p.status,
      ...(p.rotation ? { rotation: p.rotation } : {}),
      ...(p.orientation_marker ? { orientationMarker: true } : {}),
      ...(p.material_dimensions ? { materialDimensions: p.material_dimensions } : {}),
      ...(p.machining_depths ? { machiningDepths: p.machining_depths } : {}),
      ...(p.render_variant ? { renderVariant: p.render_variant } : {}),
      ...(this.machine.replaySuite === 'motion' && p.motion_dimensions ? { motionDimensions: p.motion_dimensions } : {}),
      ...(p.visible !== undefined ? { visible: p.visible } : {}),
    }))
  }

  state(id: string): DeviceState {
    const f = this.frame()
    const d = this.devices.find((x) => x.id === id)
    const raw = f.s[id] ?? 0
    const driven = d?.drive ? !!f.y[d.drive] : false

    if (d?.kind === 'carrier') {
      const span = d.span || 1
      const moving = raw - (this.prev[id] ?? raw) > 0.001
      this.prev[id] = raw
      const g = this.machine.geometry
      this.parts = [{
        id: 1,
        blocked: !moving,
        color: PART_COLOR,
        x: g.startX + Math.min(1, Math.max(0, raw / span)) * (g.endX - g.startX),
      }]
      return { pos: moving ? 1 : 0, spin: 0, running: moving, dir: moving ? 1 : 0, detecting: false }
    }

    const prev = this.prev[id] ?? raw
    this.prev[id] = raw
    const dir: -1 | 0 | 1 = raw > prev + 1e-6 ? 1 : raw < prev - 1e-6 ? -1 : 0
    // Raw vacuum state represents physical suction. In placement tasks the
    // drive bit is a release command, so it cannot indicate the hold state.
    const active = d?.ui === 'vacuum' ? raw > 0.5 : driven
    const spin = d?.visual_variant === 'motion-easy-roll' ? raw : d?.ui === 'conveyor' ? raw * Math.PI * 2 : 0
    const detecting = d?.at_max ? !!f.x[d.at_max] : false
    return { pos: raw, spin, running: active, dir, detecting }
  }
}
