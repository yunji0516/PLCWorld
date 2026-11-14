import { describe, expect, it } from 'vitest'
import { DoubleSide, Mesh, MeshBasicMaterial, Raycaster, Vector3 } from 'three'
import { doorDimensions, doorTravel, indexAngle, indexPlateGeometry } from './workcellGeometry'
import { boredPlate } from './geometry'
import { clampGeometry } from '../deviceGeometry'

describe('workcell assemblies preserve contact and travel', () => {
  for (const w of [1.4, 1.6]) it(`supports the complete opposed-door travel (${w})`, () => {
    const g = doorDimensions(w, 2, .12)
    expect(doorTravel(w, 0)).toBe(0)
    expect(doorTravel(w, 1)).toBeCloseTo(w / 2 - .08)
    expect(w / 4 + doorTravel(w, 1) + g.leafWidth / 2).toBeLessThan(g.railLength / 2)
    expect(g.glassDepth).toBeLessThan(.12)
  })
  for (const w of [.9, 1.3]) it(`keeps the table surface and bores open (${w})`, () => {
    const g = indexPlateGeometry(w, .12)
    g.computeBoundingBox()
    expect(g.boundingBox!.max.y).toBeCloseTo(.06)
    expect(g.boundingBox!.max.x).toBeCloseTo(w / 2)
    const m = new Mesh(g, new MeshBasicMaterial({ side: DoubleSide }))
    const ray = new Raycaster(new Vector3(w * .27, 1, 0), new Vector3(0, -1, 0))
    expect(ray.intersectObject(m)).toHaveLength(0)
    ray.set(new Vector3(w * .32, 1, 0), new Vector3(0, -1, 0))
    expect(ray.intersectObject(m).length).toBeGreaterThan(0)
    expect(indexAngle(1)).toBeCloseTo(-Math.PI / 3)
    g.dispose(); m.material.dispose()
  })
  for (const d of [.26, .32, .42]) it(`clamp guide bores clear both rods (${d})`, () => {
    const g = boredPlate(.30, .04, .10, .003, [-1, 1].map(s => ({ x: s * d * .28, y: 0, radius: .0135 })))
    const m = new Mesh(g, new MeshBasicMaterial({ side: DoubleSide }))
    for (const side of [-1, 1]) {
      const ray = new Raycaster(new Vector3(side * d * .28, 0, 1), new Vector3(0, 0, -1))
      expect(ray.intersectObject(m)).toHaveLength(0)
    }
    for (const p of [0, .5, 1]) {
      const j = clampGeometry(p)
      expect(j.jawCenter - .044 - .006).toBeCloseTo(j.innerGap / 2)
      expect(.055 + .08).toBeCloseTo(j.jawCenterY + j.jawHeight / 2)
    }
    g.dispose(); m.material.dispose()
  })
})
