import {Part} from './Parts'
/** Replaces the old .12 x .09 x .55 arm. Joins the slide carriage to the
 * fixed housing's rear face, with a central opening for its pneumatic port.
 * The original device/recorded arm transform is retained. */
export function WideGripperRearYoke(){return <group name="wide-gripper-rear-yoke">
 <Part name="gripper-yoke-backbone" position={[0,-.0075,.014]} size={[.16,.04,.202]}/>
 {[-1,1].map(side=><Part key={side} name="gripper-yoke-ear" position={[side*.0525,-.0075,.1325]} size={[.055,.04,.035]}/>)}
</group>}
