import { expect, it } from 'vitest'
import { PHOTOEYE_STYLE as style, MATERIAL_PHOTOEYE_STYLE as material, photoeyeRadialScale } from './photoeyeStyle'

it('keeps a visible translucent optical axis narrower than the lens', () => {
  expect(style.rayRadius).toBe(.0032)
  expect(style.rayMaxPixels).toBe(1.6)
  expect(style.rayRadius).toBeLessThan(.018)
  expect(style.rayIdleOpacity).toBe(.52)
  expect(style.rayDetectingOpacity).toBeGreaterThan(style.rayIdleOpacity)
  expect(style.rayDetectingOpacity).toBe(.65)
  expect(style.statusDetectingEmission).toBeLessThan(1)
})

it('uses the same style object for Material and Motion', () => {
  expect(material).toBe(style)
})

it('caps close-up width and never enlarges a distant ray', () => {
  for (const height of [300, 646, 1200]) for (const depth of [.25, 1.25, 3, 7, 20]) {
    const projected = style.rayRadius * 2.6 * height / depth
    const scale = photoeyeRadialScale(style.rayRadius, depth, 2.6, height)
    const pixels = projected * scale
    expect(scale).toBeLessThanOrEqual(1)
    expect(pixels).toBeCloseTo(Math.min(projected, style.rayMaxPixels))
    expect(pixels).toBeLessThanOrEqual(style.rayMaxPixels + 1e-9)
  }
})

it('lets distant rays shrink below one pixel instead of forcing a minimum', () => {
  const diameter = (depth: number) => style.rayRadius * 2.6 * 646 / depth * photoeyeRadialScale(style.rayRadius, depth, 2.6, 646)
  expect(photoeyeRadialScale(style.rayRadius, 10, 2.6, 646)).toBe(1)
  expect(diameter(10)).toBeLessThan(1)
  expect(diameter(20)).toBeCloseTo(diameter(10) / 2)
})

it('handles orthographic projection and invalid frame dimensions', () => {
  const scale = photoeyeRadialScale(.011, 10, 2, 646, true)
  expect(.011 * 2 * 646 * scale).toBeCloseTo(style.rayMaxPixels)
  expect(photoeyeRadialScale(.011, -1, 2, 646)).toBe(1)
  expect(photoeyeRadialScale(.011, 1, 2, 0)).toBe(1)
})
