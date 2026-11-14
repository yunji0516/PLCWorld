'use client'

import { useFrame } from '@react-three/fiber'
import { useRef } from 'react'
import type { Group } from 'three'
import type { DeviceProps } from '../devices'

/** Dedicated Z axis for the local vent-and-withdraw contract. The tool and its
 * cantilever use canonical world poses; this carriage follows the same Z state. */
export function VacuumMast({ device, plant }: DeviceProps) {
  const carriage = useRef<Group>(null)
  useFrame(() => {
    if (carriage.current) carriage.current.position.y = .210 + .600 * plant.state(device.id).pos
  })
  const box = (name: string, position: [number,number,number], size: [number,number,number], color='#6b7d8d') =>
    <mesh key={name} name={name} position={position} castShadow receiveShadow>
      <boxGeometry args={size}/><meshStandardMaterial color={color} metalness={.65} roughness={.38}/>
    </mesh>
  return <group name="vacuum-dedicated-mast">
    {box('vacuum-mast-foot',[0,-.985,0],[.48,.08,.14],'#304956')}
    {[-.17,.17].map((x,i)=>box(`vacuum-mast-column-${i}`,[x,0,0],[.065,1.89,.10]))}
    {box('vacuum-mast-top',[0,.985,0],[.48,.08,.14],'#304956')}
    {box('vacuum-mast-motor',[0,.88,-.01],[.11,.12,.11],'#167d83')}
    <mesh name="vacuum-mast-screw" position={[0,.2,.025]} castShadow>
      <cylinderGeometry args={[.012,.012,1.22,20]}/><meshStandardMaterial color="#c4cbd1" metalness={.8} roughness={.3}/>
    </mesh>
    <group ref={carriage} name="vacuum-mast-carriage">
      {box('vacuum-mast-crosshead',[0,0,.025],[.38,.10,.09])}
      {[-.17,.17].map((x,i)=>box(`vacuum-mast-bearing-${i}`,[x,0,0],[.09,.13,.125],'#167d83'))}
    </group>
  </group>
}
