import { expect, it } from 'vitest'
import { portraitFramingScale } from './cameraFraming'

it('preserves landscape framing and compensates for narrow portrait canvases', () => {
  expect(portraitFramingScale(800, 400)).toBe(1)
  expect(portraitFramingScale(400, 400)).toBe(1)
  expect(portraitFramingScale(320, 640)).toBe(2)
  expect(portraitFramingScale(0, 640)).toBe(1)
  expect(portraitFramingScale(320, 0)).toBe(1)
})
