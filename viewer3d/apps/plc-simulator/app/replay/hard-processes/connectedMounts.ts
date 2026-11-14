import type {Node,Frame,V3} from './ReviewCanvas'
export type Mount={id:string;a:V3;b:V3;width:number;round?:boolean}
/** Mount endpoints are evaluated against the displayed actuator poses, including travel corrections. */
export function connectedMounts(nodes:Node[],frame:Frame):Mount[]{
 const byId=new Map(nodes.map(n=>[n.id,n])),p=(id:string):V3=>(frame.poses[id]??byId.get(id))!.p
 const has=(id:string)=>byId.has(id),out:Mount[]=[]
 const link=(id:string,a:V3,b:V3,width=.035,round=false)=>out.push({id,a,b,width,round})
 if(has('separator_hold')){
  const hold=p('separator_hold')
  for(const side of ['left','right']){
   const post=p('vac_post_'+side),arm=p('vac_arm_'+side),deck=p('pouch_deck')
   link('vac-post-outrigger-'+side,[deck[0]+(side==='left'?-.115:.115),.8075,0],[post[0],.8075,0],.035)
   link('vac-arm-return-'+side,[post[0],1.05,post[2]],[post[0],1.05,arm[2]],.025)
  }
  link('pusher-drive-pedestal',[0,.7785,-.98],[0,.83,-.98],.08)
  link('pusher-bed-extension',[0,.756,-.85],[0,.756,-1.07],.08)
 }
 if(has('leader_grip')){
  for(const side of ['a','b']){
   const g=p('guide_actuator_'+side),k=p('knife_actuator_'+side),nip=p('nip_slide_'+side)
   link('guide-cylinder-flange-'+side,[g[0],g[1],.30],[g[0],g[1],.31],.07)
   link('guide-shaft-coupler-'+side,[g[0],g[1],.20],[g[0],g[1],.22],.016,true)
   link('knife-cylinder-backplate-'+side,[.18,k[1],.31],[k[0],k[1],.31],.035)
   link('knife-cylinder-seat-'+side,[k[0],k[1],.31],[k[0],k[1],.26],.035)
   link('nip-slider-bearing-'+side,[nip[0],nip[1],.25],[nip[0],nip[1],.31],.03)
  }
  const tray=p('trim_tray'),car=p('trim_carriage'),rail=p('trim_rail'),stop=p('core_stop')
  link('trim-stage-x-bearing',[rail[0],.794,-.4],[rail[0],.816,-.4],.055)
  link('trim-carriage-bearing',[car[0],.844,car[2]],[car[0],.855,car[2]],.055)
  link('trim-tray-lift-seat',[car[0],.925,car[2]],[tray[0],tray[1]-.0075,tray[2]],.065)
  link('tape-prep-pedestal',[.9,0,.44],[.9,1.25,.44],.045)
  link('tape-prep-seat',[.9,1.25,.44],[.9,1.25,.35],.035)
  const knife=p('tail_tape_knife'),head=p('tail_tape_head')
  link('tape-knife-holder',[knife[0],knife[1],knife[2]],[head[0]-.045,knife[1],head[2]],.022)
 }
 if(has('edge_knife_left')){
  // The obsolete recovery motor is hidden in the two-roll trace; it has no pedestal.
  const die=p('die_back'),car=p('die_carriage')
  for(const dx of [-.12,.12])link('die-cylinder-'+dx,[car[0]+dx,car[1]-.03,car[2]-.10],[die[0]+dx,die[1]+.05,die[2]],.025,true)
  link('die-crosshead',[die[0]-.12,die[1]+.05,die[2]],[die[0]+.12,die[1]+.05,die[2]],.028)
  for(const id of ['waste_carriage','waste_roll2_cradle'])if(has(id)){const q=p(id);link(id+'-slide',[q[0],.65,q[2]],[q[0],q[1]-.0175,q[2]],.055)}
 }
 if(has('nozzle_slide_a')){
  link('tank-foot-seat',[0,.3125,1.35],[0,.35,1.35],.3)
  for(const side of ['a','b']){
   const s=p('nozzle_slide_'+side),post=p('nozzle_post_'+side),rod=(frame.poses['nozzle_rod_'+side]??byId.get('nozzle_rod_'+side))!.points!
   link('nozzle-column-slider-'+side,[post[0],s[1]-.05,.1475],[post[0],s[1]+.05,.1475],.04)
   link('nozzle-slide-to-post-'+side,[post[0]-.02,s[1],s[2]],[s[0]+.12,s[1],s[2]],.035)
   link('nozzle-slide-to-rod-'+side,[rod[1][0],s[1],s[2]-.05],[rod[1][0],s[1],rod[1][2]+.019],.03)
  }
  const c=p('capper_carriage'),h=p('capper_head'),cyl=p('capper_cylinder')
  link('capper-cylinder-seat',[c[0],c[1]-.04,c[2]],[cyl[0],cyl[1]+.125,cyl[2]],.07)
  link('capper-tool-coupler',[h[0],h[1]+.014,h[2]],[h[0],h[1]+.04,h[2]],.035,true)
 }
 if(has('upper_grip1')){
  // The lower separator is a side-mounted cylinder, attached to the cassette frame.
  link('separator-base-bracket',[.30,.90,-.25],[.82,.90,-.25],.055)
  link('separator-upright',[.82,.90,-.25],[.82,1.1525,-.25],.05)
  link('separator-cylinder-cradle',[.82,1.1525,-.25],[.82,1.1525,0],.05)
  link('separator-cylinder-body',[.60,1.1525,0],[.85,1.1525,0],.065,true)
  const shoe=p('transfer_fork_shoe')
  link('transfer-fork-guide-carriage',[shoe[0],.845,shoe[2]-.185],[shoe[0],.845,shoe[2]],.055)

  for(const side of ['a','b']){
   const drive=p('assembly_drive_'+side),arm=p('assembly_arm_'+side),stock=p('cap_stock_'+side),post=p('assembly_post_'+side)
   link('assembly-drive-seat-'+side,[drive[0],arm[1]-.03,drive[2]],[drive[0],drive[1]+.12,drive[2]],.055)
   link('cap-stock-support-'+side,[post[0],stock[1]-.05,post[2]],[post[0],stock[1]-.05,stock[2]],.035)
   link('cap-stock-seat-'+side,[post[0],stock[1]-.05,stock[2]],[stock[0],stock[1]-.05,stock[2]],.035)
  }
 }
 if(has('formation_align')){
  const a=p('formation_align')
  for(const x of [.90,1.60]){
   const edge=x<1.25?1.0:1.5,anchor=x<1.25?.95:1.55
   link('formation-align-guide-'+x,[x,.89,2.76],[x,.89,3.08],.035)
   link('formation-align-outrigger-'+x,[anchor,.89,2.76],[x,.89,2.76],.035)
   link('formation-align-mount-'+x,[anchor,.89,2.76],[anchor,.915,2.76],.035)
   link('formation-align-slider-'+x,[x,.9075,a[2]],[x,1.0,a[2]],.028)
   link('formation-align-toe-'+x,[x,1.0,a[2]],[edge,1.0,a[2]],.025)
  }
  link('formation-stop-bed-bracket',[.84,.90,2.5],[1.0,.90,2.5],.03)
 }
 if(has('tool_service_bearing0')){
  for(const side of ['a','b'])for(const k of [0,1]){
   const jaw=p(side==='a'?'adjust_a_jaw'+k:'b_jaw'+k),base=p('adjust_'+side+'_jaw')
   link(side+'-jaw-slider-stem-'+k,[jaw[0],base[1]+.03,jaw[2]],[jaw[0],jaw[1]-.02,jaw[2]],.035)
  }
  // Follow each exchangeable tool, including the tool parked on its rack.
  for(const t of [1,2])if(has('tool'+t+'_bridge')){
   const b=p('tool'+t+'_bridge')
   for(const zSign of [-1,1])for(const xSign of [-1,1]){
    const finger=p(`tool${t}_finger${zSign}_${xSign}`),arm=p(`tool${t}_arm${zSign}_${xSign}`)
    link(`tool${t}-finger-bearing-${zSign}-${xSign}`,[finger[0],b[1]-.015,finger[2]],[finger[0],finger[1]+.06,finger[2]],.035)
    link(`tool${t}-jaw-slide-${zSign}-${xSign}`,[finger[0],arm[1],arm[2]],[arm[0],arm[1],arm[2]],.025)
   }
  }
  const rail=p('head_xrail'),car=p('head_carriage'),tool=p('tool_coupler')
  // The trace already raises the rail to the gantry. Fill only its small bearing/carriage gaps.
  for(const id of ['tool_service_bearing0','tool_service_bearing1']){const q=p(id);link(id+'-seat',q,[q[0],rail[1],q[2]],.06)}
  link('head-carriage-seat',[car[0],rail[1]-.035,car[2]],[car[0],car[1]+.04,car[2]],.07)
  link('head-z-actuator-body',[car[0],car[1]-.04,car[2]],[car[0],car[1]-.20,car[2]],.045,true)
  for(const z of [-.055,.055])link('head-z-guide-'+z,[car[0],car[1]-.04,car[2]+z],[tool[0],tool[1]+.02,tool[2]+z],.014,true)

 }
 return out
}
