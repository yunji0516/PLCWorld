/** Layout's base distance uses vertical FOV; portrait views need horizontal room. */
export function portraitFramingScale(width: number, height: number) {
  if (width <= 0 || height <= 0) return 1
  return Math.max(1, height / width)
}
