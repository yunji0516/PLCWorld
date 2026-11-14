'use client'

import { useFrame } from '@react-three/fiber'
import { useRef } from 'react'
import type { Group } from 'three'
import type { DeviceProps } from '../devices'
import { Part, RoundPart } from './Parts'
import { Profile, Rail, Drive, LabelPlate, BoredHub } from './MaterialV6Details'
import { SocketBolt } from '../IndustrialDetails'
type V3=[number,number,number]
const B=({p,s,c='#91a1aa',name}:{p:V3;s:V3;c?:string;name?:string})=><Part name={name} position={p} size={s} color={c}/>
const R=({p,r,l,axis='z',c='#aab7be'}:{p:V3;r:number;l:number;axis?:'x'|'y'|'z';c?:string})=><RoundPart position={p} radius={r} length={l} axis={axis} color={c}/>

/** Secondary frame members stay below the process deck and between the legs. */
export function MaterialFrameDetails({x=0,z=0,w,d,top,legInset=.09,legEdge=.065,deckThickness=.06,supportColor,lowerTies=true}:{x?:number;z?:number;w:number;d:number;top:number;legInset?:number;legEdge?:number;deckThickness?:number;supportColor?:string;lowerTies?:boolean}){
 const railLength=Math.max(.01,w-2*legInset-legEdge),cleatWidth=Math.min(.07,railLength/4)
 return <group name="material-bolted-frame-details">
  {[-1,1].map(side=><group key={side}>
   <group name="material-folded-deck-apron">
    <B p={[x,top-deckThickness-.003,z+side*(d/2-.028)]} s={[w-.04,.006,.026]} c="#aab8c0"/>
    <B p={[x,top-deckThickness-.050,z+side*(d/2-.018)]} s={[w-.04,.088,.006]} c="#96a9b4"/>
    {[-1,1].map(k=><group key={k} position={[x+k*(w/2-.07),top-deckThickness-.029,z+side*(d/2-.0138)]} rotation={[0,side<0?Math.PI:0,0]}><SocketBolt position={[0,0,0]} radius={.004}/></group>)}
   </group>
   <B p={[x,top-.10,z+side*(d/2-legInset)]} s={[railLength-2*cleatWidth,.065,.032]} c={supportColor??'#35434e'}/>
   {lowerTies&&<B name="bench-stretcher" p={[x,.25,z+side*(d/2-legInset)]} s={[w-2*legInset-legEdge,.035,.028]} c={supportColor??'#35434e'}/>}
   {[-1,1].map(k=><B key={k} p={[x+k*(w/2-legInset-legEdge/2-cleatWidth/2),top-.15,z+side*(d/2-legInset)]} s={[cleatWidth,.10,.035]} c="#c2cbd0"/>)}
  </group>)}
 </group>
}

/** Fine transverse stage: fixed guides and spindle, bearing blocks travel with STEER. */
export function EdgeStage(){
 return <group name="edge-guide-fixed-stage">
  {[-.09,.09].map(x=><group key={x} position={[x,.696,0]} rotation={[0,Math.PI/2,0]}><Rail p={[0,0,0]} length={.58}/></group>)}
  <R p={[.145,.719,0]} r={.006} l={.62}/>
  {[-.31,.31].map(z=><B key={z} p={[.145,.711,z]} s={[.038,.054,.025]} c="#536c7a"/>)}
  <B name="edge-motor-cantilever-bracket" p={[.145,.686,.30]} s={[.075,.012,.23]} c="#849ca8"/>
  <B p={[.145,.700,.385]} s={[.075,.016,.12]} c="#667f8b"/>
  <R p={[.145,.726,.397]} r={.025} l={.09} c="#415b68"/>
  <R p={[.145,.719,.342]} r={.011} l={.024}/>
  <B p={[.145,.753,.415]} s={[.026,.015,.024]} c="#263b46"/>
 </group>
}
export function EdgeMovingSaddle(){
 return <group name="edge-guide-moving-saddle">
  {[-.09,.09].map(x=><group key={x}>
   <B p={[x,-.016,0]} s={[.038,.014,.49]} c="#7895a3"/>
   {[-.20,.20].map(z=><group key={z}><B p={[x>0?.0625:-.0625,-.015,z]} s={[.017,.016,.065]}/><SocketBolt top position={[x,-.008,z]} radius={.003}/></group>)}
  </group>)}
  <group name="edge-spindle-nut" position={[.145,-.031,0]} rotation={[Math.PI/2,0,0]}><BoredHub p={[0,0,0]} outer={.014} inner={.0065} height={.04}/></group>
  <B p={[.119,-.016,0]} s={[.058,.014,.035]}/>
 </group>
}
export function EdgeSensor({x}:{x:number}){
 return <group name="edge-optical-fork-sensor">
  <B p={[x,.742,.16]} s={[.045,.124,.035]} c="#8fa3ad"/>
  <B p={[x,.782,.111]} s={[.055,.015,.13]} c="#334d5a"/>
  <B p={[x,.829,.111]} s={[.055,.015,.13]} c="#334d5a"/>
  <B p={[x,.805,.167]} s={[.055,.06,.018]} c="#334d5a"/>
  <R p={[x,.819,.080]} r={.006} l={.004} axis="y" c="#9b6d40"/>
  <R p={[x,.791,.080]} r={.006} l={.004} axis="y" c="#9b6d40"/>
  <LabelPlate text="EDGE" p={[x,.807,.177]} width={.046}/>
 </group>
}
export function EdgeWeb({device,plant,length}:{length:number}&DeviceProps){
 const g=useRef<Group>(null)
 useFrame(()=>{if(g.current)g.current.position.z=plant.state(device.id).pos})
 return <group ref={g} name="edge-material-with-visible-edges">
  <B name="edge-material-center" p={[0,0,0]} s={[length,.003,.152]} c="#c8a168"/>
  {[-1,1].map(k=><B key={k} name="edge-material-border" p={[0,0,k*.078]} s={[length,.003,.004]} c="#755630"/>)}
 </group>
}

