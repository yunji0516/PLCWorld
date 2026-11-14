import {expect,it} from 'vitest'
import {recordedGeometryFrames, type RecordedGeometry} from './recordedGeometry'

it('preserves scan times and visibility when resolving shared recorded poses', () => {
  const pose = {p:[1,2,3] as [number,number,number],r:0,visible:true}
  const hidden = {...pose,visible:false}
  const base = {phase:'',raw:{},received:[],requests:[]}
  const geometry:RecordedGeometry = {schema:'recorded-material-geometry/2',task:'MAT-H07',devices:[],nodes:[],pose_table:[pose,hidden],frames:[
    {...base,scan:0,t:0,poses:{head:0}}, {...base,scan:1,t:.01,poses:{head:0}},
    {...base,scan:2,t:.02,poses:{head:1}},
  ]}
  const frames = recordedGeometryFrames(geometry)
  expect(frames.map(frame=>frame.t)).toEqual([0,.01,.02])
  expect(frames[0].poses.head).toBe(frames[1].poses.head)
  expect(frames[2].poses.head.visible).toBe(false)
  expect(geometry.frames[0].poses.head).toBe(0)
})
