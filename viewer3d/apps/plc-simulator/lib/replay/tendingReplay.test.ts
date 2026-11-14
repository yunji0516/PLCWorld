import { describe, expect, it } from 'vitest'
import { TracePlant, toMachine, type TraceTask } from './adapter'

const task: TraceTask={title:'tending',aim:'',req:'',suite:'material',io:{},observed:[],runs:{},
  devices:[{id:'BENCH',kind:'static',ui:'fixture',pos:[1,.4,0],size:[.5,.8,.5],visual_variant:'hard-workbench'},
    {id:'TOOL',kind:'act',ui:'gripper',pos:[0,1.9,-1],dynamic_world_position:true}],
  assembly_view:{dist:8.3,target:[.6,1.1,-.25],front_sign:-1}}

describe('opt-in tending replay',()=>{
  it('moves only the Material tending floor stripe to its negative-Z working side',()=>{
    expect(toMachine({...task,family:'shared_dual_machine_tending'},'').floorFrontSign).toBe(-1)
    expect(toMachine({...task,family:'robot_local_acquire'},'').floorFrontSign).toBeUndefined()
    expect(toMachine({...task,family:'shared_dual_machine_tending',suite:'motion'},'').floorFrontSign).toBeUndefined()
    expect(toMachine(task,'').floorFrontSign).toBeUndefined()
  })
  it('faces the declared working front without changing legacy framing',()=>{
    expect(toMachine(task,'').geometry.view.frontSign).toBe(-1)
    expect(toMachine({...task,assembly_view:undefined},'').geometry.view.frontSign).toBeUndefined()
    expect(toMachine({...task,suite:'motion'},'').geometry.view.frontSign).toBeUndefined()
    expect(toMachine({...task,suite:'motion'},'').devices[0].visualVariant).toBeUndefined()
  })
  it('supports random seeking with declared static poses and explicit dynamic poses',()=>{
    const machine=toMachine(task,'')
    const frames=[0,1].map(k=>({k,x:{},y:{},s:{TOOL:k},v:0,world:{devices:{TOOL:{pos:[k,1.9,-1] as [number,number,number]}},parts:{}}}))
    const plant=new TracePlant(machine,task.devices,frames)
    plant.setFrame(1);expect(machine.devices[1].pos).toEqual([1,1.9,-1])
    plant.setFrame(0);expect(machine.devices[1].pos).toEqual([0,1.9,-1])
    expect(machine.devices[0].pos).toEqual([1,.4,0])
  })
})
