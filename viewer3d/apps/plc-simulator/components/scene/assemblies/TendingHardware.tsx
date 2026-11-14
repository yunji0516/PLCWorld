import {FloorControlCabinet} from './FloorControlCabinet'
import { useFrame } from '@react-three/fiber'
import { useRef } from 'react'
import type { Group } from 'three'
import type { DeviceProps } from '../devices'
import { SocketBolt } from '../IndustrialDetails'
import {MaterialTableLegs} from './MaterialTableLegs'
import { FINISH, Part, RoundPart } from './Parts'
import {useMaterialPresentation,MATERIAL_WORKBENCH_BRIGHTNESS} from './MaterialPresentation'

export function TendingPlate({label,position,size=[.30,.065],color='#24485e'}:{label:string;position:[number,number,number];size?:[number,number];color?:string}){
  // Decorative station signage is omitted in the shared paper presentation.
  return null
}

/** Opt-in tending-cell fixtures. Legacy Easy/Medium hardware is unaffected. */
const coordinationLabels: Record<string,string> = {
  INFEED_A_STAND:'Supply A / IN', INFEED_B_STAND:'Supply B / IN',
  COMMON_BELT_STAND:'Shared transfer', ROUTE_DECK_STAND:'Destination routing',
  DESTINATION_1_STAND:'Destination 1 / OUT', DESTINATION_2_STAND:'Destination 2 / OUT',
  INBOUND_1_STAND:'Inbound P3', INBOUND_2_STAND:'Inbound P4', OUTBOUND_STAND:'Outbound P1 / P2',
  TRAY_IN_a_STAND:'Empty tray A', TRAY_IN_b_STAND:'Empty tray B',
  TRAY_WORK_a_STAND:'Workstation A / KIT', TRAY_WORK_b_STAND:'Workstation B / KIT',
  TRAY_OUT_a_STAND:'Completed tray A', TRAY_OUT_b_STAND:'Completed tray B',
}
export function TendingHardware({ device, plant }: DeviceProps) {
  const softenTop=useMaterialPresentation()&&device.id!=='ROBOT_PEDESTAL'
  const lowFixture=/^MAT-H01(?:\s|$)/.test(plant.machine.title)
  const jaw = useRef<Group>(null)
  const [w,h,d]=device.size
  useFrame(()=>{if(jaw.current)jaw.current.position.z=.18-.08*plant.state(device.id).pos})
  switch(device.visualVariant){
    case 'hard-workbench': return <group name="tending-workbench">
      {device.id!=='ROBOT_PEDESTAL' && <TendingPlate label={({A_BASE:'A / MACHINING',B_BASE:'B / MACHINING',SUPPLY_A:'A / INFEED',SUPPLY_B:'B / INFEED',BUFFER:'Buffer / WAIT',INSPECTION:'Depth inspection / INSPECT',REJECT_TRAY:'Reject isolation / NG',OUTFEED_STAND:'Accepted outfeed / OK'} as Record<string,string>)[device.id]??coordinationLabels[device.id]??device.id}
        color={device.id==='REJECT_TRAY'?'#9f2345':device.id==='OUTFEED_STAND'?'#087550':'#24485e'}
        position={[0,h/2-.04,-d/2-.003]} size={[Math.min(w-.04,.72),.075]}/>}
      <Part name="bench-top" size={[w,.04,d]} position={[0,h/2-.02,0]} brightness={softenTop?MATERIAL_WORKBENCH_BRIGHTNESS:1}/>
      <group position={[0,-h/2,0]}><MaterialTableLegs halfX={w/2-.05} halfZ={d/2-.05} top={h-.04}/></group>
    </group>
    case 'hard-sliding-door': return <group name="tending-sliding-door">
      {[-1,1].map(x=><Part key={x} name="door-stile" size={[.045,h,d]} position={[x*(w/2-.0225),0,0]} color={FINISH.blue}/>)}
      {[-1,1].map(y=><Part key={y} name="door-crossbar" size={[w-.09,.045,d]} position={[0,y*(h/2-.0225),0]} color={FINISH.blue}/>)}
      <Part name="door-kick-panel" size={[w-.09,.24,.02]} position={[0,-h/2+.165,0]}/>
      <mesh name="door-window" position={[0,.12,0]}><boxGeometry args={[w-.09,h-.35,.008]}/><meshStandardMaterial color="#92b7bf" transparent opacity={.12} roughness={.8} depthWrite={false}/></mesh>
      <Part name="door-handle" size={[.025,.20,.03]} position={[w/2-.075,0,-.05]} color={FINISH.dark}/>
    </group>
    case 'hard-locator-surround': return <group name="tending-open-locator">
      {/* Edge stops only: no plate intersects the supported workpiece. */}
      {[-1,1].map(x=><Part key={x} name="locator-edge" size={[.025,.035,d]} position={[x*(w/2-.0125),0,0]} color={FINISH.dark}/>)}
      <Part name="locator-back" size={[w-.05,.035,.02]} position={[0,0,d/2-.01]} color={FINISH.dark}/>
    </group>
    case 'hard-fixture-clamp': return <group name="tending-z-clamp">
      {/* H01 keeps the robot entry edge unobstructed; no added front jaw or under-table drive. */}
      {!lowFixture&&<Part name="clamp-front-jaw" size={[.12,.10,.025]} position={[0,.04,-.0925]} color={FINISH.dark}/>}
      <Part name="clamp-fixed-body" size={[.16,lowFixture?.035:.15,.14]} position={[0,lowFixture?-.0025:.075,.27]} color={FINISH.dark}/>
      {!lowFixture&&<Part name="clamp-slot" size={[.026,.004,.12]} position={[0,.152,.27]} color={FINISH.seal}/>}
      {[-1,1].map(x=><RoundPart key={x} name="clamp-guide" radius={lowFixture?.006:.009} length={.20} position={[x*.06,lowFixture?-.0025:.025,.18]}/>)}
      <group ref={jaw} position={[0,0,.18]}><Part name="clamp-contact-pad" size={[.12,lowFixture?.035:.10,.04]} position={[0,lowFixture?-.0025:.04,0]} color={FINISH.steel}/></group>
      {[-1,1].map(x=><SocketBolt key={x} top position={[x*.052,lowFixture?.0165:.152,.29]} radius={lowFixture?.003:.006}/>)}
    </group>
    case 'hard-spindle': return <group name="tending-spindle">
      <Part name="spindle-motor" size={[.18,.14,.18]} position={[0,.08,0]} color={lowFixture?FINISH.alloy:FINISH.blue}/>
      <RoundPart name="spindle-bearing" radius={.065} length={.08} axis="y" position={[0,-.03,0]}/>
      <RoundPart name="spindle-collet" radius={.032} length={.05} axis="y" position={[0,-.095,0]} color={FINISH.dark}/>
      <RoundPart name="spindle-tool" radius={.009} length={.03} axis="y" position={[0,-.135,0]} />
    </group>
    case 'hard-probe':return <group name="tending-contact-probe">
      <Part name="probe-slide" size={[.08,.05,.08]} position={[0,.025,0]} color={lowFixture?FINISH.alloy:FINISH.blue}/>
      <RoundPart name="probe-shank" radius={.014} length={.045} position={[0,-.0225,0]} axis="y"/>
      <RoundPart name="probe-contact" radius={.006} length={.015} position={[0,-.0525,0]} axis="y" color={FINISH.dark}/>
    </group>
    case 'hard-feed-belt':return ['MERGE_DECK','ROUTE_DECK'].includes(device.id) ? <group name="coordination-cross-transfer-deck">
      <Part name="transfer-deck-base" size={[w,.035,d]} position={[0,-.0225,0]} color={FINISH.dark}/>
      {Array.from({length:8},(_,i)=><RoundPart key={i} name="transfer-x-roller" radius={.019} length={d-.035} position={[-.22+i*.06,.021,0]}/>)}
      {[-.13,.11].map(x=><Part key={x} name="transfer-z-strip" size={[.014,.02,d-.04]} position={[x,.03,0]} color={FINISH.seal}/>)}
    </group> : <group name="tending-feed-belt">
      <Part name="belt-surface" size={[w,.018,d-.05]} position={[0,.021,0]} color={FINISH.seal}/>
      {[-1,1].map(z=><Part key={z} name="belt-side" size={[w,.055,.025]} position={[0,-.0025,z*(d/2-.0125)]}/>)}
      {[-1,1].map(x=><RoundPart key={x} name="belt-roller" radius={.025} length={d-.05} position={[x*(w/2-.026),-.013,0]} />)}
    </group>
    case 'hard-control-cabinet':return <group name="tending-control-cabinet" position={[0,-h/2,0]}><FloorControlCabinet width={w} height={h} depth={d}/></group>
    default:return null
  }
}
