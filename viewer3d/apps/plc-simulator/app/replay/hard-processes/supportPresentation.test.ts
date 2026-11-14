import {describe,it,expect} from 'vitest'
import {supportPresentation,supportRole} from './supportPresentation'
import type {Node,V3} from './ReviewCanvas'
const box=(id:string,p:V3,size:V3):Node=>({id,name:id,p,size,r:0,color:'#fff',shape:'box',visible:true})
describe('Hard support mating faces',()=>{
 it('ends a column below an overhead rail without moving the rail or work envelope',()=>{
  const post=box('gantry_post',[0,1,0],[.06,2,.06]),rail=box('gantry_zrail',[0,1.98,0],[.08,.08,2])
  const [p,r]=supportPresentation([post,rail]);expect(r).toBe(rail)
  const f=p.fragments![0];expect(p.p[1]+(f.p[1]+f.size[1]/2)*p.size[1]).toBeCloseTo(1.94)
  expect(p.p[1]+(f.p[1]-f.size[1]/2)*p.size[1]).toBeCloseTo(0)
 })
 it('butts the cantilever against a column instead of embedding its end',()=>{
  const arm=box('probe_arm',[.2,1,0],[.45,.06,.08]),post=box('probe_post',[0,.75,0],[.06,1.5,.06])
  const [a]=supportPresentation([arm,post]);const f=a.fragments![0]
  expect(a.p[0]+(f.p[0]-f.size[0]/2)*a.size[0]).toBeCloseTo(.03)
  expect(a.p[0]+(f.p[0]+f.size[0]/2)*a.size[0]).toBeCloseTo(.425)
 })
 it('retains the full beam seat after shortening its supporting column',()=>{
  const post=box('probe_post',[0,.75,0],[.06,1.5,.06]),arm=box('probe_arm',[.2,1.48,0],[.46,.06,.08])
  const [p,a]=supportPresentation([post,arm]);expect(a).toBe(arm)
  const f=p.fragments![0];expect(p.p[1]+(f.p[1]+f.size[1]/2)*p.size[1]).toBeCloseTo(1.45)
 })
 it('preserves moving supports, guards, furniture and H03 custom bore geometry',()=>{
  const moving={...box('pick_bridge',[0,1,0],[.4,.05,.05]),visible:false}
  expect(supportPresentation([moving])[0]).toBe(moving)
  for(const id of ['table_leg','guard_upright','photo_post','supply_beam'])expect(supportRole(box(id,[0,1,0],[.05,2,.05]))).toBeUndefined()
  const nodes=[box('inspection_body',[0,1,0],[.04,.2,.04]),box('inspection_post',[0,.7,0],[.05,1.4,.05])]
  expect(supportPresentation(nodes)).toBe(nodes)
 })
})
