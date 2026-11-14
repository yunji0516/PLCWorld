/** Decorative machining follows each part's local dimensions, never its replay pose. */
export function motionFittingLayout(name:string,size:readonly number[]) {
  if(size.length!==3||size.some(v=>!Number.isFinite(v)||v<=0))return null
  const [w,h,d]=size
  if(name==='servo-motor-housing')return null // ServoAssembly owns its fitted motor ribs.
  if(/(?:gripper|jaw|contact|protected|tongue|finger|tool|rod|screw|rail-seat|moving)/.test(name))return null
  const foot=/(?:footplate|foot|anchor-plate)$/.test(name)&&w>.12&&d>.12&&h<.18
  const motor=/(?:motor-housing|drive-motor|gearbox-housing|reducer|drive-end|motor)$/.test(name)&&Math.min(w,h,d)>.055
  const cabinet=/(?:cell-adapter-base|slide-support|service-housing)$/.test(name)&&w>.3&&h>.16&&d>.2
  const post=/(?:track-support|crane-column|press-column|lift-mast|support-column)$/.test(name)&&h>.25
  if(!foot&&!motor&&!cabinet&&!post)return null
  return {kind:foot?'foot':motor?'motor':cabinet?'cabinet':'post',w,h,d,
    boltRadius:Math.min(.008,Math.min(w,d)*.055),inset:Math.min(.045,Math.min(w,d)*.18)} as const
}
