import type {Frame,TraceTask} from '@/lib/replay/adapter'
import {materialV8State} from './MaterialV8Readout'
import {materialV7State} from './MaterialV7Readout'

function deviceStateLabel(device: TraceTask['devices'][number], value: number, frame?: Frame): string {
  const easy = device.visual_variant ?? ''
  if (easy === 'easy15-contact-head' || easy === 'easy15-release-head') return value>=.999?'closed':value<=.001?'open':'moving'
  if (easy === 'easy15-left-weigh' || easy === 'easy15-right-weigh') return `${value.toFixed(0)} g load`
  if (easy === 'easy15-dose-liquid') return `${(value*160).toFixed(1)} mL received`
  if (easy === 'easy15-dose-source') return `${(value*1000).toFixed(1)} mL remaining`
  if (easy === 'easy15-source-bottle' || easy === 'easy15-recovery-bottle') return `${(value*40).toFixed(1)} mL`
  if (easy === 'easy15-visible-line') return `${(value*100).toFixed(0)}% remaining`
  if (easy === 'easy15-local-web') return `${(value*1000).toFixed(1)} mm deviation`
  if (easy === 'easy15-local-buffer') return `${(value*500).toFixed(1)} mm pulled`
  if (easy === 'easy15-feed-drive') return `${(value*180/Math.PI).toFixed(1)}° rotation`
  const advanced = materialV8State(device, value, frame)
  if (advanced) return advanced
  const extension = materialV7State(device, value, frame)
  if (extension !== undefined) return extension
  const variant = device.visual_variant ?? ''
  if (variant === 'motion-hard-cell' && frame?.world?.motion_hard?.dependency) return frame.world.motion_hard.success ? 'Task complete' : 'Task in progress'
  if (variant === 'motion-hard-cell') return frame?.world?.motion_hard?.success ? 'All requests complete' : 'Coordinating requests'
  if (variant.startsWith('motion-v08-')) {
    const e = frame?.world?.motion_easy_unit
    if (e) return e.violations.length ? 'Function condition violated' : e.success ? 'Result held' : Object.values(e.axes).some(a => Math.abs(a.velocity) > 1) ? 'Moving' : 'Idle / settled'
    const m=frame?.world?.motion_medium
    return m?.violations.length ? 'Path violation' : m?.success ? 'Result held' : Object.values(m?.axes ?? {}).some(a=>Math.abs(a.velocity_deg_s ?? a.velocity_mm_s ?? 0)>1) ? 'Moving' : 'Idle / settled'
  }
  if (variant === 'v6-buffer-dancer') return `${(value * 900).toFixed(1)} mm stored`
  if (variant === 'v6-buffer-ribbon') return `${(value * 500).toFixed(1)} mm pulled`
  if (variant === 'v6-buffer-spool') return `${(value * 180 / Math.PI).toFixed(1)}° rotation`
  if (variant === 'v6-stack-table') return `${(550 + value * 150).toFixed(1)} mm support height`
  if (variant.startsWith('v6-') && !variant.endsWith('-base') && variant !== 'v6-pocket-key' && variant !== 'v6-buffer-target') return `${Math.round(value * 100)}%`
  if (device.state_display?.kind === 'count') {
    return `${device.state_display.label} ${Math.round(value * device.state_display.scale)} items`
  }
  if (device.visual_variant === 'motion-easy-roll') return `${(value * 180 / Math.PI).toFixed(1)}° cumulative rotation`
  if (device.visual_variant === 'motion-holding-brake') return value > .5 ? 'Engaged' : 'Released'
  if (device.dynamic_world_position) return 'Tracks the moving axis'
  if (device.ui === 'sensor') return value > 0.5 ? 'ON' : 'OFF'
  return device.kind === 'static' ? 'Fixed' : `${Math.round(value * 100)}%`
}

export function recordedDeviceState(task:TraceTask,frame:Frame,id:string|null){
 if(!id||id==='CELL'||id==='TAPE_CELL'||id==='MATERIAL_CELL'||frame.s[id]===undefined)return null
 const device=task.devices.find(d=>d.id===id)
 return device?deviceStateLabel(device,frame.s[id],frame):null
}
