'use client'
import {MaterialTableLegs} from './MaterialTableLegs'

import {TABLE_FINISH,tablePartRole} from './tableFinish'
import { useFrame } from '@react-three/fiber'
import { useRef } from 'react'
import * as THREE from 'three'
import type { DeviceSpec } from '@/lib/machine/infer'
import type { Plant } from '@/lib/machine/plant'

type Props = { device: DeviceSpec; plant: Plant }
type V3 = [number, number, number]
const steel = '#8797a4', dark = '#304956', teal = '#167d83'

function Box({ name, pos = [0, 0, 0], size, color = steel }: { name?: string; pos?: V3; size: V3; color?: string }) {
  const role=tablePartRole(name)
  return <mesh name={name} position={pos} castShadow receiveShadow>
    <boxGeometry args={size} /><meshStandardMaterial color={role?TABLE_FINISH[role]:color} metalness={role?TABLE_FINISH.metalness:.55} roughness={role?TABLE_FINISH.roughness:.35} />
  </mesh>
}

/** Positions are replay poses. Only jaw displacement, markings and roller angle
 * are projected from recorded scalar states; no time accumulation or physics. */
export function WebIndexHardware({ device: d, plant }: Props) {
  const jaw = useRef<THREE.Group>(null)
  const rod = useRef<THREE.Mesh>(null)
  const roller = useRef<THREE.Group>(null)
  const markings = useRef<THREE.Group>(null)
  const fiducial = useRef<THREE.Mesh>(null)
  const target = useRef<THREE.Group>(null)
  const led = useRef<THREE.MeshStandardMaterial>(null)
  const guides = useRef<(THREE.Group | null)[]>([])
  const g = d.webGeometry!
  const variant = d.visualVariant
  const [w, , depth] = d.size
  useFrame(() => {
    const value = plant.state(d.id).pos
    if (jaw.current) jaw.current.position.y = (1 - value) * g.jaw_open_m
    if (rod.current) {
      const bottom = g.thickness_m / 2 + g.jaw_height_m + (1 - value) * g.jaw_open_m
      rod.current.position.y = (.063 + bottom) / 2
      rod.current.scale.y = .063 - bottom
    }
    if (led.current) {
      led.current.color.set(value >= .999 ? '#29b995' : '#d99a35')
      led.current.emissive.set(value >= .999 ? '#125c48' : '#5b350e')
    }
    if (roller.current) roller.current.rotation.z = -value * .001 / g.roller_radius_m
    if (markings.current) markings.current.position.x = ((value * .001) % g.marker_pitch_m + g.marker_pitch_m) % g.marker_pitch_m
    if (fiducial.current) fiducial.current.position.x = g.marker_origin_x + value * .001 - d.pos[0]
    if (target.current) target.current.position.x = value * .001
    if (variant === 'web-index-base') for (const guide of guides.current) {
      if (guide) guide.rotation.z = -plant.state('WEB_STRIP').pos * .001 / (g.roller_radius_m * .48)
    }
  })

  if (variant === 'web-index-base') {
    // Table top at .7025 m, rails top .740 m; all legs reach the floor.
    return <group>
      <Box name="web-table-top" pos={[0, .32, 0]} size={[w, .025, depth]} />
      <group position={[0,-.37,0]}><MaterialTableLegs halfX={.28} halfZ={.13} top={.6775}/></group>
      {[-.065, .065].map(z => <group key={z}>
        <Box pos={[-.08, .345, z]} size={[.36, .025, .035]} color={dark} />
        <Box name={`web-guide-rail-${z}`} pos={[-.08, .363, z]} size={[.36, .014, .014]} />
      </group>)}
      <Box pos={[-.275, .355, 0]} size={[.045, .045, .048]} color={teal} />
      <mesh position={[-.08, .358, 0]} rotation={[0, 0, Math.PI / 2]} castShadow>
        <cylinderGeometry args={[.004, .004, .34, 24]} /><meshStandardMaterial color={steel} metalness={.8} roughness={.3} />
      </mesh>
      {/* Cable/control enclosure mounted clear of the strip and return path. */}
      <Box pos={[.23, .36, -.125]} size={[.10, .08, .055]} color="#d7dfe3" />
      {/* Passive guides support the pre-threaded strip at both episode boundaries. */}
      {[-1, 1].map((sign, i) => <group key={sign} position={[sign * (w / 2 - .015), .4374, 0]}>
        {[-.058, .058].map(z => <Box key={z} pos={[0, -.048, z]} size={[.012, .114, .014]} color={dark} />)}
        <group name={`web-guide-rotation-${i}`} ref={o => { guides.current[i] = o }}>
          <mesh name={`web-guide-cylinder-${i}`} rotation={[Math.PI / 2, 0, 0]} castShadow>
            <cylinderGeometry args={[g.roller_radius_m * .48, g.roller_radius_m * .48, .10, 32]} />
            <meshStandardMaterial color="#b9c7cb" metalness={.65} roughness={.3} />
          </mesh>
          <Box pos={[0, 0, .051]} size={[.018, .002, .001]} color={dark} />
        </group>
      </group>)}
    </group>
  }
  if (variant === 'web-feed-carriage') return <group>
    <Box name="web-carriage-body" size={d.size} color="#a1adb7" />
    {[-.065, .065].map(z => <Box key={z} pos={[0, -.004, z]} size={[.06, .017, .025]} color={dark} />)}
    <Box pos={[-.035, .016, -.068]} size={[.013, .009, .017]} color={teal} />
  </group>

  if (variant === 'web-moving-grip' || variant === 'web-receiver-clamp') {
    const moving = variant === 'web-moving-grip'
    const lower = -(g.thickness_m + g.jaw_height_m) / 2
    const upper = -lower
    const bottom = moving ? -.055 : -.1175
    const columnTop = .063
    const columnHeight = columnTop - bottom
    return <group>
      {/* Columns flank the strip; they do not occupy its transport path. */}
      {[-1, 1].map(sign => <Box key={sign} pos={[0, bottom + columnHeight / 2, sign * (depth / 2 - .008)]}
        size={[.018, columnHeight, .016]} color={dark} />)}
      <Box pos={[0, .07, 0]} size={[w + .015, .014, depth]} color={dark} />
      <Box pos={[0, .098, 0]} size={[w * .65, .042, .034]} color={moving ? '#a77735' : teal} />
      <Box pos={[0, bottom + .008, 0]} size={[w + .012, .016, depth]} />
      <Box name={`web-lower-jaw-${d.id}`} pos={[0, lower, 0]} size={[w, g.jaw_height_m, depth - .025]} />
      <group ref={jaw} name={`web-upper-jaw-${d.id}`}>
        <Box name={`web-upper-pad-${d.id}`} pos={[0, upper, 0]} size={[w, g.jaw_height_m, depth - .025]} color={moving ? '#c8974c' : teal} />
      </group>
      <mesh ref={rod} name={`web-actuator-rod-${d.id}`} castShadow>
        <boxGeometry args={[.008, 1, .008]} /><meshStandardMaterial color={steel} metalness={.8} roughness={.3} />
      </mesh>
      <mesh position={[w / 2 + .004, .057, depth / 2 - .005]}>
        <sphereGeometry args={[.0035, 12, 8]} /><meshStandardMaterial ref={led} color="#d99a35" />
      </mesh>
    </group>
  }
  if (variant === 'web-meter-roll') return <group>
    {[-.058, .058].map(z => <group key={z}>
      <Box pos={[0, -.0254, z]} size={[.025, .103, .018]} color={dark} />
      <Box pos={[0, -.0844, z]} size={[.065, .015, .028]} />
    </group>)}
    <group ref={roller} name="web-meter-rotation">
      <mesh name="web-meter-cylinder" rotation={[Math.PI / 2, 0, 0]} castShadow receiveShadow>
        <cylinderGeometry args={[g.roller_radius_m, g.roller_radius_m, .105, 48]} />
        <meshStandardMaterial color="#e2b765" metalness={.65} roughness={.32} />
      </mesh>
      {[0, Math.PI / 2].map(angle => <group rotation={[0, 0, angle]} key={angle}>
        <Box pos={[0, 0, .0535]} size={[.04, .0025, .002]} color={dark} />
      </group>)}
    </group>
    <Box pos={[0, 0, -.081]} size={[.032, .036, .025]} color={teal} />
  </group>
  if (variant === 'web-strip') {
    const pitch = g.marker_pitch_m
    const count = Math.floor(w / pitch) - 1
    return <group>
      <mesh name="web-continuous-sheet" receiveShadow>
        <boxGeometry args={d.size} /><meshStandardMaterial color="#77bac2" metalness={.45} roughness={.4} side={THREE.DoubleSide} />
      </mesh>
      {/* These marks are material texture, not separate generated workpieces. */}
      <group ref={markings} name="web-material-markings">
        {Array.from({ length: count }, (_, i) => <Box key={i} pos={[-w / 2 + (i + .25) * pitch, g.thickness_m / 2 + .00012, 0]}
          size={[.001, .0002, depth * .65]} color="#31565e" />)}
      </group>
      <mesh ref={fiducial} name="web-material-fiducial" position={[0, g.thickness_m / 2 + .0004, 0]}>
        <boxGeometry args={[.002, .0005, depth]} /><meshStandardMaterial color="#db622f" roughness={.8} />
      </mesh>
    </group>
  }
  if (variant === 'web-target') return <group ref={target} name="web-request-target">
    {[-1, 1].map(sign => <group key={sign} position={[0, 0, sign * .052]}>
      <Box size={[.0015, .001, .016]} color="#e0a91d" />
      <Box pos={[-.004, 0, sign * .006]} size={[.009, .001, .002]} color="#e0a91d" />
    </group>)}
  </group>
  return null
}
