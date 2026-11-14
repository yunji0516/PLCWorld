import { useRef } from 'react'
import { useFrame } from '@react-three/fiber'
import type { Group } from 'three'
import type { Plant } from '@/lib/machine/plant'
import { Part } from './Parts'

/** 600 x 140 x 640 mm synthetic pallet; two genuinely open fork pockets. */
export function SlottedPallet({ id, plant, compact = false }: { id: number; plant: Plant; compact?: boolean }) {
  const root = useRef<Group>(null)
  useFrame(() => {
    const p = plant.parts.find(p => p.id === id)
    if (p && root.current) root.current.position.set(p.x, p.y ?? .67, p.z ?? 0)
  })
  if (compact) return <group ref={root} name={`rack-load-pallet-${id}`}>
    <Part name="load-pallet-top-deck" size={[.40,.02,.36]} position={[0,.05,0]} color="#b89a70" radius={.002}/>
    {[-.175,0,.175].map(x=><group key={x}>
      <Part name="load-pallet-runner" size={[.035,.02,.36]} position={[x,-.05,0]} color="#94764f" radius={.002}/>
      {[-.14,.14].map(z=><Part key={z} name="load-pallet-spacer" size={[.035,.08,.06]} position={[x,0,z]} color="#ad895c" radius={.002}/>)}
    </group>)}
    {[-1,1].map(s=><Part key={s} name="load-pallet-locator" size={[.018,.016,.16]} position={[s*.092,.068,0]} color="#48515b" radius={.002}/>)}
  </group>
  return <group ref={root} name={`slotted-pallet-${id}`}>
    <Part name="pallet-top-deck" size={[.60, .025, .64]} position={[0, .0575, 0]} color="#c4a372" radius={.002}/>
    {[-.25, 0, .25].map(x => <group key={x}>
      <Part name="pallet-bottom-runner" size={[.08, .025, .64]} position={[x, -.0575, 0]} color="#a68758" radius={.002}/>
      {[-.26, 0, .26].map(z => <Part key={z} name="pallet-spacer-block" size={[.08, .09, .10]} position={[x, 0, z]} color="#b08e60" radius={.002}/>)}
    </group>)}
  </group>
}
