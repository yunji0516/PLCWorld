export const MIN_SCENE_WIDTH = 320
export const MIN_SCENE_HEIGHT = 160
export const clampSize = (value: number, min: number, max: number) =>
  Math.max(min, Math.min(Math.max(min, max), value))

/** Keep manual widths, but reclaim space when the viewport becomes narrower. */
export function fitPanelWidths(width: number, code: number | null, details: number | null, codeOpen: boolean, detailsOpen: boolean) {
  const codeMin = codeOpen ? 240 : 0
  const detailsMin = detailsOpen ? 220 : 0
  let left = codeOpen ? clampSize(code ?? clampSize(width * .23, 260, 370), codeMin, width * .5) : 0
  let right = detailsOpen ? clampSize(details ?? clampSize(width * .21, 240, 300), detailsMin, width * .5) : 0
  const excess = Math.max(0, left + right - (width - MIN_SCENE_WIDTH))
  const flexible = left + right - codeMin - detailsMin
  if (excess > 0 && flexible > 0) {
    const scale = Math.max(0, 1 - excess / flexible)
    left = codeMin + (left - codeMin) * scale
    right = detailsMin + (right - detailsMin) * scale
  }
  return { code: left, details: right }
}

export function signalHeightLimit(workspaceHeight: number, toolbarHeight: number, playbackHeight: number) {
  return Math.max(40, workspaceHeight - toolbarHeight - playbackHeight - MIN_SCENE_HEIGHT - 19)
}
