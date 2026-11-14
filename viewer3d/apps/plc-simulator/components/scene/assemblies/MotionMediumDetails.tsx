'use client'
import {FittedMaterialDrive} from './FittedMaterialDrive'

import { useRef, type ReactNode } from 'react'
import { useFrame } from '@react-three/fiber'
import type { Group } from 'three'
import type { Frame } from '@/lib/replay/adapter'
import type { DeviceProps } from '../devices'
import { FINISH, Part, RoundPart } from './Parts'
import { counterbalanceLayout } from './counterbalanceLayout'

type State = NonNullable<NonNullable<Frame['world']>['motion_medium']>
type Reader = { motionState(): State | undefined; motionHardInstance?(): boolean; motionEasyMode?(): string | undefined }
type Vector = [number, number, number]
const AMBER = '#d7a33f', TEAL = '#238d88'
const MODES = new Set(['reference', 'registration', 'brake', 'velocity_capture', 'gear', 'index_pin', 'counterbalance', 'hexapod'])

/** Visual attachments and reference markings only. Every moving part follows recorded feedback. */
function Follow({ reader, name, pose, children }: {
  reader: Reader; name: string; pose: (state: State, group: Group) => void; children: ReactNode
}) {
  const ref = useRef<Group>(null)
  useFrame(() => { const state = reader.motionState(); if (state && ref.current) pose(state, ref.current) })
  return <group name={name} ref={ref}>{children}</group>
}

function Recorded({ reader, node, children }: { reader: Reader; node: string; children: ReactNode }) {
  return <Follow reader={reader} name={'motion-detail-recorded-' + node} pose={(s, g) => {
    const p = s.mechanism?.poses[node]
    if (p) { g.position.fromArray(p.pos); g.quaternion.fromArray(p.quaternion); g.scale.fromArray(p.scale ?? [1, 1, 1]) }
  }}>{children}</Follow>
}

function Tag({ position, children, color = TEAL }: { position: Vector; children: ReactNode; color?: string }) {
  // Device selection owns labels, as in Material. Avoid permanent floating callouts.
  return null
}

/** Engraved scale on a fixed frame; no additional encoder or optical sensor. */
function Ruler({ length = 2, width = .07, position = [0, 0, 0] }: { length?: number; width?: number; position?: Vector }) {
  const count = Math.round(length / .05)
  return <group name="motion-detail-engraved-scale" position={position}>
    <Part size={[length + .04, .014, width]} color={FINISH.alloy} radius={.001} />
    {Array.from({ length: count + 1 }, (_, k) => <Part key={k} name="scale-engraving" position={[-length / 2 + k * length / count, .0075, width / 2 - .02]} size={[.002, .001, k % 2 ? .018 : .038]} color={FINISH.dark} radius={.0001} />)}
  </group>
}

function Arch({ x, color = FINISH.blue }: { x: number; color?: string }) {
  return <group name="motion-detail-open-reference-frame" position={[x, 0, 0]}>
    {[-1, 1].map(k => <group key={k}>
      <Part name="reference-frame-foot" position={[0, .315, k * .34]} size={[.19, .03, .095]} color={FINISH.dark} />
      <Part name="reference-frame-post" position={[0, .64, k * .35]} size={[.045, .62, .04]} color={color} />
    </group>)}
    <Part name="reference-frame-crossbar" position={[0, .96, 0]} size={[.055, .035, .74]} color={color} />
  </group>
}

