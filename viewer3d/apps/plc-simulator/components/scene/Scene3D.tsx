'use client'
import {collectEquipmentGroups,type EquipmentGroup} from './equipmentGroups'








import { Canvas, useFrame, useThree } from '@react-three/fiber'
import { Grid, Html, OrbitControls, TransformControls } from '@react-three/drei'
import { Suspense, useCallback, useEffect, useMemo, useRef, useState } from 'react'
import * as THREE from 'three'
import type { MotionHardState } from '@/lib/replay/adapter'
import type { Plant } from '@/lib/machine/plant'
import type { LaidOutMachine } from '@/lib/machine/layout'
import type { DeviceSpec } from '@/lib/machine/infer'
import { primaryDevice, primaryDeviceList, structuralPart } from '@/lib/replay/primaryDevices'
import {deviceBadgePosition,equipmentSelectionTarget} from './deviceSelection'
import { DeviceNameBadge, type DeviceNameAnchor } from './DeviceNameBadge'
import { deviceDisplayName, equipmentPartName } from '@/lib/replay/deviceDisplayName'
import { DeviceMesh } from './devices'
import { MaterialServiceScope } from './MaterialServiceScope'
import { MaterialRendererGuard } from './MaterialRendererGuard'
import { replayShadowSettings } from './shadowSettings'
import {ReplaySelectionContext,useReplaySelection} from '@/app/replay/ReplaySelection'
import { EquipmentLabel } from './EquipmentLabel'
import { EquipmentCamera } from './EquipmentCamera'
import { equipmentFloor,equipmentFront,recordedTravelBounds } from './equipmentFraming'
import { useEquipmentBounds } from './useEquipmentBounds'
import { portraitFramingScale } from './cameraFraming'
import { FactoryFloorMarkings } from './FactoryFloorMarkings'
import { materialHardCellBounds } from './factoryFloor'
import { WorkshopReflections } from './WorkshopReflections'
import { MachinedWorkpiece } from './assemblies/MachiningAssembly'
import { PressureVessel } from './assemblies/PressureTestAssembly'
import { SlottedPallet } from './assemblies/SlottedPallet'
import { HardStock } from './assemblies/MaterialHard15Hardware'
import { MaterialCan } from './assemblies/MaterialAdvancedHardware'
import { MotionRegripPart } from './assemblies/MotionRegripPart'
import { MotionReplayCanvas } from './MotionReplayCanvas'



const MAX_PARTS = 24

