'use client'
import { SuctionCup } from './SuctionCup'
import {useRef} from 'react'
import {useFrame} from '@react-three/fiber'
import {Group,Vector3,Quaternion} from 'three'
import type {DeviceProps} from '../devices'
import type {MaterialHardState} from '@/lib/replay/adapter'
import geometry from '@/lib/replay/materialRedesignGeometry.json'
import {Part,RoundPart} from './Parts'
type V=[number,number,number]
type Reader={materialHardState():MaterialHardState|undefined}
type Mode=keyof typeof geometry
function Moving({r,id,scale=false,children}:{r:Reader;id:string;scale?:boolean;children:React.ReactNode}){
 const ref=useRef<Group>(null)
 useFrame(()=>{const p=r.materialHardState()?.poses[id];if(!ref.current)return;ref.current.visible=!!p;if(p){ref.current.position.fromArray(p.pos);if(scale&&p.size)ref.current.scale.fromArray(p.size)}})
 return <group ref={ref}>{children}</group>
}
function Rod({r,from,to,radius=.018,color='#aab5bd'}:{r:Reader;from:(s:MaterialHardState)=>V;to:(s:MaterialHardState)=>V;radius?:number;color?:string}){
 const ref=useRef<Group>(null);const y=new Vector3(0,1,0),d=new Vector3(),q=new Quaternion()
 useFrame(()=>{const s=r.materialHardState();if(!s||!ref.current)return;const a=from(s),b=to(s);d.set(b[0]-a[0],b[1]-a[1],b[2]-a[2]);ref.current.position.set((a[0]+b[0])/2,(a[1]+b[1])/2,(a[2]+b[2])/2);ref.current.scale.y=d.length();ref.current.quaternion.copy(q.setFromUnitVectors(y,d.normalize()))})
 return <group ref={ref}><RoundPart position={[0,0,0]} radius={radius} length={1} axis="y" color={color}/></group>
}
const point=(s:MaterialHardState,id:string,fallback:V):V=>s.poses[id]?.pos??fallback
function Shell({color}:{color:string}){
 return <group>
  <Part name="shell floor" position={[0,-.108,0]} size={[.70,.024,.64]} color={color}/>
  {[-1,1].map(k=><Part key={k} name="shell side wall" position={[k*.335,0,0]} size={[.030,.24,.64]} color={color}/>)}
  {[-.20,.20].map(x=><Part key={x} name="internal insert support rib" position={[x,-.068,0]} size={[.055,.056,.52]} color={color}/>)}
  <Part name="shell closed end" position={[0,0,.305]} size={[.64,.24,.03]} color={color}/>
  <Part name="open insertion lip" position={[0,-.083,-.30]} size={[.64,.025,.04]} color="#b7c6c6"/>
 </group>
}
function Package({r}:{r:Reader}){
 return <group>
  {[1,2,3,4].map(i=><Moving key={i} r={r} id={'part'+i}><Shell color={i<=2?'#b99765':'#8badaa'}/></Moving>)}
  {[5,6,7,8].map(i=><Moving key={i} r={r} id={'part'+i} scale><Part name="actual insert" size={[1,1,1]} color={i<=6?'#c8a66d':'#6c9f9b'}/></Moving>)}
  <Moving r={r} id="slide"><Part name="insert carriage" size={[.32,.055,.20]} color="#467a8b"/><Part name="connected insert finger" position={[0,.067,-.23]} size={[.10,.16,.04]} color="#b5bec1"/></Moving>
  <Moving r={r} id="opener"><Part name="aperture lifting beam" size={[.74,.045,.065]} color="#467a8b"/>{[-.335,.335].map(x=><Part key={x} position={[x,-.005,0]} size={[.03,.03,.065]} color="#263e46"/>)}</Moving>
  {[-.23,.23].map(x=><Rod key={x} r={r} from={()=>[x,1.64,0]} to={s=>[x,point(s,'opener',[0,1.5,0])[1]+.02,0]}/>)}
  <Rod r={r} from={()=>[0,.99,-1.37]} to={s=>[0,.99,point(s,'slide',[0,1,-1.12])[2]-.08]}/>
 </group>
}
function Branch({r}:{r:Reader}){
 const loose=useRef<Group>(null),roll=useRef<Group>(null)
 useFrame(()=>{const s=r.materialHardState();if(!s)return;const p=point(s,'pickup',[0,1.68,0]);loose.current?.position.set(0,0,p[2]);const scale=s.poses.rewind?.size?.[0]??1;roll.current?.scale.set(scale,scale,1)})
 return <group>
  {[1,2,3,4].map(i=><Moving key={i} r={r} id={'part'+i} scale><Part name="separated product region" size={[1,1,1]} color="#c7a677"/></Moving>)}
  {/* The narrow connected edges remain below the product pickup path. */}
  {[-.216,.216].map(z=><Part key={z} name="continuous stock edge" position={[-1.55,1.12,z]} size={[3.7,.014,.033]} color="#b1a18a"/>)}
  <Moving r={r} id="blade"><Part name="connector separating blade" size={[.025,.10,.45]} color="#bac5cc"/></Moving>
  <Rod r={r} from={()=>[-.29,1.61,0]} to={s=>point(s,'blade',[-.29,1.48,0])} radius={.028}/>
  <group ref={loose}><Part name="gantry carriage" position={[0,2.08,0]} size={[.56,.10,.17]} color="#467a8b"/><RoundPart name="pickup cylinder housing" position={[0,1.94,0]} radius={.05} length={.22} axis="y"/></group>
  <Moving r={r} id="pickup"><Part name="product pickup head" position={[0,.035,0]} size={[.34,.05,.24]} color="#467a8b"/>{[-.11,.11].map(x=><SuctionCup key={x} name="contact pad" position={[x,.005,0]} radius={.035} height={.018}/>)}</Moving>
  <Rod r={r} from={s=>[0,1.85,point(s,'pickup',[0,1.68,0])[2]]} to={s=>{const p=point(s,'pickup',[0,1.68,0]);return [0,p[1]+.065,p[2]]}} radius={.024}/>
  {[-.20,.20].map(z=><group key={z}>
   <Rod r={r} from={()=>[-3.59,1.398,z]} to={()=>[-3.40,1.12,z]} radius={.014} color="#ae9b7c"/>
   <Rod r={r} from={()=>[.35,1.12,z]} to={()=>[1.12,1.175,z]} radius={.014} color="#ae9b7c"/>
   <Rod r={r} from={()=>[1.12,1.175,z]} to={s=>[1.55,point(s,'scrap_loop',[1.55,.85,0])[1],z]} radius={.014} color="#ae9b7c"/>
   <Rod r={r} from={s=>[1.55,point(s,'scrap_loop',[1.55,.85,0])[1],z]} to={()=>[1.95,1.175,z]} radius={.014} color="#ae9b7c"/>
   <Rod r={r} from={()=>[1.95,1.175,z]} to={s=>{const radius=.20*(s.poses.rewind?.size?.[0]??1);const angle=Math.atan2(.075,-.8)-Math.acos(radius/Math.hypot(.8,.075));return [2.75+radius*Math.cos(angle),1.1+radius*Math.sin(angle),z]}} radius={.014} color="#ae9b7c"/>
  </group>)}
  {[-.32,.32].map(z=><group key={z}>
   <Part name="scrap dancer guide foot" position={[1.55,.04,z]} size={[.22,.08,.20]} color="#354c59"/>
   <Part name="scrap dancer vertical guide" position={[1.55,.66,z]} size={[.045,1.20,.045]} color="#b5c2c9"/>
  </group>)}
  <Moving r={r} id="scrap_loop"><RoundPart name="slack storage roller" position={[0,0,0]} radius={.035} length={.49} axis="z"/>
   <RoundPart name="supported dancer shaft" position={[0,0,0]} radius={.013} length={.66} axis="z"/>
   {[-.32,.32].map(z=><Part key={z} name="sliding dancer bearing" position={[0,0,z]} size={[.11,.13,.10]} color="#467a8b"/>)}
  </Moving>
  <group position={[2.75,1.1,0]}><group ref={roll}><RoundPart name="recovered connected scrap" position={[0,0,0]} radius={.20} length={.43} axis="z" color="#ad9775"/></group></group>
 </group>
}
function Carrier({r}:{r:Reader}){
 return <group>
  {[101,102].map(i=><Moving key={i} r={r} id={'part'+i}><Part name="reusable carrier underframe" position={[0,-.025,0]} size={[.66,.03,.58]} color={i===101?'#527f90':'#738f7b'}/>
   {[-.24,-.16,-.08,0,.08,.16,.24].map(z=><RoundPart key={z} name="carrier powered product-transfer roller" position={[0,.015,z]} radius={.025} length={.52} axis="x" color="#b5c2c9"/>)}
   {[-1,1].map(k=><Part key={'chain'+k} name="carrier roller chain cover" position={[k*.30,.007,0]} size={[.045,.065,.57]} color="#354c59"/>)}
   <Part name="carrier attached transfer gearmotor" position={[.40,-.015,0]} size={[.15,.09,.16]} color="#467a8b"/>
   <RoundPart name="carrier motor drive shaft" position={[.325,-.015,0]} radius={.014} length={.06} axis="x" color="#b5c2c9"/>{[-1,1].map(k=><group key={k}><Part name="carrier lateral locator" position={[k*.28,.065,0]} size={[.035,.05,.42]} color="#b5c0c0"/><Part name="pallet lift guide engagement arm" position={[0,0,k*.35]} size={[.13,.045,.20]} color="#467a8b"/><Part name="pallet guided drive shoe" position={[0,0,k*.43]} size={[.12,.11,.075]} color="#6e8490"/></group>)}</Moving>)}
  {[1,2,3,4].map(i=><Moving key={i} r={r} id={'part'+i} scale><Part name="product distinct from carrier" size={[1,1,1]} color={i%2?'#c7a677':'#a7bdba'}/></Moving>)}

 </group>
}
function FillStreams({r}:{r:Reader}){
 const refs=useRef<Group[]>([])
 useFrame(()=>{const state=r.materialHardState();if(!state)return;[1,2,3,4].forEach((id,j)=>{const group=refs.current[j],part=state.parts[String(id)] as (MaterialHardState['parts'][string]&{filled?:boolean})|undefined;const liquid=state.poses['liquid'+id];if(!group)return;group.visible=!!part&&part.owner==='lane'&&!part.filled&&!!liquid;if(group.visible&&part&&liquid){const bottom=liquid.pos[1]+(liquid.size?.[1]??0)/2;group.position.set(part.x,(1.48+bottom)/2,part.z);group.scale.y=Math.max(.001,1.48-bottom)}})})
 return <>{[0,1,2,3].map(i=><group key={i} ref={el=>{if(el)refs.current[i]=el}}><RoundPart name="active liquid transfer" position={[0,0,0]} radius={.008} length={1} axis="y" color="#72a6b8"/></group>)}</>
}
function Measure({r}:{r:Reader}){
 return <group><FillStreams r={r}/>
  {[1,2,3,4].map(i=><Moving key={i} r={r} id={'part'+i}>
   <Part name="vessel bottom" position={[0,-.157,0]} size={[.35,.026,.35]} color="#b9c4c2"/>
   {[-1,1].map(k=><group key={k}>
    <mesh position={[k*.167,0,0]}><boxGeometry args={[.016,.34,.35]}/><meshStandardMaterial color="#a3c1c3" transparent opacity={.22} depthWrite={false}/></mesh>
    <mesh position={[0,0,k*.167]}><boxGeometry args={[.32,.34,.016]}/><meshStandardMaterial color="#a3c1c3" transparent opacity={.22} depthWrite={false}/></mesh>
   </group>)}
   <Part name="vessel identity rim" position={[0,.165,.16]} size={[.35,.016,.02]} color={i%2?'#b18d56':'#4f8784'}/>
  </Moving>)}
  {[1,2,3,4].map(i=><Moving key={i} r={r} id={'liquid'+i} scale><Part name="actual received liquid" size={[1,1,1]} color="#80afbc"/></Moving>)}
  <Rod r={r} from={()=>[0,1.60,-2.1]} to={()=>[0,2.30,-2.1]} radius={.017} color="#40535c"/>
  <Rod r={r} from={()=>[0,2.30,-2.1]} to={()=>[-.14,2.30,-2.1]} radius={.017} color="#40535c"/>
  <Rod r={r} from={()=>[-.14,2.30,-2.1]} to={()=>[-.14,2.30,.85]} radius={.017} color="#40535c"/>
  {[-.85,.85].map(z=><group key={z}>
   <Rod r={r} from={()=>[-.14,2.30,z]} to={()=>[-.14,1.98,z]} radius={.017} color="#40535c"/>
   <Rod r={r} from={()=>[-.14,1.98,z]} to={()=>[-.065,1.98,z]} radius={.017} color="#40535c"/>
  </group>)}
 </group>
}
export function MaterialRedesignHardware({plant,device}:DeviceProps){
 const mode=(device.visualVariant?.replace('cell3-r8-','')??'package') as Mode
 const r=plant as unknown as Reader,g=geometry[mode]
 if(!g)return null
 return <group name={'material-mini-process-r8-'+mode}>
  {g.boxes.map((b,i)=><Part key={'b'+i} name={b.name} position={b.pos as V} size={b.size as V} color={b.color}/>)}
  {g.cylinders.map((c,i)=><RoundPart key={'c'+i} name={c.name} position={c.pos as V} radius={c.radius} length={c.length} axis={c.axis as 'x'|'y'|'z'} color={c.color}/>)}
  {mode==='package'?<Package r={r}/>:mode==='branch'?<Branch r={r}/>:mode==='carrier'?<Carrier r={r}/>:<Measure r={r}/>}
 </group>
}
