import {Part,RoundPart,BoredPlate,FINISH} from './Parts'
import {MotionRealism} from './MotionRealism'
import {SocketBolt} from '../IndustrialDetails'

/** Replaces one recorded actuator box with a tie-rod cylinder in exactly that envelope.
 * Axis selection follows the longest dimension; all pieces share the source pose.
 */
export function RecordedCylinderBody({size}:{size:number[]}){
 const axis=size.indexOf(Math.max(...size)),l=size[axis]
 const w=axis===0?size[1]:size[0],d=axis===2?size[1]:size[2]
 const cap=l*.13,body=l-2*cap,r=Math.min(w,d)*.038,bore=Math.min(w,d)*.16
 const rotation:[number,number,number]=axis===0?[0,0,-Math.PI/2]:axis===2?[Math.PI/2,0,0]:[0,0,0]
 return <MotionRealism.Provider value={false}><group name="recorded-tie-rod-cylinder" scale={[1/size[0],1/size[1],1/size[2]]}>
  <group rotation={rotation}>
   <Part name="cylinder-extruded-barrel" size={[w*.72,body,d*.72]} color={FINISH.alloy} radius={Math.min(w,d)*.10}/>
   {[-1,1].map(s=><group key={s} position={[0,s*(l-cap)/2,0]} rotation={[Math.PI/2,0,0]}>
    <BoredPlate name="cylinder-bored-end-cap" size={[w,d,cap]} position={[0,0,0]} corner={Math.min(w,d)*.08} holes={[{x:0,y:0,radius:bore},...[-1,1].flatMap(x=>[-1,1].map(z=>({x:x*w*.37,y:z*d*.37,radius:r*1.06})))]} color={FINISH.steel}/>
   </group>)}
   {[-1,1].flatMap(x=>[-1,1].map(z=><group key={x+':'+z}>
    <RoundPart name="cylinder-tie-rod" position={[x*w*.37,0,z*d*.37]} radius={r} length={body} axis="y" color={FINISH.dark}/>
    {[-1,1].map(s=><group key={s} rotation={[s<0?Math.PI:0,0,0]}>
     <SocketBolt top position={[x*w*.37,l/2-r*.31-.00021,z*d*.37]} radius={r}/>
    </group>)}
   </group>))}
  </group>
 </group></MotionRealism.Provider>
}