function Parts({ plant }: { plant: Plant }) {
  const mesh = useRef<THREE.InstancedMesh>(null)
  const dummy = useMemo(() => new THREE.Object3D(), [])
  const color = useMemo(() => new THREE.Color(), [])
  const beltY = plant.machine.geometry.beltY

  useFrame(() => {
    const m = mesh.current
    if (!m) return
    const parts = plant.parts
    const n = Math.min(parts.length, MAX_PARTS)
    for (let i = 0; i < n; i++) {
      const p = parts[i]
      dummy.position.set(p.x, p.y ?? beltY + 0.11, p.z ?? 0)
      dummy.rotation.set(...(p.rotation ?? [0, 0, 0] as [number, number, number]))
      dummy.scale.setScalar(p.machiningDepths || p.renderVariant === 'pressure-vessel' || p.renderVariant === 'slotted-pallet' || p.renderVariant === 'rack-load-pallet' ? 0 : 1)
      if (p.materialDimensions) dummy.scale.set(...p.materialDimensions.map(v => v / .16) as [number, number, number])
      if (plant.machine.replaySuite === 'motion' && p.motionDimensions) {
        dummy.scale.set(...p.motionDimensions.map(v => v / .16) as [number, number, number])
        if (p.renderVariant === 'motion-regrip') dummy.scale.setScalar(0)
        if (p.visible === false) dummy.scale.setScalar(0)
      }
      if (p.renderVariant === 'v8-can' || p.renderVariant?.startsWith('hard-stock-')) dummy.scale.setScalar(0)
      if (p.materialDimensions && p.visible === false) dummy.scale.setScalar(0)
      dummy.updateMatrix()
      m.setMatrixAt(i, dummy.matrix)
      m.setColorAt(i, color.set(p.color))
    }

    for (let i = n; i < MAX_PARTS; i++) {
      dummy.scale.setScalar(1)
      dummy.position.set(0, -50, 0)
      dummy.updateMatrix()
      m.setMatrixAt(i, dummy.matrix)
    }
    m.count = MAX_PARTS
    m.instanceMatrix.needsUpdate = true
    if (m.instanceColor) m.instanceColor.needsUpdate = true
  })

  // Instance positions change across scans and task switches, including an
  // initially empty web scene. A cached empty/off-screen bounding sphere must
  // not cull subsequently visible workpieces (at most 24 instances).
  return (
    <><instancedMesh name="replay-workpieces" ref={mesh} args={[undefined, undefined, MAX_PARTS]} frustumCulled={false} castShadow receiveShadow>
      <boxGeometry args={[0.16, 0.16, 0.16]} />
      <meshStandardMaterial roughness={0.5} metalness={0.15} />
    </instancedMesh>
    {plant.parts.filter(p=>p.renderVariant?.startsWith('hard-stock-')).map(p=><HardStock key={p.id} id={p.id} plant={plant}/>)}
    {plant.parts.filter(p=>p.renderVariant==='v8-can').map(p=><MaterialCan key={p.id} id={p.id} plant={plant}/>)}
    {plant.parts.filter(p=>p.machiningDepths).map(p=><MachinedWorkpiece key={p.id} id={p.id} plant={plant} tending={plant.machine.devices.some(d=>d.visualVariant==='hard-fixture-clamp')}/>)}
    {plant.parts.filter(p=>p.renderVariant==='pressure-vessel').map(p=><PressureVessel key={p.id} id={p.id} plant={plant}/>)}
    {plant.parts.filter(p=>p.renderVariant==='slotted-pallet').map(p=><SlottedPallet key={p.id} id={p.id} plant={plant}/>)}
    {plant.parts.filter(p=>p.renderVariant==='rack-load-pallet').map(p=><SlottedPallet key={p.id} id={p.id} plant={plant} compact/>)}
    {plant.machine.replaySuite === 'motion' && plant.parts.filter(p=>p.renderVariant==='motion-regrip').map(p=><MotionRegripPart key={p.id} id={p.id} plant={plant}/>)}</>
  )
}

/** A painted top-face stripe makes the symmetric cube's turnover observable. */
function PartOrientationMarkers({ plant }: { plant: Plant }) {
  const mesh = useRef<THREE.InstancedMesh>(null)
  const dummy = useMemo(() => new THREE.Object3D(), [])
  const offset = useMemo(() => new THREE.Vector3(), [])
  useFrame(() => {
    if (!mesh.current) return
    let count = 0
    for (const part of plant.parts) {
      if (!part.orientationMarker || count >= MAX_PARTS) continue
      dummy.rotation.set(...(part.rotation ?? [0, 0, 0] as [number, number, number]))
      const dims = part.materialDimensions
      dummy.scale.set(...(dims ? [.32, 1, dims[2] / .11] : [1, 1, 1]) as [number, number, number])
      offset.set(dims ? dims[0] / 2 - .022 : 0, dims ? dims[1] / 2 + .001 : .081, 0).applyEuler(dummy.rotation)
      dummy.position.set(part.x + offset.x, (part.y ?? plant.machine.geometry.beltY + .11) + offset.y, (part.z ?? 0) + offset.z)
      dummy.updateMatrix()
      mesh.current.setMatrixAt(count++, dummy.matrix)
    }
    mesh.current.count = count
    mesh.current.instanceMatrix.needsUpdate = true
  })
  return <instancedMesh name="replay-orientation-markers" ref={mesh} args={[undefined, undefined, MAX_PARTS]} count={0} frustumCulled={false}>
    <boxGeometry args={[.10, .002, .11]} />
    <meshStandardMaterial color="#fff2a3" roughness={.8} />
  </instancedMesh>
}



function DeviceLabel({
  device,
  plant,
  onSelect,
  selected,
  resolveObject,
}: {
  device: DeviceSpec
  plant: Plant
  onSelect: (id: string) => void
  selected: boolean
  resolveObject?:()=>THREE.Object3D|undefined
}) {
  return <EquipmentLabel id={device.id} name={device.label} resolve={resolveObject} position={[device.pos[0],device.pos[1]+device.size[1]/2+.13,device.pos[2]]} onSelect={()=>onSelect(device.id)}/>

}