function LinearBed({ reader, mode, probe }: { reader: Reader; mode: string; probe: number }) {
  const initial = reader.motionState()!
  const axis = initial.axes.s
  const home = mode === 'reference'
  const speed = mode === 'velocity_capture'
  const target = axis.target_mm! / 1000
  const start = Number(initial.diagnostics?.window_start ?? 0) / 1000
  const end = Number(initial.diagnostics?.window_end ?? 0) / 1000
  // Coordinates are local to BASE (world Y .30). Open posts remain outside the rail and dog sweep.
  return <group name={'motion-detail-linear-' + mode}>
    <Ruler position={[0, .42, -.36]} />
    {[-.8, 0, .8].map(x => <Part key={x} name="scale-mount-standoff" position={[x, .36, -.36]} size={[.025, .11, .025]} color={FINISH.dark} />)}
    {speed ? <>
      <Arch x={start} color={TEAL} /><Arch x={end} color={TEAL} />
      {[-1, 1].map(k => <Part key={k} name="speed-zone-side-rail" position={[(start + end) / 2, .80, k * .35]} size={[end - start, .025, .025]} color={TEAL} />)}
      <Part name="speed-zone-floor-band" position={[(start + end) / 2, .315, -.35]} size={[end - start, .005, .065]} color={TEAL} />
      <Tag position={[(start + end) / 2, 1.08, 0]}>Speed holding zone</Tag>
    </> : <>
      <Arch x={probe - .08} />
      <Tag position={[probe, 1.08, 0]}>{home ? 'Coordinate datum' : 'Mark capture'}</Tag>
    </>}
    <Arch x={target} color={FINISH.dark} />
    <Part name="work-position-index" position={[target, .431, -.36]} size={[.014, .008, .07]} color={AMBER} />
    <Tag position={[target, 1.08, 0]} color={AMBER}>Settled position</Tag>
    <Follow reader={reader} name="motion-detail-target-pointer" pose={(s, g) => { g.position.x = s.axes.s.target_mm! / 1000 }}>
      <Part position={[0, .97, 0]} size={[.018, .014, .12]} color={AMBER} />
    </Follow>
  </group>
}

function LinearSaddle({ reader }: { reader: Reader }) {
  return <Follow reader={reader} name="motion-detail-linear-saddle" pose={(s, g) => { g.position.x = s.axes.s.actual_mm! / 1000 }}>
    {/* Attached above the existing .22 x .06 tooling plate. No new axis or workpiece. */}
    <Part name="travelling-head-mount" position={[0, .217, 0]} size={[.21, .07, .32]} color={FINISH.dark} />
    <Part name="travelling-reference-head" position={[0, .31, 0]} size={[.17, .12, .25]} color={FINISH.blue} radius={.012} />
    <Part name="travelling-centre-line" position={[0, .373, 0]} size={[.012, .005, .25]} color={AMBER} />
    {[-1, 1].map(k => <RoundPart key={k} position={[k * .065, .376, 0]} radius={.012} length={.008} axis="y" />)}
  </Follow>
}

function BrakeDetails({ reader }: { reader: Reader }) {
  return <group name="motion-detail-brake-load-path">
    {/* Backplate bolts to the top cap; drive transmission meets the existing side brake. */}
    <Part name="brake-top-mount" position={[.17, .695, -.12]} size={[.38, .12, .08]} color={FINISH.dark} />
    <RoundPart name="brake-drive-coupling" position={[.145, .63, 0]} radius={.045} length={.15} axis="x" />
    <Part name="brake-motor-housing" position={[0, .925, 0]} size={[.22, .21, .24]} color={FINISH.blue} radius={.018} />
    <RoundPart name="brake-motor-output" position={[0, .80, 0]} radius={.048} length={.04} axis="y" />
    <group position={[-.30, 0, -.08]} rotation={[0, 0, Math.PI / 2]}><Ruler length={1.4} /></group>
    <Follow reader={reader} name="motion-detail-brake-crosshead" pose={(s, g) => { g.position.y = -.432 + s.axes.v.actual_mm! / 1000 }}>
      <Part name="lift-crosshead-face" position={[0, 0, .21]} size={[.45, .11, .07]} color={FINISH.blue} />
      <Part name="height-witness-pointer" position={[-.28, 0, .10]} size={[.10, .018, .035]} color={AMBER} />
      <Part name="empty-lift-carriage" position={[0, -.07, .30]} size={[.4, .07, .15]} color={FINISH.dark} />
    </Follow>
    <Tag position={[-.32, .84, .1]}>Drive → brake hold</Tag>
  </group>
}

