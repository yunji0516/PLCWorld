import {useRef,type RefObject} from 'react'
import {useFrame} from '@react-three/fiber'
import {Group} from 'three'
import type {Node,Frame} from '@/app/replay/hard-processes/ReviewCanvas'
import {Part,RoundPart,BoredPlate,FINISH} from './Parts'

export function replacedInspectionFrame(nodes:Node[],id:string){
 return nodes.some(n=>n.id==='inspection_body')&&/^(inspection_(post|arm|body)|(?:left|right)_(drive|bridge|carriage|screw|saddle)|(?:input|output)_(post.*|arm.*|rail|carriage))$/.test(id)
}

/** Separate column and cantilever terminate at mating faces. */
function StraightFrame({height,reach,depth}:{height:number;reach:number;depth:number}){
 return <group>
  <Part name="station-column" position={[0,(height-.08)/2,0]} size={[.07,height-.08,depth]} color={FINISH.dark} radius={.003}/>
  <Part name="station-cantilever" position={[(reach-.035)/2,height-.04,0]} size={[reach+.035,.08,depth]} color={FINISH.dark} radius={.003}/>
  <Part name="column-recess" position={[0,(height-.16)/2,depth/2+.001]} size={[.012,height-.20,.002]} color={FINISH.seal}/>
 </group>
}
function TransferAxis({side,nodes,frame}:{side:string;nodes:Node[];frame:RefObject<Frame>}){
 const rail=nodes.find(n=>n.id===side+'_rail')!,carriage=nodes.find(n=>n.id===side+'_carriage')!,ref=useRef<Group>(null)
 const [x,,z]=rail.p,length=rail.size[2]
 useFrame(()=>{const p=frame.current.poses[carriage.id]??carriage;if(ref.current){ref.current.position.set(p.p[0],p.p[1],p.p[2]);ref.current.visible=p.visible??true}})
 return <group name={side+'-linear-axis'}>
  <Part name="axis-extrusion" position={[x,1.74,z]} size={[.085,.08,length]} color={FINISH.alloy} radius={.004}/>
  {[-1,1].map(sign=><group key={sign}>
   <Part name="extrusion-side-channel" position={[x+sign*.0435,1.742,z]} size={[.002,.012,length-.03]} color={FINISH.dark}/>
   <Part name="axis-end-cap" position={[x,1.74,z+sign*(length/2+.008)]} size={[.091,.085,.016]} color={FINISH.dark} radius={.003}/>
  </group>)}
  <Part name="linear-guide-track" position={[x,1.695,z]} size={[.03,.01,length-.02]} color={FINISH.steel} radius={.001}/>
  <group ref={ref} name={side+'-bearing-carriage'} position={carriage.p}>
   <Part name="carriage-lower-plate" position={[0,-.0175,0]} size={[.12,.025,.13]} color={FINISH.dark} radius={.004}/>
   <Part name="linear-bearing-block" position={[0,.0125,0]} size={[.068,.035,.095]} color={FINISH.alloy} radius={.003}/>
   {[-1,1].map(sign=><Part key={sign} name="guide-bearing-lip" position={[sign*.024,.035,0]} size={[.018,.01,.095]} color={FINISH.steel} radius={.001}/>)}
   {[-1,1].map(sign=><Part key={sign} name="bearing-end-wiper" position={[0,.0125,sign*.05]} size={[.068,.035,.005]} color={FINISH.seal}/>)}
   <RoundPart name="vertical-axis-rod-socket" position={[0,-.027,0]} axis="y" radius={.019} length={.006} color={FINISH.steel}/>
  </group>
 </group>
}
function LiftBearingCarriage({side,nodes,frame}:{side:string;nodes:Node[];frame:RefObject<Frame>}){
 const ref=useRef<Group>(null),saddle=useRef<Group>(null),node=nodes.find(n=>n.id===side+'_carriage')!
 useFrame(()=>{
  const p=frame.current.poses[node.id]??node
  if(ref.current){ref.current.position.set(p.p[0],p.p[1],p.p[2]+.02);ref.current.visible=p.visible??true}
  const deck=frame.current.poses[side+'_deck']??nodes.find(n=>n.id===side+'_deck')!,seat=frame.current.poses[side+'_saddle']??nodes.find(n=>n.id===side+'_saddle')!
  if(saddle.current){saddle.current.position.set(seat.p[0],deck.p[1]-.045,seat.p[2]);saddle.current.visible=deck.visible??true}
 })
 return <><group ref={ref} name={side+'-bored-lift-carriage'}>
  <group rotation={[Math.PI/2,0,0]}><BoredPlate name="lift-carriage-body" size={[.64,.09,.10]} position={[0,0,0]} corner={.006} holes={[{x:-.28,y:-.01,radius:.0245},{x:.28,y:-.01,radius:.0245},{x:0,y:.01,radius:.0175}]} color={FINISH.blue}/></group>
 </group><group ref={saddle} name={side+'-deck-support-saddle'}><Part name="lift-deck-underseat" size={[.38,.06,.25]} color={FINISH.steel}/></group></>
}
/** Servo, flange and bearing housing share the existing screw axis. */
function LiftServo({x}:{x:number}){
 return <group name="lift-servo-assembly" position={[x,0,.28]}>
  <group position={[0,1.17,-.02]} rotation={[Math.PI/2,0,0]}>
   <BoredPlate name="lift-top-bearing-crossbeam" size={[.64,.11,.05]} position={[0,0,0]} corner={.006} holes={[{x:-.28,y:0,radius:.0245},{x:.28,y:0,radius:.0245},{x:0,y:.02,radius:.0175}]} color={FINISH.alloy}/>
  </group>
  <RoundPart name="lift-drive-screw" position={[0,.68,0]} axis="y" radius={.016} length={1} color={FINISH.steel}/>
  <Part name="screw-bearing-housing" position={[0,1.2125,0]} size={[.075,.035,.075]} color={FINISH.alloy} radius={.005}/>
  <RoundPart name="drive-coupling" position={[0,1.245,0]} radius={.021} length={.03} axis="y" color={FINISH.steel}/>
  {[-1,1].map(sign=><Part key={sign} name="motor-mount-cheek" position={[sign*.034,1.245,0]} size={[.012,.03,.075]} color={FINISH.dark} radius={.002}/>)}
  <Part name="servo-mount-flange" position={[0,1.266,0]} size={[.09,.012,.09]} color={FINISH.alloy} radius={.003}/>
  <Part name="servo-motor-housing" position={[0,1.322,0]} size={[.067,.10,.067]} color={FINISH.dark} radius={.008}/>
  <Part name="servo-encoder-cap" position={[0,1.382,0]} size={[.06,.02,.06]} color={FINISH.steel} radius={.006}/>
  <Part name="servo-cable-socket" position={[.043,1.346,0]} size={[.019,.025,.025]} color={FINISH.seal} radius={.003}/>
  {[-1,1].flatMap(xSign=>[-1,1].map(zSign=><RoundPart key={xSign+','+zSign} name="servo-flange-bolt" position={[xSign*.035,1.275,zSign*.035]} axis="y" radius={.004} length={.006} segments={6} color={FINISH.dark}/>))}
 </group>
}
export function InspectionStationFrame({nodes,frame}:{nodes:Node[];frame:RefObject<Frame>}){
 if(!nodes.some(n=>n.id==='inspection_body'))return null
 return <group name="inspection-station-redesigned-frames">
  <group position={[-.4,0,-.26]} rotation={[0,-Math.PI/2,0]}>
   <StraightFrame height={1.502} reach={.26} depth={.095}/>
   <Part name="cast-frame-base" position={[0,.035,0]} size={[.22,.07,.19]} color={FINISH.dark} radius={.018}/>
  </group>
  {/* Compact guided actuator cartridge, replacing the bare blue cylinder. */}
  <Part name="inspection-actuator-cartridge" position={[-.4,1.31,0]} size={[.09,.22,.075]} color={FINISH.alloy} radius={.012}/>
  <Part name="inspection-actuator-rear-cover" position={[-.4,1.31,-.044]} size={[.09,.19,.018]} color={FINISH.dark} radius={.005}/>
  {[1.21,1.41].map(y=><Part key={y} name="inspection-actuator-endcap" position={[-.4,y,0]} size={[.098,.024,.082]} color={FINISH.dark} radius={.006}/>)}
  {[-1,1].map(side=><RoundPart key={side} name="inspection-guide-rod" position={[-.4+side*.032,1.31,.041]} radius={.005} length={.17} axis="y"/>)}
  {nodes.filter(n=>/^(input|output)_post/.test(n.id)).map(n=><group key={n.id} position={[n.id.startsWith('input')?-.75:.75,0,Math.abs(n.p[2])===.3?Math.sign(n.p[2])*.36:n.p[2]]} rotation={[0,Math.PI,0]}>
   <StraightFrame height={1.86} reach={n.id.startsWith('input')?.45:.15} depth={.09}/>
   <Part name="transfer-frame-base" position={[0,.035,0]} size={[.20,.07,.16]} color={FINISH.dark} radius={.015}/>
  </group>)}
  {['left','right'].map(side=><LiftBearingCarriage key={side} side={side} nodes={nodes} frame={frame}/>)}
  {[-1.2,1.2].map(x=><LiftServo key={x} x={x}/>)}
  {['input','output'].map(side=><TransferAxis key={side} side={side} nodes={nodes} frame={frame}/>)}
 </group>
}