/** Walls only: neither the room nor its skirting owns a hidden second floor.
 * Outward normals + BackSide keep near walls out of the camera's way. */
function RoomSkin({ width, depth, height, centerY, material, ceiling = false }: {
  width: number; depth: number; height: number; centerY: number
  material: THREE.Material; ceiling?: boolean
}) {
  return <group name="factory-room-skin">
    {([-1, 1] as const).map(side => <group key={side}>
      <mesh name="factory-wall" position={[0, centerY, side * depth / 2]}
        rotation={[0, side === 1 ? 0 : Math.PI, 0]} material={material} receiveShadow raycast={() => null}>
        <planeGeometry args={[width, height]} />
      </mesh>
      <mesh name="factory-wall" position={[side * width / 2, centerY, 0]}
        rotation={[0, side * Math.PI / 2, 0]} material={material} receiveShadow raycast={() => null}>
        <planeGeometry args={[depth, height]} />
      </mesh>
    </group>)}
    {ceiling && <mesh name="factory-ceiling" position={[0, centerY + height / 2, 0]}
      rotation={[-Math.PI / 2, 0, 0]} material={material} raycast={() => null}>
      <planeGeometry args={[width, depth]} />
    </mesh>}
  </group>
}


function FactoryShell({ width, depth = 16, lightTheme, cutaway = false, openForeground = false, frontSign = -1 }: { width: number; depth?: number; lightTheme: boolean; cutaway?: boolean; openForeground?: boolean; frontSign?: 1 | -1 }) {
  const roomW = width + 8
  const roomD = depth
  const wallH = 5.2

  const wall = useMemo(
    () => new THREE.MeshStandardMaterial({
      color: lightTheme ? '#e1e5e4' : '#222c38',
      roughness: 0.95, metalness: 0.02, side: THREE.BackSide,
    }),
    [lightTheme],
  )
  const kick = useMemo(
    () => new THREE.MeshStandardMaterial({
      color: lightTheme ? '#a4b2b3' : '#18202a',
      roughness: 0.9, metalness: 0.04, side: THREE.BackSide,
    }),
    [lightTheme],
  )
  const beam = useMemo(
    () => new THREE.MeshStandardMaterial({
      color: lightTheme ? '#a4adb3' : '#2a3542', roughness: 0.8, metalness: 0.35,
    }),
    [lightTheme],
  )
  const lamp = useMemo(
    () => new THREE.MeshStandardMaterial({
      color: '#f4f7ff', emissive: new THREE.Color('#eaf1ff'), emissiveIntensity: 1.6, roughness: 0.4,
    }),
    [],
  )

  const columnX: number[] = []
  for (let x = -roomW / 2 + 0.6; x <= roomW / 2 - 0.6 + 1e-6; x += Math.max(4, roomW / 5)) columnX.push(x)

  return (
    <group>
      <RoomSkin width={roomW} depth={roomD} height={wallH + .6}
        centerY={(wallH - .6) / 2} material={wall} ceiling={!cutaway} />
      {}
      <RoomSkin width={roomW - .02} depth={roomD - .02} height={1.76}
        centerY={.28} material={kick} />
      {}
      {columnX.map((x) => (
        <group key={`col${x}`}>
          {(openForeground ? [-frontSign * (roomD / 2 - 0.18)] : [-roomD / 2 + 0.18, roomD / 2 - 0.18]).map((z) => (
            <mesh key={z} material={beam} position={[x, wallH / 2, z]} castShadow={!lightTheme}>
              <boxGeometry args={[0.22, wallH, 0.16]} />
            </mesh>
          ))}
        </group>
      ))}
      {}
      {!cutaway && [-roomD / 4, roomD / 4].map((z) => (
        <mesh key={`tr${z}`} material={beam} position={[0, wallH - 0.32, z]} castShadow={!lightTheme}>
          <boxGeometry args={[roomW - 0.4, 0.16, 0.14]} />
        </mesh>
      ))}
      {}
      {!cutaway && [-roomD / 4, roomD / 4].map((z) =>
        [-roomW / 4, 0, roomW / 4].map((x) => (
          <mesh key={`lp${x}:${z}`} material={lamp} position={[x, wallH - 0.14, z]}>
            <boxGeometry args={[Math.min(2.2, roomW / 5), 0.05, 0.34]} />
          </mesh>
        )),
      )}
    </group>
  )
}


