import {expect,it} from 'vitest'
import {packHeadPresentation} from './packHeadPresentation'
import type {Frame,V3} from './ReviewCanvas'
const home:V3=[2.25,1.72,.6],pick:V3=[.55,.997,1.95]
const frame=(t:number,p:V3):Frame=>({t,phase:'',raw:{},received:[],requests:[],poses:{pack_head:{p,r:0},pack_head_rod:{p:[p[0],1.86,p[2]],r:0},pack_head_slide:{p:[p[0],1.86,p[2]],r:0},'pack_pad0.1':{p:[p[0],p[1]-.025,p[2]+.1],r:0},product:{p:[0,0,0],r:0}}})
it('fills approach and return while preserving pickup/drop, source poses, and product states',()=>{
 const frames=Array.from({length:61},(_,i)=>frame(i*.1,i>=20&&i<40?pick:home)),before=JSON.stringify(frames),out=packHeadPresentation(frames)
 expect(JSON.stringify(frames)).toBe(before)
 expect(out[20].poses.pack_head.p).toEqual(pick);expect(out[39].poses.pack_head.p).toEqual(pick)
 expect(out[60].poses.pack_head.p).toEqual(home)
 for(let i=1;i<out.length;i++){
  const p=out[i].poses.pack_head.p,a=out[i-1].poses.pack_head.p
  expect(Math.hypot(...p.map((v,j)=>v-a[j]))).toBeLessThan(.25)
  expect(out[i].poses.product).toBe(frames[i].poses.product)
  expect(out[i].poses.pack_head_slide.p[0]).toBe(p[0])
  expect(out[i].poses['pack_pad0.1'].p[2]).toBeCloseTo(p[2]+.1)
  expect(out[i].poses['pack_pad0.1'].p[1]).toBeCloseTo(p[1]-.025)
 }
})
it('leaves unrelated task frames untouched',()=>{
 const frames=[{...frame(0,home),poses:{}}];expect(packHeadPresentation(frames)).toBe(frames)
})
