'use client'

import { useEffect, useMemo } from 'react'
import { CatmullRomCurve3, LatheGeometry, Quaternion, Vector2, Vector3 } from 'three'
import { SafeServiceTube } from './SafeServiceTube'
import { SlottedProfileGeometry, SocketBolt } from '../IndustrialDetails'
import {useMaterialPresentation} from './MaterialPresentation'
import {TABLE_FINISH} from './tableFinish'
import { Part, RoundPart, FINISH } from './Parts'
import {useIndexEquipmentColor} from './IndexEquipmentPalette'

type V3 = [number,number,number]

/** An actual through bore: the lift rod passes through the rotary arm hub. */
export function BoredHub({p,outer,inner,height,matte=false}:{p:V3;outer:number;inner:number;height:number;matte?:boolean}) {
  const color=useIndexEquipmentColor('#6d899a')
  const geometry=useMemo(()=>new LatheGeometry([
    new Vector2(inner,-height/2),new Vector2(outer,-height/2),
    new Vector2(outer,height/2),new Vector2(inner,height/2),new Vector2(inner,-height/2),
  ],48),[outer,inner,height])
  useEffect(()=>()=>geometry.dispose(),[geometry])
  return <mesh name="v6-bored-arm-hub" position={p} geometry={geometry} castShadow>
    <meshStandardMaterial color={color} metalness={matte?.18:.65} roughness={matte?.88:.5} envMapIntensity={matte?.25:1}/>
  </mesh>
}

export function LabelPlate({text,p,width=.30,color='#334e60'}:{text:string;p:V3;width?:number;color?:string}) {
  // Keep the hardware; remove its decorative instruction/name plate.
  return null
}

export function Hose({points,color='#273a49',radius=.006,purpose='detail'}:{points:V3[];color?:string;radius?:number;purpose?:'detail'|'functional'}) {
 return <SafeServiceTube purpose={purpose} points={points} color={color} radius={radius} name="v6-service-hose"/>
}

export function Profile({p,length,edge=.055,axis='y',finishColor='#a6b3bd'}:{p:V3;length:number;edge?:number;axis?:'x'|'y';finishColor?:string}) {
  const detailed=useMaterialPresentation()
  const mappedColor=useIndexEquipmentColor(finishColor)
  const color=axis==='y'?TABLE_FINISH.leg:mappedColor
  return <group position={p} rotation={axis==='x'?[0,0,Math.PI/2]:[0,0,0]}><mesh name="v6-slotted-extrusion" castShadow receiveShadow>
    <SlottedProfileGeometry edge={edge} length={length}/><meshStandardMaterial color={color} metalness={axis==='y'?TABLE_FINISH.metalness:.6} roughness={axis==='y'?TABLE_FINISH.roughness:.63} envMapIntensity={axis==='y'?TABLE_FINISH.envMapIntensity:1}/>
  </mesh>
  {detailed&&length>.16&&[-1,1].map(end=><SocketBolt key={end} position={[edge*.27,end*(length/2-edge*.55),edge/2+.001]} radius={Math.min(.004,edge*.09)}/>)}
  </group>
}

export function Foot({p}:{p:V3}) {
  return <group name="v6-adjustable-foot" position={p}>
    <RoundPart radius={.026} length={.018} axis="y" position={[0,.009,0]} color={FINISH.seal}/>
    <RoundPart radius={.006} length={.026} axis="y" position={[0,.029,0]}/>
    <RoundPart radius={.012} length={.006} axis="y" position={[0,.029,0]} segments={6}/>
  </group>
}

export function Rail({p,length}:{p:V3;length:number}) {
  return <group name="v6-linear-guide" position={p}>
    <Part name="linear-guide-rail" size={[length,.028,.035]} color={FINISH.alloy}/>
    <Part name="linear-guide-track" size={[length,.009,.022]} position={[0,.018,0]}/>
    {Array.from({length:Math.ceil(length/.15)},(_,i)=><SocketBolt key={i} top radius={.0035} position={[-length/2+.05+i*.14,.02355,0]}/>)}
  </group>
}

/** Common rail and extrusion, with the track datum preserved across task levels. */
export function LinearGuideBed({p,length}:{p:V3;length:number}) {
 return <group name="linear-guide-bed" position={p}>
  <Part name="linear-axis-housing" position={[0,-.05,0]} size={[length,.08,.08]} color={FINISH.alloy}/>
  <Rail p={[0,0,0]} length={length}/>
 </group>
}

