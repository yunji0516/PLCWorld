'use client'
import {MaterialTableLegs} from './MaterialTableLegs'

import { MaterialEasyFocusHardware } from './MaterialEasyFocusHardware'
import { DeckRollers } from './MaterialAdvancedHardware'
import { MaterialFrameDetails, RoutingActuator, LoadReceivingStation } from './MaterialClarityHardware'
import type { DeviceProps } from '../devices'
import { Part, RoundPart } from './Parts'
import { Foot, Profile, Rail, LinearGuideBed, Drive, Hose, BoredHub } from './MaterialV6Details'
import { SocketBolt } from '../IndustrialDetails'
import { EasyIndexBaseDetail, RotaryPedestal } from './MaterialIndexDetail'
import {useMaterialPresentation,MATERIAL_WORKBENCH_BRIGHTNESS} from './MaterialPresentation'

type V3 = [number,number,number]
const B=({p=[0,0,0],s,c='#8fa5b1',name}:{p?:V3;s:V3;c?:string;name?:string})=><Part name={name} position={p} size={s} color={c}/>
function Bench({x=0,z=0,w=1.2,d=.8,top=.72}:{x?:number;z?:number;w?:number;d?:number;top?:number}){
 const refined=useMaterialPresentation()
 return <group name="easy15-fixed-bench"><MaterialFrameDetails lowerTies={false} x={x} z={z} w={w} d={d} top={top} legInset={.08} legEdge={.06} supportColor={refined?'#35434e':undefined}/><Part name="easy-workbench-top" position={[x,top-.03,z]} size={[w,.06,d]} color={refined?'#a3afb9':'#8fa5b1'} brightness={refined?MATERIAL_WORKBENCH_BRIGHTNESS:1} matte={refined}/>
  <MaterialTableLegs x={x} z={z} halfX={w/2-.08} halfZ={d/2-.08} top={top-.06}/></group>
}

