import {expect,it} from 'vitest'
import {isConveyorHolder} from './conveyorPresentation'
it('hides complete conveyor stop assemblies and their labels across Hard layouts',()=>{
 for(const id of ['core_stop','formation_stop','source_stop_0_200','box_lane_stop_4_500_rod','product_source_stop_0_120_drive','exit_stop_2_cylinder','receiver_waste_stop_0_120_riser','out_a_stop_0_mount','clamp_a','clamp_rod_b','clamp_backstop_a','a_arrival_0_jaw-1'])expect(isConveyorHolder({id})).toBe(true)
 expect(isConveyorHolder({id:'label',anchor:'exit_stop_2'})).toBe(true)
})
it('keeps process fixtures, transport surfaces and workpieces',()=>{
 for(const id of ['repair_clamp','separator_hold','holder','splice_old_hold','left_stop1','box_clamp_drive','source_belt'])expect(isConveyorHolder({id})).toBe(false)
 expect(isConveyorHolder({id:'exit_stop_2',material:true})).toBe(false)
})
