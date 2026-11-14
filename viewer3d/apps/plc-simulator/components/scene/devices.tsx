'use client'
import {WideGripperRearYoke} from './assemblies/WideGripperRearYoke'
import {MotionMachineBase} from './assemblies/MotionMachineBase'
import {MaterialTableLegs} from './assemblies/MaterialTableLegs'
import {CompactPhotoeye} from './assemblies/ReviewPhotoeyes'
import {CouplingHead} from './assemblies/MaterialEasyFocusHardware'

import {MaterialMediumFinish} from './assemblies/MaterialMediumFinish'
import {HardStationSupport,isHardStationSupport} from './assemblies/HardStationSupport'
import { platformSeating } from './platformSeating'
import {MotionRealism,useMotionRealism} from './assemblies/MotionRealism'
import {TABLE_FINISH} from './assemblies/tableFinish'
import {ComposableHardware} from './assemblies/ComposableHardware'
import {MaterialFlowCellHardware} from './assemblies/MaterialFlowCellHardware'
import {MaterialRedesignHardware} from './assemblies/MaterialRedesignHardware'
import { MaterialReplenishmentHardware } from './assemblies/MaterialReplenishmentHardware'









import { useFrame } from '@react-three/fiber'
import { MotionHardHardware } from './assemblies/MotionHardHardware'
import { MotionDiverseHardware } from './assemblies/MotionDiverseHardware'
import { MotionMediumDetails } from './assemblies/MotionMediumDetails'
import { MotionHoldingBrake } from './assemblies/MotionHoldingBrake'
import { MotionEasyHardware } from './assemblies/MotionEasyHardware'
import { MaterialAdvancedHardware } from './assemblies/MaterialAdvancedHardware'
import { MaterialEasy15Hardware } from './assemblies/MaterialEasy15Hardware'
import {IndexEquipmentPalette,industrialEquipmentColor} from './assemblies/IndexEquipmentPalette'
import {MaterialPresentation,useMaterialPresentation} from './assemblies/MaterialPresentation'
import {MotionCellFloorOffset, MotionPresentation, useMotionPresentation, GantryBeam, MotionProcessDetail, useMotionProcessDetail} from './assemblies/MotionPresentation'
import { MaterialExtensionHardware } from './assemblies/MaterialExtensionHardware'
import { MaterialInventoryHardware } from './assemblies/MaterialInventoryHardware'
import { WebIndexHardware } from './assemblies/WebIndexHardware'
import { VacuumMast } from './assemblies/VacuumMast'
import { MaterialV6Hardware } from './assemblies/MaterialV6Hardware'
import { ForkClearanceRack } from './assemblies/ForkClearanceRack'
import { MaterialHard15Hardware } from './assemblies/MaterialHard15Hardware'
import { MaterialHardPriorityHardware } from './assemblies/MaterialHardPriorityHardware'
import { MaterialWindTapeHardware } from './assemblies/MaterialWindTapeHardware'
import { MaterialMiniProcessHardware } from './assemblies/MaterialMiniProcessHardware'
import { MaterialTapeHardware } from './assemblies/MaterialTapeHardware'
import { TendingHardware } from './assemblies/TendingHardware'
import { createContext, useContext, useMemo, useRef } from 'react'
import * as THREE from 'three'
import {
  clampGeometry,
  CONVEYOR_BELT_CENTER_Y,
  CONVEYOR_BELT_HEIGHT,
  cylinderContact,
  feederStackOffset,
  PHOTOEYE_LENS_FRONT,
  photoeyeVisibleLength,
  turnoverGripGeometry,
  SINGLE_VACUUM_CUP,
} from './deviceGeometry'
import type { DeviceSpec } from '@/lib/machine/infer'
import type { Plant } from '@/lib/machine/plant'
import { MachinedBoxGeometry, SlottedProfileGeometry, SocketBolt } from './IndustrialDetails'
import { satinFinish } from './surfaceFinish'
import { PHOTOEYE_STYLE } from './photoeyeStyle'
import { aimPhotoeye, aimedPhotoeyeLength } from './photoeyeAim'
import { createPhotoeyeWidthLimiter } from './photoeyeProjection'
import { ForkPhotoeyeMount } from './ForkPhotoeyeMount'
import { ServoAssembly } from './assemblies/ServoAssembly'
import { CylinderAssembly } from './assemblies/CylinderAssembly'
import { GripperAssembly } from './assemblies/GripperAssembly'
import { slideGripperMountGeometry } from './assemblies/geometry'
import { ConveyorAssembly } from './assemblies/ConveyorAssembly'
import { VacuumAssembly } from './assemblies/VacuumAssembly'
import { LiftLoadDeck, SlideCarriageBody, SlideEndCap } from './assemblies/GuidedMotionParts'
import { liftDeckPosition, slideCarriagePosition } from './assemblies/transportGeometry'
import { ClampAssembly } from './assemblies/ClampAssembly'
import { DoorAssembly } from './assemblies/DoorAssembly'
import { TurntableAssembly } from './assemblies/TurntableAssembly'
import { FeederAssembly } from './assemblies/FeederAssembly'
import { ForkAssembly } from './assemblies/ForkAssembly'
import { RackAssembly } from './assemblies/RackAssembly'
import { StopperAssembly } from './assemblies/StopperAssembly'
import { PressAssembly } from './assemblies/PressAssembly'
import { MachiningSpindle } from './assemblies/MachiningAssembly'
import { PressureSealHead, PressureTestModule, TestAirValve } from './assemblies/PressureTestAssembly'
import { CompactTransferBelt } from './assemblies/CompactTransferBelt'
import { RobotAssembly } from './assemblies/RobotAssembly'
import { PalletLocatorAssembly, LocatorPalletAssembly, ContactHeightGaugeAssembly } from './assemblies/PalletLocatorAssembly'
import { CornerWeb, RoundPart, Part as HardwarePart, FINISH } from './assemblies/Parts'

const SatinFinishContext = createContext(false)

export interface DeviceProps {
  device: DeviceSpec
  plant: Plant
  detailed?: boolean
}


function useMetal(color: string, opts: { rough?: number; metal?: number } = {}) {
  const satin = useContext(SatinFinishContext)
  const industrial=useContext(IndexEquipmentPalette)==='industrial'
  return useMemo(
    () =>
      new THREE.MeshStandardMaterial({
        color:industrial?industrialEquipmentColor(color):color,
        roughness: opts.rough ?? 0.55,
        metalness: opts.metal ?? 0.65,
        ...(satin ? satinFinish(opts.rough ?? .55, opts.metal ?? .65) : {}),
      }),
    [color, opts.rough, opts.metal, satin, industrial],
  )
}


function useSignal(color: string) {
  return useMemo(
    () =>
      new THREE.MeshStandardMaterial({
        color,
        emissive: new THREE.Color(color),
        emissiveIntensity: 0,
        roughness: 0.35,
        metalness: 0.1,
      }),
    [color],
  )
}



function Conveyor({ device, plant, detailed }: DeviceProps) {
  const [len, , wid] = device.size
  const cleats = useRef<THREE.InstancedMesh>(null)
  const frame = useMetal(detailed ? '#a4afb9' : '#3c444f', { rough: detailed ? .32 : 0.7 })
  const belt = useMetal('#1a1e25', { rough: 0.95, metal: 0.1 })
  const dummy = useMemo(() => new THREE.Object3D(), [])
  const N = Math.max(6, Math.round(len / 0.32))

  useFrame(() => {
    const s = plant.state(device.id)
    const m = cleats.current
    if (!m) return
    const span = len
    const markerSpan = Math.max(0.1, len - 0.20)


    const offset = (s.spin / (Math.PI * 2)) * span
    for (let i = 0; i < N; i++) {
      const x = (((i / N) * markerSpan + offset) % markerSpan + markerSpan) % markerSpan


      dummy.position.set(x - markerSpan / 2, 0.1015, 0)
      dummy.updateMatrix()
      m.setMatrixAt(i, dummy.matrix)
    }
    m.instanceMatrix.needsUpdate = true
  })

  return (
    <group>
      {}
      <mesh material={belt} position={[0, CONVEYOR_BELT_CENTER_Y, 0]} castShadow receiveShadow>
        <boxGeometry args={[len, CONVEYOR_BELT_HEIGHT, wid]} />
      </mesh>
      {}
      <instancedMesh ref={cleats} args={[undefined, undefined, N]} castShadow>
        <boxGeometry args={[0.08, 0.002, wid * 0.22]} />
        <meshStandardMaterial color="#303843" roughness={0.88} metalness={0.08} />
      </instancedMesh>
      {}
      <mesh material={frame} position={[0, -0.02, wid / 2 + 0.045]} castShadow>
        <MachinedBoxGeometry args={[len, 0.14, 0.06]} detailed={detailed} />
      </mesh>
      <mesh material={frame} position={[0, -0.02, -wid / 2 - 0.045]} castShadow>
        <MachinedBoxGeometry args={[len, 0.14, 0.06]} detailed={detailed} />
      </mesh>
      {detailed && [-1, 1].map(side => <group key={`roller-${side}`}>
        <mesh position={[side * (len / 2 - .08), 0, 0]} rotation={[Math.PI / 2, 0, 0]} castShadow>
          <cylinderGeometry args={[.072, .072, wid + .08, 24]} />
          <meshStandardMaterial color="#bfc6cd" {...satinFinish(.28, .85)} />
        </mesh>
        <SocketBolt position={[side * (len / 2 - .12), -.02, wid / 2 + .078]} radius={.018} />
      </group>)}
      {}
      {[-len / 2 + 0.25, len / 2 - 0.25].map((x) => (
        <group key={x}>
          {[wid / 2 + 0.045, -wid / 2 - 0.045].map((z) => (
            <mesh key={z} material={frame} position={[x, -device.pos[1] / 2 - 0.045, z]} castShadow>
              {detailed ? <SlottedProfileGeometry edge={.07} length={Math.max(.08, device.pos[1] - .09)} />
                : <boxGeometry args={[0.07, Math.max(0.08, device.pos[1] - 0.09), 0.07]} />}
            </mesh>
          ))}
        </group>
      ))}
    </group>
  )
}




