import type { Frame } from '@/lib/replay/adapter'
import { MaterialEdgeReadout } from './MaterialEdgeReadout'

/** Diagnostics read recorded response/ownership, never the success verdict. */
export function MaterialEasyReadout({id,frame,className}:{id:string;frame:Frame;className:string}) {
 const n=Number(id.match(/^MAT-EASY15-E(\d+)$/)?.[1]);if(![1,2,8,9,10,11,12,13,14].includes(n))return null
 if(n===11)return <MaterialEdgeReadout frame={frame} className={className} easy/>
 const s=frame.s??{},w=frame.words??{},parts=frame.world?.parts??{}
 let title='',detail='',note=''
 if(n===1||n===2){
  const value=s[n===1?'HEAD':'TOOL']??0,owner=parts[n===1?'PRODUCT':'P1']?.owner
  title=n===1?(owner==='tool'?'Gripper closed · product held':value>0?'Gripper closing':'Gripper open · product on support'):(owner==='target'?'Gripper open · product placed on receiver':value<1?'Gripper opening':'Gripper closed · product held')
  detail=`Close command ${frame.y.Y20?'ON':'OFF'} · no horizontal or vertical transfer`
  note=''
 }else if(n===8){
  const count=Object.values(parts).filter(p=>p.pos[0]-(p.material_dimensions?.[0]??.18)/2>=.12-1e-7).length
  title=count?'Trailing edge crossed':'Before the receipt boundary';detail=`Photoeye ${frame.x.X20?'blocked':'clear'} · one-way feed ${frame.y.Y20?'ON':'OFF'}`
 }else if(n===9){title=`Actually received ${((s.LIQUID??0)*160).toFixed(1)} mL · requested ${w.D10??'—'} mL`;detail=`Pump cumulative delivery ${w.D21??0} mL · fixed nozzle`}
 else if(n===10){title=`Web buffer ${w.D20??'—'} mm · allowed 200–700 mm`;detail=`Feed ${frame.y.Y20?'ON':'OFF'} · external pull ${frame.x.X20?'finished':'not started / active'}`}
 else if(n===11){title=`Actual edge deviation ${((s.WEB??0)*1000).toFixed(1)} mm · allowed ±12 mm`;detail=`Steering travel ${((frame.world?.devices.STEER?.pos[2]??0)*1000).toFixed(1)} mm · external transport section`}
 else if(n===13){title=`Single-piece routing · requested key ${w.D10??'—'}`;detail=`Current key ${w.D20||'source empty'} · ${frame.y.Y20?'moving to accept position':frame.y.Y21?'moving to bypass position':frame.x.X20?'waiting at home':'pusher returning'}`;note='The overhead X/Z axes move the contact pusher.'}
 else if(n===14){title=`Piece ${w.D20??0} g · left/right received load`;detail=`Left ${w.D21??0} g / ${frame.x.X22?'ready':'no free slot'} · right ${w.D22??0} g / ${frame.x.X23?'ready':'no free slot'}`;note=frame.y.Y20?'← moving left':frame.y.Y21?'moving right →':'transport stopped · receiver and existing stock retained'}
 else {title=`Pipe outlet ID ${w.D20??'—'} · requested ID ${w.D10??'—'}`;detail=`Residual section ${((s.LINE??0)*100).toFixed(0)}% · pump ${frame.y.Y20?'ON':'OFF'}`;note='Ochre: previous material · teal: new material. Mixing quality is not evaluated.'}
 return <div className={className} data-testid="material-easy-readout"><strong>{title}</strong><span>{detail}</span>{note&&<span>{note}</span>}</div>
}
