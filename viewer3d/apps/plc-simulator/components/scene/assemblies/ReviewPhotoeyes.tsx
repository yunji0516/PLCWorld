import type {Node,V3} from '@/app/replay/hard-processes/ReviewCanvas'
import {Part,RoundPart,FINISH} from './Parts'
import {SocketBolt} from '../IndustrialDetails'

/** Lens faces local -Z. The post remains in world coordinates. */
export function CompactPhotoeye(){return <group name="compact-photoeye">
 <Part name="photoeye-body" size={[.055,.07,.055]} radius={.005} color="#2b323b"/>
 <Part name="photoeye-optical-window" position={[0,.004,-.0285]} size={[.039,.047,.002]} radius={.003} color="#161f29"/>
 <RoundPart name="photoeye-lens" position={[0,.009,-.0305]} radius={.011} length={.002} axis="z" color="#381e24"/>
 <Part name="photoeye-status" position={[.017,.0355,.008]} size={[.006,.001,.008]} color="#8faf52"/>
 {[-1,1].map(s=><group key={s} rotation={[0,Math.PI,0]}><SocketBolt position={[s*.017,-.025,.0295]} radius={.0025}/></group>)}
</group>}
export function photoeyeTarget(nodes:Node[],n:Node):V3|undefined{
 if(!nodes.some(o=>o.id===n.id+'_lens'))return
 if(/^exit_photo_[ab]$/.test(n.id))return [n.id.endsWith('_a')?-1.3:1.3,n.p[1],n.p[2]]
 if(/^(pre|post)_photo$/.test(n.id))return [n.p[0],n.p[1],0]
 if(nodes.some(o=>o.id==='leader_grip')&&/sensor$/.test(n.id))return [.45,n.p[1],n.p[2]]
 const decks=nodes.filter(o=>o.conveyor||o.fixed_transfer)
 const clamp=(v:number,c:number,h:number)=>Math.max(c-h,Math.min(c+h,v))
 const candidate=decks.map(d=>{const x=clamp(n.p[0],d.p[0],d.size[0]/2),z=clamp(n.p[2],d.p[2],d.size[2]/2);return {d,distance:Math.hypot(n.p[0]-x,n.p[2]-z)+Math.abs(n.p[1]-d.p[1])*.1}}).sort((a,b)=>a.distance-b.distance)[0]
 if(!candidate||candidate.distance>.8)return
 const d=candidate.d,axis=d.conveyor?.axis??(d.size[0]>d.size[2]?'x':'z')
 return axis==='x'?[clamp(n.p[0],d.p[0],d.size[0]/2),n.p[1],d.p[2]]:[d.p[0],n.p[1],clamp(n.p[2],d.p[2],d.size[2]/2)]
}
export function replacedPhotoeye(nodes:Node[],id:string){const n=nodes.find(n=>n.id===id.replace(/_lens$/,''));return !!n&&!!photoeyeTarget(nodes,n)}
export function ReviewPhotoeyes({nodes}:{nodes:Node[]}){return <>{nodes.map(n=>{const t=photoeyeTarget(nodes,n);if(!t)return null
 const yaw=Math.atan2(n.p[0]-t[0],n.p[2]-t[2])
 return <group key={n.id} name={n.id+'-aimed-sensor'} position={n.p} rotation={[0,yaw,0]}><CompactPhotoeye/></group>
})}</>}