function ServoAxis({ device, plant, detailed }: DeviceProps) {
  const carriage = useRef<THREE.Group>(null)
  const [len, height, width] = device.size
  const rail = useMetal(detailed ? '#aab5bf' : '#303a46', { rough: detailed ? .3 : .55, metal: 0.82 })
  const carriageBody = useMetal(detailed ? '#bac3ca' : '#647180', { rough: detailed ? .3 : .4, metal: 0.78 })
  const statusPlate = useMetal(device.color, { rough: 0.34, metal: 0.72 })

  useFrame(() => {
    const s = plant.state(device.id)
    if (carriage.current) carriage.current.position.x = (s.pos - 0.5) * Math.max(0.1, len - 0.3)
  })

  const orientation: [number, number, number] =
    device.motionAxis === 'y' ? [0, 0, Math.PI / 2]
      : device.motionAxis === 'z' ? [0, -Math.PI / 2, 0]
        : [0, 0, 0]

  return (
    <group rotation={orientation}>
      <mesh material={rail} castShadow receiveShadow>
        <MachinedBoxGeometry args={[len, Math.max(0.06, height * 0.24), width]} detailed={detailed} />
      </mesh>
      <mesh material={rail} position={[0, height * 0.22, -width * 0.28]} castShadow>
        <boxGeometry args={[len * 0.96, Math.max(0.035, height * 0.13), width * 0.12]} />
      </mesh>
      <mesh material={rail} position={[0, height * 0.22, width * 0.28]} castShadow>
        <boxGeometry args={[len * 0.96, Math.max(0.035, height * 0.13), width * 0.12]} />
      </mesh>
      {detailed && <group name="servo-guide-assembly">
        {/* Recessed drive cover between the two guide rails. */}
        <mesh position={[0, height * .13, 0]}>
          <MachinedBoxGeometry args={[len * .86, .018, width * .23]} detailed />
          <meshStandardMaterial color="#303943" roughness={.55} metalness={.35} />
        </mesh>
        {[-1, 1].map(side => <group key={side}>
          <mesh material={carriageBody} position={[side * (len / 2 - .045), 0, 0]} castShadow>
            <MachinedBoxGeometry args={[.09, Math.max(.035, height * .2), width * .93]} detailed />
          </mesh>
          {[-1, 1].map(z => <SocketBolt key={z} position={[side * (len / 2 - .045), Math.max(.035, height * .2) / 2 + .001, z * width * .32]} radius={.004} top />)}
        </group>)}
      </group>}
      <group name="servo-moving-carriage" ref={carriage} position={[-(len - 0.3) / 2, height * 0.38, 0]}>
        {}
        <mesh material={carriageBody} castShadow>
          <MachinedBoxGeometry args={[0.30, Math.max(0.12, height * 0.55), width * 0.92]} detailed={detailed} />
        </mesh>
        {}
        <mesh material={statusPlate} position={[0, Math.max(0.09, height * 0.36), 0]} castShadow>
          <MachinedBoxGeometry args={[0.22, 0.06, width * 0.72]} detailed={detailed} />
        </mesh>
        {detailed && [-1, 1].flatMap(x => [-1, 1].map(z => <SocketBolt key={`${x}:${z}`}
          position={[x * .075, Math.max(.09, height * .36) + .031, z * width * .24]} top />))}
      </group>
    </group>
  )
}



function Cylinder({ device, plant, detailed }: DeviceProps) {
  const rod = useRef<THREE.Mesh>(null)
  const plate = useRef<THREE.Mesh>(null)
  const body = useMetal('#7b838d', { rough: 0.4, metal: 0.85 })
  const rodMat = useMetal('#c8ced4', { rough: 0.2, metal: 0.95 })
  const sensorGroove = useMetal('#252b32', { rough: 0.9, metal: 0.15 })
  const stroke = device.size[2]
  const initial = cylinderContact(stroke, 0, device.rodBaseExtension)

  useFrame(() => {
    const s = plant.state(device.id)
    const geometry = cylinderContact(stroke, s.pos, device.rodBaseExtension)


    if (rod.current) {
      rod.current.position.z = -geometry.bodyHalf - geometry.exposed / 2
      rod.current.scale.y = geometry.exposed
    }
    if (plate.current) plate.current.position.z = geometry.plateCenter
  })

  return (
    <group>
      {}
      <mesh material={body} rotation={[Math.PI / 2, 0, 0]} castShadow>
        <cylinderGeometry args={[0.055, 0.055, stroke * 0.75, 20]} />
      </mesh>
      {}
      <mesh material={sensorGroove} position={[0, 0.056, stroke * 0.03]} castShadow>
        <boxGeometry args={[0.024, 0.004, stroke * 0.55]} />
      </mesh>
      {}
      <mesh material={body} position={[0, 0, stroke * 0.4]} rotation={[Math.PI / 2, 0, 0]} castShadow>
        <cylinderGeometry args={[0.07, 0.07, 0.05, 20]} />
      </mesh>
      {detailed && <>
        <mesh material={body} position={[0, 0, -initial.bodyHalf + .013]} rotation={[Math.PI / 2, 0, 0]} castShadow>
          <cylinderGeometry args={[.065, .065, .026, 32]} />
        </mesh>
        {[-1, 1].flatMap(sx => [-1, 1].map(sy => <group key={`${sx}:${sy}`}>
          <mesh material={rodMat} position={[sx * .041, sy * .041, .01]} rotation={[Math.PI / 2, 0, 0]} castShadow>
            <cylinderGeometry args={[.004, .004, stroke * .72, 10]} />
          </mesh>
          <SocketBolt position={[sx * .041, sy * .041, stroke * .4 + .027]} radius={.007} />
        </group>))}
      </>}
      {}
      <mesh ref={rod} material={rodMat}
        position={[0, 0, -initial.bodyHalf - initial.exposedAtMin / 2]}
        scale={[1, initial.exposedAtMin, 1]} rotation={[Math.PI / 2, 0, 0]} castShadow>
        <cylinderGeometry args={[0.018, 0.018, 1, detailed ? 32 : 12]} />
      </mesh>
      <mesh ref={plate} material={rodMat} position={[0, 0, initial.plateCenter]} castShadow>
        <boxGeometry args={[0.12, 0.14, initial.plateThickness]} />
      </mesh>
    </group>
  )
}



function Door({ device, plant, detailed }: DeviceProps) {
  const left = useRef<THREE.Mesh>(null)
  const right = useRef<THREE.Mesh>(null)
  const [w, h, d] = device.size
  const half = w / 2

  const frame = useMetal('#3a424d', { rough: 0.6 })
  const glass = useMemo(
    () =>
      new THREE.MeshPhysicalMaterial({
        color: '#8fb4c8',
        transparent: true,
        opacity: 0.22,
        roughness: 0.1,
        metalness: 0,
        transmission: 0.6,
        side: THREE.DoubleSide,
      }),
    [],
  )

  useFrame(() => {

    const s = plant.state(device.id)
    const slide = s.pos * (half - 0.08)
    if (left.current) left.current.position.x = -half / 2 - slide
    if (right.current) right.current.position.x = half / 2 + slide
  })

  return (
    <group>
      {}
      <mesh material={frame} position={[0, h / 2, 0]}>
        <MachinedBoxGeometry args={[w + 0.12, 0.09, d + 0.05]} detailed={detailed} />
      </mesh>
      <mesh material={frame} position={[0, -h / 2, 0]}>
        <MachinedBoxGeometry args={[w + 0.12, 0.09, d + 0.05]} detailed={detailed} />
      </mesh>
      {}
      <mesh material={frame} position={[-half - 0.06, 0, 0]}>
        <MachinedBoxGeometry args={[0.09, h - (detailed ? .09 : 0), d + 0.05]} detailed={detailed} />
      </mesh>
      <mesh material={frame} position={[half + 0.06, 0, 0]}>
        <MachinedBoxGeometry args={[0.09, h - (detailed ? .09 : 0), d + 0.05]} detailed={detailed} />
      </mesh>
      {}
      <mesh ref={left} material={glass}>
        <boxGeometry args={[half, h - 0.12, d]} />
        {detailed && <group position={[half * .32, 0, d / 2 + .03]}>
          <mesh material={frame}><cylinderGeometry args={[.012, .012, .22, 16]} /></mesh>
          {[-1, 1].map(y => <mesh key={y} material={frame} position={[0, y * .09, -.015]}>
            <MachinedBoxGeometry args={[.032, .025, .045]} detailed />
          </mesh>)}
        </group>}
      </mesh>
      <mesh ref={right} material={glass}>
        <boxGeometry args={[half, h - 0.12, d]} />
        {detailed && <group position={[-half * .32, 0, d / 2 + .03]}>
          <mesh material={frame}><cylinderGeometry args={[.012, .012, .22, 16]} /></mesh>
          {[-1, 1].map(y => <mesh key={y} material={frame} position={[0, y * .09, -.015]}>
            <MachinedBoxGeometry args={[.032, .025, .045]} detailed />
          </mesh>)}
        </group>}
      </mesh>
    </group>
  )
}



function Clamp({ device, plant, detailed }: DeviceProps) {
  const a = useRef<THREE.Mesh>(null)
  const b = useRef<THREE.Mesh>(null)
  const [w, , d] = device.size
  const mat = useMetal(device.color, { rough: 0.45, metal: 0.8 })
  const base = useMetal('#39414b', { rough: 0.7 })
  const sensorGroove = useMetal('#252b32', { rough: 0.9, metal: 0.15 })
  const jaw = clampGeometry(0)

  useFrame(() => {
    const s = plant.state(device.id)
    const geometry = clampGeometry(s.pos)
    if (a.current) a.current.position.x = -geometry.jawCenter
    if (b.current) b.current.position.x = geometry.jawCenter
  })

  return (
    <group>
      {}
      <mesh material={base} position={[0, -0.095, 0]} castShadow>
        <MachinedBoxGeometry args={[w + 0.34, 0.06, d]} detailed={detailed} />
      </mesh>
      {[-d * 0.28, d * 0.28].map((z) => (
        <mesh key={z} material={mat} position={[0, -0.045, z]} castShadow>
          <boxGeometry args={[w + 0.20, 0.025, 0.025]} />
        </mesh>
      ))}
      {}
      <mesh material={base} position={[0, 0.015, d / 2 + 0.11]} castShadow>
        <MachinedBoxGeometry args={[0.34, 0.18, 0.18]} detailed={detailed} radius={.012} />
      </mesh>
      {detailed && [-1, 1].flatMap(x => [-1, 1].map(y => <SocketBolt key={`${x}:${y}`}
        position={[x * .13, .015 + y * .06, d / 2 + .203]} radius={.009} />))}
      {}
      <mesh material={sensorGroove} position={[0, 0.106, d / 2 + 0.11]} castShadow>
        <boxGeometry args={[0.025, 0.004, 0.14]} />
      </mesh>
      <mesh material={base} position={[0, -0.115, 0]} castShadow>
        <boxGeometry args={[w + 0.62, 0.05, d * 1.08]} />
      </mesh>
      <mesh ref={a} material={mat} position={[0, jaw.jawCenterY, 0]} castShadow>
        <boxGeometry args={[jaw.jawWidth, jaw.jawHeight, jaw.jawDepth]} />
      </mesh>
      <mesh ref={b} material={mat} position={[0, jaw.jawCenterY, 0]} castShadow>
        <boxGeometry args={[jaw.jawWidth, jaw.jawHeight, jaw.jawDepth]} />
      </mesh>
    </group>
  )
}



