/** Shared furniture finish across every suite and renderer. */
export const TABLE_FINISH = {
  leg: '#303b45',
  top: '#a1a5a7',
  roughness: .88,
  metalness: .18,
  envMapIntensity: .25,
} as const

export function tablePartRole(name = ''): 'leg' | 'top' | undefined {
  if (/(?:leg|stretcher|upright|underframe|support-column|structural-column|support-pedestal|frame-lower-tie|Support frame|Leveling foot)/i.test(name)) return 'leg'
  if (/^(?:bench-top|easy-workbench-top|v8-fixed-deck|m04-folded-support-deck|single-contact-deck|web-table-top|v7-tabletop|easy-focus-tabletop|Machine base)$/.test(name)) return 'top'
}
