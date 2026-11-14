import {useRef,type RefObject} from 'react'
import {useFrame} from '@react-three/fiber'
import {Group} from 'three'
import type {Node,Frame} from '@/app/replay/hard-processes/ReviewCanvas'
import {Part,RoundPart,FINISH} from './Parts'
import {SocketBolt} from '../IndustrialDetails'

export function replacedStationHardware(nodes:Node[],id:string){
 if(nodes.some(n=>n.id==='edge_knife_left'))return /^(tool_post.*|die_xbeam|pick_support|pick_bridge|vacuum_rod)$/.test(id)
 if(nodes.some(n=>n.id==='leader_grip'))return /^nip_post_[ab]$/.test(id)
 return false
}
function PickActuator({nodes,frame}:{nodes:Node[];frame:RefObject<Frame>}){
 const head=useRef<Group>(null),rod=useRef<Group>(null)
 useFrame(()=>{
  const car=frame.current.poses.pick_carriage??nodes.find(n=>n.id==='pick_carriage')!,pad=frame.current.poses.vacuum_pad??nodes.find(n=>n.id==='vacuum_pad')!
  const top=car.p[1]-.0275,bottom=top-.10,end=pad.p[1]+.025
  if(head.current)head.current.position.set(car.p[0],top,car.p[2])
  if(rod.current){rod.current.position.set(pad.p[0],(bottom+end)/2,pad.p[2]);rod.current.scale.y=Math.max(.001,bottom-end)}
 })
 return <><group ref={head} name="pick-guided-actuator">
  <Part name="pick-cylinder-flange" position={[0,-.008,0]} size={[.115,.016,.10]} color={FINISH.steel}/>
  <Part name="pick-cylinder-body" position={[0,-.058,0]} size={[.065,.084,.065]} color={FINISH.alloy} radius={.006}/>
  <RoundPart name="pick-rod-bearing" position={[0,-.101,0]} axis="y" radius={.021} length={.008} color={FINISH.dark}/>
  {[-1,1].map(k=><SocketBolt key={k} position={[k*.023,-.05,.034]} radius={.004}/>)}
 </group><group ref={rod}><RoundPart name="pick-telescopic-shaft" position={[0,0,0]} axis="y" radius={.012} length={1}/></group></>
}
function RollTransferStage({frame,id}:{frame:RefObject<Frame>;id:string}){
 const ref=useRef<Group>(null),saddle=useRef<Group>(null)
 useFrame(()=>{const p=frame.current.poses[id];if(!p)return;if(ref.current)ref.current.position.z=p.p[2];if(saddle.current)saddle.current.position.x=p.p[0]})
 return <group ref={ref} name={id+'-xz-stage'}>
  {[.25,1.35].map(x=><Part key={x} name="z-travel-bearing" position={[x,.593,0]} size={[.07,.032,.30]} color={FINISH.alloy}/>)}
  {[-.10,.10].map(z=><RoundPart key={z} name="moving-x-guide" position={[.80,.62,z]} axis="x" radius={.014} length={1.10}/>)}
  <group ref={saddle}><Part name="roll-x-saddle" position={[0,.638,0]} size={[.16,.024,.25]} color="#39749a"/></group>
 </group>
}
export function ReviewStationRedesign({nodes,frame}:{nodes:Node[];frame:RefObject<Frame>}){
 const die=nodes.some(n=>n.id==='edge_knife_left'),leader=nodes.some(n=>n.id==='leader_grip')
 return <>
 {die&&<group name="roll-exchange-guided-stages">
  {[.25,1.35].map(x=><group key={x}>
   <Part name="z-guide-bed" position={[x,.53275,-.15]} size={[.055,.0205,2.1]} color={FINISH.alloy}/>
   <RoundPart name="fixed-z-guide" position={[x,.56,-.15]} axis="z" radius={.017} length={2.1}/>
  </group>)}
  <RollTransferStage id="waste_carriage" frame={frame}/><RollTransferStage id="waste_roll2_cradle" frame={frame}/>
 </group>}
 {die&&<group name="die-pick-integrated-station">
  {[-.78,-.22].map(x=><group key={x}>
   <Part name="station-column" position={[x,.828,-.42]} size={[.06,1.584,.075]} color={FINISH.dark}/>
   <Part name="column-foot" position={[x,.018,-.42]} size={[.13,.036,.14]} color={FINISH.dark}/>
   {[-1,1].map(k=><SocketBolt key={k} top position={[x+k*.043,.037,-.42]} radius={.005}/>)}
  </group>)}
  <Part name="upper-station-crossbeam" position={[-.5,1.65,-.42]} size={[.62,.06,.075]} color={FINISH.dark}/>
  <Part name="pick-rail-root" position={[-.5,1.56,-.42]} size={[.10,.12,.075]} color={FINISH.dark}/>
  <Part name="pick-linear-rail" position={[-.5,1.5325,.03375]} size={[.08,.05,.8325]} color={FINISH.alloy}/>
  <Part name="pick-rail-endcap" position={[-.5,1.5325,.456]} size={[.082,.052,.012]} color={FINISH.dark}/>
  <Part name="die-rail-support-beam" position={[-.5,1.425,-.42]} size={[.50,.05,.075]} color={FINISH.dark}/>
  {[-.68,-.32].map(x=><Part key={x} name="die-rail-end-seat" position={[x,1.41,-.34125]} size={[.065,.02,.0825]} color={FINISH.steel}/>)}
  <PickActuator nodes={nodes} frame={frame}/>
 </group>}
 {nodes.some(n=>n.id==='nozzle_slide_a')&&<group name="refill-coupler-table-mount">
  <Part name="coupler-table-foot" position={[0,1.0035,2.305]} size={[.10,.012,.04]} color={FINISH.steel}/>
  {[-1,1].map(k=><SocketBolt key={k} top position={[k*.035,1.010,2.305]} radius={.004}/>)}
  <Part name="coupler-cantilever" position={[0,1.0035,2.23]} size={[.035,.012,.11]} color={FINISH.steel}/>
  <Part name="coupler-upright" position={[0,1.1835,2.1925]} size={[.035,.348,.035]} color={FINISH.dark}/>
  <Part name="coupler-pipe-saddle" position={[0,1.370,2.1925]} size={[.065,.025,.06]} color={FINISH.alloy}/>
 </group>}
 {leader&&<group name="leader-guide-service-frame">
  <Part name="leader-service-column" position={[.18,.70,.34]} size={[.06,1.40,.06]} color={FINISH.dark}/>
  <Part name="leader-column-foot" position={[.18,.025,.34]} size={[.18,.05,.16]} color={FINISH.dark}/>
  <Part name="leader-cantilever" position={[.18,1.34,.17]} size={[.06,.075,.28]} color={FINISH.dark}/>
  <Part name="leader-slide-seat" position={[.20,1.345,0]} size={[.10,.015,.06]} color={FINISH.alloy}/>
  <Part name="trim-stage-bed" position={[.11,.741,-.4]} size={[.66,.05,.12]} color={FINISH.alloy}/>
  {[-.18,.40].map(x=><group key={x}>
   <Part name="trim-stage-support-column" position={[x,.358,-.4]} size={[.045,.716,.06]} color={FINISH.dark}/>
   <Part name="trim-stage-foot" position={[x,.018,-.4]} size={[.09,.036,.10]} color={FINISH.dark}/>
  </group>)}
 </group>}
 </>
}
