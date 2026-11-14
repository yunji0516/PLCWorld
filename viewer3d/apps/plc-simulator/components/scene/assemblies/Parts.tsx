import {MotionStructuralGeometry,isMotionProfile} from './MotionStructuralGeometry'
import {motionEquipmentColor} from './motionEquipmentFinish'
import {useMaterialMediumFinish,mediumStructureFinish} from './MaterialMediumFinish'
import {useMotionRealism,MotionBoxFittings,MotionBearingFittings} from './MotionRealism'
import { useEffect, useMemo, type ReactNode } from 'react'
import { MachinedBoxGeometry } from '../IndustrialDetails'
import { satinFinish } from '../surfaceFinish'
import { boredPlate } from './geometry'
import { Color, ExtrudeGeometry, Shape } from 'three'
import {TABLE_FINISH,tablePartRole} from './tableFinish'
import {useIndexEquipmentColor,useIndustrialSurface} from './IndexEquipmentPalette'

/** Right-angle web fits below a beam and beside a post, without filling the travel opening. */
export function CornerWeb({ position, span, side = 1 }: { position: Vector; span: number; side?: number }) {
  const geometry = useMemo(() => {
    const shape = new Shape()
    shape.moveTo(0, 0); shape.lineTo(span, 0); shape.lineTo(0, -span); shape.closePath()
    const g = new ExtrudeGeometry(shape, { depth: .012, bevelEnabled: false })
    g.translate(0, 0, -.006)
    return g
  }, [span])
  useEffect(() => () => geometry.dispose(), [geometry])
  return <mesh name="mount-corner-web" position={position} rotation={[0, side < 0 ? Math.PI : 0, 0]} castShadow>
    <primitive object={geometry} attach="geometry" />
    <meshStandardMaterial color={FINISH.steel} {...satinFinish(.64, .65)} />
  </mesh>
}

export const FINISH = { alloy: '#a3afb9', steel: '#7f8f9c', dark: '#35434e', seal: '#202b32', blue: '#50768e' }
type Vector = [number, number, number]

export function Part({ name, size, position = [0, 0, 0], color = FINISH.alloy, radius, children, brightness = 1, matte = false }: {
  name?: string; size: Vector; position?: Vector; color?: string; radius?: number; children?: ReactNode; brightness?: number; matte?: boolean
}) {
  const medium=useMaterialMediumFinish()
  const realism=useMotionRealism()
  const sourceColor=realism?motionEquipmentColor(name??'',color):color
  const baseColor=medium?mediumStructureFinish(name,size,position,sourceColor):sourceColor
  const finish=useIndexEquipmentColor(baseColor)
  const surface=useIndustrialSurface(baseColor)
  const role=tablePartRole(name)
  const toned=useMemo(()=>role?new Color(TABLE_FINISH[role]):new Color(finish).multiplyScalar(brightness),[finish,brightness,role])
  return <mesh name={name} position={position} castShadow receiveShadow>
    {realism&&isMotionProfile(name??'',size)?<MotionStructuralGeometry size={size}/>:<MachinedBoxGeometry args={size} detailed radius={radius} />}
    <meshStandardMaterial color={toned} {...satinFinish(.64, .65)} {...surface} {...((matte||role)?{metalness:TABLE_FINISH.metalness,roughness:TABLE_FINISH.roughness,envMapIntensity:TABLE_FINISH.envMapIntensity}:{})}/>
    {realism&&<MotionBoxFittings name={name} size={size}/>}
    {children}
  </mesh>
}

export function BoredPlate({ name, size, position, corner = .01, holes, color = FINISH.alloy }: {
  name: string; size: Vector; position: Vector; corner?: number
  holes?: { x: number; y: number; radius: number }[]; color?: string
}) {
  const [w, h, d] = size
  const finish=useIndexEquipmentColor(color)
  const surface=useIndustrialSurface(color)
  const key = JSON.stringify(holes ?? [])
  const geometry = useMemo(() => boredPlate(w, h, d, corner, JSON.parse(key)), [w, h, d, corner, key])
  useEffect(() => () => geometry.dispose(), [geometry])
  return <mesh name={name} position={position} castShadow receiveShadow>
    <primitive object={geometry} attach="geometry" />
    <meshStandardMaterial color={finish} {...satinFinish(.64, .65)} {...surface}/>
  </mesh>
}

export function RoundPart({ name, position, radius, length, axis = 'z', color = FINISH.steel, segments = 32, matte=false }: {
  name?: string; position: Vector; radius: number; length: number; axis?: 'x' | 'y' | 'z'; color?: string; segments?: number; matte?:boolean
}) {
  const realism=useMotionRealism()
  const baseColor=realism?motionEquipmentColor(name??'',color):color
  const finish=useIndexEquipmentColor(baseColor)
  const surface=useIndustrialSurface(baseColor)
  return <mesh name={name} position={position} rotation={axis === 'z' ? [Math.PI / 2, 0, 0] : axis === 'x' ? [0, 0, Math.PI / 2] : [0, 0, 0]} castShadow>
    <cylinderGeometry args={[radius, radius, length, segments]} />
    <meshStandardMaterial color={finish} {...satinFinish(.64, .65)} {...surface} {...(matte?{roughness:.88,metalness:.18,envMapIntensity:.25}:{})}/>
    {realism&&<MotionBearingFittings name={name} radius={radius} length={length}/>}
  </mesh>
}
