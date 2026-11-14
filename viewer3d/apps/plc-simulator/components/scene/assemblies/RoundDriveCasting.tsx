'use client'
import {useMemo,useEffect} from 'react'
import {LatheGeometry,Vector2} from 'three'
import {SocketBolt} from '../IndustrialDetails'
import {FINISH} from './Parts'
/** Curved access panel seats on the cylindrical casting, not on a tangent box. */
export function RoundDriveCasting({bottom,top,radius:r}:{bottom:number;top:number;radius:number}){
 const h=top-bottom,y=(top+bottom)/2
 const geometries=useMemo(()=>{
  const body=new LatheGeometry([[0,bottom],[r-.015,bottom],[r,bottom+.02],[r,top-.02],[r-.015,top],[0,top]].map(p=>new Vector2(...p as [number,number])),64)
  const panel=new LatheGeometry([[r,y-h*.29],[r+.008,y-h*.29],[r+.008,y+h*.29],[r,y+h*.29],[r,y-h*.29]].map(p=>new Vector2(...p as [number,number])),24,-.48,.96)
  return [body,panel]
 },[bottom,top,r,h,y])
 useEffect(()=>()=>geometries.forEach(g=>g.dispose()),[geometries])
 return <group name="round-drive-casting">
  <mesh geometry={geometries[0]} castShadow receiveShadow><meshStandardMaterial color={FINISH.alloy} roughness={.62} metalness={.35}/></mesh>
  <mesh geometry={geometries[1]} castShadow><meshStandardMaterial color={FINISH.blue} roughness={.65} metalness={.25}/></mesh>
  {[-1,1].flatMap(a=>[-1,1].map(b=><group key={`${a}:${b}`} position={[(r+.009)*Math.sin(a*.34),y+b*h*.22,(r+.009)*Math.cos(a*.34)]} rotation={[0,a*.34,0]}><SocketBolt position={[0,0,0]} radius={.005}/></group>))}
 </group>
}
