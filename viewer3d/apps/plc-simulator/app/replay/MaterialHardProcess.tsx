'use client'
import dynamic from 'next/dynamic'
import {useEffect, useMemo, useRef, useState} from 'react'
import type {Frame, Review} from './hard-processes/ReviewCanvas'
import styles from './materialHardProcess.module.css'
import {reviewFloorBounds} from './hard-processes/reviewBounds'
const Scene = dynamic(()=>import('./hard-processes/ReviewCanvas'),{ssr:false})
const labels: Record<string,string> = {normal:'Normal operation',alternate:'Order/delay variant',negative:'Core violation',negative_secondary:'Handoff violation'}
function show(v:unknown):string { return typeof v==='number' ? Number(v.toFixed(3)).toString() : typeof v==='boolean' ? (v?'yes':'no') : v===null ? 'none' : typeof v==='string' ? v : JSON.stringify(v) }

/** The existing Replay navigation owns task selection; this is its scene body. */
export default function MaterialHardProcess({id}:{id:string}) {
  const [data,setData]=useState<Review|null>(null),[error,setError]=useState(''),[variant,setVariant]=useState('normal'),[index,setIndex]=useState(0),[playing,setPlaying]=useState(false),[speed,setSpeed]=useState(1),[view,setView]=useState('perspective'),[details,setDetails]=useState(false),[showLabels,setShowLabels]=useState(true)
  const frameRef=useRef<Frame>({t:0,phase:'',poses:{},raw:{},received:[],requests:[]})
  useEffect(()=>{
    const controller=new AbortController()
    fetch(`/replay/hard-processes/data?task=${id}`,{cache:'no-store',signal:controller.signal}).then(async r=>{if(!r.ok)throw new Error('Could not read the machinery execution trace.');return r.json()}).then(setData).catch(e=>{if(!controller.signal.aborted)setError(e.message)})
    return ()=>controller.abort()
  },[id])
  const floorBounds=useMemo(()=>reviewFloorBounds(data),[data])
  const run=data?.runs[variant],frame=run?.frames[Math.min(index,run.frames.length-1)]
  if(frame)frameRef.current=frame
  useEffect(()=>{
    if(!playing || !run)return
    const start=performance.now(),initial=index
    const timer=setInterval(()=>{
      const time=run.frames[initial].t+(performance.now()-start)*speed/1000
      setIndex(previous=>{let next=previous;while(next<run.frames.length-1 && run.frames[next+1].t<=time)next++;if(next===run.frames.length-1)setPlaying(false);return next})
    },30)
    return ()=>clearInterval(timer)
  },[playing,run,speed])
  if(error)return <div className={styles.message} role="alert">{error}</div>
  if(!data || !run || !frame)return <div className={styles.message}>MAT-{id} Loading machinery execution trace…</div>
  const seek=(time:number)=>{setPlaying(false);const found=run.frames.findIndex(f=>f.t>=time);setIndex(found<0?run.frames.length-1:found)}
  return <section className={styles.workspace} data-hard-process={id} data-execution={data.execution || 'python-kinematic'}>
    <aside className={`${styles.description} ${details?styles.open:''}`}>
      <h2>MAT-{id} · {data.title}</h2><p>{data.primary}</p>
      <span className={styles.badge}>{data.execution==='st-closed-loop'?'ST closed-loop verification · synthetic machinery':'Redesigned machinery model · before formal PLC evaluation'}</span>
      {data.novelty && <p className={styles.muted}>{data.novelty}</p>}
      {data.redesign_review && <div className={styles.reviewNote}><b>Additional design review</b><p>{data.redesign_review}</p></div>}
      <h3>Select run</h3><div className={styles.variants}>{Object.entries(data.runs).map(([key,value])=><button key={key} aria-pressed={variant===key} onClick={()=>{setVariant(key);setIndex(0);setPlaying(false)}}>{value.label || labels[key] || key}</button>)}</div>
      <h3>Task requests</h3>{frame.requests.map(q=><div className={styles.request} key={q.id}><b>{q.id}</b><span>{q.state}</span></div>)}
      <p className={styles.muted}>{data.execution==='st-closed-loop'?'Replays material and device states from actual ST execution. The machinery layout is synthetic; benchmark admission and real-world validation are separate.':'Currently replays machinery and physical handoffs from a Python reference run. New ST control and cross-task overlap validation are pending.'}</p>
    </aside>
    <div className={styles.center}>
      <div className={styles.toolbar}><span>MAT-{id} · {data.title}</span><div><button onClick={()=>setShowLabels(!showLabels)} aria-pressed={showLabels}>Device labels</button><button onClick={()=>setDetails(!details)} aria-expanded={details}>Process information</button>{[['perspective','Perspective'],['front','Front'],['side','Side'],['top','Top']].map(([key,label])=><button key={key} aria-pressed={view===key} onClick={()=>setView(key)}>{label}</button>)}</div></div>
      <div className={styles.viewer} data-model={id} data-time={frame.t} data-nodes={run.nodes.length} data-floor-bounds={JSON.stringify(floorBounds)}>
        <Scene key={`${id}-${variant}`} nodes={run.nodes} floorBounds={floorBounds} frame={frameRef} cameraView={view} showLabels={showLabels}/>
        <span className={styles.unit}>{data.execution==='st-closed-loop'?'Synthetic layout · 0.25 m grid · drag to rotate / wheel to zoom':'Meters · 0.25 m grid · drag to rotate / wheel to zoom'}</span>
      </div>
      <div className={styles.phase} role="status">{run.failure && index===run.frames.length-1 ? `Violation detected · ${run.failure}` : frame.phase}</div>
      <div className={styles.transport}>
        <button onClick={()=>{if(index===run.frames.length-1)setIndex(0);setPlaying(!playing)}}>{playing?'Pause':'Play'}</button><button onClick={()=>{setPlaying(false);setIndex(0)}}>Start</button>
        <input type="range" aria-label="Replay time" min={0} max={run.frames.length-1} value={index} onChange={e=>{setPlaying(false);setIndex(+e.target.value)}}/>
        <output>{frame.t.toFixed(1)} / {run.duration.toFixed(1)} s</output><select aria-label="Playback speed" value={speed} onChange={e=>setSpeed(+e.target.value)}>{[1,2,4,8].map(n=><option key={n} value={n}>{n}×</option>)}</select>
      </div>
      <div className={styles.events}><h3>Operation and handoff log</h3>{run.events.map((event,i)=><button key={i} onClick={()=>seek(event.t)} data-past={event.t<=frame.t}><time>{event.t.toFixed(1)} s</time>{event.label}</button>)}</div>
    </div>
    <aside className={`${styles.observations} ${details?styles.open:''}`}><h3>Process observations</h3><dl>{Object.entries(frame.raw).map(([key,value])=><div key={key}><dt>{key}</dt><dd>{show(value)}</dd></div>)}</dl><h3>Physically received</h3><p>{frame.received.join(', ') || 'none'}</p></aside>
  </section>
}
