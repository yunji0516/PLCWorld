import type { Frame, TraceTask } from '@/lib/replay/adapter'

/** Observed contains both inputs and outputs; don't draw inputs twice. */
export function signalNames(task: Pick<TraceTask, 'observed' | 'io'>): string[] {
  return [...new Set([...task.observed, ...Object.keys(task.io).filter(name => name.startsWith('X'))])]
}

export function signalValue(frame: Pick<Frame, 'x' | 'y'>, name: string): number {
  return Number(name.startsWith('X') ? !!frame.x[name] : !!frame.y[name])
}

/** Lossless run-length path: every ON scan owns [scan, scan + 1).
 * One SVG path per signal, not one DOM element per sample. */
export function signalPath(values: readonly number[], scans?: readonly number[]): string {
  const spans: string[] = []
  let start = -1
  for (let i = 0; i <= values.length; i++) {
    if (i < values.length && values[i]) {
      if (start < 0) start = i
    } else if (start >= 0) {
      const from=scans?.[start] ?? start
      const to=scans ? (scans[i] ?? scans[scans.length-1]+1) : i
      spans.push(`M${from} 0h${to - from}v1H${from}z`)
      start = -1
    }
  }
  return spans.join('')
}
