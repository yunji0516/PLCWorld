import {expect,it} from 'vitest'
import {dependencyEquipment} from './dependencyEquipment'
import type {MotionHardState} from './adapter'
const geometry={labels:{a:'A axis',b:'B axis'},parts:[]} as unknown as NonNullable<MotionHardState['dependency']>
const part=(name:string,style?:string,node?:string)=>({name,style,node,pos:[0,0,0] as [number,number,number],size:[1,1,1] as [number,number,number],color:'#fff'})
it('binds motor, rail and moving saddle to the recorded axis without merging its limit sensor',()=>{
 const a=['a-motor','a-rail-0.03','a-saddle'].map(n=>dependencyEquipment(part(n),geometry).equipmentGroup)
 expect(new Set(a)).toEqual(new Set(['axis:a']))
 expect(dependencyEquipment(part('b-motor'),geometry).equipmentGroup).toBe('axis:b')
 expect(dependencyEquipment(part('a-limit','sensor'),geometry).equipmentGroup).toBe('sensor:a-limit')
})
it('uses explicit axis labels for named cylinders and does not guess ambiguous ownership',()=>{
 const g={...geometry,labels:{},axis_labels:{a:'X1 short cylinder',b:'X2 long cylinder',d:'J jig transfer'}}
 expect(dependencyEquipment(part('X1 rod'),g).equipmentGroup).toBe('axis:a')
 expect(dependencyEquipment(part('Jig drive'),g).equipmentGroup).toBe('axis:d')
 expect(dependencyEquipment(part('Unassigned tool'),g).equipmentGroup).toBeUndefined()
})

it('keeps a mounted C-axis motor with C instead of merging it into its B carrier',()=>{
 const g={...geometry,labels:{a:'A height',b:'B tilt',c:'C cross approach'}}
 expect(dependencyEquipment(part('c-motor','motor','b'),g).equipmentGroup).toBe('axis:c')
})

it('keeps the serial-cylinder approach tool with its Z actuator',()=>{
 const g={...geometry,task_number:12,labels:{a:'X1 short cylinder',b:'X2 long cylinder',c:'Z approach head'}}
 expect(dependencyEquipment(part('Empty approach head'),g).equipmentGroup).toBe('axis:c')
})