function Press({ device, plant, detailed }: DeviceProps) {
  const ram = useRef<THREE.Group>(null)
  const [w, h, d] = device.size
  const body = useMetal('#454e5a', { rough: 0.6 })
  const ramMat = useMetal('#8c949e', { rough: 0.35, metal: 0.9 })

  useFrame(() => {
    const s = plant.state(device.id)
    if (ram.current) ram.current.position.y = -s.pos * (h * 0.72)
  })

  return (
    <group>
      {}
      <mesh material={body} position={[0, h / 2, 0]} castShadow>
        <MachinedBoxGeometry args={[w, h * 0.42, d]} detailed={detailed} radius={.022} />
      </mesh>
      {detailed && [-1, 1].flatMap(x => [-1, 1].map(y => <SocketBolt key={`${x}:${y}`}
        position={[x * w * .4, h / 2 + y * h * .13, d / 2 + .002]} radius={.012} />))}
      {/* Column */}
      {[-w / 2 + 0.06, w / 2 - 0.06].map((x) => (
        <mesh key={x} material={body} position={[x, 0, -d / 2 + 0.06]} castShadow>
          <boxGeometry args={[0.08, h * 1.5, 0.08]} />
        </mesh>
      ))}
      {}
      <group ref={ram}>
        <mesh material={ramMat} position={[0, h * 0.1, 0]} castShadow>
          <cylinderGeometry args={[0.07, 0.07, h * 0.5, 16]} />
        </mesh>
        <mesh material={ramMat} position={[0, -h * 0.18, 0]} castShadow>
          <MachinedBoxGeometry args={[w * 0.62, 0.12, d * 0.62]} detailed={detailed} />
        </mesh>
      </group>
    </group>
  )
}



function Spindle({ device, plant }: DeviceProps) {
  const tool = useRef<THREE.Group>(null)
  const [w, h] = device.size
  const body = useMetal('#5b646f', { rough: 0.5 })
  const steel = useMetal('#c2c8ce', { rough: 0.18, metal: 0.98 })

  useFrame(() => {
    const s = plant.state(device.id)
    if (tool.current) tool.current.rotation.y = s.spin
  })

  return (
    <group>
      <mesh material={body} castShadow>
        <cylinderGeometry args={[w / 2, w / 2, h * 0.6, 20]} />
      </mesh>
      <group ref={tool} position={[0, -h * 0.42, 0]}>
        <mesh material={steel} castShadow>
          <cylinderGeometry args={[w * 0.28, w * 0.28, h * 0.22, 14]} />
        </mesh>
        <mesh material={steel} position={[0, -h * 0.2, 0]} castShadow>
          <coneGeometry args={[w * 0.2, h * 0.24, 12]} />
        </mesh>
      </group>
    </group>
  )
}



function Lift({ device, plant, detailed }: DeviceProps) {
  const deck = useRef<THREE.Group>(null)
  const [w, h, d] = device.size
  const body = useMetal('#4b545f', { rough: 0.65 })
  const plate = useMetal(device.color, { rough: 0.5 })

  useFrame(() => {
    const s = plant.state(device.id)
    if (deck.current) deck.current.position.y = liftDeckPosition(h, s.pos)
  })

  return (
    <group>
      <mesh material={body} position={[0, -h / 2, 0]} receiveShadow>
        <MachinedBoxGeometry args={[w, 0.08, d]} detailed={detailed} />
      </mesh>
      {}
      {[[-w / 2 + 0.05, -d / 2 + 0.05], [w / 2 - 0.05, -d / 2 + 0.05]].map(([x, z], i) => (
        <mesh key={i} material={body} position={[x, 0, z]} castShadow>
          {detailed ? <SlottedProfileGeometry edge={.06} length={h} /> : <boxGeometry args={[0.06, h, 0.06]} />}
        </mesh>
      ))}
      <group name="lift-moving-deck" ref={deck}>
        {detailed ? <LiftLoadDeck width={w} depth={d} color={device.color} /> : <mesh material={plate} castShadow>
          <MachinedBoxGeometry args={[w * 0.86, 0.07, d * 0.86]} detailed={detailed} />
        </mesh>}
        {}
        <mesh material={body} position={[w * 0.465, 0.015, -d * 0.435]} castShadow>
          <boxGeometry args={[0.07, 0.09, 0.07]} />
        </mesh>
      </group>
    </group>
  )
}



function VerticalSlide({ device, plant, detailed }: DeviceProps) {
  const carriage = useRef<THREE.Group>(null)
  const extension = useRef<THREE.Mesh>(null)
  const gripperMount = useRef<THREE.Mesh>(null)
  const [w, h, d] = device.size
  const dedicatedRearYoke = device.id==='V_AXIS_A' && plant.machine.devices.some(d=>d.id==='HEAD_A_ARM'&&Math.abs(d.size[2]-.55)<.001)
  const rackMast = device.visualVariant === 'material-rack-mast'
  const caps = rackMast ? [-.5464,.75] : [-h*.46,h*.46]
  const frame = useMetal(detailed ? '#8998a6' : '#414b56', { rough: detailed ? .32 : 0.62 })
  const rail = useMetal('#a8b1ba', { rough: 0.28, metal: 0.9 })
  const moving = useMetal(detailed ? '#aeb9c4' : device.color, { rough: detailed ? .32 : .4, metal: 0.78 })
  const travel = h * 0.54
  const gripper = detailed ? plant.machine.devices.find(child => child.kind === 'gripper'
    && child.mountedOn === device.id && child.rot === device.rot) : undefined
  const localX = gripper ? Math.cos(device.rot) * (gripper.pos[0] - device.pos[0])
    - Math.sin(device.rot) * (gripper.pos[2] - device.pos[2]) : 0
  const localZ = gripper ? Math.sin(device.rot) * (gripper.pos[0] - device.pos[0])
    + Math.cos(device.rot) * (gripper.pos[2] - device.pos[2]) : 0
  const mount = gripper ? slideGripperMountGeometry(d, localZ) : undefined
  const fittedMount = mount && mount.depth > 0 && Math.abs(localX) < .03 ? mount : undefined

  useFrame(() => {
    const s = plant.state(device.id)
    if (carriage.current) carriage.current.position.y = rackMast ? -.3875 + .975*s.pos : slideCarriagePosition(h, s.pos)
    if (extension.current && rackMast) {
      const fork = plant.machine.devices.find(d => d.id === 'FORK')
      if (fork) {
        const end = device.pos[2] - (fork.pos[2] + .10)
        extension.current.position.z = (.16 + end)/2
        extension.current.scale.z = Math.max(.01,end-.16)
      }
    }
    if (gripperMount.current && gripper && fittedMount) {
      gripperMount.current.position.y = gripper.pos[1] - device.pos[1]
        - (-travel / 2 + s.pos * travel) + fittedMount.gripperRelativeY
    }
  })

  return (
    <group>
      {[-w * 0.27, w * 0.27].map((x) => (
        <mesh key={x} material={rail} position={[x, rackMast ? (caps[0]+caps[1])/2 : 0, 0]} castShadow>
          <cylinderGeometry args={[0.025, 0.025, rackMast ? caps[1]-caps[0]-.08 : detailed ? h * .92 - .04 : h * .86, detailed ? 32 : 12]} />
        </mesh>
      ))}
      {caps.map((y) => detailed ? <SlideEndCap key={y} width={w} depth={d} y={y} /> : (
        <mesh key={y} material={frame} position={[0, y, 0]} castShadow>
          <MachinedBoxGeometry args={[w * 0.78, 0.08, d * 0.32]} detailed={detailed} />
        </mesh>
      ))}
      {}
      <mesh material={frame} position={[0, caps[1], -d * 0.55]} castShadow receiveShadow>
        <boxGeometry args={[w * 0.74, 0.12, d * 0.75]} />
      </mesh>
      <mesh name="slide-rear-drive-guard" material={frame} position={[0, 0, detailed ? -.075 : -d * .08]} castShadow>
        <boxGeometry args={[w * 0.16, h * 0.72, detailed ? .028 : d * 0.2]} />
      </mesh>
      <group name="slide-moving-carriage" ref={carriage}>
        {rackMast && <mesh ref={extension} name="rack-telescopic-fork-boom" material={moving} position={[0,-.08,.22]} castShadow>
          <boxGeometry args={[.12,.08,1]}/>
        </mesh>}
        {detailed ? <SlideCarriageBody width={w} depth={d} /> : <mesh material={moving} position={[0, 0, d * 0.16]} castShadow>
          <MachinedBoxGeometry args={[w * 0.82, 0.2, d * 0.38]} detailed={detailed} />
        </mesh>}
        {dedicatedRearYoke ? null : fittedMount ? <mesh name="slide-gripper-housing-mount" ref={gripperMount} material={moving}
          position={[localX / 2, 0, fittedMount.centerZ]} castShadow>
          <MachinedBoxGeometry args={[fittedMount.width, fittedMount.height, fittedMount.depth]} detailed />
        </mesh> : <mesh name="slide-tool-bracket" material={moving} position={[0, -0.04, rackMast ? .12 : d * (detailed ? .6825 : .64)]} castShadow>
          <MachinedBoxGeometry args={[w * 0.42, 0.12, rackMast ? .08 : d * (detailed ? .665 : .75)]} detailed={detailed} />
        </mesh>}
        {}
        <mesh material={rail} position={[w * 0.46, 0, 0]} castShadow>
          <boxGeometry args={[0.07, 0.09, 0.08]} />
        </mesh>
      </group>
    </group>
  )
}

