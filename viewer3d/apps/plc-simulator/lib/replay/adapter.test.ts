import { describe, expect, it } from 'vitest'
import { TracePlant, toMachine, toReplayMachine, type TraceTask, type Frame } from './adapter'

describe('canonical replay adapter', () => {
  it('preserves occupied and empty Material slots across replay and rewind', () => {
    const task: TraceTask = { title:'magazine', aim:'', req:'', suite:'material', io:{}, observed:[], runs:{},
      devices:[{id:'CELL',kind:'act',ui:'fixture',visual_variant:'v7-magazine-base',pos:[0,0,0]}] }
    const slot = (visible:boolean) => ({pos:[.7,.735,0] as [number,number,number], visible,
      material_dimensions:[.30,.03,.22] as [number,number,number]})
    const frames: Frame[] = [true,false].map((visible,k)=>({k,x:{},y:{},s:{},v:0,
      world:{devices:{},parts:{OLD0:slot(visible),OLD1:slot(!visible)}}}))
    const machine=toMachine(task,''),plant=new TracePlant(machine,task.devices,frames)
    for (const k of [0,1,0]) {
      plant.setFrame(k)
      expect(plant.parts.map(p=>p.visible)).toEqual([k===0,k!==0])
      expect(plant.parts[0].materialDimensions).toEqual([.30,.03,.22])
    }
    expect(machine.devices[0].label).toBe('Magazine storage frame')
    expect(toMachine({...task,suite:'motion'},'').devices[0].sceneLabelOffset).toBeUndefined()
  })
  it('keeps A/B workpieces distinct across reordering, disappearance and rewind', () => {
    const task: TraceTask = {title:'stack',aim:'',req:'',suite:'material',io:{},observed:[],runs:{},devices:[]}
    const part = (x: number) => ({pos:[x,.7,0] as [number,number,number], status:'held' as const, held_by:'TOOL'})
    const frames: Frame[] = [
      {k:0,x:{},y:{},s:{},v:0,world:{devices:{},parts:{A1:part(1),B1:part(2),A2:part(3),B2:part(4)}}},
      {k:1,x:{},y:{},s:{},v:0,world:{devices:{},parts:{B2:part(4),A1:part(1)}}},
    ]
    const plant = new TracePlant(toMachine(task,''),[],frames)
    plant.setFrame(0)
    const ids = new Map(plant.parts.map(p=>[p.x,p.id]))
    expect(new Set(ids.values()).size).toBe(4)
    for (const k of [1,0]) {
      plant.setFrame(k)
      for (const p of plant.parts) expect(p.id).toBe(ids.get(p.x))
    }
  })
  it('preserves continuous Motion Easy shaft angles and its opted-in hardware', () => {
    const task: TraceTask = {title:'speed',aim:'',req:'',suite:'motion',family:'motion_easy_function',io:{},observed:[],runs:{},
      devices:[{id:'AXIS',kind:'act',ui:'spindle',visual_variant:'motion-easy-roll'}]}
    const frames=[{k:0,x:{},y:{},s:{AXIS:15.7},v:240}]
    const machine=toMachine(task,''), plant=new TracePlant(machine,task.devices,frames)
    expect(machine.devices[0].visualVariant).toBe('motion-easy-roll')
    expect(plant.state('AXIS').pos).toBe(15.7)
    expect(plant.state('AXIS').spin).toBe(15.7)
    expect(toMachine({...task,family:'motion_axis'},'').devices[0].visualVariant).toBeUndefined()
  })
  it('preserves opt-in pressure tooling and hollow workpiece poses without changing legacy parts', () => {
    const task: TraceTask = {title:'pressure',aim:'',req:'',suite:'material',io:{},observed:[],runs:{},
      devices:[{id:'HEAD',kind:'act',ui:'gripper',visual_variant:'pressure-seal-head'}]}
    const frames=[{k:0,x:{},y:{},s:{},v:0,world:{devices:{},parts:{
      PART_01:{pos:[0,.68,0] as [number,number,number],render_variant:'pressure-vessel' as const,color:'#d7a655'},
      PART_02:{pos:[1,.68,0] as [number,number,number]},
    }}}]
    const machine=toMachine(task,''),plant=new TracePlant(machine,task.devices,frames)
    plant.setFrame(0)
    expect(machine.devices[0].visualVariant).toBe('pressure-seal-head')
    expect(toMachine({...task,suite:'motion'},'').devices[0].visualVariant).toBeUndefined()
    expect(plant.parts[0]).toMatchObject({x:0,y:.68,z:0,renderVariant:'pressure-vessel',color:'#d7a655'})
    expect(plant.parts[1].renderVariant).toBeUndefined()
  })
  it('rotates only opted-in Material assemblies and preserves the Motion behavior', () => {
    const q: [number, number, number, number] = [0, -.5, 0, Math.sqrt(.75)]
    const task: TraceTask = { title: '', aim: '', req: '', suite: 'material', io: {}, observed: [], runs: {},
      devices: [{ id: 'ARM', kind: 'act', ui: 'gripper', dynamic_world_rotation: true },
        { id: 'LEGACY', kind: 'act', ui: 'gripper' }] }
    const frames = [{ k: 0, x: {}, y: {}, s: {}, v: 0, world: { parts: {}, devices: {
      ARM: { pos: [0, 1, 0] as [number, number, number], quaternion: q },
      LEGACY: { pos: [1, 1, 0] as [number, number, number], quaternion: q },
    } } }]
    const machine = toMachine(task, '')
    new TracePlant(machine, task.devices, frames).setFrame(0)
    expect(machine.devices[0].replayQuaternion).toEqual(q)
    expect(machine.devices[1].replayQuaternion).toBeUndefined()
    const motion = toMachine({ ...task, suite: 'motion' }, '')
    new TracePlant(motion, task.devices, frames).setFrame(0)
    expect(motion.devices[1].replayQuaternion).toEqual(q)
  })
  it('calibrates the H02 tool contact without modifying the recorded devices or PLC state', () => {
    const task: TraceTask = { title: 'assembly', aim: '', req: '', suite: 'material', family: 'dual_component_assembly', io: {}, observed: [], runs: {}, devices: [
      { id: 'JOIN_PRESS', kind: 'act', ui: 'press', pos: [-.1, 1.38, 0], size: [.46, .68, .46] },
      { id: 'ASSEMBLY_FIXTURE', kind: 'static', ui: 'fixture', pos: [-.1, .64, 0], size: [.64, .08, .6] },
    ] }
    const original = JSON.stringify(task), [press, fixture] = toMachine(task, '').devices
    expect(press.pressMaxTravel).toBeCloseTo(.2376)
    expect(press.pos[1] - press.pressMaxTravel! - press.size[1] * .18 - .06).toBeCloseTo(.96)
    expect(fixture.pos[1] + fixture.size[1] / 2 + fixture.fixtureTopOffset!).toBeCloseTo(.64)
    expect(toMachine({ ...task, family: 'motion_axis' }, '').devices[0].pressMaxTravel).toBeUndefined()
    expect(JSON.stringify(task)).toBe(original)
  })
  it('matches E01 framing to E02 without changing any device or trace coordinates', () => {
    const first: TraceTask = { title: 'grip', aim: '', req: '', suite: 'material', io: {}, observed: [], runs: {},
      devices: [
        { id: 'CELL_FRAME_A', kind: 'static', ui: 'support_frame', pos: [0, .925, -.55], size: [1.15, 1.85, .35] },
        { id: 'FIXTURE_A', kind: 'static', ui: 'fixture', pos: [0, .275, 0], size: [.8, .55, .7] },
      ] }
    const second: TraceTask = { ...first, title: 'vacuum', devices: [...first.devices,
      { id: 'PHOTO_BRACKET', kind: 'static', ui: 'platform', pos: [0, .53, .375], size: [.12, .04, .15] }] }
    const trace = { 'MAT-E01': first, 'MAT-E02': second, 'MOT-E01': first }
    const original = JSON.stringify(trace)
    const one = toReplayMachine(trace, 'MAT-E01'), two = toReplayMachine(trace, 'MAT-E02')
    expect(one.geometry.view).toEqual(two.geometry.view)
    expect(one.devices).toEqual(toMachine(first, '').devices)
    expect(two).toEqual(toMachine(second, 'MAT-E02 · vacuum'))
    expect(toReplayMachine(trace, 'MOT-E01')).toEqual(toMachine(first, 'MOT-E01 · grip'))
    expect(JSON.stringify(trace)).toBe(original)
    expect(toReplayMachine({ 'MAT-E01': first }, 'MAT-E01')).toEqual(toMachine(first, 'MAT-E01 · grip'))
  })
  it('limits the single vacuum cup to explicitly opted-in Material devices', () => {
    const task: TraceTask = {
      title: 'vacuum', aim: '', req: '', io: {}, observed: [], runs: {},
      devices: [{ id: 'VACUUM_A', kind: 'act', ui: 'vacuum', visual_variant: 'single-vacuum-cup' }],
    }
    expect(toMachine({ ...task, suite: 'material' }, '').devices[0].visualVariant).toBe('single-vacuum-cup')
    expect(toMachine({ ...task, suite: 'motion' }, '').devices[0].visualVariant).toBeUndefined()
    expect(toMachine({ ...task, suite: 'material' }, '').replaySuite).toBe('material')
    expect(toMachine({ ...task, suite: 'motion' }, '').replaySuite).toBe('motion')
  })
  it('enables optical clipping and turnover variants only for Material', () => {
    const task: TraceTask = {
      title: 'scope', aim: 'scope', req: 'scope', io: {}, observed: [], runs: {},
      devices: [{ id: 'PHOTO', kind: 'act', ui: 'sensor', visual_variant: 'turnover-jaws' }],
    }
    expect(toMachine({ ...task, suite: 'material' }, task.title).devices[0].clipPhotoeyeBeam).toBe(true)
    for (const suite of ['motion', 'test', undefined] as const) {
      const d = toMachine({ ...task, suite }, task.title).devices[0]
      expect(d.clipPhotoeyeBeam).toBe(false)
      expect(d.visualVariant).toBeUndefined()
    }
  })
  it('preserves engine-owned workpiece attachment while device state is read', () => {
    const task: TraceTask = {
      title: 'public synthetic handoff',
      aim: 'adapter test',
      req: 'hold the workpiece after transfer',
      io: {},
      devices: [
        {
          id: 'AXIS_A', kind: 'act', ui: 'servo', drive: 'Y0',
          pos: [0, 0.8, 0], size: [2.4, 0.3, 0.5],
        },
        {
          id: 'GRIPPER_B', kind: 'act', ui: 'gripper', drive: 'Y11',
          pos: [1.05, 1.36, 0], size: [0.34, 0.34, 0.26],
        },
      ],
      observed: ['Y0', 'Y11'],
      runs: {},
    }
    const frames = [{
      k: 0,
      y: { Y0: 0, Y11: 1 },
      x: { X12: 1 },
      s: { AXIS_A: 1, GRIPPER_B: 1 },
      v: 0,
      world: {
        devices: {},
        parts: {
          PART_01: {
            pos: [1.05, 1.08, 0] as [number, number, number],
            held_by: 'GRIPPER_B',
            status: 'held' as const,
          },
        },
        events: ['workpiece_transferred'],
      },
    }]
    const machine = toMachine(task, task.title)
    const plant = new TracePlant(machine, task.devices, frames)
    plant.setFrame(0)

    expect(machine.devices.find((device) => device.id === 'AXIS_A')?.kind).toBe('servo')
    expect(plant.parts[0].heldBy).toBe('GRIPPER_B')
    expect(plant.parts[0].x).toBe(1.05)
    plant.state('AXIS_A')
    expect(plant.parts[0].heldBy).toBe('GRIPPER_B')
  })

  it('shows vacuum physical engagement instead of the release command', () => {
    const task: TraceTask = {
      title: 'vacuum place', aim: 'adapter test', req: 'release after lowering', io: {},
      devices: [{ id: 'VACUUM_A', kind: 'act', ui: 'vacuum', drive: 'Y10' }],
      observed: ['Y10'], runs: {},
    }
    const frames = [{ k: 0, y: { Y10: 0 }, x: {}, s: { VACUUM_A: 1 }, v: 0 }]
    const machine = toMachine(task, task.title)
    const plant = new TracePlant(machine, task.devices, frames)

    expect(plant.state('VACUUM_A').running).toBe(true)
  })

  it('derives conveyor marker motion from the recorded trace position', () => {
    const task: TraceTask = {
      title: 'conveyor', aim: 'adapter test', req: 'move to target', io: {},
      devices: [{ id: 'CONVEYOR_A', kind: 'act', ui: 'conveyor', drive: 'Y20' }],
      observed: ['Y20'], runs: {},
    }
    const frames = [{ k: 0, y: { Y20: 1 }, x: {}, s: { CONVEYOR_A: 0.5 }, v: 0 }]
    const plant = new TracePlant(toMachine(task, task.title), task.devices, frames)

    expect(plant.state('CONVEYOR_A').spin).toBeCloseTo(Math.PI)
  })
})

