type Vector = [number, number, number]
export type MountPart = { name: string; size: Vector; position: Vector }

/** Sensor-local coordinates. E13 lower carriage beam top is y=-.1275,
 * z=.035..155; the sensor bottom is -.055. Optical origin stays untouched. */
export const FORK_PHOTOEYE_MOUNT: MountPart[] = [
  { name: 'fork-photoeye-base-foot', size: [.14, .012, .10], position: [0, -.1215, .09] },
  { name: 'fork-photoeye-pedestal', size: [.07, .0445, .05], position: [0, -.09325, .085] },
  { name: 'fork-photoeye-shelf', size: [.13, .016, .15], position: [0, -.063, .035] },
]
export const FORK_PHOTOEYE_WEB = {
  sides: [-.050, .050], thickness: .010,
  yz: [[-.071, -.025], [-.071, .06], [-.1155, .06]] as [number, number][],
}
