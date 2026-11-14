import {PHOTOEYE_STYLE} from '@/components/scene/photoeyeStyle'
import {supportRole} from './supportPresentation'
import { compactSuctionHeadGeometry, isSuctionHead } from '@/components/scene/assemblies/suctionHeadGeometry'
import { BoxGeometry, CylinderGeometry, LatheGeometry, Vector2, type BufferGeometry } from 'three'
import { mergeGeometries } from 'three/examples/jsm/utils/BufferGeometryUtils.js'
import { wrappedBeltGeometry } from '@/components/scene/assemblies/transportGeometry'
import { CONVEYOR_BELT_TOP_Y } from '@/components/scene/deviceGeometry'
import { RoundedBoxGeometry } from 'three/examples/jsm/geometries/RoundedBoxGeometry.js'
import { makeSlottedProfile } from '@/components/scene/profileGeometry'
import { satinFinish } from '@/components/scene/surfaceFinish'
import {TABLE_FINISH} from '@/components/scene/assemblies/tableFinish'
import { FINISH } from '@/components/scene/assemblies/Parts'
import { boredPlate } from '@/components/scene/assemblies/geometry'
import type { Node } from './ReviewCanvas'

export const isRotaryMotor=(node:Node)=>!node.material&&node.shape==='cylinder'&&/(?:motor|drive)/.test(node.id)&&!/(?:stop|clamp|hold|pusher|align|knife|cylinder|foot|jaw|bearing|shaft|roller)/.test(node.id)

const vesselWall=(node:Node)=>(node.id==='tank_shell' || (node.material && /^part\d+$/.test(node.id))) && (node.opacity ?? 1)<1