function Fixture({ device, detailed }: DeviceProps) {
  const motionPresentation=useMotionPresentation(),realism=useMotionRealism(),rise=useContext(MotionCellFloorOffset)
  const [w, h, d] = device.size
  const frame = useMemo(()=>new THREE.MeshStandardMaterial({color:TABLE_FINISH.leg,roughness:TABLE_FINISH.roughness,metalness:TABLE_FINISH.metalness,envMapIntensity:TABLE_FINISH.envMapIntensity}),[])
  const top = useMemo(()=>new THREE.MeshStandardMaterial({color:TABLE_FINISH.top,roughness:TABLE_FINISH.roughness,metalness:TABLE_FINISH.metalness,envMapIntensity:TABLE_FINISH.envMapIntensity}),[])
  const topY = h / 2 - 0.045
  const topBottom = h / 2 - 0.09
  const baseTop = -h / 2 + 0.07
  const legHeight = Math.max(detailed ? .005 : .08, topBottom - baseTop)
  const legY = (topBottom + baseTop) / 2
  const legEdge = detailed ? Math.min(.07, w * .12, d * .14) : .07
  // Thin brackets are solid plates, not four-legged tables with intersecting top/base slabs.
  if (motionPresentation && device.id==='GANTRY_BRIDGE') return <GantryBeam size={device.size}/>
  if (realism && rise>0 && detailed && h>.18 && Math.min(w,d)>=.24) return <MotionMachineBase position={[0,-h/2-rise,0]} size={[w,h+rise,d]} kind="skid"/>
  if ((motionPresentation||realism) && detailed && h>.18 && Math.min(w,d)>=.24) return <group>
    <mesh material={top} position={[0,h/2-.02,0]} castShadow receiveShadow><boxGeometry args={[w,.04,d]}/></mesh>
    <group position={[0,-h/2-rise,0]}><MaterialTableLegs halfX={w/2-.08} halfZ={d/2-.08} top={h-.04+rise}/></group>
  </group>
  if (detailed && h <= .18) return <mesh name="fixture-compact-plate" position={[0, (device.fixtureTopOffset ?? 0) / 2, 0]} material={top} castShadow receiveShadow>
    <MachinedBoxGeometry args={[w, h + (device.fixtureTopOffset ?? 0), d]} detailed />
  </mesh>
  return (
    <group>
      <mesh material={top} position={[0, topY, 0]} castShadow receiveShadow>
        <MachinedBoxGeometry args={[w, 0.09, d]} detailed={detailed} />
      </mesh>
      {motionPresentation&&[-1,1].flatMap(sx=>[-1,1].map(sz=><group key={`alignment-foot:${sx}:${sz}`} position={[sx*w*.38,baseTop,sz*d*.36]}>
        <mesh material={frame} position={[0,.006,0]} castShadow><boxGeometry args={[legEdge+.06,.012,legEdge+.06]}/></mesh>
        {[-1,1].map(k=><SocketBolt key={k} position={[k*(legEdge/2+.014),.013,0]} radius={.006} top/>)}
      </group>))}
      {detailed && [-1, 1].flatMap(sx => [-1, 1].map(sz =>
        <SocketBolt key={`${sx}:${sz}`} position={[sx * w * .4, h / 2 + .001, sz * d * .4]} radius={.012} top />
      ))}
      {detailed && Math.min(w, d) < .24 ? <mesh name="fixture-pedestal" material={frame} position={[0, legY, 0]} castShadow>
        <MachinedBoxGeometry args={[w * .62, legHeight, d * .62]} detailed />
      </mesh> : [[-1, -1], [-1, 1], [1, -1], [1, 1]].map(([sx, sz], index) => (
        <mesh key={index} material={frame} position={[sx * w * 0.38, legY, sz * d * 0.36]} castShadow>
          {detailed ? <SlottedProfileGeometry edge={legEdge} length={legHeight} /> : <boxGeometry args={[legEdge, legHeight, legEdge]} />}
        </mesh>
      ))}
      {detailed && Math.min(w, d) >= .24 && legHeight > .08 && [-1, 1].flatMap(sx => [-1, 1].map(sz =>
        <CornerWeb key={`web:${sx}:${sz}`} position={[sx * (w * .38 - legEdge / 2), topBottom, sz * d * .36]}
          side={-sx} span={Math.min(.09, legHeight * .45, w * .16)} />
      ))}
      <mesh material={frame} position={[0, -h / 2 + 0.035, 0]} receiveShadow>
        <MachinedBoxGeometry args={[w * 0.9, 0.07, d * 0.9]} detailed={detailed} />
      </mesh>
    </group>
  )
}


function Platform({ device, plant, detailed }: DeviceProps) {
  const seat=platformSeating(device,plant.machine.devices)
  const [rawWidth, h, d] = device.size
  const w=seat.width??rawWidth
  const lower = detailed && device.id.endsWith('_PNEUMATIC_BODY')
    ? plant.machine.devices.find(other => other.id === `${device.id}_LOWER_MOUNT`) : undefined
  const upper = lower ? plant.machine.devices.find(other => other.id === `${device.id}_UPPER_MOUNT`) : undefined
  // The published mount centres sit at the old tube ends. Trim the hidden overlap,
  // retaining world poses and the tube's sensor-mounting X/Z faces.
  const forkGuide = detailed && device.id === 'FORK_LIFT_ROD'
    ? plant.machine.devices.find(other => other.id === 'FORK_GUIDE') : undefined
  const bottom = seat.bottom!==undefined ? Math.max(-h/2,seat.bottom) : lower ? Math.max(-h / 2, lower.pos[1] - device.pos[1] + lower.size[1] / 2)
    : -h / 2 + (forkGuide ? Math.min(h / 2, forkGuide.size[1] + .001) : 0)
  const topEdge = seat.top!==undefined ? Math.min(h/2,seat.top) : upper ? Math.min(h / 2, upper.pos[1] - device.pos[1] - upper.size[1] / 2) : h / 2
  const bodyHeight = Math.max(.01, topEdge - bottom)
  const bodyY = (topEdge + bottom) / 2 + seat.lift
  // The photoeye's cantilever mates to the fixture edge, not through its top face.
  const fixture = detailed && device.id === 'PHOTO_BRACKET_ARM'
    ? plant.machine.devices.find(other => other.id === 'FIXTURE_A') : undefined
  const backZ = seat.front!==undefined ? Math.max(-d/2,seat.front) : fixture && device.rot === 0 && fixture.rot === 0
    ? Math.min(d / 2 - .01, Math.max(-d / 2, fixture.pos[2] + fixture.size[2] / 2 - device.pos[2])) : -d / 2
  const bodyDepth = seat.depth ?? d / 2 - backZ
  const bodyZ = seat.z ?? (d / 2 + backZ) / 2
  const top = useMetal(device.color, { rough: 0.52, metal: 0.76 })
  const rib = useMetal('#3f4853', { rough: 0.64, metal: 0.78 })
  return (
    <group>
      <mesh name="platform-body" material={top} position={[seat.x??0, bodyY, bodyZ]}
        scale={[1, 1, lower && upper ? bodyDepth / w : 1]} castShadow receiveShadow>
        {lower && upper ? <SlottedProfileGeometry edge={w} length={bodyHeight} />
          : <MachinedBoxGeometry args={[w, bodyHeight, bodyDepth]} detailed={detailed} />}
      </mesh>
      {w > 0.35 && [-d * 0.32, d * 0.32].map((z) => (
        <mesh key={z} material={rib} position={[0, -h / 2 - 0.018, z]} castShadow>
          <boxGeometry args={[w * 0.9, 0.035, Math.min(0.04, d * 0.12)]} />
        </mesh>
      ))}
    </group>
  )
}


function SupportFrame({ device, detailed }: DeviceProps) {
  const [w, h, d] = device.size
  const metal = useMetal(detailed ? '#a6b1bb' : device.color, { rough: detailed ? .3 : 0.5, metal: 0.82 })
  const edge = Math.max(0.08, Math.min(0.14, w * 0.09))
  const postX = Math.max(0, w / 2 - edge / 2)
  return (
    <group>
      {[-postX, postX].map((x) => (
        <group key={x} position={[x, 0, 0]}>
          <mesh material={metal} castShadow receiveShadow>
            {detailed ? <SlottedProfileGeometry edge={edge} length={h - 2 * edge} /> : <boxGeometry args={[edge, h, edge]} />}
          </mesh>
          {detailed && <>
            {[h / 2 - edge * .65, -h / 2 + edge * 1.4].map(y => <mesh key={y} material={metal}
              position={[0, y, edge / 2 + .001]}>
              <MachinedBoxGeometry args={[edge * .78, edge * .8, .002]} detailed />
            </mesh>)}
            <SocketBolt position={[0, h / 2 - edge * .65, edge / 2 + .003]} radius={.014} />
            <SocketBolt position={[0, -h / 2 + edge * 1.4, edge / 2 + .003]} radius={.014} />
          </>}
          <mesh material={metal} position={[0, -h / 2 + edge / 2, d * 0.05]} castShadow receiveShadow>
            <MachinedBoxGeometry args={[edge * 1.9, edge, d]} detailed={detailed} />
          </mesh>
          {detailed && [-1, 1].map(side => <SocketBolt key={`anchor${side}`}
            position={[0, -h / 2 + edge + .001, d * .05 + side * d * .36]} radius={.013} top />)}
        </group>
      ))}
      <mesh material={metal} position={[0, h / 2 - edge / 2, 0]} castShadow receiveShadow>
        <MachinedBoxGeometry args={[w, edge, Math.max(edge, d * 0.72)]} detailed={detailed} />
      </mesh>
      {detailed && [-1, 1].map(s => <CornerWeb key={`frame-web:${s}`}
        position={[s * (postX - edge / 2), h / 2 - edge, 0]} side={-s} span={Math.min(edge * .9, w * .12)} />)}
      {}
      {w > 2 && [-w * 0.34, w * 0.34].map((x) => (
        <mesh
          key={`rail-mount-${x}`}
          material={metal}
          position={[x, h / 2 - edge / 2, d * 0.41]}
          castShadow
          receiveShadow
        >
          <boxGeometry args={[edge * 1.35, edge * 1.3, d * 0.24]} />
        </mesh>
      ))}
      <mesh material={metal} position={[0, -h / 2 + edge / 2, 0]} castShadow receiveShadow>
        <MachinedBoxGeometry args={[detailed ? w - 2.9 * edge : w, edge, Math.max(edge, d * 0.72)]} detailed={detailed} />
      </mesh>
    </group>
  )
}



function Turntable({ device, plant, detailed }: DeviceProps) {
  const disc = useRef<THREE.Group>(null)
  const [w, h] = device.size
  const body = useMetal('#414a55', { rough: 0.7 })
  const top = useMetal(device.color, { rough: 0.45 })
  const pedestalHeight = Math.max(0.10, device.pos[1] - 0.16)

  useFrame(() => {
    const s = plant.state(device.id)

    if (disc.current) disc.current.rotation.y = -s.pos * Math.PI / 3
  })

  return (
    <group>
      {}
      <mesh material={body} position={[0, -device.pos[1] + pedestalHeight / 2, 0]} castShadow receiveShadow>
        <cylinderGeometry args={[w * 0.24, w * 0.29, pedestalHeight, 24]} />
      </mesh>
      <mesh material={body} position={[0, -device.pos[1] + 0.035, 0]} castShadow receiveShadow>
        <cylinderGeometry args={[w * 0.34, w * 0.34, 0.07, 24]} />
      </mesh>
      <mesh material={body} position={[0, -0.1, 0]} receiveShadow>
        <cylinderGeometry args={[w / 2 + 0.05, w / 2 + 0.08, 0.12, detailed ? 64 : 32]} />
      </mesh>
      <group ref={disc}>
        <mesh material={top} castShadow receiveShadow>
          <cylinderGeometry args={[w / 2, w / 2, h, detailed ? 64 : 32]} />
        </mesh>
        {detailed && <>
          <mesh position={[0, h / 2 + .009, 0]} castShadow>
            <cylinderGeometry args={[w * .13, w * .14, .018, 48]} />
            <meshStandardMaterial color="#adb8c1" {...satinFinish(.25, .85)} />
          </mesh>
          {Array.from({ length: 8 }, (_, i) => <SocketBolt key={i}
            position={[Math.cos(i * Math.PI / 4) * w * .2, h / 2 + .002, Math.sin(i * Math.PI / 4) * w * .2]} top radius={.012} />)}
        </>}
        {}
        {device.visualVariant !== 'single-pocket-index' && [0, 1, 2, 3, 4, 5].map((i) => (
          <mesh
            key={i}
            position={[Math.cos((i * Math.PI) / 3) * w * 0.36, h / 2 + 0.02, Math.sin((i * Math.PI) / 3) * w * 0.36]}
          >
            <boxGeometry args={[0.1, 0.03, 0.1]} />
            <meshStandardMaterial color="#8d97a3" />
          </mesh>
        ))}
      </group>
    </group>
  )
}



