import {useEffect,useMemo,useRef,type RefObject} from 'react'
import {useFrame} from '@react-three/fiber'
import {CatmullRomCurve3,Group,Mesh,TubeGeometry,Vector3} from 'three'
import type {Node,Frame} from '@/app/replay/hard-processes/ReviewCanvas'
import {InspectionStationFrame} from './InspectionStationFrame'
import {Part,RoundPart,FINISH} from './Parts'
import {connectedMounts} from '@/app/replay/hard-processes/connectedMounts'

/** Keep fasteners at physical size while only the central member changes length. */
function EngineeredMount({mount}:{mount:ReturnType<typeof connectedMounts>[number]}){
 const w=mount.width, round=mount.round, plate=Math.min(.012,w*.18)
 return <group name={mount.id}>
  <mesh name="mount-member" castShadow receiveShadow>
   {round?<cylinderGeometry args={[w/2,w/2,1,24]}/>:<boxGeometry args={[w,1,w]}/>}
   <meshStandardMaterial color={round?'#7f8f9c':'#35434e'} roughness={.66} metalness={.45}/>
  </mesh>
  {[-1,1].map(sign=><group key={sign} name="mount-end-fitting">
   {round?<>
    <RoundPart position={[0,0,0]} axis="y" radius={w*.63} length={plate*2} color={FINISH.alloy}/>
    <RoundPart position={[0,sign*plate,0]} axis="y" radius={w*.52} length={plate*.4} color={FINISH.seal}/>
   </>:<>
    <Part size={[w*1.32,plate,w*1.32]} color={FINISH.steel} radius={.002}/>
    {[-1,1].map(x=><RoundPart key={x} position={[x*w*.43,0,w*.67]} axis="z" radius={w*.075} length={.003} segments={6} color={FINISH.seal}/>)}
   </>}
  </group>)}
  {!round&&<mesh name="mount-profile-channel" position={[0,0,w/2+.0008]}>
   <boxGeometry args={[w*.18,1,.0015]}/><meshStandardMaterial color="#202b32" roughness={.85}/>
  </mesh>}
 </group>
}

export function ReviewConnectedMounts({nodes,frame}:{nodes:Node[];frame:RefObject<Frame>}){
 const ref=useRef<Group>(null)
 const mounts=useMemo(()=>connectedMounts(nodes,frame.current),[nodes,frame])
 useFrame(()=>{
  if(!ref.current)return
  for(const [i,m] of connectedMounts(nodes,frame.current).entries()){
   const group=ref.current.children[i];if(!group)continue
   const a=new Vector3(...m.a),b=new Vector3(...m.b),d=b.clone().sub(a),length=d.length()
   group.visible=length>.0001
   group.position.copy(a).add(b).multiplyScalar(.5)
   if(length>.0001)group.quaternion.setFromUnitVectors(new Vector3(0,1,0),d.multiplyScalar(1/length))
   group.children[0].scale.y=Math.max(.0001,length)
   const inset=Math.min(m.width*.09,length*.2)
   group.children[1].position.y=-length/2+inset
   group.children[2].position.y=length/2-inset
   if(group.children[3])group.children[3].scale.y=Math.max(.0001,length-2*inset)
  }
 })
 return <><group ref={ref} name="connected-actuator-mounts">{mounts.map(m=><EngineeredMount key={m.id} mount={m}/>)}</group><InspectionStationFrame nodes={nodes} frame={frame}/></>
}
export function FluidHose({node,frame}:{node:Node;frame:RefObject<Frame>}){
 const ref=useRef<Mesh>(null),last=useRef<unknown>(null)
 useEffect(()=>()=>{ref.current?.geometry.dispose()},[])
 useFrame(()=>{
  const pose=frame.current.poses[node.id],points=pose?.points??node.points
  if(!ref.current||!points||last.current===points)return
  last.current=points
  // Bring H09's flexible hose down beside the slide, then into the nozzle's
  // left port. The old diagonal crossed the slide and its supporting arm.
  const routed=/^flex_hose_[ab]$/.test(node.id)?(()=>{
   const end=points[points.length-1],start=points[0],x=end[0]-.18
   return [start,[start[0],1.78,.65],[x,1.78,.60],[x,end[1],-.10],[end[0]-.019,end[1],0]] as [number,number,number][]
  })():points
  const path=routed.map(p=>new Vector3(...p))
  const geometry=new TubeGeometry(new CatmullRomCurve3(path,false,'centripetal'),40,node.size[1]/2,8,false)
  ref.current.geometry.dispose();ref.current.geometry=geometry
  ref.current.visible=pose?.visible??node.visible??true
 })
 return <mesh ref={ref} name={'fluid-hose-'+node.id} castShadow><bufferGeometry/><meshStandardMaterial color="#303b45" roughness={.83} metalness={.08}/></mesh>
}
