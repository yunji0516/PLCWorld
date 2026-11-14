'use client'
import { createContext, type ReactNode } from 'react'
import { useThree } from '@react-three/fiber'
import type { Plant } from '@/lib/machine/plant'

export const EssentialMaterialServices = createContext(false)
/** Show connections only when they explain the new20 task's material operation. */
export function MaterialServiceScope({plant,children}:{plant:Plant;children:ReactNode}){
 const {scene}=useThree()
 scene.userData.materialServicePlant=plant
 const essentialOnly=plant.machine.replaySuite==='material'&&/^MAT-V(?:6-D(?:01|03|04|06|10)|7-D1[1-5]|8-D(?:1[6-9]|2[0-5]))/.test(plant.machine.title)
 return <EssentialMaterialServices.Provider value={essentialOnly}>{children}</EssentialMaterialServices.Provider>
}