export function Drive({p,axis='x'}:{p:V3;axis?:'x'|'z'}) {
  return <group name="v6-geared-drive" position={p} rotation={axis==='x'?[0,Math.PI/2,0]:[0,0,0]}>
    {/* Split casting, machined output flange and motor cooling jacket occupy
        the original drive envelope. No extra shaft extends into a task. */}
    <Part name="drive-reducer-casting" size={[.095,.105,.051]} position={[0,0,-.0065]} radius={.012} color="#9da9af"/>
    <Part name="drive-output-flange" size={[.115,.125,.014]} position={[0,0,.028]} radius={.008} color="#c8d0d3"/>
    <Part name="drive-motor-adapter" size={[.103,.113,.008]} position={[0,0,-.036]} radius={.009} color="#b1bcc2"/>
    <group position={[0,0,.038]} rotation={[Math.PI/2,0,0]}><BoredHub p={[0,0,0]} outer={.036} inner={.017} height={.006}/></group>
    <RoundPart name="drive-output-seal" radius={.0165} length={.006} position={[0,0,.038]} color="#293139"/>
    <RoundPart name="drive-output-shaft-end" radius={.009} length={.007} position={[0,0,.038]} color="#bac5cb"/>
    <RoundPart name="drive-motor-jacket" radius={.041} length={.096} position={[0,0,-.088]} color="#3b454d"/>
    {Array.from({length:10},(_,i)=>{const angle=i*Math.PI/5;return <group key={i} rotation={[0,0,angle]}>
      <Part name="drive-longitudinal-cooling-fin" size={[.005,.008,.086]} position={[0,.044,-.087]} radius={.001} color="#53616b"/>
    </group>})}
    <RoundPart name="drive-rear-cap" radius={.047} length={.018} position={[0,0,-.145]} color="#283640"/>
    {[-2,-1,0,1,2].map(i=><Part key={i} name="drive-rear-vent" size={[.052-Math.abs(i)*.007,.003,.001]} position={[0,i*.009,-.1545]} radius={.0003} color="#101b23"/>)}
    <Part name="drive-terminal-mount" size={[.035,.007,.04]} position={[0,.040,-.105]} color={FINISH.dark}/>
    <Part name="v6-drive-terminal" size={[.045,.023,.05]} position={[0,.055,-.105]} color={FINISH.dark}/>
    <Part name="drive-terminal-lid" size={[.044,.003,.048]} position={[0,.068,-.105]} radius={.002} color="#798991"/>
    <Part name="drive-rating-plate" size={[.001,.024,.042]} position={[.0479,0,-.006]} radius={.0002} color="#d1d7d5"/>
    {[-1,1].flatMap(x=>[-1,1].map(y=><SocketBolt key={`${x}:${y}`} radius={.006} position={[x*.043,y*.047,.038]}/>))}
  </group>
}

/** The full-stroke rod retracts into a real barrel above the carriage. */
export function CylinderBarrel({stroke,backService=false}:{stroke:number;backService?:boolean}) {
  const serviceSide=backService?-1:1
  return <group name="v6-full-stroke-cylinder-barrel">
    <RoundPart radius={.035} length={stroke+.035} axis="y" position={[0,(stroke+.035)/2+.045,0]}/>
    {[.045,stroke+.08].map(y=><group key={y}>
      <Part size={[.095,.03,.085]} position={[0,y,0]} color="#4c6a7b"/>
      <RoundPart radius={.007} length={.019} position={[.025,y,serviceSide*.052]} color="#2a3e4a"/>
      {[-1,1].flatMap(x=>[-1,1].map(z=><SocketBolt key={`${x}:${z}`} top position={[x*.035,y+.016,z*.029]} radius={.005}/>))}
    </group>)}
    {[-1,1].flatMap(x=>[-1,1].map(z=><RoundPart key={`${x}:${z}`} radius={.004} length={stroke+.035} axis="y" position={[x*.035,(stroke+.035)/2+.045,z*.029]}/>))}
    <Hose color="#4386a5" points={[[.025,.045,serviceSide*.060],[.08,.12,serviceSide*.085],[.08,stroke+.02,serviceSide*.085],[.025,stroke+.08,serviceSide*.060]]} radius={.004}/>
  </group>
}

/** Orthogonal mounts stay outside the workpiece and tool travel envelopes. */
export function SensorBracket({kind}:{kind:'orientation'|'datum'|'classification'}) {
  return <group name="v6-photoeye-mount">
    {kind==='datum'?<>
      <Part size={[.10,.02,.085]} position={[-.43,.73,.46]}/>
      <Profile p={[-.43,1.21,.46]} length={.94} edge={.035}/>
      <Part size={[.225,.035,.055]} position={[-.52,1.68,.46]}/>
      <Part size={[.075,.045,.40]} position={[-.615,1.68,.29]}/>
      <Part size={[.065,.015,.055]} position={[-.615,1.656,.12]} color={FINISH.dark}/>
      <Hose points={[[-.615,1.633,.034],[-.66,1.72,.13],[-.66,1.72,.46],[-.43,1.71,.49],[-.43,.79,.49]]} radius={.004}/>

    </>:kind==='orientation'?<>
      <Part size={[.10,.025,.19]} position={[-.75,.6425,.31]}/>
      <Part size={[.075,.01,.085]} position={[-.75,.6575,.35]} color={FINISH.dark}/>
      <Part size={[.12,.06,.05]} position={[-.75,.62,.225]} color={FINISH.dark}/>
      <Hose points={[[-.75,.786,.363],[-.78,.79,.43],[-.80,.61,.36],[-.79,.62,.25]]} radius={.004}/>
    </>:<>
      <Part size={[.09,.025,.11]} position={[-1.16,.6425,0]}/>
      <Part size={[.085,.01,.075]} position={[-1.14,.6575,0]} color={FINISH.dark}/>
      <Part size={[.05,.07,.10]} position={[-1.09,.63,0]} color={FINISH.dark}/>
      <Hose points={[[-1.153,.786,0],[-1.21,.79,.03],[-1.19,.60,.08],[-1.09,.63,.035]]} radius={.004}/>
    </>}
  </group>
}

export function CabinetFace({p,width=.30,height=.40,label='SERVICE'}:{p:V3;width?:number;height?:number;label?:string}) {
  return <group name="v6-access-panel" position={p}>
    <Part size={[width,height,.012]} color="#bac5ca"/>
    <Part size={[.014,.09,.018]} position={[width*.34,.025,.012]} color={FINISH.dark}/>
    {Array.from({length:5},(_,i)=><Part key={i} size={[width*.55,.005,.002]} position={[-width*.06,-height*.25+i*.016,.007]} color={FINISH.dark}/>)}
    <LabelPlate text={label} p={[0,height*.31,.008]} width={width*.76}/>
    {[-1,1].flatMap(x=>[-1,1].map(y=><SocketBolt key={`${x}:${y}`} radius={.004} position={[x*(width/2-.016),y*(height/2-.016),.009]}/>))}
  </group>
}
