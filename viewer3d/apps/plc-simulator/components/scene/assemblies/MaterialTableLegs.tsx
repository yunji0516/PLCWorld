import {Part} from './Parts'
import {Foot, Profile} from './MaterialV6Details'

/** M06-style dark extrusions and leveling feet, fitted to the deck underside. */
export function MaterialTableLegs({x=0,z=0,halfX,halfZ,top}:{x?:number;z?:number;halfX:number;halfZ:number;top:number}) {
 return <group name="material-table-underframe">{[-1,1].flatMap(a=>[-1,1].map(b=><group key={`${a}:${b}`}>
  <Foot p={[x+a*halfX,0,z+b*halfZ]}/>
  <Profile p={[x+a*halfX,(top+.04)/2,z+b*halfZ]} length={top-.04}/>
 </group>))}
 {[-1,1].map(b=><Part key={'tie'+b} name="bench-stretcher" position={[x,Math.min(.25,top*.42),z+b*halfZ]} size={[Math.max(.01,2*halfX-.055),.035,.028]} color="#303b45"/>)}
 </group>
}
