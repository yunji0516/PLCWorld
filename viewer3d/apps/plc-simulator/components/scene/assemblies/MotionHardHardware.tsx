'use client'
import {MotionAxisStand} from './MotionAxisStand'
import {FittedMaterialDrive} from './FittedMaterialDrive'

import { memo, useMemo, useRef, useContext, type ReactNode } from 'react'
import { useFrame } from '@react-three/fiber'
import { TendingPlate } from './TendingHardware'
import type { Group } from 'three'
import type { DeviceProps } from '../devices'
import type { MotionHardState } from '@/lib/replay/adapter'
import { MotionDiverseHardware } from './MotionDiverseHardware'
import { ServoAssembly } from './ServoAssembly'
import { MotionMiniProcessHardware } from './MotionMiniProcessHardware'
import { MotionDependencyHardware } from './MotionDependencyHardware'
import { FINISH, Part, RoundPart } from './Parts'
import {MotionCellFloorOffset,MotionCellPlatform,useMotionProcessDetail} from './MotionPresentation'

type V = [number,number,number]
type Reader = { motionHardState(): MotionHardState | undefined }
function Recorded({reader,node,children}:{reader:Reader;node:string;children:ReactNode}) {
  const ref=useRef<Group>(null)
  useFrame(()=>{const p=reader.motionHardState()?.poses[node],g=ref.current;if(p&&g){g.position.fromArray(p.pos);g.quaternion.fromArray(p.quaternion);g.scale.fromArray(p.scale??[1,1,1])}})
  return <group ref={ref} name={`motion-hard-pose-${node}`} userData={{equipmentUnit:true,equipmentGroup:`pose:${node}`,deviceDisplayName:node.replace(/_/g,' ')}}>{children}</group>
}
function Axis({reader,axis,base=[0,0,0],direction=[1,0,0],rotate=false,children}:{reader:Reader;axis:string;base?:V;direction?:V;rotate?:boolean;children:ReactNode}) {
  const ref=useRef<Group>(null)
  useFrame(()=>{const a=reader.motionHardState()?.axes[axis],g=ref.current;if(!a||!g)return;g.position.fromArray(base);if(rotate)g.rotation.z=a.actual*Math.PI/180;else g.position.addScaledVector({x:direction[0],y:direction[1],z:direction[2]} as import('three').Vector3,a.actual/1000)})
  return <group ref={ref} name={`motion-hard-axis-${axis}`} userData={{equipmentUnit:true,equipmentGroup:`axis:${axis}`,deviceDisplayName:`Servo axis ${axis.toUpperCase()}`}}>{children}</group>
}
function Rail({props,reader,axis,position=[0,.45,0],rotation=[0,0,0],length=2.35,offset=0,sign=1,height=.28,width=.42}:{props:DeviceProps;reader:Reader;axis:string;position?:V;rotation?:V;length?:number;offset?:number;sign?:number;height?:number;width?:number}) {
  const proxy=useMemo(()=>({state:()=>({pos:.5+(sign*(reader.motionHardState()?.axes[axis]?.actual??0)/1000-offset)/(length-.3)})}) as unknown as DeviceProps['plant'],[reader,axis,length,offset,sign])
  return <group position={position} rotation={rotation} name={`motion-hard-rail-${axis}`} userData={{equipmentUnit:true,equipmentGroup:`axis:${axis}`,deviceDisplayName:`Servo axis ${axis.toUpperCase()}`}}><ServoAssembly device={{...props.device,id:axis,size:[length,height,width],motionAxis:'x',color:FINISH.blue}} plant={proxy} driveOffsetZ={reader.motionHardState()?.rail_shift_z||reader.motionHardState()?.clearance_revision===7?-.12:0}/></group>
}
function Native({props,reader,id,mode,position=[0,0,0],rot=0}:{props:DeviceProps;reader:Reader;id:string;mode:string;position?:V;rot?:number}) {
  const proxy=useMemo(()=>({motionMechanism:()=>reader.motionHardState()?.mechanisms[id],motionHardInstance:()=>true}),[reader,id]) as unknown as DeviceProps['plant']
  return <group position={position} rotation={[0,rot,0]} name={`motion-hard-instance-${id}`} userData={{equipmentScope:true}}><MotionDiverseHardware device={{...props.device,id,visualVariant:`motion-v08-${mode}` as DeviceProps['device']['visualVariant']}} plant={proxy}/></group>
}
function Pedestal({position=[0,0,0],height=.45,width=.55,depth=.6}:{position?:V;height?:number;width?:number;depth?:number}) {
  return <group position={position}><Part name="anchored-footplate" position={[0,.035,0]} size={[width,.07,depth]} color={FINISH.dark}/><Part name="support-column" position={[0,height/2,0]} size={[.13,height,.18]} color={FINISH.blue}/></group>
}
function Cabinet({position=[1.5,0,-.8]}:{position?:V}) {
  // No simulated control equipment is associated with this decorative cabinet.
  return null
}

