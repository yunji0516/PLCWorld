'use client'

import { useEffect, useMemo } from 'react'
import { ExtrudeGeometry, Shape, Path } from 'three'
import { SocketBolt } from '../IndustrialDetails'
import { FINISH, Part, RoundPart } from './Parts'
import { MotionRealism } from './MotionRealism'
import { useIndexEquipmentColor, useIndustrialSurface } from './IndexEquipmentPalette'
import { RoundDriveCasting } from './RoundDriveCasting'
import { FittedMaterialDrive } from './FittedMaterialDrive'

/** Parts use physical dimensions. The parent remains driven by the recorded poses. */
export function ArticulatedLink({ size, color }: { size: number[]; color: string }) {
  const [sx,sy,d]=size,vertical=sy>sx,w=Math.max(sx,sy),l=Math.min(sx,sy)
  const geometry=useMemo(()=>{
    const s=new Shape(),b=.003,r=l/2-b,left=-w/2+b,right=w/2-b
    s.moveTo(left+r,-r);s.lineTo(right-r,-r*.84)
    s.quadraticCurveTo(right,-r*.84,right,0);s.quadraticCurveTo(right,r*.84,right-r,r*.84)
    s.lineTo(left+r,r);s.quadraticCurveTo(left,r,left,0);s.quadraticCurveTo(left,-r,left+r,-r);s.closePath()
    const g=new ExtrudeGeometry(s,{depth:d-.012,bevelEnabled:true,bevelThickness:.003,bevelSize:b,bevelSegments:3,curveSegments:16})
    g.translate(0,0,-(d-.012)/2);return g
  },[w,l,d])
  useEffect(()=>()=>geometry.dispose(),[geometry])
  const paint=useIndexEquipmentColor(color),surface=useIndustrialSurface(color)
  return <MotionRealism.Provider value={false}><group scale={[1/sx,1/sy,1/d]} name="machined-articulated-link"><group rotation={[0,0,vertical?Math.PI/2:0]}>
    <mesh geometry={geometry} castShadow receiveShadow><meshStandardMaterial color={paint} {...surface}/></mesh>
    {[-1,1].map(side=><group key={side} rotation={[0,side<0?Math.PI:0,0]}>
      <Part name="link-service-cover" position={[0,0,d/2-.002]} size={[w*.58,l*.57,.004]} color={FINISH.blue} radius={.012}/>
      {[-1,1].flatMap(x=>[-1,1].map(y=><SocketBolt key={`${x}-${y}`} position={[x*w*.19,y*l*.235,d/2+.001]} radius={.004}/>))}
    </group>)}
  </group></group></MotionRealism.Provider>
}

export function BoltCircle({radius,y,count=8,bolt=.006}:{radius:number;y:number;count?:number;bolt?:number}) {
 return <>{Array.from({length:count},(_,i)=>{const a=i*2*Math.PI/count;return <SocketBolt key={i} top position={[radius*Math.cos(a),y,radius*Math.sin(a)]} radius={bolt}/>})}</>
}

export function RobotPedestal() {
 return <MotionRealism.Provider value={false}><group name="robot-cast-drive-pedestal">
  <RoundPart name="pedestal-mount-flange" position={[0,.12,0]} radius={.27} length={.06} axis="y" color={FINISH.steel}/>
  <BoltCircle radius={.235} y={.151} bolt={.009}/>
  <RoundPart name="robot-drive-column" position={[0,.4125,0]} radius={.195} length={.525} axis="y" color={FINISH.alloy}/>
  <RoundPart name="shoulder-bearing-housing" position={[0,.7075,0]} radius={.235} length={.065} axis="y" color={FINISH.alloy}/>
  <RoundPart name="shoulder-seal" position={[0,.748,0]} radius={.21} length={.016} axis="y" color={FINISH.seal}/>
  <RoundPart name="shoulder-output" position={[0,.843,0]} radius={.16} length={.174} axis="y" color={FINISH.alloy}/>
  <RoundPart name="shoulder-cap" position={[0,.942,0]} radius={.16} length={.024} axis="y" color={FINISH.alloy}/>
  <BoltCircle radius={.12} y={.955} count={6}/>
  <Part name="pedestal-service-panel" position={[0,.40,.197]} size={[.19,.30,.016]} color={FINISH.dark} radius={.015}/>
  {[-1,1].flatMap(x=>[-1,1].map(y=><SocketBolt key={`${x}-${y}`} position={[x*.067,.4+y*.12,.206]} radius={.005}/>))}
 </group></MotionRealism.Provider>
}

