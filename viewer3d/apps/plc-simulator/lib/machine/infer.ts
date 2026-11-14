/** Infer machine devices from PLC tag names, declaration comments, and read/write usage. */
import type { IecType } from '../plc/types'
import {
  FEEDBACK_MARKS, KIND_INFO, KIND_RULES, NEUTRAL_TOKENS, OPERATOR_WORDS, ROLE_TOKENS,
  matchesToken, tokenizeName,
  type DeviceKind, type Motion, type Role,
} from './vocab'

export interface TagRef {
  name: string
  key: string
  type: IecType

  scope: string
  comment?: string
  address?: string
}

export interface WebGeometry {
  thickness_m: number; jaw_open_m: number; jaw_height_m: number
  roller_radius_m: number; marker_origin_x: number; marker_pitch_m: number
}

export interface DeviceSpec {
  webGeometry?: WebGeometry
  id: string
  kind: DeviceKind
  motion: Motion
  label: string
  /** Opt-in local anchor for a named synthetic Material mechanism. */
  sceneLabelOffset?: [number, number, number]

  index: number
  drive: { fwd?: string; rev?: string; enable?: string; speed?: string }
  feedback: { atMax?: string; atMin?: string; present?: string; running?: string; fault?: string }

  strokeMs: number

  evidence: string[]
  confidence: number
  color: string

  pos: [number, number, number]
  rot: number
  size: [number, number, number]

  motionAxis?: 'x' | 'y' | 'z'

  stateDisplay?: { kind: 'count'; scale: number; label: string }

  actuatorRef?: string
  /** Public replay mounting relation, used only to fit visual connection brackets. */
  mountedOn?: string
  /** Opt-in rigid pose recorded by the Motion assembly projector. */
  replayQuaternion?: [number, number, number, number]
  replayPoseRotation?: boolean

  rodBaseExtension?: number

  sensorVisual?: 'photoeye' | 'limit' | 'slot' | 'pressure' | 'proximity'
  /** Material replay only; leave Motion and ordinary simulation visuals intact. */
  clipPhotoeyeBeam?: boolean
  /** Opt-in composite geometry used only by Material's turnover task. */
  visualVariant?: 'motion-hard-cell' | `cell3-${string}` | `easy15-${string}` | `v13-${string}` | 'turnover-drive' | 'turnover-jaws' | 'single-vacuum-cup' | 'wide-stroke' | 'material-taught-arm' | 'material-pallet-locator' | 'material-locator-pallet' | 'material-contact-height-gauge' | 'machining-spindle' | 'single-pocket-index' | 'compact-transfer-belt' | 'quarter-turn-base' | 'pressure-seal-head' | 'pressure-test-module' | 'test-air-valve' | 'material-sized-slot' | 'material-limit-sensor' | 'material-fork-clearance-rack' | 'material-rack-mast' | 'hard-workbench' | 'hard-sliding-door' | 'hard-locator-surround' | 'hard-fixture-clamp' | 'hard-spindle' | 'hard-probe' | 'hard-feed-belt' | 'hard-control-cabinet' | 'material-pallet-rack' | 'web-index-base' | 'web-feed-carriage' | 'web-moving-grip' | 'web-receiver-clamp' | 'web-meter-roll' | 'web-strip' | 'web-target' | 'material-vacuum-mast' | 'v6-orientation-base' | 'v6-datum-base' | 'v6-classification-base' | 'v6-vacuum-head' | 'v6-sort-gripper' | 'v6-z-slide' | 'v6-datum-z-slide' | 'v6-buffer-base' | 'v6-buffer-ribbon' | 'v6-buffer-dancer' | 'v6-buffer-spool' | 'v6-buffer-feeder' | 'v6-buffer-receiver' | 'v6-buffer-target' | 'v6-stack-base' | 'v6-stack-slide' | 'v6-stack-table' | 'v6-swing-arm' | 'v6-pocket-key' | 'v6-align-x' | 'v6-align-z' | 'motion-easy-roll' | 'motion-reference-dog' | 'motion-home-probe' | 'motion-holding-brake' | 'motion-v08-articulated' | 'motion-v08-index_pin' | 'motion-v08-table_slide' | 'motion-v08-scissor' | 'motion-v08-door_recovery' | 'motion-v08-telescopic' | 'motion-v08-mobile' | 'motion-v08-hoist' | 'motion-v08-counterbalance' | 'motion-v08-crank' | 'motion-v08-hexapod' | 'v7-dose-base' | 'v7-pitch-base' | 'v7-magazine-base' | 'v7-handshake-base' | 'v7-selective-base' | 'v7-nozzle' | 'v7-valve' | 'v7-liquid' | 'v7-tank' | 'v7-carriage' | 'v7-pitch-crosshead' | 'v7-selective-crosshead' | 'v7-head' | 'v7-pitch-receiver' | 'v7-rack' | 'v7-pusher' | 'v7-sender' | 'v7-receiver' | 'v8-aperture-base' | 'v8-balance-base' | 'v8-balance-head' | 'v8-balance-tray' | 'v8-board-pusher' | 'v8-bridge-base' | 'v8-carousel' | 'v8-carousel-base' | 'v8-carousel-pusher' | 'v8-content-line' | 'v8-conveyor-drive' | 'v8-diverter-valve' | 'v8-edge-web' | 'v8-edgeguide-base' | 'v8-gantry-carriage' | 'v8-intercept-base' | 'v8-lineidentity-base' | 'v8-liquid-level' | 'v8-mouth-pad' | 'v8-moving-pocket' | 'v8-netflow-base' | 'v8-pairjoin-base' | 'v8-pairjoin-base-v2' | 'v8-pair-transfer' | 'v8-pouch' | 'v8-receiver-nip' | 'v8-routing-drive' | 'v8-skeleton-base' | 'v8-small-pusher' | 'v8-steering-roll' | 'v8-support-bridge' | 'v8-vacuum-bed' | 'v8-scrap-platen' | 'v8-vacuum-head'

