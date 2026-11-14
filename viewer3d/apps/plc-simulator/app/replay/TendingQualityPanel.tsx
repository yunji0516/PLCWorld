import { useMemo } from 'react'
import type { TraceRun } from '@/lib/replay/adapter'
import { indexTendingMeasurements, tendingLocation, tendingMeasurementsAt } from '@/lib/replay/tendingQuality'

export function TendingQualityPanel({ run, scan, onSeek }: { run: TraceRun; scan: number; onSeek: (frame: number) => void }) {
  const records = useMemo(() => indexTendingMeasurements(run.frames), [run.frames])
  const results = tendingMeasurementsAt(records, scan)
  const frame = run.frames[scan]
  const parts = Object.entries(frame.world?.parts ?? {})
  const normal = parts.filter(([, p]) => p.owner === 'outfeed').length
  const rejected = parts.filter(([, p]) => p.owner?.startsWith('reject_')).length
  return <section data-testid="tending-quality" aria-label="Per-workpiece inspection and routing" className="border-b border-border bg-surface-2 p-3 text-[11px] leading-relaxed">
    <h3 className="text-xs font-semibold">Inspection → verdict → destination</h3>
    <p className="mt-1 text-text-muted">Both measured depths must be within 5.80–6.20 mm. Each workpiece is routed by its own measurement, not by a target count.</p>
    <div className="my-2 flex flex-wrap gap-1.5 font-semibold">
      <span className="rounded bg-emerald-50 px-2 py-1 text-emerald-800">Accepted outfeed {normal}</span>
      <span className="rounded bg-rose-50 px-2 py-1 text-rose-800">Rejected quarantine {rejected}</span>
    </div>
    <div className="space-y-2">
      {parts.map(([id, part]) => {
        const token = Number(/^P(\d+)_/.exec(id)?.[1])
        const result = results.get(token)
        const wrongRoute = (part.owner === 'outfeed' || part.owner?.startsWith('reject_'))
          && (!result || result.good !== (part.owner === 'outfeed'))
        return <div key={id} data-testid={`tending-quality-P${token}`} className="rounded border border-border bg-white px-2 py-1.5">
          <div className="flex items-center justify-between gap-2">
            <strong>P{token} · {id.endsWith('_A') ? 'A' : 'B'} order</strong>
            <span className={result ? result.good ? 'font-semibold text-emerald-800' : 'font-semibold text-rose-800' : 'text-text-muted'}>
              {result ? result.good ? 'Accepted' : 'Rejected' : frame.world?.tending?.measuring && frame.world.tending.resultToken === token ? 'Measuring' : 'Not inspected'}
            </span>
          </div>
          <div className="font-mono tabular-nums">{result ? `${result.depths.map(d => (d / 1000).toFixed(2)).join(' / ')} mm` : '— / — mm'}</div>
          <div>{result ? `Destination: ${result.good ? 'accepted outfeed' : 'rejection tray'}` : 'Destination: determined after inspection'}</div>
          <div className={wrongRoute ? 'font-semibold text-rose-800' : 'text-text-muted'}>Current: {tendingLocation(part.owner)}{wrongRoute ? ' · wrong route' : ''}</div>
          {result && <button type="button" className="mt-0.5 text-blue-700 underline underline-offset-2" onClick={() => onSeek(result.frame)} aria-label={`View inspection of P${token}`}>View inspection · scan {result.frame}</button>}
        </div>
      })}
    </div>
    <p className="mt-2 text-[10px] text-text-muted">Quarantine separates rejected parts; it is not general storage. The temporary fixture holds parts awaiting inspection. Machining and measurement are synthetic models; a defective part does not by itself mean that the control task failed.</p>
  </section>
}
