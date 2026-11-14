import type {Frame,TraceTask,TraceRun} from '@/lib/replay/adapter'
/** Presentation reads recorded facts; it does not infer evaluator success from motion. */
export function executionOutcome(run:Pick<TraceRun,'goal'|'viol'|'frames'>,loading=false){
 if(loading)return 'loading'
 if(!run.frames.length)return 'unavailable'
 return run.goal&&run.viol.length===0?'PASS':'FAIL'
}
export function replayGroup(name:string){return name.startsWith('Reference')?'reference':name.startsWith('My runs')?'mine':name.startsWith('Paper sample')?'paper':'other'}
export function selectedReadings(task:TraceTask,frame:Frame,id:string|null){
 const device=task.devices.find(d=>d.id===id)
 const addresses=new Set([device?.drive,device?.at_min,device?.at_max,device?.slow,...(device?.sensors??[]).map(s=>s[0])].filter((a):a is string=>!!a))
 const values={...frame.x,...frame.y,...frame.words}
 return [...addresses].filter(a=>a in values).map(address=>({address,label:task.io[address]??address,value:values[address]}))
}
export function recordedParts(frame:Frame){
 const parts={...frame.world?.parts,...frame.world?.material_hard?.parts}
 return Object.entries(parts).map(([id,p])=>({id,owner:String(('held_by' in p?p.held_by:undefined)??p.owner??''),status:String(p.status??'')}))
}

export function failureFrameIndex(run:Pick<TraceRun,'frames'|'viol'>){
 const first=run.viol[0]?.k
 if(first===undefined)return Math.max(0,run.frames.length-1)
 const found=run.frames.findIndex(frame=>frame.k>=first)
 return found<0?Math.max(0,run.frames.length-1):found
}
