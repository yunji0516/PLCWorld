import {useRef,type RefObject} from 'react'
import {useFrame} from '@react-three/fiber'
import {Group} from 'three'
import type {Node,Frame} from '@/app/replay/hard-processes/ReviewCanvas'
import {Part,RoundPart,BoredPlate,FINISH} from './Parts'
import {SocketBolt} from '../IndustrialDetails'

type Context={nodes:Node[];frame:RefObject<Frame>}
export function replacedStackTransfer(nodes:Node[],id:string){return nodes.some(n=>n.id==='empty_pallet_lift')&&/^(fork_xcarriage|fork_lift|fork_spine|fork_side_arm|fork_zslide|receiver_cross_[ab]|empty_pallet_lift|head_zrod|support_carriage_[ab]|support_arm_[ab].*)$/.test(id)}
function StackSaddle({side,nodes,frame}:Context&{side:string}){
 const saddle=useRef<Group>(null),arms=useRef<Group>(null)
 useFrame(()=>{
  const c=frame.current.poses['support_carriage_'+side]??nodes.find(n=>n.id==='support_carriage_'+side)!,fork=frame.current.poses['support_'+side+'0']??nodes.find(n=>n.id==='support_'+side+'0')!
  if(saddle.current)saddle.current.position.set(c.p[0],c.p[1],.24)
  const top=fork.p[1]-.015,low=c.p[1]
  if(arms.current){arms.current.position.set(c.p[0],(top+low)/2,.33);arms.current.scale.y=Math.max(.001,top-low)}
 })
 return <><group ref={saddle} name={side+'-guided-stack-saddle'}>
  <group rotation={[Math.PI/2,0,0]}><BoredPlate name="stack-bearing-saddle" position={[0,0,0]} size={[.35,.10,.12]} corner={.004} holes={[{x:-.15,y:0,radius:.0185},{x:.15,y:0,radius:.0185},{x:0,y:.03,radius:.0145}]} color={FINISH.steel}/></group>
 </group><group ref={arms}>{[-.09,.09].map(x=><Part key={x} name="stack-support-arm" position={[x,0,0]} size={[.03,1,.08]} color={FINISH.steel}/>)}</group></>
}
function MovingFork({nodes,frame}:Context){
 const shoe=useRef<Group>(null),base=useRef<Group>(null),pistons=useRef<Group>(null),spine=useRef<Group>(null),rail=useRef<Group>(null)
 useFrame(()=>{
  const c=frame.current.poses.fork_xcarriage??nodes.find(n=>n.id==='fork_xcarriage')!,f=frame.current.poses.fork_spine??nodes.find(n=>n.id==='fork_spine')!
  if(shoe.current)shoe.current.position.set(c.p[0],.665,2.09)
  if(base.current)base.current.position.set(f.p[0],.71,f.p[2])
  if(spine.current)spine.current.position.set(...f.p)
  // End the telescopic slide at its lift saddle; no fixed tail enters a station.
  const z0=Math.min(2.09,f.p[2])-.045,z1=Math.max(2.09,f.p[2])+.045
  if(rail.current){rail.current.position.set(f.p[0],.6925,(z0+z1)/2);rail.current.scale.z=z1-z0}
  const low=.756,high=f.p[1]-.0075
  if(pistons.current){pistons.current.position.set(f.p[0],(low+high)/2,f.p[2]);pistons.current.scale.y=Math.max(.001,high-low)}
 })
 return <>
  <group ref={shoe} name="fork-x-bearing-shoe">
   <Part name="fork-x-linear-bearing" size={[.18,.02,.12]} color={FINISH.steel}/>
   <group position={[0,-.0225,.09]} rotation={[0,Math.PI/2,0]}><BoredPlate name="fork-screw-bearing-bracket" position={[0,0,0]} size={[.035,.065,.07]} holes={[{x:0,y:-.0225,radius:.013}]} color={FINISH.steel}/></group>
   {[-.065,.065].map(x=><SocketBolt key={x} top position={[x,.011,0]} radius={.004}/>)}
  </group>
  <group ref={rail}><Part name="fork-telescopic-transfer-guide" size={[.055,.035,1]} color={FINISH.dark}/></group>
  <group ref={spine}><Part name="fork-narrow-crosshead" size={[.13,.015,.06]} color={FINISH.steel}/></group>
  <group ref={base} name="fork-connected-lift-saddle">
   <Part name="fork-transverse-lift-base" position={[0,.008,0]} size={[.13,.016,.09]} color={FINISH.steel}/>
   {[-.032,.032].map(x=><group key={x}>
    <Part name="fork-lift-cartridge" position={[x,.031,0]} size={[.045,.03,.055]} color={FINISH.alloy} radius={.004}/>
    {[-1,1].map(k=><SocketBolt key={k} top position={[x+k*.015,.047,.017]} radius={.003}/>)}
   </group>)}
  </group>
  <group ref={pistons}>{[-.032,.032].map(x=><RoundPart key={x} name="fork-lift-piston" position={[x,0,0]} axis="y" radius={.010} length={1} color={FINISH.steel}/>)}</group>
 </>
}
function PickupAxis({nodes,frame}:Context){
 const body=useRef<Group>(null),rod=useRef<Group>(null),bridge=useRef<Group>(null)
 useFrame(()=>{
  const c=frame.current.poses.head_carriage??nodes.find(n=>n.id==='head_carriage')!,pad=frame.current.poses.head_pad??nodes.find(n=>n.id==='head_pad')!,rail=frame.current.poses.head_xrail??nodes.find(n=>n.id==='head_xrail')!
  if(body.current)body.current.position.set(c.p[0],1.64,c.p[2])
  if(bridge.current)bridge.current.position.z=rail.p[2]
  const top=1.48,bottom=pad.p[1]+.02
  if(rod.current){rod.current.position.set(pad.p[0],(top+bottom)/2,pad.p[2]);rod.current.scale.y=Math.max(.001,top-bottom)}
 })
 return <>
  <group ref={bridge}>{[-.8,.8].map(x=><Part key={x} name="gantry-travel-bearing" position={[x,1.76375,0]} size={[.105,.0025,.13]} color={FINISH.steel}/>)}</group>
  <group ref={body} name="pickup-guided-cylinder">
   <Part name="pickup-cylinder-flange" position={[0,-.008,0]} size={[.12,.016,.12]} color={FINISH.steel}/>
   <Part name="pickup-cylinder-housing" position={[0,-.086,0]} size={[.065,.14,.065]} color={FINISH.alloy} radius={.006}/>
   <RoundPart name="pickup-rod-bearing" position={[0,-.158,0]} axis="y" radius={.021} length={.004} color={FINISH.dark}/>
   {[-1,1].map(k=><SocketBolt key={k} position={[k*.022,-.065,.033]} radius={.004}/>)}
  </group>
  <group ref={rod}><RoundPart name="pickup-telescopic-rod" position={[0,0,0]} axis="y" radius={.013} length={1}/></group>
 </>
}
export function StackTransferMounts(ctx:Context){
 if(!ctx.nodes.some(n=>n.id==='empty_pallet_lift'))return null
 return <group name="h15-connected-transfer-station">
  <MovingFork {...ctx}/><PickupAxis {...ctx}/>
  {['a','b'].map(side=><StackSaddle key={side} side={side} {...ctx}/>)}
  {[-1.32,-1.08].flatMap(x=>[2.40,3.40].map(z=><group key={x+','+z}>
   <Part name="pallet-rail-bearing-seat" position={[x,.76125,z]} size={[.055,.0575,.08]} color={FINISH.steel}/>
   <SocketBolt top position={[x,.821,z]} radius={.003}/>
  </group>))}
  <Part name="fork-left-support-column" position={[-1.40,.3175,2.09]} size={[.06,.535,.06]} color={FINISH.dark}/>
  <Part name="fork-left-column-foot" position={[-1.40,.025,2.09]} size={[.13,.05,.13]} color={FINISH.dark}/>
  <Part name="fork-drive-flange" position={[-1.4475,.62,2.135]} size={[.035,.10,.17]} color={FINISH.steel}/>
  <RoundPart name="fork-screw-coupler" position={[-1.4575,.62,2.18]} axis="x" radius={.019} length={.015}/>
 </group>
}
