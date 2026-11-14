import {expect,it} from 'vitest'
import {motionEquipmentColor as finish} from './motionEquipmentFinish'
it('uses Material metal and motor finishes with dark installation bases',()=>{
 expect(finish('servo-linear-rail','#50768e')).toBe('#a3afb9')
 expect(finish('Axis A rail','#407e88','rail')).toBe('#a3afb9')
 expect(finish('drive-motor','#50768e')).toBe('#35434e')
 expect(finish('cell-adapter-base','#50768e')).toBe('#35434e')
 expect(finish('support-column','#50768e')).toBe('#35434e')
})
it('keeps product, contact and common gripper colors intact',()=>{
 for(const name of ['protected-rail','workpiece-motor','gripper-guide-rail','gripper-contact-insert-1'])expect(finish(name,'#d9a947')).toBe('#d9a947')
})
