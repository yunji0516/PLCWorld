'use client'
import { SuctionCup } from './SuctionCup'

import { useMemo, useRef, type ReactNode } from 'react'
import { useFrame } from '@react-three/fiber'
import { Html } from '@react-three/drei'
import { Group, Quaternion, Vector3 } from 'three'
import type { DeviceProps } from '../devices'
import type { MaterialHardState } from '@/lib/replay/adapter'
import { Part, RoundPart, FINISH } from './Parts'

type V = [number,number,number]
type Reader = { materialHardState(): MaterialHardState | undefined }
const blue='#407f9e', amber='#bd883d', pale='#d4dce0', dark=FINISH.dark
const P=Part, C=RoundPart

function Recorded({reader,node,scale=false,axis='y',children}:{reader:Reader;node:string;scale?:boolean;axis?:'y'|'z';children:ReactNode}) {
  const ref=useRef<Group>(null)
  useFrame(()=>{const p=reader.materialHardState()?.poses[node],g=ref.current;if(p&&g){g.position.fromArray(p.pos);g.rotation.set(0,0,0);g.rotation[axis]=p.yaw??0;if(scale&&p.size)g.scale.fromArray(p.size)}})
  return <group ref={ref} name={'material-priority-pose-'+node}>{children}</group>
}

function Label({at,children}:{at:V;children:ReactNode}) {
  return <Html position={at} center distanceFactor={6} zIndexRange={[20,0]} style={{pointerEvents:'none'}}><div style={{background:'rgba(247,250,252,.94)',border:'1px solid #ccd6df',borderRadius:5,padding:'4px 8px',fontSize:11,color:'#243d51',whiteSpace:'nowrap',boxShadow:'0 1px 3px #0001'}}>{children}</div></Html>
}

function Bar({a,b,r=.018,color=dark}:{a:V;b:V;r?:number;color?:string}) {
  const [mid,q,len]=useMemo(()=>{const x=new Vector3(...a),y=new Vector3(...b),d=y.clone().sub(x);return [x.add(y).multiplyScalar(.5),new Quaternion().setFromUnitVectors(new Vector3(0,1,0),d.clone().normalize()),d.length()] as const},[a[0],a[1],a[2],b[0],b[1],b[2]])
  return <group position={mid} quaternion={q}><C position={[0,0,0]} radius={r} length={len} axis="y" color={color}/></group>
}

function Foot({x,z,top=.75}:{x:number;z:number;top?:number}) {
  return <group><P name="floor-foot" position={[x,.035,z]} size={[.22,.07,.22]} color={dark}/><P name="frame-column" position={[x,(top+.07)/2,z]} size={[.075,top-.07,.075]} color={FINISH.alloy}/></group>
}

function Track({a,b,width=.42,top=.90,legs=true}:{a:V;b:V;width?:number;top?:number;legs?:boolean}) {
  const dx=b[0]-a[0],dz=b[2]-a[2],len=Math.hypot(dx,dz),angle=-Math.atan2(dz,dx),mid:V=[(a[0]+b[0])/2,top-.035,(a[2]+b[2])/2]
  return <group><group position={mid} rotation={[0,angle,0]}>
    <P name="belt-support-bed" position={[0,-.010,0]} size={[len,.058,width]} color={dark}/>
    <P name="conveyor-contact-surface" position={[0,.027,0]} size={[len,.016,width-.055]} color="#758a92"/>
    {[-1,1].map(k=><group key={k}><P name="belt-frame-side" position={[0,-.055,k*width/2]} size={[len,.075,.035]} color={FINISH.alloy}/><C name="belt-end-roller" position={[k*(len/2-.025),-.008,0]} radius={.027} length={width-.01} color={pale}/></group>)}
    <P name="belt-drive-motor" position={[-len/2+.10,-.065,width/2+.07]} size={[.17,.14,.12]} color={blue}/>
  </group>{legs&&[.18,.82].map(t=><Foot key={t} x={a[0]+dx*t} z={a[2]+dz*t} top={top-.07}/>)}</group>
}

