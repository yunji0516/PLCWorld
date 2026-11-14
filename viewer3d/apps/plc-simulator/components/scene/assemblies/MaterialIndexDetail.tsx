'use client'

import {useRef, type RefObject} from 'react'
import {useFrame} from '@react-three/fiber'
import {Group, LatheGeometry, Vector2} from 'three'
import {RoundDriveCasting} from './RoundDriveCasting'
import {Part, RoundPart} from './Parts'
import {BoredHub, Profile} from './MaterialV6Details'
import {SocketBolt} from '../IndustrialDetails'
import type {Node, Frame} from '@/app/replay/hard-processes/ReviewCanvas'

const steel='#bac4c9', dark='#34434e', blue='#486d7c', seal='#242e34'
type V=[number,number,number]
function Box({p,s,c=steel,n}:{p:V;s:V;c?:string;n:string}){
 return <Part name={'index-detail-'+n} position={p} size={s} color={c}/>
}
function Disc({p,r,h,c=steel}:{p:V;r:number;h:number;c?:string}){
 return <RoundPart name="index-detail-machined-flange" position={p} radius={r} length={h} axis="y" color={c} segments={64} matte/>
}
function BoltCircle({r,y,n=8,size=.006}:{r:number;y:number;n?:number;size?:number}){
 return <>{Array.from({length:n},(_,i)=><SocketBolt key={i} top position={[r*Math.cos(i*2*Math.PI/n),y,r*Math.sin(i*2*Math.PI/n)]} radius={size}/>)}</>
}
function Ring({r,inner,y,h}:{r:number;inner:number;y:number;h:number}){
 return <group name="index-detail-machined-ring"><BoredHub p={[0,y,0]} outer={r} inner={inner} height={h} matte/></group>
}

/** E06 is mechanically locked: no motor or independent rotation is invented. */
export function EasyIndexBaseDetail(){return <group name="index-detail-e06-fixed-body">
 <Box n="locking-bracket" p={[.16,.6475,.22]} s={[.12,.065,.09]} c={dark}/>
 <Disc p={[.16,.69,.22]} r={.014} h={.020}/>
 {/* Fixed service duct attaches to the existing slide. */}
 <Box n="eject-axis-fixed-service-cover" p={[-.60,1.01,-.232]} s={[1.02,.032,.021]} c={dark}/>
</group>}

/** Local decoration stays outside the .10 m product and the open eject corridor. */
export function EasyIndexTableDetail(){return <group name="index-detail-e06-fixtures">
 {[0,1,2,3].map(i=><group key={i} position={[.52*Math.cos(i*Math.PI/2),.027,.52*Math.sin(i*Math.PI/2)]} rotation={[0,-i*Math.PI/2,0]}>
  {[-1,1].map(k=><group key={k}>
   <Box n="replaceable-pocket-wear-strip" p={[0,.026,k*.0625]} s={[.148,.025,.005]} c={seal}/>
   {[-.053,.053].map(x=><SocketBolt key={x} top position={[x,.04805,k*.073]} radius={.0035}/>)}
   <Box n="pocket-locating-lug" p={[-.045,-.006,k*.09]} s={[.055,.015,.022]} c={steel}/>
  </group>)}
 </group>)}
</group>}

export function EjectorCarriageDetail(){return <group name="index-detail-eject-carriage">
 <Box n="ejector-face-insert" p={[-.1685,0,0]} s={[.003,.065,.066]} c={seal}/>
 {[-.10,.10].map(x=><SocketBolt key={x} top position={[x,.262,-.18]} radius={.004}/>)}
 <Box n="ejector-bearing-wiper" p={[.153,.23,-.18]} s={[.006,.054,.10]} c={seal}/>
</group>}

/** Shared M14 pedestal; only height varies with the task's working plane. */
export function RotaryPedestal({top=.638}:{top?:number}){return <group name="rotary-table-pedestal">
 <Disc p={[0,.0325,0]} r={.34} h={.065} c={dark}/><BoltCircle r={.285} y={.0685} n={6} size={.008}/>
 <RoundDriveCasting bottom={.065} top={top-.02} radius={.208}/>
 <Disc p={[0,top-.01,0]} r={.25} h={.02}/>

</group>}

/** M14 fixed drive housing and track datum; part and receiver poses are untouched. */
export function InterceptBaseDetail(){return <group name="index-detail-m14-fixed-body">
 <group position={[.9,0,0]}>
  <Disc p={[0,.687,0]} r={.205} h={.024} c={dark}/><Disc p={[0,.703,0]} r={.16} h={.008}/>
  <BoltCircle r={.125} y={.709} n={8} size={.005}/>
  <Ring r={.57} inner={.555} y={.677} h={.004}/>
  <BoltCircle r={.515} y={.679} n={12} size={.004}/>
 </group>
 {/* Precision side strips end before the moving receiver envelope. */}
 {[-1,1].map(k=><group key={k}>
  <Box n="launch-bed-side-strip" p={[-.40,.813,k*.085]} s={[1.0,.014,.01]} c={dark}/>
  {[-.83,-.43,-.03].map(x=><SocketBolt key={x} top position={[x,.822,k*.085]} radius={.003}/>)}
 </group>)}
 <Box n="launch-axis-service-channel" p={[-.45,.830,-.354]} s={[.88,.03,.02]} c={dark}/>
 {[-.075,.875].map(z=><Box key={z} n="feed-axis-end-cap" p={[-.91,.888,z]} s={[.091,.08,.019]} c={steel}/>)}
 <Box n="feed-fixed-terminal-box" p={[-.965,.865,.72]} s={[.035,.07,.10]} c={dark}/>
 <Box n="feed-terminal-connector" p={[-.941,.865,.72]} s={[.013,.025,.03]} c={steel}/>
</group>}

