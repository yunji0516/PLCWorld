import type { Frame } from '@/lib/replay/adapter'

export const MOTION_EASY_REASONS: Record<string,string> = {
  request_accepted:'Single-function request accepted', reference_captured:'Encoder count captured at the reference edge',
  reference_committed:'Coordinate reference set from the captured count', result_asserted:'Result asserted after checking the physical condition',
  motion_easy_complete:'Physical result held for the required interval', premature_completion:'Result asserted before the physical condition was met',
  result_not_held:'Physical state was not maintained after completion', travel_limit_crossed:'Travel limit exceeded',
  fresh_reference_missing:'No fresh reference capture for this homing cycle', reference_offset_error:'Coordinate reference offset error',
  capture_too_fast:'Reference edge captured above the speed limit', velocity_not_maintained:'Requested speed was not maintained after ready',
  power_removed_during_stop:'Drive power removed during deceleration', ready_dropped:'Speed-ready state was not maintained',
  command_out_of_range:'Command is outside the published drive range', completion_deadline_missed:'Ready or completion deadline missed',
  motion_without_request:'Motion occurred without a request', physical_result_not_held:'Physical result was not held for the required interval',
  result_not_asserted:'No valid completion or ready signal', request_not_received:'Request was not accepted',
}

export function MotionEasyPanel({ value }: { value: NonNullable<NonNullable<Frame['world']>['motion_easy']> }) {
  const titles = { position:'Precise positioning', home:'Coordinate referencing', stop:'Decelerate and hold', speed:'Run at requested speed' }
  return <section data-testid="motion-easy-state" className="mt-2 space-y-1 rounded-md border border-border px-2.5 py-2 text-[11px] leading-relaxed">
    <div className="font-semibold">Single-function task · {titles[value.mode]}</div>
    {value.mode === 'position' && <>
      <div>Target {value.target.toFixed(2)} / actual {value.actual.toFixed(2)} mm</div>
      <div>Position error {(value.actual-value.target).toFixed(3)} mm · speed {value.velocity.toFixed(2)} mm/s</div>
      <div>Continuous settling {value.stable_ms.toFixed(0)} / 50 ms</div>
    </>}
    {value.mode === 'home' && <>
      <div>Reference {value.referenced ? 'established' : 'not established'} · speed {value.velocity.toFixed(2)} mm/s</div>
      <div>Raw count {value.raw_count} / captured {value.capture_valid ? value.captured_count : 'pending'}</div>
      <div>Set reference {value.reference_count ?? 'pending'} · reference error {value.reference_error_mm === null ? '—' : `${value.reference_error_mm.toFixed(3)} mm`}</div>
    </>}
    {value.mode === 'stop' && <>
      <div>Actual position {value.actual.toFixed(2)} / limit {value.limit.toFixed(2)} mm</div>
      <div>Actual speed {value.velocity.toFixed(2)} mm/s</div>
      <div>Continuous stop {value.stable_ms.toFixed(0)} / 30 ms</div>
    </>}
    {value.mode === 'speed' && <>
      <div>Target {value.target.toFixed(1)} / actual {value.velocity.toFixed(1)} rpm</div>
      <div>Speed error {(value.velocity-value.target).toFixed(2)} rpm</div>
      <div>{value.result_asserted ? 'Running after speed-ready indication' : 'Waiting for requested speed'}</div>
    </>}
    <div>Result hold observation {value.result_age_ms.toFixed(0)} / {value.mode==='speed' ? 500 : 300} ms</div>
    {value.violations.length > 0 && <div className="text-rose-600">{MOTION_EASY_REASONS[value.violations[0]] ?? value.violations[0]}</div>}
  </section>
}
