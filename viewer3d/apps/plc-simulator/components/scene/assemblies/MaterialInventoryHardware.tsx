'use client'
import {ServiceEnclosure} from './ServiceEnclosure'

import { useFrame } from '@react-three/fiber'
import { useMemo, useRef } from 'react'
import * as THREE from 'three'
import type { DeviceProps } from '../devices'
import {MaterialTableLegs} from './MaterialTableLegs'
import { Part, RoundPart } from './Parts'
import { SocketBolt } from '../IndustrialDetails'
import { CabinetFace, CylinderBarrel, Drive, Foot, Hose, LabelPlate, Profile, Rail } from './MaterialV6Details'

type V3 = [number, number, number]
function Box({p,s,color='#9dafbb',name}:{p:V3;s:V3;color?:string;name?:string}) {
  return <Part name={name} position={p} size={s} color={color}/>
}
function Roll({p,r,w,color='#739aa9'}:{p:V3;r:number;w:number;color?:string}) {
  return <mesh position={p} rotation={[Math.PI/2,0,0]} castShadow><cylinderGeometry args={[r,r,w,48]}/><meshStandardMaterial color={color} metalness={.7} roughness={.3}/></mesh>
}

/** The same route is used for every frame; only the material inventory and
 * actual fed length change. Two vertical loop legs encode 2*delta-height. */
function route(buffer:number,web:number): V3[] {
  const y=1.15-buffer/2000
  const pts:V3[]=[[-1.60,1.25075,0],[-1.0515,1.25075,0]]
  const arc=(cx:number,cy:number,start:number,end:number,n:number)=>{
    for(let i=1;i<=n;i++){const a=start+(end-start)*i/n;pts.push([cx+.10075*Math.cos(a),cy+.10075*Math.sin(a),0])}
  }
  arc(-1.0515,1.15,Math.PI/2,0,16)
  pts.push([-.95075,y,0]);arc(-.85,y,Math.PI,2*Math.PI,32)
  pts.push([-.74925,1.15,0]);arc(-.6485,1.15,Math.PI,0,32)
  pts.push([-.54775,.95075,0]);arc(-.447,.95075,Math.PI,Math.PI*1.5,16)
  pts.push([1.05+web/1000,.85,0])
  return pts
}

function Ribbon({plant}:DeviceProps) {
  const geometry=useMemo(()=>{
    const n=route(100,0).length
    const g=new THREE.BufferGeometry();g.setAttribute('position',new THREE.BufferAttribute(new Float32Array(n*6),3))
    const indices:number[]=[]
    for(let i=0;i<n-1;i++){const j=i*2;indices.push(j,j+1,j+2,j+1,j+3,j+2)}
    g.setIndex(indices);return g
  },[])
  const tip=useRef<THREE.Mesh>(null)
  useFrame(()=>{
    const buffer=plant.state('DANCER').pos*900,web=plant.state('RIBBON').pos*500
    const points=route(buffer,web),a=geometry.attributes.position as THREE.BufferAttribute
    points.forEach((p,i)=>{a.setXYZ(i*2,p[0],p[1],-.065);a.setXYZ(i*2+1,p[0],p[1],.065)})
    a.needsUpdate=true;geometry.computeVertexNormals()
    if(tip.current)tip.current.position.x=1.05+web/1000
  })
  return <>
    <mesh name="buffer-continuous-ribbon" geometry={geometry} frustumCulled={false} receiveShadow>
      <meshStandardMaterial color="#b68a57" metalness={.55} roughness={.4} side={THREE.DoubleSide}/>
    </mesh>
    <mesh ref={tip} name="buffer-actual-material-tip" position={[1.05,.852,0]}><boxGeometry args={[.005,.003,.13]}/><meshStandardMaterial color="#e9d272"/></mesh>
  </>
}