export function JointCap({radius,height}:{radius:number;height:number}) {
 return <MotionRealism.Provider value={false}><group name="joint-machined-end-cover">
  <RoundPart position={[0,height/2+.007,0]} radius={radius} length={.014} axis="y" color={FINISH.alloy}/>
  <RoundPart position={[0,height/2+.017,0]} radius={radius*.52} length={.006} axis="y" color={FINISH.alloy}/>
  <BoltCircle radius={radius*.77} y={height/2+.015} count={6} bolt={.004}/>
 </group></MotionRealism.Provider>
}

export function RotaryIndexBase() {
 return <MotionRealism.Provider value={false}><group name="cast-rotary-index-drive">
  <RoundPart name="gearbox-mount-flange" position={[0,.12,0]} radius={.33} length={.06} axis="y" color={FINISH.steel}/>
  <RoundDriveCasting bottom={.15} top={.54} radius={.275}/>
  <RoundPart name="rotary-output-housing" position={[0,.61,0]} radius={.265} length={.14} axis="y" color={FINISH.alloy}/>
  <RoundPart name="rotary-seal-band" position={[0,.69,0]} radius={.255} length={.02} axis="y" color={FINISH.seal}/>
  <RoundPart name="table-bearing-cartridge" position={[0,.745,0]} radius={.24} length={.09} axis="y" color={FINISH.alloy}/>
  <RoundPart name="table-output-flange" position={[0,.80375,0]} radius={.35} length={.0275} axis="y" color={FINISH.steel}/>
  <RoundPart name="gearbox-input-adapter" position={[-.2825,.32,0]} radius={.09} length={.065} axis="x"/>
  <FittedMaterialDrive position={[-.425,.32,0]} size={[.22,.18,.18]} axis="x"/>
  <BoltCircle radius={.29} y={.151} bolt={.008}/>
 </group></MotionRealism.Provider>
}

/** Separate face plates meet at edges; the central opening remains clear for the next tube. */
export function TubeCollar({x,width,height}:{x:number;width:number;height:number}) {
 return <group position={[x,0,0]} name="telescopic-guide-wiper">
  {[-1,1].map(s=><group key={s}>
   <Part position={[0,s*(height/2+.009),0]} size={[.055,.018,width+.036]} color={FINISH.steel} radius={.002}/>
   <Part position={[0,0,s*(width/2+.009)]} size={[.055,height,.018]} color={FINISH.steel} radius={.002}/>
   <SocketBolt top position={[0,height/2+.019,s*width*.32]} radius={.0035}/>
  </group>)}
 </group>
}
export function TelescopicPedestal() {
 return <MotionRealism.Provider value={false}><group name="telescopic-slew-drive">
  <Part name="slew-mount-foot" position={[0,.12,0]} size={[.50,.06,.50]} color={FINISH.steel} radius={.015}/>
  <Part name="slew-column" position={[0,.475,0]} size={[.36,.65,.36]} color={FINISH.alloy} radius={.025}/>
  <Part name="column-service-cover" position={[0,.47,.185]} size={[.24,.43,.01]} color={FINISH.blue} radius={.012}/>
  {[-1,1].flatMap(x=>[-1,1].map(y=><SocketBolt key={`${x}-${y}`} position={[x*.09,.47+y*.18,.191]} radius={.006}/>))}
  <RoundPart name="slew-lower-housing" position={[0,.84,0]} radius={.26} length={.08} axis="y" color={FINISH.alloy}/>
  <RoundPart name="slew-bearing-seal" position={[0,.886,0]} radius={.245} length={.012} axis="y" color={FINISH.seal}/>
  <RoundPart name="slew-output-collar" position={[0,.901,0]} radius={.24} length={.018} axis="y" color={FINISH.alloy}/>
  <BoltCircle radius={.204} y={.911} bolt={.005}/>
 </group></MotionRealism.Provider>
}

/** Bored eye replaces the solid disk; its outer envelope and recorded tip pose stay fixed. */
export function BoomEndEye() {
 const geometry=useMemo(()=>{
  const s=new Shape();s.absarc(0,0,.065,0,2*Math.PI,false)
  const h=new Path();h.absarc(0,0,.032,0,2*Math.PI,true);s.holes.push(h)
  const g=new ExtrudeGeometry(s,{depth:.08,bevelEnabled:false,curveSegments:48});g.translate(0,0,-.04);return g
 },[])
 useEffect(()=>()=>geometry.dispose(),[geometry])
 const color=useIndexEquipmentColor(FINISH.steel),surface=useIndustrialSurface(FINISH.steel)
 return <mesh name="empty-boom-bored-end-eye" geometry={geometry} castShadow receiveShadow><meshStandardMaterial color={color} {...surface}/></mesh>
}
