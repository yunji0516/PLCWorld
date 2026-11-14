'use client'
import {InterceptWorkbench} from './InterceptWorkbench'
import {MaterialTableLegs} from './MaterialTableLegs'
import { SuctionCup } from './SuctionCup'

import { useFrame } from '@react-three/fiber'
import { useEffect, useMemo, useRef } from 'react'
import * as THREE from 'three'
import type { DeviceProps } from '../devices'
import { Part, RoundPart, BoredPlate } from './Parts'
import { MaterialFrameDetails, EdgeStage, EdgeMovingSaddle, EdgeSensor, EdgeWeb } from './MaterialClarityHardware'
import { Foot, Profile, Rail, LinearGuideBed, Drive, Hose, LabelPlate, BoredHub } from './MaterialV6Details'
import { StandardBeltDeck, StandardBeltDrive } from './StandardBeltDeck'
import { SocketBolt } from '../IndustrialDetails'
import {EasyIndexTableDetail,CarouselToolingRing,RotaryPedestal,EjectorCarriageDetail,InterceptBaseDetail,InterceptPocketDetail} from './MaterialIndexDetail'
import {useMaterialPresentation,MATERIAL_WORKBENCH_BRIGHTNESS} from './MaterialPresentation'

type V3=[number,number,number]
const B=({p=[0,0,0],s,c='#93a8b5',name}:{p?:V3;s:V3;c?:string;name?:string})=><Part name={name} position={p} size={s} color={c}/>
const R=({p,r,l,axis='y',c='#7e95a4',name}:{p:V3;r:number;l:number;axis?:'x'|'y'|'z';c?:string;name?:string})=><RoundPart name={name} position={p} radius={r} length={l} axis={axis} color={c} matte={name==='rotary-table-deck'}/>
function PairTransferBridge({plant,side}:{plant:DeviceProps['plant'];side:number}){
 const beam=useRef<THREE.Group>(null),slider=useRef<THREE.Group>(null),rod=useRef<THREE.Group>(null)
 useFrame(()=>{const p=plant.machine.devices.find(d=>d.id==='TRANSFER_'+(side<0?'A':'B'))?.pos;if(!p)return
  beam.current?.position.set(side*.5,1.32,p[2]);slider.current?.position.set(p[0],1.32,p[2]);if(rod.current){const length=1.29-p[1]-.026;rod.current.position.set(p[0],p[1]+.026+length/2,p[2]);rod.current.scale.y=length}
 })
 return <group>
  {[side*.10,side*1.0].map(x=><group key={x}>{[-1.02,.43].map(z=><B key={z} name="pair-gantry-upright" p={[x,1.02,z]} s={[.045,.60,.045]}/>)}<B name="pair-longitudinal-guide" p={[x,1.32,-.30]} s={[.042,.045,1.53]} c="#486b81"/></group>)}
  <group ref={beam}><B name="pair-moving-crossbeam" s={[.94,.044,.047]}/></group>
  <group ref={slider}><B name="pair-cross-slide" s={[.10,.075,.095]} c="#416983"/></group>
  <group ref={rod}><R name="pair-connected-lift-rod" p={[0,0,0]} r={.009} l={1}/></group>
 </group>
}

