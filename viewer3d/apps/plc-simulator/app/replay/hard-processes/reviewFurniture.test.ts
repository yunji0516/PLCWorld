import {describe,it,expect} from 'vitest'
import {reviewFurniture} from './reviewFurniture'
import type {Node} from './ReviewCanvas'
const node=(id:string,p:number[],size:number[]):Node=>({id,name:id,p:p as Node['p'],size:size as Node['size'],r:0,shape:'box',color:'#888888'})
const cabinet=(id:string,z:number)=>[node(id+'_side-1',[-.2,.42,z],[.018,.6,.6]),node(id+'_side1',[.2,.42,z],[.018,.6,.6])]
describe('shared review furniture',()=>{
 it('merges overlapping service cases and removes their duplicate skins',()=>{
  const nodes=[...cabinet('a',0),...cabinet('b',.4)],before=JSON.stringify(nodes),plan=reviewFurniture(nodes)
  expect(plan.furniture).toHaveLength(1)
  expect(plan.furniture[0].d).toBeCloseTo(1)
  expect(plan.hidden.size).toBe(4)
  expect(JSON.stringify(nodes)).toBe(before)
 })
 it('keeps the upper part of a structural post and never crops an actuator',()=>{
  const nodes=[...cabinet('a',0),node('gantry_post',[0,.7,0],[.05,1.4,.05]),node('moving_head',[0,.7,0],[.05,1.4,.05])]
  const plan=reviewFurniture(nodes)
  expect(plan.hidden.has('gantry_post')).toBe(true)
  expect(plan.hidden.has('moving_head')).toBe(false)
  expect(plan.upper[0].p[1]-plan.upper[0].size[1]/2).toBeCloseTo(.72)
  expect(plan.upper[0].p[1]+plan.upper[0].size[1]/2).toBeCloseTo(1.4)
 })
 it('replaces four table legs while preserving the tabletop and its height',()=>{
  const nodes=[...[-1,1].flatMap((x,i)=>[-1,1].map((z,j)=>node(`stand_leg${i}${j}`,[x*.4,.35,z*.3],[.05,.7,.05]))),node('stand_deck',[0,.73,0],[1,.06,.8])]
  const plan=reviewFurniture(nodes)
  expect(plan.furniture).toHaveLength(1);expect(plan.furniture[0].top).toBeCloseTo(.7)
  expect(plan.hidden.has('stand_deck')).toBe(false)
 })
 it('retains floor support for a leg outside the enclosure footprint',()=>{
  const deck={...node('deck',[0,.82,0],[.5,.08,.7]),fixed_transfer:{}} as Node
  const plan=reviewFurniture([...cabinet('a',0),deck,node('edge_leg',[.24,.5,.36],[.055,1,.055])])
  expect(plan.furniture[0].top).toBeCloseTo(.78)
  expect(plan.hidden.has('edge_leg')).toBe(true)
  expect(plan.posts).toHaveLength(1)
  expect(plan.posts[0].bottom).toBeCloseTo(.04)
  expect(plan.posts[0].top).toBeCloseTo(1)
  expect(plan.upper).toHaveLength(0)
 })

})
