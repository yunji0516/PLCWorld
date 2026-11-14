import {expect,it} from 'vitest'
import {hydrateMotionProcessLayouts,TracePlant,type Frame,type TraceTask,type MotionHardState} from './adapter'
import {withActiveMotionReplay} from '@/app/replay/motionReplayCache'

function frames(label:string){
 return [{k:0,world:{motion_hard:{process:{layout:{label}},poses:{jig:{pos:[0,1,0]}}}}},
  {k:1,world:{motion_hard:{process:{},poses:{jig:{pos:[2,1,-3]}}}}}] as unknown as Frame[]
}
it('restores one shared installation per run while preserving every moving pose',()=>{
 const normal=frames('normal'),alt=frames('alternative'),pose=normal[1].world!.motion_hard!.poses
 const task={suite:'motion',difficulty:'hard',replay_shared_motion_layout:true,runs:{normal:{frames:normal},alt:{frames:alt}}} as unknown as TraceTask
 const loaded=withActiveMotionReplay({},'MOT-H07',task)['MOT-H07']
 expect(loaded).toBe(task)
 expect(normal[1].world!.motion_hard!.process!.layout).toBe(normal[0].world!.motion_hard!.process!.layout)
 expect(alt[1].world!.motion_hard!.process!.layout).toBe(alt[0].world!.motion_hard!.process!.layout)
 expect(alt[1].world!.motion_hard!.process!.layout).not.toBe(normal[1].world!.motion_hard!.process!.layout)
 expect(normal[1].world!.motion_hard!.poses).toBe(pose)
})
it('direct replay readers retain geometry when seeking forward and backward',()=>{
 const data=frames('square'),plant=new TracePlant({} as ConstructorParameters<typeof TracePlant>[0],[],data)
 plant.k=1;expect(plant.motionHardState()!.process!.layout).toBe(data[0].world!.motion_hard!.process!.layout)
 expect(plant.motionHardState()!.poses.jig.pos).toEqual([2,1,-3])
 plant.k=0;expect(plant.motionHardState()!.poses.jig.pos).toEqual([0,1,0])
})
it('preserves explicitly recorded legacy layouts and non-Motion frames',()=>{
 const data=frames('original'),other={label:'per-frame installation'}
 data[1].world!.motion_hard!.process!.layout=other as unknown as NonNullable<MotionHardState['process']>['layout']
 hydrateMotionProcessLayouts(data);expect(data[1].world!.motion_hard!.process!.layout).toBe(other)
 const material=[{k:0,world:{parts:{}}}] as unknown as Frame[];const before=JSON.stringify(material);hydrateMotionProcessLayouts(material);expect(JSON.stringify(material)).toBe(before)
})
