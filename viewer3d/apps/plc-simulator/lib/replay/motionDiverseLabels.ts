export const DIVERSE_MOTION_LABELS: Record<string, string> = {
  table_slide: 'Rotary table and approach slide',
  articulated: 'Articulated robot', index_pin: 'Pin-lock indexing table', scissor: 'Outrigger scissor lift',
  door_recovery: 'Rack-driven sliding door', telescopic: 'Slewing telescopic boom', mobile: 'Differential-drive mobile robot',
  hoist: 'Wire-rope hoist', counterbalance: 'Counterweight tilting head', crank: 'Clutch-brake crank press', hexapod: 'Six-link hexapod',
}

export function motionDiverseLabel(variant?: string): string | undefined {
  return variant?.startsWith("motion-v08-") ? DIVERSE_MOTION_LABELS[variant.slice(11)] : undefined
}
