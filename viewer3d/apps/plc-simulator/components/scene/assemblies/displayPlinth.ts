/** Only the anonymous display slab and its own feet, never a functional machine bed. */
export function isDisplayPlinth(part: {name:string; node?:string; pos:number[]; size:number[]}) {
  return !part.node && (part.name === 'base' || part.name.startsWith('foot-'))
    && part.pos[1] + part.size[1] / 2 <= .071
}

/** Lower the entire display assembly equally, including moving parts, onto the floor.
 * This is a render transform only; recorded relative poses and evaluation stay intact. */
export function displayGroundOffset(parts: {name:string; node?:string; pos:number[]; size:number[]}[]) {
  if (!parts.some(isDisplayPlinth)) return 0
  const bottoms=parts.filter(p=>!p.node&&!isDisplayPlinth(p)).map(p=>p.pos[1]-p.size[1]/2)
  return bottoms.length ? -Math.max(0,Math.min(...bottoms)) : 0
}

/** Ground existing M13 installation parts, without adding pedestals or changing
 * moving/contact geometry. Keep column tops and all recorded poses unchanged. */
export function groundedInstallationPart<T extends {name:string;node?:string;pos:number[];size:number[]}>(part:T,task:number,offset:number):T {
  if(task!==13 || part.node)return part
  const floor=-offset
  let bottom:number|undefined,top=part.pos[1]+part.size[1]/2
  if(part.name.endsWith('-foot')) {
    return {...part,pos:[part.pos[0],floor+part.size[1]/2,part.pos[2]]}
  }
  if(part.name.endsWith('-column'))bottom=floor+.035
  // The vertical axis has a bottom-mounted motor. Lower that motor, and extend
  // the existing bed down to its top, leaving the rail and carriage untouched.
  if(part.name==='a-motor')return {...part,pos:[part.pos[0],floor+part.size[1]/2,part.pos[2]]}
  if(part.name==='a-bed')bottom=floor+.10
  if(bottom===undefined || bottom>=top)return part
  return {...part,pos:[part.pos[0],(top+bottom)/2,part.pos[2]],size:[part.size[0],top-bottom,part.size[2]]}
}

/** Thin common mounting plate for the requested standalone Medium cells. */
export function mediumMountingPlate(task:number,parts:{name:string;node?:string;pos:number[];size:number[]}[]) {
  if(![6,7,8,9,10,11,13,15,16,17,18,19].includes(task))return null
  const fixed=parts.filter(p=>!p.node&&!isDisplayPlinth(p))
  if(!fixed.length)return null
  const minX=Math.min(...fixed.map(p=>p.pos[0]-p.size[0]/2))-.04
  const maxX=Math.max(...fixed.map(p=>p.pos[0]+p.size[0]/2))+.04
  const minZ=Math.min(...fixed.map(p=>p.pos[2]-p.size[2]/2))-.04
  const maxZ=Math.max(...fixed.map(p=>p.pos[2]+p.size[2]/2))+.04
  return {x:(minX+maxX)/2,z:(minZ+maxZ)/2,width:maxX-minX,depth:maxZ-minZ,thickness:.025}
}