/** Local fixtures only. Medium hardware components and geometry are unchanged. */
export function MaterialEasy15Hardware({device,plant}:DeviceProps){
 const refined=useMaterialPresentation()
 if(['easy15-contact-head','easy15-release-head','easy15-source-bottle','easy15-recovery-bottle','easy15-dose-source','easy15-dose-liquid','easy15-local-buffer','easy15-feed-drive','easy15-local-web','easy15-visible-line'].includes(device.visualVariant??''))return <MaterialEasyFocusHardware device={device} plant={plant}/>
 if(device.visualVariant==='easy15-left-weigh'||device.visualVariant==='easy15-right-weigh')return <LoadReceivingStation side={device.visualVariant==='easy15-left-weigh'?-1:1}/>
 if(device.visualVariant==='easy15-feed-roll')return <group name="easy15-pass-through-rolls">
  {[-1,1].map(k=><RoundPart key={k} position={[0,k*.034,0]} radius={.032} length={.17} axis="z" color="#617f8e"/>)}
  {[-1,1].map(k=><B key={k} p={[0,-.027,k*.12]} s={[.07,.15,.055]} c="#446778"/>)}
 </group>
 if(device.visualVariant==='easy15-routing-corner')return <group name="easy15-routing-contact">
  <B p={[-.08,0,0]} s={[.02,.08,.14]} c="#54798e"/>
  <B p={[0,0,-.08]} s={[.18,.08,.02]} c="#54798e"/>
 </group>
 if(device.visualVariant==='easy15-fixed-nozzle')return <group>
  <RoundPart position={[0,0,0]} radius={.019} length={.50} axis="y"/>
  <B p={[.085,.06,0]} s={[.17,.035,.07]} c="#53758a"/>
 </group>
 if(device.visualVariant==='easy15-inline-coupler')return <group>
  <RoundPart position={[0,0,0]} radius={.028} length={.18} axis="x"/>
  <RoundPart position={[0,0,.06]} radius={.020} length={.12} axis="z"/>
 </group>
 const n=Number(device.visualVariant?.slice(-2))
 if([8,9,10,11,12].includes(n))return <MaterialEasyFocusHardware device={device} plant={plant}/>
 if(n===1)return <group name="easy15-acquire-fixture">
  <Bench x={-.6} w={1.1} d={.9} top={.74}/>
  <Profile p={[-.6,.865,-.27]} length={.25} edge={.06}/>
  <B p={[-.6,.9525,refined?-.191:-.185]} s={[.18,.04,refined?.158:.17]} c="#52788d"/>
  {refined&&<group name="easy-gripper-support-detail">
   {[-1,1].map(s=><group key={s}>
    <Part name="head-mount-cheek" position={[-.6+s*.067,.906,-.252]} size={[.012,.053,.06]} color="#a3afb9"/>
    <SocketBolt top position={[-.6+s*.060,.9735,-.19]} radius={.004}/>
   </group>)}
  </group>}
 </group>
 if(n===2)return <group name="easy15-place-fixture">
  <Bench w={.95} d={.72}/>
  <Profile p={[0,.82,-.24]} length={.20} edge={.06}/>
  <B p={[0,.88,-.17]} s={[.18,.04,.14]} c="#52788d"/>
 </group>
 if(n===3)return <group name="easy15-selective-release-station">
  <Bench x={.75} w={.70} d={1.18} top={.68}/>
  {[-1,0,1].map(k=><group key={k}><B p={[.75,.70,k*.34]} s={[.28,.04,.27]} c="#486d78"/>{[-1,1].map(z=><B key={z} p={[.75,.732,k*.34+z*.141]} s={[.28,.024,.012]}/>)}</group>)}
  {[.45,1.05].map(x=><Profile key={x} p={[x,.91,-.53]} length={.46} edge={.045}/>)}
  <B p={[.75,1.13,-.22]} s={[.68,.05,.66]} c="#557c90"/>
  <B p={[.75,1.065,0]} s={[.06,.08,.08]}/>
 </group>
 if(n===4)return <group name="easy15-docked-handoff-station">
  <Bench x={.65} w={.85} d={.72} top={.72}/>
  <B p={[.65,.73375,0]} s={[.25,.0275,.30]} c="#567780"/>
  <Profile p={[.65,.92,-.30]} length={.40}/>
  <B p={[.65,1.13,-.175]} s={[.22,.045,.30]}/>
  <B p={[.65,1.095,-.03]} s={[.12,.025,.10]}/>
 </group>
 if(n===6)return <group name="easy15-fixed-pocket-eject-station">
  <EasyIndexBaseDetail/>
  <RotaryPedestal top={.70}/>
  <Bench x={-.98} w={.46} d={.38} top={.794}/>
  <B p={[-.6875,.784,0]} s={[.125,.02,.16]} c="#708d98"/>
  <LinearGuideBed p={[-.60,1.07,-.18]} length={1.0}/>
  <Profile p={[-.98,.887,-.18]} length={.186} edge={.04}/>
 </group>
 if(n===7)return <group name="easy15-continuous-supported-transfer">
  <Bench w={2.35} d={.68} top={.79}/>
  <LinearGuideBed p={[-.42,.89,-.31]} length={1.65}/>
  {[-1.12,.35].map(x=><B key={x} name="easy-guide-bed-foot" p={[x,.795,-.31]} s={[.06,.01,.065]} c="#7f8f9c"/>)}
 </group>
 if(n===14)return <group name="easy15-supported-load-routing">
  <Bench w={1.65} d={.90} top={.58}/>
  <DeckRollers w={.656} top={.75} d={.18}/>
  {[-1,1].map(side=><DeckRollers key={side} x={side*.54} w={.416} top={.75} d={.18}/>)}
  <B p={[0,.61875,.28]} s={[.16,.0775,.12]}/>
  {[-.24,.24].flatMap(x=>[-.117,.117].map(z=><B key={`${x}:${z}`} p={[x,.61375,z]} s={[.045,.0675,.04]} c="#738c99"/>))}
 </group>
 if(n===5)return <group name="easy15-datum-fixture">
  <Bench x={-.65} w={1.15} d={.85}/>
  <B p={[-.963,.75,0]} s={[.025,.06,.38]} c="#364f61"/>
  <B p={[-.75,.75,-.159]} s={[.40,.06,.018]} c="#364f61"/>
  <B p={[-.33,.75,0]} s={[.18,.055,.10]} c="#456879"/>
  <B p={[-.75,.75,.355]} s={[.10,.055,.18]} c="#456879"/>
  <Hose points={[[-.26,.755,.05],[-.23,.78,.24],[-.40,.79,.43],[-.70,.78,.44]]} radius={.004} color="#3f515d"/>
 </group>
 if(n===13)return <group name="easy15-single-routing-fixture">
  <Bench x={-.48} z={-.1} w={1.28} d={1.2} top={.69}/>
  <B name="easy15-continuous-routing-bed" p={[-.5,.72,-.1]} s={[.95,.06,1.0]} c="#59788c"/>
  <B p={[-.20,.76,.415]} s={[.28,.02,.025]} c="#56817a"/>
  <B p={[-.45,.76,-.615]} s={[.25,.02,.025]} c="#8b7b5c"/>
  <RoutingActuator plant={plant}/>
 </group>
 if(n===15)return <group name="easy15-opening-fixture">
  <Bench x={.10} w={1.1} d={.95} top={.69}/>
  <B name="pouch-bottom-support-deck" p={[.25,.7725,0]} s={[.68,.015,.26]} c="#7f8f9c"/>
  {[-.10,.10].map(z=><B key={z} name="pouch-deck-support" p={[.54,.7275,z]} s={[.04,.075,.04]} c="#35434e"/>)}
  <B p={[.1,.7275,0]} s={[.48,.075,.52]} c="#547486"/>
  {[-.21,.21].map(x=><group key={x}>
   <RoundPart position={[.1+x,.80,0]} radius={.011} length={.57} axis="z" color="#becbd2"/>
   {[-.31,.31].map(z=><B key={z} p={[.1+x,.7675,z]} s={[.055,.155,.045]} c="#426779"/>)}
  </group>)}
  <B p={[.1,.7725,-.38]} s={[.24,.165,.14]} c="#52768b"/>
 </group>
 return null
}