function Dial({ radius = .25 }: { radius?: number }) {
  return <group name="motion-detail-angle-dial">
    <mesh rotation={[0, Math.PI / 2, 0]}><ringGeometry args={[radius - .012, radius + .014, 64]} /><meshStandardMaterial color={FINISH.alloy} side={2} /></mesh>
    {Array.from({ length: 24 }, (_, i) => <group key={i} rotation={[i * Math.PI / 12, 0, 0]}>
      <Part position={[0, radius, 0]} size={[.014, i % 3 ? .017 : .035, .004]} color={FINISH.dark} />
    </group>)}
  </group>
}

function GearDetails({ reader, axis }: { reader: Reader; axis: 's' | 'u' }) {
  return <group name={'motion-detail-geared-axis-' + axis}>
    <group position={[.56, 0, 0]}><Dial /></group>
    <Part name="phase-dial-bracket" position={[.56, -.27, 0]} size={[.06, .045, .35]} color={FINISH.dark} />
    <Follow reader={reader} name={'motion-detail-phase-pointer-' + axis} pose={(s, g) => { g.rotation.x = s.axes[axis].actual_deg! * Math.PI / 180 }}>
      <Part name="shaft-phase-pointer" position={[.578, .11, 0]} size={[.018, .22, .019]} color={axis === 's' ? AMBER : TEAL} />
      <RoundPart position={[.575, 0, 0]} radius={.055} length={.025} axis="x" color={FINISH.dark} />
      {[0, 1, 2, 3].map(k => <group key={k} rotation={[k * Math.PI / 2, 0, 0]}>
        <Part name="roll-phase-stripe" position={[0, .192, 0]} size={[.58, .002, .028]} color={k === 0 ? (axis === 's' ? AMBER : TEAL) : FINISH.dark} radius={.0005} />
      </group>)}
    </Follow>
    <Tag position={[0, .39, 0]} color={axis === 's' ? AMBER : TEAL}>{axis === 's' ? 'Follower axis · settle after synchronization' : 'Reference axis · continuous rotation'}</Tag>
  </group>
}

function IndexDetails({ reader }: { reader: Reader }) {
  return <group name="motion-detail-index-lock">
    <FittedMaterialDrive position={[-.42,.36,0]} size={[.24,.26,.28]}/>
    <RoundPart position={[-.29, .36, 0]} radius={.075} length={.045} axis="x" />
    <Part name="pin-cylinder-body" position={[.48, .365, 0]} size={[.095, .25, .095]} color={FINISH.blue} radius={.008} />
    <group position={[0, .845, 0]} rotation={[0, 0, Math.PI / 2]}><Dial radius={.67} /></group>
    {[-1, 1].map(k => <group key={k}>
      <Part name="fixed-scale-bracket" position={[k * .46, .56, 0]} size={[.46, .035, .06]} color={FINISH.dark} />
      <Part name="fixed-scale-support" position={[k * .67, .70, 0]} size={[.025, .28, .04]} color={FINISH.dark} />
    </group>)}
    <Recorded reader={reader} node="table">
      {Array.from({ length: 4 }, (_, i) => <group key={i} rotation={[0, i * Math.PI / 2, 0]}>
        <Part name="index-hole-radial-marker" position={[.55, .035, 0]} size={[.065, .006, .024]} color={i === 0 ? AMBER : FINISH.blue} />
      </group>)}
    </Recorded>
    <Recorded reader={reader} node="pin">
      <Part name="pin-stroke-witness-arm" position={[0, -.04, .105]} size={[.025, .022, .21]} color={AMBER} />
      <Part name="pin-stroke-witness-face" position={[0, -.04, .205]} size={[.06, .018, .015]} color={AMBER} />
    </Recorded>
    {[-1, 1].map(k => <group key={k}>
      <Part name="pin-travel-window-side" position={[.48 + k * .042, .69, .18]} size={[.012, .14, .018]} color={FINISH.dark} />
      <Part name="pin-travel-window-end" position={[.48, .69 + k * .07, .18]} size={[.096, .012, .018]} color={FINISH.dark} />
      {[-1, 1].map(side => <Part key={side} name="pin-endpoint-mark" position={[.48 + side * .042, .6925 + k * .02, .192]} size={[.012, .003, .003]} color={FINISH.alloy} />)}
    </group>)}
    <Tag position={[.65, .54, .2]} color={AMBER}>Locking pin · 40 mm</Tag>
    <Tag position={[-.2, 1.03, 0]}>Rotate → align → lock</Tag>
  </group>
}

