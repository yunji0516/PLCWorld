'use client'

import { useRef } from 'react'
import { useFrame } from '@react-three/fiber'
import { Group } from 'three'
import type { DeviceProps } from '../devices'
import type { MaterialHardState } from '@/lib/replay/adapter'
import { Part, RoundPart } from './Parts'

type V = [number, number, number]
type WindTape = NonNullable<MaterialHardState['wind_tape']>
type Reader = { materialHardState(): MaterialHardState | undefined }

function RecordedRoll({ reader, id }: { reader: Reader; id: number }) {
  const ref = useRef<Group>(null)
  useFrame(() => {
    const state = reader.materialHardState()
    const pose = state?.poses[`part${id}`]
    const group = ref.current
    if (!group) return
    group.visible = !!pose && state?.parts[String(id)]?.owner !== 'accepted'
    if (pose) {
      group.position.fromArray(pose.pos)
      const radius = Math.max(0.05, (state?.parts[String(id)] as { radius?: number })?.radius ?? 0.05)
      group.scale.set(radius, radius, 1)
    }
  })
  return <group ref={ref} name={`recorded-winding-roll-${id}`} userData={{selectionDisabled:true}}>
    <RoundPart position={[0, 0, 0]} radius={1} length={0.12} axis="z" color="#c79e60" />
    <RoundPart position={[0, 0, 0.07]} radius={0.36} length={0.015} axis="z" color="#5d7f8b" />
  </group>
}

function SourceRoll({ reader, side, at }: { reader: Reader; side: 'a' | 'b'; at: V }) {
  const ref = useRef<Group>(null)
  useFrame(() => {
    const physical = reader.materialHardState()?.wind_tape
    const group = ref.current
    if (!physical || !group) return
    const radius = side === 'a' ? physical.source_a_radius : physical.source_b_radius
    group.scale.set(Math.max(radius, 0.005), Math.max(radius, 0.005), 1)
  })
  return <group position={at} userData={{deviceDisplayName:`Supply reel ${side.toUpperCase()}`}}>
    <Part name="reel-support-column" position={[0, -0.37, 0]} size={[0.10, 0.72, 0.10]} color="#406275" />
    <group ref={ref} position={[0, 0, 0]}>
      <RoundPart position={[0, 0, 0]} radius={1} length={0.12} axis="z" color={side === 'a' ? '#c2a56d' : '#91aab2'} />
    </group>
  </group>
}

function WebSpan({ reader, side }: { reader: Reader; side: 'a' | 'b' }) {
  const ref = useRef<Group>(null)
  useFrame(() => {
    const physical = reader.materialHardState()?.wind_tape
    const path = side === 'a' ? physical?.source_a_path : physical?.source_b_path
    const group = ref.current
    if (!path || path.length < 2 || !group) return
    const a = path[0], b = path[path.length - 1]
    group.position.set((a[0] + b[0]) / 2, (a[1] + b[1]) / 2, side === 'a' ? -0.10 : 0.10)
    group.rotation.z = Math.atan2(b[1] - a[1], b[0] - a[0])
    group.scale.x = Math.hypot(b[0] - a[0], b[1] - a[1])
  })
  return <group ref={ref}><Part position={[0, 0, 0]} size={[1, 0.006, 0.08]} color={side === 'a' ? '#c2a56d' : '#91aab2'} /></group>
}

function MovingTool({ reader, field, color, size }: { reader: Reader; field: keyof WindTape; color: string; size: V }) {
  const ref = useRef<Group>(null)
  useFrame(() => {
    const physical = reader.materialHardState()?.wind_tape
    const group = ref.current
    if (!physical || !group) return
    const value = physical[field]
    if (Array.isArray(value) && value.length === 3) group.position.fromArray(value as V)
  })
  return <group ref={ref} userData={{deviceDisplayName:field.replace(/_/g,' ')}}><Part position={[0, 0, 0]} size={size} color={color} /></group>
}

export function MaterialWindTapeHardware({ plant }: DeviceProps) {
  const reader = plant as unknown as Reader
  return <group name="final-evaluator-winding-cell">
    <Part position={[0.25, 0.73, 0.22]} size={[2.2, 0.10, 1.8]} color="#425b68" />
    <Part position={[0.25, 0.39, 0.22]} size={[2.1, 0.62, 1.7]} color="#728794" />
    <SourceRoll reader={reader} side="a" at={[-0.55, 1.25, -0.10]} />
    <SourceRoll reader={reader} side="b" at={[-0.55, 0.70, 0.10]} />
    <WebSpan reader={reader} side="a" />
    <WebSpan reader={reader} side="b" />
    <Part position={[0.18, 0.97, 0]} size={[0.07, 0.36, 0.35]} color="#9aabb3" />
    <Part position={[0.45, 0.80, 0]} size={[0.35, 0.10, 0.36]} color="#587b8c" />
    <Part position={[0.45, 1.06, 0]} size={[0.18, 0.08, 0.15]} color="#b9c5c9" />
    {[1, 2, 3].map(id => <RecordedRoll key={id} reader={reader} id={id} />)}
    <Part position={[0.45, 0.84, 1.17]} size={[0.22, 0.08, 0.62]} color="#718c94" />
    <Part position={[0.90, 1.37, 0.18]} size={[0.28, 0.09, 0.55]} color="#476f80" />
    <MovingTool reader={reader} field="tape_head" color="#d0a56b" size={[0.11, 0.09, 0.12]} />
    <Part position={[0.82, 0.85, -0.62]} size={[0.60, 0.08, 0.34]} color="#859da5" />
  </group>
}
