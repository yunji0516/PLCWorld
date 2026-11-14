/** Keep shadow depth offsets small relative to a 0.16-unit workpiece.
 * The old 499.5-unit depth span amplified a .0004 bias to ~.20 units.
 * Material and Motion share the same small industrial parts; only the editor
 * and non-benchmark scenes retain the legacy settings. The replay light uses
 * a 4096px map: a 4mm normal offset suppresses column self-shadow striping
 * without detaching the small workpiece/contact shadows.
 */
export function replayShadowSettings(suite?: string) {
  return suite === 'material' || suite === 'motion'
    ? { near: 0.5, far: 30, bias: -0.00015, normalBias: 0.004 }
    : { near: 0.5, far: 500, bias: -0.0004, normalBias: 0 }
}
