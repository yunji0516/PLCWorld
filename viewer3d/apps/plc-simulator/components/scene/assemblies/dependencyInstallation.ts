/** Render-only installation seating and clearance. Recorded actuator/contact
 * poses stay intact; decorative hardware no longer occupies identical faces. */
export function seatedDependencyPart<T extends {name:string;node?:string;pos:number[];size:number[]}>(p:T,task:number):T {
 if(p.node?.startsWith('protected'))return p
 const set=(pos:number[],size:number[]=p.size):T=>({...p,pos,size})
 if(task===7&&['probe-stem','b-top-drive-coupling','c-drive-coupling'].includes(p.name)) {
  const axis=p.name==='c-drive-coupling'?2:1
  const size=[...p.size];size[axis]-=.002
  return set([...p.pos],size)
 }
 // The side-axis end cap occupied the same space as its carrying saddle
 // in M07 (omitted below). M13's cap instead seats ahead of the tilt flange.
 if(task===13) {
  // The horizontal tilt slide used to pass through the upright lift bed.
  // Put the lift behind the tilt drive, with its saddle facing the drive.
  if(p.name==='a-saddle')return set([p.pos[0],p.pos[1],p.pos[2]-.44])
  if(p.name.startsWith('a-'))return set([p.pos[0],p.pos[1],p.pos[2]-.56])
  // Separate the tilt gearbox from the C motor along their depth axis.
  // Its underside seats on the A saddle (0.23 + 0.045/2).
  if(p.name==='tilt-housing')return set([p.pos[0],p.pos[1],-.663],[.10,.055,.07])
  if(p.name==='c-end-0')return set([p.pos[0],p.pos[1],.025])
 }
 // Fit the mount BETWEEN the two 12mm rails, not through their outside faces.
 if(task===18&&p.name==='recovery-stage-mount')return set([...p.pos],[.056,p.size[1],p.size[2]])
 // M12 fixed frame: columns seat between the foot tops and beam underside;
 // the cantilever arms meet the beam front and the mounting-plate top.
 if(task===12){
  if(p.name.startsWith('Upper frame column'))return set([p.pos[0],1.08,p.pos[2]],[p.size[0],.88,p.size[2]])
  if(p.name.startsWith('X1 fixed support arm'))return set([p.pos[0],1.575,.335],[p.size[0],.05,.23])
 }
 // The moving neck joins the saddle's side. Keep its outboard endpoint fixed.
 if(task===15&&p.name==='shuttle-neck')return set([p.pos[0]+.035,p.pos[1],p.pos[2]],[p.size[0]-.07,p.size[1],p.size[2]])
 if(task!==9)return p
 // The pin passes through the jaw; its exposed cap must not share the jaw face.
 if(p.name==='b-jaw'||p.name==='c-jaw')return set([...p.pos],[p.size[0],p.size[1],.033])
 if(p.name==='clamp-mount-span')return set([0,.045,0],[.1,.045,.66])
 if(p.node)return p
 if(p.name==='a-bed-support0.045'||p.name==='a-bed-support0.20500000000000002')return set([p.pos[0],(.0675+.2475)/2,p.pos[2]],[p.size[0],.2475-.0675,p.size[2]])
 if(p.name==='receiver-backbeam-1'||p.name==='receiver-backbeam1')return set([(.13+.3275)/2,.44,p.name.endsWith('-1')?-.21:.25],[.3275-.13,.025,.04])
 if(p.name==='receiver-crossbeam-1')return set([.1,.44,(-.23-.04)/2],[.06,.025,.19])
 if(p.name==='receiver-crossbeam1')return set([.1,.44,(.04+.27)/2],[.06,.025,.23])
 if(p.name==='receiver-support-column')return set([p.pos[0],(.1025+.4275)/2,p.pos[2]],[p.size[0],.4275-.1025,p.size[2]])
 return p
}

/** Some recorded parts have world-space motion despite lacking a node (for
 * example M07 b-bed). Join only explicit rigid groups or known fixed supports;
 * never punch permanent holes at a transient actuator intersection.
 */
export function isJoinedInstallation(p:{name:string;node?:string},task?:number) {
 if(p.node)return !p.node.startsWith('protected')
 // These gantry motors are fixed. Their mounting caps are machined around
 // the motor housing so the front surfaces have one owner.
 if(([7,18,19].includes(task??0)&&p.name==='a-motor')||(task===17&&p.name==='c-motor'))return true
 return /(?:foot(?:$|[-0-9])|column$|(?:back|cross)beam-?1$|crosshead$|crown(?:$|-)|gantry-cap|(?:start|end)-cap$|rear-x-cap|standoff[01]$|^[bc]-arm$)/.test(p.name)
}

export function redundantDependencyPart(p:{name:string;node?:string},task:number) {
 // M07's saddle already encloses and supports this entire end cap; drawing
 // both places two differently colored top/bottom faces at the same depth.
 return !p.node&&((task===6&&['b0.19','b0.4'].includes(p.name))||(task===7&&p.name==='c-cross-end-0')||(task===13&&p.name==='lift-tilt-mount'))
}
