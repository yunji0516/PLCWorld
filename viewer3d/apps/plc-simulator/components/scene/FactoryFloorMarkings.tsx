import { useMemo } from 'react'
import * as THREE from 'three'
import type { DeviceSpec } from '@/lib/machine/infer'
import { factoryCellBounds, materialHardCellBounds, operatorBandZ } from './factoryFloor'

/** Flat paint, no raised blocks; never intercept device selection. */
export function FactoryFloorMarkings({ devices, title, frontSign = 1, bounds, outline, bandPosition }: { devices: DeviceSpec[]; title?: string; frontSign?: 1 | -1; bounds?: ReturnType<typeof factoryCellBounds>; outline?: [number,number][]; bandPosition?: [number,number] }) {
  const cell = useMemo(() => bounds ?? materialHardCellBounds(title) ?? factoryCellBounds(devices), [bounds, devices, title])
  const bandWidth = Math.min(2.1, cell.width - .6)
  const bandDepth = .22
  const uniforms = useMemo(() => ({
    extent: { value: new THREE.Vector2(bandWidth, bandDepth) },
    yellow: { value: new THREE.Color('#f5bf24') },
    charcoal: { value: new THREE.Color('#27313b') },
  }), [bandWidth])
  const t = .085
  return <group name="factory-floor-markings" position={[cell.x, .008, cell.z]}>
    {outline?outline.map((a,i)=>{const b=outline[(i+1)%outline.length],dx=b[0]-a[0],dz=b[1]-a[1];return <group key={i} position={[(a[0]+b[0])/2-cell.x,0,(a[1]+b[1])/2-cell.z]} rotation={[0,-Math.atan2(dz,dx),0]}><mesh rotation={[-Math.PI/2,0,0]} raycast={()=>null}><planeGeometry args={[Math.hypot(dx,dz)+t,t]}/><meshBasicMaterial color="#efb923" toneMapped={false}/></mesh></group>}) : [-1, 1].map(side => <group key={side}>
      <mesh rotation={[-Math.PI / 2, 0, 0]} position={[0, 0, side * cell.depth / 2]} raycast={() => null}>
        <planeGeometry args={[cell.width + t, t]} />
        <meshBasicMaterial color="#efb923" toneMapped={false} />
      </mesh>
      <mesh rotation={[-Math.PI / 2, 0, 0]} position={[side * cell.width / 2, 0, 0]} raycast={() => null}>
        <planeGeometry args={[t, cell.depth - t]} />
        <meshBasicMaterial color="#efb923" toneMapped={false} />
      </mesh>
    </group>)}
    {/* A single painted keep-clear strip on the operator side of the cell. */}
    <mesh name="factory-operator-hazard-band" rotation={[-Math.PI / 2, 0, 0]} position={bandPosition?[bandPosition[0]-cell.x,0,bandPosition[1]-cell.z]:[0, 0, operatorBandZ(cell.depth, frontSign)]} raycast={() => null}>
      <planeGeometry args={[bandWidth, bandDepth]} />
      <shaderMaterial uniforms={uniforms} toneMapped={false}
        vertexShader={`varying vec2 paintUv;
          void main() { paintUv = uv; gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0); }`}
        fragmentShader={`varying vec2 paintUv; uniform vec2 extent; uniform vec3 yellow; uniform vec3 charcoal;
          void main() {
            float phase = (paintUv.x * extent.x + paintUv.y * extent.y) / .28;
            float stripe = sin(phase * 6.2831853);
            float aa = max(fwidth(phase) * 6.2831853, .01);
            gl_FragColor = vec4(mix(yellow, charcoal, smoothstep(-aa, aa, stripe)), 1.0);
            #include <colorspace_fragment>
          }`} />
    </mesh>
  </group>
}
