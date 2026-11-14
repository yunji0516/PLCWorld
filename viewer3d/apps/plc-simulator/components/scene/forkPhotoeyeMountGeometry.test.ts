import { expect, it } from 'vitest'
import { FORK_PHOTOEYE_MOUNT as parts, FORK_PHOTOEYE_WEB as web } from './forkPhotoeyeMountGeometry'

const bounds = (name: string, axis: number) => {
  const p = parts.find(p => p.name === `fork-photoeye-${name}`)!
  return [p.position[axis] - p.size[axis] / 2, p.position[axis] + p.size[axis] / 2]
}
it('has an unbroken vertical support chain from carriage beam to sensor bottom', () => {
  expect(bounds('base-foot', 1)[0]).toBeCloseTo(-.1275)
  expect(bounds('base-foot', 1)[1]).toBeCloseTo(bounds('pedestal', 1)[0])
  expect(bounds('pedestal', 1)[1]).toBeCloseTo(bounds('shelf', 1)[0])
  expect(bounds('shelf', 1)[1]).toBeCloseTo(-.055)
  expect(bounds('base-foot', 2)[0]).toBeGreaterThanOrEqual(.035)
  expect(bounds('base-foot', 2)[1]).toBeLessThanOrEqual(.155)
})
it('keeps support between the fork heels and braces the cantilever underside', () => {
  expect(bounds('base-foot', 0)[1]).toBeLessThan(.0775)
  expect(Math.max(...web.sides) + web.thickness / 2).toBeLessThan(.0775)
  expect(web.yz[0][0]).toBeCloseTo(bounds('shelf', 1)[0])
  expect(web.yz[2][0]).toBeCloseTo(bounds('base-foot', 1)[1])
  expect(web.yz[1][1]).toBeCloseTo(bounds('pedestal', 2)[0])
})
