'use client'

import {useMemo,useRef,type ReactNode} from 'react'
import {useFrame} from '@react-three/fiber'
import {type Group} from 'three'
import {DeviceMesh,type DeviceProps} from '../devices'
import {toMachine,type TraceTask,type MotionHardState,type MotionMechanism} from '@/lib/replay/adapter'
import {MotionHardHardware} from './MotionHardHardware'
import {MotionDiverseHardware} from './MotionDiverseHardware'
import {ServoAssembly} from './ServoAssembly'
import {FINISH,Part,RoundPart} from './Parts'
import {MotionPathGuide,PathBogie,PathCarriage} from './MotionPathGuide'
import {TendingPlate} from './TendingHardware'
import {useMotionRealism} from './MotionRealism'
import {MotionCellFloorOffset,MotionCellPlatform,useMotionProcessDetail} from './MotionPresentation'
import {MotionMachineBase} from './MotionMachineBase'
import {MotionAxisStand} from './MotionAxisStand'
import {SocketBolt} from '../IndustrialDetails'

type V=[number,number,number]
type Reader={motionHardState():MotionHardState|undefined}
type Cell=NonNullable<MotionHardState['process']>['cells'][string]
function Recorded({reader,node,children}:{reader:Reader;node:string;children:ReactNode}){
 const ref=useRef<Group>(null)
 useFrame(()=>{const p=reader.motionHardState()?.poses[node],g=ref.current;if(p&&g){g.position.fromArray(p.pos);g.quaternion.fromArray(p.quaternion);g.scale.fromArray(p.scale??[1,1,1])}})
 return <group ref={ref} name={'mini-process-pose-'+node}>{children}</group>
}