function SafetyOutline({ width, depth, lightTheme }: { width: number; depth: number; lightTheme: boolean }) {
  const paint = useMemo(
    () => new THREE.MeshStandardMaterial({
      color: lightTheme ? '#c9971f' : '#8a6a1e',
      roughness: 0.85,
      metalness: 0.02,
    }),
    [lightTheme],
  )
  const t = 0.11
  const half = { x: width / 2, z: depth / 2 }
  return (
    <group position={[0, 0.004, 0]}>
      {[half.z, -half.z].map((z) => (
        <mesh key={z} material={paint} rotation={[-Math.PI / 2, 0, 0]} position={[0, 0, z]}>
          <planeGeometry args={[width, t]} />
        </mesh>
      ))}
      {[half.x, -half.x].map((x) => (
        <mesh key={x} material={paint} rotation={[-Math.PI / 2, 0, 0]} position={[x, 0, 0]}>
          <planeGeometry args={[t, depth]} />
        </mesh>
      ))}
    </group>
  )
}

export function Stage({ machine, plant, lightTheme = false, bounds }: { machine: LaidOutMachine; plant?: Plant; lightTheme?: boolean; bounds?: {x:number;z:number;width:number;depth:number} }) {
  const cell=bounds ?? materialHardCellBounds(machine.title)
  const centerX=cell?.x??0,centerZ=cell?.z??0
  const width=Math.max(8,cell?.width??machine.geometry.endX-machine.geometry.startX+4)
  const depth=Math.max(16,(cell?.depth??10)+4)
  const frontSign=equipmentFront(machine)
  const shadow = replayShadowSettings(machine.replaySuite)

  return (
    <>
      {/* ACES tone mapping can wash out bright lighting.
          Keep enough contrast between machinery and floor. */}
      <ambientLight intensity={lightTheme ? 1.0 : 0.95} />
      <hemisphereLight args={[lightTheme ? '#f6f8ff' : '#d5e5f5', lightTheme ? '#d4d9d6' : '#344255', lightTheme ? .9 : 1.0]} />
      <directionalLight
        position={[4, 8, 5]}
        intensity={lightTheme ? 1.6 : 2.1}
        castShadow
        shadow-mapSize={[2048, 2048]}
        shadow-camera-left={-10}
        shadow-camera-right={10}
        shadow-camera-top={10}
        shadow-camera-bottom={-10}
        shadow-camera-near={shadow.near}
        shadow-camera-far={shadow.far}
        shadow-bias={shadow.bias}
        shadow-normalBias={shadow.normalBias}
      />
      <directionalLight position={[-6, 4, -4]} intensity={lightTheme ? .7 : 0.75} color={lightTheme ? '#f4f7ff' : '#a9c5ff'} />
      {/* Fill light across the line so front faces remain visible */}
      <pointLight position={[0, 3.2, 2.2]} intensity={lightTheme ? 5 : 10} distance={14} decay={2} color="#dcecff" />

      {/* 24cm solid slab. Top stays at -0.02: equipment and paint heights do not change. */}
      <mesh name="factory-floor-solid" position={[centerX, -0.14, centerZ]} receiveShadow raycast={() => null}>
        <boxGeometry args={[width + 8, 0.24, depth]} />
        <meshStandardMaterial color={lightTheme ? '#bfc5c3' : '#2b3746'} roughness={0.94} metalness={0.03} />
      </mesh>
      {/* Replay uses a smooth epoxy floor: no near-coplanar transparent grid layer. */}
      {!lightTheme && <Grid
        position={[0, 0.001, 0]}
        args={[width + 8, depth]}
        cellSize={0.5}
        cellThickness={lightTheme ? 0.25 : 0.5}
        cellColor={lightTheme ? '#b8c1c0' : '#3b4a5c'}
        sectionSize={2}
        sectionThickness={lightTheme ? 0.6 : 1}
        sectionColor={lightTheme ? '#a9b5b6' : '#53657a'}
        fadeDistance={26}
        fadeStrength={1}
        infiniteGrid={false}
      />}
      {lightTheme ? <FactoryFloorMarkings bounds={cell} devices={machine.devices} title={machine.title} frontSign={frontSign}/>
        : <SafetyOutline width={width + 3.2} depth={8.4} lightTheme={false} />}
      <group position={[centerX,0,centerZ]}><FactoryShell depth={depth} width={width} lightTheme={lightTheme} frontSign={frontSign} openForeground cutaway={machine.geometry.view.cutaway??false}/></group>
    </>
  )
}