function Robot({ device, plant, detailed }: DeviceProps) {
  const j1 = useRef<THREE.Group>(null)
  const j2 = useRef<THREE.Group>(null)
  const body = useMetal(device.color, { rough: 0.45, metal: 0.6 })
  const joint = useMetal('#2f3742', { rough: 0.6 })

  useFrame(() => {
    const s = plant.state(device.id)
    if (j1.current) j1.current.rotation.y = -0.9 + s.pos * 1.8
    if (j2.current) j2.current.rotation.z = -0.6 + s.pos * 0.9
  })

  return (
    <group>
      <mesh material={joint} position={[0, 0.12, 0]} castShadow>
        <cylinderGeometry args={[0.24, 0.28, 0.24, 20]} />
      </mesh>
      <group ref={j1} position={[0, 0.24, 0]}>
        {detailed && <mesh material={joint} position={[0, .045, 0]} castShadow>
          <cylinderGeometry args={[.15, .19, .09, 40]} />
        </mesh>}
        <mesh material={body} position={[0, 0.35, 0]} castShadow>
          <MachinedBoxGeometry args={[0.18, 0.7, 0.18]} detailed={detailed} radius={.055} />
        </mesh>
        <group ref={j2} position={[0, 0.7, 0]}>
          {detailed && <group name="robot-elbow-gearcase">
            <mesh material={joint} rotation={[Math.PI / 2, 0, 0]} castShadow>
              <cylinderGeometry args={[.125, .125, .22, 40]} />
            </mesh>
            <mesh position={[0, 0, .116]} rotation={[Math.PI / 2, 0, 0]} castShadow>
              <cylinderGeometry args={[.091, .091, .012, 32]} />
              <meshStandardMaterial color="#a4aeb8" {...satinFinish(.32, .8)} />
            </mesh>
            {[-1, 1].flatMap(x => [-1, 1].map(y => <SocketBolt key={`${x}:${y}`} position={[x * .048, y * .048, .125]} radius={.009} />))}
          </group>}
          <mesh material={body} position={[0.32, 0, 0]} castShadow>
            <MachinedBoxGeometry args={[0.68, 0.14, 0.14]} detailed={detailed} radius={.045} />
          </mesh>
          <mesh material={joint} position={[0.66, -0.06, 0]} castShadow>
            <MachinedBoxGeometry args={[0.1, 0.16, 0.16]} detailed={detailed} radius={.025} />
          </mesh>
        </group>
      </group>
    </group>
  )
}



function Gripper({ device, plant, detailed }: DeviceProps) {
  const a = useRef<THREE.Mesh>(null)
  const b = useRef<THREE.Mesh>(null)
  const body = useMetal(detailed ? '#bac3cb' : device.color, { rough: detailed ? .29 : .4, metal: 0.85 })
  const jaw = useMetal('#56616b', { rough: .34, metal: .8 })
  const sensorGroove = useMetal('#252b32', { rough: 0.9, metal: 0.15 })



  const wide = device.visualVariant === 'wide-stroke'

  useFrame(() => {
    const s = plant.state(device.id)


    const jawCenter = wide ? 0.32 - s.pos * 0.2 : 0.15 - s.pos * 0.05
    if (a.current) a.current.position.x = -jawCenter
    if (b.current) b.current.position.x = jawCenter
  })

  return (
    <group>
      <mesh material={body} castShadow>
        <MachinedBoxGeometry args={[wide ? 0.74 : 0.2, 0.16, 0.14]} detailed={detailed} />
      </mesh>
      {detailed && [-1, 1].flatMap(sx => [-1, 1].map(sy =>
        <SocketBolt key={`${sx}:${sy}`} position={[sx * (wide ? .34 : .084), sy * .055, .073]} radius={.007} />
      ))}
      {}
      <mesh material={sensorGroove} position={[0, 0.081, 0]} castShadow>
        <boxGeometry args={[wide ? 0.09 : 0.025, 0.004, 0.12]} />
      </mesh>
      <mesh ref={a} material={detailed ? jaw : body} position={[-0.1, -0.16, 0]} castShadow>
        <MachinedBoxGeometry args={[wide ? 0.06 : 0.04, 0.2, 0.1]} detailed={detailed} />
        {detailed && <SocketBolt position={[0, .055, .052]} radius={.006} />}
      </mesh>
      <mesh ref={b} material={detailed ? jaw : body} position={[0.1, -0.16, 0]} castShadow>
        <MachinedBoxGeometry args={[wide ? 0.06 : 0.04, 0.2, 0.1]} detailed={detailed} />
        {detailed && <SocketBolt position={[0, .055, .052]} radius={.006} />}
      </mesh>
    </group>
  )
}



function VacuumPickup({ device, detailed }: DeviceProps) {
  const body = useMetal(detailed ? '#aeb9c1' : device.color, { rough: detailed ? .32 : .42, metal: 0.72 })
  const rubber = useMetal('#26333b', { rough: 0.82, metal: 0.05 })

  return (
    <group>
      <mesh material={body} position={[0, 0.2, 0]} castShadow>
        <MachinedBoxGeometry args={[0.34, 0.12, 0.22]} detailed={detailed} />
      </mesh>
      {detailed && [-1, 1].map(side => <SocketBolt key={side} position={[side * .13, .2, .113]} radius={.009} />)}
      <mesh material={body} position={[0, 0.38, 0]} castShadow>
        <cylinderGeometry args={[0.035, 0.035, 0.3, 12]} />
      </mesh>
      {device.visualVariant === 'single-vacuum-cup' ? (
        <group name="single-vacuum-cup">
          <mesh material={body} position={[0, .1275, 0]} castShadow>
            <cylinderGeometry args={[.018, .018, .045, 16]} />
          </mesh>
          <mesh name="vacuum-sealing-cup" position={[0, SINGLE_VACUUM_CUP.centerY, 0]} castShadow>
            <cylinderGeometry args={[SINGLE_VACUUM_CUP.topRadius, SINGLE_VACUUM_CUP.radius, SINGLE_VACUUM_CUP.height, 24, 1, true]} />
            <meshStandardMaterial color="#26333b" roughness={.82} metalness={.05} side={THREE.DoubleSide} />
          </mesh>
        </group>
      ) : [-0.11, 0.11].map((x) => (
        <group key={x} position={[x, 0.08, 0]}>
          <mesh material={rubber} rotation={[Math.PI, 0, 0]} castShadow>
            <coneGeometry args={[0.065, 0.07, 18]} />
          </mesh>
        </group>
      ))}
    </group>
  )
}



const TOWER_COLORS = ['#f0574d', '#e5a83c', '#3ddc84']

function Lamp({ device, plant }: DeviceProps) {
  const lights = useRef<(THREE.MeshStandardMaterial | null)[]>([])
  const pole = useMetal('#333a44', { rough: 0.7 })

  useFrame((_, dt) => {
    const s = plant.state(device.id)

    const t = performance.now() / 300
    lights.current.forEach((m, i) => {
      if (!m) return
      const target = s.running ? (i === 2 ? 1.6 : 0) : i === 0 ? (Math.sin(t) > 0 ? 0.9 : 0) : 0
      m.emissiveIntensity += (target - m.emissiveIntensity) * Math.min(1, dt * 12)
    })
  })

  return (
    <group>
      <mesh material={pole} position={[0, -0.5, 0]} castShadow>
        <cylinderGeometry args={[0.035, 0.05, 1.0, 12]} />
      </mesh>
      {TOWER_COLORS.map((c, i) => (
        <mesh key={c} position={[0, 0.18 - i * 0.17, 0]} castShadow>
          <cylinderGeometry args={[0.085, 0.085, 0.15, 20]} />
          <meshStandardMaterial
            ref={(m) => { lights.current[i] = m }}
            color={c}
            emissive={c}
            emissiveIntensity={0}
            roughness={0.3}
            transparent
            opacity={0.92}
          />
        </mesh>
      ))}
    </group>
  )
}







function Stopper({ device, plant, detailed }: DeviceProps) {
  const blade = useRef<THREE.Group>(null)
  const body = useMetal('#4b5562', { rough: 0.55, metal: 0.75 })
  const bladeMat = useMetal(device.color, { rough: 0.38, metal: 0.8 })
  const [, h, d] = device.size

  useFrame(() => {
    const s = plant.state(device.id)
    if (blade.current) blade.current.position.y = -h * 0.58 + s.pos * h * 0.78
  })

  return (
    <group>
      {}
      <mesh material={body} position={[0, -h * 0.46, 0]} castShadow>
        <MachinedBoxGeometry args={[0.18, h * 0.38, d * 0.72]} detailed={detailed} />
      </mesh>
      {}
      <group ref={blade}>
        <mesh material={bladeMat} castShadow>
          <MachinedBoxGeometry args={[0.055, h * 0.58, d]} detailed={detailed} />
        </mesh>
        <mesh material={body} position={[0, -h * 0.35, 0]} castShadow>
          <boxGeometry args={[0.09, h * 0.30, d * 0.78]} />
        </mesh>
      </group>
    </group>
  )
}



