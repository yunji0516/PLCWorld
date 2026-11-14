'use client'
import type {ReactNode} from 'react'
import type {CameraView} from '@/components/scene/Scene3D'
import {replayUiText,type ReplayLocale} from './replayUiText'
import styles from './replay.module.css'
export function ReplayToolbar({locale,activeView,showLabels,statusOpen,onView,onLabels,onStatus,onReset,onReload,diagnostics}:{locale?:ReplayLocale;activeView:CameraView|null;showLabels:boolean;statusOpen:boolean;onView:(view:CameraView)=>void;onLabels:()=>void;onStatus:()=>void;onReset:()=>void;onReload:()=>void;diagnostics:ReactNode}){
 const t=replayUiText(locale)
 return <div className={styles.cameraActions} data-testid="replay-toolbar">
  {(['front','side','top'] as const).map(view=><button key={view} type="button" className={styles.button} aria-pressed={activeView===view} onClick={()=>onView(view)}>{t[view]}</button>)}
  <button type="button" className={styles.button} aria-pressed={showLabels} onClick={onLabels}>{t.labels}</button>
  <button type="button" className={styles.button} aria-expanded={statusOpen} aria-controls="replay-status" onClick={onStatus}>{t.status}</button>
  <button type="button" className={styles.button} onClick={onReset}>{t.reset}</button>
  <details className={styles.troubleshooting} data-testid="replay-troubleshooting"><summary className={styles.button}>{t.help}</summary><div className={styles.troubleshootingBody}>
   <p>{t.helpNote}</p><button type="button" className={styles.button} onClick={onReload}>{t.reload}</button>{diagnostics}
  </div></details>
 </div>
}