function Port({x}:{x:number}) {
  return <group position={[x,0,.51]} name="empty-receiver-port"><Pedestal height={.79} width={.17}/><Part position={[0,.79,0]} size={[.16,.06,.25]} color={FINISH.dark}/>{[-1,1].map(k=><Part key={k} position={[k*.065,.85,0]} size={[.04,.10,.22]} color={FINISH.alloy}/>)}</group>
}
export const MotionHardHardware = memo(function MotionHardHardware(props:DeviceProps) {
  const processDetail=useMotionProcessDetail(),platform=useContext(MotionCellPlatform)
  const reader=props.plant as unknown as Reader, state=reader.motionHardState(),m=state?.mode,railShift=state?.rail_shift_z??0
  const R=useMemo(()=>function BoundRecorded({node,children}:{node:string;children:ReactNode}) {return <Recorded reader={reader} node={node}>{children}</Recorded>},[reader])
  if(!state)return null
  if(state.dependency)return <MotionDependencyHardware {...props}/>
  if(m==='mini_process')return <MotionMiniProcessHardware {...props}/>
  let assembly:ReactNode
  if(m==='mini_motion_line') assembly=<>
    <group name="mini-line-lift-cell">
      <Part name="lift-bank-foot" position={[-.61,.05,.72]} size={[1.28,.10,.85]} color={FINISH.dark}/>
      {[-.9,-.35].map((x,k)=><group key={k}>
        <Rail props={props} reader={reader} axis={'cd'[k]} position={[x+.3,.9,.8]} rotation={[0,0,Math.PI/2]} length={1.5} offset={.7}/>
        <Part name="lift-bed-seat" position={[x+.3,.125,.8]} size={[.13,.05,.18]} color={FINISH.alloy}/>
        <R node={'lift'+k}>
          <Part name="empty-lift-platform" size={[.42,.08,.42]} color={FINISH.blue}/>
          <Part name="lift-carriage-mount" position={[.09,.12,.255]} size={[.09,.24,.20]} color={FINISH.alloy}/>
          {[-1,1].map(s=><group key={s}><Part name="lift-dock-side" position={[s*.0725,.215,0]} size={[.04,.11,.24]} color={FINISH.alloy}/><Part name="lift-jig-support" position={[s*.05,.10,0]} size={[.01,.12,.12]} color={FINISH.alloy}/></group>)}
        </R>
      </group>)}
        <TendingPlate label="① Lift preparation A / B" position={[-.5,1.5,.733]} size={[1.0,.13]}/>
    </group>
    <group name="mini-line-shuttle-cell">
      <Rail props={props} reader={reader} axis="a" position={[0,.6428,0]}/>
      {[-1,1].map(k=><Pedestal key={k} position={[k*.95,0,0]} height={.6428}/>)}
      <R node="shuttle"><Part name="fork-drive-housing" position={[0,0,-.05]} size={[.20,.12,.30]} color={FINISH.blue}/>{[-1,1].map(k=><RoundPart key={k} position={[k*.065,0,.12]} radius={.014} length={.32} axis="z"/>)}</R>
      <R node="fork"><Part name="empty-insertion-tongue" size={[.08,.045,.36]} color={FINISH.alloy}/><Part name="fork-coupling-pad" position={[0,.0275,.15]} size={[.08,.01,.12]} color={FINISH.dark}/></R>
      <TendingPlate label="② Shared shuttle" position={[0,.52,-.218]} size={[1.05,.13]}/>
    </group>
    <group name="mini-line-waiting-dock" position={[.15,0,.51]}>
      <Pedestal height={.8125} width={.2}/><Part name="waiting-dock-seat" position={[0,.8325,0]} size={[.18,.04,.24]} color={FINISH.dark}/>
      {[-1,1].map(s=><group key={s}><Part name="waiting-dock-side" position={[s*.0725,1.0275,0]} size={[.04,.11,.24]} color={FINISH.alloy}/><Part name="waiting-jig-support" position={[s*.05,.9125,0]} size={[.01,.12,.12]} color={FINISH.alloy}/></group>)}
      <TendingPlate label="Waiting station" position={[0,.78,-.125]} size={[.30,.075]} color="#9a6320"/>
    </group>
    <group name="mini-line-rotary-cell" position={[.85,0,1.06]}>
      <Native props={props} reader={reader} id="table" mode="table_slide"/>
      <Rail props={props} reader={reader} axis="f" position={[1.35,.8,0]} length={1.4} height={.24} width={.30} offset={-.35} sign={-1}/>
      <MotionAxisStand/>
      <TendingPlate label="③ Rotation" position={[0,.40,-.295]} size={[.50,.11]}/><TendingPlate label="Precision approach" position={[1.35,.5,-.255]} size={[.75,.12]}/>
    </group>
    <R node="table_seats">{[0,1,2,3].map(i=><group key={i} rotation={[0,-i*Math.PI/2,0]}>{[-1,1].map(s=><Part key={s} name="table-jig-support" position={[.55,.9275,s*.05]} size={[.12,.09,.01]} color={FINISH.alloy}/>)}</group>)}</R>
    {[0,1].map(k=><R key={k} node={'jig'+k}><Part name="circulating-setting-jig" size={[.10,.02,.12]} color={k?'#d99b36':'#2693b3'}/><Part name="setting-jig-datum" position={[0,.012,0]} size={[.03,.004,.06]} color={FINISH.steel}/></R>)}
    <Cabinet position={[-1.5,0,1.1]}/>
  </>
  else if(m==='shared_table_cell') assembly=<>
    <Native props={props} reader={reader} id="table" mode="table_slide"/>
    <Rail props={props} reader={reader} axis="b" position={[1.35,.8,0]} length={1.4} height={.24} width={.30} offset={-.35} sign={-1}/>
    <MotionAxisStand/>

    <Rail props={props} reader={reader} axis="c" position={[.55,1.65,-.92]} rotation={[0,Math.PI/2,Math.PI/2]} length={1.5} offset={1.315}/>
    <Part name="lift-foot" position={[.55,.05,-1.1]} size={[.65,.1,.7]} color={FINISH.dark}/>
    <Part name="lift-mast" position={[.55,1.35,-1.2]} size={[.25,2.6,.22]} color={FINISH.blue}/>
    {[1.1,1.65,2.2].map(y=><Part key={y} name="lift-bed-mount" position={[.55,y,-1.0218]} size={[.24,.10,.1364]} color={FINISH.alloy}/>)}
    <R node="lift_arm"><Part name="lift-carriage-arm" size={[.09,.07,.6828]} color={FINISH.alloy}/></R>
    <R node="lift_stem"><Part name="lift-tool-stem" size={[.05,.265,.05]} color={FINISH.alloy}/></R>
    <R node="lift_tip"><Part name="empty-lift-tongue" size={[.14,.07,.07]} color={FINISH.blue}/></R>
  </>
  else if(m==='cross') assembly=<>
    <Rail props={props} reader={reader} axis="a"/>
    <Rail props={props} reader={reader} axis="b" position={[0,1.45,0]} rotation={state.clearance_revision===7?[0,-Math.PI/2,Math.PI]:[0,-Math.PI/2,0]} sign={state.clearance_revision===7?-1:1}/>
    {[-1,1].map(k=><group key={k}><Pedestal position={[k*.95,0,0]}/>{state.clearance_revision===7?<><Pedestal position={[state.cross_support_x??-1.25,0,k*.95]} height={1.5336}/><Part name="overhead-cross-rail-bracket" position={[(state.cross_support_x??-1.25)/2,1.5336,k*.95]} size={[Math.abs(state.cross_support_x??-1.25)+.10,.10,.10]} color={FINISH.blue}/></>:<Pedestal position={[0,0,k*.95]} height={1.45}/>}</group>)}
    {[0,1].map(k=><group key={k}><R node={'head'+k}><Part name="protected-moving-head" size={[.20,.18,.20]} color={k?FINISH.dark:FINISH.blue}/></R><R node={'stem'+k}><Part name="head-support-stem" size={[1,1,1]} color={FINISH.alloy}/></R></group>)}
  </>
  else if(['shuttle','cancel','deadline'].includes(m??'')) assembly=<>
    <Rail props={props} reader={reader} axis="a" position={[0,.64,0]}/>{[-1,1].map(k=><Pedestal key={k} position={[k*.95,0,0]} height={.64}/>)}
    <R node="shuttle"><Part name="fork-drive-housing" position={[0,0,-.05]} size={[.20,.12,.30]} color={FINISH.blue}/>{[-1,1].map(k=><RoundPart key={k} position={[k*.065,0,.12]} radius={.014} length={.32} axis="z"/>)}</R>
    <R node="fork"><Part name="empty-insertion-tongue" size={[.08,.045,.36]} color={FINISH.alloy}/></R>
    {Array.from(new Set(state.requests.map(j=>j.target))).map(x=><Port key={x} x={x/1000}/>)}<Cabinet/>
  </>
  else if(['frame','capture','power'].includes(m??'')) assembly=<>
    {['a','b'].map((a,k)=><group key={a}><Rail props={props} reader={reader} axis={a} position={[0,.55,-.55+k*1.1]}/>{[-1,1].map(s=><Pedestal key={s} position={[s*.95,0,-.55+k*1.1]} height={.55}/>)}<Axis reader={reader} axis={a} base={[0,.85,-.55+k*1.1]}><Part name="empty-axis-tool" size={[.12,.16,.16]} color={k?FINISH.dark:FINISH.blue}/></Axis>
      {m==='capture'&&<Part name="registration-reference-mark" position={[(state.requests.find(j=>j.lane===k)?.mark??(-140+80*k))/1000,.59,-.84+k*1.1]} size={[.015,.10,.08]} color={FINISH.dark}/>}
    </group>)}
    {m==='frame'&&<><Part name="reference-datum-bar" position={[(state.requests.find(j=>j.lane===0)?.target??120)/1000,.6,-.77]} size={[.025,.24,.12]} color={FINISH.dark}/><Part name="common-coordinate-frame" position={[0,.12,0]} size={[2.4,.12,1.7]} color={FINISH.dark}/></>}
    {m==='power'&&<Part name="shared-power-bus-conduit" position={[1.22,.25,0]} size={[.045,.045,1.5]} color={FINISH.dark}/>}<Cabinet/>
  </>
  else if(m==='master') assembly=<>
    {['a','b','c'].map((a,k)=><group key={a} position={[-1+k,0,0]}><Pedestal height={.9} width={.65}/><RoundPart name="bearing-housing" position={[0,.92,0]} radius={.18} length={.4} color={FINISH.blue}/><RoundPart name="clutch-transmission-housing" position={[0,.92,-.24]} radius={.13} length={.22} color={FINISH.dark}/><RoundPart name="rotating-shaft" position={[0,.92,.2]} radius={.045} length={.35}/><Axis reader={reader} axis={a} base={[0,.92,.43]} rotate><RoundPart name="driven-disk" position={[0,0,0]} radius={.3} length={.07}/><Part name="shaft-angle-key" position={[0,.13,.04]} size={[.035,.26,.012]} color={FINISH.dark}/></Axis></group>)}
    <Part name="common-drive-transmission" position={[0,.9,-.3]} size={[2.4,.16,.16]} color={FINISH.dark}/><Cabinet/>
  </>
  else if(m==='pockets') assembly=<>
    {[[-.95,0],[0,-1.1],[.95,0]].map(([x,z],k)=><Native key={k} props={props} reader={reader} id={'robot'+k} mode="articulated" position={state.native_positions?.[k]??[x,0,z]}/>)}
    {state.native_positions?.map(([x,y,z],k)=><Part key={'riser'+k} name="robot-installation-riser" position={[x,y/2,z]} size={[.8,y,.8]} color={FINISH.blue}/>)}
    {[-1,1].map(k=><group key={k} position={[k*.35,0,state.pocket_z??.3]}><Pedestal height={.67} width={.24} depth={state.native_positions?.length?.30:.6}/><Part name="contact-pocket-base" position={[0,.70,0]} size={[.24,.06,.24]} color={FINISH.dark}/>{[-1,1].map(s=><Part key={s} name="compatible-pocket-side" position={[s*.10,.7225,0]} size={[.035,.025,.23]} color={FINISH.alloy}/>)}</group>)}
  </>
  else if(m==='corridor') assembly=<>
    {[0,1].map(k=><Native key={k} props={props} reader={reader} id={'mobile'+k} mode="mobile"/>)}
    {[-1,1].map(k=><group key={k}><Part name="shared-corridor-wall" position={[0,.2,k*.52]} size={[1,.4,.08]} color={FINISH.dark}/><Part name="approach-bay-guide" position={[k*1.2,.03,-.05]} size={[.75,.04,.025]} color={FINISH.blue}/></group>)}
  </>
  else if(m==='index') assembly=<>
    <Native props={props} reader={reader} id="table" mode="index_pin"/>
    {[0,1].map(k=><group key={k}><group position={[.85*(k===0?1:-1),.59,0]} rotation={[0,k===0?Math.PI:0,0]}><FittedMaterialDrive size={[.20,.23,.23]} axis="x"/></group><Part name="pin-drive-mounting-bracket" position={[.60*(k===0?1:-1),.49,0]} size={[.75,.09,.20]} color={FINISH.alloy}/><Part name="independent-pin-guide" position={[.48*(k===0?1:-1),.60,0]} size={[.10,.2,.12]} color={FINISH.blue}/><R node={'pin'+k}><RoundPart name="independent-approach-pin" position={[0,0,0]} radius={.016} length={.20} axis="y"/></R></group>)}
  </>
  else if(m==='booms') assembly=<>{[0,1].map(k=><Native key={k} props={props} reader={reader} id={'boom'+k} mode="telescopic" position={state.native_positions?.[k]??[-.6+k*1.2,0,0]} rot={k*Math.PI}/>)}</>
  else if(m==='level') assembly=<>
    {[0,1].map(k=><Native key={k} props={props} reader={reader} id={'lift'+k} mode="scissor" position={[-1.1+k*2.2,0,0]}/>)}
    <R node="beam"><Part name="common-supported-beam" size={[1,1,1]} color={FINISH.dark}/></R>

  </>
  else if(m==='balance') assembly=<>
    {[0,1].map(k=><Native key={k} props={props} reader={reader} id={'head'+k} mode="counterbalance" position={[-.9+k*1.8,0,0]}/>)}
    {/* Raised process cells already have a full-width foundation at this height.
        The legacy support occupied the same volume and produced coplanar top faces. */}
    {!platform&&!processDetail&&<Part name="common-moment-support" position={[0,(state.clearance_revision??0)>=6?-.04:.12,0]} size={[3.2,(state.clearance_revision??0)>=6?.08:.12,.35]} color={FINISH.dark}/>}
    <Axis reader={reader} axis="c" base={(state.clearance_revision??0)>=6?[0,.67,.195]:[0,.54,-.2]}><Part name="mechanically-linked-counterweight-bar" size={[1.8,.035,.035]} color={FINISH.steel}/>{[-1,1].map(k=>(state.clearance_revision??0)>=6?<group key={k}><Part name="counterweight-connecting-clevis" position={[k*.9,0,-.0975]} size={[.035,.035,.195]} color={FINISH.steel}/><Part name="counterweight-top-clamp" position={[k*.9,-.02,-.195]} size={[.035,.04,.035]} color={FINISH.steel}/></group>:<Part key={k} name="counterweight-connecting-clevis" position={[k*.9,0,.12]} size={[.035,.035,.24]} color={FINISH.steel}/>)}</Axis>
  </>
  else if(m==='brake_bank') assembly=<>
    {['a','b'].map((a,k)=><group key={a}><Rail props={props} reader={reader} axis={a} position={[-.65+k*1.3,.70,-.22+railShift]} rotation={[0,0,Math.PI/2]} length={1.5} offset={.5}/><Pedestal position={[-.65+k*1.3,0,-.22+railShift]} height={.15}/><R node={'lift'+k}><Part name="empty-lift-platform" size={[.42,.08,.42]} color={FINISH.blue}/></R>{railShift!==0&&<R node={'lift_mount'+k}><Part name="lift-carriage-offset-bracket" size={[1,1,1]} color={FINISH.alloy}/></R>}<Part name="fixed-brake-caliper-bracket" position={[-.65+k*1.3,.58,-.43+railShift]} size={[.20,.16,.04]} color={FINISH.blue}/><R node={'brake'+k}>{[-1,1].map(s=><Part key={s} name="common-brake-pad" position={[s*.06,0,-.18]} size={[.03,.12,.06]} color={FINISH.dark}/>)}</R>{railShift!==0&&<Part name="brake-linkage-return" position={[-.65+k*1.3,.58,.71]} size={[.045,.045,.54]} color={FINISH.steel}/>}</group>)}
    <Part name="common-brake-linkage" position={[0,.58,railShift!==0?.98:-.4]} size={[1.55,.045,.045]} color={FINISH.steel}/><Cabinet/>
  </>
  else assembly=null
  return <group name={`motion-hard-hardware-${m}`} userData={{mode:m,requestChannels:state.requests.length}}>{assembly}</group>
})
