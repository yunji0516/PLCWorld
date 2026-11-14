import { expect, it } from 'vitest'
import type { Frame } from '@/lib/replay/adapter'
import { latestReplayEvent } from './eventHistory'

const frames: Frame[] = [[], ['acquired'], [], ['lifted'], []].map((events, k) => ({
  k, x: {}, y: {}, s: {}, v: 0, world: { devices: {}, parts: {}, events },
}))

it('keeps the last event between events and after completion', () => {
  expect(latestReplayEvent(frames, 2)).toEqual({ scan: 1, events: ['acquired'] })
  expect(latestReplayEvent(frames, 4)).toEqual({ scan: 3, events: ['lifted'] })
})
it('seeking backwards never shows a future event', () => {
  expect(latestReplayEvent(frames, 0)).toBeNull()
  expect(latestReplayEvent(frames, 1)?.events).toEqual(['acquired'])
})
it('has no stale events when switching to a trace without events', () => {
  expect(latestReplayEvent([], 10)).toBeNull()
  expect(latestReplayEvent([{ k: 0, x: {}, y: {}, s: {}, v: 0 }], 0)).toBeNull()
})
