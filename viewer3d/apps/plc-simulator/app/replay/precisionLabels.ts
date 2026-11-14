const labels: Record<string, string> = {
  swept_collision: 'Collision detected along the motion path',
  premature_completion: 'Completion asserted before the requested result',
  result_not_held: 'Completion output or final position was not maintained',
  travel_limit: 'Actual position exceeded the axis travel range',
  target_out_of_range: 'Commanded position exceeded the axis travel range',
  collapsed_tool_before_traverse: 'Horizontal traverse before securing head width and clearance',
  traverse_at_height: 'Horizontal traverse before securing clearance height',
  fork_before_traverse: 'Carrier or lift moved before fork retraction',
  rise_outside: 'Head raised inside the press',
  precision_task_complete: 'Position and clearance request completed',
  motion_without_request: 'Mechanism moved without a request',
  conflicting_outputs: 'Forward and reverse outputs asserted together',
}
const results: Record<string, string> = {
  register: 'Datum registered', approach: 'Approach position reached', withdraw: 'Withdrawal confirmed',
  left_probe: 'First ram approach confirmed', left_clear: 'First ram withdrawn', right_probe: 'Second ram approach confirmed', right_clear: 'Second ram withdrawn',
  ram_clear: 'Ram passage cleared', indexed: 'Index position reached', datum_pair: 'Both datum faces registered',
  probe_access: 'Center ram approach', probe_clear: 'Center ram withdrawn', head_raised: 'Head raised clear',
  opposite_parks: 'Post-traverse position registered', head_lowered: 'Head at lower position', work_approach: 'Work datum approach', head_clear: 'Head withdrawn',
  datum_exposed: 'Datum exposed', datum_clear: 'Datum withdrawn', source_approach: 'Shared datum-space approach',
  inside: 'Inside datum registered', outside: 'Outside withdrawal', table_indexed: 'Fixture index confirmed', rotated_registration: 'Rotated fixture reapproached',
  side_register: 'Low datum side registration', head_outside: 'Head withdrawn outside', ram_approach: 'Ram approach confirmed',
  docked: 'Fork docked', fork_clear: 'Fork withdrawn', upper_fork_clear: 'Upper fork withdrawn',
  lower_registration: 'Lower datum registered', lower_docked: 'Lower fork docked', extended: 'Passage position reached',
  rod_clear: 'Pusher and rod withdrawn', side_approach: 'Side mechanism approach', stopped_before_ram: 'Decelerated and held before ram', ram_withdrawn: 'Ram withdrawn',
}
export function precisionReason(name: string): string {
  if (labels[name]) return labels[name]
  if (name.startsWith('precision_')) return 'Physical position, speed, or 40 ms registration hold condition not met'
  if (name.startsWith('function_registered_')) return 'Physical position and settling hold confirmed'
  if (name.startsWith('function_')) return results[name.slice(9)] ?? 'Mechanism position result confirmed'
  return name
}
