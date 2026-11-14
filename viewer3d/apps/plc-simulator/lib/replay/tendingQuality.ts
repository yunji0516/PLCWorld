import type { Frame } from './adapter'

export interface TendingMeasurement {
  frame: number
  token: number
  depths: number[]
  good: boolean
}

// Index recorded, valid measurements only. Never use latent machining depths
// or future results to label an unmeasured part during playback/rewind.
export function indexTendingMeasurements(frames: Frame[]): TendingMeasurement[] {
  const records: TendingMeasurement[] = []
  frames.forEach((frame, index) => {
    const q = frame.world?.tending
    const previous = frames[index - 1]?.world?.tending
    if (!q?.resultValid || q.measuring || !q.resultToken || q.depths.length !== 2) return
    if (previous?.resultValid && !previous.measuring && previous.resultToken === q.resultToken
      && previous.depths.every((depth, i) => depth === q.depths[i])) return
    records.push({ frame: index, token: q.resultToken, depths: [...q.depths],
      good: q.depths.every(depth => Number.isFinite(depth) && depth >= 5800 && depth <= 6200) })
  })
  return records
}

export function tendingMeasurementsAt(records: TendingMeasurement[], frame: number) {
  const visible = new Map<number, TendingMeasurement>()
  for (const record of records) {
    if (record.frame > frame) break
    visible.set(record.token, record)
  }
  return visible
}

export function tendingLocation(owner?: string) {
  if (owner?.startsWith('reject_')) return `Rejected quarantine · slot ${Number(owner.slice(7)) + 1}`
  return ({ source_a: 'A source', source_b: 'B source', cell_a: 'Machining cell A', cell_b: 'Machining cell B',
    tool: 'In robot transit', inspection: 'Inspection fixture', buffer: 'Temporary waiting fixture',
    outfeed: 'Accepted outfeed', dropped: 'Grip lost' } as Record<string, string>)[owner ?? ''] ?? 'Location unknown'
}
