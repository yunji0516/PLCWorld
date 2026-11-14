import dimensions from './counterbalance-layout.json'

/** Display attachment only: recorded X/rotation and all PLC/evaluator data stay unchanged. */
export function counterbalanceLayout(reader: { motionHardInstance?(): boolean; motionEasyMode?(): string | undefined }) {
  if (reader.motionHardInstance?.()) return { revision: 'legacy', dy: 0, y: .54, end: .65, span: 1.25 }
  const { endplateX } = reader.motionEasyMode?.() === 'balance' ? dimensions.easy : dimensions.medium
  return { revision: dimensions.revision, dy: dimensions.weightY - dimensions.recordedWeightY,
    y: dimensions.weightY, end: endplateX, span: 2 * endplateX }
}
