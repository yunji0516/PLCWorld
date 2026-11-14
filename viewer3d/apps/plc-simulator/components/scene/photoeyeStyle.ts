/** The ray is an explanatory overlay, not a luminous solid rod. */
export const PHOTOEYE_STYLE = {
  rayRadius: .0032,
  // CSS-pixel diameter cap, not a target/minimum width when zooming out.
  rayMaxPixels: 1.6,
  rayIdleOpacity: .52,
  rayDetectingOpacity: .65,
  lensColor: '#381e24',
  statusIdleEmission: .025,
  statusDetectingEmission: .55,
} as const

/** Backward-compatible alias; both suites deliberately share one style. */
export const MATERIAL_PHOTOEYE_STYLE = PHOTOEYE_STYLE

/** Cap close-up thickness without enlarging the beam at a distance.
 * There is deliberately no minimum-pixel floor when zooming out. */
export function photoeyeRadialScale(worldRadius: number, depth: number, projectionY: number, viewportHeight: number, orthographic = false) {
  if (worldRadius <= 0 || projectionY <= 0 || viewportHeight <= 0 || (!orthographic && depth <= 0)) return 1
  const pixels = worldRadius * projectionY * viewportHeight / (orthographic ? 1 : depth)
  if (!Number.isFinite(pixels) || pixels <= 0) return 1
  return Math.min(1, PHOTOEYE_STYLE.rayMaxPixels / pixels)
}