function BalanceDetails({ reader }: { reader: Reader }) {
  const layout = counterbalanceLayout(reader)
  return <group name="motion-detail-balance-mechanism">
    <Part name="tilt-motor-bracket" position={[0, .91, -.40]} size={[.22, .08, .20]} color={FINISH.dark} />
    <RoundPart name="tilt-gearmotor" position={[0, 1, -.40]} radius={.11} length={.15} axis="z" color={FINISH.blue} />
    {reader.motionHardInstance?.() && <>
    <Part name="balance-axis-endplate" position={[-.65, .52, 0]} size={[.045, .19, .30]} color={FINISH.blue} />
    <Part name="balance-axis-endplate" position={[.65, .52, 0]} size={[.045, .19, .30]} color={FINISH.blue} />
    {[-1, 1].map(k => <RoundPart key={k} name="balance-linear-guide" position={[0, .51, k * .125]} radius={.016} length={1.27} axis="x" />)}
    <FittedMaterialDrive position={[-.77,.52,0]} size={[.19,.14,.15]}/>
    </>}
    <Ruler length={layout.span} width={.05} position={[0, .62+layout.dy, .19]} />
    <Recorded reader={reader} node="weight">
      <group position={[0,layout.dy,0]}>
      {[-.055, 0, .055].map(x => <Part key={x} name="counterweight-stack-seam" position={[x, .092, 0]} size={[.002, .004, .30]} color={FINISH.dark} />)}
      <Part name="counterweight-pointer-mount" position={[0, .091, .142]} size={[.025, .018, .016]} color={FINISH.dark} />
      <Part name="counterweight-scale-pointer" position={[0, .105, .17]} size={[.025, .01, .07]} color={AMBER} />
      </group>
    </Recorded>
    <Recorded reader={reader} node="cradle">
      <Part name="head-mounting-flange" position={[0, .3, .185]} size={[.27, .25, .025]} color={FINISH.dark} />
      <RoundPart name="empty-head-interface" position={[0, .3, .213]} radius={.075} length={.03} axis="z" />
      <Part name="head-cg-witness" position={[0, .3, .23]} size={[.12, .008, .005]} color={AMBER} />
      <Part position={[0, .3, .23]} size={[.008, .12, .005]} color={AMBER} />
    </Recorded>
    <Tag position={[-.40, .87, .20]} color={AMBER}>Counterweight ↔ head tilt</Tag>
  </group>
}

