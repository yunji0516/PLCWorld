import {describe,it,expect} from 'vitest'
import {scrapFallPresentation} from './scrapFallPresentation'
import type {Frame,Pose} from './ReviewCanvas'
const p=(y:number):Pose=>({p:[.16,y,.57],r:0,visible:true})
const frames=[.75,.6875,.625,.5625,.5,.5].map((y,i)=>({t:i*.4,poses:{bin_floor101:p(.477),part110:p(y),product:p(1.15)},raw:{signal:i},received:[],requests:[],phase:'test'} as Frame))
describe('H12 scrap descent presentation',()=>{
 it('accelerates only the unsupported vertical segment and retains arrival, bin and process records',()=>{
  const result=scrapFallPresentation(frames)
  expect(result[0]).toBe(frames[0]);expect(result[4]).toBe(frames[4]);expect(result[5]).toBe(frames[5])
  expect(result[2].poses.part110.p[1]).toBeCloseTo(.6875)
  result.forEach((f,i)=>{expect(f.raw).toBe(frames[i].raw);expect(f.poses.product).toBe(frames[i].poses.product);expect(f.poses.bin_floor101).toBe(frames[i].poses.bin_floor101)})
  expect(frames[2].poses.part110.p[1]).toBe(.625)
 })
 it('leaves other task traces unchanged',()=>{
  const other=frames.map(f=>({...f,poses:{part110:f.poses.part110}}))
  expect(scrapFallPresentation(other)).toBe(other)
 })
})