  sensorBeamLength?: number
  /** Optional world-space optical target for inclined synthetic photoeyes. */
  sensorTarget?: [number, number, number]
  /** Visual mechanical calibration only; never alters PLC/plant progress or verdict. */
  pressMaxTravel?: number
  fixtureTopOffset?: number
  sensorReceiver?: boolean

  sensorPurpose?: string
}

export interface OperatorControl {
  tag: string
  role: string
  label: string
  kind: 'button' | 'selector' | 'estop' | 'lamp'

  momentary: boolean
}

export interface MachineSpec {
  title: string
  replaySuite?: 'material' | 'motion' | 'test'
  /** Fixed operator-side floor paint; independent of the interactive camera. */
  floorFrontSign?: 1 | -1
  devices: DeviceSpec[]
  controls: OperatorControl[]

  unmatched: string[]
  notes: string[]
}

export interface UsageInfo {

  writes: Set<string>

  reads: Set<string>
}

type Direction = 'out' | 'in'

interface Analyzed {
  tag: TagRef
  tokens: string[]

  base: string
  baseTokens: string[]
  roles: Role[]
  isFeedback: boolean
  dir: Direction
  text: string
  index: number
}

const OPERATOR_ROLE_BY_TOKEN = new Map<string, { role: string; label: string }>()
for (const o of OPERATOR_WORDS) {
  for (const t of o.tokens) OPERATOR_ROLE_BY_TOKEN.set(t.toUpperCase(), { role: o.role, label: o.label })
}

function analyze(tag: TagRef, usage: UsageInfo): Analyzed {
  const tokens = tokenizeName(tag.name)
  const text = `${tag.name} ${tag.comment ?? ''}`.toUpperCase()

  let dir: Direction
  if (tag.scope === 'input') dir = 'in'
  else if (tag.scope === 'output') dir = 'out'
  else if (tag.address?.startsWith('%I')) dir = 'in'
  else if (tag.address?.startsWith('%Q')) dir = 'out'
  else dir = usage.writes.has(tag.key) ? 'out' : 'in'

  const work = [...tokens]
  const roles: Role[] = []
  let isFeedback = false

  for (let guard = 0; guard < 6 && work.length > 1; guard++) {
    const last = work[work.length - 1]

    if (NEUTRAL_TOKENS.includes(last)) {
      work.pop()
      continue
    }
    if (FEEDBACK_MARKS.some((m) => matchesToken(last, m))) {
      isFeedback = true
      work.pop()
      continue
    }

    const hit = ROLE_TOKENS.find((rt) => rt.tokens.some((t) => matchesToken(last, t)))
    if (hit) {
      roles.push(hit.role)
      if (hit.role === 'atMax' || hit.role === 'atMin') isFeedback = true
      work.pop()
      continue
    }
    break
  }

  if (roles.length === 0 && tag.comment) {
    const ct = tag.comment.toUpperCase()
    const hit = ROLE_TOKENS.find((rt) =>
      rt.tokens.some((t) => new RegExp(`\\b${t}\\b`).test(ct)),
    )
    if (hit) roles.push(hit.role)
  }

  const idxTok = [...tokens].reverse().find((t) => /^\d+$/.test(t))
  return {
    tag,
    tokens,
    base: work.join('_'),
    baseTokens: work,
    roles,
    isFeedback,
    dir,
    text,
    index: idxTok ? Number(idxTok) : 0,
  }
}

