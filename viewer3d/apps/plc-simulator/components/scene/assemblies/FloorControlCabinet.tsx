import {Part} from './Parts'
import {FINISH} from './Parts'

/** H01 floor cabinet. Its bottom sits on the mounting plane. */
export function FloorControlCabinet({width=.4,height=1.36,depth=.5}:{width?:number;height?:number;depth?:number}){
 const w=width,h=height,d=depth
 return <group name="control-box-equipment" userData={{deviceDisplayName:'Control cabinet'}} position={[0,h/2,0]}>
  <Part name="cabinet-body" size={[w,h,d]} position={[0,0,0]} color="#c0c9cc"/>
  <Part name="cabinet-door" size={[w-.035,h-.04,.015]} position={[0,0,d/2+.008]}/>
  <Part name="cabinet-display" size={[w*.6,.15,.012]} position={[0,h*.25,d/2+.024]} color={FINISH.dark}/>
  <Part name="cabinet-handle" size={[.015,.13,.018]} position={[w*.33,0,d/2+.03]} color={FINISH.dark}/>
 </group>
}