export function InterceptPocketDetail(){return <group name="index-detail-m14-receiver">
 {[-1,1].map(k=><group key={k}>
  <Box n="pocket-guide-liner" p={[.04,.061,k*.078]} s={[.154,.034,.004]} c={seal}/>
  {[-.015,.095].map(x=><SocketBolt key={x} top position={[x,.092,k*.095]} radius={.0035}/>)}
  {/* Seat ends at the deck underside (-.04); the bore clears the support ball.
      A solid block formerly penetrated the deck and the top of the ball. */}
  <group name="index-detail-track-ball-seat"><BoredHub p={[0,-.0445,k*.035]} outer={.0185} inner={.0142} height={.009}/></group>
 </group>)}
 {/* The former rear backing was inside the deck with an identical x=.12
     outer face. Omit that duplicate surface rather than offsetting the pocket. */}
</group>}

export function IndexControlCabinetBase(){return <group name="index-detail-h05-control-cabinet-base">
 <Box n="cabinet-floor-plinth" p={[-.95,.115,.68]} s={[.36,.18,.21]} c={dark}/>
 <Box n="cabinet-plinth-top-flange" p={[-.95,.21,.68]} s={[.40,.01,.25]} c={steel}/>
 <Box n="cabinet-floor-baseplate" p={[-.95,.0125,.68]} s={[.44,.025,.29]} c={dark}/>
 {[-1,1].flatMap(x=>[-1,1].map(z=><SocketBolt key={`${x}:${z}`} top position={[-.95+x*.20,.026,.68+z*.123]} radius={.006}/>))}
</group>}

/** Move only the rework mechanism's support rail away from the return head's
 * vertical path. The tool, clamp jaw and workpiece keep their recorded poses. */
export function IndexReworkSupports({frame}:{frame:RefObject<Frame>}){
 const carriage=useRef<Group>(null),liftRod=useRef<Group>(null),arm=useRef<Group>(null),clampRod=useRef<Group>(null)
 useFrame(()=>{
  const grip=frame.current.poses.repair_grip?.p ?? [-1.2,1.7,-.9]
  const jaw=frame.current.poses.repair_clamp?.p ?? [-1.04,.91,-.9]
  carriage.current?.position.set(grip[0],1.834,-.65)
  arm.current?.position.set(grip[0],grip[1],grip[2])
  const bottom=grip[1]+.05,top=1.8175
  if(liftRod.current){liftRod.current.position.set(grip[0],(top+bottom)/2,-.71);liftRod.current.scale.y=Math.max(.001,top-bottom)}
  const start=-1.11,end=jaw[0]-.02
  if(clampRod.current){clampRod.current.position.set((start+end)/2,jaw[1],jaw[2]);clampRod.current.scale.x=Math.max(.001,end-start)}
 })
 return <group name="index-detail-h05-rework-supports">
  <Box n="rework-jig-subplate" p={[-.995,.79625,-.9]} s={[.57,.0375,.33]} c={steel}/>
  <Box n="rework-cylinder-bracket" p={[-1.19,.845,-.9]} s={[.13,.06,.09]} c={blue}/>
  <RoundPart name="index-detail-rework-clamp-cylinder" position={[-1.19,.91,-.9]} radius={.035} length={.16} axis="x" color={blue}/>
  <group ref={clampRod}><RoundPart name="index-detail-rework-clamp-rod" position={[0,0,0]} radius={.009} length={1} axis="x"/></group>
  {[-1.235,-1.145].map(x=><SocketBolt key={x} top position={[x,.877,-.935]} radius={.004}/>)}
  <Box n="rework-post-foot" p={[-1.33,.02,-.65]} s={[.105,.04,.105]} c={dark}/>
  <Profile p={[-1.33,.90125,-.65]} length={1.7225} edge={.035}/>
  <Box n="rework-offset-rail" p={[-1.08,1.79,-.65]} s={[.535,.055,.055]} c={steel}/>
  <group ref={carriage}>
   <Box n="rework-guide-carriage" p={[0,0,-.0275]} s={[.16,.033,.17]} c={blue}/>
   {[-.05,.05].map(x=><SocketBolt key={x} top position={[x,.018,0]} radius={.004}/>)}
  </group>
  <group ref={liftRod}><RoundPart name="index-detail-rework-offset-lift-rod" position={[0,0,0]} radius={.014} length={1} axis="y"/></group>
  <group ref={arm}>
   <Box n="rework-tool-connecting-arm" p={[0,.04,.095]} s={[.05,.02,.24]} c={steel}/>
   <Box n="rework-tool-flange" p={[0,.025,0]} s={[.05,.01,.05]} c={blue}/>
  </group>
 </group>
}

