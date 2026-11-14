import { useEffect, useMemo } from 'react'
import { SocketBolt } from '../IndustrialDetails'
import { satinFinish } from '../surfaceFinish'
import { liftDeckGeometry, sleeveGeometry, slideBodyDimensions } from './transportGeometry'
import { BoredPlate, FINISH, Part } from './Parts'

export function GuideSleeve({ position, height, square = false }: { position: [number, number, number]; height: number; square?: boolean }) {
  const geometry = useMemo(() => sleeveGeometry(square ? .0475 : .042, square ? .0335 : .026, height, square), [square, height])
  useEffect(() => () => geometry.dispose(), [geometry])
  return <mesh name={square ? 'lift-profile-shoe' : 'slide-linear-bearing'} position={position} castShadow receiveShadow>
    <primitive object={geometry} attach="geometry" />
    <meshStandardMaterial color={FINISH.dark} {...satinFinish(.7, .6)} />
  </mesh>
}

export function SlideCarriageBody({ width, depth }: { width: number; depth: number }) {
  const g = slideBodyDimensions(depth)
  return <group name="assembly-slide-carriage-v2">
    <group position={[0, 0, g.centerZ]} rotation={[Math.PI / 2, 0, 0]}>
      <BoredPlate name="slide-bored-carriage" size={[width * .82, g.depth, g.bodyHeight]} position={[0, 0, 0]}
        holes={[-1, 1].map(s => ({ x: s * width * .27, y: -g.centerZ, radius: .030 }))} corner={.009} />
    </group>
    {[-1, 1].flatMap(side => [-1, 1].map(end => <GuideSleeve key={`${side}:${end}`}
      position={[side * width * .27, end * .085, 0]} height={.03} />))}
    {[-1, 1].map(side => <group key={side}>
      <SocketBolt position={[side * width * .32, .045, g.front + .002]} radius={.009} />
      <SocketBolt position={[side * width * .32, -.045, g.front + .002]} radius={.009} />
    </group>)}
  </group>
}

export function SlideEndCap({ width, depth, y }: { width: number; depth: number; y: number }) {
  return <group name="slide-guide-endcap" position={[0, y, 0]}>
    <group rotation={[Math.PI / 2, 0, 0]}>
      <BoredPlate name="slide-guide-support" size={[width * .78, depth * .32, .08]} position={[0, 0, 0]}
        holes={[-1, 1].map(s => ({ x: s * width * .27, y: 0, radius: .0255 }))} corner={.009} />
    </group>
    {[-1, 1].map(side => <SocketBolt key={side} position={[side * width * .14, .041, 0]} radius={.007} top />)}
  </group>
}

export function LiftLoadDeck({ width, depth, color }: { width: number; depth: number; color: string }) {
  const geometry = useMemo(() => liftDeckGeometry(width, depth), [width, depth])
  useEffect(() => () => geometry.dispose(), [geometry])
  return <group name="assembly-lift-deck-v2">
    <mesh name="lift-relieved-load-plate" castShadow receiveShadow>
      <primitive object={geometry} attach="geometry" />
      <meshStandardMaterial color={color} {...satinFinish(.65, .65)} />
    </mesh>
    {[-1, 1].map(side => <group key={side}>
      <GuideSleeve position={[side * (width / 2 - .05), -.0475, -depth / 2 + .05]} height={.025} square />
      <SocketBolt position={[side * width * .34, .037, depth * .3]} radius={.012} top />
      <SocketBolt position={[side * width * .34, .037, -depth * .3]} radius={.012} top />
    </group>)}
    <Part name="lift-deck-stiffener" size={[width * .60, .022, .045]} position={[0, -.046, depth * .14]} color={FINISH.steel} />
  </group>
}