function Stand({x=0,z=0,w=2,d=1,top=.75}:{x?:number;z?:number;w?:number;d?:number;top?:number}){
 const refined=useMaterialPresentation()
 const inset=refined?.08:.09,edge=.055
 return <group name="v8-support-frame">
  <Part name="v8-fixed-deck" position={[x,top-.03,z]} size={[w,.06,d]} color={refined?'#a3afb9':'#93a8b5'} brightness={refined?MATERIAL_WORKBENCH_BRIGHTNESS:1} matte={refined}/>
  <MaterialTableLegs x={x} z={z} halfX={w/2-inset} halfZ={d/2-inset} top={top-.06}/>

  <MaterialFrameDetails lowerTies={false} x={x} z={z} w={w} d={d} top={top} legInset={inset} legEdge={edge} supportColor={refined?'#35434e':undefined}/>
 </group>
}
function Gantry({w=1.8,z=-.35,y=1.5,bottom=.1}:{w?:number;z?:number;y?:number;bottom?:number}){
 return <group name="v8-overhead-gantry">{[-1,1].map(k=><Profile key={k} p={[k*w/2,(y+bottom)/2,z]} length={y-bottom} edge={.075}/>)}<B p={[0,y,z]} s={[w+.12,.10,.10]} c="#4b7289"/><Rail p={[0,y+.065,z]} length={w}/><Drive p={[-w/2-.10,y,z]}/></group>
}
export function DeckRollers({x=0,z=0,w=1.9,d=.32,top=.79}:{x?:number;z?:number;w?:number;d?:number;top?:number}){
 const n=Math.max(2,Math.floor(w/.10))
 return <group name="v8-roller-bed" userData={{deviceDisplayName:'Conveyor'}}>
  {Array.from({length:n},(_,i)=>{const rx=x-w/2+.06+i*(w-.12)/(n-1);return <group key={i} name="roller-with-bearing-supports">
   <R name="roller-machined-shell" p={[rx,top-.027,z]} r={.027} l={d-.016} axis="z" c="#a4b3bb"/>
   <R name="roller-through-axle" p={[rx,top-.027,z]} r={.005} l={d+.075} axis="z" c="#bcc6ca"/>
   {[-1,1].map(side=><group key={side}>
    <R name="roller-end-cap" p={[rx,top-.027,z+side*(d/2-.004)]} r={.0268} l={.008} axis="z" c="#546d7a"/>
    <BoredPlate name="roller-bored-bearing-seat" position={[rx,top-.027,z+side*(d/2+.020)]} size={[.040,.041,.012]} corner={.008} holes={[{x:0,y:0,radius:.006}]} color="#a5b4bc"/>
    <group position={[rx,top-.027,z+side*(d/2+.029)]} rotation={[Math.PI/2,0,0]}><BoredHub p={[0,0,0]} outer={.011} inner={.0055} height={.006}/></group>
   </group>)}
  </group>})}
  {[-1,1].map(side=><group key={side} name="conveyor-folded-side-channel">
   <B p={[x,top-.075,z+side*(d/2+.021)]} s={[w,.055,.028]} c="#607c8b"/>
   <B name="conveyor-service-cover" p={[x,top-.069,z+side*(d/2+.041)]} s={[w-.016,.044,.012]} c="#b0bdc5"/>
   {[-1,1].map(end=><group key={end} position={[x+end*(w/2-.028),top-.069,z+side*(d/2+.0482)]} rotation={[0,side<0?Math.PI:0,0]}><SocketBolt position={[0,0,0]} radius={.004}/></group>)}
  </group>)}
 </group>
}
function SlideRail({x=0,y=.87,z=-.26,w=1.1}:{x?:number;y?:number;z?:number;w?:number}){
 const end=x-w/2
 return <group name="v8-slide-rail">
  <LinearGuideBed p={[x,y,z]} length={w}/><Drive p={[end-.09,y-.04,z]}/>
  <group position={[end-.0275,y-.04,z]} rotation={[0,Math.PI/2,0]}>
   <BoredPlate name="motor-to-rail-bearing-housing" position={[0,0,0]} size={[.115,.125,.055]} corner={.006} holes={[{x:0,y:0,radius:.019}]} color="#7f8f9c"/>
  </group>
  <R name="motor-to-rail-drive-shaft" p={[end-.02425,y-.04,z]} r={.009} l={.0485} axis="x"/>
 </group>
}
function FluidJar({level}:{level:React.RefObject<THREE.Group|null>}){
 return <group><BoredHub p={[0,.20,0]} outer={.125} inner={.116} height={.4}/><R p={[0,.002,0]} r={.124} l={.004}/><R p={[0,.408,0]} r={.13} l={.014}/><group ref={level} name="v8-fluid-volume"><R p={[0,.195,0]} r={.114} l={.39} c="#5bafaa"/></group><B p={[0,.225,.128]} s={[.025,.28,.012]} c="#d5e1e2"/>{[0,1,2,3].map(i=><B key={i} p={[.020,.11+i*.068,.137]} s={[.035,.003,.004]} c="#354e5e"/>)}</group>
}
function HeadLocalHose({points}:{points:V3[]}){
 const curve=useMemo(()=>new THREE.CatmullRomCurve3(points.map(p=>new THREE.Vector3(...p)),false,'centripetal'),[points])
 return <mesh name="v8-fixed-length-local-hose" userData={{rigidLocalService:true,points}}>
  <tubeGeometry args={[curve,64,.004,8,false]}/><meshStandardMaterial color="#273a49" roughness={.8}/>
 </mesh>
}
/** Only the head-local pneumatic circuit is shown. Upstream supply is omitted.
 * Both fittings and the short hose are rigidly attached to the same moving body;
 * no world-fixed spline endpoint or variable-length service span is fabricated.
 */
