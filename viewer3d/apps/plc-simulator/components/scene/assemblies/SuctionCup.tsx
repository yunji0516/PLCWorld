import { useEffect, useMemo } from 'react'
import { suctionCupGeometry, SUCTION_FINISH } from './suctionHeadGeometry'

/** Shared appearance; each task retains its cup count, size and contact pose. */
export function SuctionCup({position,radius,height,name='vacuum-sealing-cup'}:{position:[number,number,number];radius:number;height:number;name?:string}) {
  const geometry=useMemo(()=>suctionCupGeometry(radius,height),[radius,height])
  useEffect(()=>()=>geometry.dispose(),[geometry])
  return <mesh name={name} position={position} castShadow receiveShadow>
    <primitive object={geometry} attach="geometry"/>
    <meshStandardMaterial {...SUCTION_FINISH[0]}/>
  </mesh>
}