function RemotePivotDetails({ reader }: { reader: Reader }) {
  const initial = reader.motionState()!.mechanism!.initial
  const pivot = initial.pivot / 1000, referenceY = (initial.c + initial.pivot) / 1000
  return <group name="motion-detail-remote-pivot-frame">
    {/* Fixed metrology frame, behind the entire platform sweep. The centre is a visual reference, not an obstruction. */}
    {[-1, 1].map(k => <group key={k}>
      <Part name="pivot-reference-foot" position={[k * .68, .07, -.82]} size={[.22, .14, .24]} color={FINISH.dark} />
      <Part name="pivot-reference-post" position={[k * .68, .73, -.82]} size={[.055, 1.3, .055]} color={FINISH.blue} />
    </group>)}
    <Part name="pivot-reference-crossbar" position={[0, 1.38, -.82]} size={[1.42, .055, .055]} color={FINISH.blue} />
    <Part name="reticle-mount" position={[0, (1.38 + referenceY + .08) / 2, -.80]} size={[.012, 1.38 - referenceY - .08, .035]} color={FINISH.steel} />
    <group position={[0, referenceY, -.785]} name="fixed-remote-centre-reticle">
      <mesh><ringGeometry args={[.077, .081, 48]} /><meshBasicMaterial color={TEAL} side={2} /></mesh>
      <Part position={[0, 0, 0]} size={[.22, .004, .004]} color={TEAL} /><Part size={[.004, .22, .004]} color={TEAL} />
    </group>
    <group name="remote-centre-reference-axis" userData={{ referenceMarking: true }}>
      {Array.from({ length: 10 }, (_, i) => <mesh key={i} position={[0, referenceY, -.73 + i * .077]} rotation={[Math.PI / 2, 0, 0]}>
        <cylinderGeometry args={[.0015, .0015, .038, 6]} /><meshBasicMaterial color={TEAL} transparent opacity={.45} depthWrite={false} />
      </mesh>)}
    </group>
    <Tag position={[0, 1.54, -.82]}>Fixed rotation center · platform tilt</Tag>
    {Array.from({ length: 6 }, (_, i) => <Recorded reader={reader} key={i} node={'leg' + i}>
      {/* Undo the replay rod scale for fixed-size end sockets. */}
      <JointSockets reader={reader} node={'leg' + i} />
    </Recorded>)}
    <Recorded reader={reader} node="platform">
      <RoundPart name="platform-tool-flange" position={[0, .129, 0]} radius={.17} length={.025} axis="y" color={FINISH.dark} />
      {Array.from({ length: 6 }, (_, i) => <RoundPart key={i} name="platform-mount-bolt" position={[.125 * Math.cos(i * Math.PI / 3), .147, .125 * Math.sin(i * Math.PI / 3)]} radius={.011} length={.014} axis="y" />)}
      <mesh name="actual-stylus-tip" position={[0, pivot, 0]}><sphereGeometry args={[.012, 12, 8]} /><meshStandardMaterial color={AMBER} /></mesh>
    </Recorded>
  </group>
}

function JointSockets({ reader, node }: { reader: Reader; node: string }) {
  const ref = useRef<Group>(null)
  useFrame(() => {
    const l = reader.motionState()?.mechanism?.poses[node]?.scale?.[1] ?? 1
    if (!ref.current) return
    ref.current.children.forEach((g, i) => { g.position.y = (i === 0 ? -.5 : .5); g.scale.set(1 / .065, 1 / l, 1 / .065) })
  })
  return <group ref={ref}>{[-1, 1].map(k => <group key={k}>
    <mesh name="strut-spherical-joint" castShadow><sphereGeometry args={[.052, 16, 12]} /><meshStandardMaterial color={FINISH.steel} metalness={.65} roughness={.4} /></mesh>
  </group>)}</group>
}

export function MotionMediumDetails({ device, plant }: DeviceProps) {
  if (!('motionState' in plant) || typeof plant.motionState !== 'function') return null
  const reader = plant as unknown as Reader, state = reader.motionState()
  if (!state || !MODES.has(state.mode)) return null
  let content: ReactNode = null
  if (['reference', 'registration', 'velocity_capture'].includes(state.mode)) {
    if (device.id === 'BASE') {
      const sensorId = state.mode === 'registration' ? 'REGISTRATION_PROBE' : 'HOME_SENSOR'
      const probe = (plant.machine.devices.find(d => d.id === sensorId)?.pos[0] ?? device.pos[0]) - device.pos[0]
      content = <LinearBed reader={reader} mode={state.mode} probe={probe} />
    }
    if (device.id === 'AXIS' || device.id === 'S_AXIS_A') content = <LinearSaddle reader={reader} />
  }
  if (state.mode === 'brake' && device.id === 'V_AXIS_A') content = <BrakeDetails reader={reader} />
  if (state.mode === 'gear' && ['S_AXIS_A', 'U_AXIS_A'].includes(device.id)) content = <GearDetails reader={reader} axis={device.id === 'S_AXIS_A' ? 's' : 'u'} />
  if (state.mode === 'index_pin' && device.id === 'CELL') content = <IndexDetails reader={reader} />
  if (state.mode === 'counterbalance' && device.id === 'CELL') content = <BalanceDetails reader={reader} />
  if (state.mode === 'hexapod' && device.id === 'CELL') content = <RemotePivotDetails reader={reader} />
  return content ? <group name={'motion-medium-details-' + state.mode}>{content}</group> : null
}
