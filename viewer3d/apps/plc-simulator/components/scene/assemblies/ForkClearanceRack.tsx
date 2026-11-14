import type { DeviceProps } from '../devices'
import { FINISH, Part } from './Parts'

/** Solid shelf pans with raised work supports and open-front fork entry. */
export function ForkClearanceRack({device}: DeviceProps) {
  const [w,h,d]=device.size
  const rack=device.kind==='rack'
  const levels=rack?[-h/2+.12,0,h/2-.22]:[h/2-.035]
  const palletRack=device.visualVariant==='material-pallet-rack'
  const front=Math.min(d/2,.22),back=-d/2+.03,depth=front-back
  return <group name="fork-clearance-support">
    {[-1,1].flatMap(x=>[-1,1].map(z=><Part key={`${x}:${z}`} name="clearance-support-post" size={[.06,h,.06]} position={[x*(w/2-.04),0,z*(d/2-.04)]} color={FINISH.dark}/>))}
    {levels.map(y=><group key={y} position={[0,y,0]}>
      {palletRack ? <Part name="pallet-shelf-solid-pan" size={[w-.14,.035,d-.14]} position={[0,.0175,0]} color={FINISH.steel}/> : <>
      {/* The shelf itself is continuous. Raised supports provide fork clearance,
          as opposed to cutting two full-depth holes through an ordinary shelf. */}
      <Part name="shelf-solid-pan" size={[w-.14,.018,depth]} position={[0,-.085,(front+back)/2]} color={FINISH.dark}/>
      <Part name="shelf-centre-riser" size={[.14,.086,depth]} position={[0,-.033,(front+back)/2]}/>
      {[-1,1].map(s=><Part key={'riser'+s} name="shelf-side-riser" size={[w/2-.24,.086,depth]} position={[s*(w/4+.05),-.033,(front+back)/2]}/>)}
      <Part name="shelf-centre-land" size={[.14,.025,depth]} position={[0,.0225,(front+back)/2]}/>
      {[-1,1].map(s=><Part key={s} name="shelf-side-land" size={[w/2-.24,.025,depth]} position={[s*(w/4+.05),.0225,(front+back)/2]}/>)}
      <Part name="shelf-rear-support" size={[w-.06,.065,.035]} position={[0,-.0125,back-.0175]} color={FINISH.dark}/>
      </>}
    </group>)}
  </group>
}
