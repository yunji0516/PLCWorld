import { describe,it,expect } from 'vitest'
import {primaryDevice,primaryDeviceList,primaryReviewNode,structuralPart} from './primaryDevices'

describe('major equipment interaction policy',()=>{
 const devices=[{id:'A_COLUMN',ui:'platform'},{id:'A_DOOR',ui:'door'},{id:'A_CLAMP',ui:'clamp'},{id:'A_SPINDLE',ui:'platform',visual_variant:'hard-spindle'},{id:'GAUGE_COLUMN',ui:'platform'},{id:'GAUGE_PROBE',ui:'platform',visual_variant:'hard-probe'},{id:'ROBOT',ui:'robot'}]
 it('keeps a clamp, door and spindle independently selectable',()=>{
  expect(primaryDeviceList(devices).map(d=>d.id)).toEqual(['A_DOOR','A_CLAMP','A_SPINDLE','GAUGE_PROBE','ROBOT'])
  expect(primaryDevice(devices[1],devices)?.id).toBe('A_DOOR')
  expect(primaryDevice(devices[2],devices)?.members).toEqual(['A_CLAMP'])
  expect(primaryDevice(devices[0],devices)).toBeUndefined()
 })
 it('does not make structural details interactive',()=>{
  for(const name of ['packing_column','receiver-support-column','cabinet_foot01','Support leg','Support column','synthetic-v6-datum-base','Base','bench-top','material-table-underframe'])expect(structuralPart(name)).toBe(true)
  expect(structuralPart('servo-axis')).toBe(false)
  expect(primaryDevice({id:'PHOTO',kind:'static',ui:'sensor'},[])?.id).toBe('PHOTO')
  expect(primaryReviewNode({id:'packing_column',name:'packing column',shape:'box'},new Set(['packing_column']))).toBe(false)
  expect(primaryReviewNode({id:'input_pad',name:'Product loading suction head',shape:'cylinder'},new Set())).toBe(true)
 })
})

it('does not mistake a recorded supported axis for static support furniture',()=>{
 expect(structuralPart('recorded-supported-axis-DIE')).toBe(false)
 expect(structuralPart('support-column')).toBe(true)
})

it('excludes composite cells and invisible state anchors from the equipment list',()=>{
 expect(primaryDeviceList([{id:'MATERIAL_CELL',visual_variant:'cell3-mini-fifo_pack'},{id:'BOX',visual_variant:'cell3-mini-anchor'},{id:'SENSOR',ui:'sensor'}]).map(d=>d.id)).toEqual(['SENSOR'])
})

it('keeps independently registered clamps distinct even when their display labels match',()=>{
 const devices=[{id:'CLAMP_A',label:'Slot clamp',ui:'clamp'},{id:'CLAMP_B',label:'Slot clamp',ui:'clamp'}]
 expect(primaryDeviceList(devices)).toHaveLength(2)
 expect(primaryDevice(devices[0],devices)?.label).toBe('Slot clamp · CLAMP_A')
 expect(primaryDevice(devices[1],devices)?.label).toBe('Slot clamp · CLAMP_B')
})
