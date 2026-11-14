'use client'
import {FittedMaterialDrive} from './FittedMaterialDrive'

import {FINISH,Part,RoundPart} from './Parts'
import {SocketBolt} from '../IndustrialDetails'

/** Mechanical fittings only; all moving fittings inherit the recorded parent pose. */
export function Flange({radius=.12,z=0}:{radius?:number;z?:number}) {
  return <group position={[0,0,z]} name="process-bearing-flange">
    <RoundPart position={[0,0,0]} radius={radius} length={.025} color={FINISH.alloy}/>
    <RoundPart position={[0,0,.016]} radius={radius*.64} length={.008} color={FINISH.dark}/>
    {Array.from({length:6},(_,i)=>{const a=i*Math.PI/3;return <RoundPart key={i} position={[Math.cos(a)*radius*.80,Math.sin(a)*radius*.80,.017]} radius={.007} length={.012} segments={6} color={FINISH.steel}/>})}
  </group>
}

export function RotaryDriveDetails(){
  return <group name="rotary-table-drive-details">
    <RoundPart name="spindle-bearing-foot" position={[0,.605,0]} radius={.27} length={.05} axis="y"/>
    <RoundPart name="spindle-dust-seal" position={[0,.637,0]} radius={.197} length={.014} axis="y" color={FINISH.dark}/>
    <FittedMaterialDrive position={[-.45,.35,0]} size={[.32,.22,.24]}/>
    <RoundPart name="rotary-drive-motor-flange" position={[-.302,.35,0]} radius={.14} length={.025} axis="x"/>
    <Part name="gearbox-service-cover" position={[0,.34,.299]} size={[.44,.32,.018]} color={FINISH.alloy}/>
    {[-1,1].flatMap(x=>[-1,1].map(y=><RoundPart key={`${x}-${y}`} position={[x*.18,.34+y*.12,.313]} radius={.012} length={.01} segments={6} color={FINISH.dark}/>))}
    {Array.from({length:8},(_,i)=>{const a=i*Math.PI/4;return <SocketBolt key={i} position={[.23*Math.cos(a),.633,.23*Math.sin(a)]} radius={.009} top/>})}
  </group>
}

export function RotaryFaceDetails(){
  return <group name="rotary-table-machining">
    <RoundPart name="rotary-central-cover" position={[0,.043,0]} radius={.16} length={.02} axis="y" color={FINISH.blue}/>
    {Array.from({length:8},(_,i)=>{const a=i*Math.PI/4+Math.PI/8;return <SocketBolt key={i} position={[.34*Math.cos(a),.034,.34*Math.sin(a)]} radius={.01} top/>})}
    {[0,1,2,3].map(k=><group key={k} rotation={[0,-k*Math.PI/2,0]}>
      {[-1,1].map(s=><group key={s}>
        <Part name="receiver-jaw-wear-strip" position={[.48,.234,s*.0725]} size={[.24,.004,.032]} color={FINISH.steel}/>
        {[-1,1].map(x=><SocketBolt key={x} position={[.48+x*.09,.238,s*.0725]} radius={.006} top/>)}
      </group>)}
    </group>)}
  </group>
}

export function BalanceDriveDetails(){
  return <group name="balance-trunnion-drive">
    <group position={[0,1,-.34]} rotation={[0,Math.PI,0]}><Flange radius={.115}/></group>
    <Part name="trunnion-reducer" position={[0,1,-.425]} size={[.20,.22,.14]} color={FINISH.blue}/>
    <RoundPart name="trunnion-motor" position={[0,1,-.555]} radius={.079} length={.12} color={FINISH.dark}/>
    {[-1,1].map(s=><Part key={s} name="trunnion-post-foot" position={[0,.506,s*.27]} size={[.21,.022,.17]} color={FINISH.steel}/>)}
    <Part name="counterweight-drive-end" position={[-.715,.54,0]} size={[.13,.115,.15]} color={FINISH.blue}/>
    <RoundPart name="counterweight-coupling" position={[-.641,.54,0]} radius={.038} length={.023} axis="x"/>
  </group>
}
