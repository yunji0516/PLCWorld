import {Part} from './Parts'
import {Foot,Profile} from './MaterialV6Details'
/** One L-shaped frame: the extension starts at the main deck edge, and shares
 * its front support instead of duplicating two nearly coincident legs. */
export function InterceptWorkbench(){
 const legs=[[-.87,-.31],[.01,-.31],[-.87,.31],[.01,.31],[-.86,.95],[-.54,.95]]
 return <group name="intercept-l-workbench">
  <Part name="v8-fixed-deck" position={[-.43,.67,0]} size={[1.04,.06,.78]}/>
  <Part name="v8-fixed-deck" position={[-.70,.67,.71]} size={[.48,.06,.64]}/>
  {legs.map(([x,z])=><group key={`${x}:${z}`}><Foot p={[x,0,z]}/><Profile p={[x,.34,z]} length={.60}/></group>)}
  {[-.31,.31].map(z=><group key={z}>
   <Part name="bench-underframe-beam" position={[-.43,.615,z]} size={[.825,.05,.035]}/>
   <Part name="bench-stretcher" position={[-.43,.25,z]} size={[.825,.035,.028]}/>
  </group>)}
  {[-.87,.01].map(x=><Part key={x} name="bench-underframe-beam" position={[x,.615,0]} size={[.035,.05,.565]}/>)}
  {[[-.86,.3375],[-.54,.3275]].map(([x,start])=><Part key={x} name="bench-extension-underframe" position={[x,.615,(start+.9225)/2]} size={[.035,.05,.9225-start]}/>)}
  <Part name="bench-underframe-beam" position={[-.70,.615,.95]} size={[.265,.05,.035]}/>
  <Part name="bench-stretcher" position={[-.70,.25,.95]} size={[.265,.035,.028]}/>
 </group>
}