/**
 * Set the initial camera framing to the equipment bounds.
 *
 * Conveyor length alone can clip tower lights or utility racks.
 * Measure all device bounding boxes when framing the scene.
 */
export type CameraView = 'iso' | 'front' | 'side' | 'top'

function CameraRig({ machine, bounds, view = 'iso', responsive = false, resetKey = 0, onInteraction }: {
  machine: LaidOutMachine; view?: CameraView; responsive?: boolean; resetKey?: number; onInteraction?: () => void
  bounds?: {x:number;z:number;width:number;depth:number}
}) {
  const { camera, size } = useThree()
  const controls = useRef<any>(null)
  const previousScale = useRef(1)
  const framingScale = responsive ? portraitFramingScale(size.width, size.height) : 1
  // The layout stage already computed framing; apply it here.
  const { dist } = machine.geometry.view
  const cell = useMemo(() => bounds ?? materialHardCellBounds(machine.title), [bounds, machine.title])
  const target = useMemo<[number, number, number]>(() => cell
    ? [cell.x, .9, cell.z] : machine.geometry.view.target, [cell, machine.geometry.view.target])
  const frontSign = machine.geometry.view.frontSign ?? 1

  useEffect(() => {
    const offsets: Record<CameraView, [number, number, number]> = {
      iso: [0.46, 0.5, 0.78 * frontSign],
      front: [0, 0.24, frontSign],
      side: [1.0, 0.24, 0],
      top: [0.01, 1.0, 0.01],
    }
    const [ox, oy, oz] = offsets[view]
    // A preset request also resets a target moved by manual panning.
    controls.current?.target.set(...target)
    camera.position.set(target[0] + dist * ox, target[1] + dist * oy, target[2] + dist * oz)
    camera.lookAt(target[0], target[1], target[2])
    if (cell) {
      // Fit the entire fixed floor envelope and equipment height on preset entry.
      // Orbiting and scrubbing do not recalculate the camera or move the paint.
      const anchor = new THREE.Vector3(...target)
      for (let attempt = 0; attempt < 60; attempt++) {
        camera.updateMatrixWorld(true)
        const fits = [-1, 1].every(x => [-1, 1].every(z => [0, 2.6].every(y => {
          const p = new THREE.Vector3(cell.x + x * (cell.width / 2 + .08), y,
            cell.z + z * (cell.depth / 2 + .08)).project(camera)
          return Math.abs(p.x) < .91 && Math.abs(p.y) < .91 && p.z > -1 && p.z < 1
        })))
        if (fits) break
        camera.position.sub(anchor).multiplyScalar(1.045).add(anchor)
      }
    }
    controls.current?.update()
    previousScale.current = 1
  }, [camera, dist, target, view, resetKey, frontSign, cell])

  useEffect(() => {
    // Resize without resetting the user's orbit direction or relative zoom.
    const anchor = controls.current?.target ?? new THREE.Vector3(...target)
    camera.position.sub(anchor).multiplyScalar(framingScale / previousScale.current).add(anchor)
    previousScale.current = framingScale
    controls.current?.update()
  }, [camera, dist, target, view, framingScale, resetKey])

  return (
    <OrbitControls
      ref={controls}
      onStart={onInteraction}
      makeDefault
      // Both initial and explicit preset framing use this same layout target.
      target={target}
      minDistance={1.5}
      maxDistance={responsive ? Math.max(40, dist * framingScale * 2) : 40}
      maxPolarAngle={Math.PI / 2 - 0.03}
      enableDamping
      dampingFactor={0.08}
    />
  )
}

// ── Main scene ──────────────────────────────────────────────

/** Layout editing mode */
export type LayoutMode = 'off' | 'translate' | 'rotate' | 'scale'

export interface DeviceTransform {
  pos: [number, number, number]
  rot: number
  size: [number, number, number]
}