export function containsKeyword(text: string, kw: string): boolean {
  let from = 0
  for (;;) {
    const i = text.indexOf(kw, from)
    if (i < 0) return false
    const before = i > 0 ? text[i - 1] : ''
    const after = i + kw.length < text.length ? text[i + kw.length] : ''
    if (!/[A-Z]/.test(before) && !/[A-Z]/.test(after)) return true
    from = i + 1
  }
}

function scoreKind(texts: string[]): { kind: DeviceKind; weight: number; hit: string } | null {
  let best: { kind: DeviceKind; weight: number; hit: string } | null = null
  for (const rule of KIND_RULES) {
    for (const kw of rule.keywords) {
      const found = texts.some((t) => containsKeyword(t, kw))
      if (!found) continue

      const w = rule.weight + kw.length * 0.1
      if (!best || w > best.weight) best = { kind: rule.kind, weight: w, hit: kw }
    }
  }
  return best
}

function asControl(a: Analyzed): OperatorControl | null {

  const words = [...a.baseTokens, ...a.tokens]
  const estop = words.some((w) => ['EMG', 'ESTOP', 'EMO', 'EMSTOP'].includes(w))
  if (estop) {
    return { tag: a.tag.name, role: 'estop', label: 'Emergency stop', kind: 'estop', momentary: false }
  }
  if (a.baseTokens.length > 0) {

    const single = a.baseTokens.length === 1 ? OPERATOR_ROLE_BY_TOKEN.get(a.baseTokens[0]) : undefined
    if (!single) return null
    if (a.dir !== 'in') return null
    return { tag: a.tag.name, role: single.role, label: single.label, kind: 'button', momentary: single.role !== 'auto' && single.role !== 'manual' }
  }

  const hit = a.tokens.map((t) => OPERATOR_ROLE_BY_TOKEN.get(t)).find(Boolean)
  if (!hit) return null
  if (a.dir === 'out') {
    return { tag: a.tag.name, role: hit.role, label: hit.label, kind: 'lamp', momentary: false }
  }
  const selector = hit.role === 'auto' || hit.role === 'manual'
  return { tag: a.tag.name, role: hit.role, label: hit.label, kind: selector ? 'selector' : 'button', momentary: !selector }
}

function labelFor(base: string, kind: DeviceKind, index: number, comments: string[]): string {

  for (const c of comments) {
    const cleaned = c.replace(/[(（].*?[)）]/g, '').trim()

    if (cleaned.length >= 2 && cleaned.length <= 20) return cleaned
  }
  const kindLabel = KIND_INFO[kind].label
  const n = index || 0
  if (!base) return n ? `${kindLabel} ${n}` : kindLabel
  return n ? `${kindLabel} ${n}` : `${kindLabel} (${base})`
}