function Asset({device,plant,read}:{device:DeviceProps['device'];plant:DeviceProps['plant'];read:()=>Cell|undefined}){
 const ref=useRef<Group>(null)
 useFrame(()=>{const p=read()?.device_poses?.[device.id],g=ref.current;if(p&&g){g.position.fromArray(p.pos);g.quaternion.fromArray(p.quaternion??[0,0,0,1])}})
 return <group ref={ref} name={'reused-medium-asset-'+device.id} userData={{deviceDisplayName:device.label}} position={device.pos}><DeviceMesh device={device} plant={plant} detailed/></group>
}
function CellHardware({props,reader,id}:{props:DeviceProps;reader:Reader;id:string}){
 const proc=reader.motionHardState()!.process!,source=id==='source',cfg=source?undefined:proc.layout.cells[id],read=useMemo(()=>()=>reader.motionHardState()?.process?.cells[id],[reader,id]),cell=read()!
 const native=useMemo(()=>({motionMechanism:()=>read()?.mechanism,motionHardInstance:()=>true}),[read]) as unknown as DeviceProps['plant']
 const hard=useMemo(()=>({motionHardState:read}),[read]) as unknown as DeviceProps['plant']
 const assetMachine=useMemo(()=>cfg?.assets?.length?toMachine({suite:'motion',family:'motion_medium_v07',aim:'Reused Medium assembly',devices:cfg.assets,relations:[]} as unknown as TraceTask,'Reused cell'):undefined,[cfg])
 const assets=assetMachine?.devices??[]
 const assetPlant=useMemo(()=>({machine:assetMachine,state:(name:string)=>({pos:read()?.device_states?.[name]??0,vel:0}),motionState:()=>undefined}),[read,assetMachine]) as unknown as DeviceProps['plant']
 const m=cell.mode
 let content:ReactNode
 if(assets.length)content=<>{assets.map(d=><Asset key={d.id} device={d} plant={assetPlant} read={read}/>)}{m==='gear'&&<Part name="setting-fixture-pedestal" position={[0,.82,0]} size={[.18,.44,.24]} color={FINISH.dark}/>}</>
 else if(['table','hoist','counterbalance'].includes(m))content=<>
  <MotionDiverseHardware device={{...props.device,id:'native-'+id,visualVariant:`motion-v08-${m==='table'?'table_slide':m}` as DeviceProps['device']['visualVariant']}} plant={native}/>
  {m==='table'&&<TableRail props={props} read={read}/>}
 </>
 else content=<MotionHardHardware {...props} plant={hard}/>
 const position=source?proc.layout.source.position:cfg!.position
 const raised=position[1]
 const footSize=source?proc.layout.source.foot_size:cfg?.foot_size
 const frame=proc.layout.transport_path?.station_frames[id]
 const platformSize=footSize??[source?3.1:2.5,raised,source?1.5:1.75]
 const platformZ=(source?proc.layout.source.foot_offset_z:cfg?.foot_offset_z)??0
 // R3F skips undefined props: a straight layout must reset a previous path transform.
 return <group name={'path-installation-'+id} position={frame?.pos??[0,0,0]} quaternion={frame?.quaternion??[0,0,0,1]}><group name={'mini-process-cell-'+id} userData={{source:source?proc.layout.source_ids[1]:cfg!.source,mode:m}} position={position} rotation={[0,cfg?.rotation_y??0,0]}>
  {raised>.015&&!assets.some(d=>d.id==='BASE'&&d.size[1]>.18)&&<MotionMachineBase kind={['table','index','pockets','booms'].includes(m)?'casting':'skid'} position={[0,-raised,(source?proc.layout.source.foot_offset_z:cfg?.foot_offset_z)??0]} size={footSize??[source?3.1:2.5,raised,source?1.5:1.75]}/>}
  {cfg?.pocket_z!==undefined&&[-.35,.35].map(x=><Part key={x} name="pocket-ground-support" position={[x,-raised/2,cfg.pocket_z!]} size={[.28,raised,.30]} color={FINISH.dark}/>)}
  <MotionCellFloorOffset.Provider value={raised}><MotionCellPlatform.Provider value={raised>.015?{width:platformSize[0],depth:platformSize[2],z:platformZ}:null}>{content}</MotionCellPlatform.Provider></MotionCellFloorOffset.Provider>
  <TendingPlate label={`${source?'①':id==='3'?'③':'④'} ${source?proc.layout.labels[1]:cfg!.label}`} position={[0,.22,-.95]} size={[source?1.5:1.7,.18]}/>
 </group></group>
}
function TableRail({props,read}:{props:DeviceProps;read:()=>Cell|undefined}){
 const plant=useMemo(()=>({state:()=>({pos:.5+(.35-(read()?.axes.b.actual??50)/1000)/1.1})}),[read]) as unknown as DeviceProps['plant']
 return <>
  <group position={[1.35,.8,0]}><ServoAssembly device={{...props.device,id:'approach',size:[1.4,.24,.3],motionAxis:'x'}} plant={plant}/></group>
  <MotionAxisStand/>
 </>
}
function Receiver({reader,id}:{reader:Reader;id:number}){
 const p=reader.motionHardState()!.process!,mode=id<3?p.source_mode:p.layout.cells[String(id)].mode
 const revised=p.layout.clearance_revision!==undefined&&p.layout.clearance_revision>=5
 const height=revised?(mode==='level'?.12:mode==='index'?.10:.09):(mode==='level'||mode==='pockets'?.14:.10)
 if((p.layout.clearance_revision??0)>=6&&mode==='table')return <Recorded reader={reader} node={'receiver'+id}>{[-1,1].map(k=><Part key={k} name="table-jig-ledger" position={[k*.045,-.03875,0]} size={[.01,.0575,.12]} color={FINISH.alloy}/>)}</Recorded>
 const parts=<>
  {[-1,1].map(s=><group key={s}>
   <Part name="fixture-support-ledger" position={[s*.0675,-.01-height/2,0]} size={[.025,height,.16]} color={FINISH.alloy}/>
   {mode!=='table'&&<Part name="fixture-side-guide" position={[s*.0825,(p.layout.clearance_revision??0)>=6&&mode==='pockets'?.008:.026,0]} size={[.025,(p.layout.clearance_revision??0)>=6&&mode==='pockets'?.036:.072,.17]} color={FINISH.blue}/>}
  </group>)}
  <Part name="receiver-rear-bridge" position={[0,-.0675,.09]} size={[.19,.085,.045]} color={FINISH.alloy}/>
 </>
 if(mode==='pockets'){
  const cfg=p.layout.cells[String(id)],origin=cfg.position
  const frame=p.layout.transport_path?.station_frames[String(id)]
  return <group name={'path-pocket-installation-'+id} position={frame?.pos??[0,0,0]} quaternion={frame?.quaternion??[0,0,0,1]}><group name={'mini-process-fixed-pockets-'+id} position={origin}>{[-.35,.35].map(x=><group key={x} position={[x,.8525,cfg.pocket_z??.3]}>{parts}</group>)}</group></group>
 }
 return <Recorded reader={reader} node={'receiver'+id}>
  {parts}
 </Recorded>
}
/** Four existing cells share actual moving jigs and a continuous modular guide. */
export function MotionMiniProcessHardware(props:DeviceProps){
 const processDetail=useMotionProcessDetail(),realism=useMotionRealism()
 const detail=processDetail||realism
 const reader=props.plant as unknown as Reader,proc=reader.motionHardState()?.process
 const staticPlant=useMemo(()=>({state:()=>({pos:.5})}),[]) as unknown as DeviceProps['plant']
 const carriagePlant=useMemo(()=>({state:()=>({pos:.5+(reader.motionHardState()?.axes.a.actual??0)/2050})}),[reader]) as unknown as DeviceProps['plant']
 if(!proc)return null
 const revised=proc.layout.clearance_revision!==undefined&&proc.layout.clearance_revision>=5
 const railDevice={...props.device,id:'shared-shuttle',size:[2.35,.28,.42] as V,motionAxis:'x' as const,color:FINISH.blue}
 return <group name="motion-mini-process-hardware" userData={{sourceCells:proc.layout.source_ids,task:proc.slug}}>
  <CellHardware props={props} reader={reader} id="source"/>
  <CellHardware props={props} reader={reader} id="3"/>
  <CellHardware props={props} reader={reader} id="4"/>
  <group name="mini-process-cell-transfer" userData={{source:proc.layout.source_ids[0]}}>
   {proc.layout.transport_path?<><MotionPathGuide layout={proc.layout}/><Recorded reader={reader} node="path_carriage"><PathCarriage/></Recorded>{[0,1].map(i=><Recorded key={i} reader={reader} node={'path_bogie'+i}><PathBogie/></Recorded>)}</>:<>
   {proc.layout.rails.map(x=><group key={x} position={[x,proc.layout.rail_y,0]}>
    <ServoAssembly device={railDevice} plant={staticPlant} staticOnly driveOffsetZ={revised?-.12:0}/>
    {[-.8,.8].map(k=><group key={k}><Part name="track-support" position={[k,-proc.layout.rail_y/2,0]} size={[.16,proc.layout.rail_y,.24]} color={FINISH.dark}/><Part position={[k,-proc.layout.rail_y+.04,0]} size={[.5,.08,.65]} color={FINISH.dark}/>
      {detail&&<Part name="track-bearing-mount-cap" position={[k,-.14,0]} size={[.32,.035,.40]} color={FINISH.alloy}/>}
      {detail&&[-1,1].flatMap(s=>[-1,1].map(z=><SocketBolt key={`${s}-${z}`} position={[k+s*.18,-proc.layout.rail_y+.083,z*.24]} radius={.013} top/>))}
    </group>)}
    {detail&&<Part name="track-frame-cross-brace" position={[0,-proc.layout.rail_y+.28,0]} size={[1.60,.09,.12]} color={FINISH.steel}/>}
   </group>)}
   {[-2.35,0,2.35].map(x=><group key={x} position={[x,proc.layout.rail_y,0]}>
    {[-1,1].map(s=><group key={s}>
      <Part name="guide-segment-side-splice" position={[0,0,s*.216]} size={[.16,.04,.012]} color={FINISH.steel}/>
      <group position={[0,0,s*.223]} rotation={[0,s<0?Math.PI:0,0]}>{[-.055,.055].map(x=><SocketBolt key={x} position={[x,0,0]} radius={.004}/>)}</group>
      <Part name="guide-track-joint-key" position={[0,.0616,s*.1176]} size={[.094,.0364,.0504]}/>
    </group>)}
   </group>)}
   <group position={[0,proc.layout.rail_y,0]}><ServoAssembly device={railDevice} plant={carriagePlant} carriageOnly/></group></>}
   <Recorded reader={reader} node="shuttle">
    {revised?<group name="shuttle-fork-open-guide">
     {[-1,1].map(s=><group key={s}><Part name="fork-guide-side" position={[s*.09,0,-.05]} size={[.02,.084,.30]} color={FINISH.blue}/><Part name="fork-guide-deck" position={[0,s*.051,-.05]} size={[.20,.018,.30]} color={FINISH.blue}/></group>)}
     <Part name="fork-drive-rear-cap" position={[0,0,-.19]} size={[.16,.084,.02]} color={FINISH.blue}/>
    </group>:<Part name="reused-shuttle-fork-drive" position={[0,0,-.05]} size={[.20,.12,.30]} color={FINISH.blue}/>}
    {[-1,1].map(s=><RoundPart key={s} position={[s*.065,0,.12]} radius={.014} length={.32} axis="z"/>)}</Recorded>
   <Recorded reader={reader} node="fork"><Part name="reused-insertion-fork" size={[.08,.045,.36]}/><Part name="fork-coupling-pad" position={[0,.0275,.15]} size={[.08,.01,.12]} color={FINISH.dark}/></Recorded>
   <TendingPlate label="② Shared shuttle · cell connection and return" position={[0,.9,-.22]} size={[2.5,.19]}/>
  </group>
  {[1,2,3,4].map(id=><Receiver key={id} reader={reader} id={id}/>)}
  {Object.keys(reader.motionHardState()!.poses).filter(k=>k.startsWith('connector')).map(k=><Recorded key={k} reader={reader} node={k}><Part name="rigid-fixture-mount" size={[1,1,1]} color={FINISH.alloy}/></Recorded>)}
  {[0,1].map(k=><Recorded key={k} reader={reader} node={'jig'+k}><Part name="circulating-setting-jig" size={[.10,.02,.12]} color={k?'#d99b36':'#2693b3'}/><Part name="setting-datum" position={[0,.016,0]} size={[.04,.012,.07]} color={FINISH.dark}/></Recorded>)}
 </group>
}
