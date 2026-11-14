'use client'
import {useRef} from 'react'
import {useFrame} from '@react-three/fiber'
import type {Group} from 'three'
import type {DeviceProps} from '../devices'
import {Part,RoundPart} from './Parts'
import {TendingPlate} from './TendingHardware'
type V=[number,number,number]
const B=({p,s,c='#9cabb2',name}:{p:V;s:V;c?:string;name?:string})=><Part name={name} position={p} size={s} color={c}/>
const R=({p,r,l,axis='y',c='#8c9fa9'}:{p:V;r:number;l:number;axis?:'x'|'y'|'z';c?:string})=><RoundPart position={p} radius={r} length={l} axis={axis} color={c}/>

export function MaterialHard15V4Hardware({device,plant}:DeviceProps){
 const root=useRef<Group>(null),upper=useRef<Group>(null),lower=useRef<Group>(null)
 const v=device.visualVariant??'',[w,h,d]=device.size
 useFrame(()=>{
  if(v!=='cell3-scara'||!upper.current||!lower.current)return
  const tool=plant.machine.devices.find(x=>x.id==='TOOL')
  if(!tool)return
  const dx=tool.pos[0]-device.pos[0],dz=tool.pos[2]-device.pos[2],r2=dx*dx+dz*dz,L=w
  const beta=-Math.acos(Math.max(-1,Math.min(1,(r2-2*L*L)/(2*L*L))))
  const theta=Math.atan2(dz,dx)-Math.atan2(L*Math.sin(beta),L+L*Math.cos(beta))
  const ex=L*Math.cos(theta),ez=L*Math.sin(theta)
  upper.current.rotation.y=-theta
  lower.current.position.set(ex,0,ez);lower.current.rotation.y=-(theta+beta)
  if(root.current)root.current.userData.ikError=Math.hypot(ex+L*Math.cos(theta+beta)-dx,ez+L*Math.sin(theta+beta)-dz)
 })
 if(v==='cell3-scara')return <group ref={root} name="hard15-v4-scara">
  <B p={[0,-.11,0]} s={[.38,.08,.40]} c="#516b79"/>
  <R p={[0,.025,0]} r={.15} l={.29} c="#b5a65b"/>
  <group ref={upper}>
   <B name="scara-upper-arm" p={[w/2,.16,0]} s={[w,.14,.24]} c="#d3c27a"/>
   <B p={[w/2,.236,0]} s={[w-.15,.012,.13]} c="#727c7e"/>
   <R p={[w,.08,0]} r={.14} l={.32} c="#637f8e"/>
  </group>
  <group ref={lower}>
   <B name="scara-forearm" p={[w/2,0,0]} s={[w,.14,.20]} c="#ccd2d3"/>
   <B p={[w/2,.076,0]} s={[w-.16,.012,.09]} c="#596f7b"/>
   <R p={[w,0,0]} r={.115} l={.18} c="#536c7a"/>
  </group>
 </group>
 if(v==='cell3-arm-mast')return <group>
  <B p={[0,0,0]} s={[w,h,d]} c="#506d7c"/>
  <B p={[0,-h/2+.035,0]} s={[.62,.07,.62]} c="#758890"/>
  <B p={[0,.05,-d/2-.012]} s={[w*.7,h-.22,.022]} c="#aab5ba"/>
  <B p={[0,h/2-.04,0]} s={[.36,.08,.36]} c="#849ba6"/>
 </group>
 if(v==='cell3-rear-track')return <group>
  <B p={[0,0,0]} s={[w,h,d]} c="#748c99"/>
  {[-1,1].map(k=><B key={k} p={[0,h/2+.01,k*.065]} s={[w-.1,.02,.025]} c="#c7ced2"/>)}
  <B p={[w/2+.04,0,0]} s={[.16,.22,.22]} c="#455d6a"/>
 </group>
 if(v==='cell3-cantilever')return <group>
  <B p={[0,0,0]} s={[w,h,d]} c="#c3cacc"/>
  {[-1,1].map(k=><B key={k} p={[k*(w/2+.01),-.05,0]} s={[.02,.035,d-.1]} c="#748c98"/>)}
  <B name="rear-x-truck" p={[0,-.12,d/2-.10]} s={[.48,.06,.42]} c="#5d7b8d"/>
  <R p={[0,0,d/2+.08]} r={.075} l={.16} axis="z" c="#496675"/>
 </group>
 if(v==='cell3-z-saddle')return <group>
  <B p={[0,-.07,0]} s={[.36,.045,.28]} c="#587487"/>
  {[-1,1].map(k=><B key={k} p={[k*.142,.015,0]} s={[.035,.17,.28]} c="#8aa0ac"/>)}
 </group>
 if(v.startsWith('cell3-bank-')){
  const style=v.slice(11),open=['order','carrier','exchange','sorter'].includes(style),mobile=style==='magazine'
  const skin=style==='quarantine'?'#d5c9a7':style==='web'?'#9ca99e':style==='weigh'?'#c3c9c7':style==='batch'?'#b4c5cc':'#a8bbc5'
  return <group name={'hard15-v4-integrated-'+style}>
   {[-1,1].flatMap(x=>[-1,1].map(z=><group key={`${x}:${z}`}>
    {mobile?<><R p={[x*(w/2-.09),-.33,z*(d/2-.09)]} r={.07} l={.045} axis="x" c="#35464e"/><B p={[x*(w/2-.09),-.23,z*(d/2-.09)]} s={[.08,.10,.08]}/></>:
     <R p={[x*(w/2-.08),-.36,z*(d/2-.08)]} r={.055} l={.08} c="#354c59"/>}
    {open&&<B p={[x*(w/2-.06),0,z*(d/2-.06)]} s={[.055,.72,.055]} c="#64808f"/>}
   </group>))}
   {open?<>
    {[-1,1].map(k=><B key={k} p={[0,.38,k*(d/2-.04)]} s={[w,.04,.08]} c="#7f929c"/>)}
    {[-1,1].map(k=><B key={k} p={[k*(w/2-.04),.38,0]} s={[.08,.04,d]} c="#7f929c"/>)}
    <B p={[0,-.17,0]} s={[w-.09,.035,d-.09]} c="#8397a1"/>
    {style==='sorter'&&Array.from({length:4},(_,i)=><B key={i} p={[0,-.06,-d/2+.3+i*(d-.6)/3]} s={[w-.1,.18,.015]} c="#aab8be"/>)}
   </>:<>
    <B p={[0,mobile?.094:.034,0]} s={[w,mobile?.588:.708,d]} c={skin}/>
    <B p={[0,.394,0]} s={[w,.012,d]} c="#9aaab0"/>
    {Array.from({length:Math.max(1,Math.ceil(w/.7))},(_,i)=>{const count=Math.ceil(w/.7),cw=w/count;return <group key={i}>
     <B p={[-w/2+cw*(i+.5),.02,-d/2-.004]} s={[cw-.025,.48,.008]} c="#8499a2"/>
     <B p={[-w/2+cw*(i+.5)+cw*.30,.07,-d/2-.025]} s={[.015,.15,.025]} c="#354e5c"/>
    </group>})}
   </>}
   <TendingPlate label={device.label} position={[0,.31,-d/2-.012]} size={[Math.min(w-.06,1.2),.095]}/>
  </group>
 }
 if(v==='cell3-roller-port'||v==='cell3-deck-port')return <group name="hard15-v4-mounted-material-port">
  {v==='cell3-roller-port'?<>
   <B p={[0,.37,0]} s={[w,.04,d]} c="#6c8796"/>
   {Array.from({length:10},(_,i)=><R key={i} p={[0,.43,-d/2+.035+i*(d-.07)/9]} r={.02} l={w-.08} axis="x" c="#b8c2c7"/>)}
   {[-1,1].map(k=><B key={k} p={[k*(w/2-.015),.418,0]} s={[.03,.064,d]} c="#708d9e"/>)}
  </>:<>
   <B p={[0,.4275,0]} s={[w,.045,d]} c="#bdc7cb"/>
   {[-1,1].flatMap(x=>[-1,1].map(z=><B key={`${x}:${z}`} p={[x*.19,.375,z*.25]} s={[.04,.06,.04]} c="#688291"/>))}
  </>}
  <B p={[0,.385,-d/2+.02]} s={[w-.1,.030,.040]} c="#81959f"/>
  <TendingPlate label={device.label} position={[0,.32,-d/2-.004]} size={[w-.025,.075]}/>
 </group>
 if(v==='cell3-recovery-v4'||v==='cell3-quarantine-v4'){
  const cage=v==='cell3-quarantine-v4'
  return <group name={cage?'hard15-v4-approval-locker':'hard15-v4-return-bin'}>
   <B p={[0,.005,.04]} s={[.55,.51,.045]} c={cage?'#bba77a':'#b99269'}/>
   {[-1,1].map(k=><group key={k}>
    <B p={[k*.26,.005,-.29]} s={[.025,.51,.64]} c={cage?'#8499a2':'#be9f7c'}/>
    {cage&&Array.from({length:6},(_,i)=><B key={i} p={[k*.276,.005,-.55+i*.1]} s={[.007,.39,.02]} c="#4b6370"/>)}
   </group>)}
   <B p={[0,-.225,-.62]} s={[.50,.05,.025]} c="#8b775c"/>
   <TendingPlate label={cage?'ID / RELEASE':'RETURN'} position={[0,.18,.012]} size={[.32,.10]}/>
   {cage&&<R p={[.18,.18,.007]} r={.025} l={.018} axis="z" c="#ba8b47"/>}
  </group>
 }
 if(v==='cell3-magazine-v4')return <group name="hard15-v4-cassette-bay">
  <B p={[0,.05,0]} s={[.52,.60,.14]} c="#768b97"/>
  {[-.14,0,.14,.28].map(y=><group key={y}><B p={[0,y,-.085]} s={[.40,.075,.03]} c="#344e5b"/><B p={[0,y-.045,-.11]} s={[.42,.018,.085]} c="#b4c1c8"/></group>)}
  {[-1,1].map(k=><B key={k} p={[k*.245,.045,-.07]} s={[.03,.59,.03]} c="#bac4c9"/>)}
  <TendingPlate label="CASSETTE" position={[0,.35,-.015]} size={[.38,.075]}/>
 </group>
 if(v==='cell3-scale-v4')return <group name="hard15-v4-loadcell-platform">
  <B p={[0,-.335,-.34]} s={[.32,.03,.26]} c="#647d8b"/>
  <R p={[0,-.3075,-.34]} r={.10} l={.025} c="#9aa9af"/>
  <B p={[0,-.035,0]} s={[.06,.43,.08]} c="#78929f"/>
  <B p={[0,.205,-.01]} s={[.42,.15,.065]} c="#5c7582"/>
  <TendingPlate label="NET / kg" position={[0,.205,-.045]} size={[.36,.105]}/>
 </group>
 if(v==='cell3-reel-v4')return <group name="hard15-v4-reel-cradle">
  <B p={[0,-.15,0]} s={[.49,.20,.12]} c="#799084"/>
  {[-1,1].map(k=><B key={k} p={[k*.20,.05,0]} s={[.045,.25,.10]} c="#a3b0aa"/>)}
  <R p={[0,.07,-.015]} r={.085} l={.14} axis="z" c="#7c9084"/>
  <R p={[0,.07,-.10]} r={.035} l={.05} axis="z" c="#bcc6c4"/>
 </group>
 return <B p={[0,0,0]} s={[w,h,d]}/>
}
