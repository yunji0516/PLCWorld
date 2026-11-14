import {expect,it} from 'vitest'
import {motionFittingLayout} from './motionFittingLayout'
it('sizes fittings inside small and large mounting faces',()=>{
 for(const [name,size] of [['track-support',[.16,1.2,.24]],['roller-drive-motor',[.18,.095,.105]],['cell-adapter-base',[3,.5,1.7]],['anchor-plate',[.8,.09,.8]]] as const){
  const p=motionFittingLayout(name,size)!
  expect(p).not.toBeNull()
  expect(p.inset).toBeLessThan(Math.min(size[0],size[2])/2)
  expect(p.boltRadius).toBeLessThan(p.inset)
 }
})
it('does not decorate contact surfaces, tooling, rods or invalid bounds',()=>{
 for(const name of ['protected-motor','gripper-motor','tool-support','contact-foot','moving-support','receiver-rod'])expect(motionFittingLayout(name,[.5,.5,.5])).toBeNull()
 expect(motionFittingLayout('drive-motor',[0,.2,.2])).toBeNull()
 expect(motionFittingLayout('drive-motor',[NaN,.2,.2])).toBeNull()
})
