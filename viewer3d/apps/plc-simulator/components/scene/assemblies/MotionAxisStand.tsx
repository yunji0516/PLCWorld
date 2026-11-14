import {useContext} from 'react'
import {MotionCellFloorOffset} from './MotionPresentation'
import {MotionMachineBase} from './MotionMachineBase'
export function MotionAxisStand(){
 const rise=useContext(MotionCellFloorOffset)
 return <MotionMachineBase kind="casting" position={[1.35,-rise,0]} size={[1.25,.77+rise,.5]}/>
}