/** A declared fixture-mounted photoeye needs a physical cantilever, not a floating body. */
function FixturePhotoeyeMount({ device, plant }: DeviceProps) {
  const parent = plant.machine.devices.find(d => d.id === device.mountedOn && d.kind === 'fixture')
  if (!parent || parent.rot !== 0) return null
  const seat = parent.pos[1] + parent.size[1] / 2 + (parent.fixtureTopOffset ?? 0)
  const height = device.pos[1] - .075 - (seat + .02)
  if (height < .14) return null // already seated close to the fixture; do not add a duplicate bracket
  const ax = THREE.MathUtils.clamp(device.pos[0], parent.pos[0] - parent.size[0] / 2 + .06, parent.pos[0] + parent.size[0] / 2 - .06)
  const az = THREE.MathUtils.clamp(device.pos[2], parent.pos[2] - parent.size[2] / 2 + .06, parent.pos[2] + parent.size[2] / 2 - .06)
  const dx = ax - device.pos[0], dz = az - device.pos[2]
  return <group name="fixture-photoeye-cantilever" rotation={[0, -device.rot, 0]}>
    <group position={[dx / 2, seat + .01 - device.pos[1], dz / 2]} rotation={[0, -Math.atan2(dz, dx), 0]}>
      <HardwarePart name="sensor-foot-arm" size={[Math.hypot(dx, dz) + .06, .02, .06]} radius={.004} />
    </group>
    <HardwarePart name="sensor-upright" size={[.025, height, .025]} position={[0, -.075 - height / 2, 0]} color={FINISH.dark} />
    <HardwarePart name="sensor-mount-pad" size={[.08, .02, .08]} position={[0, -.065, 0]} />
    <SocketBolt top radius={.004} position={[dx, seat + .022 - device.pos[1], dz]} />
  </group>
}

function Sensor({ device, plant, detailed }: DeviceProps) {
  const photoeyeStyle = PHOTOEYE_STYLE
  const beam = useRef<THREE.Mesh>(null)
  const limitBeamWidth = useMemo(createPhotoeyeWidthLimiter, [])
  const led = useRef<THREE.MeshStandardMaterial>(null)
  const body = useMetal('#2b323b', { rough: 0.8, metal: 0.2 })
  const metal = useMetal('#66717f', { rough: 0.55, metal: 0.7 })
  const visual = device.sensorVisual ?? 'photoeye'
  const beamLength = device.sensorBeamLength ?? 0.5
  const aim = device.sensorTarget ? aimPhotoeye(device.pos,device.sensorTarget,device.rot) : null
  const [sensorWidth, sensorHeight, sensorDepth] = device.size
  const slotLedOnTop = sensorHeight <= sensorDepth
  const sizedSlot = device.visualVariant === 'material-sized-slot'
  const slotBodySize: [number, number, number] = sizedSlot ? [...device.size] : slotLedOnTop
    ? [0.032, 0.014, 0.090]
    : [sensorWidth, sensorHeight, sensorDepth]

  useFrame(({ camera, size }) => {
    const s = plant.state(device.id)
    if (led.current) led.current.emissiveIntensity = visual === 'photoeye'
      ? (s.detecting ? photoeyeStyle.statusDetectingEmission : photoeyeStyle.statusIdleEmission)
      : (s.detecting ? 2.2 : 0.12)
    if (beam.current) {
      const m = beam.current.material as THREE.MeshBasicMaterial
      m.opacity = s.detecting ? photoeyeStyle.rayDetectingOpacity : photoeyeStyle.rayIdleOpacity
      // Preserve each suite's length/clipping behavior; only apparent width
      // is shared. Radial X/Z scale never changes beam length (local Y).
      if (device.clipPhotoeyeBeam) {
        const length = aim ? aimedPhotoeyeLength(aim,beamLength,plant.parts,plant.machine.geometry.beltY+.11) : photoeyeVisibleLength(
          device.pos, device.rot, beamLength, plant.parts,
          plant.machine.geometry.beltY + 0.11,
        )
        beam.current.scale.y = length
        beam.current.position.z = -PHOTOEYE_LENS_FRONT - length / 2
        beam.current.visible = length > 1e-6
      }
      limitBeamWidth(beam.current, camera, size.width, size.height)
    }
  })

  if (/^MAT-H01(?:\s|$)/.test(plant.machine.title) && /^[AB]_PART_SENSOR$/.test(device.id)) return <group name="machining-photoeye"><CompactPhotoeye/><HardwarePart name="sensor-pedestal" position={[0,-.045,0]} size={[.024,.02,.024]} color={FINISH.dark}/></group>

  if (/^MAT-H01(?:\s|$)/.test(plant.machine.title) && /^TOOL_tool_(open|closed)$/.test(device.id)) return <group position={[0,-.053,.007]} name="gripper-integrated-slot-switch"><HardwarePart size={[.020,.008,.004]} color={FINISH.dark}/><HardwarePart position={[0,0,.0025]} size={[.005,.003,.001]} color="#79a95b"/></group>

  if (visual === 'limit' && device.visualVariant === 'material-limit-sensor') return <group name="material-endpoint-sensor">
    <HardwarePart name="endpoint-switch-body" size={[.035, .05, .035]} radius={.004} color={FINISH.dark}/>
    <HardwarePart name="endpoint-sensing-face" size={[.025, .034, .002]} position={[0, 0, -.0185]} color="#303842" radius={.002}/>
    <mesh position={[0, .021, .008]}><boxGeometry args={[.009, .003, .012]}/><meshStandardMaterial ref={led} color="#edb547" emissive="#edb547" emissiveIntensity={.12}/></mesh>
    <RoundPart name="endpoint-cable" radius={.004} length={.025} position={[0, 0, .03]} color={FINISH.dark}/>
  </group>
  if (visual === 'limit') return (
    <group>
      {}
      <mesh material={body} position={[0, 0, 0.015]} castShadow>
        <MachinedBoxGeometry args={[0.06, 0.09, 0.07]} detailed={detailed} radius={.006} />
      </mesh>
      <mesh material={metal} position={[0, -0.055, 0.04]} castShadow>
        <MachinedBoxGeometry args={[0.10, 0.025, 0.06]} detailed={detailed} />
      </mesh>
      {detailed && [-1, 1].map(s => <SocketBolt key={s} top radius={.004} position={[s * .038, -.041, .04]} />)}
      {detailed && <RoundPart name="limit-cable-gland" position={[0, .051, .028]} radius={.009} length={.012} axis="y" segments={6} color={FINISH.dark} />}
      {}
      <mesh position={[0, 0, -0.021]}>
        <circleGeometry args={[0.018, 16]} />
        <meshStandardMaterial ref={led} color="#56b7ff" emissive="#56b7ff" emissiveIntensity={0.12} />
      </mesh>
    </group>
  )

  if (visual === 'slot') return (
    <group>
      {



}
      <mesh material={body} castShadow>
        <MachinedBoxGeometry args={slotBodySize} detailed={detailed} radius={.003} />
      </mesh>
      {detailed && (slotLedOnTop ? <SocketBolt top radius={.003} position={[0, sizedSlot ? slotBodySize[1]/2+.001 : .008, sizedSlot ? -Math.min(.032,slotBodySize[2]*.32) : -.032]} />
        : <SocketBolt radius={Math.min(.003, sensorWidth * .12)} position={[0, -sensorHeight * .34, sensorDepth / 2 + .001]} />)}
      {slotLedOnTop ? (
        <mesh position={[0, sizedSlot ? slotBodySize[1]/2+.001 : .008, 0]}>
          <boxGeometry args={sizedSlot ? [Math.min(.016,slotBodySize[0]*.6), 0.002, Math.min(.032,slotBodySize[2]*.45)] : [.016,.004,.032]} />
          <meshStandardMaterial ref={led} color="#56b7ff" emissive="#56b7ff" emissiveIntensity={0.12} />
        </mesh>
      ) : (
        <mesh position={[0, 0, sensorDepth / 2 + 0.002]}>
          <boxGeometry args={[
            Math.max(0.014, sensorWidth * 0.50),
            Math.max(0.026, sensorHeight * 0.36),
            0.004,
          ]} />
          <meshStandardMaterial ref={led} color="#56b7ff" emissive="#56b7ff" emissiveIntensity={0.12} />
        </mesh>
      )}
    </group>
  )

  if (visual === 'pressure') return (
    <group>
      {}
      <mesh material={body} castShadow>
        <MachinedBoxGeometry args={[sensorWidth, sensorHeight, sensorDepth]} detailed={detailed} radius={.004} />
      </mesh>
      {detailed && <RoundPart name="pressure-port-nut" position={[0, -sensorHeight / 2 - .003, 0]} radius={.009} length={.006} axis="y" segments={6} />}
      <mesh position={[0, 0, sensorDepth / 2 + 0.002]}>
        <circleGeometry args={[Math.max(0.009, Math.min(sensorWidth, sensorHeight) * 0.22), 16]} />
        <meshStandardMaterial ref={led} color="#58d68d" emissive="#58d68d" emissiveIntensity={0.12} />
      </mesh>
      <mesh material={metal} position={[0, -sensorHeight / 2 - 0.008, 0]}>
        <cylinderGeometry args={[0.006, 0.006, 0.016, 10]} />
      </mesh>
    </group>
  )

  if (visual === 'proximity') return (
    <group rotation={[Math.PI / 2, 0, 0]}>
      {}
      <mesh material={metal} castShadow>
        <cylinderGeometry args={[0.022, 0.022, 0.10, detailed ? 32 : 12]} />
      </mesh>
      {detailed && <>
        {[-.023, .012].map(y => <RoundPart key={y} name="proximity-mount-nut" position={[0, y, 0]} radius={.029} length={.007} axis="y" segments={6} />)}
        <RoundPart name="proximity-rear-connector" position={[0, -.057, 0]} radius={.014} length={.014} axis="y" color={FINISH.dark} />
      </>}
      <mesh position={[0, 0.052, 0]}>
        <cylinderGeometry args={[0.016, 0.016, 0.008, 12]} />
        <meshStandardMaterial ref={led} color="#ffb347" emissive="#ffb347" emissiveIntensity={0.12} />
      </mesh>
    </group>
  )

  return (
    <group name="photoeye-optical-housing" quaternion={aim?.localRotation}>
      <mesh material={body} castShadow>
        <MachinedBoxGeometry args={[0.07, 0.11, 0.07]} detailed={detailed} radius={.006} />
      </mesh>
      {detailed && <FixturePhotoeyeMount device={device} plant={plant} />}
      {detailed && device.clipPhotoeyeBeam && device.mountedOn === 'LOAD_PHOTO_MOUNT' && (
        <ForkPhotoeyeMount />
      )}
      {detailed && <>
        <HardwarePart name="photoeye-front-insert" size={[.055, .085, .004]} position={[0, .003, -.037]} color="#161f29" radius={.003} />
        <RoundPart name="photoeye-lens-barrel" position={[0, .02, -.046]} radius={.021} length={.014} color="#46515c" />
        <RoundPart name="photoeye-cable-gland" position={[0, .063, .013]} radius={.010} length={.016} axis="y" segments={6} color={FINISH.dark} />
        <mesh name="photoeye-status-led" position={[.020, .056, -.010]} rotation={[-Math.PI / 2, 0, 0]}>
          <circleGeometry args={[.0035, 16]} />
          <meshStandardMaterial ref={led} color="#79a95b" emissive="#79a95b" emissiveIntensity={PHOTOEYE_STYLE.statusIdleEmission} roughness={.5} />
        </mesh>
        <group rotation={[0, Math.PI, 0]}>{[-1, 1].map(s => <SocketBolt key={s} position={[s * .022, -.032, .036]} radius={.0035} />)}</group>
      </>}
      <mesh position={[0, 0.02, detailed ? -.0555 : -.04]} rotation={detailed ? [Math.PI / 2, 0, 0] : [0, 0, 0]}>
        {detailed ? <cylinderGeometry args={[.018, .018, .005, 32]} /> : <sphereGeometry args={[0.018, 12, 12]} />}
        <meshStandardMaterial ref={detailed ? undefined : led} color={PHOTOEYE_STYLE.lensColor} roughness={.26} metalness={.12} />
      </mesh>
      {}
      {device.clipPhotoeyeBeam ? <mesh name="photoeye-axis-material" key={`material-beam-${photoeyeStyle.rayRadius}`} ref={beam} position={[0, 0.02, -beamLength / 2]} scale={[1, beamLength, 1]} rotation={[Math.PI / 2, 0, 0]}>
        <cylinderGeometry args={[photoeyeStyle.rayRadius, photoeyeStyle.rayRadius, 1, 12]} />
        <meshBasicMaterial color="#cf625e" transparent opacity={photoeyeStyle.rayIdleOpacity} depthWrite={false} toneMapped={false} />
      </mesh> : <mesh name="photoeye-axis-motion" key={`fixed-beam-${photoeyeStyle.rayRadius}`} ref={beam} position={[0, 0.02, -beamLength / 2]} rotation={[Math.PI / 2, 0, 0]}>
        <cylinderGeometry args={[PHOTOEYE_STYLE.rayRadius, PHOTOEYE_STYLE.rayRadius, beamLength, 12]} />
        <meshBasicMaterial color="#cf625e" transparent opacity={PHOTOEYE_STYLE.rayIdleOpacity} depthWrite={false} toneMapped={false} />
      </mesh>}
      {device.sensorReceiver && (
        <group position={[0, 0.02, -beamLength - 0.018]} rotation={[0, Math.PI, 0]}>
          <mesh material={metal} castShadow>
            <MachinedBoxGeometry args={[0.08, 0.11, 0.035]} detailed={detailed} radius={.005} />
          </mesh>
          {detailed && [-1, 1].map(s => <SocketBolt key={s} position={[s * .031, -.043, .019]} radius={.003} />)}
          <mesh position={[0, 0, 0.019]}>
            <planeGeometry args={[0.055, 0.075]} />
            <meshStandardMaterial color="#d9dfe7" roughness={0.45} metalness={0.2} />
          </mesh>
        </group>
      )}
    </group>
  )
}