function Stocks({reader,count,mode}:{reader:Reader;count:number;mode:string}) {
  return <>{Array.from({length:count},(_,j)=>{
    const i=j+1,initial=reader.materialHardState()?.parts[String(i)],color=mode==='stack'?(['',blue,pale,amber][typeof initial?.kind==='number'?initial.kind:1]):mode==='index'?(initial?.kind===1?blue:amber):i===1?blue:amber
    return <Recorded key={i} reader={reader} node={'part'+i} scale>
      <P name={'material-workpiece-'+i} size={[1,1,1]} color={color}/>
      <P name="identity-mark" position={[-.25,.505,-.16]} size={[.22,.012,.32]} color={pale}/>
    </Recorded>
  })}</>
}

function IndexCell({reader}:{reader:Reader}) {
  return <>
    <P name="index-drive-base" position={[0,.08,0]} size={[1.0,.16,1.0]} color={dark}/>
    <C name="index-drive-column" position={[0,.485,0]} radius={.32} length={.65} axis="y" color={blue}/>
    <Recorded reader={reader} node="table">
      <C name="common-index-table" position={[0,0,0]} radius={1.35} length={.09} axis="y" color={FINISH.alloy}/>
      <C name="index-centre-cap" position={[0,.055,0]} radius={.25} length={.02} axis="y" color={dark}/>
      {[0,1,2,3].map(i=><group key={i} position={[1.08*Math.cos(i*Math.PI/2),.065,1.08*Math.sin(i*Math.PI/2)]} rotation={[0,-i*Math.PI/2,0]}>
        {[-1,1].map(k=><P key={k} name="open-radial-pocket-guide" position={[0,0,k*.15]} size={[.32,.04,.035]} color={blue}/>)}
        <P name="pocket-number-tag" position={[-.22,-.012,0]} size={[.07,.012,.10]} color={i%2?amber:blue}/>
      </group>)}
    </Recorded>
    {(['a','b'] as const).map((s,j)=>{const sign=j===0?1:-1;return <group key={s}>
      <Foot x={-.25} z={sign*1.65} top={1.85}/><Foot x={.25} z={sign*1.65} top={1.85}/>
      <P name="head-overarm" position={[0,1.85,sign*1.35]} size={[.60,.12,.75]} color={dark}/>
      <P name="fixed-local-head-guide" position={[0,1.64,sign*1.08]} size={[.16,.35,.16]} color={blue}/>
      <Recorded reader={reader} node={'head_'+s}>
        <C name="local-service-stem" position={[0,.13,0]} radius={.035} length={.26} axis="y" color={FINISH.alloy}/>
        <P name="local-contact-head" size={[.19,.12,.19]} color={blue}/>
      </Recorded>
      <Label at={[.45,2.0,sign*1.50]}>{s.toUpperCase()} Workstation</Label>
    </group>})}
    <Track a={[-3.65,.9,0]} b={[-1.35,.9,0]} width={.43}/>
    <P name="radial-unload-housing" position={[-.39,.98,0]} size={[.56,.14,.16]} color={blue}/>
    <Recorded reader={reader} node="pusher"><P name="radial-unload-contact-blade" size={[.05,.14,.26]} color={pale}/></Recorded>
    <Recorded reader={reader} node="pusher_rod" scale><C name="radial-unload-rod" position={[0,0,0]} radius={.5} length={1} axis="x" color={FINISH.alloy}/></Recorded>
    <Label at={[-2.7,1.23,.34]}>Shared outfeed and receiving zone</Label>
    <Label at={[.7,.45,-.95]}>Shared four-pocket indexing</Label>
    <Stocks reader={reader} count={4} mode="index"/>
  </>
}

function RibbonSegment({reader,index}:{reader:Reader;index:number}) {
  const ref=useRef<Group>(null)
  useFrame(()=>{const q=reader.materialHardState(),g=ref.current;if(!q||!g)return;const points=q.web_path??[];let a:V|undefined=points[index],b:V|undefined=points[index+1];
    if(index===-1){const p=q.poses.source;a=[p.pos[0],p.pos[1]+(p.size?.[0]??.15),0];b=points[0]}
    if(index===-2){const p=q.poses.receiver;a=points.at(-1);b=[p.pos[0],p.pos[1]+(p.size?.[0]??.15),0]}
    if(!a||!b)return;g.position.set((a[0]+b[0])/2,(a[1]+b[1])/2,0);g.rotation.z=Math.atan2(b[1]-a[1],b[0]-a[0]);g.scale.set(Math.hypot(b[0]-a[0],b[1]-a[1]),1,1)
  })
  return <group ref={ref}><P name="continuous-material-span" size={[1,.006,.18]} color={amber}/></group>
}

