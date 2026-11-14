import {Part} from './Parts'
import {CabinetFace} from './MaterialV6Details'
import {MaterialTableLegs} from './MaterialTableLegs'

/** M06-sized service enclosure: body and brackets terminate at the mounting plane. */
export function ServiceEnclosure({x=0,z=0,top,stand=false}:{x?:number;z?:number;top:number;stand?:boolean}){
 return <group name="service-enclosure-assembly" position={[x,0,z]}>
  <group name="control-box-equipment" userData={{deviceDisplayName:'Control cabinet'}}>
  <Part name="control-box-body" position={[0,top-.145,0]} size={[.44,.25,.18]} color="#7f8f9c"/>
  <CabinetFace p={[0,top-.145,.096]} width={.40} height={.22}/>
  </group>
  {stand?<group><MaterialTableLegs halfX={.16} halfZ={.065} top={top-.27}/></group>:[-.15,.15].map(dx=><Part key={dx} name="service-cover-mount" position={[dx,top-.01,0]} size={[.035,.02,.15]} color="#35434e"/>)}
 </group>
}
