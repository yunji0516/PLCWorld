/** Canonical task IDs are shared by packages, traces and the UI. */
export const MOTION_MEDIUM20: Record<string, string> = Object.fromEntries(
  Array.from({ length: 20 }, (_, index) => {
    const id = `MOT-M${String(index + 1).padStart(2, '0')}`
    return [id, id]
  }),
)

/** A revised task can publish new records without mutating older evidence. */
export const MOTION_TASK_RELEASES: Record<string, string> = {
  'MOT-M14': 'motion-m14-table-slide-v12-20260914',
  'MOT-H01': 'motion-h01-mini-line-v3-20260914',
  ...Object.fromEntries(Array.from({length:14},(_,i)=>[`MOT-H${String(i+2).padStart(2,'0')}`, 'motion-hard15-mini-process-v4-20260914'])),
  ...Object.fromEntries(['MOT-H06','MOT-H07','MOT-H08','MOT-H09','MOT-H10'].map(id=>[id, 'motion-h06-h10-clearance-v6-20260914'])),
  ...Object.fromEntries(['MOT-H02','MOT-H03','MOT-H04','MOT-H05'].map(id=>[id, 'motion-h02-h05-clearance-v5-20260914'])),
  ...Object.fromEntries(['MOT-H09','MOT-H11','MOT-H12','MOT-H13','MOT-H14','MOT-H15'].map(id=>[id, 'motion-h09-h11-h15-clearance-v7-20260914'])),
  ...Object.fromEntries(['MOT-H09','MOT-H11'].map(id=>[id, 'motion-h09-h11-contact-fix-v8-20260914'])),
  ...Object.fromEntries(['MOT-H02','MOT-H03','MOT-H04','MOT-H05'].map(id=>[id, 'motion-h02-h05-bent-path-v9-20260915'])),
  ...Object.fromEntries(['MOT-H06','MOT-H07','MOT-H08','MOT-H09','MOT-H10'].map(id=>[id, 'motion-h06-h10-bent-path-v10-20260915'])),
  ...Object.fromEntries(['MOT-H06','MOT-H07'].map(id=>[id, 'motion-h06-h07-l-path-v11-20260915'])),
}

/** Active Hard IDs take precedence over aliases from the retired Hard suite. */
export const MOTION_HARD_TASKS: Record<string, string> = Object.fromEntries(
  Array.from({length:15},(_,i)=>{const id=`MOT-H${String(i+1).padStart(2,'0')}`;return [id,id]}),
)

/** Historical mapping is retained for provenance; active Hard IDs win below. */
export const MOTION_LEGACY_IDS: Record<string, string> = Object.fromEntries([
  'MOT-V07-D03', 'MOT-V07-D06', 'MOT-V07-D09', 'MOT-V08-D17', 'MOT-V08-D18',
  'MOT-H01', 'MOT-H02', 'MOT-H03', 'MOT-H04', 'MOT-H05',
  'MOT-H07', 'MOT-H08', 'MOT-H09', 'MOT-H10', 'MOT-H11',
  'MOT-H12', 'MOT-H13', 'MOT-H14', 'MOT-H15',
  'MOT-V07-D08',
].map((id, i) => [id, `MOT-M${String(i + 1).padStart(2, '0')}`]))

export function motionDisplayId(id: string): string {
  if (Object.hasOwn(MOTION_HARD_TASKS, id)) return id
  return MOTION_LEGACY_IDS[id] ?? id
}

export function motionInternalId(id: string | null): string | null {
  const oldEasy: Record<string, string> = { 'MOT-E-POS': 'MOT-E01', 'MOT-E-HOME': 'MOT-E02', 'MOT-E-STOP': 'MOT-E03', 'MOT-E-SPEED': 'MOT-E04' }
  if (id && oldEasy[id]) return oldEasy[id]
  if (id && Object.hasOwn(MOTION_HARD_TASKS, id)) return id
  return id ? MOTION_LEGACY_IDS[id] ?? id : null
}
