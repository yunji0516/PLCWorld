'use client'

import dynamic from 'next/dynamic'
import {useMemo,useRef} from 'react'
import type {LaidOutMachine} from '@/lib/machine/layout'
import type {Frame,Review} from './hard-processes/ReviewCanvas'

import {reviewFloorBounds} from './hard-processes/reviewBounds'

const Scene=dynamic(()=>import('./hard-processes/ReviewCanvas'),{ssr:false})

/** Scene only: H01's ReplayPage owns code, scan cursor, playback and verdicts. */
export default function StationReplayScene({review,run,index,machine,selectedDevice,onSelectDevice,showLabels,cameraView,cameraResetKey}:{
  review:Review;run:string;index:number;machine:LaidOutMachine;selectedDevice:string|null;onSelectDevice:(id:string|null)=>void;showLabels:boolean;cameraView:string;cameraResetKey:number
}) {
  const floorBounds=useMemo(()=>reviewFloorBounds(review),[review])
  const current=review.runs[run],frame=current.frames[Math.min(index,current.frames.length-1)]
  const ref=useRef<Frame>(frame);ref.current=frame
  return <div className="h-full w-full" data-model={review.id} data-geometry-revision={review.geometry_revision} data-time={frame.t} data-nodes={current.nodes.length} data-execution="st-closed-loop" data-floor-bounds={JSON.stringify(floorBounds)}>
    <Scene key={`${review.id}-${run}`} nodes={current.nodes} registeredOnly={review.geometry_revision?.startsWith('recorded-material-geometry/')} floorBounds={floorBounds} frame={ref} machine={machine} indexDetails={review.id==='H05'}
      selectedDevice={selectedDevice} onSelectDevice={onSelectDevice} showLabels={showLabels} cameraView={cameraView} cameraResetKey={cameraResetKey}/>
  </div>
}
