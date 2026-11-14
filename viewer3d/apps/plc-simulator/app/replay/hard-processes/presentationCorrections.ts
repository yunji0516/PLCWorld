import {chuteTray} from './scrapChutes'
import type {Node} from './ReviewCanvas'

/** Explicit render-only corrections; canonical products and actuator poses are retained. */
export function presentationCorrections(nodes:Node[]):Node[]{
 const rolls=nodes.some(n=>n.id==='waste_roll1_cradle')&&nodes.some(n=>n.id==='waste_roll2_cradle')
 const kit=nodes.some(n=>n.id==='box_lane_surface')&&nodes.some(n=>n.id==='box2_base')
 const independentRoll=nodes.some(n=>n.id==='exit_support_beam')&&nodes.some(n=>n.id==='core_feed_stand_beam')
 const punching=nodes.some(n=>n.id==='scrap_chute_a2')&&nodes.some(n=>n.id==='external_pickup_a_surface')
 const machining=nodes.some(n=>n.id==='cradle_pad')&&nodes.some(n=>n.id==='b_keeper')
 const filling=nodes.some(n=>n.id==='nozzle_slide_a')
 const formation=nodes.some(n=>n.id==='formation_align')
 const tooling=nodes.some(n=>n.id==='tool_service_bearing0')
 const corrected=nodes.filter(n=>!(nodes.some(o=>o.id==='separator_hold')&&(/^(pouch_magazine_(?:guide|mount)|package_out_(?:guide|mount)|separator_return_bed)/.test(n.id)))).filter(n=>!(nodes.some(o=>o.id==='splice_new_hold')&&/^receiver_rail_[ab]/.test(n.id))).filter(n=>!(tooling&&/^[ab]_fixture_beam$/.test(n.id))).filter(n=>!(formation&&n.id.startsWith('unit_nose_'))).filter(n=>!(rolls&&/^waste_[xz]rail/.test(n.id))).filter(n=>!(filling&&(/^(?:device_label_)?[ab]_arrival_/.test(n.id)||['batch_coupler_support','batch_exchange_beam'].includes(n.id)))).filter(n=>!(punching&&/^scrap_chute_[ab][12]$/.test(n.id))).filter(n=>!(nodes.some(o=>o.id==='upper_grip1')&&/^mag_tag/.test(n.id))).filter(n=>!(nodes.some(o=>o.id==='kit_hopper1')&&/^source_arrival_/.test(n.id))).filter(n=>!(/^order_mark_[ab]$/.test(n.id)&&nodes.some(o=>o.id==='cutter_cell_side-1'))).filter(n=>!(nodes.some(o=>o.id==='lower_fork')&&['upper_housing','lower_housing'].includes(n.id))).filter(n=>!(rolls&&n.id==='waste_carriage')).filter(n=>!(machining&&/^(source|exit)_drive_bracket$/.test(n.id))).map((n):Node=>{
  // H06: butt the end ties against the two running rails; retain the original
  // rail transforms and running surfaces. The supply saddle's lower sole is
  // sufficient: its former upper volume was entirely inside the carriage.
  if(nodes.some(o=>o.id==='splice_new_hold')){
   if(/^waste_transfer_zrail/.test(n.id))return {...n,fragments:[{p:[0,0,0],size:[1,1,.435/n.size[2]]}]}
   if(n.id==='source_b_mount')return {...n,fragments:[{p:[0,-.035/n.size[1],0],size:[1,.01/n.size[1],1]}]}
  }
  if(nodes.some(o=>o.id==='leader_grip')&&n.id==='core_seated_sensor_post')return {...n,p:[.62,.95375,.4],size:[.024,.0825,.024],presentationFixed:true,fragments:undefined}
  if(nodes.some(o=>o.id==='lower_fork')&&/^exit_photo_[ab](?:_post)?$/.test(n.id)){
   const post=n.id.endsWith('_post'),x=n.id.startsWith('exit_photo_a')?-1.575:1.575
   return {...n,p:[x,post?1.0275:n.p[1],n.p[2]],size:post?[.024,.115,.024]:n.size,presentationFixed:true,fragments:undefined}
  }
  if(tooling){
   if(/^cradle_bearing/.test(n.id))return {...n,size:[.029,.045,.029],visible:true,presentationFixed:true}
   if(/^cradle_column/.test(n.id))return {...n,p:[n.p[0],n.p[1]+.003,n.p[2]],size:[n.size[0],n.size[1]+.006,n.size[2]],presentationFixed:true,fragments:undefined}
   if(n.id==='cradle_motor')return {...n,p:[-.22,.48,0],presentationFixed:true}
   if(/^[ab]_probe_post$/.test(n.id))return {...n,p:[n.p[0],n.p[1],-.60],presentationFixed:true,fragments:undefined}
   if(/^[ab]_probe_arm$/.test(n.id))return {...n,p:[n.p[0],n.p[1],-.50],presentationFixed:true,fragments:undefined}
  }
  if(n.id==='box_jaw')return {...n,size:[.04,.12,.30]}
  if(n.id==='box_clamp_drive')return {...n,p:[3.025,.95,.6],size:[.045,.32,.045],presentationFixed:true}
  if(nodes.some(o=>o.id==='lower_fork')){
   if(n.id==='exit_b_transverse_pusher_drive')return {...n,p:[.83,n.p[1],n.p[2]],visible:true,presentationFixed:true}
   if(/^transverse_pusher_b_(?:beam|leg|foot)/.test(n.id))n={...n,p:[n.p[0]+.15,n.p[1],n.p[2]],presentationFixed:true}
  }
  if(filling&&/^photo_.*_post$/.test(n.id))return {...n,p:[n.p[0],.875,n.p[2]],size:[.024,.18,.024],presentationFixed:true,fragments:undefined}
  if(tooling&&/^[ab]_fixture_surface$/.test(n.id))return {...n,fragments:[
   {p:[0,0,0],size:[.15/n.size[0],1,.08/n.size[2]]},
   ...[-1,1].map(k=>({p:[k*.14/n.size[0],0,0] as Node['p'],size:[.03/n.size[0],1,1] as Node['p']})),
  ]}
  if(tooling&&/^[ab]_fixture_beam$/.test(n.id))return {...n,fragments:[-1,1].map(k=>({p:[k*.14/n.size[0],0,0] as Node['p'],size:[.13/n.size[0],1,1] as Node['p']}))}
  if(filling&&n.id==='batch_exchange_surface')return {...n,color:'#7f8f9c'}
  // Fit the existing stand to this task's actual cylinder, including H10 and H12.
  const pusherStand=n.id.match(/^transverse_pusher_([ab])_(beam|leg)/)
  if(pusherStand){
   const drive=nodes.find(o=>o.id===`exit_${pusherStand[1]}_transverse_pusher_drive`)
   const beam=nodes.find(o=>o.id===`transverse_pusher_${pusherStand[1]}_beam`)
   if(drive&&beam){const delta=drive.p[1]-drive.size[0]-.006-(beam.p[1]+beam.size[1]/2),leg=pusherStand[2]==='leg'
    return {...n,p:[n.p[0],n.p[1]+delta/(leg?2:1),n.p[2]],size:[n.size[0],n.size[1]+(leg?delta:0),n.size[2]],presentationFixed:true,fragments:undefined}
   }
  }
  if(nodes.some(o=>o.id==='cross_1.25_surface')){
   const m=n.id.match(/^(rail_1\.72_(?:leg|foot)0[01]|rail_2\.68_(?:leg|foot)1[01]|rail_-1\.66_(?:leg|foot)1[01]|kit_lane[12]_(?:leg|foot)[01][01]|exit[12]_(?:leg|foot)0[01])/)
   if(m){const x=n.id.startsWith('rail_1.72')?1.70:n.id.startsWith('rail_2.68')?2.70:n.id.startsWith('rail_-1.66')?-1.75:n.id.startsWith('kit_lane')?(n.p[0]<0?-.85:.85):3.55
    return {...n,p:[x,n.p[1],n.p[2]],presentationFixed:true,fragments:undefined}
   }
  }
  if(rolls){
   const fixed=(p:Node['p'],size:Node['size'])=>({...n,p,size,presentationFixed:true,fragments:undefined})
   if(n.id.startsWith('rewinder_guard'))return fixed([n.p[0],n.id.includes('upright')?.525:n.p[1],1.0],n.id.includes('upright')?[.035,1.05,.035]:n.size)
   if(n.id==='reel_swap_stand_beam')return fixed([.4,.485,-.15],[.37,.075,2.1])
   if(n.id==='waste_receiving_beam')return fixed([1.2,.485,-.15],[.4,.075,2.1])
   if(/^(reel_swap_stand|waste_receiving)_(leg|foot)/.test(n.id)){
    const z=/_(?:leg|foot)[01]1$/.test(n.id)?.855:-1.155
    return fixed([n.p[0],n.id.includes('_leg')?.24875:n.p[1],z],n.id.includes('_leg')?[.055,.3975,.055]:n.size)
   }
  }
  // H08: an open-front saddle leaves the pickup shaft's entire Z sweep clear.
  // Keep the recorded carriage pose and the cutting/contact geometry unchanged.
  if(rolls&&nodes.some(o=>o.id==='edge_knife_left')&&n.id==='die_carriage')return {...n,fragments:[
   ...[-1,1].map(k=>({p:[k*.18/.42,0,-.03/.14] as Node['p'],size:[.06/.42,1,.20/.14] as Node['p']})),
   {p:[0,0,-.10/.14],size:[.30/.42,1,.06/.14]},
  ]}
  if(nodes.some(o=>o.id==='empty_pallet_lift')){
   const fixed=(p:Node['p'],size=n.size)=>({...n,p,size,presentationFixed:true,fragments:undefined})
   // Put the stack lift columns on the opposite side of the pickup opening.
   // Their old centre screw and saddle crossed the incoming fork at z=.62.
   if(/^stack_(guide|screw|motor)_/.test(n.id)){
    const z=n.id.startsWith('stack_guide')?.24:.21
    return {...fixed([n.p[0],n.p[1],z]),points:n.points?.map(p=>[p[0],p[1],z] as Node['p'])}
   }
   if(/^receiver_leg_/.test(n.id))return fixed([n.p[0],.42,n.p[2]],[n.size[0],.74,n.size[2]])
   // Open the pallet stand centre for the transfer slide. Its two side beams
   // still carry both pallet rails; a solid tabletop intersected the moving axis.
   if(n.id==='pallet_stand_beam')return {...fixed(n.p),fragments:[-1,1].map(k=>({p:[k*.155/.4,0,0] as Node['p'],size:[.09/.4,1,1] as Node['size']}))}
   if(n.id==='fork_xrail')return fixed([n.p[0],.62,n.p[2]])
   if(/^fork_railpost/.test(n.id))return fixed([n.p[0],.3175,n.p[2]],[n.size[0],.535,n.size[2]])
   if(n.id==='fork_xscrew')return {...fixed([-1.45,.62,2.18]),points:[[-1.45,.62,2.18],[.8,.62,2.18]] as Node['points']}
   if(n.id==='fork_xmotor')return fixed([-1.53,.62,2.18])
  }
  if(nodes.some(o=>o.id==='kit_hopper1')&&/^(pre|post)_photo_post$/.test(n.id))return {...n,p:[n.p[0],(.9425+1.325)/2,n.p[2]],size:[n.size[0],1.325-.9425,n.size[2]],presentationFixed:true,fragments:undefined}
  if(nodes.some(o=>o.id==='lower_fork')&&n.id.startsWith('cassette_leg('))return {...n,p:[n.p[0],.425,n.p[2]],size:[n.size[0],.85,n.size[2]],fragments:undefined,presentationFixed:true}
  const chute=n.id.match(/^scrap_chute_([ab])([0-2])$/)
  if(chute)return {...n,shape:'panel',points:chuteTray(n.id),presentationFixed:true}
  // Extend the three-hole product receiving belt by 0.4 m, retaining its inlet.
  if(punching&&n.id.startsWith('external_pickup_a_')){
   const p=[...n.p] as Node['p'],size=[...n.size] as Node['size']
   if(n.conveyor){p[0]+=.2;size[0]+=.4;return {...n,p,size,conveyor:{...n.conveyor,length:n.conveyor.length+.4},presentationFixed:true,fragments:undefined}}
   if(/side_rail|rail_channel/.test(n.id)){p[0]+=.2;size[0]+=.4}
   else if(p[0]>-.1)p[0]+=.4
   else if(/motor|drive_/.test(n.id))p[0]+=.2
   return {...n,p,size,presentationFixed:true,fragments:undefined}
  }
  if(independentRoll){
   if(/^exit_(occupied|clear)_sensor_post$/.test(n.id))return {...n,p:[n.p[0],(.8825+.995)/2,n.p[2]],size:[n.size[0],.995-.8825,n.size[2]],presentationFixed:true,fragments:undefined}
   const fixed=(p:Node['p'],size:Node['size'])=>({...n,p,size,presentationFixed:true,fragments:undefined})
   if(n.id==='core_feed_stand_beam')return {...fixed([.45,.745,.98],[.58,.075,1.3]),fragments:[-1,1].map(k=>({p:[k*.26/.58,0,0] as Node['p'],size:[.06/.58,1,1] as Node['size']}))}
   if(/^core_feed_rail/.test(n.id))return fixed([n.p[0],n.p[1],1.015],[n.size[0],n.size[1],1.03])
   if(/^core_feed_stand_leg/.test(n.id))return fixed([n.p[0]<.45?.19:.71,(.05+.7075)/2,n.p[2]],[.055,.7075-.05,.055])
   if(/^core_feed_stand_foot/.test(n.id))return fixed([n.p[0]<.45?.19:.71,n.p[1],n.p[2]],n.size)
   if(/^receiver_leg0\./.test(n.id)&&!/_upper/.test(n.id))return fixed([n.p[0]<.45?.19:.71,(.7825+.86)/2,n.p[2]],[.025,.86-.7825,.025])
   if(/^exit_roller_foot/.test(n.id))return fixed([n.p[0],(.6125+.835)/2,n.p[2]],[.025,.835-.6125,.025])
   if(/^exit_support_leg/.test(n.id))return fixed([n.p[0],(.05+.5375)/2,n.p[2]],[.055,.5375-.05,.055])
  }
  // Fixed guard uprights retain their top and section, extending to the floor.
  if(!n.material&&n.shape==='box'&&/_guard.*_upright-?1$/.test(n.id)&&!n.rx&&!n.rz){
   const top=n.p[1]+n.size[1]/2
   return {...n,p:[n.p[0],top/2,n.p[2]],size:[n.size[0],top,n.size[2]],fragments:undefined,presentationFixed:true}
  }
  if(rolls&&n.id==='waste_roll1_cradle')return {...n,id:'waste_carriage',name:'Waste roll exchange cradle 1'}
  if(rolls&&n.id==='waste_roll2_cradle')return {...n,name:'Waste roll exchange cradle 2'}
  if(kit&&n.id.startsWith('box_lane_')&&!n.material&&!/stop/.test(n.id)){
   const p=[...n.p] as Node['p'],size=[...n.size] as Node['size'];let changed=false
   const points=n.points?.map(v=>[...v] as Node['p'])
   if(n.conveyor){p[2]-=.17;size[2]+=.34;return {...n,p,size,conveyor:{...n.conveyor,length:n.conveyor.length+.34},presentationFixed:true,fragments:undefined}}
   if(size[2]>3.5&&n.shape==='box'){p[2]-=.17;size[2]+=.34;changed=true}
   if(p[2]<-1.0){p[2]-=.34;changed=true}
   if(points)for(const v of points)if(v[2]<-1.0){v[2]-=.34;changed=true}
   if(changed)return {...n,p,size,points,presentationFixed:true,fragments:undefined}
  }
  if(machining&&/^(source|exit)_drive_mount$/.test(n.id))return {...n,p:[n.p[0],.765,n.p[2]],size:[.04,.01,.04],presentationFixed:true,fragments:undefined}

  return n
 })
 if(tooling){
  for(const side of ['a','b']){
   const n=nodes.find(n=>n.id===side+'_fixture_surface')!
   for(const dx of [-.14,.14])corrected.push({id:side+'-fixture-deck-support-'+dx,name:'Fixture side support',shape:'box',p:[n.p[0]+dx,.7725,0],size:[.03,.085,n.size[2]],r:0,color:'#7f8f9c',presentationFixed:true})
   corrected.push({id:side+'-fixture-centre-seat',name:'Fixture center support',shape:'box',p:[n.p[0],.8025,0],size:[.15,.025,.08],r:0,color:'#7f8f9c',presentationFixed:true})
  }
 }
 if(filling){
  for(const n of nodes.filter(n=>/^photo_.*_post$/.test(n.id)))corrected.push({id:n.id+'-side-bracket',name:'Sensor side mounting bracket',shape:'box',p:[n.p[0]-.0435,.7725,n.p[2]],size:[.111,.025,.05],r:0,color:'#7f8f9c',presentationFixed:true})
  for(const side of ['a','b']){
   const n=nodes.find(n=>n.id==='nozzle_post_'+side)!
   corrected.push({id:'nozzle-column-guide-'+side,name:'Nozzle lift guide',shape:'box',p:[n.p[0],1.445,.180],size:[.04,.50,.025],r:0,color:'#7f8f9c',presentationFixed:true})
  }
  // End bearing blocks meet the gantry underside and contain the shaft ends.
  for(const x of [-1.62,1.62])corrected.push({id:'capper-rail-end-bearing-'+x,name:'Capping rail end bearing',shape:'box',p:[x,1.875,-1],size:[.10,.06,.14],r:0,color:'#7f8f9c',presentationFixed:true})
 }
 if(independentRoll){
  // Thin bearing seats sit above the saddle sweep; the carrier enters the open bay below.
  for(const n of nodes.filter(n=>/^fixed_receiver0\./.test(n.id))){
   const postX=n.p[0]<.45?.19:.71
   corrected.push({id:n.id+'-bearing-seat',name:'Roller bearing seat',shape:'box',color:'#7f8f9c',r:0,p:[(postX+n.p[0])/2,.8625,n.p[2]],size:[Math.abs(postX-n.p[0])+.025,.005,.025],presentationFixed:true})
  }
 }
 if(nodes.some(n=>n.id==='lower_fork')){
  const add=(id:string,p:Node['p'],size:Node['size'])=>corrected.push({id,name:'Transfer rail support frame',shape:'box',p,size,color:'#35434e',r:0,presentationFixed:true})
  const rails=nodes.filter(n=>n.conveyor&&n.id.startsWith('cassette_'))
  for(const leg of nodes.filter(n=>n.id.startsWith('cassette_leg('))){
   const nearest=rails.map(n=>({x:Math.max(n.p[0]-n.size[0]/2,Math.min(leg.p[0],n.p[0]+n.size[0]/2)),z:Math.max(n.p[2]-n.size[2]/2,Math.min(leg.p[2],n.p[2]+n.size[2]/2))})).sort((a,b)=>Math.hypot(a.x-leg.p[0],a.z-leg.p[2])-Math.hypot(b.x-leg.p[0],b.z-leg.p[2]))[0]
   if(nearest)add(leg.id+'-top-crossmember',[(leg.p[0]+nearest.x)/2,.875,(leg.p[2]+nearest.z)/2],[Math.abs(leg.p[0]-nearest.x)+.055,.05,Math.abs(leg.p[2]-nearest.z)+.055])
  }
  add('transfer-guide-bed',[0,.765,-.185],[.19,.07,.74])
  for(const side of [-1,1])add('transfer-guide-bed-crossmember-'+side,[side*.21,.765,-.25],[.23,.07,.08])
 }
 if(nodes.some(n=>n.id==='lower_fork'))for(const sign of [-1,1])corrected.push({id:'exit-photo-folded-foot-'+sign,name:'Sensor side mounting flange',shape:'box',p:[sign*1.556,.96,-2.08],size:[.062,.02,.06],r:0,color:'#7f8f9c',presentationFixed:true})
 if(nodes.some(n=>n.id==='leader_grip'))corrected.push({id:'core-photo-bed-flange',name:'Core sensor mounting flange',shape:'box',p:[.62,.9025,.37975],size:[.05,.02,.0645],r:0,color:'#7f8f9c',presentationFixed:true})
 if(nodes.some(n=>n.id==='leader_grip')&&!nodes.some(n=>n.id.startsWith('device_label_'))){
  const names:Record<string,string>={source_core_a:'Web supply roll A',source_core_b:'Web supply roll B',guide_a:'Web feed nip roller A',guide_b:'Web feed nip roller B',leader_grip:'Web leading-edge gripper',trim_tray:'Leader cutting support',mandrel:'Shared winding shaft',core_stop:'Core supply stopper',tail_tape_head:'Tail tape applicator head',exit_axial_pusher:'Finished roll outfeed pusher'}
  for(let i=0;i<corrected.length;i++){const n=corrected[i];if(names[n.id])corrected[i]={...n,name:names[n.id]}}
  for(const [id,name] of Object.entries(names)){const n=corrected.find(o=>o.id===id);if(n)corrected.push({id:'device_label_'+id,name,shape:'label',anchor:id,label_offset:[0,.24,0],p:[n.p[0],n.p[1]+.24,n.p[2]],size:[.01,.01,.01],r:0,color:'#ffffff'})}
 }
 return corrected
}
