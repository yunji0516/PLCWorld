import type {Frame, Node, Pose} from '@/app/replay/hard-processes/ReviewCanvas'
import type {TraceTask} from './adapter'

export type RecordedGeometry = {
  schema: string
  task: string
  devices: TraceTask['devices']
  nodes: Node[]
  pose_table?: Pose[]
  frames: (Omit<Frame, 'poses'> & {scan:number; poses:Record<string, Pose | number>})[]
}

/** Resolve shared immutable poses without interpolating or dropping scans. */
export function recordedGeometryFrames(geometry: RecordedGeometry): Frame[] {
  return geometry.frames.map(frame => ({...frame,
    poses:Object.fromEntries(Object.entries(frame.poses).map(([id, value]) => {
      const pose = typeof value === 'number' ? geometry.pose_table?.[value] : value
      if (!pose) throw new Error(`Missing recorded pose for ${id}`)
      return [id, pose]
    })),
  }))
}
