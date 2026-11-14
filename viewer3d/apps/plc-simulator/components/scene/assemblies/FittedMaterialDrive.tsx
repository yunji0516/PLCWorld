'use client'
import {Drive} from './MaterialV6Details'
import {MotionRealism} from './MotionRealism'
type V=[number,number,number]
/** Reuse the Material drive casting, jacket, terminal and flange. The envelope
 * remains the recorded motor box, so support faces and contact paths stay put. */
export function FittedMaterialDrive({size,position=[0,0,0],axis='x'}:{size:V;position?:V;axis?:'x'|'y'|'z'}){
 const local:V=axis==='x'?size:axis==='y'?[size[1],size[0],size[2]]:[size[2],size[1],size[0]]
 const rotation:V=axis==='x'?[0,0,0]:axis==='y'?[0,0,Math.PI/2]:[0,-Math.PI/2,0]
 return <group name="material-style-fitted-drive" position={position} rotation={rotation}>
  <group scale={[local[0]/.1965,local[1]/.132,local[2]/.115]}>
   <group position={[.05675,-.0035,0]}><MotionRealism.Provider value={false}><Drive p={[0,0,0]}/></MotionRealism.Provider></group>
  </group>
 </group>
}
