'use client'









import { Component, type ReactNode } from 'react'
import { AlertTriangle, RotateCcw } from 'lucide-react'

interface Props {
  children: ReactNode
  resetKey?: string
}

interface State {
  error: Error | null
}

export class SceneBoundary extends Component<Props, State> {
  state: State = { error: null }

  static getDerivedStateFromError(error: Error): State {
    return { error }
  }

  componentDidUpdate(previous: Props) {
    // An error in one replay must not hide every subsequently selected task.
    if (this.state.error && previous.resetKey !== this.props.resetKey) {
      this.setState({ error: null })
    }
  }

  componentDidCatch(error: Error, info: { componentStack?: string | null }) {

    console.error('[3D] Scene rendering failed:', error.message, info.componentStack)
  }

  render() {
    const { error } = this.state
    if (!error) return this.props.children
    const chunkFailed = /ChunkLoadError|Loading chunk|Failed to fetch dynamically imported module/i.test(error.name+' '+error.message)
    const graphicsUnavailable = /WebGL.*context|context.*WebGL/i.test(error.message)

    return (
      <div data-testid="scene-error" className="h-full grid place-items-center px-8">
        <div className="max-w-md text-center">
          <AlertTriangle size={22} className="mx-auto mb-3 text-warn" />
          <p className="text-sm text-text mb-1.5">{graphicsUnavailable ? 'The browser could not initialize 3D graphics.' : 'The 3D view could not be loaded.'}</p>
          {graphicsUnavailable && <p className="text-xs text-text-subtle leading-relaxed mb-3">
            This view requires WebGL 2. Browser acceleration settings, graphics drivers or remote access may limit availability.
          </p>}
          <p className="text-xs text-text-subtle leading-relaxed mb-4 font-mono break-words">
            {error.message}
          </p>
          <button className="btn mx-auto" onClick={() => chunkFailed ? window.location.reload() : this.setState({ error: null })}>
            <RotateCcw size={12} /> Retry
          </button>
          <button className="btn mx-auto mt-2" onClick={() => window.location.reload()}>
            <RotateCcw size={12} /> Reload latest view
          </button>
          <p className="text-2xs text-text-subtle mt-4 leading-relaxed">
            If retrying does not restore the view, reload the latest page.
            Task evaluation results are independent of this rendering error.
          </p>
        </div>
      </div>
    )
  }
}
