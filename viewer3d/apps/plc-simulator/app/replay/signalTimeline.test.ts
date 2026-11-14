import { describe, expect, it } from 'vitest'
import { signalNames, signalPath, signalValue } from './signalTimeline'

describe('replay signals', () => {
  it('keeps observed order and adds missing inputs exactly once', () => {
    expect(signalNames({ observed: ['X20', 'Y20', 'X20'], io: { X20: '', X21: '', Y20: '' } }))
      .toEqual(['X20', 'Y20', 'X21'])
  })
  it('reads X from inputs even when the same address is absent or false in outputs', () => {
    const frame = { x: { X20: 1 }, y: { X20: 0, Y20: 1 } }
    expect(signalValue(frame, 'X20')).toBe(1)
    expect(signalValue(frame, 'Y20')).toBe(1)
    expect(signalValue(frame, 'X99')).toBe(0)
  })
  it.each([
    [[], ''], [[0, 0], ''], [[1], 'M0 0h1v1H0z'],
    [[1, 1, 1], 'M0 0h3v1H0z'], [[0, 1, 1, 0, 1], 'M1 0h2v1H1zM4 0h1v1H4z'],
  ] as [number[], string][] )('preserves run boundaries for %j', (values, path) => {
    expect(signalPath(values)).toBe(path)
  })
  it('preserves every sample for all 8-scan boolean patterns', () => {
    for (let mask = 0; mask < 256; mask++) {
      const values = Array.from({ length: 8 }, (_, i) => (mask >> i) & 1)
      const reconstructed = Array(8).fill(0)
      for (const match of signalPath(values).matchAll(/M(\d+) 0h(\d+)v1H\d+z/g)) {
        reconstructed.fill(1, Number(match[1]), Number(match[1]) + Number(match[2]))
      }
      expect(reconstructed).toEqual(values)
    }
  })
  it('a long held signal does not create per-scan shapes', () => {
    expect(signalPath(Array(1800).fill(1))).toBe('M0 0h1800v1H0z')
  })
  it('places retained one-scan pulses at actual scan positions', () => {
    expect(signalPath([0,1,0,0,1],[0,7,8,10,20])).toBe('M7 0h1v1H7zM20 0h1v1H20z')
    expect(signalPath([1,1,0],[0,10,17])).toBe('M0 0h17v1H0z')
  })
})
