/** Advance the plant model and feed actuator state back into PLC sensor inputs. */
import type { PlcRuntime } from '../plc/runtime/vm'
import type { DeviceSpec } from './infer'
import type { LaidOutMachine } from './layout'

const BELT_SPEED = 0.55

const DETECT_RANGE = 0.22

const PART_GAP = 0.5

export interface DeviceState {

  pos: number

  spin: number

  running: boolean

  dir: -1 | 0 | 1

  detecting: boolean
}

export interface Part {
  id: number

  x: number

  y?: number
  z?: number
  rotation?: [number, number, number]
  orientationMarker?: boolean
  machiningDepths?: [number, number]
  renderVariant?: 'pressure-vessel' | 'slotted-pallet' | 'motion-regrip' | 'rack-load-pallet' | 'v8-can' | `hard-stock-${string}`
  motionDimensions?: [number, number, number]
  materialDimensions?: [number, number, number]
  visible?: boolean

  heldBy?: string | null
  status?: 'idle' | 'held' | 'dropped'

  blocked: boolean
  color: string
}

const PART_COLORS = ['#c98a3c', '#4a9d5f', '#3fa7d6', '#b5563a', '#9b7fd4']

export interface PlantOptions {

  feedIntervalMs: number

  feedWhenStopped: boolean
}

export const defaultPlantOptions: PlantOptions = {
  feedIntervalMs: 3000,
  feedWhenStopped: false,
}

export class Plant {
  states = new Map<string, DeviceState>()
  parts: Part[] = []
  options: PlantOptions = { ...defaultPlantOptions }

  private partSeq = 0
  private sinceFeed = 0

  constructor(public machine: LaidOutMachine) {
    this.reset()
  }

  reset(): void {
    this.states.clear()
    for (const d of this.machine.devices) {
      this.states.set(d.id, {

        pos: 0,
        spin: 0,
        running: false,
        dir: 0,
        detecting: false,
      })
    }
    this.parts = []
    this.partSeq = 0
    this.sinceFeed = 0
  }

  state(id: string): DeviceState {
    let s = this.states.get(id)
    if (!s) {
      s = { pos: 0, spin: 0, running: false, dir: 0, detecting: false }
      this.states.set(id, s)
    }
    return s
  }

  step(rt: PlcRuntime, dtMs: number): void {
    const dt = Math.max(0, dtMs)
    this.moveDevices(rt, dt)
    this.moveParts(rt, dt)
    this.writeFeedback(rt)
  }

  private readBool(rt: PlcRuntime, tag?: string): boolean {
    if (!tag) return false
    const v = rt.get(tag)
    return typeof v === 'boolean' ? v : typeof v === 'number' ? v !== 0 : false
  }

  private moveDevices(rt: PlcRuntime, dt: number): void {
    for (const d of this.machine.devices) {
      const s = this.state(d.id)
      const fwd = this.readBool(rt, d.drive.fwd)
      const rev = this.readBool(rt, d.drive.rev)
      const enable = d.drive.enable ? this.readBool(rt, d.drive.enable) : true

      if (strokes(d)) {

        const twoWay = !!d.drive.rev
        let dir: -1 | 0 | 1 = 0
        if (twoWay) dir = fwd && !rev ? 1 : rev && !fwd ? -1 : 0
        else dir = fwd ? 1 : -1

        if (!enable) dir = 0
        s.dir = dir
        const stroke = Math.max(80, d.strokeMs)
        if (dir !== 0) {
          s.pos = clamp01(s.pos + (dir * dt) / stroke)
        }
        s.running = dir !== 0 && s.pos > 0 && s.pos < 1
        continue
      }

      if (d.motion === 'continuous') {
        const on = (fwd || (!d.drive.fwd && enable && rev)) && enable
        const reverse = rev && !fwd
        s.running = on || reverse
        s.dir = reverse ? -1 : on ? 1 : 0

        let rate = 1
        if (d.drive.speed) {
          const v = rt.get(d.drive.speed)
          if (typeof v === 'number' && v > 0) rate = Math.min(2, v / 50)
        }
        if (s.running) s.spin += (s.dir * rate * dt) / 1000 * Math.PI * 2
        s.pos = s.running ? 1 : 0
        continue
      }

      // discrete / operator
      s.running = fwd || (enable && !d.drive.fwd && rev)
      s.dir = s.running ? 1 : 0
      s.pos = s.running ? 1 : 0
    }
  }

