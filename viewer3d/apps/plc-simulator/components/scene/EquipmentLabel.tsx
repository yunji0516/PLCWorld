'use client'
import {Html} from '@react-three/drei'
import {useFrame} from '@react-three/fiber'
import {useRef} from 'react'
import {Group,type Object3D} from 'three'
import {deviceBadgePosition} from './deviceSelection'
import {deviceDisplayName} from '@/lib/replay/deviceDisplayName'
export function EquipmentLabel({id,name,resolve,position=[0,0,0],onSelect}:{id:string;name:string;resolve?:()=>Object3D|undefined|null;position?:[number,number,number];onSelect:()=>void}){
 const ref=useRef<Group>(null)
 useFrame(()=>{const object=resolve?.();if(ref.current&&object){deviceBadgePosition(object,ref.current.position,undefined,true);ref.current.parent?.worldToLocal(ref.current.position)}})
 return <group ref={ref} position={position}><Html center zIndexRange={[10,0]} style={{pointerEvents:'none'}}><button type="button" data-device-label={id} onPointerDown={e=>e.stopPropagation()} onClick={e=>{e.stopPropagation();onSelect()}} style={{pointerEvents:'auto',whiteSpace:'nowrap',border:'1px solid #b9cbd1',background:'rgba(247,250,251,.94)',color:'#264b5a',padding:'3px 6px',fontSize:10,borderRadius:4,cursor:'pointer'}}>{deviceDisplayName(name)}</button></Html></group>
}