function Feeder({ device, plant, detailed }: DeviceProps) {
  const stack = useRef<THREE.Group>(null)
  const stockMeshes = useRef<Array<THREE.Mesh | null>>([])
  const body = useMetal(device.color, { rough: 0.7, metal: 0.4 })
  const windowMaterial = useMemo(
    () => new THREE.MeshStandardMaterial({
      color: '#7f97a8',
      roughness: 0.34,
      metalness: 0.12,
      transparent: true,
      opacity: 0.38,
      side: THREE.DoubleSide,
    }),
    [],
  )
  const [w, h, d] = device.size
  const slotHeight = 0.20
  const railThickness = 0.055
  const panelHeight = Math.max(0.12, h - slotHeight - (detailed ? railThickness : 0))
  const railY = (slotHeight - (detailed ? railThickness : 0)) / 2

  useFrame((_, delta) => {
    const stock = Math.max(0, Math.min(3, Math.round(plant.state(device.id).pos * 3)))
    const actuator = device.actuatorRef ? plant.state(device.actuatorRef).pos : 0



    const visibleReserve = stock === 3 ? 2 : stock
    stockMeshes.current.forEach((mesh, index) => {
      if (mesh) mesh.visible = index < visibleReserve
    })
    if (stack.current) {
      const target = feederStackOffset(stock, actuator)
      stack.current.position.y = THREE.MathUtils.damp(stack.current.position.y, target, 14, delta)
    }
  })

  return (
    <group>
      {}
      {([-1, 1] as const).flatMap((sx) =>
        ([-1, 1] as const).map((sz) => (
          <mesh
            key={`${sx}-${sz}`}
            material={body}
            position={[
              sx * (w / 2 - railThickness / 2),
              detailed ? -railThickness / 2 : 0,
              sz * (d / 2 - railThickness / 2),
            ]}
            castShadow
          >
            <boxGeometry args={[railThickness, h - (detailed ? railThickness : 0), railThickness]} />
          </mesh>
        )),
      )}
      {}
      {([-1, 1] as const).map((sz) => (
        <mesh
          key={`top-x-${sz}`}
          material={body}
          position={[0, h / 2 - railThickness / 2, sz * (d / 2 - railThickness / 2)]}
          castShadow
        >
          <boxGeometry args={[w, railThickness, railThickness]} />
        </mesh>
      ))}
      {([-1, 1] as const).map((sx) => (
        <mesh
          key={`top-z-${sx}`}
          material={body}
          position={[sx * (w / 2 - railThickness / 2), h / 2 - railThickness / 2, 0]}
          castShadow
        >
          <boxGeometry args={[railThickness, railThickness, d - (detailed ? 2 * railThickness : 0)]} />
        </mesh>
      ))}
      {


}
      {([-1, 1] as const).map((sx) => (
        <mesh key={`wall-x-${sx}`} material={windowMaterial} position={[sx * (w / 2 - 0.008), railY, 0]}>
          <boxGeometry args={[0.018, panelHeight, Math.max(0.08, d - railThickness * 2)]} />
        </mesh>
      ))}
      {([-1, 1] as const).map((sz) => (
        <mesh key={`wall-z-${sz}`} material={windowMaterial} position={[0, railY, sz * (d / 2 - 0.008)]}>
          <boxGeometry args={[Math.max(0.08, w - railThickness * 2), panelHeight, 0.018]} />
        </mesh>
      ))}
      {}
      {}
      <group ref={stack}>
        {Array.from({ length: 2 }, (_, index) => (
          <mesh
            key={index}
            ref={(mesh) => { stockMeshes.current[index] = mesh }}
            position={[0, -h / 2 + 0.08 + (1 + index) * 0.18, 0]}
            castShadow
          >
            {}
            <boxGeometry args={[0.16, 0.16, 0.16]} />
            <meshStandardMaterial color="#c98a3c" roughness={0.65} />
          </mesh>
        ))}
      </group>
    </group>
  )
}



function StorageRack({ device, detailed }: DeviceProps) {
  const [w, h, d] = device.size
  const frame = useMetal(device.color, { rough: 0.58, metal: 0.75 })
  const shelf = useMetal('#8b949f', { rough: 0.52, metal: 0.72 })
  const levels = [-h / 2 + 0.12, 0, h / 2 - 0.22]
  return (
    <group>
      {([-1, 1] as const).flatMap((sx) =>
        ([-1, 1] as const).map((sz) => (
          <mesh key={`${sx}-${sz}`} material={frame}
            position={[sx * (w / 2 - 0.045), 0, sz * (d / 2 - 0.045)]} castShadow>
            {detailed ? <SlottedProfileGeometry edge={.09} length={h} /> : <boxGeometry args={[0.09, h, 0.09]} />}
          </mesh>
        )),
      )}
      {levels.map((y) => (
        <mesh key={y} material={shelf} position={[0, y, 0]} castShadow receiveShadow>
          <MachinedBoxGeometry args={[w, 0.07, d]} detailed={detailed} />
        </mesh>
      ))}
      {}
    </group>
  )
}

function LiftFork({ device, plant, detailed }: DeviceProps) {
  const carriage = useRef<THREE.Group>(null)
  const metal = useMetal(device.color, { rough: 0.4, metal: 0.9 })
  const dark = useMetal('#3f4852', { rough: 0.65, metal: 0.65 })
  const stroke = Math.max(0.24, device.size[2])
  useFrame(() => {
    if (carriage.current) carriage.current.position.z = -plant.state(device.id).pos * 0.18
  })
  return (
    <group ref={carriage}>
      <mesh material={dark} position={[0, 0.04, 0.10]} castShadow>
        <MachinedBoxGeometry args={[0.34, 0.30, 0.12]} detailed={detailed} />
      </mesh>
      {detailed && [-1, 1].flatMap(x => [-1, 1].map(y => <SocketBolt key={`${x}:${y}`}
        position={[x * .13, .04 + y * .11, .163]} radius={.01} />))}
      {[-0.105, 0.105].map((x) => (
        <mesh key={x} material={metal} position={[x, -0.08, -stroke / 2 + 0.06]} castShadow>
          <MachinedBoxGeometry args={[0.055, 0.055, stroke]} detailed={detailed} />
        </mesh>
      ))}
    </group>
  )
}



function Box({ device, plant, detailed }: DeviceProps) {
  const led = useRef<THREE.MeshStandardMaterial>(null)
  const rotor = useRef<THREE.Mesh>(null)
  const [w, h, d] = device.size
  const body = useMetal(device.color, { rough: 0.6 })
  const spinning = device.motion === 'continuous'
  const glowColor = device.kind === 'heater' ? '#ff7a45' : '#3ddc84'

  useFrame(() => {
    const s = plant.state(device.id)
    if (led.current) led.current.emissiveIntensity = s.running ? (device.kind === 'heater' ? 2.4 : 1.6) : 0.05
    if (rotor.current) rotor.current.rotation.x = s.spin
  })

  return (
    <group>
      <mesh material={body} castShadow receiveShadow>
        <boxGeometry args={[w, h, d]} />
      </mesh>
      {spinning && (
        <mesh ref={rotor} position={[0, 0, d / 2 + 0.03]} rotation={[0, Math.PI / 2, Math.PI / 2]} castShadow>
          <cylinderGeometry args={[h * 0.3, h * 0.3, 0.06, 14]} />
          <meshStandardMaterial color="#9aa3ad" {...(detailed ? satinFinish(.25, .9) : { metalness: .9, roughness: .25 })} />
        </mesh>
      )}
      {}
      <mesh position={[w / 2 - 0.06, h / 2 - 0.06, d / 2 + 0.005]}>
        <circleGeometry args={[0.022, 16]} />
        <meshStandardMaterial ref={led} color={glowColor} emissive={glowColor} emissiveIntensity={0.05} />
      </mesh>
    </group>
  )
}



function TurnoverDrive({ device, plant }: DeviceProps) {
  const rotor = useRef<THREE.Mesh>(null)
  const body = useMetal('#566472')
  const metal = useMetal('#9aadb9')
  useFrame(() => {
    if (rotor.current) rotor.current.rotation.z = plant.state(device.id).pos * Math.PI
  })
  return <group>
    <mesh material={body} castShadow><boxGeometry args={[.40, .40, .40]} /></mesh>
    <mesh ref={rotor} material={metal} position={[0, 0, .225]} castShadow>
      <boxGeometry args={[.24, .12, .05]} />
    </mesh>
  </group>
}

