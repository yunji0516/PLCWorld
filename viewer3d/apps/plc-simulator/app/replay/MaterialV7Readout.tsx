import type { Frame, TraceDevice } from '@/lib/replay/adapter'

/** Viewer state comes from the recorded physical poses and input words. */
export function materialV7State(device: TraceDevice, value: number, frame?: Frame): string | undefined {
  const v = device.visual_variant ?? ''
  if (!v.startsWith('v7-')) return undefined
  const pos = frame?.world?.devices[device.id]?.pos
  if (v.endsWith('-base')) return 'Frame'
  if (v === 'v7-nozzle') return `Height ${(value * 1000).toFixed(0)} mm`
  if (v === 'v7-liquid') return `${(value * 160).toFixed(1)} mL received`
  if (v === 'v7-tank') return `${(value * 1000).toFixed(1)} mL remaining`
  if (v === 'v7-valve') return value >= .999 ? 'open' : value <= .001 ? 'closed' : 'switching'
  if (v === 'v7-receiver') return value >= .999 ? 'received and held' : value <= .001 ? 'waiting below' : value < .45 ? 'fingers rising' : 'gripper closing'
  if (v === 'v7-head' || v === 'v7-sender') return value >= .999 ? 'closed' : value <= .001 ? 'open' : 'moving'
  if (v === 'v7-pitch-crosshead' || v === 'v7-pitch-receiver') return `Spacing ${(value * 1000).toFixed(0)} mm`
  if (v === 'v7-selective-crosshead') return 'Three-lane beam'
  if (v === 'v7-carriage') return `Lift ${(value * 400).toFixed(0)} mm`
  if (v === 'v7-rack' && pos) return `Descent ${(-pos[1] * 1000).toFixed(0)} mm`
  if (v === 'v7-pusher' && pos) return `Extension ${((pos[0] + .93) * 1000).toFixed(0)} mm`
  return 'Position linked'
}

export function MaterialV7Readout({ id, frame, className }: { id: string; frame: Frame; className: string }) {
  if (!id.startsWith('MAT-V7-')) return null
  const parts = Object.entries(frame.world?.parts ?? {}).filter(([, p]) => p.visible !== false)
  const count = (owner: string) => parts.filter(([, p]) => p.owner === owner).length
  const names = (owner: string) => parts.filter(([, p]) => p.owner === owner).map(([key]) => key).join(', ') || 'none'
  let title = '', detail = ''
  if (id === 'MAT-V7-D11') {
    title = `Actually received ${(frame.s.LIQUID * 160).toFixed(1)} mL · requested ${frame.words?.D10 ?? '—'} mL`
    detail = `Nozzle ${frame.x.X21 ? 'at receiver' : frame.x.X20 ? 'at top' : 'moving'} · valve ${frame.x.X22 ? 'open' : frame.x.X23 ? 'closed' : 'switching'} · pump ${frame.y.Y23 ? 'ON' : 'OFF'}`
  } else if (id === 'MAT-V7-D12') {
    title = `Gripper spacing ${(frame.s.CROSSHEAD * 1000).toFixed(0)} / receiver spacing ${(frame.s.RECEIVER * 1000).toFixed(0)} mm`
    detail = `Held ${count('tool')}/2 · received ${count('target')}/2`
  } else if (id === 'MAT-V7-D13') {
    title = `New sheet ${parts.find(([key]) => key === 'NEW')?.[1].owner === 'slot' ? 'stored' : 'in transit'} · ${parts.filter(([key]) => key.startsWith('OLD')).length} old sheets retained`
    detail = `Magazine descent ${(-(frame.world?.devices.RACK?.pos[1] ?? 0) * 1000).toFixed(0)} mm · current level ${frame.x.X25 ? frame.x.X24 ? 'occupied' : 'empty' : 'aligning'}`
  } else if (id === 'MAT-V7-D14') {
    title = `Workpiece held by ${parts[0]?.[1].owner === 'receiver' ? 'receiver' : parts[0]?.[1].owner === 'sender' ? 'sender' : 'none'}`
    detail = `Offer ${frame.y.Y23 ?? 0} · Ack ${frame.x.X23 ?? 0} · receiver custody ${frame.x.X25 ? 'confirmed' : 'unconfirmed'}`
  } else if (id === 'MAT-V7-D15') {
    title = `Received ${names('target')} · returned ${names('source')}`
    detail = `Still held ${names('tool')} · request mask ${frame.words?.D10 ?? '—'}`
  } else return null
  return <div className={className} data-testid="material-v7-readout" aria-label="Recorded physical state">
    <strong>{title}</strong><span>{detail}</span>
  </div>
}
