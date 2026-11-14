import { describe, it, expect } from 'vitest'
import { compactSuctionHeadGeometry, suctionCupGeometry, isSuctionHead } from './suctionHeadGeometry'

describe('shared suction hardware',()=>{
 it('preserves pad contact plane and radius',()=>{
  for(const [r,h] of [[.027,.024],[.022,.02],[.125,.025]]){
   const g=suctionCupGeometry(r,h);g.computeBoundingBox();const b=g.boundingBox!
   expect(b.min.y).toBeCloseTo(-h/2,6);expect(b.max.y).toBeCloseTo(h/2,6)
   expect(b.max.x).toBeCloseTo(r,6);g.dispose()
  }
 })
 it('fits both box and radius-scaled cylinder trace envelopes',()=>{
  for(const d of [1,2]){
   const g=compactSuctionHeadGeometry(d);g.computeBoundingBox();const b=g.boundingBox!
   expect(b.min.y).toBeCloseTo(-.5,6);expect(b.max.y).toBeCloseTo(.5,6)
   expect(b.max.x).toBeCloseTo(d/2,6);expect(g.groups.map(x=>x.materialIndex)).toEqual([0,1,2]);g.dispose()
  }
 })
 it('keeps specialized opening pads, material and labels separate from pickup heads',()=>{
  expect(isSuctionHead({name:'Content supply suction head',shape:'box'})).toBe(true)
  expect(isSuctionHead({name:'Product loading suction head',shape:'cylinder'})).toBe(true)
  expect(isSuctionHead({name:'Left opening suction pad',shape:'cylinder'})).toBe(false)
  expect(isSuctionHead({name:'Product loading suction head',shape:'label'})).toBe(false)
  expect(isSuctionHead({name:'Product loading suction head',shape:'box',material:true})).toBe(false)
 })
})
