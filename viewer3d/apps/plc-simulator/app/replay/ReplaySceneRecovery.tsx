'use client'

import { Fragment, useCallback, useEffect, useRef, useState, type ReactNode } from 'react'

/** WebGL context loss does not throw, so a React error boundary cannot catch it. */
export function ReplaySceneRecovery({ enabled, reloadKey, onContextLost, children }: {
  enabled: boolean
  reloadKey: number
  onContextLost: () => void
  children: ReactNode
}) {
  const container = useRef<HTMLDivElement>(null)
  const automaticAttempted = useRef(false)
  const handlingLoss = useRef(false)
  const previousReload = useRef(reloadKey)
  const [generation, setGeneration] = useState(0)
  const [phase, setPhase] = useState<'ready' | 'recovering' | 'failed'>('ready')

  const restart = useCallback(() => {
    automaticAttempted.current = false
    handlingLoss.current = false
    setGeneration(value => value + 1)
    setPhase('ready')
  }, [])

  useEffect(() => {
    if (previousReload.current === reloadKey) return
    previousReload.current = reloadKey
    restart()
  }, [reloadKey, restart])

  useEffect(() => {
    if (!enabled) {
      automaticAttempted.current = false
      handlingLoss.current = false
      setPhase('ready')
      return
    }
    const element = container.current
    const lost = (event: Event) => {
      event.preventDefault()
      if (handlingLoss.current) return
      handlingLoss.current = true
      onContextLost()
      setPhase(automaticAttempted.current ? 'failed' : 'recovering')
      automaticAttempted.current = true
    }
    // This event does not bubble. Capture also ignores intentionally disposed,
    // detached canvases when a replay or renderer is replaced.
    element?.addEventListener('webglcontextlost', lost, true)
    return () => element?.removeEventListener('webglcontextlost', lost, true)
  }, [enabled, onContextLost])

  useEffect(() => {
    if (phase !== 'recovering') return
    const timer = window.setTimeout(() => {
      handlingLoss.current = false
      setGeneration(value => value + 1)
      setPhase('ready')
    }, 250)
    return () => window.clearTimeout(timer)
  }, [phase])

  return <div ref={container} style={{ position: 'relative', width: '100%', height: '100%' }}>
    {phase === 'ready' && <Fragment key={generation}>{children}</Fragment>}
    {phase !== 'ready' && <div data-testid="scene-recovery" role="status"
      className="absolute inset-0 grid place-items-center bg-surface p-6 text-center">
      <div>
        <p className="text-sm text-text">{phase === 'recovering'
          ? 'The 3D connection was lost; reloading the scene.'
          : 'The 3D connection could not be restored.'}</p>
        {phase === 'failed' && <>
          <button type="button" className="btn mx-auto mt-3" onClick={restart}>Reload 3D</button>
          <button type="button" className="btn mx-auto mt-2" onClick={() => window.location.reload()}>Reload page</button>
        </>}
      </div>
    </div>}
  </div>
}