export interface Scene3DProps {
  presentationBounds?: {x:number;z:number;width:number;depth:number}
  labelDeviceIds?: string[]
  machine: LaidOutMachine
  plant: Plant
  selectedDevice: string | null
  onSelectDevice: (id: string | null) => void
  showLabels: boolean
  cameraView?: CameraView
  cameraResetKey?: number
  onCameraInteraction?: () => void
  responsiveFraming?: boolean
  lightTheme?: boolean
  layoutMode: LayoutMode
  onTransform: (deviceId: string, t: DeviceTransform) => void
}

function SceneContents({
  machine, plant, presentationBounds, selectedDevice, onSelectDevice, showLabels, labelDeviceIds, cameraView, cameraResetKey, onCameraInteraction, responsiveFraming, lightTheme, layoutMode, onTransform,
}: Scene3DProps) {
  const setEquipment=useReplaySelection()?.setEquipment
  const equipmentRoot=useRef<THREE.Group>(null)
  const frames=(plant as unknown as {frames?:unknown[]}).frames
  const travel=useMemo(()=>recordedTravelBounds(frames),[frames])
  const measured=useEquipmentBounds(equipmentRoot,machine,travel)
  const floor=useMemo(()=>measured?equipmentFloor(measured,presentationBounds):presentationBounds,[measured,presentationBounds])


  const groups = useRef(new Map<string, THREE.Group>())
  const [attached, setAttached] = useState<THREE.Group | null>(null)

  useEffect(() => {
    if (layoutMode === 'off' || !selectedDevice) {
      setAttached(null)
      return
    }
    setAttached(groups.current.get(selectedDevice) ?? null)
  }, [layoutMode, selectedDevice, machine])

  const [nameAnchor, setNameAnchor] = useState<DeviceNameAnchor | undefined>()
  const [compositeTargets,setCompositeTargets]=useState<EquipmentGroup[]>([])
  const labelTicks=useRef(0)
  useEffect(()=>{labelTicks.current=0;setCompositeTargets([])},[machine])
  useFrame(()=>{
    if(![3,8,12].includes(++labelTicks.current)&&labelTicks.current%30!==0)return
    const next:EquipmentGroup[]=[]
    for(const id of ['CELL','TAPE_CELL','MATERIAL_CELL']){
      const root=groups.current.get(id);if(root)next.push(...collectEquipmentGroups(root,id))
    }
    setCompositeTargets(previous=>previous.length===next.length&&previous.every((t,i)=>t.object===next[i].object&&t.name===next[i].name&&t.objects.length===next[i].objects.length&&t.objects.every((o,j)=>o===next[i].objects[j]))?previous:next)
  })
  useEffect(() => { if (!selectedDevice) setNameAnchor(undefined) }, [selectedDevice])
  const selected = machine.devices.find((d) => d.id === selectedDevice)
  const resolveDeviceObject=(id:string)=>{
    let marked:THREE.Object3D|undefined
    for(const root of groups.current.values())root.traverse(o=>{if(!marked&&o.userData.selectionDeviceId===id)marked=o})
    return marked??groups.current.get(id)
  }
  const activeAnchor = useMemo(() => {
    if (!selected) return undefined
    if(nameAnchor?.id===selected.id && machine.devices.some(d=>groups.current.get(d.id)?.getObjectById(nameAnchor.object.id))) return nameAnchor
    const primary=primaryDevice(selected,machine.devices)
    if (!primary) return undefined
    const object=resolveDeviceObject(primary.id)
    return object ? {id:primary.id,object,name:primary.label,above:selected.visualVariant==='v7-rack',objects:primary.members.length>1?primary.members.map(id=>groups.current.get(id)).filter((g):g is THREE.Group=>!!g):undefined} : undefined
  }, [selected, nameAnchor, machine])
  useEffect(()=>{
    if(!setEquipment)return
    const compositeIds=new Set(compositeTargets.map(t=>t.id))
    const rows=primaryDeviceList(machine.devices).filter(d=>!compositeIds.has(d.id)).map(d=>({
      key:d.id,id:d.id,name:primaryDevice(d,machine.devices)!.label,selected:selectedDevice===d.id,
      select:()=>{setNameAnchor(undefined);onSelectDevice(selectedDevice===d.id?null:d.id)},
    }))
    rows.push(...compositeTargets.map(t=>({
      key:t.object.uuid,id:t.id,name:t.name,poseId:t.object.userData.recordedPoseId as string|undefined,selected:activeAnchor?.object===t.object,
      select:()=>{const same=activeAnchor?.object===t.object;setNameAnchor(same?undefined:{id:t.id,name:t.name,object:t.object,objects:t.objects});onSelectDevice(same?null:t.id)},
    })))
    setEquipment(rows)
  },[machine,compositeTargets,selectedDevice,activeAnchor,onSelectDevice,setEquipment])
  useEffect(()=>()=>setEquipment?.([]),[machine,setEquipment])
  const hard15Scene = machine.devices.some(d=>d.visualVariant?.startsWith('cell3-'))
  const miniScene = machine.devices.some(d=>(d.visualVariant?.startsWith('cell3-mini-') || d.visualVariant?.startsWith('cell3-r8-') || d.visualVariant?.startsWith('cell3-r9-') || d.visualVariant?.startsWith('cell3-composable-')))


  const commit = useCallback(() => {
    if (!attached || !selected) return
    const size: [number, number, number] = [
      Math.max(0.02, selected.size[0] * attached.scale.x),
      Math.max(0.02, selected.size[1] * attached.scale.y),
      Math.max(0.02, selected.size[2] * attached.scale.z),
    ]
    onTransform(selected.id, {
      pos: [
        round(attached.position.x),
        round(attached.position.y),
        round(attached.position.z),
      ],
      rot: round(attached.rotation.y, 4),
      size: [round(size[0]), round(size[1]), round(size[2])],
    })

    attached.scale.set(1, 1, 1)
  }, [attached, selected, onTransform])

  return (
    <MaterialServiceScope plant={plant}>
      <Stage machine={machine} plant={plant} lightTheme={lightTheme} bounds={floor} />
      <MaterialRendererGuard machine={machine} />
      {lightTheme && <WorkshopReflections />}
      {measured?<EquipmentCamera bounds={measured} floor={floor} view={cameraView??'front'} front={equipmentFront(machine)} resetKey={cameraResetKey} onInteraction={onCameraInteraction}/>:<CameraRig machine={machine} view={cameraView??'front'} responsive={responsiveFraming} resetKey={cameraResetKey} onInteraction={onCameraInteraction} />}

      <group ref={equipmentRoot} name="replay-equipment">
        {machine.devices.filter(d=>d.visualVariant!=='hard-control-cabinet').map((d) => (
          <group
            key={d.id}
            name={`device-${d.id}`}
            position={d.pos}
            rotation={[0, d.rot, 0]}
            {...(d.replayQuaternion ? { quaternion: d.replayQuaternion } : {})}
            ref={(g) => {
              if (g) groups.current.set(d.id, g)
              else groups.current.delete(d.id)
            }}
            onClick={(e) => {
              if((e.nativeEvent.target as HTMLElement)?.closest?.('[data-device-label], [data-device-name]'))return
              e.stopPropagation()
              const composite=d.id==='CELL'||d.id==='TAPE_CELL'||d.id==='MATERIAL_CELL'
              let hit:THREE.Object3D|null=e.object
              while(!composite&&hit&&hit!==e.eventObject){
                if(structuralPart(hit.name)||structuralPart(hit.userData.deviceDisplayName??'')){setNameAnchor(undefined);onSelectDevice(null);return}
                if(hit.userData.selectionDeviceId||hit.userData.deviceDisplayName)break
                hit=hit.parent
              }
              const nameObject=composite?equipmentSelectionTarget(e.object,e.eventObject):undefined
              const targetDevice=nameObject?.userData.selectionDeviceId?machine.devices.find(item=>item.id===nameObject.userData.selectionDeviceId)??d:d
              const primary=primaryDevice(targetDevice,machine.devices)??(composite&&nameObject?{id:targetDevice.id,label:targetDevice.label,members:[targetDevice.id]}:undefined)
              if(!primary||(composite&&!nameObject)){setNameAnchor(undefined);onSelectDevice(null);return}
              const grouped=nameObject?compositeTargets.find(t=>t.objects.includes(nameObject)):undefined
              const name=grouped?.name??(composite?(nameObject!.userData.deviceDisplayName??equipmentPartName(nameObject!.name)??primary.label):primary.label)
              const object=grouped?.object??(composite?nameObject!:(resolveDeviceObject(primary.id)??e.eventObject))
              const same = selectedDevice === primary.id && (!nameAnchor || nameAnchor.object === object)
              setNameAnchor(same ? undefined : { id: primary.id, object, name, above:d.visualVariant==='v7-rack', objects: grouped?.objects??(primary.members.length > 1 ? primary.members.map(id=>groups.current.get(id)).filter((g):g is THREE.Group=>!!g) : undefined) })
              onSelectDevice(same ? null : primary.id)
            }}
          >
            <DeviceMesh device={d} plant={plant} detailed={lightTheme} />
            {selectedDevice === d.id && layoutMode !== 'off' && <SelectionBox device={d} />}
          </group>
        ))}
        <Parts plant={plant} />
        <PartOrientationMarkers plant={plant} />
      </group>

      {attached && layoutMode !== 'off' && (
        <TransformControls
          object={attached}
          mode={layoutMode}
          translationSnap={0.05}
          rotationSnap={Math.PI / 24}
          scaleSnap={0.05}
          onMouseUp={commit}
        />
      )}

      {selected && (activeAnchor||primaryDevice(selected,machine.devices)) && <DeviceNameBadge
        id={selected.id}
        name={activeAnchor?.name??selected.label}
        anchor={activeAnchor}
        position={[selected.pos[0], selected.pos[1] + selected.size[1] / 2 + .13, selected.pos[2]]}
      />}
      {showLabels&&compositeTargets.filter(t=>t.object!==activeAnchor?.object).map(t=><EquipmentLabel key={'composite-'+t.object.id} id={t.id+':'+t.object.id} name={t.name} resolve={()=>t.object} onSelect={()=>{setNameAnchor({id:t.id,name:t.name,object:t.object,objects:t.objects});onSelectDevice(t.id)}}/>)}
      {showLabels &&
        primaryDeviceList(machine.devices).map(d=>({...d,label:primaryDevice(d,machine.devices)!.label})).filter(d=>d.id !== selectedDevice).map((d) => (
          <DeviceLabel
            key={`l-${d.id}`}
            device={miniScene ? {...d,sceneLabelOffset:[0,.32,0] as [number,number,number]} : hard15Scene ? {...d,sceneLabelOffset:(/^ST\d{2}$/.test(d.id) ? [0,.24,-.40] : d.id==='TOOL' ? [.28,.2,0] : [0,.20,0]) as [number,number,number]} : d}
            plant={plant}
            resolveObject={()=>resolveDeviceObject(d.id)}
            selected={selectedDevice === d.id}
            onSelect={(id) => onSelectDevice(selectedDevice === id ? null : id)}
          />
        ))}
    </MaterialServiceScope>
  )
}

