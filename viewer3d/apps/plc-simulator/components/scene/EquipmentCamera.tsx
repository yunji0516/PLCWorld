'use client'
import {useEffect,useRef} from 'react'
import {useThree} from '@react-three/fiber'
import {OrbitControls} from '@react-three/drei'
import type {PerspectiveCamera} from 'three'
import {fitEquipment,type EquipmentBounds,type FloorEnvelope,type FramingView} from './equipmentFraming'

export function EquipmentCamera({bounds,floor,view='front',front=1,resetKey=0,onInteraction}:{bounds:EquipmentBounds;floor?:FloorEnvelope;view?:FramingView;front?:1|-1;resetKey?:number;onInteraction?:()=>void}){
 const {camera,size,scene}=useThree(),controls=useRef<any>(null),fitted=useRef(4)
 const previous=useRef<{bounds:EquipmentBounds;floor?:FloorEnvelope;view:FramingView;front:number;resetKey:number}|undefined>(undefined)
 useEffect(()=>{
  const prior=previous.current
  const resizeOnly=prior&&prior.bounds===bounds&&prior.floor===floor&&prior.view===view&&prior.front===front&&prior.resetKey===resetKey
  const target=controls.current?.target.clone()
  const direction=target?camera.position.clone().sub(target):undefined
  const zoom=resizeOnly&&direction?direction.length()/fitted.current:1
  const result=fitEquipment(camera as PerspectiveCamera,bounds,floor,view,front,resizeOnly&&target&&direction?{target,direction}:undefined)
  if(resizeOnly&&direction)camera.position.copy(result.target).addScaledVector(direction.normalize(),result.distance*zoom)
  controls.current?.target.copy(result.target);controls.current?.update();fitted.current=result.distance
  const fog=scene.fog as {near?:number;far?:number}|null
  if(fog&&'near' in fog){fog.near=Math.max(18,result.distance*1.7);fog.far=Math.max(42,result.distance*4)}
  camera.far=Math.max(200,result.distance*6);camera.updateProjectionMatrix()
  previous.current={bounds,floor,view,front,resetKey}
 },[camera,bounds,floor,view,front,resetKey,size.width,size.height])
 return <OrbitControls ref={controls} makeDefault onStart={onInteraction} minDistance={.5} maxDistance={Math.max(80,fitted.current*4)} maxPolarAngle={Math.PI/2-.03} enableDamping dampingFactor={.08}/>
}