/** Stepped tooling is machined inside the original cylinder envelope. The
 * contact plane, maximum radius and recorded articulation remain identical. */
export function indexToolGeometry(node:Node){
 if(!['load_pad','insert_pad','probe_body'].includes(node.id))return null
 const profile=node.id==='load_pad'
  ? [[0,-.5],[1,-.5],[1,-.39],[.76,-.30],[.55,-.20],[.55,.23],[.82,.28],[.82,.43],[.70,.5],[0,.5]]
  : [[0,-.5],[.72,-.5],[.72,-.35],[.88,-.30],[.88,.30],[1,.35],[1,.46],[.78,.5],[0,.5]]
 return new LatheGeometry(profile.map(([r,y])=>new Vector2(r,y)),48)
}

/** H05 v17 uses the recorded node scene, not the retired six-pocket renderer.
 * Every added piece follows its owning node, including visibility/rewinding.
 * Only non-contact faces receive covers; guides retain their canonical bores.
 */
export function IndexStationNodeDetail({node,frame}:{node:Node;frame:RefObject<Frame>}){
 const ref=useRef<Group>(null)
 useFrame(()=>{if(ref.current)ref.current.visible=frame.current.poses[node.id]?.visible??node.visible??true})
 const [w,h,d]=node.size,id=node.id
 let content=null
 // The replacement supply cases already reach the fixture underside.
 // The old shim occupied the same volume as the new case top.
 if(id==='table_ring')content=<>
  <Ring r={.29} inner={.26} y={.043} h={.006}/>
  <BoltCircle r={.277} y={.048} n={8} size={.006}/>
  <BoltCircle r={.573} y={.043} n={12} size={.005}/>
 </>
 else if(/^pocket\dguide/.test(id))content=<>
  {[-.067,.067].map(x=><SocketBolt key={x} top position={[x,h/2+.002,0]} radius={.0035}/>)}
 </>
 else if(/^(load_carriage|insert_carriage|repair_grip_slide|return_head_slide)$/.test(id))content=<>
  <Box n="slide-front-cover" p={[0,0,d/2+.0025]} s={[w*.88,h*.82,.005]} c={steel}/>
  {[-1,1].map(x=><SocketBolt key={x} position={[x*w*.31,0,d/2+.006]} radius={.0035}/>)}
  <Box n="slide-side-wiper" p={[w/2+.002,0,0]} s={[.004,h*.9,d*.90]} c={seal}/>
 </>
 else if(/^(load_pad|insert_pad|probe_body)$/.test(id))content=<>
  <Ring r={w+.0035} inner={w+.0002} y={h*.32} h={h*.12}/>
  <Ring r={w+.0035} inner={w+.0002} y={-h*.32} h={h*.12}/>
  <Box n="actuator-port" p={[w+.008,0,0]} s={[.016,.017,.017]} c={steel}/>
 </>
 else if(/^index_drive_panel\d$/.test(id))content=<>
  {[-1,1].flatMap(x=>[-1,1].map(y=><SocketBolt key={`${x}:${y}`} position={[x*(w/2-.032),y*(h/2-.032),d/2+.002]} radius={.005}/>))}
 </>
 else if(/^(loader_cell|insert_supply_cell|inspection_cell)_door1$/.test(id))content=<>
  <Box n="cabinet-identification-plate" p={[-w*.22,h*.32,d/2+.002]} s={[Math.min(.10,w*.28),.037,.003]} c={blue}/>
  {[.065,-.065].map(y=><Box key={y} n="cabinet-hinge" p={[-w/2+.027,y,d/2+.007]} s={[.017,.055,.012]} c={steel}/>)}
 </>
 else if(id==='eject_motor')content=<>
  <Box n="ejector-end-cover" p={[0,0,d/2+.003]} s={[w*.9,h*.9,.006]} c={steel}/>
  {[-1,1].map(x=><SocketBolt key={x} position={[x*w*.3,0,d/2+.007]} radius={.004}/>)}
 </>
 return content?<group name="index-detail-h05-node" ref={ref}>{content}</group>:null
}

/** H05 tooling-ring silhouette adapted to the existing .78 m contact plane. */
export function CarouselToolingRing(){return <group name="carousel-h05-tooling-ring">
 <group position={[0,-.02,0]}><BoredHub p={[0,0,0]} outer={.62} inner={.20} height={.08} matte/></group>
 <Ring r={.29} inner={.26} y={.023} h={.006}/>
 <BoltCircle r={.277} y={.0278} n={8} size={.006}/>
 <BoltCircle r={.573} y={.0215} n={12} size={.005}/>
</group>}
