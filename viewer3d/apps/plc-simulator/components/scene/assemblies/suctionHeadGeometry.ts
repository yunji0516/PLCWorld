import { CylinderGeometry } from 'three'
import { mergeGeometries } from 'three/examples/jsm/utils/BufferGeometryUtils.js'
import { bellowsCupGeometry } from './transportGeometry'
import { SINGLE_VACUUM_CUP } from '../deviceGeometry'

export const SUCTION_FINISH = [
  {color:'#29343b',roughness:.88,metalness:.02},
  {color:'#a3afb9',roughness:.65,metalness:.64},
  {color:'#50768e',roughness:.65,metalness:.64},
] as const

/** Recognize actual tools, never material, labels, rods or vacuum plumbing. */
export function isSuctionHead(node: {name:string;shape:string;material?:boolean}) {
  return !node.material && ['box','cylinder'].includes(node.shape) && /suction head/i.test(node.name)
}

/** Centred at the original pad origin; contact plane and outer radius are unchanged. */
export function suctionCupGeometry(radius:number,height:number) {
  return bellowsCupGeometry(radius,height).translate(0,-SINGLE_VACUUM_CUP.lipY-height/2,0)
}

/** Fits the original node envelope: y=-.5..+.5, width/depth=diameter.
 * Shared rubber bellows, alloy retainer and blue manifold for every review head. */
export function compactSuctionHeadGeometry(diameter=1) {
  const cup=suctionCupGeometry(diameter/2,.70).translate(0,-.15,0)
  const collar=new CylinderGeometry(diameter*.28,diameter*.28,.12,32).translate(0,.26,0)
  const cap=new CylinderGeometry(diameter*.46,diameter*.46,.18,32).translate(0,.41,0)
  const pieces=[cup,collar,cap]
  const merged=mergeGeometries(pieces,true)
  pieces.forEach(g=>g.dispose())
  return merged
}
