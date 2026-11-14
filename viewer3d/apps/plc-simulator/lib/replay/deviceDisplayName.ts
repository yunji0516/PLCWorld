/** English presentation vocabulary; identifiers and trace states are unchanged. */
export function deviceDisplayName(name:string):string {return name.replace(/[_]+/g,' ')}

export function equipmentPartName(raw: string): string | undefined {
  const name = raw.toLowerCase().replace(/_/g, '-')
  const rules: [RegExp, string][] = [
    [/cabinet|control-box/, 'Control cabinet'],
    [/side-rail/, 'Conveyor side guide'],
    [/support-column|gauge-column|probe-post/, 'Support column'],
    [/footplate|mounting-plate|baseplate|bank-foot/, 'Mounting base'],
    [/support|pedestal|stand/, 'Support'],
    [/crosshead/, 'Crosshead'],
    [/gripper|grip(?!per)|jaw/, 'Gripper'],
    [/clamp/, 'Clamp'],
    [/cylinder/, 'Cylinder'],
    [/servo|motion-hard-rail/, 'Servo axis'],
    [/motor|drive-housing/, 'Drive motor'],
    [/bearing/, 'Bearing'],
    [/coupling/, 'Shaft coupling'],
    [/saddle|carriage/, 'Carriage'],
    [/rail|guide/, 'Guide rail'],
    [/conveyor|belt|surface/, 'Conveyor'],
    [/lift-platform/, 'Lift platform'],
    [/fork|insertion-tongue/, 'Transfer fork'],
    [/turntable|rotary-table/, 'Rotary table'],
    [/probe/, 'Measuring probe'],
    [/sensor/, 'Sensor'],
    [/roller|drum/, 'Roller'],
    [/reel|spool/, 'Reel'],
    [/shaft|rod/, 'Shaft'],
    [/bracket|mount/, 'Mounting bracket'],
    [/foot|leg/, 'Support leg'],
    [/frame|chassis/, 'Frame'],
    [/door/, 'Door'],
    [/handle/, 'Handle'],
    [/vent/, 'Vent'],
    [/guard|panel|cover/, 'Protective cover'],
    [/beam|cross/, 'Crossbeam'],
    [/base|bed/, 'Base'],
    [/flange/, 'Flange'],
    [/pin/, 'Locating pin'],
    [/stop/, 'Stopper'],
    [/tool/, 'Tool'],
  ]
  const type = rules.find(([pattern]) => pattern.test(name))?.[1]
  if (!type) return undefined
  const role = /receiver|receiving/.test(name) ? 'Receiving ' : /source|supply|feed/.test(name) ? 'Supply ' : /(?:^|-)out(?:put)?(?:-|$)|exit/.test(name) ? 'Outfeed ' : ''
  const axis = name.match(/(?:^|[-])([abcxyz])(?:[-]|$)/)?.[1]?.toUpperCase()
  return `${role}${type}${axis ? ` ${axis}` : ''}`
}
