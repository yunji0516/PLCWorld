import { expect, it } from 'vitest'
import { fitPanelWidths, signalHeightLimit } from './panelSizing'

it('keeps the 3D area usable after wide panels meet a narrower desktop', () => {
  for (const width of [1100, 1280, 1440, 1920]) {
    const p = fitPanelWidths(width, 900, 900, true, true)
    expect(p.code).toBeGreaterThanOrEqual(240)
    expect(p.details).toBeGreaterThanOrEqual(220)
    expect(width - p.code - p.details).toBeGreaterThanOrEqual(319.99)
  }
})
it('restores manual widths and frees collapsed panel space', () => {
  expect(fitPanelWidths(1440, 450, 350, true, true)).toEqual({ code: 450, details: 350 })
  expect(fitPanelWidths(1440, 450, 350, false, false)).toEqual({ code: 0, details: 0 })
})
it('reserves space for the scene and playback at any timeline size', () => {
  expect(signalHeightLimit(700, 40, 50)).toBe(431)
  expect(signalHeightLimit(330, 40, 74)).toBe(40)
})