function WebCell({reader}:{reader:Reader}) {
  return <>
    <P name="web-frame-plinth" position={[0,.06,-.10]} size={[4.8,.12,1.25]} color={dark}/>
    {[-1.9,1.9].map((x,j)=><group key={x}>
      <P name="reel-pedestal" position={[x,.66,-.40]} size={[.25,1.08,.16]} color={blue}/>
      <P name="reel-bearing-block" position={[x,1.25,-.40]} size={[.19,.16,.18]} color={FINISH.alloy}/>
      <Bar a={[x,1.25,-.43]} b={[x,1.25,.33]} r={.047} color={FINISH.alloy}/>
      <Recorded reader={reader} node={j===0?'source':'receiver'} scale axis="z">
        <C name="material-reel" position={[0,0,0]} radius={1} length={1} color={amber}/>
        {[-1,1].map(k=><C key={k} name="reel-flange" position={[0,0,k*.52]} radius={1.08} length={.04} color={FINISH.alloy}/>)}
        <P name="reel-rotation-mark" position={[.55,0,.55]} size={[.6,.065,.05]} color={dark}/>
      </Recorded>
      <Label at={[x,1.95,.32]}>{j===0?'Supply order · input roll':'Draw order · receiving roll'}</Label>
    </group>)}
    {[-.30,.30].map(x=><group key={x}><P name="dancer-column" position={[x,1.05,-.22]} size={[.065,1.86,.065]} color={FINISH.alloy}/><P name="dancer-guide-rail" position={[x,1.5,-.17]} size={[.035,.85,.035]} color={dark}/></group>)}
    <P name="dancer-top-crossmember" position={[0,2,-.22]} size={[.68,.10,.15]} color={blue}/>
    <Recorded reader={reader} node="dancer">
      <P name="dancer-moving-crosshead" position={[0,0,-.22]} size={[.68,.07,.13]} color={blue}/>
      {[-.075,.075].map(x=><group key={x}><Bar a={[x,0,-.23]} b={[x,0,.15]} r={.012} color={FINISH.alloy}/><C name="dancer-contact-roll" position={[x,0,0]} radius={.025} length={.22} color={FINISH.alloy}/></group>)}
    </Recorded>
    {[-.10,.10].map(x=><group key={x}><Bar a={[x,1.925,-.23]} b={[x,1.925,.14]} r={.011} color={dark}/><C name="upper-guide-roll" position={[x,1.925,0]} radius={.025} length={.22} color={FINISH.alloy}/></group>)}
    {Array.from({length:11},(_,i)=><RibbonSegment key={i} reader={reader} index={i}/>)}
    <RibbonSegment reader={reader} index={-1}/><RibbonSegment reader={reader} index={-2}/>
    <Label at={[0,.78,.24]}>Shared storage loop · 0.4–1.6 m</Label>
  </>
}