it('faces the tending cell openings and places its floor band on the same side', () => {
  const task: TraceTask = {title:'tending',aim:'',req:'',suite:'material',family:'shared_dual_machine_tending',io:{},observed:[],runs:{},devices:[],assembly_view:{dist:3.5,target:[0,.8,0],front_sign:1}}
  const original=JSON.stringify(task)
  const machine=toMachine(task,'MAT-H01 · tending')
  expect(machine.geometry.view.frontSign).toBe(-1)
  expect(machine.floorFrontSign).toBe(-1)
  expect(JSON.stringify(task)).toBe(original)
})

it('uses detailed equipment IDs for scene selection without rewriting the task', () => {
  const task:TraceTask={title:'winding',aim:'',req:'',suite:'material',io:{},observed:[],runs:{},devices:[{id:'CELL',kind:'static',ui:'fixture'}]}
  const display:TraceTask['devices']=[{id:'tail_tape_knife',label:'Tail tape knife',kind:'static',ui:'fixture',pos:[.85,1.34,.35]}]
  const machine=toReplayMachine({'MAT-H07':task},'MAT-H07',display)
  expect(machine.devices.map(device=>device.id)).toEqual(['tail_tape_knife'])
  expect(task.devices.map(device=>device.id)).toEqual(['CELL'])
})
