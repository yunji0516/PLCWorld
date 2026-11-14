import type { Frame } from '@/lib/replay/adapter'

export function PrecisionPanel({ value }: { value: NonNullable<NonNullable<Frame['world']>['precision']> }) {
  return <section data-testid="motion-precision-state" aria-label="Precision position and path clearance"
    className="mt-2 space-y-2 rounded-md border border-border px-2.5 py-2 text-[11px] leading-relaxed">
    <div className="font-semibold">Precision position and path clearance</div>
    {Object.entries(value.axes).map(([name, axis]) => <div key={name} data-testid={`precision-axis-${name}`}>
      <div className="font-semibold">{name.toUpperCase()} · {axis.settled ? 'settled' : 'moving / awaiting settle'}</div>
      <div>Target {axis.target_mm.toFixed(1)} / actual {axis.actual_mm.toFixed(1)} mm</div>
      <div>Error {axis.error_mm.toFixed(2)} mm · speed {axis.velocity_mm_s.toFixed(1)} mm/s</div>
    </div>)}
    {value.current_gap_mm !== null && <div>
      <div className={value.collision ? 'font-semibold text-rose-700' : 'text-text-muted'}>
        {value.collision ? `Path collision detected · ${value.collision.pair}` : 'No protected-geometry collision so far'}
      </div>
      <div>Current clearance {value.current_gap_mm.toFixed(1)} mm · simultaneous motion {value.overlap_scans} scans</div>
      <div className="text-[10px] text-text-subtle">Major geometry of the specified device pair · projected separation axis</div>
    </div>}
  </section>
}
