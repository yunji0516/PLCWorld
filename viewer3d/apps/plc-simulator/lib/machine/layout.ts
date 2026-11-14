/** Place inferred machine devices in a 3D coordinate system. */
import type { DeviceSpec, MachineSpec } from './infer'
import type { DeviceKind } from './vocab'

const CONV_LEN = 2.6
const CONV_H = 0.75
const CONV_W = 0.72

const STATION_KINDS: DeviceKind[] = [
  'servo', 'cylinder', 'stopper', 'clamp', 'press', 'spindle', 'gripper', 'vacuum', 'lift', 'vertical_slide', 'fixture', 'support_frame', 'rack', 'fork', 'turntable', 'robot', 'feeder',
]

const UTILITY_KINDS: DeviceKind[] = ['pump', 'valve', 'heater', 'motor']

export interface LineGeometry {

  startX: number
  endX: number

  beltY: number

  segments: { id: string; x0: number; x1: number }[]

  view: CameraView
}

export interface CameraView {

  dist: number

  target: [number, number, number]
  /** Declared working front; omitted layouts retain the existing +Z view. */
  frontSign?: 1 | -1
  cutaway?: boolean
}

function frameDevices(devices: DeviceSpec[], fovDeg = 42): CameraView {
  if (devices.length === 0) return { dist: 6, target: [0, 0.8, 0] }

  let minX = Infinity, maxX = -Infinity
  let minY = Infinity
  let minZ = Infinity, maxZ = -Infinity
  let maxY = 0
  for (const d of devices) {
    minX = Math.min(minX, d.pos[0] - d.size[0] / 2)
    maxX = Math.max(maxX, d.pos[0] + d.size[0] / 2)
    minY = Math.min(minY, d.pos[1] - d.size[1] / 2)
    minZ = Math.min(minZ, d.pos[2] - d.size[2] / 2)
    maxZ = Math.max(maxZ, d.pos[2] + d.size[2] / 2)
    maxY = Math.max(maxY, d.pos[1] + d.size[1] / 2)
  }

  const radius = 0.5 * Math.max(
    Math.hypot(maxX - minX, maxZ - minZ),
    maxY - minY,
  )
  const fov = (fovDeg * Math.PI) / 180
  const dist = (radius / Math.tan(fov / 2)) * 1.15

  const view: CameraView = {
    dist: Number.isFinite(dist) ? Math.max(2.8, dist) : 6,
    target: [(minX + maxX) / 2, (minY + maxY) / 2, (minZ + maxZ) / 2],
  }

  if (!view.target.every(Number.isFinite)) return { dist: 6, target: [0, 0.8, 0] }
  return view
}

export interface LaidOutMachine extends MachineSpec {
  geometry: LineGeometry
}

