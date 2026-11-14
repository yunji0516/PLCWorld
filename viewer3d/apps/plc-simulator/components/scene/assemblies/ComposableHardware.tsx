'use client'
import {useRef} from 'react'
import {useFrame} from '@react-three/fiber'
import {Group} from 'three'
import type {DeviceProps} from '../devices'
import {Part,RoundPart} from './Parts'
import type {MaterialHardState} from '@/lib/replay/adapter'
const blue='#477c90',dark='#344a56',silver='#b1bdc5'
type Reader={materialHardState():MaterialHardState|undefined}
/** Only module kinds and dimensions dispatch geometry; never a task identifier. */
export function ComposableHardware({device,plant}:DeviceProps){
 const r=plant as unknown as Reader,kind=device.visualVariant?.slice('cell3-composable-'.length),moving=useRef<Group>(null),rod=useRef<Group>(null)
 const [length,height,width]=device.size
 useFrame(()=>{const s=r.materialHardState();if(!s)return
  if(kind==='part'){const p=s.poses[device.id];if(moving.current&&p)moving.current.position.fromArray(p.pos)}
  else if(kind==='receiver'){
   const z=s.poses[device.id+'_clamp']?.pos[2]??.19
   moving.current?.position.set(0,height+.06,z)
   if(rod.current){rod.current.position.set(0,height+.06,(z+.01+.30)/2);rod.current.scale.z=Math.max(.001,.30-z-.01)}
  }
 })
 if(kind==='part')return <group name={'composable-hardware-'+device.id} ref={moving}>
  <Part name="identified-workpiece" size={[length,height,width]} color={Number(device.id.replace('part',''))%2? '#c0a16c':'#75a29d'}/>
  <Part name="workpiece-identification-plate" position={[0,height/2+.002,0]} size={[.07,.004,.07]} color="#e4ecee"/>
 </group>
 return <group name={'composable-hardware-'+device.id}>
  <Part name="module-underframe" position={[0,height-.075,0]} size={[length,.10,width]} color={dark}/>
  <Part name={kind==='transfer'?'directional-transfer-support-deck':'driven-conveyor-surface'} position={[0,height-.013,0]} size={[length,.026,width-.02]} color={kind==='transfer'?silver:'#738b95'}/>
  {[-1,1].flatMap(x=>[-1,1].map(z=><group key={x+':'+z}>
   <Part name="connected-frame-leg" position={[x*(length/2-.11),(height-.12)/2,z*(width/2-.065)]} size={[.055,height-.12,.055]} color={silver}/>
   <Part name="leveling-foot" position={[x*(length/2-.11),.024,z*(width/2-.065)]} size={[.13,.048,.13]} color={dark}/>
  </group>))}
  {[-1,1].map(k=><group key={k}>
   <Part name="side-channel" position={[0,height-.075,k*(width/2+.014)]} size={[length,.10,.028]} color={silver}/>
   {kind!=='transfer'&&<RoundPart name="end-drum" position={[k*(length/2-.03),height-.03,0]} radius={.028} length={width-.035} axis="z" color={silver}/>}
  </group>)}
  <Part name="coupled-drive-motor" position={[0,height-.095,width/2+.13]} size={[.16,.15,.19]} color={blue}/>
  <RoundPart name="drive-shaft" position={[0,height-.08,width/2+.04]} radius={.016} length={.12} axis="z" color={silver}/>
  {kind==='transfer'&&<>
   <Part name="transverse-drive-motor" position={[length/2+.12,height-.14,0]} size={[.18,.13,.16]} color={blue}/>
   <RoundPart name="transverse-drive-shaft" position={[length/2+.04,height-.14,0]} radius={.016} length={.12} axis="x" color={silver}/>
  </>}
  {/* Opposed detector and reflector mounted on the same physical frame. */}
  {[-1,1].map(k=><group key={'sensor'+k}>
   <Part name="photoeye-connected-bracket" position={[-length*.23,height+.035,k*(width/2+.04)]} size={[.04,.20,.045]} color={silver}/>
   <Part name={k===1?'photoeye':'reflector'} position={[-length*.23,height+.13,k*(width/2+.01)]} size={[.065,.07,.032]} color={k===1?dark:'#bbbba3'}/>
  </group>)}
  {kind==='receiver'&&<>
   <Part name="fixed-jaw" position={[0,height+.06,-.10]} size={[.20,.085,.02]} color={dark}/>
   <Part name="fixed-jaw-support" position={[0,height-.014,-.15]} size={[.13,.12,.07]} color={silver}/>
   <Part name="clamp-cylinder" position={[0,height+.06,.39]} size={[.14,.12,.18]} color={blue}/>
   <Part name="clamp-cylinder-support" position={[0,height-.055,.39]} size={[.14,.12,.14]} color={silver}/>
   <Part name="clamp-frame-outrigger" position={[0,height-.12,.20]} size={[.20,.055,.51]} color={silver}/>
   <group ref={moving}><Part name="moving-jaw" size={[.20,.085,.02]} color={dark}/></group>
   <group ref={rod}><RoundPart name="connected-clamp-rod" position={[0,0,0]} radius={.014} length={1} axis="z" color={silver}/></group>
  </>}
 </group>
}
