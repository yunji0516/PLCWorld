'use client'
import {useEffect,useMemo,useRef,useState,type RefObject} from 'react'
import {useFrame} from '@react-three/fiber'
import type {Group} from 'three'
import {visibleEquipmentBounds,mergeEquipmentBounds,type EquipmentBounds} from './equipmentFraming'
/** Settle after child pose effects. A scrub must not move the floor or reset an orbit. */
export function useEquipmentBounds(root:RefObject<Group|null>,identity:unknown,seed?:EquipmentBounds){
 const [measured,setMeasured]=useState<EquipmentBounds|undefined>(),epoch=useRef({identity,ticks:0})
 useEffect(()=>{epoch.current={identity,ticks:0};setMeasured(undefined)},[identity])
 useFrame(()=>{
  const e=epoch.current;if(e.identity!==identity||++e.ticks>12||![3,8,12].includes(e.ticks)||!root.current)return
  const b=visibleEquipmentBounds(root.current)
  if(b)setMeasured(old=>JSON.stringify(old)===JSON.stringify(b)?old:b)
 })
 return useMemo(()=>mergeEquipmentBounds(seed,measured),[seed,measured])
}
