import {describe,it,expect} from 'vitest'
import {BoxGeometry,Group,Mesh,MeshBasicMaterial,InstancedMesh,Matrix4,PerspectiveCamera} from 'three'
import {visibleEquipmentBounds,equipmentFloor,equipmentFront,fitEquipment,framingCorners,recordedTravelBounds} from './equipmentFraming'
describe('equipment framing',()=>{
 it('measures offset rotated hardware without invisible parked stock',()=>{
  const root=new Group(),part=new Mesh(new BoxGeometry(4,2,1),new MeshBasicMaterial())
  part.position.set(7,1,-3);part.rotation.y=Math.PI/2;root.add(part)
  const hidden=part.clone();hidden.position.set(100,100,100);hidden.visible=false;root.add(hidden)
  const stock=new InstancedMesh(new BoxGeometry(1,1,1),new MeshBasicMaterial(),2)
  stock.setMatrixAt(0,new Matrix4().makeTranslation(7,1,-3));stock.setMatrixAt(1,new Matrix4().makeTranslation(0,-50,0));root.add(stock)
  const b=visibleEquipmentBounds(root)!
  expect(b.min).toEqual([6.5,0,-5]);expect(b.max).toEqual([7.5,2,-1])
  const floor=equipmentFloor(b);expect(floor.x).toBe(7);expect(floor.z).toBe(-3)
  expect(floor.width/2).toBeGreaterThan(.5+.35)
 })
 it('fits offset equipment and its paint from either front in a narrow canvas',()=>{
  const bounds={min:[3,0,-8] as [number,number,number],max:[14,4,2] as [number,number,number]},floor=equipmentFloor(bounds)
  for(const sign of [-1,1] as const){
   const c=new PerspectiveCamera(42,.6,.1,200),result=fitEquipment(c,bounds,floor,'front',sign)
   expect(result.target.toArray()).toEqual([8.5,2,-3])
   expect(Math.sign(c.position.z-result.target.z)).toBe(sign)
   for(const p of framingCorners(bounds,floor)){p.project(c);expect(Math.abs(p.x)).toBeLessThan(.9001);expect(Math.abs(p.y)).toBeLessThan(.9001)}
  }
 })
 it('shares the explicit front between camera and floor',()=>{
  expect(equipmentFront({floorFrontSign:-1,geometry:{view:{frontSign:1}}})).toBe(1)
  expect(equipmentFront({floorFrontSign:-1,geometry:{view:{}}})).toBe(-1)
 })
 it('includes recorded travel endpoints without interpreting local station poses',()=>{
  const frames=[{"world": {"motion_hard": {"poses": {"tool": {"pos": [5, 1, 2], "size": [1, 1, 1]}}, "process": {"cells": {"local": {"poses": {"tool": {"pos": [500, 500, 500]}}}}}}}}, {"world": {"motion_hard": {"poses": {"tool": {"pos": [-2, 3, 0], "size": [1, 1, 1]}}}}}]
  const before=JSON.stringify(frames),b=recordedTravelBounds(frames)!
  expect(b.min).toEqual([-2.5,.5,-.5]);expect(b.max).toEqual([5.5,3.5,2.5]);expect(JSON.stringify(frames)).toBe(before)
 })
})
