import {describe,it,expect} from 'vitest'
import {reviewCabinetLayout} from './reviewCabinetLayout'
import {presentationCorrections} from './presentationCorrections'
import type {Node} from './ReviewCanvas'
const node=(id:string,p:Node['p'],size:Node['size']):Node=>({id,name:id,p,size,r:0,shape:'box',color:'#888888'})
describe('review cabinet layout',()=>{
 it('uses the same rear placement before and after the waste-cradle presentation rename',()=>{
  const nodes=[node('controls',[-1,.48,.56],[.4,.55,.25]),node('waste_roll1_cradle',[0,.6,0],[.2,.1,.2]),node('waste_roll2_cradle',[0,.6,1],[.2,.1,.2]),node('rear_table',[0,.5,-1],[2,1,.5])]
  const raw=reviewCabinetLayout(nodes),rendered=reviewCabinetLayout(presentationCorrections(nodes))
  expect(rendered).toEqual(raw)
  expect(rendered[0].z+.25).toBeLessThan(-1.25)
  expect(nodes[0].p).toEqual([-1,.48,.56])
 })
})
