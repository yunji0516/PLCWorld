import {TABLE_FINISH} from './tableFinish'
import { useEffect, useMemo } from 'react'
import type { DeviceProps } from '../devices'
import { SlottedProfileGeometry, SocketBolt } from '../IndustrialDetails'
import { satinFinish } from '../surfaceFinish'
import { FINISH, Part } from './Parts'
import { rackShelfGeometry } from './storageGeometry'

export function RackAssembly({ device }: DeviceProps) {
  const [w, h, d] = device.size
  const g = useMemo(() => rackShelfGeometry(w, d), [w, d])
  useEffect(() => () => g.dispose(), [g])
  const levels = [-h / 2 + .12, 0, h / 2 - .22]
  return <group name="assembly-rack-v1">
    {[-1, 1].flatMap(x => [-1, 1].map(z => <mesh key={`${x}:${z}`} position={[x * (w / 2 - .045), 0, z * (d / 2 - .045)]} castShadow>
      <SlottedProfileGeometry edge={.09} length={h} />
      <meshStandardMaterial color={TABLE_FINISH.leg} roughness={TABLE_FINISH.roughness} metalness={TABLE_FINISH.metalness} envMapIntensity={TABLE_FINISH.envMapIntensity} />
    </mesh>))}
    {levels.map((y, i) => <group key={i} name="rack-shelf-level" position={[0, y, 0]}>
      <mesh name="rack-relieved-shelf-pan" castShadow receiveShadow>
        <primitive object={g} attach="geometry" />
        <meshStandardMaterial color={FINISH.alloy} {...satinFinish(.75, .5)} />
      </mesh>
      {[-1, 1].map(s => <group key={s}>
        <Part name="rack-load-crossmember" size={[w - .18, .052, .06]} position={[0, -.009, s * (d / 2 - .045)]} color={FINISH.dark} />
        <Part name="rack-side-apron" size={[.028, .052, d - .18]} position={[s * (w / 2 - .045), -.009, 0]} color={FINISH.dark} />
        <SocketBolt position={[s * (w / 2 - .045), -.008, d / 2 + .002]} radius={.008} />
      </group>)}
    </group>)}
    {/* Rear-only diagonal stiffener leaves both fork entry paths open. */}
    <group position={[0, 0, -d / 2 - .0125]} rotation={[0, 0, -Math.atan2(w - .18, h - .24)]}>
      <Part name="rack-rear-brace" size={[.025, Math.hypot(w - .18, h - .24), .025]} color={FINISH.dark} />
    </group>
  </group>
}
