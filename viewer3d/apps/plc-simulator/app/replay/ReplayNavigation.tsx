'use client'
import type { Trace } from '@/lib/replay/adapter'
import { materialDisplayId } from './materialCatalog'
import { motionDisplayId } from './motionCatalog'
import styles from './replay.module.css'

export function ReplayNavigation({trace, tid, suite, pick, setSuite}: {trace: Trace; tid: string; suite: string; pick: (id: string) => void; setSuite: (suite: string) => void}) {
  const task = trace[tid]
  const difficulty = task.difficulty ?? 'easy'
  const suites = ['motion', 'material']
  const names: Record<string, string> = {motion: 'Motion', material: 'Material', test: 'Test'}
  const levels = ['easy', 'medium', 'hard'].filter(level => Object.values(trace).some(t => (t.suite ?? 'other') === suite && (t.difficulty ?? 'easy') === level))
  const ids = Object.keys(trace).filter(id => (trace[id].suite ?? 'other') === suite && (trace[id].difficulty ?? 'easy') === difficulty)
    .sort((a,b) => suite === 'material' ? materialDisplayId(a).localeCompare(materialDisplayId(b), undefined, {numeric:true}) : 0)
  const position = ids.indexOf(tid)
  return <header className={styles.header} aria-label="Replay navigation">
    <div className={styles.filters}>
      <label className={styles.field}>Suite<select aria-label="Select suite" value={suite} onChange={e => {
        setSuite(e.target.value)
        const next = Object.keys(trace).find(id => (trace[id].suite ?? 'other') === e.target.value)
        if (next) pick(next)
      }}>{suites.map(s => <option key={s} value={s}>{names[s]}</option>)}</select></label>
      <label className={styles.field}>Difficulty<select aria-label="Select difficulty" value={levels.includes(difficulty) ? difficulty : ''} disabled={!levels.length} onChange={e => {
        const next = Object.keys(trace).find(id => (trace[id].suite ?? 'other') === suite && (trace[id].difficulty ?? 'easy') === e.target.value)
        if (next) pick(next)
      }}>{!levels.length && <option value="">None</option>}{levels.map(level => <option key={level} value={level}>{task.family === 'composable_v1' ? 'Composition experiment' : level[0].toUpperCase()+level.slice(1)}</option>)}</select></label>
    </div>
    <div className={styles.taskPicker}>
      <label className={`${styles.field} ${styles.taskField}`}>Task<select aria-label="Select task" value={ids.includes(tid) ? tid : ''} disabled={!ids.length} onChange={e => pick(e.target.value)}>
        {!ids.length && <option value="">No registered tasks</option>}
        {ids.map(id => <option key={id} value={id}>{motionDisplayId(materialDisplayId(id))} · {trace[id].title}{trace[id].review_hold ? ' · Review hold' : trace[id].family === 'material_hard_process_review' ? ' · 3D review' : trace[id].score_role === 'implementation_variant' ? ' · Comparison variant' : trace[id].candidate_status === 'review_pending' ? ' · Review candidate' : ''}</option>)}
      </select></label>
      <span className={styles.taskCount}>{Math.max(0,position+1)} / {ids.length}</span>
      <button aria-label="Previous task" className={styles.iconButton} disabled={position<=0} onClick={()=>pick(ids[position-1])}>←</button>
      <button aria-label="Next task" className={styles.iconButton} disabled={!ids.length || position>=ids.length-1} onClick={()=>pick(ids[position+1])}>→</button>
    </div>
  </header>
}
