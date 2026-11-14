import type { Frame } from '@/lib/replay/adapter'
import { MOTION_EASY_REASONS } from './MotionEasyPanel'

export const MOTION_UNIT_REASONS: Record<string, string> = {
  ...MOTION_EASY_REASONS,
  motion_easy_unit_complete: 'Function result and hold period confirmed',
  request_accepted_missing: 'Function request not accepted', result_asserted_missing: 'No valid result asserted',
  motion_easy_unit_complete_missing: 'Result hold period not completed',
  travel_limit: 'Travel limit exceeded', stale_capture: 'Result recorded without a fresh capture',
  wrong_reference: 'Coordinate reference differs from detected edge', support_lost: 'Brake support lost',
  obstruction_contact: 'Contact with obstruction', corridor_exit: 'Exited travel corridor',
  excess_sway: 'Sway limit exceeded', excess_moment: 'Support moment limit exceeded',
}

const axes: Record<string, Record<string, string>> = {
  gear: { s: 'Driven axis', u: 'External reference axis' }, tracking: { s: 'Tracking axis', u: 'External reference axis' },
  orientation: { a: 'External shoulder', b: 'External elbow', c: 'Controlled wrist' },
  index: { a: 'Index disc', b: 'Locking pin' }, retract: { a: 'Pivot axis', b: 'Boom extension' },
  mobile: { a: 'Travel X', b: 'Centerline offset Z', c: 'Heading' },
  sway: { a: 'Hoist length', b: 'Trolley X', c: 'Hook sway' },
  balance: { a: 'External head angle', b: 'Controlled counterweight' },
}

export function MotionEasyUnitPanel({ value: v }: { value: NonNullable<NonNullable<Frame['world']>['motion_easy_unit']> }) {
  const a = v.axes[v.primary_axis], d = v.diagnostics
  const relation = ['gear', 'tracking', 'orientation', 'balance'].includes(v.mode)
  return <section data-testid="motion-easy-unit-state" className="mt-2 space-y-1 rounded-md border border-border px-2.5 py-2 text-[11px] leading-relaxed">
    <div className="font-semibold">Single function · {v.function_id}</div>
    {Object.entries(v.axes).filter(([key]) => !(v.mode === 'index' && key === 'b')).map(([key, axis]) => <div key={key}>
      {axes[v.mode]?.[key] ?? 'Controlled axis'} {axis.actual.toFixed(2)} {axis.unit === 'deg' ? '°' : axis.unit}
      {' · '}{axis.velocity.toFixed(2)} {axis.unit === 'deg' ? '°' : axis.unit}/s
    </div>)}
    {['position', 'index', 'retract', 'mobile', 'sway', 'reopen'].includes(v.mode) && <div>Target {a.target?.toFixed(2)} {a.unit === 'deg' ? '°' : a.unit} · position error {v.error.toFixed(3)}</div>}
    {v.mode === 'speed' && <div>Target speed {a.target?.toFixed(1)} °/s · speed error {v.error.toFixed(2)} °/s</div>}
    {relation && <div>{v.mode === 'balance' ? 'Support moment' : 'Relation error'} {v.error.toFixed(3)} {v.mode === 'balance' ? 'Nm' : v.mode === 'tracking' ? 'mm' : '°'}</div>}
    {v.mode === 'stop' && <div>Stop limit {(d.limit / 100).toFixed(2)} mm</div>}
    {v.mode === 'home' && <div>Fresh edge capture {d.fresh ? d.captured : 'pending'} · reference {d.referenced ? 'established' : 'not established'}</div>}
    {v.mode === 'capture' && <div>Captured mark {d.fresh ? `${(d.captured / 100).toFixed(2)} mm` : 'pending'} · capture error {d.fresh ? `${v.error.toFixed(2)} mm` : '—'}</div>}
    {v.mode === 'brake' && <div>Brake {d.brake_closed ? 'engaged' : 'released'} · external torque support {d.support ? 'active' : 'inactive'}</div>}
    {v.mode === 'reopen' && <div>Obstruction {d.obstruction ? 'detected' : 'not detected'}</div>}
    <div>Result hold observation {v.result_age_ms.toFixed(0)} / {v.observation_ms} ms</div>
    <div>{v.success ? 'Function result confirmed' : v.result_asserted ? 'Checking result hold' : 'Function in progress'}</div>
    {v.violations.length > 0 && <div className="text-rose-600">{MOTION_UNIT_REASONS[v.violations[0]] ?? v.violations[0]}</div>}
  </section>
}