/** XY module follows recorded router coordinates; no free moving pusher or wall-clock animation. */
export function RoutingActuator({plant}:Pick<DeviceProps,'plant'>){
 const bridge=useRef<Group>(null),saddle=useRef<Group>(null)
 useFrame(()=>{const p=plant.machine.devices.find(d=>d.id==='ROUTER')?.pos;if(!p)return;bridge.current?.position.set(p[0],0,0);saddle.current?.position.set(p[0],0,p[2])})
 return <group name="easy13-xy-pusher-drive">
  {[-.99,.02].flatMap(x=>[-.65,.46].map(z=><group key={`${x}:${z}`}>
   <Profile p={[x,.92,z]} length={.46} edge={.04}/>
   <B p={[x,.704,z]} s={[.085,.028,.075]}/>
   {[-.025,.025].map(dx=><SocketBolt key={dx} top position={[x+dx,.719,z]} radius={.003}/>)}
  </group>))}
  {[-.65,.46].map(z=><group key={z}>
   <B p={[-.485,1.17,z]} s={[1.09,.06,.06]} c="#527382"/>
   <Rail p={[-.485,1.216,z]} length={1.08}/>
  </group>)}
  <group position={[.11,1.216,-.65]} rotation={[0,Math.PI,0]}><Drive p={[0,0,0]}/></group>
  <group ref={bridge} name="easy13-moving-y-bridge">
   {[-.65,.46].map(z=><group key={z}><B p={[0,1.252,z]} s={[.09,.022,.09]} c="#6b8d9c"/>{[-1,1].map(k=><B key={k} name="easy13-x-guide-bearing-cheek" p={[0,1.226,z+k*.027]} s={[.09,.030,.011]} c="#708b9c"/>)}</group>)}
   <B p={[0,1.285,-.095]} s={[.07,.045,1.20]} c="#6b8d9c"/>
   <group position={[0,1.322,-.095]} rotation={[0,Math.PI/2,0]}><Rail p={[0,0,0]} length={1.18}/></group>
   <R p={[.047,1.315,-.095]} r={.006} l={1.17}/>
   <R p={[.047,1.315,.56]} r={.025} l={.10} c="#405c6a"/>
   <B p={[.047,1.289,.515]} s={[.075,.012,.055]}/>
  </group>
  <group ref={saddle} name="easy13-moving-xz-saddle">
   <B p={[0,1.363,0]} s={[.075,.020,.09]} c="#52788c"/>
   {[-1,1].map(k=><B key={k} name="easy13-z-guide-bearing-cheek" p={[k*.027,1.338,0]} s={[.011,.030,.09]} c="#708b9c"/>)}
   <B p={[-.04,1.365,-.04]} s={[.105,.020,.12]}/>
   <B name="easy13-pusher-vertical-link" p={[-.08,1.0925,-.08]} s={[.025,.525,.025]} c="#9baeb9"/>
   <B p={[-.08,.8475,-.08]} s={[.047,.035,.047]} c="#4c6c7b"/>
   <SocketBolt top position={[0,1.375,0]} radius={.004}/>
  </group>
 </group>
}

export function LoadReceivingStation({side}:{side:number}){
 return <group name={side<0?'easy14-left-weigh-module':'easy14-right-weigh-module'}>
  <B p={[0,.593,-.10]} s={[.40,.026,.52]} c="#697f8c"/>
  {[-.145,.145].flatMap(x=>[-.28,.10].map(z=><group key={`${x}:${z}`}>
   <B name="easy14-strain-loadcell" p={[x,.62,z]} s={[.075,.028,.052]} c="#bac5cb"/>
   <SocketBolt top position={[x,.648,z]} radius={.003}/>
  </group>))}
  <B p={[0,.64075,-.10]} s={[.35,.0135,.48]} c="#8398a2"/>
  <B p={[0,.725,-.26]} s={[.38,.05,.18]} c={side<0?'#638b82':'#617e96'}/>
  {[-.145,.145].map(x=><B key={x} p={[x,.67375,-.26]} s={[.04,.0525,.12]}/>)}
  {[-.18,.18].map(x=><B key={x} p={[x,.766,-.26]} s={[.008,.032,.16]} c="#b0bdc3"/>)}
  <LabelPlate text={side<0?'LEFT / 2 SLOTS':'RIGHT / 2 SLOTS'} p={[0,.624,.166]} width={.32}/>
 </group>
}
