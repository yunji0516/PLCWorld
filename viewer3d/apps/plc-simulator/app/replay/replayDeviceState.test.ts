import {expect,it} from 'vitest'
import type {Frame,TraceTask} from '@/lib/replay/adapter'
import {recordedDeviceState} from './replayDeviceState'
it('distinguishes a recorded released brake from a missing observation',()=>{
 const task={devices:[{id:'BRAKE',visual_variant:'motion-holding-brake'}]} as unknown as TraceTask
 const frame={k:0,s:{BRAKE:0},x:{},y:{},v:0} as Frame
 expect(recordedDeviceState(task,frame,'BRAKE')).toBe('Released')
 expect(recordedDeviceState(task,{...frame,s:{}},'BRAKE')).toBeNull()
 expect(recordedDeviceState(task,{...frame,s:{BRAKE:1}},'BRAKE')).toBe('Engaged')
})
it('does not assign the enclosing cell value to its selected equipment',()=>{
 const task={devices:[{id:'CELL',kind:'static'}]} as unknown as TraceTask
 expect(recordedDeviceState(task,{k:0,x:{},y:{},v:0,s:{CELL:1}},'CELL')).toBeNull()
 expect(recordedDeviceState(task,{k:0,x:{},y:{},v:0,s:{CELL:1}},'motor')).toBeNull()
})
