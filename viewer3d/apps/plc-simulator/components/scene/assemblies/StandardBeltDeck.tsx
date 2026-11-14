'use client'
import {useEffect,useMemo,useRef} from 'react'
import {useFrame} from '@react-three/fiber'
import {Group,InstancedMesh,Object3D} from 'three'
import {Part,RoundPart,BoredPlate,FINISH} from './Parts'
import {beltDimensions,wrappedBeltGeometry,beltSurfacePose} from './transportGeometry'
import {CONVEYOR_BELT_TOP_Y} from '../deviceGeometry'
import type {DeviceProps} from '../devices'

/** M04 belt geometry/finish, sized for a compact deck with an existing stand.
 * Every marker reads recorded belt distance. There is no clock-driven motion.
 */
export function StandardBeltDeck({length,width,top,plant,stateId,drive=false}:{length:number;width:number;top:number;plant:DeviceProps['plant'];stateId?:string;drive?:boolean}) {
 const radius=.027,g=beltDimensions(length,radius),geometry=useMemo(()=>wrappedBeltGeometry(length,width-.024,radius),[length,width])
 const marks=useRef<InstancedMesh>(null),dummy=useMemo(()=>new Object3D(),[]),count=Math.ceil(g.perimeter/.24)
 useEffect(()=>()=>geometry.dispose(),[geometry])
 useFrame(()=>{
  if(!marks.current)return
  const distance=stateId?plant.state(stateId).pos:0
  for(let i=0;i<count;i++){
   const p=beltSurfacePose(length,distance+i*g.perimeter/count,.0007,radius)
   dummy.position.set(p.x,p.y+top-CONVEYOR_BELT_TOP_Y,0);dummy.rotation.z=p.angle;dummy.updateMatrix();marks.current.setMatrixAt(i,dummy.matrix)
  }
  marks.current.instanceMatrix.needsUpdate=true
 })
 return <group name="standard-belt-deck-m04-family">
  <mesh name="conveyor-continuous-belt" position={[0,top-CONVEYOR_BELT_TOP_Y,0]} geometry={geometry} castShadow receiveShadow><meshStandardMaterial color="#252e34" roughness={.94} metalness={.02}/></mesh>
  {stateId&&<instancedMesh name="conveyor-shared-drive-markers" ref={marks} args={[undefined,undefined,count]}><boxGeometry args={[.016,.001,width*.22]}/><meshStandardMaterial color="#45535e" roughness={.94}/></instancedMesh>}
  {[-1,1].map(side=><group key={side}>
   <Part name="conveyor-side-rail" position={[0,top-.042,side*(width/2+.014)]} size={[length,.060,.028]} color={FINISH.alloy}/>
   <Part name="conveyor-rail-channel" position={[0,top-.045,side*(width/2+.029)]} size={[length*.82,.006,.002]} color={FINISH.dark}/>
   {[-1,1].map(end=><BoredPlate key={end} name="conveyor-bored-bearing" position={[end*g.halfStraight,top-radius,side*(width/2+.025)]} size={[.06,.044,.012]} corner={.008} holes={[{x:0,y:0,radius:.006}]} color={FINISH.alloy}/>)}
  </group>)}
  {[-1,1].map(end=><group key={end}>
   <RoundPart name="conveyor-end-drum" position={[end*g.halfStraight,top-radius,0]} radius={radius-g.thickness-.002} length={width-.026} axis="z"/>
   <RoundPart name="conveyor-through-shaft" position={[end*g.halfStraight,top-radius,0]} radius={.005} length={width+.075} axis="z"/>
  </group>)}
  {drive&&<group position={[-g.halfStraight,top-radius,-width/2-.08]}><StandardBeltDrive/></group>}
 </group>
}
export function StandardBeltDrive(){return <group name="conveyor-connected-gearmotor">
 <Part position={[0,0,0]} size={[.075,.070,.055]} color={FINISH.steel}/>
 <RoundPart position={[0,0,-.064]} radius={.029} length={.075} axis="z" color={FINISH.dark}/>
 <RoundPart position={[0,0,-.105]} radius={.031} length={.010} axis="z" color={FINISH.dark}/>
 <RoundPart name="conveyor-drive-shaft" position={[0,0,.045]} radius={.006} length={.090} axis="z"/>
 <Part name="conveyor-drive-bracket" position={[0,-.045,.02]} size={[.085,.018,.090]} color={FINISH.alloy}/>
 </group>}
export function BeltSlotClamp({device,plant,stop=false}:DeviceProps&{stop?:boolean}){
 const a=useRef<Group>(null),b=useRef<Group>(null)
 useFrame(()=>{const closed=plant.state(device.id).pos>.5;if(a.current)a.current.position.z=stop?(closed?0:.18):.069+(closed?0:.10);if(b.current)b.current.position.z=-.069-(closed?0:.10)})
 return <group name={stop?'belt-side-entry-stop':'belt-slot-holding-clamp'}>
  <group ref={a}><Part name="contact-finger" size={stop?[.02,.040,.14]:[.12,.04,.018]} color={FINISH.dark}/><RoundPart position={[0,0,stop?.12:.072]} radius={.007} length={stop?.20:.12} axis="z"/></group>
  {!stop&&<group ref={b}><Part name="opposed-contact-finger" size={[.12,.04,.018]} color={FINISH.dark}/><RoundPart position={[0,0,-.072]} radius={.007} length={.12} axis="z"/></group>}
  {(stop?[1]:[-1,1]).map(s=><group key={s}><Part name="clamp-cylinder-body" position={[0,0,s*.225]} size={[.06,.045,.10]} color={FINISH.alloy}/><Part name="clamp-rail-mount" position={[0,-.045,s*.198]} size={[.075,.045,.110]} color={FINISH.steel}/></group>)}
 </group>
}
