'use client'
import {useEffect,useMemo,useRef} from 'react'
import {useFrame} from '@react-three/fiber'
import {InstancedMesh,Object3D} from 'three'
import type {DeviceProps} from '../devices'
import {Part,RoundPart,FINISH} from './Parts'
import {noseBeltGeometry,noseBeltPose,noseBeltDimensions} from './noseBeltGeometry'

/** Opt-in small-nose transfer conveyor. Drive fits inside the frame envelope. */
export function CompactTransferBelt({device,plant}:DeviceProps){
 const [l,,w]=device.size,r=.015,rotary=device.mountedOn==='ROTARY_BASE'
 const geometry=useMemo(()=>noseBeltGeometry(l,w,r,r),[l,w]),dummy=useMemo(()=>new Object3D(),[]),marks=useRef<InstancedMesh>(null)
 useEffect(()=>()=>geometry.dispose(),[geometry])
 const count=Math.ceil(noseBeltDimensions(l,r,r).perimeter/.18)
 useFrame(()=>{if(!marks.current)return;const distance=plant.state(device.id).spin/(2*Math.PI)*l
  for(let i=0;i<count;i++){const p=noseBeltPose(l,r,r,distance+i*.18);dummy.position.set(p.x,p.y,0);dummy.rotation.z=p.angle;dummy.updateMatrix();marks.current.setMatrixAt(i,dummy.matrix)}marks.current.instanceMatrix.needsUpdate=true})
 return <group name="compact-transfer-conveyor">
  <mesh name="compact-continuous-belt" geometry={geometry} castShadow receiveShadow><meshStandardMaterial color="#28333b" roughness={.94}/></mesh>
  <instancedMesh name="compact-drive-marks" ref={marks} args={[undefined,undefined,count]}><boxGeometry args={[.018,.001,.04]}/><meshStandardMaterial color="#677b89" roughness={.9}/></instancedMesh>
  {[-1,1].map(s=><group key={s}>
   <Part name="compact-side-frame" size={[l,.10,.025]} position={[0,.01,s*(w/2+.0125)]}/>
   <RoundPart name="compact-nose-roller" radius={r-.005} length={w+.02} position={[s*(l/2-r),.085,0]}/>
   <RoundPart name="compact-bearing" radius={.015} length={.006} position={[s*(l/2-r),.085,w/2+.027]}/>
  </group>)}
  <Part name="compact-lower-mount" size={[l*.8,.02,w+.05]} position={[0,-.05,0]}/>
  <RoundPart name="compact-enclosed-drive" radius={.03} length={w-.02} position={[0,.066,0]} color={FINISH.dark}/>
  {rotary ? [-1,1].flatMap(x=>[-1,1].map(z=><Part key={`${x}:${z}`} name="deck-mount-foot" size={[.05,.01,.035]} position={[x*.16,-.065,z*.09]}/>))
   : [-1,1].flatMap(x=>[-1,1].map(z=><group key={`${x}:${z}`}>
    <Part name="compact-fixed-leg" size={[.035,.44,.035]} position={[x*(l/2-.14),-.28,z*(w/2-.025)]} color={FINISH.dark}/>
    <RoundPart name="compact-fixed-foot" radius={.035} length={.025} position={[x*(l/2-.14),-.4875,z*(w/2-.025)]} axis="y" color={FINISH.dark}/>
   </group>))}
 </group>
}
