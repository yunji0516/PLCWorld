import {describe,it,expect} from 'vitest'
import {recordedContactTravel,toolSupport,deckSupport} from './recordedContactLayout'
import type {Frame} from '@/lib/replay/adapter'
describe('recorded contact presentation',()=>{
 it('covers reversed travel without changing the original scans',()=>{
  const frames=[[-2,.8,1],[3,1.4,-1],[0,1,0]].map(pos=>({world:{material_hard:{contact:{poses:{head:{pos,kind:'tool',yaw:0}}}}}})) as unknown as Frame[]
  const before=JSON.stringify(frames),t=recordedContactTravel(frames).head,s=toolSupport(t)
  expect(t.min).toEqual([-2,.8,-1]);expect(t.max).toEqual([3,1.4,1])
  expect(s.left).toBeLessThan(t.min[0]-.3);expect(s.right).toBeGreaterThan(t.max[0]+.3)
  expect(s.top-t.max[1]).toBeCloseTo(.65)
  expect(JSON.stringify(frames)).toBe(before)
 })
 it('aligns the carriage ways with transverse Z travel',()=>{
  const s=deckSupport({min:[1.25,.85,-.85],max:[1.25,1.1,.85],kind:'deck'})
  expect(s.alongX).toBe(false)
  expect(s.d).toBeGreaterThan(1.7)
  expect(s.cx).toBe(1.25)
  expect(s.top).toBeLessThan(.85-.1)
 })
 it('keeps the inventory for temporarily absent actuators',()=>{
  const inventory={tool:{pos:[1,1,1] as [number,number,number],kind:'tool',yaw:0}}
  const t=recordedContactTravel([], {schema:'test',poses:{},inventory,lanes:[],stops:[],web_path:[]})
  expect(t.tool.min).toEqual([1,1,1])
 })
})
