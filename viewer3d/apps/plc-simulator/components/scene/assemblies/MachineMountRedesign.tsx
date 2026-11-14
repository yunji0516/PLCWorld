import {useRef,type RefObject,type ReactNode} from 'react'
import {useFrame} from '@react-three/fiber'
import {Group} from 'three'
import type {Node,Frame,V3} from '@/app/replay/hard-processes/ReviewCanvas'
import {Part,RoundPart,FINISH} from './Parts'
import {SocketBolt} from '../IndustrialDetails'
type C={nodes:Node[];frame:RefObject<Frame>}
function Follow({id,nodes,frame,children}:C&{id:string;children:ReactNode}){
 const ref=useRef<Group>(null)
 useFrame(()=>{const p=frame.current.poses[id]??nodes.find(n=>n.id===id);if(p&&ref.current){ref.current.position.fromArray(p.p);ref.current.visible=p.visible??true}})
 return <group ref={ref} name={id+'-integrated-mount'}>{children}</group>
}
function MachiningHead({side,nodes,frame}:C&{side:string}){
 const n=nodes.find(n=>n.id===side+'_probe')!,x=n.p[0],slide=useRef<Group>(null),tool=useRef<Group>(null)
 useFrame(()=>{const p=frame.current.poses[n.id]??n;slide.current?.position.set(x,p.p[1]+.20,-.38);tool.current?.position.set(x,p.p[1]+.20,p.p[2])})
 return <group name={side+'-rigid-ram-machining-head'}>
  <Part name="head-vertical-guide" position={[x,1.1375,-.565]} size={[.045,.34,.025]} color={FINISH.alloy}/>
  <group ref={slide}>
   <Part name="head-z-carriage" position={[0,0,-.16125]} size={[.08,.065,.0225]} color={FINISH.steel}/>
   {[-1,1].map(k=><group key={k}>
    <Part name="head-guide-sleeve-wall" position={[k*.03,.008,0]} size={[.012,.048,.30]} color={FINISH.alloy}/>
    <Part name="head-guide-sleeve-cover" position={[0,.008+k*.03,0]} size={[.072,.012,.30]} color={FINISH.alloy}/>
   </group>)}
  </group>
  <group ref={tool}>
   <Part name="head-rigid-sliding-ram" position={[0,.008,-.1325]} size={[.04,.04,.32]} color={FINISH.steel}/>
   <Part name="head-tool-slide" position={[0,.008,0]} size={[.07,.055,.055]} color={FINISH.steel}/>
   <RoundPart name="head-tool-quill" position={[0,-.093,0]} radius={.012} length={.194} axis="y"/>
  </group>
 </group>
}
function SpliceClamp({id,nodes,frame}:C&{id:string}){
 const n=nodes.find(n=>n.id===id)!,rod=useRef<Group>(null)
 useFrame(()=>{const p=frame.current.poses[id]??n,end=p.p[1]+.0125,top=1.13;if(rod.current){rod.current.position.set(n.p[0],(top+end)/2,0);rod.current.scale.y=top-end}})
 return <group name={id+'-guided-press'}>
  <Part name="splice-cylinder-body" position={[n.p[0],1.195,0]} size={[.042,.13,.055]} color={FINISH.alloy}/>
  <Part name="splice-flange" position={[n.p[0],1.25,0]} size={[.065,.02,.075]} color={FINISH.dark}/>
  <group ref={rod}><RoundPart name="splice-press-rod" position={[0,0,0]} radius={.008} length={1} axis="y"/></group>
 </group>
}
function WebFeedFrame(ctx:C){
 const rolls=ctx.nodes.filter(n=>['feed_roll','feed_pressure','pull_roll','pull_pressure'].includes(n.id))
 return <group name="web-feed-bearing-cassette">
  {[-1,1].map(side=><group key={side}>
   <Part name="nip-cassette-sideplate" position={[.04,.89,side*.105]} size={[.38,.22,.018]} color={FINISH.dark}/>
   {rolls.map(n=><Follow key={n.id} {...ctx} id={n.id}>
    <RoundPart name="nip-bearing-hub" position={[0,0,side*.094]} radius={.023} length={.022} axis="z"/>
    <Part name="nip-bearing-slide" position={[0,0,side*.107]} size={[.05,.06,.022]} color={FINISH.alloy}/>
   </Follow>)}
  </group>)}
  <Part name="nip-frame-crossfoot" position={[0,.77,.12]} size={[.48,.02,.07]} color={FINISH.dark}/>
  {[-.21,.21].map(x=><Part key={x} name="nip-frame-post-seat" position={[x,.77,.12]} size={[.045,.02,.07]} color={FINISH.dark}/>)}
  {['a','b'].map(side=>{const sign=side==='a'?1:-1;return <group key={side} name="receiver-folded-guard">
   {[.38,1.53].map(x=><group key={x}>
    <Part name="receiver-guide-edge" position={[x,.975,sign*.745]} size={[.018,.08,1.08]} color={FINISH.alloy}/>
    {[.30,1.20].map(z=><Part key={z} name="receiver-guard-flange" position={[x,.904,sign*z]} size={[.018,.062,.045]} color={FINISH.dark}/>)}
   </group>)}
   <Part name="receiver-end-fold" position={[.955,.931,sign*1.29]} size={[1.13,.018,.04]} color={FINISH.alloy}/>
  </group>})}
 </group>
}
function CoreEscapement(ctx:C){
 const n=ctx.nodes.find(n=>n.id==='core_stop')!,moving=useRef<Group>(null),rod=useRef<Group>(null)
 useFrame(()=>{const p=ctx.frame.current.poses.core_stop??n,end=p.p[0]+.125
  moving.current?.position.set(p.p[0],.95,.3075)
  if(rod.current){rod.current.position.set((.77+end)/2,.94,.3075);rod.current.scale.x=Math.max(.001,.77-end)}
 })
 return <group name="core-fork-escapement">
  <Part name="escapement-floor-base" position={[.88,.0125,.3075]} size={[.20,.025,.20]} color={FINISH.dark}/>
  <Part name="escapement-floor-column" position={[.88,.45875,.3075]} size={[.065,.8675,.065]} color={FINISH.alloy}/>
  {[-.07,.07].map(x=><SocketBolt key={x} top position={[.88+x,.026,.3075]} radius={.006}/>)}
  <Part name="escapement-machined-bed" position={[.75,.9025,.3075]} size={[.48,.02,.08]} color={FINISH.alloy}/>
  <Part name="escapement-guide" position={[.63,.916,.3075]} size={[.24,.007,.028]} color={FINISH.steel}/>
  <Part name="escapement-cylinder-foot" position={[.88,.91625,.3075]} size={[.18,.0075,.05]} color={FINISH.dark}/>
  <Part name="escapement-cylinder" position={[.88,.94,.3075]} size={[.22,.04,.045]} color={FINISH.alloy}/>
  <group ref={rod}><RoundPart name="escapement-piston" position={[0,0,0]} radius={.006} length={1} axis="x"/></group>
  <group ref={moving}>
   <Part name="escapement-carriage" position={[.10,-.020,0]} size={[.05,.021,.055]} color={FINISH.steel}/>
   <Part name="fork-lower-bridge" position={[.025,-.069,0]} size={[.16,.012,.025]} color={FINISH.alloy}/>
   {[-1,1].map(k=><group key={k}>
    <Part name="fork-clearance-stem" position={[k*.054,-.034,0]} size={[.008,.058,.025]} color={FINISH.alloy}/>
    <Part name="core-rim-stop-finger" position={[k*.045,0,0]} size={[.010,.018,.025]} color={FINISH.steel}/>
   </group>)}
   <Part name="fork-carriage-neck" position={[.10,-.041,0]} size={[.025,.044,.025]} color={FINISH.alloy}/>
  </group>
 </group>
}
function BoxClamp(ctx:C){
 const rod=useRef<Group>(null)
 useFrame(()=>{const p=(ctx.frame.current.poses.box_jaw??ctx.nodes.find(n=>n.id==='box_jaw')!).p,end=p[0]+.02;if(rod.current){rod.current.position.set((2.865+end)/2,.95,.6);rod.current.scale.x=2.865-end}})
 return <group name="box-side-guided-clamp">
  <Part name="box-clamp-cantilever" position={[2.895,.78,.6]} size={[.55,.04,.36]} color={FINISH.alloy}/>
  {[2.73,3.10].flatMap(x=>[.47,.73].map(z=><group key={x+':'+z}>
   <Part name="box-clamp-table-leg" position={[x,.3975,z]} size={[.045,.725,.045]} color={FINISH.alloy}/>
   <RoundPart name="box-clamp-leveling-foot" position={[x,.0175,z]} radius={.04} length={.035} axis="y" color={FINISH.dark}/>
  </group>))}
  {[-.14,.14].map(z=><Part key={z} name="box-clamp-linear-bed" position={[2.945,.86,.6+z]} size={[.45,.12,.035]} color={FINISH.dark}/>)}
  <Part name="box-clamp-cylinder-saddle" position={[3.025,.8875,.6]} size={[.26,.035,.245]} color={FINISH.steel}/>
  <Follow {...ctx} id="box_jaw">{[-.14,.14].map(z=><group key={z}><Part name="box-jaw-guided-slider" position={[.18,-.015,z]} size={[.08,.03,.05]} color={FINISH.steel}/><Part name="box-jaw-carrier-arm" position={[.08,0,z]} size={[.12,.03,.04]} color={FINISH.alloy}/></group>)}</Follow>
  <group ref={rod}><RoundPart name="box-clamp-outward-piston" position={[0,0,0]} radius={.012} length={1} axis="x"/></group>
 </group>
}
function PouchSeparatorClamp(ctx:C){
 const left=useRef<Group>(null),right=useRef<Group>(null)
 useFrame(()=>{const p=ctx.frame.current.poses.separator_hold??ctx.nodes.find(n=>n.id==='separator_hold')!,closed=Math.max(0,Math.min(1,(p.p[1]-.794)/.05)),half=.065+.04*(1-closed)
  left.current?.position.set(-.65-half,.852,.345);right.current?.position.set(-.65+half,.852,.345)
 })
 return <group name="lower-sheet-edge-pinch-clamp">
  {[-1,1].map(k=><group key={k}>
   <Part name="edge-clamp-side-seat" position={[-.65+k*.165,.827,.345]} size={[.09,.02,.07]} color={FINISH.dark}/>
   <Part name="edge-clamp-cylinder" position={[-.65+k*.155,.852,.345]} size={[.07,.03,.05]} color={FINISH.alloy}/>
   <group ref={k<0?left:right}>
    <Part name="lower-sheet-edge-pad" size={[.006,.003,.045]} color={FINISH.seal}/>
    <Part name="edge-clamp-finger" position={[k*.015,0,0]} size={[.024,.003,.045]} color={FINISH.steel}/>
    <RoundPart name="edge-clamp-sliding-rod" position={[k*.065,0,0]} radius={.004} length={.10} axis="x"/>
   </group>
  </group>)}
 </group>
}
export function MachineMountRedesign(ctx:C){
 const {nodes}=ctx,has=(id:string)=>nodes.some(n=>n.id===id)
 return <>
 {has('splice_new_hold')&&<WebFeedFrame {...ctx}/>}
 {has('leader_grip')&&<CoreEscapement {...ctx}/>}
 {has('box_clamp_drive')&&<BoxClamp {...ctx}/>}
 {has('separator_hold')&&<PouchSeparatorClamp {...ctx}/>}
 {has('tool_service_bearing0')&&<group name="cradle-underframe-belt-drive"><Part name="cradle-timing-belt-guard" position={[-.255,.79,0]} size={[.035,.62,.09]} color={FINISH.dark}/><Part name="cradle-motor-foot" position={[-.22,.3975,0]} size={[.20,.025,.18]} color={FINISH.alloy}/><Part name="cradle-drive-seat" position={[-.22,.33,0]} size={[.10,.11,.16]} color={FINISH.dark}/></group>}
 {has('deck_drive')&&<group name="deck-axis-end-drive">
  <Part name="deck-end-bearing-bridge" position={[-1.4,.665,0]} size={[.08,.066,.20]} color={FINISH.steel}/>
  <Part name="deck-motor-cradle" position={[-1.49,.665,0]} size={[.18,.03,.14]} color={FINISH.alloy}/>
  <Part name="deck-drive-flange" position={[-1.405,.72,0]} size={[.01,.09,.12]} color={FINISH.dark}/>
 </group>}
 {has('deck_belt_motor')&&<Follow {...ctx} id="deck_belt_motor">
  <Part name="moving-belt-motor-seat" position={[-.04,-.045,0]} size={[.15,.014,.10]} color={FINISH.alloy}/>
  <Part name="moving-belt-side-flange" position={[-.05,-.004,0]} size={[.014,.068,.09]} color={FINISH.dark}/>
 </Follow>}
 {has('cart_motor')&&<group name="pouch-cart-drive-endcap">
  <Part name="cart-end-bearing-bridge" position={[-.9,.66,0]} size={[.075,.08,.215]} color={FINISH.steel}/>
  <Part name="cart-motor-seat" position={[-.97,.6465,0]} size={[.15,.017,.12]} color={FINISH.alloy}/>
  <Part name="cart-motor-flange" position={[-.906,.70,0]} size={[.012,.09,.12]} color={FINISH.dark}/>
 </group>}
 {has('splice_new_hold')&&<><SpliceClamp {...ctx} id="splice_new_hold"/><SpliceClamp {...ctx} id="splice_old_hold"/></>}
 {has('tool_service_bearing0')&&<><MachiningHead {...ctx} side="a"/><MachiningHead {...ctx} side="b"/></>}
 {has('exit_a_transverse_pusher')&&(['a','b'] as const).map(side=>{
  const n=nodes.find(n=>n.id===`exit_${side}_transverse_pusher_drive`)!,x=n.p[0],z=n.p[2],seat=n.p[1]-n.size[0]-.003
  return <group key={side} name={side+'-pusher-integrated-drive-bed'}>
   <Part name="pusher-cylinder-seat" position={[x,seat,z]} size={[.26,.006,.18]} color={FINISH.alloy}/>
   {[-.09,.09].map(dx=><SocketBolt key={dx} top position={[x+dx,seat+.004,z+.07]} radius={.004}/>)}
  </group>
 })}
 {has('cross_1.25_surface')&&[-1.25,1.25,3.15].filter(x=>has('cross_'+x+'_surface')).map(x=><group key={x} name={'cross-'+x+'-rail-bed'}>
  {[-.24,.24].map(dx=><group key={dx}>
   <Part name="traverse-guide-bed" position={[x+dx,.9425,0]} size={[.07,.025,2.16]} color={FINISH.alloy}/>
   {[-1,1].map(z=><Part key={z} name="traverse-bed-end-cheek" position={[x+dx,.87625,z]} size={[.07,.1075,.12]} color={FINISH.dark}/>) }
  </group>)}
  <Part name="traverse-drive-mount" position={[x,.83875,1.13]} size={[.16,.0325,.16]} color={FINISH.alloy}/>
  {[-1.05,1.00].map(z=><Part key={z} name="traverse-screw-bearing-seat" position={[x,.86,z]} size={[.12,.075,.09]} color={FINISH.steel}/>)}
 </group>)}
 </>
}