export function MaterialInventoryHardware(props:DeviceProps) {
  const {device,plant}=props,variant=device.visualVariant??''
  const moving=useRef<THREE.Group>(null),rod=useRef<THREE.Group>(null)
  useFrame(()=>{
    const f=plant.state(device.id).pos
    if(variant==='v6-buffer-spool'&&moving.current)moving.current.rotation.z=f
    if((variant==='v6-buffer-feeder'||variant==='v6-buffer-receiver')&&moving.current&&rod.current){
      const opening=.045*(1-f);moving.current.position.y=opening
      const length=.1125-(.02075+opening)
      rod.current.scale.y=length;rod.current.position.y=.1125-length/2
    }
    if(variant==='v6-stack-slide'&&rod.current){
      const length=.02+.45*(1-f);rod.current.scale.y=length;rod.current.position.y=-length/2
    }
    if(variant==='v6-stack-table'&&rod.current){
      const deck=.55+.15*f,length=deck-.45;rod.current.scale.y=length;rod.current.position.y=-.05-length/2
    }
  })
  if(variant==='v6-buffer-ribbon')return <Ribbon {...props}/>
  if(variant==='v6-buffer-base')return <group name="synthetic-v6-buffer-base" position={[0,-.8,0]}>
    <group name="v6-mechanism-detail-layer">
      <Drive p={[-1.60,.90,-.28]} axis="z"/>
      <CabinetFace p={[-1.60,.45,-.115]} width={.13} height={.28} label="REEL"/>
      <LabelPlate text="WEB BUFFER" p={[-.85,.25,.035]} width={.40}/>
      <Box p={[-.85,.25,-.16]} s={[.48,.27,.38]} color="#567488"/>
      {[-1.0515,-.6485].map(x=><group key={x}>
        <Profile p={[x,.64,-.245]} length={1.13} edge={.045}/>
        <Roll p={[x,1.15,.085]} r={.031} w={.017} color="#c2cbd2"/>
        <SocketBolt position={[x,1.15,.096]} radius={.010}/>
      </group>)}
      <Box p={[-.58,.91,-.16]} s={[.045,.44,.012]} color="#dbe0e3"/>
      {Array.from({length:10},(_,i)=><Box key={i} p={[-.58,.72+i*.042,-.152]} s={[i%3===0?.033:.019,.002,.002]} color="#536778"/>)}
      <Hose points={[[-1.60,.91,-.38],[-1.64,.62,-.38],[-1.50,.11,-.26],[-1.04,.12,-.26]]}/>
      <ServiceEnclosure x={.94} z={.07} top={.755}/>
      <Drive p={[-.11,.78,-.20]}/>
      <LabelPlate text="FEED / TRANSFER" p={[.37,.747,.256]} width={.40}/>
      {[-.15,.15].map(z=><Rail key={z} p={[.36,.758,z]} length={.81}/>)}
    </group>
    <Box p={[-1.60,.04,-.09]} s={[.58,.08,.46]} color="#385c6c"/>
    <Box p={[-1.60,.48,-.18]} s={[.14,.90,.12]}/>
    <Roll p={[-1.60,.90,-.10]} r={.055} w={.28}/>
    <Box p={[-.85,.045,-.16]} s={[.60,.09,.38]} color="#385c6c"/>
    {[-1.0515,-.6485].map(x=><group key={x}>
      <Box p={[x,.63,-.19]} s={[.065,1.17,.065]}/>
      <Roll p={[x,1.15,0]} r={.10} w={.15}/>
      <Roll p={[x,1.15,-.12]} r={.025} w={.15}/>
    </group>)}
    <Roll p={[-.447,.95075,0]} r={.10} w={.15}/><Roll p={[-.447,.95075,-.12]} r={.025} w={.15}/>
    <Box p={[-.447,.48,-.19]} s={[.065,.90,.065]}/>
    <Box p={[-.85,1.16,-.265]} s={[.46,.05,.07]}/>
    <Box p={[-.85,.92,-.18]} s={[.025,.54,.03]} color="#c4d1d8"/>
    <MaterialTableLegs x={.695} halfX={.675} halfZ={.19} top={.755}/>
    {[-.22,.22].map(z=><Box key={z} p={[.62,.79,z]} s={[1.77,.07,.08]}/>)}
    <Box p={[1.29,.82425,0]} s={[.56,.05,.38]} color="#497888"/>
    <Box p={[.36,.7265,0]} s={[.80,.035,.34]} color="#497888"/>
    <Box p={[.90,.7495,0]} s={[.18,.05,.32]}/>
    {[-1,1].map(z=><Box key={z} p={[.90,.7775,z*.15]} s={[.18,.006,.06]}/>)}
  </group>
  if(variant==='v6-buffer-spool')return <group ref={moving} name="buffer-spool-rotation">
    <Roll p={[0,0,0]} r={.35} w={.13} color="#ac8d68"/>
    {[-.08,.08].map(z=><group key={z}>
      <mesh name="v6-reel-flange-ring" position={[0,0,z]} castShadow><torusGeometry args={[.352,.008,8,64]}/><meshStandardMaterial color="#c4cdd2" metalness={.7} roughness={.55}/></mesh>
      <Roll p={[0,0,z]} r={.075} w={.02} color="#bbc7d0"/>
      {Array.from({length:6},(_,i)=><group key={i} rotation={[0,0,i*Math.PI/3]}>
        <Box p={[.20,0,z]} s={[.28,.028,.014]} color="#93a6b4"/>
        <SocketBolt position={[.05,0,z+.012]} radius={.008}/>
      </group>)}
    </group>)}
    <Roll p={[0,0,-.10]} r={.07} w={.035}/>
    <Box p={[.16,0,-.09]} s={[.21,.026,.012]} color="#d3b365"/>
  </group>
  if(variant==='v6-buffer-dancer')return <group name="buffer-moving-dancer">
    <Roll p={[0,0,0]} r={.10} w={.15}/><Roll p={[0,0,-.12]} r={.025} w={.14}/>
    <Box p={[0,0,-.19]} s={[.12,.10,.07]} color="#197e86"/>
    <Roll p={[0,0,.085]} r={.026} w={.020}/><SocketBolt position={[0,0,.097]} radius={.009}/>
  </group>
  if(variant==='v6-buffer-feeder'||variant==='v6-buffer-receiver')return <group name="buffer-physical-clamp">
    <Hose color="#4283a1" points={[[.02,.16,-.02],[.08,.22,-.04],[.08,.23,-.10],[.045,.205,-.11]]} radius={.004}/>
    {[-1,1].map(z=><group key={z}>
      <SocketBolt top position={[.045,.208,z*.105]} radius={.006}/>
      <SocketBolt top position={[-.045,.208,z*.105]} radius={.006}/>
      <Box p={[0,-.057,z*.15]} s={[.15,.025,.06]} color="#536c7b"/>
    </group>)}
    <Box p={[0,-.043,0]} s={[.18,.065,.24]}/>
    <Box p={[0,-.01075,0]} s={[.14,.02,.20]} color="#576e7b"/>
    <group ref={moving} name={`buffer-upper-jaw-${device.id}`}><Box p={[0,.01075,0]} s={[.14,.02,.20]} color="#c7a25e"/></group>
    {[-.13,.13].map(z=><Box key={z} p={[0,.07525,z]} s={[.04,.1795,.03]}/>)}
    <Box p={[0,.185,0]} s={[.16,.04,.29]} color="#197e86"/>
    <mesh position={[0,.145,0]}><cylinderGeometry args={[.028,.028,.065,24]}/><meshStandardMaterial color="#5f8995"/></mesh>
    <group ref={rod}><Box p={[0,0,0]} s={[.015,1,.015]} color="#d2dce0"/></group>
  </group>
  if(variant==='v6-buffer-target')return <Box p={[0,0,0]} s={[.006,.004,.19]} color="#50bdad" name="buffer-request-line"/>
  if(variant==='v6-stack-base')return <group name="synthetic-v6-stack-base" position={[0,-.8,0]}>
    <group name="v6-mechanism-detail-layer">
      <Drive p={[-.89,1.385,-.19]}/>
      {[-1,1].map(side=><group key={side}>
        <CabinetFace p={[side*.70,.34,.163]} width={.35} height={.53} label={side<0?'A / SUPPLY':'B / SUPPLY'}/>
        {[-1,1].map(edge=><Profile key={edge} p={[side*.70+edge*.17,.34,.12]} length={.62} edge={.035}/>)}
        {[-1,1].map(z=><Foot key={z} p={[side*.70,0,-.12+z*.21]}/>)}
        {[-1,1].map(end=><group key={end} position={[side*.70,.671,-.12+end*.25]} rotation={[0,Math.PI/2,0]}><RoundPart radius={.029} length={.33} position={[0,0,0]}/></group>)}
        <Box p={[side*.70,.697,-.12]} s={[.30,.006,.51]} color="#485964"/>
        <Drive p={[side*.70+.22,.62,-.34]} axis="z"/>
      </group>)}
      {[-1,1].map(side=><group key={side}>
        <RoundPart radius={.015} length={.49} axis="y" position={[side*.145,.325,-.20]}/>
        <RoundPart radius={.028} length={.04} axis="y" position={[side*.145,.105,-.20]} color="#597b8c"/>
        <SocketBolt top position={[side*.18,.075,.15]} radius={.010}/>
      </group>)}
    </group>
    <Box p={[0,.715,-.46]} s={[.25,1.29,.23]} color="#698894"/>
    <Box p={[0,.035,-.235]} s={[.50,.07,.89]} color="#365867"/>
    <Box p={[0,1.37,-.325]} s={[.24,.10,.10]}/>
    <Box name="v6-fixed-travel-beam" p={[0,1.385,-.19]} s={[1.68,.09,.17]}/>
    <Box p={[0,1.410,-.1025]} s={[1.63,.05,.025]} color="#385563"/>
    {[-1,1].map(side=><group key={side}>
      <Box p={[side*.70,.345,-.12]} s={[.40,.67,.55]} color={side<0?'#aa8450':'#497b9b'}/>
      <Box p={[side*.70,.687,-.12]} s={[.40,.014,.55]}/>
      <Box p={[side*.70,.64,.157]} s={[.22,.03,.004]} color={side<0?'#e2b45f':'#5299c5'}/>
      {[-1,1].map(edge=><Box key={edge} p={[side*.70+edge*.19,.775,-.17]} s={[.025,.15,.40]}/>)}
    </group>)}
    <mesh position={[0,.23,0]}><cylinderGeometry args={[.085,.085,.40,32]}/><meshStandardMaterial color="#547d8d"/></mesh>
  </group>
  if(variant==='v6-stack-slide')return <group name="stack-fixed-stroke-slide">
    <CylinderBarrel stroke={.45}/>
    <Box name="v6-lift-carriage-body" p={[0,.015,0]} s={[.14,.06,.14]} color="#197e86"/>
    <Box p={[0,.055,-.06625]} s={[.23,.05,.0475]} color="#567080"/>
    {[-1,1].map(side=><SocketBolt key={side} top position={[side*.05,.047,.035]} radius={.006}/>)}
    <group ref={rod}><RoundPart position={[0,0,0]} radius={.015} length={1} axis="y" color="#c8d2d9"/></group>
  </group>
  if(variant==='v6-stack-table')return <group name="stack-physical-receiving-table">
    <Box p={[0,-.025,0]} s={[.37,.05,.28]} color="#7898a5"/>
    <Box p={[0,-.054,-.17]} s={[.34,.04,.12]} color="#3e5c6d"/>
    {[-1,1].map(side=><RoundPart key={side} radius={.025} length={.08} axis="y" position={[side*.145,-.075,-.20]} color="#8ca3b3"/>)}
    <group ref={rod}><Box p={[0,0,0]} s={[.07,1,.07]} color="#c8d2d9"/></group>
  </group>
  return null
}
