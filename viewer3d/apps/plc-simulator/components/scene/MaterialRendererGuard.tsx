'use client'

import { useFrame, useThree } from '@react-three/fiber'
import { Html } from '@react-three/drei'
import { useRef, useState } from 'react'
import type { LaidOutMachine } from '@/lib/machine/layout'

/** A generic fixture is not a valid substitute for a declared v7 mechanism. */
export function MaterialRendererGuard({ machine }: { machine: LaidOutMachine }) {
  const { scene } = useThree()
  const checked = useRef({ machine, at: -1 })
  const [failedMachine, setFailedMachine] = useState<LaidOutMachine | null>(null)
  useFrame(({ clock }) => {
    const composed = machine.devices.filter(d => d.visualVariant?.startsWith('cell3-composable-'))
    const flow = machine.devices.find(d => d.visualVariant?.startsWith('cell3-r9-'))
    const redesign = machine.devices.find(d => d.visualVariant?.startsWith('cell3-r8-'))
    if (machine.replaySuite !== 'material' || (!composed.length && !flow && !redesign && !/^MAT-V[78]-/.test(machine.title))) return
    if (checked.current.machine !== machine) checked.current = { machine, at: -1 }
    if (clock.elapsedTime - checked.current.at < 1) return
    checked.current.at = clock.elapsedTime
    const version = machine.title.startsWith('MAT-V8-') ? 'v8' : 'v7'
    const hardware = machine.devices.filter(d => d.kind !== 'sensor')
    const missing = composed.length ? composed.some(d => !scene.getObjectByName('composable-hardware-'+d.id)) : flow ? !scene.getObjectByName(`material-flowcell-r9-${flow.visualVariant!.slice('cell3-r9-'.length)}`) : redesign
      ? !scene.getObjectByName(`material-mini-process-r8-${redesign.visualVariant!.slice('cell3-r8-'.length)}`)
      : hardware.some(d => {
      const renderer = d.visualVariant?.startsWith('v13-') ? 'v13' : version
      return !d.visualVariant?.startsWith(`${renderer}-`) || !scene.getObjectByName(`material-${renderer}-hardware-${d.id}`)
    })
    setFailedMachine(previous => missing ? machine : previous === machine ? null : previous)
  })
  if (failedMachine !== machine) return null
  return <Html center zIndexRange={[100, 100]}>
    <div data-testid="material-renderer-recovery" className="w-72 rounded-lg border border-border bg-surface p-4 text-center shadow-lg">
      <p className="text-sm font-semibold">The dedicated task equipment could not be loaded.</p>
      <p className="mt-2 text-xs text-text-muted">The fallback fixture shown is not the equipment for this task.</p>
      <button className="mt-3 rounded border border-border px-3 py-2 text-xs" onClick={() => window.location.reload()}>Reload 3D view</button>
    </div>
  </Html>
}
