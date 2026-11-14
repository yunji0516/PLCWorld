import {describe,it,expect} from 'vitest'
import {presentationCorrections} from './presentationCorrections'
import type {Node} from './ReviewCanvas'
const n=(id:string,p:number[],size:number[],extra:Partial<Node>={}):Node=>({id,name:id,p:p as Node['p'],size:size as Node['size'],r:0,shape:'box',color:'#888888',...extra})
describe('render-only corrections',()=>{
 it('extends only the back of the H02 box conveyor, preserving the forward transfer end and products',()=>{
  const belt=n('box_lane_surface',[2.25,.76,.72],[.64,.08,4.12],{conveyor:{axis:'z',radius:.04,belt_width:.6,length:4.12,source:'box_lane_surface'}})
  const box=n('box2_base',[2.25,.825,-1.35],[.6,.05,.5],{material:true}),input=[belt,box],before=JSON.stringify(input)
  const [out,product]=presentationCorrections(input)
  expect(out.p[2]+out.size[2]/2).toBeCloseTo(belt.p[2]+belt.size[2]/2)
  expect(out.p[2]-out.size[2]/2).toBeLessThan(box.p[2]-box.size[2]/2)
  expect(product).toBe(box);expect(JSON.stringify(input)).toBe(before)
 })
})

it('extends the H12 receiving belt and outlet hardware while retaining its inlet and product poses',()=>{
 const belt=n('external_pickup_a_surface',[-.75,1.107,-2],[1.5,.08,.5],{conveyor:{axis:'x',radius:.04,belt_width:.46,length:1.5,source:'external_pickup_a_surface'}})
 const marker=n('scrap_chute_a2',[0,0,0],[.004,.14,.004])
 const drum=n('external_pickup_a_surface_drum1',[-.04,1.107,-2],[.03,.46,.03])
 const product=n('plate1_0_1',[-.035,1.15,-2],[.15,.006,.12],{material:true})
 const out=presentationCorrections([belt,marker,drum,product])
 expect(out[0].p[0]-out[0].size[0]/2).toBeCloseTo(-1.5)
 expect(out[0].p[0]+out[0].size[0]/2).toBeCloseTo(.4)
 expect(out.find(n=>n.id===drum.id)!.p[0]).toBeCloseTo(.36)
 expect(out.find(n=>n.id===product.id)).toBe(product)
})

it('removes H06 enclosure order plaques without removing the enclosure or workpieces',()=>{
 const side=n('cutter_cell_side-1',[0,.4,0],[.02,.6,.4]),markA=n('order_mark_a',[0,.6,1],[.25,.1,.008]),markB=n('order_mark_b',[0,.6,-1],[.25,.1,.008]),part=n('part1',[0,1,0],[.1,.01,.1],{material:true})
 const result=presentationCorrections([side,markA,markB,part])
 expect(result.map(n=>n.id)).toEqual(['cutter_cell_side-1','part1'])
 expect(presentationCorrections([markA])).toEqual([markA])
})
