import { describe, expect, it } from 'vitest'
import type { Frame } from './adapter'
import { indexTendingMeasurements, tendingMeasurementsAt, tendingLocation } from './tendingQuality'

function frame(token = 0, valid = false, depths = [6000, 6000], measuring = false): Frame {
  return { k: 0, x: {}, y: {}, s: {}, v: 0, world: { devices: {}, parts: {}, tending: {
    cells: {}, robot: 0, buffer: 0, delivered: 0, resultToken: token, resultValid: valid, depths, measuring,
  } } }
}

describe('recorded tending quality history', () => {
  it('retains per-part readings, deduplicates valid levels, and hides future results on rewind', () => {
    const records = indexTendingMeasurements([frame(), frame(1, true), frame(1, true), frame(2, false, [5500, 6000], true), frame(2, true, [5500, 6000])])
    expect(records.map(r => r.frame)).toEqual([1, 4])
    expect(tendingMeasurementsAt(records, 4).get(1)?.good).toBe(true)
    expect(tendingMeasurementsAt(records, 4).get(2)?.good).toBe(false)
    expect(tendingMeasurementsAt(records, 3).has(2)).toBe(false)
    expect(tendingMeasurementsAt(records, 0).size).toBe(0)
  })
  it('uses both measured depths and inclusive limits, never a fixed two/two split', () => {
    const good = indexTendingMeasurements([1, 2, 3, 4].map(id => frame(id, true, [5800, 6200])))
    expect(good.every(r => r.good)).toBe(true)
    const bad = indexTendingMeasurements([frame(1, true, [5799, 6000]), frame(2, true, [6000, 6201])])
    expect(bad.every(r => !r.good)).toBe(true)
  })
  it('does not inherit another candidate’s readings and ignores in-progress/invalid measurements', () => {
    expect(indexTendingMeasurements([frame(1, true, [6000, 6000], true), frame(1, false), frame()])).toEqual([])
    expect(indexTendingMeasurements([frame(1, true, [6000])])).toEqual([])
    expect(tendingMeasurementsAt(indexTendingMeasurements([frame()]), 0).size).toBe(0)
  })
  it('distinguishes actual holding locations from the required destination', () => {
    expect(tendingLocation('buffer')).toBe('Temporary waiting fixture')
    expect(tendingLocation('reject_1')).toBe('Rejected quarantine · slot 2')
    expect(tendingLocation('outfeed')).toBe('Accepted outfeed')
    expect(tendingLocation('tool')).toBe('In robot transit')
  })
})
