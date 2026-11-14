import {describe,it,expect} from 'vitest'
import {hardwareFinish,isWorkbenchDeck} from './reviewHardware'
import {TABLE_FINISH} from '@/components/scene/assemblies/tableFinish'
import type {Node} from './ReviewCanvas'
const slab=(id:string,extra:Partial<Node>={}):Node=>({id,name:id,p:[0,.75,0],size:[.7,.075,.5],shape:'box',r:0,color:'#407e88',...extra})
describe('hard workbench finish',()=>{
 it('uses the common tabletop finish on support decks and fixed work surfaces',()=>{
  for(const id of ['reel_swap_stand_beam','waste_receiving_beam','formation_table_surface','pouch_deck','tool_rack_beam'])expect(hardwareFinish(slab(id)).color).toBe(TABLE_FINISH.top)
  expect(hardwareFinish(slab('supply_surface',{fixed_transfer:true})).color).toBe(TABLE_FINISH.top)
 })
 it('preserves products, conveyor belts, floor bases and overhead beams',()=>{
  for(const n of [slab('product_deck',{material:true}),slab('source_surface',{shape:'conveyor_belt'}),slab('source_base',{p:[0,.05,0]}),slab('gantry_beam',{p:[0,1.6,0]})])expect(isWorkbenchDeck(n)).toBeFalsy()
 })
})
