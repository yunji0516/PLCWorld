'use client'

import { memo, useMemo } from 'react'
import type { Frame, TraceTask } from '@/lib/replay/adapter'
import { signalNames, signalPath, signalValue } from './signalTimeline'

type Row = { name: string; path: string; bad?: boolean }

// Waveforms depend on the run, never on the playback cursor.
const Waveforms = memo(function Waveforms({ rows, total }: { rows: Row[]; total: number }) {
  return <div data-testid="signal-waveforms" className="space-y-0.5">
    {rows.map(row => <div key={row.name} data-signal={row.name} className="flex items-center gap-2">
      <span className="w-20 shrink-0 text-right font-mono text-[10px] text-text-subtle">{row.name}</span>
      <svg className="h-3 min-w-0 flex-1 rounded-sm bg-surface-2" viewBox={`0 0 ${Math.max(1, total)} 1`}
        preserveAspectRatio="none" aria-hidden="true">
        <path d={row.path} fill={row.bad ? '#c2362b' : '#2563eb'} />
      </svg>
    </div>)}
  </div>
})

export function SignalTimeline({ task, frames, violations, scan }: {
  task: TraceTask; frames: Frame[]; violations: { k: number }[]; scan: number
}) {
  const numericInputs = ['motion_easy_function', 'motion_easy_unit', 'motion_medium_core', 'motion_hard15'].includes(task.family ?? '') || (task.suite === 'material' && (task.task_version?.startsWith('7.') || task.task_version?.startsWith('easy15/')))
  const names = useMemo(() => numericInputs
    ? signalNames(task).filter(name => !name.startsWith('D')) : signalNames(task), [task, numericInputs])
  const rows = useMemo(() => {
    const bad = new Set(violations.map(v => v.k))
    const scans=task.family==='material_stations_v7' ? frames.map(f=>f.k) : undefined
    return [...names.map(name => ({ name, path: signalPath(frames.map(f => signalValue(f, name)),scans) })),
      { name: 'Safety violation', bad: true, path: signalPath(frames.map((_, i) => Number(bad.has(i))),scans) }]
  }, [names, frames, violations,task.family])
  const frame = frames[Math.min(scan, frames.length - 1)]
  const total=task.family==='material_stations_v7' ? frames[frames.length-1].k+1 : frames.length
  const cursor=task.family==='material_stations_v7' ? (frame?.k ?? 0) : scan
  return <>
    <div className="relative mt-3">
      <Waveforms rows={rows} total={total} />
      <div className="pointer-events-none absolute inset-y-0 left-[5.5rem] right-0" aria-hidden="true">
        <i data-testid="signal-cursor" className="absolute inset-y-0 w-px bg-text/40"
          style={{ left: `${total > 1 ? cursor / (total - 1) * 100 : 0}%` }} />
      </div>
    </div>
    <p className="mt-2 font-mono text-[10px] text-text-subtle">
      Current scan — {frame && names.map(name => `${name}=${signalValue(frame, name)}`).join('  ')}
    </p>
    {numericInputs && frame?.words && <p data-testid={task.suite === 'material' ? 'material-v7-word-values' : 'motion-easy-word-values'} className="mt-1 font-mono text-[10px] text-text-subtle">
      Numeric I/O · scaled integers — {Object.keys(task.io).filter(name => name.startsWith('D')).map(name => `${name}=${frame.words?.[name] ?? 0}`).join('  ')}
    </p>}
  </>
}