const round = (v: number, digits = 3): number => Number(v.toFixed(digits))


function SelectionBox({ device }: { device: DeviceSpec }) {
  const [w, h, d] = device.size
  return (
    <mesh raycast={() => null}>
      <boxGeometry args={[w * 1.08 + 0.06, h * 1.08 + 0.06, d * 1.08 + 0.06]} />
      <meshBasicMaterial color="#37b7f0" wireframe transparent opacity={0.45} />
    </mesh>
  )
}

export default function Scene3D(props: Scene3DProps) {
  const replaySelection=useReplaySelection()
  const Renderer = props.machine.replaySuite === 'material' || props.machine.devices.some(device => device.visualVariant === 'motion-hard-cell')
    ? MotionReplayCanvas : Canvas
  return (
    <Renderer
      shadows={{ type: THREE.PCFShadowMap }}
      dpr={[1, 2]}
      camera={{ fov: 42, near: 0.1, far: 200, position: [5, 4, 7] }}
      gl={{ antialias: true, toneMapping: THREE.ACESFilmicToneMapping }}



      resize={{ scroll: false, debounce: { scroll: 0, resize: 0 } }}
      onPointerMissed={event => {if((event.target as HTMLElement)?.closest?.('[data-device-label], [data-device-name]'))return;props.onSelectDevice(null)}}
    >
      <color attach="background" args={[props.lightTheme ? '#e4e9e8' : '#192432']} />
      <fog attach="fog" args={[props.lightTheme ? '#e4e9e8' : '#192432', 18, 42]} />
      <Suspense fallback={null}>
        <ReplaySelectionContext.Provider value={replaySelection}><SceneContents {...props} /></ReplaySelectionContext.Provider>
      </Suspense>
    </Renderer>
  )
}