function D17VacuumServices({plant}:Pick<DeviceProps,'plant'>){
 const head=useRef<THREE.Group>(null),scrap=useRef<THREE.Group>(null)
 useFrame(()=>{for(const [id,ref] of [['HEAD',head],['SCRAP_CARRIER',scrap]] as const){
  const p=plant.machine.devices.find(d=>d.id===id)?.pos;if(p)ref.current?.position.set(...p)
 }})
 return <group name="v8-local-vacuum-circuits">
  <group ref={head} name="v8-product-local-service">
   <B name="v8-head-valve-bracket" p={[.09,0,-.035]} s={[.04,.012,.05]}/>
   <B name="v8-head-local-valve" p={[.112,.022,-.035]} s={[.032,.032,.035]} c="#4c6979"/>
   <R p={[.112,.044,-.035]} r={.006} l={.012}/>
   <HeadLocalHose points={[[.112,.05,-.035],[.112,.078,-.035],[.075,.078,0],[.065,.025,0],[.048,.025,0]]}/>
  </group>
  <group ref={scrap} name="v8-scrap-local-service">
   <B name="v8-platen-local-valve" p={[.13,.04,.13]} s={[.055,.04,.045]} c="#4c6979"/>
   <R p={[.13,.066,.13]} r={.006} l={.012}/>
   <R p={[.08,.026,.08]} r={.006} l={.012}/>
   <HeadLocalHose points={[[.13,.072,.13],[.13,.094,.13],[.08,.094,.08],[.08,.032,.08]]}/>
  </group>
 </group>
}
/** Dedicated synthetic mechanisms. State and world poses are read from the replay. */
export function MaterialAdvancedHardware({device,plant}:DeviceProps){
 const v=device.visualVariant??'',a=useRef<THREE.Group>(null),b=useRef<THREE.Group>(null),c=useRef<THREE.Group>(null),rod=useRef<THREE.Group>(null)
 useFrame(()=>{
  const f=plant.state(device.id).pos
  if(v==='v8-carousel'&&a.current)a.current.rotation.y=-f
  if(v==='v8-pouch'){
   if(a.current)a.current.position.z=-f/2-.004
   if(b.current)b.current.position.z=f/2+.004
   if(c.current)c.current.scale.z=Math.max(.016,f+.016)
  }
  if(v==='v8-edge-web'&&a.current)a.current.position.z=f
  if(v==='v8-receiver-nip'&&a.current)a.current.position.y=.03+.08*(1-f)
  if(v==='v8-liquid-level'&&a.current)a.current.scale.y=Math.max(.00001,f)
  if(v==='v8-diverter-valve'&&a.current)a.current.rotation.y=f*Math.PI/2
  if(v==='v8-content-line'&&a.current)a.current.scale.x=Math.max(.001,f)
  if(v==='v8-gantry-carriage'){
   const headY=.8225+.28*f, len=1.3-headY-.067
   if(rod.current){rod.current.scale.y=len;rod.current.position.y=-len/2}
   if(a.current)a.current.position.y=headY+.053-1.3
  }
  if(v==='v8-skeleton-base'){
   const p=plant.machine.devices.find(d=>d.id==='SCRAP_CARRIER')?.pos
   if(p&&rod.current){const len=1.61-p[1]-.02;rod.current.position.set(-.6,p[1]+.02+len/2,0);rod.current.scale.y=len}
  }
  if(v==='v8-balance-base'){
   const h=plant.machine.devices.find(d=>d.id==='HEAD')?.pos
   if(h){
    if(a.current)a.current.position.set(h[0],1.48,0)
    if(b.current)b.current.position.set(h[0],1.48,h[2])
    const len=1.48-h[1]-.04
    if(rod.current){rod.current.position.set(h[0],h[1]+.04+len/2,h[2]);rod.current.scale.y=len}
   }
  }
  if(v==='v8-routing-drive'&&a.current)a.current.rotation.z=f*Math.PI*4
  if(v==='v8-conveyor-drive'&&a.current)a.current.rotation.z=f*Math.PI*4
 })
 if(v==='v8-aperture-base')return <group><Stand w={1.85} d={1.15} top={.73}/><B name="v8-content-support" p={[-.49,.755,0]} s={[.88,.05,.20]}/><B name="v8-pouch-internal-support" p={[.25,.755,0]} s={[.60,.05,.22]}/><SlideRail x={-.36} y={1.14} z={-.30} w={1.15}/>{[-.91,.18].map(x=><group key={x}><Profile p={[x,.90,-.50]} length={.34} edge={.04}/><B p={[x,1.07,-.40]} s={[.08,.05,.30]}/><B p={[x,.745,-.50]} s={[.09,.03,.12]}/></group>)}{[-1,1].map(k=><group key={k}><B p={[.1,.76,k*.30]} s={[.30,.06,.32]} c="#547789"/><R p={[.1,.86,k*.30]} r={.035} l={.25} axis="z"/><B p={[.1,.83,k*.43]} s={[.13,.10,.03]} c="#466376"/></group>)}<LabelPlate text="OPEN ENVELOPE" p={[0,.695,.452]} width={.45}/></group>
 if(v==='v8-mouth-pad'&&/MAT-(?:EASY15-)?E15/.test(plant.machine.title))return <group name="opening-guided-pad">
  <B p={[0,0,0]} s={[.30,.09,.07]} c="#7f8f9c"/>
  <B name="v8-mouth-contact" p={[0,-.012,device.id==='LEFT_PAD'?.031:-.031]} s={[.27,.05,.012]} c="#253b46"/>
  <B name="opening-pad-crosshead" p={[0,-.06,0]} s={[.36,.03,.07]} c="#7f8f9c"/>
  {[-.21,.21].map(x=><group key={x} position={[x,-.06,0]}>
   <BoredPlate name="opening-linear-bearing" position={[0,0,0]} size={[.06,.05,.07]} holes={[{x:0,y:0,radius:.0115}]} color="#a3afb9"/>
   <SocketBolt top position={[0,.026,.023]} radius={.004}/>
  </group>)}
  {[-.1,.1].map(x=><SocketBolt key={x} top position={[x,.046,0]} radius={.004}/>)}
 </group>
 if(v==='v8-mouth-pad')return <group><B p={[0,0,0]} s={[.30,.09,.07]} c="#536e81"/><B name="v8-mouth-contact" p={[0,-.012,device.id==='LEFT_PAD'?.031:-.031]} s={[.27,.05,.012]} c="#253b46"/><R p={[0,0,device.id==='LEFT_PAD'?-.08:.08]} r={.012} l={.12} axis="z"/>{[-.1,.1].map(x=><SocketBolt key={x} top position={[x,.046,0]} radius={.004}/>)}</group>
 if(v==='v8-pouch')return <group name="connected-flexible-pouch">
  <group ref={a}><B name="pouch-left-wall" p={[.25,.866,0]} s={[.64,.168,.008]} c="#b4b9b7"/></group>
  <group ref={b}><B name="pouch-right-wall" p={[.25,.866,0]} s={[.64,.168,.008]} c="#b4b9b7"/></group>
  <group ref={c}>
   <B name="pouch-connected-end-seam" p={[.574,.866,0]} s={[.008,.168,1]} c="#9babae"/>
   <B name="pouch-bottom-fold" p={[.25,.781,0]} s={[.64,.002,1]} c="#9babae"/>
  </group>
 </group>
 if(v==='v8-small-pusher'&&plant.machine.title.startsWith('MAT-V8-D16'))return <group>
  <B name="v8-pusher-face" s={device.size??[.08,.1,.1]} c="#445f70"/>
  <B name="v8-aperture-pusher-upright" p={[0,.135,0]} s={[.035,.27,.035]}/>
  <B name="v8-aperture-overhead-crosshead" p={[0,.2875,-.115]} s={[.055,.035,.265]}/>
  <B name="v8-aperture-saddle-neck" p={[0,.31375,-.23]} s={[.055,.0175,.035]}/><B name="v8-aperture-slide-saddle" p={[0,.35,-.30]} s={[.11,.055,.18]} c="#6a8798"/>
 </group>
 if(v==='v13-launch-pusher'||(v==='v8-small-pusher'&&plant.machine.title.startsWith('MAT-V8-D19')))return <group>
  <B name="v8-intercept-pusher-face" p={[0,0,0]} s={[.15,.08,.10]} c="#445f70"/>
  <B name="v8-intercept-pusher-arm" p={[-.035,.015,-.15]} s={[.05,.04,.28]}/>
  <B name="v8-intercept-pusher-saddle-cap" p={[-.025,.0515,-.30]} s={[.09,.018,.10]} c="#6a8798"/>
  {[-1,1].map(k=><B key={k} name="v8-intercept-pusher-saddle-cheek" p={[-.025,.02925,-.30+k*.0285]} s={[.09,.0265,.022]} c="#6a8798"/>)}
  <B name="v8-intercept-pusher-link" p={[-.035,.044,-.215]} s={[.05,.044,.07]}/>
  {[-1,1].map(k=><SocketBolt key={k} top position={[-.025+k*.026,.0615,-.30]} radius={.003}/>)}
 </group>
 if(v==='v8-small-pusher')return <group><B name="v8-pusher-face" s={device.size??[.08,.1,.1]} c="#445f70"/><B p={[0,.01,-.17]} s={[.07,.05,.28]}/><B p={[0,.02,-.30]} s={[.11,.055,.10]} c="#6a8798"/></group>
 if(v==='v8-skeleton-base')return <group>
  <Stand w={2.1} d={1.22} top={.68}/><Gantry w={1.85} z={-.38} y={1.3} bottom={.68}/>
  <B name="v8-passive-source-bed" p={[-.6,.71,0]} s={[.56,.06,.42]} c="#617c87"/>
  <B name="v8-product-receiver" p={[.6,.71,0]} s={[.42,.06,.34]} c="#65837f"/>
  {[-1,1].flatMap(x=>[-1,1].map(z=><group key={`${x}:${z}`}>
   <R name="v8-scrap-guide-post" p={[-.6+x*.32,1.30,z*.48]} r={.014} l={1.22}/>
   <B name="scrap-guide-anchor-foot" p={[-.6+x*.32,.715,z*.48]} s={[.09,.07,.09]} c="#4d6a7b"/>
  </group>))}
  <B name="v8-scrap-upper-crossbeam" p={[-.6,1.93,0]} s={[.76,.06,1.08]} c="#4c6a80"/>
  <R name="v8-scrap-lift-cylinder" p={[-.6,1.76,0]} r={.045} l={.30}/>
  <group ref={rod}><R name="v8-scrap-lift-piston" p={[0,0,0]} r={.017} l={1}/></group>
  <D17VacuumServices plant={plant}/>
  {!/^(MAT-V8-D17|MAT-M12)(?:\s|$)/.test(plant.machine.title??'')&&<LabelPlate text="SEPARATE CARRIERS" p={[.13,.648,.612]} width={.56}/>}
 </group>
 if(v==='v8-scrap-platen')return <group>
  <B name="v8-scrap-moving-platen" s={[.52,.04,.40]} c="#718c9c"/>
  {[[-.20,0],[.20,0],[0,-.15],[0,.15]].map(([x,z],i)=><group key={i}>
   <R name="v8-scrap-cup-stem" p={[x,-.029,z]} r={.006} l={.018}/>
   <SuctionCup name="v8-scrap-contact" position={[x,-.0465,z]} radius={.010} height={.017}/>
   <SocketBolt top position={[x,.0205,z]} radius={.004}/>
  </group>)}
  {[-1,1].flatMap(x=>[-1,1].map(z=><group key={`${x}:${z}`}>
   <B p={[x*.275,0,z*.21]} s={[.09,.024,.025]}/>
   {z<0&&<B name="v8-rear-guide-riser" p={[x*.32,.11,z*.21]} s={[.024,.22,.025]}/>}
   <B name="v8-scrap-guide-arm" p={[x*.32,z<0?.22:0,z*.345]} s={[.024,.024,.295]}/>
   <BoredHub p={[x*.32,z<0?.22:0,z*.48]} outer={.026} inner={.0145} height={.06}/>
  </group>))}
  <R p={[0,.026,0]} r={.032} l={.012}/>
 </group>
 if(v==='v8-vacuum-head'||v==='v8-balance-head')return <group><B name="v8-vacuum-head-plate" s={[.14,.035,.12]} c="#a3afb9"/><R p={[0,.028,0]} r={.026} l={.022}/>{<R name="v8-product-vacuum-port" p={[.036,.025,0]} r={.006} l={.024} axis="x"/>}{[-1,1].map(k=><group key={k}><R p={[k*.042,-.025,0]} r={.014} l={.015}/><SuctionCup name="v8-vacuum-contact" position={[k*.042,-.0425,0]} radius={.022} height={.02}/></group>)}</group>
 if(v==='v8-gantry-carriage')return <group>
  <B p={[0,.025,0]} s={[.18,.07,.14]} c="#4c6b7d"/>
  <R name="v8-product-lift-cylinder" p={[0,.20,0]} r={.028} l={.34}/>
  <group ref={rod}><R name="v8-product-lift-piston" p={[0,0,0]} r={.012} l={1}/></group>
  <group ref={a} name="v8-product-cantilever"><B name="v8-product-crosshead" p={[0,0,.19]} s={[.075,.028,.455]} c="#647f91"/>
  </group>
 </group>
 if(v==='v8-carousel-base')return <group><RotaryPedestal top={.70}/><group position={[.30,.38,0]} rotation={[0,Math.PI,0]}><Drive p={[0,0,0]} axis="x"/></group><R name="v8-carousel-drive-shaft" p={[.2325,.38,0]} r={.015} l={.065} axis="x"/><Stand x={-.98} w={.46} d={.38} top={.794}/><SlideRail x={-.60} y={1.07} z={-.18} w={1.0}/><B p={[-.98,.887,-.15]} s={[.06,.186,.06]}/><B name="v8-ejection-support-bridge" p={[-.6875,.784,0]} s={[.125,.02,.16]} c="#708d98"/><B name="carousel-sensor-floor-foot" p={[.72,.025,-.16]} s={[.14,.05,.14]} c="#35434e"/>
  <Profile p={[.72,.5,-.16]} length={.90} edge={.045}/>
  <B name="carousel-sensor-crossarm" p={[.72,.975,-.07]} s={[.045,.05,.225]} c="#7f8f9c"/>
  <B name="carousel-sensor-offset-arm" p={[.65,.975,0]} s={[.095,.04,.045]} c="#7f8f9c"/>
  <B name="carousel-pocket-sensor" p={[.58,.98,0]} s={[.05,.07,.08]} c="#2b323b"/>
  <B name="carousel-pocket-sensor-lens" p={[.553,.98,0]} s={[.004,.024,.024]} c="#381e24"/><LabelPlate text="POCKET ID" p={[0,.45,.205]} width={.28}/></group>
 if(v==='v8-carousel')return <group ref={a}><CarouselToolingRing/>{plant.machine.devices.some(d=>d.visualVariant==='easy15-base-06')&&<EasyIndexTableDetail/>}{[0,1,2,3].map(i=><group key={i} rotation={[0,-i*Math.PI/2,0]} position={[.52*Math.cos(i*Math.PI/2),.027,.52*Math.sin(i*Math.PI/2)]}><B s={[.16,.014,.15]} c="#405c6c"/>{[-1,1].map(k=><B key={k} p={[0,.027,k*.073]} s={[.15,.04,.015]} c="#8da3ac"/>)}<SocketBolt top position={[0,.008,.06]} radius={.003}/></group>)}</group>
 if(v==='v8-carousel-pusher'){
  return <group>
   <B name="v8-carousel-pusher-face" p={[-.13,.011,0]} s={[.08,.04,.05]} c="#35434e"/>
   <B name="carousel-pusher-neck" p={[-.13,.065,0]} s={[.035,.068,.035]} c="#a3afb9"/>
   <B name="carousel-pusher-offset-arm" p={[-.13,.118,-.04375]} s={[.035,.038,.1225]} c="#a3afb9"/>
   <B name="carousel-pusher-riser" p={[-.13,.19025,-.105]} s={[.035,.1065,.035]} c="#a3afb9"/>
   <B name="carousel-pusher-rail-carriage" p={[0,.2735,-.18]} s={[.30,.06,.18]} c="#7f8f9c"/>
  </group>
 }
 if(v==='v8-intercept-base')return <group>{!plant.machine.devices.some(d=>d.visualVariant==='v13-intercept-base')&&<Stand x={-.43} w={1.04} d={.78} top={.70}/>}<B name="v8-feed-support" p={[-.40,.76,0]} s={[1.02,.12,.16]}/><SlideRail x={-.405} y={.88} z={-.30} w={1.11}/>{[-.86,.04].map(x=><B key={x} name="v8-intercept-rail-support" p={[x,.745,-.30]} s={[.08,.09,.08]}/>)}<group position={[.90,0,0]}><RotaryPedestal top={.638}/></group><R name="rotary-table-deck" p={[.90,.6525,0]} r={.72} l={.045}/><BoredHub p={[.90,.6925,0]} outer={.70} inner={.60} height={.035} matte/><group position={[1.17,.30,0]} rotation={[0,Math.PI,0]}><Drive p={[0,0,0]} axis="x"/></group><R p={[1.1175,.30,0]} r={.015} l={.035} axis="x"/>{!plant.machine.devices.some(d=>d.visualVariant==='v13-intercept-base')&&<LabelPlate text="MOVING RECEIVER" p={[-.4,.74,.302]} width={.48}/>}</group>
 if(v==='v8-moving-pocket')return <group>{plant.machine.devices.some(d=>d.visualVariant==='v13-intercept-base')&&<InterceptPocketDetail/>}<B name="v8-moving-pocket-deck" s={[.24,.08,.22]} c="#5b807c"/>{[-1,1].map(k=><B key={k} name="v8-pocket-side" p={[.04,.065,k*.095]} s={[.16,.05,.03]} c="#9eafb7"/>)}{[-1,1].map(k=><mesh key={k} name="v8-pocket-track-ball" position={[0,-.055,k*.035]}><sphereGeometry args={[.015,16,12]}/><meshStandardMaterial color="#7f929d" metalness={.7} roughness={.4}/></mesh>)}</group>
 if(v==='v8-netflow-base')return <group><B name="v8-conveyor-motor-mount" p={[0,.60625,-.20]} s={[.12,.0275,.10]}/><Stand w={3.8} d={.68} top={.68}/><DeckRollers w={3.6} top={.79} d={.28}/>{[0,.12].map(x=><group key={x}><B p={[x,.72,.31]} s={[.06,.04,.08]} c="#4b6b7e"/><B p={[x,.76,.33]} s={[.025,.08,.04]}/></group>)}<LabelPlate text="A   B  /  NET TRANSFER" p={[0,.648,.342]} width={.60}/></group>
 if(v==='v8-routing-drive')return <group>
  <B name="v8-routing-controller" p={[device.id==='DRIVE_A'?-.05:.05,-.08,.42]} s={[.16,.12,.08]} c="#486779"/>
  <B name="v6-drive-terminal" p={[device.id==='DRIVE_A'?-.05:.05,-.08,.468]} s={[.045,.04,.016]} c="#263d4b"/>
  <B p={[device.id==='DRIVE_A'?-.05:.05,-.08,.36]} s={[.10,.08,.04]}/>
 </group>
 if(v==='v8-conveyor-drive')return <group><Drive p={[0,0,0]} axis="z"/><group ref={a}><R p={[0,0,.07]} r={.054} l={.02} axis="z" c="#597b87"/><B p={[0,0,.083]} s={[.065,.007,.003]} c="#d2dadd"/></group></group>
 if(v==='v8-edgeguide-base')return <group><Stand w={2.25} d={.85} top={.68}/>{[-.8,.78].map(x=><group key={x}><R p={[x,.760,0]} r={.04} l={.33} axis="z"/>{[-.22,.22].map(z=><group key={z}><B p={[x,.74,z]} s={[.10,.12,.08]} c="#4a6d80"/><SocketBolt top position={[x,.801,z]} radius={.004}/></group>)}</group>)}<EdgeStage/><EdgeSensor x={.44}/><LabelPlate text="EDGE GUIDANCE" p={[0,.65,.427]} width={.46}/></group>
 if(v==='v8-steering-roll')return <group><R p={[0,0,0]} r={.05} l={.32} axis="z"/>{[-.20,.20].map(z=><group key={z}><B p={[0,-.005,z]} s={[.12,.11,.075]} c="#507286"/><R p={[0,0,z]} r={.026} l={.082} c="#bdc7cc"/><R p={[0,0,z*1.22]} r={.014} l={.012} c="#466371"/><SocketBolt top position={[.038,.051,z]} radius={.003}/></group>)}<EdgeMovingSaddle/></group>
 if(v==='v8-edge-web')return <EdgeWeb device={device} plant={plant} length={1.92}/>
 if(v==='v8-receiver-nip')return <group>
  <R name="v8-nip-lower-roll" p={[0,-.027,0]} r={.027} l={.26} axis="z"/>
  <group ref={a}><R name="v8-nip-upper-roll" p={[0,0,0]} r={.027} l={.26} axis="z" c="#394e59"/>{[-1,1].map(k=><group key={k}><R p={[0,0,k*.15]} r={.009} l={.05} axis="z"/><B name="v8-nip-moving-bearing" p={[0,0,k*.18]} s={[.045,.045,.045]} c="#526b79"/></group>)}</group>
  {[-1,1].map(k=><group key={k}><B name="v8-nip-mount-foot" p={[0,-.105,k*.18]} s={[.13,.03,.10]}/><B name="v8-nip-upright" p={[.036,.05,k*.18]} s={[.025,.28,.055]} c="#7f9aaa"/><R name="v8-nip-lower-axle" p={[0,-.027,k*.15]} r={.009} l={.05} axis="z"/><B p={[0,-.027,k*.18]} s={[.055,.045,.055]}/></group>)}
 </group>
 if(v==='v8-lineidentity-base')return <group><Stand w={2.25} d={1.25} top={.76}/><B p={[-.42,.87,0]} s={[.20,.22,.20]} c="#506f83"/><Drive p={[-.42,.87,-.23]} axis="z"/><R p={[-.42,.87,-.1475]} r={.015} l={.095} axis="z"/><B name="v8-valve-support-post" p={[.205,.8705,0]} s={[.065,.221,.08]} c="#6b8798"/><group position={[.205,1.06,0]} rotation={[0,0,Math.PI/2]}><BoredHub p={[0,0,0]} outer={.079} inner={.0655} height={.022}/></group><Hose purpose="functional" points={[[-.675,.92,0],[-.61,.98,.22],[-.42,.98,.10]]} radius={.012}/><Hose purpose="functional" points={[[.15,1.06,.11],[.18,1.25,.28],[.40,1.30,.4],[.40,1.18,.4]]} radius={.012}/><Hose purpose="functional" points={[[.26,1.06,0],[.50,1.31,-.16],[.85,1.31,-.2],[.85,1.18,-.2]]} radius={.012}/><LabelPlate text="LINE ID / DIVERT" p={[0,.73,.627]} width={.50}/></group>
 if(v==='v8-liquid-level')return <FluidJar level={a}/>
 if(v==='v8-content-line')return <group><R p={[-.155,1.06,0]} r={.018} l={.49} axis="x" c="#7a9d9b"/><group ref={a} position={[-.40,1.06,0]}><R p={[.245,0,0]} r={.0185} l={.49} axis="x" c="#ba8755"/></group><R p={[-.40,1.02,0]} r={.018} l={.08}/></group>
 if(v==='v8-diverter-valve')return <group><R p={[0,0,0]} r={.065} l={.18} axis="x"/><R p={[0,0,.08]} r={.032} l={.10} axis="z"/><R p={[0,.075,0]} r={.029} l={.075}/><group ref={a}><B p={[0,.12,0]} s={[.19,.018,.035]} c="#b0805a"/></group></group>
 if(v==='v8-pair-transfer')return <group>
  <B name="pair-contact-guide-crosshead" p={[0,.004,0]} s={[.186,.024,.05]} c="#4c7289"/>
  {[-1,1].map(k=><group key={k}><B name="pair-side-contact-guide" p={[k*.0815,-.054,0]} s={[.018,.078,.181]} c="#8da3ae"/><B name="pair-end-contact-guide" p={[0,-.054,k*.0815]} s={[.145,.078,.018]} c="#8da3ae"/></group>)}
 </group>
 if(v==='v8-pairjoin-base'||v==='v8-pairjoin-base-v2')return <group><Stand z={-.30} w={2.05} d={1.55} top={.72}/>{[-1,1].map(side=><group key={side}>
  <B p={[side*.75,.7205,-.7]} s={[.18,.001,.70]} c="#405d6f"/><B p={[side*.45,.7205,-.7]} s={[.17,.001,.68]} c="#658382"/><B p={[side*.2,.7205,.25]} s={[.20,.001,.21]} c="#658382"/>
  {Array.from({length:v==='v8-pairjoin-base-v2'?12:5},(_,i)=>Array.from({length:v==='v8-pairjoin-base-v2'?23:9},(_,j)=><mesh key={`${i}:${j}`} name="v8-omnidirectional-support-ball" position={[side*(v==='v8-pairjoin-base-v2'?.14+i*.06:.20+i*.14),v==='v8-pairjoin-base-v2'?.736:.732,v==='v8-pairjoin-base-v2'?-.98+j*.06:-.90+j*.14]} castShadow><sphereGeometry args={[v==='v8-pairjoin-base-v2'?.014:.018,12,8]}/><meshStandardMaterial color="#a8b8c0" metalness={.75} roughness={.4}/></mesh>))}
  <B p={[side*.62,.56,-.45]} s={[.50,.20,.62]} c="#4b6c7e"/>
  {v==='v8-pairjoin-base-v2'?<><PairTransferBridge plant={plant} side={side}/><B name="pair-side-reader-post" p={[side*.92,.80,-.7]} s={[.025,.16,.04]}/><B name="pair-side-id-reader" p={[side*.89,.862,-.7]} s={[.055,.04,.065]} c="#2e4859"/></>:<><B p={[side*.91,.83,-.7]} s={[.04,.22,.04]}/><B p={[side*.83,.95,-.7]} s={[.20,.04,.055]} c="#5e7c8d"/><B p={[side*.75,.917,-.7]} s={[.08,.025,.05]} c="#2e4859"/></>}
 </group>)}<LabelPlate text="KEY A = KEY B" p={[0,.691,.477]} width={.46}/><B p={[0,.81,-1.0]} s={[.35,.18,.10]} c="#46697e"/></group>
 if(v==='v8-balance-base')return <group><Stand w={2.50} d={1.20} top={.60}/><B p={[-.8,.675,0]} s={[.26,.15,1.05]} c="#5e7886"/><Gantry w={2.05} z={-.53} y={1.5} bottom={.60}/><group ref={a}><B p={[0,0,0]} s={[.14,.08,1.10]} c="#668698"/></group><group ref={b}><B s={[.16,.065,.12]} c="#42667f"/><R p={[0,.22,0]} r={.028} l={.43}/></group><group ref={rod}><R name="v8-balance-lift-rod" p={[0,0,0]} r={.012} l={1}/></group><SlideRail x={.62} y={.705} z={.38} w={1.45}/><LabelPlate text="MASS BALANCE" p={[0,.66,.602]} width={.46}/></group>
 if(v==='v8-balance-tray')return <group><B name="v8-balance-tray-deck" s={[.65,.05,.60]} c="#5d827f"/>{[-1,1].map(k=><group key={k}><B p={[k*.18,-.044,0]} s={[.09,.038,.38]} c="#465b6c"/><R p={[k*.18,-.076,0]} r={.021} l={.025}/></group>)}<B p={[0,-.07,.36]} s={[.55,.06,.10]} c="#547489"/><B p={[0,-.10,0]} s={[.55,.024,.50]} c="#506c7e"/><B p={[0,-.09,.28]} s={[.12,.04,.12]} c="#506c7e"/></group>
 if(v==='v8-bridge-base')return <group><Stand x={-.675} w={.85} d={.65} top={.79}/><Stand x={.675} w={.85} d={.65} top={.79}/><B p={[0,.08,0]} s={[.44,.06,.40]} c="#4c6e85"/><R p={[0,.28,0]} r={.054} l={.36}/>{[-.16,.16].map(x=><R key={x} p={[x,.28,0]} r={.024} l={.36}/>)}<SlideRail x={-.42} y={.89} z={-.31} w={1.65}/>{[-.95,.3].map(x=><B key={x} p={[x,.795,-.30]} s={[.10,.01,.10]}/>)}<LabelPlate text="SPAN SUPPORT" p={[-.675,.755,.327]} width={.40}/></group>
 if(v==='v8-support-bridge')return <group><B name="v8-moving-bridge-support" s={[.50,.06,.40]} c="#638681"/><R p={[0,-.22,0]} r={.024} l={.38}/>{[-.16,.16].map(x=><R key={x} p={[x,-.22,0]} r={.012} l={.38}/>)}</group>
 if(v==='v8-board-pusher')return <group>
  <B name="v8-board-contact" s={[.04,.03,.24]} c="#365565"/>
  <B name="board-pusher-offset-arm" p={[0,.035,-.13]} s={[.04,.04,.26]}/>
  <B name="board-pusher-front-riser" p={[0,.08125,-.24]} s={[.04,.0525,.04]}/>
  <B name="board-pusher-rail-carriage" p={[0,.1275,-.31]} s={[.11,.04,.18]} c="#6f8c9d"/>
 </group>
 if(v==='v13-intercept-base')return <group>
  <InterceptBaseDetail/>
  <MaterialAdvancedHardware device={{...device,visualVariant:'v8-intercept-base'}} plant={plant}/>
  <B name="v13-source-nest" p={[-.65,.79,.445]} s={[.19,.06,.73]} c="#64818c"/>
  {[-.755,-.545].map(x=><B key={x} p={[x,.844,.47]} s={[.02,.048,.60]} c="#a5b4bc"/>)}
  <B name="v13-reserve-stop" p={[-.65,.853,.825]} s={[.19,.066,.025]} c="#344f60"/>
  <InterceptWorkbench/>
  <B name="v13-feed-axis-housing" p={[-.91,.89,.40]} s={[.075,.07,1.0]} c="#547488"/>
  <R name="v13-feed-guide" p={[-.91,.95,.40]} r={.01} l={.94} axis="z"/>
  {[-.06,.86].map(z=><group key={z}>
   <B p={[-.91,.928,z]} s={[.042,.006,.026]}/>
   <group position={[-.91,.95,z]} rotation={[Math.PI/2,0,0]}><BoredHub p={[0,0,0]} outer={.019} inner={.0101} height={.026}/></group>
  </group>)}
  {/* Supports end at the housing underside (.855). The former .905 top
      buried 50 mm of each leg in the bar, with coincident side faces. */}
  {[.10,.74].map(z=><B key={z} name="v13-feed-axis-support" p={[-.91,.7775,z]} s={[.075,.155,.075]}/>)}
 </group>
 if(v==='v13-source-feeder')return <group>
  <B name="v13-feeder-contact" s={[.15,.06,.03]} c="#435d6a"/>
  <B p={[-.06,.0575,0]} s={[.03,.055,.03]}/>
  <B name="v13-feeder-crosshead" p={[-.152,.0925,0]} s={[.184,.025,.055]}/>
  <group name="v13-feeder-bored-linear-bearing" position={[-.26,.09,0]} rotation={[Math.PI/2,0,0]}><BoredHub p={[0,0,0]} outer={.019} inner={.0105} height={.08}/></group>
  <SocketBolt top position={[-.12,.106,0]} radius={.003}/>
 </group>
 // Hide repeated per-workpiece belt holders/stops; recorded holding state is unchanged.
 if(v==='v13-slot-clamp-v17'||v==='v13-slot-stop-v17')return null
 if(v==='v13-belt-drive-v17')return <StandardBeltDrive/>
 if(v==='v13-netbatch-base'||v==='v13-netbatch-base-v17')return <group>
  <Stand x={-.655} w={2.51} d={.68} top={.68}/>
  {v.endsWith('v17')?<group position={[-.655,0,0]}><StandardBeltDeck length={2.41} width={.28} top={.79} plant={plant} stateId={device.id}/>{[-1,1].flatMap(a=>[-1,1].map(b=><B key={`${a}:${b}`} name="belt-chassis-stand-joint" p={[a*.90,.700,b*.154]} s={[.08,.042,.055]}/>))}</group>:<DeckRollers x={-.655} w={2.41} top={.79} d={.28}/>}
  {!v.endsWith('v17')&&<B name="v13-conveyor-drive-bracket" p={[0,.60625,-.20]} s={[.12,.0275,.10]}/>}
  {[0,.12].map(x=><group key={x}><B p={[x,.72,.31]} s={[.06,.04,.08]} c="#4b6b7e"/><B p={[x,.76,.33]} s={[.025,.08,.04]}/></group>)}
  <Stand x={1.14} z={.325} w={1.35} d={1.08} top={.62}/>
  {[.75,1.53].map(x=><group key={x}><B name="v13-tray-transverse-guide" p={[x,.654,.325]} s={[.045,.034,.88]} c="#b0bec6"/>{[-.10,.75].map(z=><SocketBolt key={z} top position={[x,.672,z]} radius={.004}/>)}</group>)}
  <B name="v13-dispatch-drive" p={[1.14,.653,.84]} s={[.14,.065,.22]} c="#526f80"/>
  <R name="v13-dispatch-lead-screw" p={[1.14,.665,.29]} r={.009} l={.88} axis="z" c="#afbcc4"/>
  <LabelPlate text="NET COUNT / BATCH HANDOFF" p={[-.30,.648,.342]} width={.66}/>
 </group>
 if(v==='v13-batch-tray'||v==='v13-batch-tray-v17')return <group>
  {v.endsWith('v17')?<StandardBeltDeck length={1.10} width={.28} top={.05} plant={plant} stateId={device.id} drive/>:<DeckRollers w={1.10} top={.05} d={.28}/>}
  <B name="v13-tray-underframe" p={[0,-.032,0]} s={[1.10,.028,.30]} c="#587c7e"/>
  {[-.39,.39].map(x=><group key={x}>
   <B name="v13-tray-slide-cap" p={[x,-.0575,0]} s={[.09,.023,.14]} c="#496573"/>
   {[-1,1].map(k=><B name="v13-tray-slide-cheek" key={k} p={[x+k*.0325,-.083,0]} s={[.020,.028,.14]} c="#496573"/>)}
  </group>)}
  <group position={[0,-.075,0]} rotation={[Math.PI/2,0,0]}><BoredHub p={[0,0,0]} outer={.022} inner={.010} height={.065}/></group>
  <B name="v13-tray-nut-bracket" p={[0,-.048,0]} s={[.05,.012,.08]} c="#7d949e"/>
  <B name="v13-tray-end-stop" p={[.559,.058,0]} s={[.018,.06,.30]} c="#a3b5bb"/>
 </group>
 return null
}

export function MaterialCan({id,plant}:{id:number;plant:DeviceProps['plant']}){
 const ref=useRef<THREE.Group>(null)
 useFrame(()=>{const p=plant.parts.find(q=>q.id===id);if(ref.current&&p){ref.current.position.set(p.x,p.y??0,p.z??0);ref.current.visible=p.visible!==false}})
 return <group ref={ref} name={`v8-cylindrical-item-${id}`}><R p={[0,0,0]} r={.05} l={.104} c="#c6d0d2"/><R p={[0,.053,0]} r={.048} l={.004} c="#637e8b"/><R p={[0,.055,0]} r={.017} l={.002} c="#d5b06b"/><LabelPlate text={String(id)} p={[0,0,.0505]} width={.055}/></group>
}