function VacuumCell({reader}:{reader:Reader}) {
  return <>
    {[-.85,.85].map((x,j)=>{const s=j===0?'a':'b';return <group key={s}>
      <P name="vacuum-lift-base" position={[x,.07,0]} size={[.62,.14,.67]} color={dark}/>
      <P name="lift-cylinder-body" position={[x,.38,0]} size={[.18,.46,.18]} color={blue}/>
      <Recorded reader={reader} node={'lift_'+s}>
        <P name="receiving-support-plate" size={[.48,.06,.40]} color={FINISH.alloy}/>
        <C name="lift-piston-rod" position={[0,-.25,0]} radius={.034} length={.50} axis="y" color={FINISH.alloy}/>
      </Recorded>
      {[-.30,.30].map(z=><group key={z}><Foot x={x} z={z} top={1.56}/><Bar a={[x-.26,1.56,z]} b={[x+.26,1.56,z]} r={.025} color={dark}/></group>)}
      <P name="pad-overhead-support" position={[x,1.52,0]} size={[.52,.10,.68]} color={blue}/>
      <C name="vacuum-pad-stem" position={[x,1.35,0]} radius={.035} length={.30} axis="y" color={FINISH.alloy}/>
      <SuctionCup name="fixed-vacuum-pad" position={[x,1.2125,0]} radius={.125} height={.025}/>
      <Track a={[j===0?-2.9:1.09,.70,0]} b={[j===0?-1.09:2.9,.70,0]} top={.70} width={.43}/>
      <P name="branch-isolation-valve" position={[x,1.65,-.12]} size={[.14,.13,.15]} color={amber}/>
      <P name="local-vent-valve" position={[x+.20,1.65,.12]} size={[.12,.12,.13]} color={blue}/>
      <Recorded reader={reader} node={'isolate_'+s}><P name="isolation-valve-handle" size={[.19,.035,.035]} color={dark}/></Recorded>
      <Recorded reader={reader} node={'vent_'+s}><P name="vent-valve-handle" size={[.17,.035,.035]} color={dark}/></Recorded>
      <Bar a={[0,1.65,-.12]} b={[x,1.65,-.12]} r={.016} color="#447da0"/>
      <Bar a={[x,1.65,-.12]} b={[x,1.35,0]} r={.013} color="#447da0"/>
      <Bar a={[x+.20,1.65,.12]} b={[x,1.35,0]} r={.010} color={amber}/>
      <Label at={[x,1.98,.16]}>{s.toUpperCase()} Vacuum pickup and lift handover</Label>
    </group>})}
    <P name="pump-skid" position={[0,.07,-.85]} size={[.65,.14,.75]} color={dark}/>
    <C name="common-vacuum-reservoir" position={[0,.38,-.85]} radius={.20} length={.55} color={FINISH.alloy}/>
    <P name="vacuum-pump" position={[0,.20,-1.24]} size={[.32,.28,.25]} color={blue}/>
    <Bar a={[0,.38,-.85]} b={[0,1.65,-.85]} r={.022} color="#447da0"/>
    <Bar a={[0,1.65,-.85]} b={[0,1.65,-.12]} r={.022} color="#447da0"/>
    <Label at={[0,.80,-1.1]}>Shared vacuum source</Label>
    <Stocks reader={reader} count={2} mode="vacuum"/>
  </>
}

function StackCell({reader}:{reader:Reader}) {
  return <>
    {[-.65,0,.65].map((x,j)=><group key={x}>
      <Track a={[x,.9,-3]} b={[x,.9,-1.3]} width={.44}/>
      <Track a={[x,.9,-1.4]} b={[0,.9,-.6]} width={.43} legs={false}/>
      <P name="single-feed-metering-gate" position={[x,.79,-1.32]} size={[.42,.16,.08]} color={blue}/>
      <Label at={[x,1.24,-2.80]}>Type {j+1} supply</Label>
    </group>)}
    <Track a={[0,.9,-.60]} b={[0,.9,0]} width={.43}/>
    <Label at={[.52,1.25,-.50]}>Shared single-sheet path</Label>
    {[-1,1].map((x,j)=>{const s=j===0?'a':'b';return <group key={s}>
      <Track a={[0,.9,0]} b={[x*.68765,.9,.55012]} width={.43} legs={false}/>
      <P name="stack-lift-plinth" position={[x,.065,.80]} size={[.67,.13,.67]} color={dark}/>
      <P name="stack-lift-drive" position={[x,.38,.80]} size={[.20,.50,.20]} color={blue}/>
      <Recorded reader={reader} node={'lift_'+s}>
        <P name="stack-support-platen" size={[.55,.07,.55]} color={FINISH.alloy}/>
        <C name="stack-lift-rod" position={[0,-.21,0]} radius={.038} length={.42} axis="y" color={FINISH.alloy}/>
      </Recorded>
      <Track a={[x,.74,1.08]} b={[x,.74,2.16]} width={.53} top={.74}/>
      <Label at={[x*1.40,1.13,1.25]}>Order {s.toUpperCase()} · Layer stacking</Label>
    </group>})}
    <Stocks reader={reader} count={8} mode="stack"/>
  </>
}

export function MaterialHardPriorityHardware({device,plant}:DeviceProps) {
  const reader=plant as unknown as Reader,mode=device.visualVariant?.replace('cell3-priority-','')
  return <group name={'material-priority-cell-'+mode}>
    {mode==='index'?<IndexCell reader={reader}/>:mode==='web'?<WebCell reader={reader}/>:mode==='vacuum'?<VacuumCell reader={reader}/>:<StackCell reader={reader}/>}
  </group>
}
