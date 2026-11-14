type Device={id:string;pos:readonly number[];size:readonly number[];visualVariant?:string}
/** Seat cosmetic mounting plates and trim frame members at their mating faces.
 * Returns local bounds; device poses, sensor heights and evaluation stay intact. */
export function platformSeating(device:Device,devices:readonly Device[]) {
 const result:{lift:number;bottom?:number;top?:number;width?:number;front?:number;x?:number;z?:number;depth?:number}={lift:0}
 const footLift=(foot:Device)=>{
  const id=foot.id.replace(/_PHOTO_FOOT$/,'')
  const bench=devices.find(d=>(d.id===id||d.id===id+'_STAND')&&d.visualVariant==='hard-workbench')
  return bench&&Math.abs(bench.pos[1]+bench.size[1]/2-foot.pos[1]-foot.size[1]/2)<1e-6?foot.size[1]:0
 }
 if(device.id.endsWith('_PHOTO_FOOT')){
  result.lift=footLift(device)
  const id=device.id.replace(/_PHOTO_FOOT$/,'')
  const bench=devices.find(d=>(d.id===id||d.id===id+'_STAND')&&d.visualVariant==='hard-workbench')
  if(bench&&result.lift){
   // The short cantilever attaches to the outer belt frame. Stop at that
   // side face instead of pushing the plate through the frame and tabletop.
   const axis=device.size[0]>device.size[2]?0:2
   const a=-device.size[axis]/2,b=device.size[axis]/2
   const lo=bench.pos[axis]-bench.size[axis]/2-device.pos[axis]
   const hi=bench.pos[axis]+bench.size[axis]/2-device.pos[axis]
   const start=hi<=1e-6?Math.max(a,hi):a,end=lo>=-1e-6?Math.min(b,lo):b
   if(end-start>.01){
    if(axis===0){result.width=end-start;result.x=(start+end)/2}
    else {result.depth=end-start;result.z=(start+end)/2}
   }
  }
 }
 if(device.id.endsWith('_PHOTO_MOUNT')){
  const foot=devices.find(d=>d.id===device.id.replace(/_MOUNT$/,'_FOOT'))
  if(foot){const lift=footLift(foot);if(lift)result.bottom=foot.pos[1]+foot.size[1]/2+lift-device.pos[1]}
 }
 const probe=devices.find(d=>d.id==='GAUGE_PROBE'&&d.visualVariant==='hard-probe')
 if(probe&&device.id==='GAUGE_COLUMN'){
  const head=devices.find(d=>d.id==='GAUGE_CROSSHEAD')
  if(head)result.top=head.pos[1]-head.size[1]/2-device.pos[1]
 }
 if(probe&&device.id==='GAUGE_CARRIAGE')result.front=probe.pos[2]+probe.size[2]/2-device.pos[2]
 if(device.id.endsWith('_REAR_PANEL')){
  const prefix=device.id.replace(/_PANEL$/,'_POST_')
  const left=devices.find(d=>d.id===prefix+'-1'),right=devices.find(d=>d.id===prefix+'1')
  if(left&&right)result.width=Math.min(device.size[0],2*Math.min(device.pos[0]-left.pos[0]-left.size[0]/2,right.pos[0]-right.size[0]/2-device.pos[0]))
 }
 return result
}
