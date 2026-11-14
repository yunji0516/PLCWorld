'use client'

import { useRef } from 'react'

export function ResizeHandle({ label, controls, orientation, value, min, max, direction = 1, className, onChange, onReset }: {
  label: string
  controls: string
  orientation: 'horizontal' | 'vertical'
  value: number
  min: number
  max: number
  direction?: number
  className: string
  onChange: (value: number) => void
  onReset: () => void
}) {
  const drag = useRef<{ pointer: number; coordinate: number; size: number } | null>(null)
  const change = (size: number) => onChange(Math.max(min, Math.min(max, size)))
  return <div role="separator" tabIndex={0} aria-label={label} aria-controls={controls}
    aria-orientation={orientation} aria-valuemin={Math.round(min)} aria-valuemax={Math.round(max)}
    aria-valuenow={Math.round(value)} aria-valuetext={`${Math.round(value)} pixels`}
    title={`${label} · drag or use arrow keys · double-click to reset`}
    className={className}
    onPointerDown={event => {
      if (event.button !== 0) return
      event.preventDefault()
      event.currentTarget.focus()
      event.currentTarget.setPointerCapture(event.pointerId)
      drag.current = { pointer: event.pointerId, coordinate: orientation === 'horizontal' ? event.clientY : event.clientX, size: value }
    }}
    onPointerMove={event => {
      const start = drag.current
      if (!start || start.pointer !== event.pointerId) return
      const coordinate = orientation === 'horizontal' ? event.clientY : event.clientX
      change(start.size + (coordinate - start.coordinate) * direction)
    }}
    onPointerUp={event => {
      drag.current = null
      if (event.currentTarget.hasPointerCapture(event.pointerId)) event.currentTarget.releasePointerCapture(event.pointerId)
    }}
    onPointerCancel={() => { drag.current = null }}
    onLostPointerCapture={() => { drag.current = null }}
    onDoubleClick={onReset}
    onKeyDown={event => {
      const plus = orientation === 'horizontal' ? 'ArrowDown' : 'ArrowRight'
      const minus = orientation === 'horizontal' ? 'ArrowUp' : 'ArrowLeft'
      const step = event.shiftKey ? 40 : 10
      if (event.key === plus || event.key === minus) {
        event.preventDefault()
        change(value + (event.key === plus ? step : -step) * direction)
      } else if (event.key === 'Home' || event.key === 'End') {
        event.preventDefault()
        change(event.key === 'Home' ? min : max)
      } else if (event.key === 'Enter') { event.preventDefault(); onReset() }
    }}><span aria-hidden="true" />{orientation === 'horizontal' && <small aria-hidden="true">↕ Drag vertically</small>}</div>
}