export function inferMachine(tags: TagRef[], usage: UsageInfo, title = 'Inferred machine'): MachineSpec {
  const analyzed = tags

    .filter((t) => t.type === 'BOOL' || t.type === 'INT' || t.type === 'DINT' || t.type === 'REAL')
    .map((t) => analyze(t, usage))

  const controls: OperatorControl[] = []
  const groups = new Map<string, Analyzed[]>()
  const unmatched: string[] = []

  const hasDeclaredIO = tags.some(
    (t) => t.scope === 'input' || t.scope === 'output' || !!t.address,
  )

  for (const a of analyzed) {
    const ctrl = asControl(a)
    if (ctrl) {
      controls.push(ctrl)
      continue
    }
    if (!a.base) {
      unmatched.push(a.tag.name)
      continue
    }
    const key = a.base.toUpperCase()
    const list = groups.get(key)
    if (list) list.push(a)
    else groups.set(key, [a])
  }

  const devices: DeviceSpec[] = []

  for (const [base, members] of groups) {
    const texts = members.map((m) => m.text)
    const scored = scoreKind(texts)
    const outs = members.filter((m) => m.dir === 'out')
    const ins = members.filter((m) => m.dir === 'in')

    const isPhysical =
      !!scored ||
      members.some((m) => m.tag.scope === 'input' || m.tag.scope === 'output' || !!m.tag.address)
    if (hasDeclaredIO && !isPhysical) {
      members.forEach((m) => unmatched.push(m.tag.name))
      continue
    }

    let kind: DeviceKind
    let confidence: number
    const evidence: string[] = []

    if (scored) {
      kind = scored.kind
      confidence = 0.9
      evidence.push(`Name or comment matches '${scored.hit}'`)
    } else if (outs.some((o) => o.roles.includes('fwd')) && (outs.some((o) => o.roles.includes('rev')) || ins.some((i) => i.roles.includes('atMax') || i.roles.includes('atMin')))) {
      kind = 'cylinder'
      confidence = 0.6
      evidence.push('Forward/reverse outputs with limit inputs imply a two-position actuator')
    } else if (outs.length > 0 && ins.length === 0) {
      kind = 'motor'
      confidence = 0.4
      evidence.push('Outputs without feedback imply a simple on/off drive')
    } else if (outs.length === 0) {
      kind = 'sensor'
      confidence = 0.5
      evidence.push('Read-only in the program; treated as a sensor')
    } else {
      kind = 'motor'
      confidence = 0.35
      evidence.push('Limited evidence; treated as a generic drive')
    }

    if (kind === 'button' || kind === 'estop') {
      for (const m of members) {
        const isLamp = m.dir === 'out'
        controls.push({
          tag: m.tag.name,
          role: kind === 'estop' ? 'estop' : 'manual',
          label: m.tag.comment?.slice(0, 12) || m.tag.name,
          kind: kind === 'estop' ? 'estop' : isLamp ? 'lamp' : 'button',
          momentary: kind !== 'estop' && !isLamp,
        })
      }
      continue
    }

    const info = KIND_INFO[kind]

    const drive: DeviceSpec['drive'] = {}
    const feedback: DeviceSpec['feedback'] = {}

    for (const m of outs) {
      const name = m.tag.name
      if (m.tag.type !== 'BOOL' || m.roles.includes('speed')) {
        if (!drive.speed && m.tag.type !== 'BOOL') drive.speed = name
        continue
      }
      if (m.roles.includes('fwd') && !drive.fwd) drive.fwd = name
      else if (m.roles.includes('rev') && !drive.rev) drive.rev = name
      else if (m.roles.includes('enable') && !drive.enable) drive.enable = name
      else if (!drive.fwd) drive.fwd = name
      else if (!drive.rev) drive.rev = name
    }

    let invertedFeedback = false
    const boolOuts = outs.filter((m) => m.tag.type === 'BOOL' && !m.roles.includes('speed'))
    if (!drive.fwd && drive.rev && boolOuts.length === 1) {
      drive.fwd = drive.rev
      drive.rev = undefined
      invertedFeedback = true
      evidence.push('Single output treated as the command for a spring-return actuator')
    }

    for (const m of ins) {
      const name = m.tag.name

      const fwdRole = invertedFeedback ? 'rev' : 'fwd'
      const revRole = invertedFeedback ? 'fwd' : 'rev'
      const maxRole = invertedFeedback ? 'atMin' : 'atMax'
      const minRole = invertedFeedback ? 'atMax' : 'atMin'

      if (m.roles.includes(maxRole) || (m.isFeedback && m.roles.includes(fwdRole))) feedback.atMax ??= name
      else if (m.roles.includes(minRole) || (m.isFeedback && m.roles.includes(revRole))) feedback.atMin ??= name
      else if (m.roles.includes('present')) feedback.present ??= name
      else if (m.roles.includes('running')) feedback.running ??= name
      else if (m.roles.includes('fault')) feedback.fault ??= name
      else feedback.present ??= name
    }

    if (drive.fwd) evidence.push(`Forward output ${drive.fwd}`)
    if (drive.rev) evidence.push(`Reverse output ${drive.rev}`)
    if (feedback.atMax) evidence.push(`Forward limit ${feedback.atMax}`)
    if (feedback.atMin) evidence.push(`Reverse limit ${feedback.atMin}`)

    if (info.motion === 'linear' && !feedback.atMax && !feedback.atMin) {
      evidence.push('No limit input; movement is time-based')
      confidence = Math.min(confidence, 0.7)
    }

    const index = members.map((m) => m.index).find((n) => n > 0) ?? 0
    const comments = members.map((m) => m.tag.comment).filter((c): c is string => !!c)

    devices.push({
      id: base,
      kind,
      motion: info.motion,
      label: labelFor(base, kind, index, comments),
      index,
      drive,
      feedback,
      strokeMs: info.strokeMs,
      evidence,
      confidence,
      color: info.color,
      pos: [0, 0, 0],
      rot: 0,
      size: [1, 1, 1],
    })
  }

  const notes: string[] = []
  if (devices.length === 0) {
    notes.push('No output tags identify a moving device. Declare an actuator in VAR_OUTPUT or add a descriptive comment.')
  }

  const ORDER: DeviceKind[] = ['feeder', 'conveyor', 'stopper', 'cylinder', 'clamp', 'press', 'spindle', 'lift', 'turntable', 'robot', 'gripper', 'door', 'valve', 'pump', 'heater', 'motor', 'sensor', 'lamp', 'button', 'estop']
  devices.sort((a, b) => {
    const d = ORDER.indexOf(a.kind) - ORDER.indexOf(b.kind)
    return d !== 0 ? d : a.index - b.index || a.id.localeCompare(b.id)
  })

  const seen = new Set<string>()
  const dedupControls = controls.filter((c) => {
    const k = c.tag.toUpperCase()
    if (seen.has(k)) return false
    seen.add(k)
    return true
  })

  return { title, devices, controls: dedupControls, unmatched, notes }
}
