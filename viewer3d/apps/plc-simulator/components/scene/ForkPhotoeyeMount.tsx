import { useEffect, useMemo } from 'react'
import { ExtrudeGeometry, Shape } from 'three'
import { SocketBolt } from './IndustrialDetails'
import { FINISH, Part } from './assemblies/Parts'
import { satinFinish } from './surfaceFinish'
import { FORK_PHOTOEYE_MOUNT, FORK_PHOTOEYE_WEB as web } from './forkPhotoeyeMountGeometry'

/** A carriage-supported pedestal, not a bracket hanging from thin face straps. */
export function ForkPhotoeyeMount() {
  const geometry = useMemo(() => {
    // Build the triangle in XY as (z,y), then rotate it into the YZ plane.
    const shape = new Shape()
    web.yz.forEach(([y, z], i) => i ? shape.lineTo(z, y) : shape.moveTo(z, y))
    shape.closePath()
    const g = new ExtrudeGeometry(shape, { depth: web.thickness, bevelEnabled: false })
    g.translate(0, 0, -web.thickness / 2)
    g.rotateY(-Math.PI / 2)
    return g
  }, [])
  useEffect(() => () => geometry.dispose(), [geometry])
  return <group name="fork-photoeye-braced-pedestal">
    {FORK_PHOTOEYE_MOUNT.map(part => <Part key={part.name} {...part} radius={.002} />)}
    {web.sides.map(x => <mesh key={x} name="fork-photoeye-triangular-web" position={[x, 0, 0]} geometry={geometry} castShadow receiveShadow>
      <meshStandardMaterial color={FINISH.steel} {...satinFinish(.64, .65)} />
    </mesh>)}
    {[-1, 1].map(side => <group key={side}>
      {[.060, .120].map(z => <SocketBolt key={z} top position={[side * .052, -.113, z]} radius={.005} />)}
      <Part name="fork-photoeye-retaining-ear" size={[.012, .07, .03]} position={[side * .044, -.020, .020]} radius={.002} />
      <group rotation={[0, Math.PI, 0]}>
        <SocketBolt position={[side * .044, -.003, -.005]} radius={.0045} />
      </group>
    </group>)}
  </group>
}
