import {useRef,type RefObject} from 'react'
import {useFrame} from '@react-three/fiber'
import {Group} from 'three'
import type {Frame,Node} from '@/app/replay/hard-processes/ReviewCanvas'
import {Part,RoundPart} from './Parts'

function ClampActuator({id,x,z,outer,bottom,top,frame,nodes,blade=false,foot=true,toolX=x}:{id:string;x:number;z:number;outer:number;bottom:number;top:number;frame:RefObject<Frame>;nodes:Node[];blade?:boolean;foot?:boolean;toolX?:number}){
 const rod=useRef<Group>(null),toe=useRef<Group>(null)
 const fixed=nodes.find(n=>n.id===id)!
 useFrame(()=>{
  const pose=frame.current.poses[id]??fixed,y=pose.p[1]+(blade?.0175:.01),start=top-.124
  if(rod.current){rod.current.position.set(x,(start+y)/2,outer);rod.current.scale.y=Math.max(.001,start-y)}
  if(toe.current)toe.current.position.set((x+toolX)/2,y,(outer+z)/2)
 })
 return <group name={id+'-guided-clamp'}>
  {foot&&<><Part name="clamp-mount-foot" position={[x,bottom+.006,outer]} size={[.09,.012,.085]} color="#7f8f9c"/>
  {[-1,1].map(k=><RoundPart key={k} position={[x+k*.031,bottom+.014,outer]} radius={.006} length={.005} axis="y" color="#35434e"/>)}</>}
  <Part name="clamp-fixed-guide" position={[x+(blade?.05:-.05),(bottom+top)/2,outer]} size={[.025,top-bottom,.04]} color="#35434e"/>
  <Part name="clamp-cylinder-seat" position={[x+(blade?.014:-.014),top-.012,outer]} size={[.10,.024,.065]} color="#7f8f9c"/>
  <RoundPart name="clamp-cylinder-barrel" position={[x,top-.074,outer]} radius={.022} length={.10} axis="y" color="#50768e"/>
  <group ref={rod}><RoundPart name="clamp-piston-rod" position={[0,0,0]} radius={.008} length={1} axis="y"/></group>
  <group ref={toe}><Part name="clamp-moving-toe" size={[Math.abs(toolX-x)+.045,.02,Math.abs(outer-z)+.025]} color="#7f8f9c"/></group>
 </group>
}
export function ReviewClampMounts({nodes,frame}:{nodes:Node[];frame:RefObject<Frame>}){
 if(!nodes.some(n=>n.id==='edge_knife_left'))return null
 return <group name="h08-machined-clamp-mounts">
  {[-1,1].map((sign,i)=><ClampActuator key={'bed'+i} id={'clamp'+i} x={-.5} z={sign*.08} outer={sign*.16} bottom={.56} top={1.10} nodes={nodes} frame={frame}/>)}
  {(['left','right'] as const).map((side,i)=>{
   const sign=i?1:-1,z=sign*.08,outer=sign*.18
   return <group key={side}>
    <Part name="edge-cutter-bed" position={[.285,.536,outer]} size={[.16,.027,.10]} color="#35434e"/>
    <Part name="edge-anvil-pedestal" position={[.26,(.55+.816)/2,z]} size={[.035,.816-.55,.04]} color="#35434e"/>
    <Part name="edge-anvil-seat" position={[.26,.55,(outer+z)/2]} size={[.07,.025,Math.abs(outer-z)+.04]} color="#7f8f9c"/>
    <ClampActuator id={'edge_hold_'+side} x={.255} z={z} outer={outer} bottom={.55} top={1.08} foot={false} nodes={nodes} frame={frame}/>
    <ClampActuator id={'edge_knife_'+side} x={.20} toolX={.31} z={z} outer={outer} bottom={.55} top={1.12} foot={false} nodes={nodes} frame={frame} blade/>
   </group>
  })}
 </group>
}
