import { expect, it } from 'vitest'
import { factoryCellBounds, materialHardCellBounds, operatorBandZ } from './factoryFloor'

it('encloses long Hard outfeeds with fixed clearance rather than the representative CELL box', () => {
  const cell = materialHardCellBounds('MAT-H04 · package')!
  expect(cell.x + cell.width / 2).toBeCloseTo(6.86 + .75)
  expect(cell.z - cell.depth / 2).toBeCloseTo(-3.67 - .75)
  expect(materialHardCellBounds('MAT-H06 · web')!.depth).toBeCloseTo(3.89)
})
it('does not override Motion, Easy, Medium or inactive Hard geometry', () => {
  for (const title of ['MOT-H04', 'MAT-E04', 'MAT-M04', 'MAT-H07', 'MAT-H040']) {
    expect(materialHardCellBounds(title)).toBeUndefined()
  }
})

it('places the keep-clear paint on the declared operator side, preserving the default', () => {
  expect(operatorBandZ(4)).toBe(1.76)
  expect(operatorBandZ(4, -1)).toBe(-1.76)
  expect(Math.abs(operatorBandZ(4, -1)) + .22 / 2).toBeLessThan(4 / 2 - .085 / 2)
})

it('has a compact default footprint', () => {
  expect(factoryCellBounds([])).toEqual({ x: 0, z: 0, width: 3, depth: 2.6 })
})
it('centers the paint on offset equipment with clearance on every side', () => {
  expect(factoryCellBounds([{ pos: [4, 1, -2], size: [6, 2, 3], rot: 0 }]))
    .toEqual({ x: 4, z: -2, width: 7.2, depth: 4.2 })
})
it('includes rotated footprints', () => {
  const cell = factoryCellBounds([{ pos: [0, 1, 0], size: [6, 2, 1], rot: Math.PI / 2 }])
  expect(cell.depth).toBeCloseTo(7.2)
  expect(cell.width).toBe(3)
})
