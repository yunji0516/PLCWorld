import type { Frame } from '@/lib/replay/adapter'

/** Derive from the selected trace/scan, so seeking backwards cannot show future events. */
export function latestReplayEvent(frames: Frame[], scan: number) {
  for (let index = Math.min(scan, frames.length - 1); index >= 0; index--) {
    const events = frames[index].world?.events
    if (events?.length) return { scan: index, events }
  }
  return null
}
