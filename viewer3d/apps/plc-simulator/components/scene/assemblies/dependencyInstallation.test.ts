import {expect,it} from 'vitest'
import {seatedDependencyPart,isJoinedInstallation,redundantDependencyPart} from './dependencyInstallation'
const part=(name:string,pos=[0,0,0],size=[1,1,1],node?:string)=>({name,pos,size,node})
it('seats M09 moving span on its saddle without shifting actuator poses',()=>{
 const p=part('clamp-mount-span',[0,.05,0],[.1,.035,.66],'a')
 const q=seatedDependencyPart(p,9)
 expect(.295+q.pos[1]-q.size[1]/2).toBeCloseTo(.295+.045/2)
 expect(q.pos[1]+q.size[1]/2).toBeCloseTo(p.pos[1]+p.size[1]/2)
 expect(seatedDependencyPart(p,8)).toBe(p)
 const protectedPart=part('b-locking-pin',[0,0,0],[.006,.012,.115],'protected-b-locking-pin')
 expect(seatedDependencyPart(protectedPart,9)).toBe(protectedPart)
})
it('butt-joins M09 receiver beams and seats them on the existing column',()=>{
 const back=seatedDependencyPart(part('receiver-backbeam1'),9)
 const cross=seatedDependencyPart(part('receiver-crossbeam1'),9)
 const col=seatedDependencyPart(part('receiver-support-column',[.3,.27,.25],[.055,.34,.06]),9)
 expect(back.pos[0]-back.size[0]/2).toBeCloseTo(cross.pos[0]+cross.size[0]/2)
 expect(back.pos[2]+back.size[2]/2).toBeCloseTo(cross.pos[2]+cross.size[2]/2)
 expect(col.pos[1]+col.size[1]/2).toBeCloseTo(back.pos[1]-back.size[1]/2)
 expect(col.pos[1]-col.size[1]/2).toBeCloseTo(.1025)
})

it('does not crop animated world-space mechanisms as if they were fixed',()=>{
 for(const name of ['b-bed','c-cross-bed','internal-probe','module-saddle','recovery-stage-mount','feeder-upper-yoke'])expect(isJoinedInstallation({name})).toBe(false)
 for(const name of ['press0.17-foot','aperture1-column','receiver-backbeam-1','receiver-crossbeam1','b-arm'])expect(isJoinedInstallation({name})).toBe(true)
 expect(isJoinedInstallation({name:'guide-deck',node:'a'})).toBe(true)
 expect(isJoinedInstallation({name:'b-locking-pin',node:'protected-b-locking-pin'})).toBe(false)
})

it('removes the redundant M07 cap but preserves independent and protected parts',()=>{
 expect(redundantDependencyPart(part('c-cross-end-0'),7)).toBe(true)
 expect(redundantDependencyPart(part('c-cross-end-0'),13)).toBe(false)
 expect(redundantDependencyPart(part('c-cross-end-0',[0,0,0],[1,1,1],'protected-cap'),7)).toBe(false)
 expect(isJoinedInstallation(part('a-motor'),7)).toBe(true)
 expect(isJoinedInstallation(part('a-motor'),12)).toBe(false)
 expect(isJoinedInstallation(part('c-motor'),17)).toBe(true)
 expect(isJoinedInstallation(part('c-motor'),18)).toBe(false)
})
it('separates visible caps and mounts using actual dimensions, not depth bias',()=>{
 const cap=seatedDependencyPart(part('c-end-0',[0,.04,0],[.095,.045,.025],'b'),13)
 expect(cap.pos[2]-cap.size[2]/2).toBeCloseTo(.025/2)
 const mount=seatedDependencyPart(part('recovery-stage-mount',[.16,.59,-.07],[.08,.035,.24]),18)
 expect(mount.size[0]/2).toBeCloseTo(.034-.012/2)
 const jaw=seatedDependencyPart(part('b-jaw',[0,0,0],[.09,.06,.035],'b'),9)
 expect(jaw.size[2]).toBeLessThan(.035)
 expect(jaw.pos).toEqual([0,0,0])
})
it('separates M13 lift, tilt gearbox and carried C slide in depth',()=>{
 const bed=seatedDependencyPart(part('a-bed',[0,.44,-.22],[.085,.54,.085]),13)
 const cBed=part('c-bed',[0,.04,.225],[.085,.025,.57],'b')
 const cWorldRear=-.5+cBed.pos[2]-cBed.size[2]/2
 expect(bed.pos[2]+bed.size[2]/2).toBeLessThan(cWorldRear)
 const box=seatedDependencyPart(part('tilt-housing',[0,.28,-.56],[.1,.1,.07]),13)
 const cMotorRear=-.5-.075-.10/2
 expect(box.pos[2]+box.size[2]/2).toBeLessThan(cMotorRear)
 const saddle=seatedDependencyPart(part('a-saddle',[0,0,0],[.1,.045,.13],'a'),13)
 expect(box.pos[1]-box.size[1]/2).toBeCloseTo(.23+saddle.pos[1]+saddle.size[1]/2)
 const saddleFront=-.28+saddle.pos[2]+saddle.size[2]/2
 expect(saddleFront).toBeGreaterThan(box.pos[2]-box.size[2]/2)
 expect(redundantDependencyPart(part('lift-tilt-mount'),13)).toBe(true)
})
