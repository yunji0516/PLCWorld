import type { Frame } from '@/lib/replay/adapter'

/** A labeled magnified measurement view; the actual 3D displacement is never amplified. */
export function MaterialEdgeReadout({frame,className,easy=false}:{frame:Frame;className?:string;easy?:boolean}){
 const edge=(frame.s.WEB??0)*1000,axis=(frame.world?.devices.STEER?.pos[2]??0)*1000
 const x=150+Math.max(-22,Math.min(22,edge))*5,ok=Math.abs(edge)<=12
 const correction=frame.y.Y20?'Adjusting toward −':frame.y.Y21?'Adjusting toward +':'Steering stopped'
 return <div className={className} data-testid="material-edge-readout" style={{width:310}}>
  <strong>Keep the moving web edge within ±12 mm</strong>
  <svg viewBox="0 0 300 112" role="img" aria-label={`Magnified edge diagram: deviation ${edge.toFixed(1)} mm, allowed ±12 mm`} style={{width:'100%',height:112}}>
   <text x="5" y="12" fill="#536e79" fontSize="10">Magnified edge · horizontal axis: deviation mm</text>
   <rect x="90" y="22" width="120" height="60" fill="#e3f0e9"/>
   <path d="M90 20V85 M210 20V85" stroke="#82a391" strokeDasharray="3 3"/>
   <rect x={x-45} y="27" width="45" height="50" fill="#d6b783"/>
   <path d={`M${x} 25V80`} stroke={ok?'#936b28':'#c34737'} strokeWidth="3"/>
   <path d="M150 20V85" stroke="#496878" strokeDasharray="4 3"/>
   <path d={`M${x-25} 40V65m-4-5 4 5 4-5`} fill="none" stroke="#7e632f" strokeWidth="1.5"/>
   <text x={Math.min(204,x+5)} y="49" fill="#705223" fontSize="10">{Math.abs(edge)>22?'outside diagram':'actual edge'}</text>
   <text x="77" y="100" fill="#496878" fontSize="11">−12</text><text x="146" y="100" fill="#496878" fontSize="11">0</text><text x="203" y="100" fill="#496878" fontSize="11">+12</text>
  </svg>
  <span>Web deviation <b>{edge.toFixed(1)} mm</b> · {ok?'within tolerance':'outside tolerance'}</span>
  <span>{correction} · steering axis {axis.toFixed(1)} mm</span>
  <span>{easy?(frame.x.X20?'External transport finished · edge held':'Edge held during external transport'):`Transport ${frame.words?.D21??0} / ${frame.words?.D10??0} mm · receiver clamp ${frame.x.X20?'complete':'pending'}`}</span>
 </div>
}