// Use the same physical extrusions and satin metal finish as the standard
// scene assemblies. Geometry is normalized only after machining, so replay
// poses retain the calibrated outer envelope and contact surfaces.
export function hardwareGeometry(node: Node) {
  if(node.id==='exit_pusher_slide'){
    const pieces:BufferGeometry[]=[]
    const box=(w:number,h:number,d:number,x:number,y:number)=>{const g=new RoundedBoxGeometry(w,h,d,2,.001);g.translate(x,y,0);pieces.push(g)}
    box(.08,.015,.10,0,.025)
    for(const x of [-.02875,.02875])box(.0225,.03,.10,x,.0025)
    const converted=pieces.map(g=>g.toNonIndexed()),g=mergeGeometries(converted);[...pieces,...converted].forEach(p=>p.dispose());g.scale(1/node.size[0],1/node.size[1],1/node.size[2]);return g
  }
  if(node.id==='align_front'){
    // Registration fingers straddle the pusher; the return bridge is below its sweep.
    const parts:BufferGeometry[]=[]
    const box=(w:number,h:number,d:number,x:number,y:number)=>{const g=new RoundedBoxGeometry(w,h,d,2,.015);g.translate(x,y,0);parts.push(g)}
    for(const x of [-.9375,.9375]){box(.3125,1,1,x,0);box(.3125,.24,1,x,-.62)}
    box(2.1875,.4286,1,0,-.9571)
    const converted=parts.map(g=>g.toNonIndexed()),g=mergeGeometries(converted);[...parts,...converted].forEach(p=>p.dispose());return g
  }
  if(/^upper_grip-?1$/.test(node.id)){
    const pieces:BufferGeometry[]=[]
    const box=(w:number,h:number,d:number,y:number,z:number)=>{const g=new RoundedBoxGeometry(w,h,d,2,.025);g.translate(0,y,z);pieces.push(g)}
    box(1,1,.22,0,-.39);box(1,.18,.78,.41,.11);box(1,.18,.78,-.41,.11)
    const converted=pieces.map(g=>g.toNonIndexed()),g=mergeGeometries(converted);[...pieces,...converted].forEach(p=>p.dispose());return g
  }
  if (isSuctionHead(node)) return compactSuctionHeadGeometry(node.shape === 'cylinder' ? 2 : 1)
  if(node.material && node.shape==='cylinder' && /^part\d+_rim$/.test(node.id)) {
    // Open vessel mouth: retain the outside radius and thickness, with an
    // actual bore. A filled disk falsely looked like an already fitted cap.
    const inner=.128/.137
    return new LatheGeometry([[inner,-.5],[1,-.5],[1,.5],[inner,.5],[inner,-.5]].map(([x,y])=>new Vector2(x,y)),40)
  }
  if (node.bearing_axis && node.bore_radius) {
    const [w,h,d]=node.size, transverse=node.bearing_axis==='x'
    const g=boredPlate(transverse?d:w,h,transverse?w:d,Math.min(.008,h*.2),[{x:0,y:0,radius:node.bore_radius}])
    if(transverse)g.rotateY(Math.PI/2)
    g.scale(1/w,1/h,1/d)
    return g
  }
  if (node.shape === 'conveyor_belt' && node.conveyor) {
    const c=node.conveyor, g=wrappedBeltGeometry(c.length,c.belt_width,c.radius)
    g.translate(0,-CONVEYOR_BELT_TOP_Y+c.radius,0)
    if(c.axis==='z')g.rotateY(Math.PI/2)
    g.scale(1/node.size[0],1/node.size[1],1/node.size[2])
    return g
  }
  if(node.shape==='leveling_foot'){
    const foot=new CylinderGeometry(.5,.5,.55,32);foot.translate(0,-.225,0)
    const thread=new CylinderGeometry(.13,.13,.45,20);thread.translate(0,.275,0)
    const g=mergeGeometries([foot,thread]);foot.dispose();thread.dispose();return g
  }
  if(!node.material&&node.shape==='cylinder'&&/(?:cylinder|clamp_drive|align_.*_drive|jaw_drive|lift_body)/.test(node.id)){
    // Extruded pneumatic barrel and machined end caps within the original envelope.
    const parts:BufferGeometry[]=[]
    const box=(w:number,h:number,d:number,y:number)=>{const g=new RoundedBoxGeometry(w,h,d,2,.035);g.translate(0,y,0);parts.push(g)}
    box(1.5,.72,1.5,0);box(1.85,.14,1.85,-.43);box(1.85,.14,1.85,.43)
    for(const x of [-.63,.63])for(const z of [-.63,.63]){const g=new CylinderGeometry(.09,.09,.74,12);g.translate(x,0,z);parts.push(g)}
    const converted=parts.map(g=>g.toNonIndexed()),g=mergeGeometries(converted);[...parts,...converted].forEach(p=>p.dispose());return g
  }
  if(isRotaryMotor(node)) {
    // Local Y is the original shaft axis. Keep the full envelope and shaft endpoint.
    const parts:BufferGeometry[]=[]
    const box=(w:number,h:number,d:number,y:number)=>{const g=new RoundedBoxGeometry(w,h,d,2,.025);g.translate(0,y,0);parts.push(g)}
    const cylinder=(r:number,h:number,y:number)=>{const g=new CylinderGeometry(r,r,h,24);g.translate(0,y,0);parts.push(g)}
    box(1.42,.60,1.42,-.04);box(1.22,.14,1.22,-.41)
    box(1.8,.10,1.8,.31);cylinder(.38,.10,.41);cylinder(.23,.04,.48)
    const socket=new RoundedBoxGeometry(.22,.17,.38,2,.02);socket.translate(.82,-.16,0);parts.push(socket)
    const unified=parts.map(p=>p.index?p.toNonIndexed():p),g=mergeGeometries(unified)
    new Set([...parts,...unified]).forEach(p=>p.dispose());return g
  }
  if (node.shape !== 'box' || node.material || node.fragments) return null
  const size = node.size, longest = size.indexOf(Math.max(...size))
  if (Math.min(...size) <= 0) return null
  const cross = size.filter((_, i) => i !== longest)
  const structural = !supportRole(node) && /(?:frame|post|leg|upright|gantry|bridge|profile)/.test(node.id)
    && size[longest] > Math.max(...cross) * 3 && Math.max(...cross) / Math.min(...cross) < 1.15
    && Math.max(...cross) < .16
  const geometry = structural ? makeSlottedProfile(Math.min(...cross), size[longest])
    : new RoundedBoxGeometry(...size, 2, Math.min(.006, Math.min(...size) * .06))
  if (structural) {
    if (longest === 0) geometry.rotateZ(Math.PI / 2)
    if (longest === 2) geometry.rotateX(Math.PI / 2)
    // Rectangular variants keep their specified cross section.
    geometry.computeBoundingBox()
    const box = geometry.boundingBox!
    geometry.scale(size[0] / (box.max.x-box.min.x), size[1] / (box.max.y-box.min.y), size[2] / (box.max.z-box.min.z))
  }
  geometry.scale(1 / size[0], 1 / size[1], 1 / size[2])
  return geometry
}
export function isWorkbenchDeck(node:Node){
  return !node.material&&!node.conveyor&&node.shape==='box'&&node.size[1]<=.12
    &&Math.min(node.size[0],node.size[2])>=.18&&node.p[1]>.4&&node.p[1]<1.2
    &&(node.fixed_transfer||/(?:_beam$|table|_deck$|_bed$|source_surface|_base$)/.test(node.id))
    &&!/(?:carriage|saddle|pad|motor|jaw|guard|contact)/.test(node.id)
}
export function hardwareFinish(node: Node) {
  const sensor=!node.material&&(/photo|sensor|detector/i.test(node.id)||/Sensor|Detector/.test(node.name))
  if(sensor&&!/(?:_post|_mount|_support|_bracket)$/.test(node.id))return {color:/lens|Lens/.test(node.id+' '+node.name)?PHOTOEYE_STYLE.lensColor:'#2b323b',roughness:.8,metalness:.15,envMapIntensity:.25}

  if(isWorkbenchDeck(node))return {color:TABLE_FINISH.top,roughness:TABLE_FINISH.roughness,metalness:TABLE_FINISH.metalness,envMapIntensity:TABLE_FINISH.envMapIntensity}
  if(/^upper_grip-?1$/.test(node.id))return {color:FINISH.steel,...satinFinish(.7,.4)}
  const support=supportRole(node)
  if(support)return {color:support==='rail'?FINISH.alloy:FINISH.dark,roughness:.68,metalness:.35,envMapIntensity:.5}
  if (!node.material && /photo/i.test(node.id) && !/(post|lens)/i.test(node.id)) return {color:'#303b45',roughness:.78,metalness:.15}
  if (node.fixed_transfer) return {color:'#7f8f9c',...satinFinish(.64,.65)}
  if (vesselWall(node))
    return {color:'#a4c3c7',roughness:.4,metalness:.02,envMapIntensity:.5}
  if (!node.material && /(?:leg|post|upright|underframe|stretcher)/i.test(node.id)) return {color:TABLE_FINISH.leg,roughness:TABLE_FINISH.roughness,metalness:TABLE_FINISH.metalness,envMapIntensity:TABLE_FINISH.envMapIntensity}
  if (node.material) return { color: node.color, roughness: .66, metalness: .12, envMapIntensity: .5 }
  if (node.shape==='conveyor_belt' || /(?:belt|rubber|seal|contact_pad|jaw_pad|_surface$)/.test(node.id))
    return { color: '#252e34', roughness: .94, metalness: .02, envMapIntensity: .5 }
  if (isRotaryMotor(node)) return { color: FINISH.dark, ...satinFinish(.66,.60) }
  if (node.shape==='leveling_foot') return { color: '#35434e', roughness:.84, metalness:.12 }
  if (node.conveyor_hardware) return { color: node.color, ...satinFinish(.64,.65) }
  const color = /(?:frame|post|leg|upright|gantry|bridge|profile)/.test(node.id) ? FINISH.alloy
    : /(?:rod|shaft|screw|roller|rail|guide|finger|jaw|plate|deck|tine|spine|bearing)/.test(node.id) ? FINISH.steel
    : /(?:motor|housing|cylinder|jaw_drive|clamp_drive|align_.*_drive)/.test(node.id) ? FINISH.alloy
    : /(?:actuator|carriage|slide|saddle|support_beam|stand_beam|mandrel_stand|core_stop|leader_grip|align_front|pusher$|_stay$)/.test(node.id) ? FINISH.steel : node.color
  return { color, ...satinFinish(.64, .65) }
}
export function hardwareOpacity(node: Node) {
  // Keep the liquid observable, but make the wall connecting base and rim
  // legible against the standard light factory background.
  return vesselWall(node) ? Math.max(.48,node.opacity ?? 1) : node.opacity ?? 1
}
