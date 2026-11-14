'use client'

import { useFrame } from '@react-three/fiber'
import { useEffect, useMemo, useRef } from 'react'
import * as THREE from 'three'
import type { DeviceProps } from '../devices'
import { Part, RoundPart, BoredPlate } from './Parts'
import { MaterialTableLegs } from './MaterialTableLegs'
import { DeckRollers } from './MaterialAdvancedHardware'
import { MaterialFrameDetails, EdgeStage, EdgeSensor, EdgeWeb } from './MaterialClarityHardware'
import { Profile, Drive, Hose, BoredHub, Rail } from './MaterialV6Details'
import { SocketBolt } from '../IndustrialDetails'
import {gripperAssemblyGeometry} from './geometry'
import {useMaterialPresentation} from './MaterialPresentation'

type V3=[number,number,number]
const B=({p,s,c='#91a6af'}:{p:V3;s:V3;c?:string})=><Part position={p} size={s} color={c}/>
const R=({p,r,l,axis='y',c='#78939f'}:{p:V3;r:number;l:number;axis?:'x'|'y'|'z';c?:string})=><RoundPart position={p} radius={r} length={l} axis={axis} color={c}/>
function Frame({x=0,w=1,d=.5,top=.7,commonLegs=false}:{x?:number;w?:number;d?:number;top?:number;commonLegs?:boolean}){
 return <group><MaterialFrameDetails x={x} w={w} d={d} top={top} legInset={.06} legEdge={commonLegs?.055:.045} deckThickness={.05} lowerTies={!commonLegs}/><Part name="easy-focus-tabletop" position={[x,top-.025,0]} size={[w,.05,d]}/>{commonLegs?<MaterialTableLegs x={x} halfX={w/2-.06} halfZ={d/2-.06} top={top-.05}/>:<>{[-1,1].flatMap(a=>[-1,1].map(b=><Profile key={`${a}${b}`} p={[x+a*(w/2-.06),(top-.05)/2,b*(d/2-.06)]} length={top-.05} edge={.045}/>))}</>}</group>
}
function Bottle({device,plant,capacity=40,source=false}:{device:DeviceProps['device'];plant:DeviceProps['plant'];capacity?:number;source?:boolean}){
 const fill=useRef<THREE.Group>(null)
 useFrame(()=>{if(fill.current){const f=plant.state(device.id).pos;fill.current.scale.y=Math.max(.0001,f);fill.current.visible=f>1e-6}})
 const h=capacity===1000?.32:.24,r=capacity===1000?.075:.055
 return <group name="easy-graduated-reservoir">
  <mesh position={[0,h/2+.01,0]}><cylinderGeometry args={[r,r,h,32,1,true]}/><meshStandardMaterial color="#cae4e3" transparent opacity={.22} depthWrite={false} side={THREE.DoubleSide}/></mesh>
  <R p={[0,.005,0]} r={r+.004} l={.01}/><R p={[0,h+.02,0]} r={r+.004} l={.02}/>
  <group position={[0,.01,0]}><group ref={fill}><R p={[0,h/2,0]} r={r-.006} l={h} c={source?'#5ca6a0':'#c99755'}/></group></group>
  {[0,1,2,3,4].map(i=><B key={i} p={[.012,.02+i*(h-.02)/4,r+.003]} s={[.024,.003,.004]} c="#405e67"/>)}
 </group>
}
export function CouplingHead({device,plant,release=false,robot=false}:DeviceProps&{release?:boolean;robot?:boolean}){
 const refined=useMaterialPresentation()
 const left=useRef<THREE.Group>(null),right=useRef<THREE.Group>(null)
 useFrame(()=>{const f=plant.state(device.id).pos,half=robot?gripperAssemblyGeometry(false,f).jawCenter-.008:.162+.055*(1-f);left.current?.position.set(-half,0,0);right.current?.position.set(half,0,0)})
 const padY=robot?-.025:release?-.015:-.0675
 return <group name="easy-parallel-gripper" position={robot?[0,-.17,0]:[0,0,0]}>
  {robot&&<R p={[0,.20375,0]} r={.05} l={.0925} c="#7f8f9c"/>}
  <group name="easy-gripper-slotted-housing">
   <B p={[0,.15,0]} s={[.18,.015,.16]} c="#b9c4ca"/>
   <B p={[0,.1225,0]} s={[.18,.04,.13]} c="#526f7f"/>
   <B p={[0,.126,.081]} s={[.145,.028,.002]} c="#aab9c2"/>
   {[-1,1].map(side=><group key={side}>
    <B p={[side*.1725,.1485,0]} s={[.165,.012,.148]} c="#9bafb9"/>
    <B p={[0,.126,side*.076]} s={[.51,.033,.008]} c="#526773"/>
    <B p={[side*.092,.1225,0]} s={[.004,.036,.13]} c="#aebcc4"/>
    {[-1,1].map(z=><SocketBolt key={z} top position={[side*.06,.1587,z*.045]} radius={.004}/>)}
   </group>)}
  </group>
  <B p={[0,.13,-.09]} s={[.18,.04,.02]}/>
  {refined&&<group name="easy-gripper-machined-detail">
   <Part name="gripper-rear-mount-flange" position={[0,.13,-.106]} size={[.20,.055,.012]} radius={.004}/>
   {[-1,1].map(s=><group key={s}>
    <Part name="gripper-end-cover" position={[s*.260,.13,0]} size={[.010,.043,.15]} radius={.004} color="#35434e"/>
    <RoundPart name="gripper-air-port" position={[s*.064,.128,.086]} radius={.006} length={.010} axis="z" color="#35434e"/>
    <SocketBolt position={[s*.045,.128,.092]} radius={.003}/>
   </group>)}
  </group>}
  {[-1,1].map(side=><group key={side} ref={side<0?left:right} name={side<0?'easy-left-jaw':'easy-right-jaw'}>
   <B p={[0,.115,0]} s={[.065,.045,.14]}/>
   <B p={[side*.012,(.095+padY)/2,0]} s={[.028,.095-padY,.10]} c="#839aa4"/>
   <B p={[0,padY,0]} s={[.024,.024,.12]} c="#304d57"/>
   {[-1,1].map(z=><SocketBolt key={z} top position={[0,.1387,z*.042]} radius={.004}/>)}
   <SocketBolt position={[side*.012,(.095+padY)/2,.052]} radius={.005}/>
  </group>)}
 </group>
}
function LocalBuffer({plant}:DeviceProps){
 const geometry=useMemo(()=>new THREE.BufferGeometry(),[])
 useEffect(()=>()=>geometry.dispose(),[geometry])
 useFrame(()=>{
  const y=1.15-plant.state('DANCER').pos*900/2000,pts:V3[]=[[-1.40,1.25075,0],[-1.0515,1.25075,0]]
  const arc=(x:number,y:number,a:number,b:number,n:number)=>{for(let i=1;i<=n;i++){const t=a+(b-a)*i/n;pts.push([x+.10075*Math.cos(t),y+.10075*Math.sin(t),0])}}
  arc(-1.0515,1.15,Math.PI/2,0,16);pts.push([-.95075,y,0]);arc(-.85,y,Math.PI,2*Math.PI,32);pts.push([-.74925,1.15,0]);arc(-.6485,1.15,Math.PI,Math.PI/2,16);pts.push([-.25,1.25075,0])
  const pos=pts.flatMap(p=>[p[0],p[1],-.065,p[0],p[1],.065]),indices:number[]=[]
  for(let i=0;i<pts.length-1;i++){const j=i*2;indices.push(j,j+1,j+2,j+1,j+3,j+2)}
  geometry.setAttribute('position',new THREE.Float32BufferAttribute(pos,3));geometry.setIndex(indices);geometry.computeVertexNormals();geometry.computeBoundingSphere()
 })
 return <mesh name="buffer-continuous-ribbon" geometry={geometry} frustumCulled={false}><meshStandardMaterial color="#bf955c" roughness={.5} side={THREE.DoubleSide}/></mesh>
}
export function MaterialEasyFocusHardware(props:DeviceProps){
 const {device,plant}=props,v=device.visualVariant??'',moving=useRef<THREE.Group>(null)
 useFrame(()=>{const f=plant.state(device.id).pos;if(v==='easy15-local-web'&&moving.current)moving.current.position.z=f;if(v==='easy15-feed-drive'&&moving.current)moving.current.rotation.z=f;if(v==='easy15-dose-liquid'&&moving.current){moving.current.scale.y=Math.max(.00001,f);moving.current.visible=f>1e-6};if(v==='easy15-visible-line'&&moving.current){moving.current.scale.x=Math.max(.00001,f);moving.current.position.x=.09-.245*f;moving.current.visible=f>1e-6}})
 if(v==='easy15-contact-head'||v==='easy15-release-head')return <CouplingHead {...props} release={v==='easy15-release-head'}/>
 if(v==='easy15-source-bottle'||v==='easy15-recovery-bottle'||v==='easy15-dose-source')return <Bottle {...props} capacity={v==='easy15-dose-source'?1000:40} source={v!=='easy15-recovery-bottle'}/>
 if(v==='easy15-dose-liquid')return <group ref={moving}><R p={[0,.1,0]} r={.10} l={.20} c="#5ca6a0"/></group>
 if(v==='easy15-local-buffer')return <LocalBuffer {...props}/>
 if(v==='easy15-feed-drive')return <group><Drive p={[0,0,0]} axis="z"/><group ref={moving}><B p={[0,0,.085]} s={[.08,.015,.008]} c="#d8ba73"/></group></group>
 if(v==='easy15-local-web')return <EdgeWeb device={device} plant={plant} length={1.0}/>
 if(v==='easy15-visible-line')return <group>
  <R p={[-.155,1.06,0]} r={.018} l={.49} axis="x" c="#5da8a1"/>
  <group ref={moving}><R p={[0,1.06,0]} r={.019} l={.49} axis="x" c="#c99755"/></group>
  <R p={[-.4,1.02,0]} r={.018} l={.08}/>
 </group>
 const n=Number(v.slice(-2))
 if(n===8)return <group name="easy-single-piece-conveyor">
  <Frame w={.90} d={.40} top={.65}/>
  <DeckRollers w={.90} top={.79} d={.28}/>
  <group name="easy08-photoeye-mounted-cantilever">
   <Part name="easy08-sensor-foot" position={[.12,.662,.15]} size={[.09,.024,.09]}/>
   <Part name="easy08-sensor-arm" position={[.12,.680,.255]} size={[.045,.012,.255]}/>
   <Part name="easy08-sensor-upright" position={[.12,.768,.36]} size={[.025,.164,.025]}/>
   <Part name="easy08-sensor-backplate" position={[.12,.80,.3485]} size={[.08,.10,.007]}/>
   {[-1,1].map(k=><SocketBolt key={k} top position={[.12+k*.029,.6752,.15]} radius={.004}/>)}
  </group>
  <B p={[0,.61,-.20]} s={[.12,.16,.10]}/>
  <group name="easy08-retroreflector-mount">
   <Part position={[.12,.656,-.165]} size={[.09,.012,.10]}/>
   <Part position={[.12,.741,-.202]} size={[.025,.158,.025]}/>
   <Part name="easy08-reflector-frame" position={[.12,.82,-.185]} size={[.075,.09,.012]} color="#384e5c"/>
   <Part name="easy08-reflector-face" position={[.12,.82,-.1785]} size={[.055,.065,.001]} color="#e4e8dc"/>
   {[-1,1].map(k=><SocketBolt key={k} position={[.12+k*.029,.785,-.1778]} radius={.004}/>)}
  </group>
 </group>
 if(n===9)return <group name="easy-benchtop-dose-instrument">
  <Frame commonLegs x={.13} w={1.45} d={.6} top={.72}/>
  <B p={[-.25,.80,0]} s={[.20,.16,.22]} c="#557d85"/><Drive p={[-.43,.80,0]}/>
  <Profile p={[-.15,.95,-.12]} length={.46} edge={.035}/><B p={[-.15,1.1,-.06]} s={[.08,.035,.16]}/>
  <Profile p={[.82,1.0,0]} length={.56} edge={.035}/><B p={[.745,1.26,0]} s={[.185,.025,.055]}/>
  <BoredHub p={[.65,.845,0]} outer={.12} inner={.11} height={.22}/><B p={[.65,.724,0]} s={[.23,.008,.23]}/>
  {[0,1,2,3,4].map(i=><B key={i} p={[.65,.74+i*.045,.122]} s={[.035,.003,.005]} c="#405e67"/>)}
  <Hose purpose="functional" points={[[-.45,1.06,-.15],[-.32,1.08,-.18],[-.25,.88,0]]} radius={.007}/>
  <Hose purpose="functional" points={[[-.25,.88,.04],[-.32,1.0,.10],[-.26,1.12,0]]} radius={.007}/>
  <Hose purpose="functional" points={[[-.04,1.12,0],[.08,1.31,-.09],[.55,1.31,-.09],[.65,1.27,0]]} radius={.006}/>
 </group>
 if(n===10)return <group name="easy-vertical-buffer-module">
  <Frame commonLegs x={-.85} w={1.25} d={.62} top={.60}/>
  <BoredPlate name="easy-buffer-bearing-panel" position={[-.85,.96,-.28]} size={[1.14,.72,.035]} holes={[{x:-.2015,y:.19,radius:.021},{x:.2015,y:.19,radius:.021}]} color="#b7c5c7"/>
  {[-1.0515,-.6485].map(x=><group key={x}><R p={[x,1.15,0]} r={.10} l={.15} axis="z"/><R p={[x,1.15,-.175]} r={.018} l={.26} axis="z"/></group>)}
  <Part name="easy-buffer-vertical-guide" position={[-.85,1.0,-.24]} size={[.025,.50,.05]} color="#a3afb9"/>
  {[.8,1.05].map(y=><B key={y} p={[-.40,y,-.257]} s={[.16,.008,.012]} c="#709b80"/>)}
  {Array.from({length:11},(_,i)=><B key={i} p={[-.44,.75+i*.03,-.257]} s={[i%5===0?.08:.04,.003,.012]} c="#536a71"/>)}
 </group>
 if(n===11)return <group name="easy-local-edge-guide-module">
  <Frame commonLegs w={1.12} d={.56} top={.68}/>
  {[-.4,.4].map(x=><group key={x}><R p={[x,.77,0]} r={.03} l={.28} axis="z"/>{[-.18,.18].map(z=><B key={z} p={[x,.74,z]} s={[.07,.12,.06]} c="#52727b"/>)}</group>)}
  <EdgeStage/><EdgeSensor x={.25}/>

 </group>
 if(n===12)return <group name="easy-line-displacement-instrument">
  <Frame commonLegs x={-.1} w={1.35} d={.52} top={.76}/>
  <B p={[-.4,.87,0]} s={[.14,.22,.14]} c="#4e7885"/>
  <B p={[.205,.896,0]} s={[.065,.272,.08]}/>
  <Hose purpose="functional" points={[[-.65,1.02,0],[-.56,1.09,.10],[-.4,.98,.07]]} radius={.007}/>
  <Hose purpose="functional" points={[[.15,1.06,.12],[.32,1.16,.14],[.42,1.14,0],[.42,1.02,0]]} radius={.007}/>
 </group>
 return null
}