function TurnoverJaws({ device, plant }: DeviceProps) {
  const rotation = useRef<THREE.Group>(null)
  const left = useRef<THREE.Group>(null)
  const right = useRef<THREE.Group>(null)
  const body = useMetal('#8393a1')
  const pad = useMetal('#d9b36a', { rough: .9, metal: .1 })
  const shape = turnoverGripGeometry(1)
  useFrame(() => {
    const current = turnoverGripGeometry(plant.state(device.id).pos)
    if (rotation.current) rotation.current.rotation.z = plant.state(device.actuatorRef!).pos * Math.PI
    if (left.current) left.current.position.x = -current.contactX
    if (right.current) right.current.position.x = current.contactX
  })
  return <group ref={rotation} name={`${device.id}-rotating-grip`}>
    <mesh name="turnover-gripper-palm" material={body} castShadow><boxGeometry args={[.36, .12, .08]} /></mesh>
    {([-1, 1] as const).map((side) => (
      <group key={side} ref={side < 0 ? left : right} position={[side * shape.contactX, 0, 0]}>
        <mesh name="turnover-jaw-slider" material={body} position={[side * shape.padThickness / 2, 0, .035]} castShadow>
          <boxGeometry args={[.065, .07, .03]} />
        </mesh>
        {/* Each finger runs from the palm to an explicit inward-facing pad.
            The pad, not the surrounding bracket, contacts the workpiece. */}
        <mesh material={body} position={[side * (shape.padThickness + shape.fingerWidth / 2), 0, shape.fingerCenterZ]} castShadow>
          <boxGeometry args={[shape.fingerWidth, shape.fingerHeight, shape.fingerDepth]} />
        </mesh>
        <mesh name={`${device.id}-contact-pad-${side}`} material={pad}
          position={[side * shape.padThickness / 2, 0, shape.partCenterZ]} castShadow>
          <boxGeometry args={[shape.padThickness, shape.padHeight, shape.padDepth]} />
        </mesh>
      </group>
    ))}
  </group>
}

export function DeviceMesh(props: DeviceProps) {
  const inheritedRealism=useMotionRealism()
  const realism=inheritedRealism||props.plant.machine?.replaySuite==='motion'||/^MOT-/.test(props.plant.machine?.title??'')
  const inheritedMotion=useMotionPresentation()
  const inheritedProcess=useMotionProcessDetail()
  const inheritedPalette=useContext(IndexEquipmentPalette)
  const inheritedMaterial=useMaterialPresentation()
  const materialPresentation=inheritedMaterial||/^MAT-/.test(props.plant.machine?.title??'')
  const industrialPalette=materialPresentation||inheritedPalette==='industrial'||/^MOT-/.test(props.plant.machine?.title??'')
  const processDetail=inheritedProcess || /^(MOT-E14|MOT-M14|MOT-H03|MOT-H15)(?:\s|$)/.test(props.plant.machine?.title??'')
  const motionPresentation=inheritedMotion || processDetail || /^(MOT-E01|MOT-E14|MOT-M02|MOT-H02|MOT-H03)(?:\s|$)/.test(props.plant.machine?.title??'')
  const indexPalette=props.plant.machine.devices.some(d=>d.visualVariant==='easy15-base-06'||d.visualVariant==='v13-intercept-base')
  return <MotionRealism.Provider value={realism}><MotionProcessDetail.Provider value={processDetail}><MotionPresentation.Provider value={motionPresentation}><IndexEquipmentPalette.Provider value={industrialPalette?'industrial':indexPalette||motionPresentation}><SatinFinishContext.Provider value={!!props.detailed}>
    <MaterialPresentation.Provider value={materialPresentation}><MaterialMediumFinish.Provider value={/^MAT-M\d|^MAT-V[678]-/.test(props.plant.machine.title)}><DeviceShape {...props} /></MaterialMediumFinish.Provider></MaterialPresentation.Provider>
    <MotionMediumDetails {...props} />
  </SatinFinishContext.Provider></IndexEquipmentPalette.Provider></MotionPresentation.Provider></MotionProcessDetail.Provider></MotionRealism.Provider>
}

function DeviceShape(props: DeviceProps) {
  if (props.device.visualVariant==='cell3-priority-wind-tape') return <MaterialWindTapeHardware {...props} />
  if(props.device.id==='HEAD_A_ARM'&&Math.abs(props.device.size[2]-.55)<.001)return <WideGripperRearYoke/>

  // H01 sensing remains in the PLC trace; omit the old in-cell sensor decorations.
  if(/^MAT-H01(?:\s|$)/.test(props.plant.machine.title)&&/^[AB]_(?:CLAMP_clamp_(?:open|closed))$/.test(props.device.id))return null
  if (props.device.visualVariant?.startsWith('easy15-')) return <MaterialEasy15Hardware {...props} />
  if(isHardStationSupport(props))return <HardStationSupport {...props}/>
  if (props.device.visualVariant === 'motion-hard-cell') return <MotionHardHardware {...props} />
  if (props.device.visualVariant?.startsWith('motion-v08-')) return <MotionDiverseHardware {...props} />
  if (props.device.visualVariant?.startsWith('v8-')) return <group name={`material-v8-hardware-${props.device.id}`}><MaterialAdvancedHardware {...props} /></group>
  if (props.device.visualVariant?.startsWith('v13-')) return <group name={`material-v13-hardware-${props.device.id}`}><MaterialAdvancedHardware {...props} /></group>
  if (props.device.visualVariant?.startsWith('v7-')) return <group name={`material-v7-hardware-${props.device.id}`}><MaterialExtensionHardware {...props} /></group>
  if (props.device.visualVariant?.startsWith('v6-buffer-') || props.device.visualVariant?.startsWith('v6-stack-')) return <MaterialInventoryHardware {...props} />
  if (props.device.visualVariant?.startsWith('v6-')) return <MaterialV6Hardware {...props} />
  if (props.device.visualVariant === 'motion-holding-brake') return <MotionHoldingBrake {...props} />
  if (['motion-easy-roll', 'motion-reference-dog', 'motion-home-probe'].includes(props.device.visualVariant ?? '')) return <MotionEasyHardware {...props} />
  if (props.device.visualVariant === 'material-vacuum-mast') return <VacuumMast {...props} />
  if (props.device.visualVariant?.startsWith('web-')) return <WebIndexHardware {...props} />
  if (props.device.visualVariant==='cell3-priority-anchor') return null
  if (props.device.visualVariant==='cell3-mini-anchor') return null
  if (props.device.visualVariant?.startsWith('cell3-composable-')) return <ComposableHardware {...props}/>
  if (props.device.visualVariant?.startsWith('cell3-r9-')) return <MaterialFlowCellHardware {...props}/>
  if (props.device.visualVariant?.startsWith('cell3-r8-')) return <MaterialRedesignHardware {...props}/>
  if (props.device.visualVariant==='cell3-mini-replenish') return <MaterialReplenishmentHardware {...props}/>
  if (props.device.visualVariant==='cell3-mini-tape') return <MaterialTapeHardware {...props} />
  if (props.device.visualVariant?.startsWith('cell3-mini-')) return <MaterialMiniProcessHardware {...props} />
  if (props.device.visualVariant?.startsWith('cell3-priority-')) return <MaterialHardPriorityHardware {...props} />
  if (props.device.visualVariant?.startsWith('cell3-')) return <MaterialHard15Hardware {...props} />
  if (props.device.visualVariant?.startsWith('hard-')) return <TendingHardware {...props} />
  if (props.device.visualVariant === 'material-fork-clearance-rack' || props.device.visualVariant === 'material-pallet-rack') return <ForkClearanceRack {...props} />
  if (props.device.visualVariant === 'machining-spindle') return <MachiningSpindle {...props} />
  if (props.device.visualVariant === 'compact-transfer-belt') return <CompactTransferBelt {...props} />
  if (props.device.visualVariant === 'pressure-seal-head') return <PressureSealHead {...props} />
  if (props.device.visualVariant === 'pressure-test-module') return <PressureTestModule {...props} />
  if (props.device.visualVariant === 'test-air-valve') return <TestAirValve {...props} />
  if (props.device.visualVariant === 'turnover-drive') return <TurnoverDrive {...props} />
  if (props.device.visualVariant === 'material-pallet-locator') return <PalletLocatorAssembly {...props} />
  if (props.device.visualVariant === 'material-locator-pallet') return <LocatorPalletAssembly />
  if (props.device.visualVariant === 'material-contact-height-gauge') return <ContactHeightGaugeAssembly {...props} />
  if (props.device.visualVariant === 'turnover-jaws') return <TurnoverJaws {...props} />
  switch (props.device.kind) {
    case 'conveyor': return props.detailed ? <ConveyorAssembly {...props} /> : <Conveyor {...props} />
    case 'servo': return props.detailed ? <ServoAssembly {...props} /> : <ServoAxis {...props} />
    case 'cylinder': return props.detailed ? <CylinderAssembly {...props} /> : <Cylinder {...props} />
    case 'stopper': return props.detailed ? <StopperAssembly {...props} /> : <Stopper {...props} />
    case 'door': return props.detailed ? <DoorAssembly {...props} /> : <Door {...props} />
    case 'clamp': return props.detailed ? <ClampAssembly {...props} /> : <Clamp {...props} />
    case 'press': return props.detailed ? <PressAssembly {...props} /> : <Press {...props} />
    case 'spindle': return <Spindle {...props} />
    case 'lift': return <Lift {...props} />
    case 'vertical_slide': return <VerticalSlide {...props} />
    case 'fixture': return <Fixture {...props} />
    case 'platform': return <Platform {...props} />
    case 'support_frame': return <SupportFrame {...props} />
    case 'rack': return props.detailed ? <RackAssembly {...props} /> : <StorageRack {...props} />
    case 'fork': return props.detailed ? <ForkAssembly {...props} /> : <LiftFork {...props} />
    case 'turntable': return props.detailed ? <TurntableAssembly {...props} /> : <Turntable {...props} />
    case 'robot': return props.detailed ? <RobotAssembly {...props} /> : <Robot {...props} />
    case 'gripper': return /^MAT-H01(?:\s|$)/.test(props.plant.machine.title) ? <CouplingHead {...props} robot/> : props.detailed ? <GripperAssembly {...props} /> : <Gripper {...props} />
    case 'vacuum': return props.detailed ? <VacuumAssembly {...props} /> : <VacuumPickup {...props} />
    case 'lamp': return <Lamp {...props} />
    case 'sensor': return <Sensor {...props} />
    case 'feeder': return props.detailed ? <FeederAssembly {...props} /> : <Feeder {...props} />
    default: return <Box {...props} />
  }
}