export function layoutMachine(
  spec: MachineSpec,
  transforms?: Record<string, { pos?: [number, number, number]; rot?: number; size?: [number, number, number] }>,
): LaidOutMachine {
  const devices = spec.devices.map((d) => ({ ...d }))
  const conveyors = devices.filter((d) => d.kind === 'conveyor')
  const stations = devices.filter((d) => STATION_KINDS.includes(d.kind))
  const utilities = devices.filter((d) => UTILITY_KINDS.includes(d.kind))
  const doors = devices.filter((d) => d.kind === 'door')
  const lamps = devices.filter((d) => d.kind === 'lamp')
  const sensors = devices.filter((d) => d.kind === 'sensor')

  const segments: LineGeometry['segments'] = []
  const convCount = Math.max(conveyors.length, 1)
  const totalLen = convCount * CONV_LEN
  let x = -totalLen / 2

  conveyors.forEach((c) => {
    c.pos = [x + CONV_LEN / 2, CONV_H, 0]
    c.size = [CONV_LEN, 0.16, CONV_W]
    c.rot = 0
    segments.push({ id: c.id, x0: x, x1: x + CONV_LEN })
    x += CONV_LEN
  })

  const startX = -totalLen / 2
  const endX = conveyors.length ? x : totalLen / 2

  const slots = stations.length + 1
  stations.forEach((d, i) => {
    const sx = startX + ((i + 1) / slots) * (endX - startX)
    switch (d.kind) {
      case 'servo':
        d.pos = [sx, CONV_H + 0.12, 0]
        d.size = [1.8, 0.3, 0.5]
        d.rot = 0
        break
      case 'cylinder':
      case 'gripper':

        d.pos = [sx, CONV_H + 0.28, CONV_W / 2 + 0.45]
        d.size = [0.14, 0.14, 0.55]
        d.rot = 0
        break
      case 'stopper':
        d.pos = [sx, CONV_H - 0.06, 0]
        d.size = [0.2, 0.32, CONV_W * 0.86]
        d.rot = 0
        break
      case 'clamp':
        d.pos = [sx, CONV_H + 0.22, 0]
        d.size = [0.32, 0.3, 0.5]
        break
      case 'press':
        d.pos = [sx, CONV_H + 1.15, 0]
        d.size = [0.6, 0.9, 0.6]
        break
      case 'spindle':
        d.pos = [sx, CONV_H + 1.05, 0]
        d.size = [0.24, 0.8, 0.24]
        break
      case 'lift':
        d.pos = [sx, CONV_H - 0.35, 0]
        d.size = [0.8, 0.7, 0.8]
        break
      case 'vertical_slide':
        d.pos = [sx, CONV_H + 0.85, 0.45]
        d.size = [0.5, 1.2, 0.35]
        break
      case 'fixture':
        d.pos = [sx, CONV_H - 0.1, 0]
        d.size = [0.8, 0.55, 0.7]
        break
      case 'support_frame':
        d.pos = [sx, 1.1, 0.45]
        d.size = [1.2, 2.2, 0.35]
        break
      case 'turntable':
        d.pos = [sx, CONV_H + 0.05, 0]
        d.size = [1.1, 0.14, 1.1]
        break
      case 'robot':
        d.pos = [sx, 0.0, -1.25]
        d.size = [0.5, 1.6, 0.5]
        break
      case 'feeder':
        d.pos = [startX - 0.5, CONV_H + 0.6, 0]
        d.size = [0.7, 0.8, 0.7]
        break
    }
  })

  utilities.forEach((d, i) => {
    const ux = startX + 0.6 + i * 0.85
    d.pos = [Math.min(ux, endX - 0.4), 0.42, 1.85]
    d.size = [0.5, 0.62, 0.45]
  })

  doors.forEach((d, i) => {
    d.pos = [0, CONV_H + 0.55, -1.35 - i * 0.25]
    d.size = [Math.max(2.4, endX - startX), 1.7, 0.08]
  })

  lamps.forEach((d, i) => {
    d.pos = [endX + 0.55, 1.35, 0.9 + i * 0.45]
    d.size = [0.14, 0.75, 0.14]
  })

  const stationXs = stations
    .filter((s) => s.kind !== 'feeder' && s.kind !== 'robot')
    .map((s) => s.pos[0])
    .sort((a, b) => a - b)

  sensors.forEach((d, i) => {
    const sx = stationXs.length
      ? stationXs[i % stationXs.length] - 0.25
      : startX + ((i + 0.5) / Math.max(sensors.length, 1)) * (endX - startX)
    d.pos = [sx, CONV_H + 0.2, CONV_W / 2 + 0.12]
    d.size = [0.09, 0.14, 0.09]
  })

  devices.forEach((d, i) => {
    if (d.pos[0] === 0 && d.pos[1] === 0 && d.pos[2] === 0) {
      d.pos = [startX + i * 0.7, 0.4, 2.6]
      d.size = [0.45, 0.5, 0.45]
    }
  })

  if (transforms) {
    for (const d of devices) {
      const t = transforms[d.id]
      if (!t) continue
      if (t.pos) d.pos = [...t.pos]
      if (typeof t.rot === 'number') d.rot = t.rot
      if (t.size) d.size = [...t.size]
    }
  }

  const movedSegments = devices
    .filter((d) => d.kind === 'conveyor')
    .map((d) => ({ id: d.id, x0: d.pos[0] - d.size[0] / 2, x1: d.pos[0] + d.size[0] / 2 }))
    .sort((a, b) => a.x0 - b.x0)

  const finalSegments = movedSegments.length ? movedSegments : segments
  const lineStart = finalSegments.length ? finalSegments[0].x0 : startX
  const lineEnd = finalSegments.length ? finalSegments[finalSegments.length - 1].x1 : endX

  return {
    ...spec,
    devices,
    geometry: {
      startX: lineStart,
      endX: lineEnd,
      beltY: CONV_H,
      segments: finalSegments,
      view: frameDevices(devices),
    },
  }
}
