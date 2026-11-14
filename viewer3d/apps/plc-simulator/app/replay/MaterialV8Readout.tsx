import type { Frame, TraceDevice } from '@/lib/replay/adapter'
import { MaterialEdgeReadout } from './MaterialEdgeReadout'
const captions:Record<string,[string,string[]]>={
 'MAT-V8-D16':['Aperture maintained',['Aperture mm','Insertion depth']],
 'MAT-V8-D17':['Scrap held separately · product dispatched',['Product head height mm','Scrap platen height mm']],
 'MAT-V8-D18':['Pocket correspondence',['Read ID','Index']],
 'MAT-V8-D19':['Piece ready → future contact point',['Remaining distance mm','Pocket speed mm/s']],
 'MAT-V8-D20':['Net quantity gathered → tray handoff',[]],
 'MAT-V8-D21':['Physical web alignment',['Web error mm','Fed length mm','Steering axis mm']],
 'MAT-V8-D22':['Pipe material identity',['Outlet material ID','Supply remaining mL']],
 'MAT-V8-D23':['Matching pair keys',['A key','B key']],
 'MAT-V8-D24':['Left/right load distribution',['Object 1 g','Object 2 g','Object 3 g','Object 4 g','Left g','Right g']],
 'MAT-V8-D25':['Span support maintained',['Sheet center mm']],
}
export function MaterialV8Readout({id,frame,className}:{id:string;frame:Frame;className?:string}){
 if(id==='MAT-V8-D21')return <MaterialEdgeReadout frame={frame} className={className}/>
 const info=captions[id];if(!info)return null
 const words=frame.words??{}
 return <div className={className} data-testid="material-v8-readout"><strong>{info[0]}</strong><div>{info[1].map((s,i)=>`${s}: ${words['D'+(20+i)]??0}`).join(' · ')}</div>{id==='MAT-V8-D17'&&<div>Scrap {frame.x.X21?'held on platen':'waiting on bed / not held'} · product {frame.x.X26?'received':frame.x.X20?'held by head':'before extraction'}</div>}{id==='MAT-V8-D19'&&<div>Piece {frame.x.X23?'ready at loading station':'before / during feed'} · feeder {frame.x.X24?'at home':'advancing / returning'} · pocket {frame.x.X22?'receiving':'waiting'}</div>}{id==='MAT-V8-D20'&&<div>A {frame.x.X20?'ON':'OFF'} · B {frame.x.X21?'ON':'OFF'} · external return {frame.x.X22?'active':'finished'} · transfer zone {frame.x.X23?'empty':'active'} · tray {frame.x.X25?'at receiver':'gathering / moving'}</div>}</div>
}

export function materialV8State(device:TraceDevice,value:number,frame?:Frame):string|undefined {
 const v=device.visual_variant;if(!v?.startsWith('v8-')&&!v?.startsWith('v13-'))return undefined
 if(v.endsWith('-base'))return 'Frame'
 if(v==='v8-scrap-platen'||v==='v8-mouth-pad'||v==='v8-vacuum-bed'||v==='v8-vacuum-head')return value>=.999?'vacuum held':value<=.001?'released':'switching'
 if(v==='v8-liquid-level')return `${(value*40).toFixed(1)} mL`
 if(v==='v8-carousel')return `${(value*180/Math.PI).toFixed(0)}°`
 if(v==='v8-diverter-valve')return value>=.999?'receiving direction':value<=.001?'recovery direction':'switching'
 const p=frame?.world?.devices[device.id]?.pos
 if(device.dynamic_world_position&&p)return p.map(x=>Math.round(x*1000)).join(' / ')+' mm'
 return 'Linked to physical state'
}
