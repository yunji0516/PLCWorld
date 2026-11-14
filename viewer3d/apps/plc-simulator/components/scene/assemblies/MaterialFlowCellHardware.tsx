'use client'
import type {DeviceProps} from '../devices'
import {B,C,Moving,Rod,Foot,Belt,Solids,RecordedRod,Web,type Reader} from './MaterialMiniProcessHardware'
const blue='#4b798e',dark='#354c59',silver='#b5c2c9'
function Sensor({x,z}:{x:number;z:number}){return <group>
 <B name="photoeye-frame-bracket" position={[x,.88,z+.32]} size={[.09,.24,.06]} color={silver}/>
 <B name="photoeye-body" position={[x,.995,z+.31]} size={[.08,.09,.08]} color={dark}/>
 <B name="photoeye-lens" position={[x,.995,z+.268]} size={[.035,.035,.006]} color="#962f30"/>
 <B name="reflector-frame-bracket" position={[x,.88,z-.32]} size={[.07,.24,.06]} color={silver}/>
 <B name="opposed-retroreflector" position={[x,.995,z-.285]} size={[.09,.10,.013]} color="#cbccb7"/>
 <B name="sensor-mount-outrigger" position={[x,.775,z]} size={[.10,.05,.70]} color={silver}/>
 </group>}
function Sequence({r}:{r:Reader}){return <>
 <B name="storage-bank-shared-machine-base" position={[0,.36,0]} size={[3.70,.56,3.46]} color="#738a94"/>
 {[-1,1].map(k=><group key={'guard'+k}>
  <B name="storage-bank-fixed-side-guard" position={[0,1.24,k*1.93]} size={[3.70,.65,.014]} color="#b9d0d5" opacity={.17}/>
  <B name="storage-bank-guard-top-rail" position={[0,1.59,k*1.93]} size={[3.80,.045,.045]} color={silver}/>
  {[-1.86,0,1.86].map(x=><B key={x} name="storage-bank-guard-post" position={[x,1.02,k*1.93]} size={[.045,1.18,.045]} color={silver}/>)}
  <B name="storage-bank-bottom-frame" position={[0,.76,k*1.81]} size={[3.80,.10,.10]} color={dark}/>
 </group>)}
 {[-1.5,1.5].map(z=><group key={z}><Belt a={[-5,.9,z]} b={[-3.15,.9,z]} width={.46}/><Sensor x={-3.55} z={z}/><Belt a={[3.15,.9,z]} b={[7.8,.9,z]} width={.46}/><Sensor x={6.3} z={z}/></group>)}
 {[-1.5,-.5,.5,1.5].map((z,i)=><group key={z}><Belt a={[-1.95,.9,z]} b={[1.95,.9,z]} width={.46}/><Sensor x={.42} z={z}/><B name={'bay-'+(i+1)+'-stop-marker'} position={[.30,.905,z+.20]} size={[.08,.008,.04]} color="#bd9559"/></group>)}
 {[-1,1].map((sign,j)=><group key={sign}>
  {[-.42,.42].map(dx=><group key={dx}><B name="transverse-shuttle-linear-rail" position={[sign*2.55+dx,.67,0]} size={[.06,.08,3.95]} color={silver}/><Foot x={sign*2.55+dx} z={-1.8} h={.63}/><Foot x={sign*2.55+dx} z={1.8} h={.63}/></group>)}
  <B name="shuttle-axis-servo" position={[sign*2.55,.65,2.0]} size={[.25,.20,.26]} color={blue}/>
  <B name="shuttle-toothed-drive-belt" position={[sign*2.55,.66,0]} size={[.045,.045,3.78]} color={dark}/>
  <Moving r={r} id={j===0?'in_cart':'out_cart'}>
   <B name="shuttle-powered-belt" position={[0,.032,0]} size={[1.20,.016,.42]} color="#7c9097"/>
   <B name="shuttle-support-deck" position={[0,-.025,0]} size={[1.20,.08,.46]} color={dark}/>
   {[-1,1].map(k=><group key={k}><B name="shuttle-frame-rail" position={[0,-.045,k*.25]} size={[1.20,.12,.04]} color={silver}/><C name="shuttle-belt-end-drum" position={[k*.565,.005,0]} radius={.027} length={.47} color={silver}/><B name="shuttle-bearing-truck" position={[k*.42,-.11,0]} size={[.13,.10,.33]} color={blue}/></group>)}
   <B name="shuttle-belt-gearmotor" position={[-.47,-.045,.35]} size={[.16,.15,.16]} color={blue}/>
  </Moving>
 </group>)}
 {(['a','b'] as const).map((s,j)=>{const z=j===0?-1.5:1.5;return <group key={s}>
  <B name="receiver-fixed-contact-jaw" position={[4.3,.99,z-.18]} size={[.34,.10,.04]} color={dark}/>
  <B name="receiver-jaw-mount" position={[4.3,.875,z-.25]} size={[.26,.20,.10]} color={silver}/>
  <B name="receiver-clamp-cylinder" position={[4.3,.99,z+.47]} size={[.16,.14,.26]} color={blue}/>
  <B name="receiver-cylinder-bracket" position={[4.3,.875,z+.47]} size={[.18,.12,.18]} color={silver}/>
  <B name="receiver-support-outrigger" position={[4.3,.775,z+.22]} size={[.30,.065,.71]} color={silver}/>
  <Moving r={r} id={'clamp_'+s}><B name="receiver-moving-contact-jaw" size={[.34,.10,.02]} color={dark}/></Moving>
  <RecordedRod r={r} id={'clamp_'+s} anchor={[4.3,.99,z+.34]} offset={[0,0,.01]} radius={.014}/>
 </group>})}
 <Solids r={r} count={6}/>
 </>}
