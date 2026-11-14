import type { Frame } from '@/lib/replay/adapter'

/** Inspector readout of recorded physical state; never an extra PLC input. */
export function MaterialV6Readout({ id, frame, className }: { id: string; frame: Frame; className: string }) {
  if (!id.startsWith('MAT-V6-')) return null
  const parts = Object.entries(frame.world?.parts ?? {})
  const held = parts.filter(([, p]) => p.held_by === 'TOOL').map(([key]) => key).join(', ') || 'none'
  let title = '', detail = ''
  if (id === 'MAT-V6-D01') {
    title = `Buffer ${(frame.s.DANCER * 900).toFixed(1)} mm / allowed 80–900 mm`
    detail = `Requested ${frame.words?.D10 ?? 0} mm · actually pulled ${(frame.s.RIBBON * 500).toFixed(1)} mm · receiver ${frame.s.RECEIVER >= .999 ? 'clamped' : 'unclamped'}`
  } else if (id === 'MAT-V6-D10') {
    const layers = parts.filter(([, p]) => p.owner === 'stack').sort((a,b) => a[1].pos[1] - b[1].pos[1])
    const requested = [11,12,13,14].map(n => frame.words?.[`D${n}`] === 1 ? 'B' : 'A').join(' → ')
    title = `Requested ${requested} · actual ${layers.map(([key]) => key[0]).join(' → ') || 'none yet'}`
    detail = `${layers.length}/4 layers from bottom · support ${(550 + frame.s.STACK_TABLE * 150).toFixed(1)} mm · held ${held}`
  } else if (id === 'MAT-V6-D03') {
    const p = parts[0]?.[1]
    const angle = (((p?.rotation?.[1] ?? 0) * 180 / Math.PI) % 360 + 360) % 360
    title = `Requested orientation ${frame.words?.D10 ?? 0}° · physical orientation ${angle.toFixed(1)}°`
    detail = `Held ${held} · yellow mark shows physical orientation`
  } else if (id === 'MAT-V6-D04') {
    title = `Physical datum detection X ${frame.x.X31 ? 'matched' : 'not matched'} · Z ${frame.x.X32 ? 'matched' : 'not matched'}`
    detail = `Held ${held} · datum detection applies only to the workpiece on the source support`
  } else if (id === 'MAT-V6-D06') {
    title = `Current inspection input ${frame.x.X31 ? frame.words?.D20 === 1 ? 'quarantine' : 'accept' : 'invalid'}`
    detail = `Held ${held} · received: ${parts.filter(([,p]) => ['accept','reject'].includes(p.owner ?? '')).map(([key,p]) => `${key} ${p.owner === 'accept' ? 'accepted' : 'quarantined'}`).join(' / ') || 'none yet'}`
  } else return null
  return <div className={className} data-testid="material-v6-readout" aria-label="Recorded physical state">
    <strong>{title}</strong><span>{detail}</span>
  </div>
}
