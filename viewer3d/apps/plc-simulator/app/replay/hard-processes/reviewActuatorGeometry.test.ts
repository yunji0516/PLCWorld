import {describe,it,expect} from 'vitest'
import {Box3,Triangle,Vector3} from 'three'
import {hardwareGeometry,hardwareFinish} from './reviewHardware'
import type {Node} from './ReviewCanvas'
const node=(id:string,size:Node['size']):Node=>({id,name:id,shape:'box',color:'#407e88',size,p:[0,0,0],r:0})
const intersects=(geometry:NonNullable<ReturnType<typeof hardwareGeometry>>,box:Box3)=>{
 const g=geometry.index?geometry.toNonIndexed():geometry,pts=g.getAttribute('position');let hit=false
 for(let i=0;i<pts.count;i+=3){const t=new Triangle(...[0,1,2].map(k=>new Vector3().fromBufferAttribute(pts,i+k)) as [Vector3,Vector3,Vector3]);if(box.intersectsTriangle(t)){hit=true;break}}
 if(g!==geometry)g.dispose();return hit
}
describe('machined actuator clearances',()=>{
 it('keeps the H04 registration stop outside the complete pusher sweep',()=>{
  for(const z of [-.7175,-.6775]){
   const g=hardwareGeometry(node('align_front',[.08,.035,.015]))!;g.scale(.08,.035,.015);g.translate(0,.875,z)
   expect(intersects(g,new Box3(new Vector3(-.04,.852,-.87),new Vector3(.04,.872,.2)))).toBe(false);g.dispose()
  }
 })
 it('leaves the H10 jaw centre open instead of covering it with a solid plate',()=>{
  const g=hardwareGeometry(node('upper_grip1',[.03,.25,.23]))!
  expect(intersects(g,new Box3(new Vector3(-.4,-.2,0),new Vector3(.4,.2,.2)))).toBe(false);g.dispose()
 })
 it('keeps the H07 moving carriage clear of its continuous bed and guide rail',()=>{
  for(const z of [-1.20,-.92,-.64]){
   const g=hardwareGeometry(node('exit_pusher_slide',[.08,.065,.10]))!;g.scale(.08,.065,.10);g.translate(.68,.9,z)
   expect(intersects(g,new Box3(new Vector3(.58,.8525,-1.30),new Vector3(.74,.8825,-.54)))).toBe(false)
   expect(intersects(g,new Box3(new Vector3(.6626,.8826,-1.26),new Vector3(.6974,.9174,-.58)))).toBe(false)
   g.dispose()
  }
 })
 it('does not mistake post_photo for a sensor mounting post',()=>{
  expect(hardwareFinish(node('post_photo',[.055,.07,.055])).color).toBe('#2b323b')
  expect(hardwareFinish(node('post_photo_lens',[.015,.009,.015])).color).toBe('#381e24')
 })
})
