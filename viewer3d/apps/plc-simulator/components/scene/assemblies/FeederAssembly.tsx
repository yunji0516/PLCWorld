import {TABLE_FINISH} from './tableFinish'
import { useRef } from 'react'
import { useFrame } from '@react-three/fiber'
import { MathUtils, type Group, type Mesh } from 'three'
import type { DeviceProps } from '../devices'
import { feederStackOffset } from '../deviceGeometry'
import { SlottedProfileGeometry, SocketBolt } from '../IndustrialDetails'
import { satinFinish } from '../surfaceFinish'
import { FINISH, Part } from './Parts'

export function FeederAssembly({ device, plant }: DeviceProps) {
  const stack = useRef<Group>(null), stocks = useRef<(Mesh | null)[]>([])
  const [w, h, d] = device.size, edge = .055
  const panelHeight = Math.max(.02, h - .20 - edge), panelY = (.20 - edge) / 2
  useFrame((_, delta) => {
    const stock = Math.max(0, Math.min(3, Math.round(plant.state(device.id).pos * 3)))
    const actuator = device.actuatorRef ? plant.state(device.actuatorRef).pos : 0
    stocks.current.forEach((m, i) => { if (m) m.visible = i < (stock === 3 ? 2 : stock) })
    if (stack.current) stack.current.position.y = MathUtils.damp(stack.current.position.y, feederStackOffset(stock, actuator), 14, delta)
  })
  return <group name="assembly-feeder-v1">
    {[-1, 1].flatMap(x => [-1, 1].map(z => <mesh key={`${x}:${z}`} position={[x * (w / 2 - edge / 2), -edge / 2, z * (d / 2 - edge / 2)]} castShadow>
      <SlottedProfileGeometry edge={edge} length={h - edge} />
      <meshStandardMaterial color={TABLE_FINISH.leg} roughness={TABLE_FINISH.roughness} metalness={TABLE_FINISH.metalness} envMapIntensity={TABLE_FINISH.envMapIntensity} />
    </mesh>))}
    {[-1, 1].map(s => <group key={s}>
      <Part size={[w, edge, edge]} position={[0, h / 2 - edge / 2, s * (d / 2 - edge / 2)]} />
      <Part size={[edge, edge, d - 2 * edge]} position={[s * (w / 2 - edge / 2), h / 2 - edge / 2, 0]} />
      <SocketBolt position={[s * (w / 2 - edge / 2), h / 2 + .002, d / 2 - edge / 2]} top radius={.007} />
      <mesh name="feeder-inspection-pane" position={[s * (w / 2 - .008), panelY, 0]}>
        <boxGeometry args={[.008, panelHeight, d - 2 * edge]} />
        <meshStandardMaterial color="#a7c5ce" transparent opacity={.16} roughness={.65} depthWrite={false} />
      </mesh>
      <mesh name="feeder-inspection-pane" position={[0, panelY, s * (d / 2 - .008)]}>
        <boxGeometry args={[w - 2 * edge, panelHeight, .008]} />
        <meshStandardMaterial color="#a7c5ce" transparent opacity={.16} roughness={.65} depthWrite={false} />
      </mesh>
      {/* Inner wear guides start above the outlet, leaving the pusher path open. */}
      <Part name="feeder-stock-guide" size={[.024, h - .2425, .045]} position={[s * .101, .07875, 0]} color={FINISH.dark} radius={.003} />
      <Part name="feeder-guide-adjuster" size={[w / 2 - edge - .089, .025, .045]} position={[s * (w / 2 - edge + .089) / 2, h / 2 - .03, 0]} />
      <SocketBolt position={[s * .13, h / 2 - .014, 0]} top radius={.008} />
      {/* Pane retaining clips sit on the frame, outside the workpiece corridor. */}
      {[-1, 1].map(y => <Part key={y} size={[.026, .045, .012]} position={[s * (w / 2 - .038), panelY + y * panelHeight * .35, d / 2 + .006]} color={FINISH.dark} />)}
    </group>)}
    <group ref={stack} name="feeder-recorded-stock">
      {[0, 1].map(i => <mesh key={i} ref={m => { stocks.current[i] = m }} name={`feeder-reserve-${i}`} position={[0, -h / 2 + .08 + (1 + i) * .18, 0]} castShadow>
        <boxGeometry args={[.16, .16, .16]} />
        <meshStandardMaterial color="#c98a3c" roughness={.65} />
      </mesh>)}
    </group>
  </group>
}
