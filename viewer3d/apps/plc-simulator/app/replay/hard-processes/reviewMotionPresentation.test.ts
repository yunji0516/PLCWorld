import {expect,it} from 'vitest'
import {reviewMotionPresentation} from './reviewMotionPresentation'
import type {Frame,Pose,V3} from './ReviewCanvas'
const pose=(p:V3):Pose=>({p,r:0})
const frame=(t:number,poses:Record<string,Pose>):Frame=>({t,poses,phase:'',raw:{},received:[],requests:[]})
it('connects empty assembly head approach/return and its rod without changing contact or products',()=>{
 const fs=Array.from({length:41},(_,i)=>{const y=i>=10&&i<25?1.17:1.45;return frame(i*.1,{assembly_head_a:pose([0,y,0]),assembly_rod_a:{...pose([0,1.54,0]),points:[[0,1.54,0],[0,y+.025,0]]},product:pose([0,1,0])})})
 const before=JSON.stringify(fs),out=reviewMotionPresentation(fs)
 expect(JSON.stringify(fs)).toBe(before)
 expect(out[10].poses.assembly_head_a.p[1]).toBe(1.17);expect(out[24].poses.assembly_head_a.p[1]).toBe(1.17)
 for(let i=1;i<out.length;i++){
  expect(Math.abs(out[i].poses.assembly_head_a.p[1]-out[i-1].poses.assembly_head_a.p[1])).toBeLessThan(.1)
  expect(out[i].poses.assembly_rod_a.points![1][1]).toBeCloseTo(out[i].poses.assembly_head_a.p[1]+.025)
  expect(out[i].poses.product).toBe(fs[i].poses.product)
 }
})
it('keeps each waste cradle attached to its own recorded roll rather than the active-roll index',()=>{
 const a=pose([1,.6,0]),b=pose([0,.6,1]),f=frame(0,{waste_roll1_cradle:a,waste_roll2_cradle:b,waste_carriage:b})
 const out=reviewMotionPresentation([f]);expect(out[0].poses.waste_carriage).toBe(a);expect(out[0].poses.waste_roll2_cradle).toBe(b);expect(f.poses.waste_carriage).toBe(b)
})
it('adjusts finger pads and slider endpoints together before the contact-width change',()=>{
 const fs=Array.from({length:12},(_,i)=>{const z=i<8?.5:.7;return frame(i*.1,{formation_contact_pad1:pose([0,1,z]),transfer_finger1_pad:pose([0,1,z]),transfer_finger1_slide:{...pose([0,1,0]),points:[[0,1,0],[0,1,z]]},product:pose([0,0,0])})})
 const out=reviewMotionPresentation(fs)
 expect(out[8].poses.transfer_finger1_pad.p[2]).toBe(.7)
 for(let i=1;i<out.length;i++){
  expect(Math.abs(out[i].poses.transfer_finger1_pad.p[2]-out[i-1].poses.transfer_finger1_pad.p[2])).toBeLessThan(.08)
  expect(out[i].poses.transfer_finger1_slide.points![1][2]).toBeCloseTo(out[i].poses.transfer_finger1_pad.p[2])
  expect(out[i].poses.transfer_finger1_slide.points![0][2]).toBe(0)
 }
})
it('does not smooth ordinary fast continuous tool travel',()=>{
 const fs=Array.from({length:10},(_,i)=>frame(i*.1,{tape_head:pose([i*.3,1,0])}));expect(reviewMotionPresentation(fs)).toBe(fs)
})
