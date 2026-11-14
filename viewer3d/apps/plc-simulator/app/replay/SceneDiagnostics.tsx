'use client'

import { useState } from 'react'

export function SceneDiagnostics({ task }: { task: string }) {
  const [report, setReport] = useState('')
  const [copied, setCopied] = useState(false)
  const inspect = () => {
    const scene = document.querySelector('[data-testid="replay-scene"]')
    const canvas = scene?.querySelector('canvas')
    const rect = (element: Element | null | undefined) => {
      const r = element?.getBoundingClientRect()
      return r ? { width: Math.round(r.width), height: Math.round(r.height) } : null
    }
    setCopied(false)
    setReport(JSON.stringify({
      revision: 'replay-ui-v1', task,
      page: location.origin + location.pathname, browser: navigator.userAgent,
      viewport: { width: innerWidth, height: innerHeight, pixelRatio: devicePixelRatio },
      scene: rect(scene), canvas: rect(canvas),
      phase: canvas?.dataset.scenePhase ?? (canvas ? 'canvas-present' : 'no-canvas'),
      health: canvas?.dataset.sceneHealth ? JSON.parse(canvas.dataset.sceneHealth) : null,
      error: scene?.querySelector('[data-testid="scene-error"]')?.textContent ?? null,
      recovery: scene?.querySelector('[data-testid="scene-recovery"]')?.textContent ?? null,
    }, null, 2))
  }
  return <div style={{ position: 'relative' }}>
    <button type="button" className="btn" onClick={inspect}>3D diagnostics</button>
    {report && <div role="region" aria-label="3D diagnostic information" className="rounded-md border border-border bg-surface p-3 shadow-lg"
      style={{ position: 'absolute', right: 0, top: '100%', width: 'min(340px, 90vw)', zIndex: 100 }}>
      <p className="mb-2 text-xs text-text">Copy this information to help diagnose a blank scene in the current browser.</p>
      <textarea aria-label="3D diagnostic report" readOnly value={report} rows={10}
        className="w-full border border-border p-2 font-mono text-[10px] text-text" />
      <div className="mt-2 flex gap-2">
        <button type="button" className="btn" onClick={() => {
          void navigator.clipboard?.writeText(report).then(() => setCopied(true)).catch(() => setCopied(false))
        }}>{copied ? 'Copied' : 'Copy diagnostics'}</button>
        <button type="button" className="btn" onClick={() => setReport('')}>Close</button>
      </div>
    </div>}
  </div>
}
