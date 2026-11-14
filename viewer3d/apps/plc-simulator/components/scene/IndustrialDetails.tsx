import { useEffect, useMemo } from 'react'
import { RoundedBoxGeometry } from 'three/examples/jsm/geometries/RoundedBoxGeometry.js'
import { makeSlottedProfile } from './profileGeometry'
import { satinFinish } from './surfaceFinish'

export function SlottedProfileGeometry({ edge, length }: { edge: number; length: number }) {
  const geometry = useMemo(() => makeSlottedProfile(edge, length), [edge, length])
  useEffect(() => () => geometry.dispose(), [geometry])
  return <primitive object={geometry} attach="geometry" />
}

/** Same outside dimensions as the original box, with small machined edge radii. */
export function MachinedBoxGeometry({ args, detailed, radius }: { args: [number, number, number]; detailed?: boolean; radius?: number }) {
  const [w, h, d] = args
  const geometry = useMemo(() => detailed
    ? new RoundedBoxGeometry(w, h, d, 2, radius ?? Math.min(.008, Math.min(w, h, d) * .08)) : null,
  [w, h, d, detailed, radius])
  useEffect(() => () => geometry?.dispose(), [geometry])
  return geometry ? <primitive object={geometry} attach="geometry" /> : <boxGeometry args={args} />
}

/** Decorative socket head fastener. No I/O, collision, or independent motion. */
export function SocketBolt({ position, radius = .009, top = false }: {
  position: [number, number, number]; radius?: number; top?: boolean
}) {
  return <group name="visual-fastener" position={position} rotation={top ? [-Math.PI / 2, 0, 0] : [0, 0, 0]}>
    <mesh rotation={[Math.PI / 2, 0, 0]} raycast={() => null}>
      <cylinderGeometry args={[radius, radius, radius * .6, 12]} />
      <meshStandardMaterial color="#8c969f" {...satinFinish(.28, .85)} />
    </mesh>
    <mesh position={[0, 0, radius * .31]} rotation={[Math.PI / 2, 0, 0]} raycast={() => null}>
      <cylinderGeometry args={[radius * .44, radius * .44, .0004, 6]} />
      <meshStandardMaterial color="#20252b" metalness={.2} roughness={.85} />
    </mesh>
  </group>
}
