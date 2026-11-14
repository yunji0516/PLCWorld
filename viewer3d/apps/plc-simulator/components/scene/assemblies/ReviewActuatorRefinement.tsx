import {useRef,type RefObject,type ReactNode} from 'react'
import {useFrame} from '@react-three/fiber'
import {Group} from 'three'
import type {Node,Frame,V3} from '@/app/replay/hard-processes/ReviewCanvas'
import {Part,RoundPart,FINISH} from './Parts'
import {SocketBolt} from '../IndustrialDetails'

type Context={nodes:Node[];frame:RefObject<Frame>}
function Follow({id,nodes,frame,children,offset=[0,0,0]}:Context&{id:string;children:ReactNode;offset?:V3}){
 const ref=useRef<Group>(null)
 useFrame(()=>{const p=frame.current.poses[id]??nodes.find(n=>n.id===id);if(ref.current&&p){ref.current.position.set(p.p[0]+offset[0],p.p[1]+offset[1],p.p[2]+offset[2]);ref.current.visible=p.visible??true}})
 return <group ref={ref} name={id+'-machined-attachment'}>{children}</group>
}
export function replacedActuatorHardware(nodes:Node[],id:string){
 if(nodes.some(n=>n.id==='leader_grip')&&id==='core_stop')return true
 if(nodes.some(n=>n.id==='separator_hold')&&id==='separator_hold')return true
 if(nodes.some(n=>n.id==='tool_service_bearing0')&&/^[ab]_probe_(body|slide)$/.test(id))return true
 if(nodes.some(n=>n.id==='exit_a_transverse_pusher')&&/^exit_[ab]_transverse_pusher_mount$/.test(id))return true
 if(nodes.some(n=>n.id==='separator_hold')&&/^(pusher_body|align_front_drive|align_side_drive)$/.test(id))return true
 if(nodes.some(n=>n.id==='tape_actuator')&&/^(tape_actuator|tape_rod|cutter_body|cutter_rod|cutter_stay)$/.test(id))return true
 if(nodes.some(n=>n.id==='kit_hopper1')&&(/^(kit_arm|kit_post)[12]$/.test(id)||/^cross_.*_jaw_(mount|rod)/.test(id)))return true
 return false
}
function PouchPusher({nodes,frame}:Context){
 const toe=useRef<Group>(null),rod=useRef<Group>(null),sideRod=useRef<Group>(null)
 useFrame(()=>{const q=(frame.current.poses.align_front??nodes.find(n=>n.id==='align_front')!).p
  const side=(frame.current.poses.align_side??nodes.find(n=>n.id==='align_side')!).p,endX=side[0]+.007
  if(sideRod.current){sideRod.current.position.set((.215+endX)/2,.884,side[2]);sideRod.current.scale.x=Math.max(.001,.215-endX)}
  if(toe.current)toe.current.position.set(.07,q[1],q[2])
  const end=q[2]-.0075,start=-.73
  if(rod.current){rod.current.position.set(.10,.884,(start+end)/2);rod.current.scale.z=Math.max(.001,end-start)}
 })
 return <group name="pouch-separated-pneumatic-axes">
  <Part name="side-alignment-mounting-shelf" position={[.225,.7935,-.55]} size={[.30,.03,.11]} color={FINISH.steel}/>
  {[.235,.325].map(x=><group key={x}>
   <Part name="side-cylinder-mount-foot" position={[x,.83325,-.55]} size={[.035,.0495,.065]} color={FINISH.dark}/>
   <SocketBolt top position={[x,.81,-.589]} radius={.004}/>
  </group>)}
  <Part name="side-alignment-cylinder-barrel" position={[.28,.884,-.55]} size={[.11,.044,.052]} color={FINISH.alloy} radius={.005}/>
  {[.22,.34].map(x=><group key={x}>
   <Part name="side-alignment-cylinder-endcap" position={[x,.884,-.55]} size={[.01,.052,.06]} color={FINISH.dark} radius={.003}/>
   {[-1,1].map(k=><group key={k} position={[x-.006,.90,-.55+k*.02]} rotation={[0,-Math.PI/2,0]}><SocketBolt position={[0,0,0]} radius={.003}/></group>)}
  </group>)}
  <group ref={sideRod}><RoundPart name="side-alignment-piston" position={[0,0,0]} radius={.007} length={1} axis="x"/></group>
  <Part name="pusher-extruded-cylinder" position={[0,.87,-.98]} size={[.075,.064,.208]} color={FINISH.alloy} radius={.006}/>
  {[-1,1].map(k=><group key={k}>
   <Part name="pusher-endcap" position={[0,.87,-.98+k*.112]} size={[.09,.08,.016]} color={FINISH.dark} radius={.004}/>
   {[-1,1].map(x=><SocketBolt key={x} position={[x*.028,.889,-.98+k*.121]} radius={.004}/>)}
  </group>)}
  <Part name="alignment-cylinder-bed" position={[.10,.819,-.79]} size={[.065,.081,.16]} color={FINISH.steel}/>
  <Part name="alignment-cylinder-body" position={[.10,.884,-.79]} size={[.042,.042,.10]} color={FINISH.alloy} radius={.004}/>
  {[-1,1].map(k=><Part key={k} name="alignment-cylinder-endcap" position={[.10,.884,-.79+k*.055]} size={[.048,.048,.01]} color={FINISH.dark}/>)}
  <group ref={rod}><RoundPart name="alignment-piston" position={[0,0,0]} radius={.007} length={1} axis="z"/></group>
  <group ref={toe}><Part name="alignment-offset-toe" size={[.06,.025,.015]} color={FINISH.steel}/></group>
 </group>
}
function MagazineGripper(ctx:Context){
 return <group name="magazine-guided-parallel-gripper">
  <Part name="gripper-fixed-housing" position={[0,1.65,-.2675]} size={[.50,.10,.11]} color={FINISH.alloy} radius={.008}/>
  <Part name="gripper-guide-slot" position={[0,1.655,-.2115]} size={[.44,.028,.002]} color={FINISH.dark}/>
  {[-1,1].map(sign=><Follow key={sign} {...ctx} id={'upper_grip'+sign}>
   <Part name="gripper-bearing-slider" position={[0,.17,-.17]} size={[.075,.07,.085]} color={FINISH.steel}/>
   <Part name="gripper-jaw-arm" position={[0,.16,-.0575]} size={[.045,.07,.145]} color={FINISH.alloy}/>
   {[-.1025,.1025].map(y=><Part key={y} name="gripper-contact-pad" position={[-sign*.017,y,.025]} size={[.004,.045,.18]} color={FINISH.seal}/>)}
   {[-.07,.07].map(z=><SocketBolt key={z} position={[sign*.016,.1025,z]} radius={.004}/>)}
  </Follow>)}
 </group>
}
function FilmStation({nodes,frame}:Context){
 const cutter=useRef<Group>(null),cutterSlide=useRef<Group>(null),stop=useRef<Group>(null),slide=useRef<Group>(null)
 useFrame(()=>{
  const b=(frame.current.poses.cutter_blade??nodes.find(n=>n.id==='cutter_blade')!).p,q=(frame.current.poses.formation_stop??nodes.find(n=>n.id==='formation_stop')!).p,t=(frame.current.poses.tape_head??nodes.find(n=>n.id==='tape_head')!).p
  if(cutterSlide.current)cutterSlide.current.position.set(b[0],1.30,-.36)
  if(cutter.current){cutter.current.position.set(b[0],1.265,(-.33+b[2])/2);cutter.current.scale.z=Math.max(.01,b[2]+.33)}
  if(stop.current){stop.current.position.set((.86+q[0]-.012)/2,1.025,2.5);stop.current.scale.x=Math.max(.001,q[0]-.012-.86)}
  if(slide.current)slide.current.position.set(t[0],1.335,t[2])
 })
 return <group name="film-cutter-and-tape-guided-station">
  <Part name="tape-rail-root" position={[1.15,1.39,-.1095]} size={[.09,.06,.139]} color={FINISH.dark}/>
  <Part name="tape-linear-guide" position={[.61,1.39,0]} size={[1.40,.06,.08]} color={FINISH.alloy}/>
  <Part name="tape-guide-channel" position={[.61,1.359,0]} size={[1.34,.002,.022]} color={FINISH.dark}/>
  <group ref={slide}>
   <Part name="tape-bearing-carriage" size={[.13,.048,.10]} color={FINISH.steel}/>
   <Part name="tape-tool-neck" position={[0,-.04,0]} size={[.06,.032,.06]} color={FINISH.alloy}/>
   <SocketBolt position={[0,0,.051]} radius={.005}/>
  </group>
  <Part name="tape-reel-stay-seat" position={[1.15,.78,-.357]} size={[.06,.04,.286]} color={FINISH.dark}/>
  <Part name="cutter-support-column" position={[.65,.635,-.36]} size={[.06,1.27,.07]} color={FINISH.dark}/>
  <Part name="cutter-guide-base" position={[.20,1.30,-.36]} size={[.96,.06,.06]} color={FINISH.alloy}/>
  <group ref={cutterSlide}>
   <Part name="cutter-guide-carriage" position={[0,0,0]} size={[.10,.045,.04]} color={FINISH.steel}/>
  </group>
  <group ref={cutter}><Part name="cutter-moving-tool-arm" size={[.08,.026,1]} color={FINISH.steel}/></group>
  <Part name="formation-stop-bed" position={[.835,.9325,2.5]} size={[.19,.035,.15]} color={FINISH.steel}/>
  <Part name="formation-stop-drive" position={[.80,1.025,2.5]} size={[.12,.06,.08]} color={FINISH.alloy} radius={.005}/>
  <Part name="formation-stop-drive-foot" position={[.80,.9725,2.5]} size={[.09,.045,.08]} color={FINISH.dark}/>
  <group ref={stop}><RoundPart name="formation-stop-piston" position={[0,0,0]} radius={.009} length={1} axis="x"/></group>
 </group>
}
function TransferJawMount({id,nodes,frame}:Context&{id:string}){
 const bracket=useRef<Group>(null),rod=useRef<Group>(null),sign=id.endsWith('-1')?-1:1,prefix=id.replace(/_jaw_drive-?1$/,'')
 useFrame(()=>{
  const d=(frame.current.poses[id]??nodes.find(n=>n.id===id)!).p,r=(frame.current.poses[prefix+'_deckrail'+sign]??nodes.find(n=>n.id===prefix+'_deckrail'+sign)!).p,j=(frame.current.poses[prefix+'_jaw'+sign]??nodes.find(n=>n.id===prefix+'_jaw'+sign)!).p
  const low=r[1]+.0325,high=d[1]-.023
  if(bracket.current){bracket.current.position.set(d[0],(low+high)/2,(r[2]+d[2])/2);bracket.current.scale.set(1,Math.max(.001,high-low),Math.abs(r[2]-d[2])+.05)}
  const a=d[2]-sign*.05,b=j[2]+sign*.012
  if(rod.current){rod.current.position.set(d[0],d[1],(a+b)/2);rod.current.scale.z=Math.max(.001,Math.abs(a-b))}
 })
 return <><group ref={bracket} name={id+'-deck-mounted-bracket'}><Part size={[.08,1,1]} color={FINISH.steel}/></group><group ref={rod}><RoundPart name="transfer-jaw-piston" position={[0,0,0]} radius={.007} length={1} axis="z"/></group></>
}
export function ReviewActuatorRefinement(ctx:Context){
 const {nodes}=ctx,has=(id:string)=>nodes.some(n=>n.id===id)
 return <>
  {has('separator_hold')&&<PouchPusher {...ctx}/>}
  {has('upper_grip1')&&<MagazineGripper {...ctx}/>}
  {has('tape_actuator')&&<FilmStation {...ctx}/>}
  {has('exit_linear_rail')&&<group name="exit-linear-axis-sideframe">
   <Part name="exit-rail-continuous-bed" position={[.66,.8675,-.92]} size={[.16,.03,.76]} color={FINISH.steel}/>
   {[-.65,-1.19].map(z=><group key={z}>
    <Part name="exit-axis-anchor-foot" position={[.65,.625,z]} size={[.16,.025,.09]} color={FINISH.steel}/>
    <Part name="exit-axis-support-column" position={[.68,.745,z]} size={[.05,.215,.055]} color={FINISH.dark}/>
    {[-1,1].map(k=><SocketBolt key={k} top position={[.60,.639,z+k*.027]} radius={.004}/>)}
   </group>)}
   <Part name="exit-linear-motor-seat" position={[.68,.86225,-.52]} size={[.07,.0125,.12]} color={FINISH.steel}/>
  </group>}
  {has('leader_grip')&&<group name="core-feed-supported-rail-end">
   <Follow {...ctx} id="core_stop">{[-.025,.025].map(x=><SocketBolt key={x} position={[x,0,.0135]} radius={.003}/>)}</Follow>
   <Part name="core-feed-rear-crossmember" position={[.45,.805,1.45]} size={[.58,.045,.07]} color={FINISH.dark}/>
   {[.405,.495].map(x=><group key={x}>
    <Part name="core-rail-end-support" position={[x,(.8275+.910206)/2,1.45]} size={[.024,.910206-.8275,.055]} color={FINISH.steel}/>
    <SocketBolt top position={[x,.929,1.45]} radius={.003}/>
   </group>)}
  </group>}
  {has('kit_hopper1')&&<group name="hopper-aligned-side-mounts">
   {[1,2].map(i=>{const h=nodes.find(n=>n.id==='kit_hopper'+i)!,z=h.p[2];return <group key={i}>
    <Part name="hopper-support-column" position={[.34,1.025,z]} size={[.05,2.05,.05]} color={FINISH.dark}/>
    <Part name="hopper-side-flange" position={[.178,1.99,z]} size={[.016,.17,.22]} color={FINISH.steel}/>
    <Part name="hopper-top-arm" position={[.2755,2.0675,z]} size={[.179,.035,.08]} color={FINISH.dark}/>
    {[-1,1].map(k=><group key={k} position={[.188,2.02,z+k*.075]} rotation={[0,Math.PI/2,0]}><SocketBolt position={[0,0,0]} radius={.005}/></group>)}
   </group>})}
   {nodes.filter(n=>/^cross_.*_jaw_drive-?1$/.test(n.id)).map(n=><TransferJawMount key={n.id} id={n.id} {...ctx}/>)}
  </group>}
 </>
}
