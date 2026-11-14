'use client'

import {useReplaySelection} from '@/app/replay/ReplaySelection'
import { Html } from '@react-three/drei'
import { useFrame } from '@react-three/fiber'
import { useEffect, useRef } from 'react'
import { Box3, Group, Object3D } from 'three'
import { deviceBadgePosition, equipmentGroupBadgePosition, highlightDevice } from './deviceSelection'
import { deviceDisplayName } from '@/lib/replay/deviceDisplayName'

export type DeviceNameAnchor = { id: string; object: Object3D; name: string; objects?: Object3D[]; above?: boolean }

/** The Material H02 click badge, shared by both replay renderers. */
export function DeviceNameBadge({ id, name, position, anchor }: {
  id: string; name: string; position?: [number, number, number]; anchor?: DeviceNameAnchor
}) {
  const context=useReplaySelection(),setSelection=context?.setSelection
  useEffect(()=>{
    setSelection?.(old=>old?.id===id&&old.name===name?old:{id,name})
    return ()=>setSelection?.(old=>old?.id===id&&old.name===name?null:old)
  },[id,name,setSelection])
  const ref = useRef<Group>(null)
  const bounds = useRef(new Box3())
  useEffect(() => {
    if (!anchor) return
    const restores=(anchor.objects??[anchor.object]).map(highlightDevice)
    return ()=>restores.forEach(restore=>restore())
  }, [anchor?.object, anchor?.objects])
  useFrame(() => {
    if (!anchor || !ref.current) return
    if(anchor.objects?.length)equipmentGroupBadgePosition(anchor.objects,ref.current.position,bounds.current,anchor.above)
    else deviceBadgePosition(anchor.object, ref.current.position, bounds.current, anchor.above)
    ref.current.parent?.worldToLocal(ref.current.position)
  })
  return <group ref={ref} position={position}>
    <Html center zIndexRange={[20, 0]} style={{ pointerEvents: 'none' }}>
      <span data-device-name={id} style={{ display: 'block', whiteSpace: 'nowrap', background: '#142a37', color: 'white', padding: '5px 9px', fontSize: 11, borderRadius: 5 }}>
        {deviceDisplayName(name)}
      </span>
    </Html>
  </group>
}
