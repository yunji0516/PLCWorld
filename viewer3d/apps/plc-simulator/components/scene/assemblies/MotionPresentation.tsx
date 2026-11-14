'use client'

import {createContext, useContext} from 'react'
import {Part} from './Parts'
import {SocketBolt} from '../IndustrialDetails'

/** Presentation only, inherited by the reused cells inside H02. */
export const MotionPresentation = createContext(false)
export const MotionProcessDetail = createContext(false)
export const useMotionProcessDetail = () => useContext(MotionProcessDetail)
export const MotionCellFloorOffset = createContext(0)
export const MotionCellPlatform = createContext<{width:number;depth:number;z:number}|null>(null)
export const useMotionPresentation = () => useContext(MotionPresentation)

export function GantryBeam({size}:{size:[number,number,number]}) {
  const [w,h,d]=size
  return <group name="machined-gantry-crossbeam">
    <Part name="gantry-beam-core" size={[w,h,d]} color="#a3afb9" radius={.004}/>
    {[-1,1].map(s=><group key={s}>
      <Part name="gantry-beam-recess" size={[.002,h*.32,d*.91]} position={[s*(w/2+.0015),0,0]} color="#35434e" radius={.001}/>
      <Part name="gantry-end-cap" size={[w+.008,h+.008,.014]} position={[0,0,s*(d/2+.007)]} color="#50768e" radius={.003}/>
      {[-1,1].map(x=><SocketBolt key={x} position={[x*w*.28,h/2+.001,s*d*.4]} radius={.006} top/>)}
    </group>)}
  </group>
}
