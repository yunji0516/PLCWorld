import {describe,it,expect} from 'vitest'
import {executionOutcome,failureFrameIndex,selectedReadings,replayGroup,recordedParts} from './replayPresentation'
import type {Frame,TraceTask,TraceRun} from '@/lib/replay/adapter'
const frames=[0,10,20].map(k=>({k,x:{},y:{},s:{},v:0})) as Frame[]
describe('common replay presentation',()=>{
 it('shows no verdict until a trace exists and honors both goal and violations',()=>{
  expect(executionOutcome({goal:true,viol:[],frames:[]})).toBe('unavailable')
  expect(executionOutcome({goal:true,viol:[],frames},true)).toBe('loading')
  expect(executionOutcome({goal:true,viol:[],frames})).toBe('PASS')
  expect(executionOutcome({goal:true,viol:[{k:10,name:'collision'}],frames})).toBe('FAIL')
  expect(executionOutcome({goal:false,viol:[],frames})).toBe('FAIL')
 })
 it('finds a recorded failure in sparse scans and a missed goal at the end',()=>{
  expect(failureFrameIndex({frames,viol:[{k:10,name:'collision'}]})).toBe(1)
  expect(failureFrameIndex({frames,viol:[{k:12,name:'collision'}]})).toBe(2)
  expect(failureFrameIndex({frames,viol:[]})).toBe(2)
 })
 it('only associates explicitly linked I/O with the selected device',()=>{
  const task={devices:[{id:'CLAMP',drive:'Y1',at_max:'X1'},{id:'DOOR',drive:'Y2'}],io:{Y1:'close',X1:'closed',Y2:'door'}} as unknown as TraceTask
  const frame={...frames[0],x:{X1:1},y:{Y1:1,Y2:0}}
  expect(selectedReadings(task,frame,'CLAMP').map(r=>r.address)).toEqual(['Y1','X1'])
  expect(selectedReadings(task,frame,'CELL')).toEqual([])
 })
 it('keeps legacy run names visible and separates generated runs',()=>{
  expect(replayGroup('normal')).toBe('other')
  expect(replayGroup('Paper sample · failed')).toBe('paper')
  expect(replayGroup('My runs · test · condition 1')).toBe('mine')
 })
 it('merges recorded ownership without making up a new physical state',()=>{
  const frame={...frames[0],world:{parts:{P1:{owner:'A',status:'held'}},material_hard:{parts:{P1:{owner:'B'},P2:{owner:'C'}}}}} as unknown as Frame
  expect(recordedParts(frame).map(p=>[p.id,p.owner])).toEqual([['P1','B'],['P2','C']])
 })
})