function Cassettes({r}:{r:Reader}){return <>
 <Web r={r} endX={4.25} count={6}/>
 {[-1,1].map(k=><B key={'cutguard'+k} name="fixed-cutting-side-guard" position={[1.79,1.23,k*.355]} size={[.44,.46,.016]} color="#b9d0d5" opacity={.20}/>)}
 <Belt a={[1.35,.54,1.45]} b={[9.65,.54,1.45]} width={.64} top={.54}/>
 <Belt a={[4.6,.54,.30]} b={[4.6,.54,1.12]} width={.74} top={.54}/>
 <B name="receiving-lift-foundation" position={[4.6,.09,0]} size={[.88,.18,.85]} color={dark}/>
 {[-1,1].map(k=><group key={k}><B name="receiving-lift-guide" position={[4.6+k*.40,.49,-.36]} size={[.05,.72,.06]} color={silver}/><B name="receiving-lift-guide-base" position={[4.6+k*.40,.20,-.36]} size={[.13,.10,.14]} color={blue}/></group>)}
 <B name="receiving-lift-drive" position={[4.6,.28,0]} size={[.20,.22,.23]} color={blue}/>
 <RecordedRod r={r} id="receiver_lift" anchor={[4.6,.39,0]} offset={[0,-.045,0]} radius={.032}/>
 <Moving r={r} id="receiver_lift"><B name="receiving-lift-deck" size={[.74,.07,.64]} color={silver}/></Moving>
 <B name="cassette-clamp-support" position={[5.17,.66,0]} size={[.11,.49,.18]} color={silver}/>
 <B name="cassette-clamp-drive" position={[5.17,.90,0]} size={[.23,.13,.16]} color={blue}/>
 <Moving r={r} id="cassette_lock"><B name="cassette-clamp-contact" size={[.02,.065,.18]} color={dark}/></Moving>
 <RecordedRod r={r} id="cassette_lock" anchor={[5.05,.90,0]} offset={[.01,0,0]} radius={.013}/>
 {[-1,1].map(k=><B key={k} name="cross-transfer-belt-drive" position={[4.6+k*.46,.38,1.45]} size={[.19,.18,.24]} color={blue}/>)}
 {[1,2,3].map(i=><Moving key={i} r={r} id={'cassette'+i}>
  <B name="cassette-base-frame" position={[0,-.04,0]} size={[.70,.04,.58]} color={blue}/>
  {[.07,.29].map(y=><B key={y} name="cassette-actual-support-shelf" position={[0,y,0]} size={[.66,.02,.51]} color={silver}/>)}
  {[-1,1].flatMap(x=>[-1,1].map(z=><B key={x+':'+z} name="cassette-corner-upright" position={[x*.325,.20,z*.275]} size={[.04,.48,.03]} color={blue}/>))}
  <B name="cassette-rear-top-crossmember" position={[.325,.445,0]} size={[.04,.04,.58]} color={silver}/>
  <B name="cassette-id-plate" position={[0,-.035,-.294]} size={[.17,.027,.009]} color="#e0e6e8"/>
 </Moving>)}
 </>}
export function MaterialFlowCellHardware({device,plant}:DeviceProps){const r=plant as unknown as Reader,mode=device.visualVariant?.replace('cell3-r9-','');return <group name={'material-flowcell-r9-'+mode}>{mode==='sequence'?<Sequence r={r}/>:<Cassettes r={r}/>}</group>}
