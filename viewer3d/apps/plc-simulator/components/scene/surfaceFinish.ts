/** Satin finish for the detailed replay models; preserve already-matte rubber/paint. */
export function satinFinish(roughness: number, metalness: number) {
  return { roughness: Math.max(.62, roughness), metalness: Math.min(.72, metalness), envMapIntensity: .5 }
}