  private beltRateAt(x: number): number {
    for (const seg of this.machine.geometry.segments) {
      if (x < seg.x0 - 0.05 || x > seg.x1 + 0.05) continue
      const s = this.states.get(seg.id)
      if (!s?.running) return 0
      return s.dir >= 0 ? 1 : -1
    }
    return 0
  }

  private activeStoppers(): number[] {
    const out: number[] = []
    for (const d of this.machine.devices) {
      if (d.kind !== 'cylinder' && d.kind !== 'stopper' && d.kind !== 'clamp' && d.kind !== 'press') continue
      const s = this.state(d.id)
      if (s.pos > 0.6) out.push(d.pos[0])
    }
    return out
  }

  private moveParts(rt: PlcRuntime, dt: number): void {
    const { startX, endX } = this.machine.geometry
    const stoppers = this.activeStoppers()

    this.sinceFeed += dt
    const lineRunning = this.beltRateAt(startX + 0.1) > 0
    const feederOn = this.machine.devices.some(
      (d) => d.kind === 'feeder' && this.state(d.id).running,
    )
    const wantFeed =
      this.options.feedIntervalMs > 0 &&
      this.sinceFeed >= this.options.feedIntervalMs &&
      (feederOn || lineRunning || this.options.feedWhenStopped)

    if (wantFeed) {
      const headroom = this.parts.every((p) => p.x > startX + PART_GAP)
      if (headroom) {
        this.parts.push({
          id: ++this.partSeq,
          x: startX,
          blocked: false,
          color: PART_COLORS[this.partSeq % PART_COLORS.length],
        })
        this.sinceFeed = 0
      }
    }

    const sorted = [...this.parts].sort((a, b) => b.x - a.x)
    let aheadX = Infinity
    for (const p of sorted) {
      const rate = this.beltRateAt(p.x)
      p.blocked = false
      if (rate === 0) {
        aheadX = p.x
        continue
      }
      let nx = p.x + (rate * BELT_SPEED * dt) / 1000

      if (nx > aheadX - PART_GAP) {
        nx = Math.min(nx, aheadX - PART_GAP)
        p.blocked = true
      }

      for (const sx of stoppers) {
        if (p.x <= sx - 0.02 && nx > sx - DETECT_RANGE * 0.6) {
          nx = sx - DETECT_RANGE * 0.6
          p.blocked = true
        }
      }
      p.x = nx
      aheadX = p.x
    }

    this.parts = this.parts.filter((p) => p.x <= endX + 0.4)
  }

  private writeFeedback(rt: PlcRuntime): void {
    for (const d of this.machine.devices) {
      const s = this.state(d.id)

      if (strokes(d)) {
        if (d.feedback.atMax) rt.set(d.feedback.atMax, s.pos >= 0.985)
        if (d.feedback.atMin) rt.set(d.feedback.atMin, s.pos <= 0.015)
      }
      if (d.feedback.running) rt.set(d.feedback.running, s.running)
      if (d.feedback.fault) {

      }
      if (d.feedback.present) {
        const detected = this.partNear(d.pos[0])
        s.detecting = detected
        rt.set(d.feedback.present, detected)
      } else {
        s.detecting = d.kind === 'sensor' ? this.partNear(d.pos[0]) : false
      }
    }
  }

  private partNear(x: number): boolean {
    return this.parts.some((p) => Math.abs(p.x - x) <= DETECT_RANGE)
  }

  addPart(): void {
    const { startX } = this.machine.geometry
    this.parts.push({
      id: ++this.partSeq,
      x: startX,
      blocked: false,
      color: PART_COLORS[this.partSeq % PART_COLORS.length],
    })
  }

  clearParts(): void {
    this.parts = []
  }
}

function strokes(d: DeviceSpec): boolean {
  if (d.motion === 'linear') return true
  return d.motion === 'discrete' && !!(d.feedback.atMax || d.feedback.atMin)
}

function clamp01(v: number): number {
  return v < 0 ? 0 : v > 1 ? 1 : v
}

export function describeState(d: DeviceSpec, s: DeviceState): string {
  switch (d.motion) {
    case 'linear':
      if (s.pos >= 0.985) return 'Extended'
      if (s.pos <= 0.015) return 'Retracted'
      return `Moving ${Math.round(s.pos * 100)}%`
    case 'continuous':
      return s.running ? (s.dir < 0 ? 'Reverse' : 'Running') : 'Stopped'
    default:
      return s.running ? 'ON' : 'OFF'
  }
}
