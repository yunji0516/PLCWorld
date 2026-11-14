import { describe, expect, it } from 'vitest'
import { replayShadowSettings } from './shadowSettings'
import { WORKPIECE_SIZE } from './deviceGeometry'

describe('replay shadow depth calibration', () => {
  it.each(['material', 'motion'])('limits %s depth and normal offsets to a small fraction of a workpiece', suite => {
    const s = replayShadowSettings(suite)
    expect(s.far).toBeGreaterThan(s.near)
    expect(Math.abs(s.bias) * (s.far - s.near)).toBeLessThan(WORKPIECE_SIZE / 32)
    expect(s.normalBias).toBeLessThan(WORKPIECE_SIZE / 32)
    // Existing light is at [4,8,5], ~10.25 units from the scene origin.
    expect(s.far).toBeGreaterThan(20)
  })

  it.each(['test', undefined])('preserves the previous settings for %s', suite => {
    expect(replayShadowSettings(suite)).toEqual({
      near: 0.5, far: 500, bias: -0.0004, normalBias: 0,
    })
  })
})
