import type {Frame,Pose,V3} from './ReviewCanvas'
const dist=(a:V3,b:V3)=>Math.hypot(...a.map((v,k)=>v-b[k]))
const lerp=(a:V3,b:V3,t:number)=>a.map((v,k)=>v+(b[k]-v)*t) as V3
/** Presentation geometry, never material or PLC state. */
export function auxiliaryMotionPresentation(input:Frame[]):Frame[]{
 let frames=input
 // Keep the clamp jaw clear of the adjacent packing column throughout its stroke.
 if(input[0]?.poses.box_jaw)frames=frames.map(f=>({...f,poses:{...f.poses,box_jaw:{...f.poses.box_jaw,s:[.04,.12,.30]}}}))
 if(input[0]?.poses.leader_grip){
  const positions=new Map<number,V3>()
  for(let i=1;i<input.length;i++){
   const a=input[i-1].poses.leader_grip.p,b=input[i].poses.leader_grip.p
   if(dist(a,b)<.08||dist(a,b)/(input[i].t-input[i-1].t)<2)continue
   if(b[1]<a[1]-.08){
    let start=i-1;while(start>0&&input[i].t-input[start-1].t<.4&&dist(input[start-1].poses.leader_grip.p,a)<.001)start--
    for(let j=start;j<i;j++)positions.set(j,lerp(a,b,(input[j].t-input[start].t)/(input[i].t-input[start].t)))
   }else{
    for(let j=i;j<input.length&&input[j].t-input[i-1].t<.4;j++)positions.set(j,lerp(a,input[j].poses.leader_grip.p,(input[j].t-input[i-1].t)/.4))
   }
  }
  frames=frames.map((f,i)=>{
   const p=positions.get(i);if(!p)return f
   const rod=f.poses.leader_rod,points:V3[]=[[p[0],1.30,0],[p[0],p[1]+.009,0]]
   return {...f,poses:{...f.poses,leader_grip:{...f.poses.leader_grip,p},...(rod?{leader_rod:{...rod,p:points[0],points}}:{})}}
  })
 }
 // Jaw width was selected from the next order in one step. Adjust the empty
 // fingers before that frame, in the existing tool coordinates, including slides.
 if(input[0]?.poses.formation_contact_pad1){
  const ids=Object.keys(input[0].poses).filter(id=>/^(transfer_finger|formation_(head$|gripper_|finger|contact_pad|jaw_slider))/.test(id))
  const edits=new Map<number,Record<string,Pose>>()
  for(const id of ids)for(let i=1;i<input.length;i++){
   const a=input[i-1].poses[id],b=input[i].poses[id];if(!a||!b)continue
   const dt=input[i].t-input[i-1].t
   const dp=b.p.map((v,k)=>v-a.p[k]) as V3,ds=a.s&&b.s?b.s.map((v,k)=>v-a.s![k]) as V3:undefined
   const pointJump=Math.max(0,...(a.points??[]).map((v,k)=>b.points?.[k]?dist(v,b.points[k]):0))
   const jump=Math.max(dist(a.p,b.p),pointJump)
   const shifted=jump>.08&&jump/dt>=2-1e-6, resized=ds&&Math.hypot(...ds)>.08
   if(!shifted&&!resized)continue
   // Whole-tool motion stays untouched; width changes are along Z only.
   if(shifted&&(Math.abs(dp[0])>.02||Math.abs(dp[1])>.02))continue
   let start=i-1;while(start>0&&input[i].t-input[start-1].t<=.4)start--
   for(let j=start;j<i;j++){
    const f=input[j],old=f.poses[id];if(!old)continue
    const t=(f.t-input[start].t)/(input[i].t-input[start].t),row=edits.get(j)??{...frames[j].poses}
    const pose:Pose={...old}
    if(shifted){pose.p=[old.p[0],old.p[1],old.p[2]+dp[2]*t];if(old.points&&a.points&&b.points)pose.points=old.points.map((v,k)=>[v[0],v[1],v[2]+((b.points?.[k]?.[2]??v[2])-(a.points?.[k]?.[2]??v[2]))*t])}
    if(resized&&old.s)pose.s=old.s.map((v,k)=>v+ds![k]*t) as V3
    row[id]=pose;edits.set(j,row)
   }
  }
  frames=frames.map((f,i)=>edits.has(i)?{...f,poses:edits.get(i)!}:f)
 }
 // Keep winding/contact frames unchanged. At the receiving station park the
 // first roll in the far bay and the second in the near bay, without crossing it.
 if(input[0]?.poses.waste_roll1_cradle&&input[0]?.poses.waste_roll2_cradle)frames=frames.map(f=>{
  const poses={...f.poses}
  for(const index of [1,2]){
   const core=poses[`waste_roll${index}_core`];if(!core||core.p[0]<1.1999||core.p[2]>=-.45)continue
   const z=-.45+(core.p[2]+.45)*(index===1?5:2/9),dz=z-core.p[2]
   for(const [id,p] of Object.entries(poses))if(id.startsWith(`waste_roll${index}_`))poses[id]={...p,p:[p.p[0],p.p[1],p.p[2]+dz],points:p.points?.map(q=>[q[0],q[1],q[2]+dz] as V3)}
  }
  return {...f,poses}
 })
 // The old aggregate jumped between rolls. Bind it to the first existing cradle;
 // the second cradle already has its own stable identity and recorded motion.
 if(input[0]?.poses.waste_roll1_cradle&&input[0]?.poses.waste_roll2_cradle)frames=frames.map(f=>({...f,poses:{...f.poses,waste_carriage:f.poses.waste_roll1_cradle}}))
 // H02's belt motor is coaxial with its driven roller, on the same moving saddle.
 if(input[0]?.poses.deck_belt_motor)frames=frames.map(f=>{
  const motor=f.poses.deck_belt_motor,shaft=f.poses.deck_shaft1
  if(!motor||!shaft)return f
  return {...f,poses:{...f.poses,deck_belt_motor:{...motor,p:[motor.p[0],shaft.p[1],shaft.p[2]]}}}
 })
 if(input[0]?.poses.exit_b_transverse_pusher&&input[0]?.poses.lower_fork)frames=frames.map(f=>{
  const rod=f.poses.exit_b_transverse_pusher_rod,jaw=f.poses.exit_b_transverse_pusher
  if(!rod||!jaw)return f
  const a:V3=[.95,jaw.p[1],jaw.p[2]],b:V3=[jaw.p[0]-.006,jaw.p[1],jaw.p[2]]
  return {...f,poses:{...f.poses,exit_b_transverse_pusher_rod:{...rod,p:a,points:[a,b]}}}
 })
 if(input[0]?.poses.tool_coupler)frames=frames.map(f=>{const poses={...f.poses}
  for(const sign of [-1,1]){
   const id='cradle_offset_arm'+sign,p=poses[id];if(p)poses[id]={...p,p:[sign*.22,p.p[1],p.p[2]],points:p.points?.map(q=>[sign*.22,q[1],q[2]] as V3)}
   const sid='cradle_wide_stub'+sign,sp=poses[sid];if(sp?.points)poses[sid]={...sp,points:[sp.points[0],[sign*.22,...sp.points[1].slice(1)] as V3]}
  }
  return {...f,poses}
 })
 return frames
}
