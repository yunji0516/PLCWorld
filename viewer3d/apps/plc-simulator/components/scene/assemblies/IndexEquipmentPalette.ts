'use client'

import {createContext,useContext} from 'react'

/** Shared paper equipment finish for all Motion and Material tasks.
 * Workpieces and safety markings are outside this context / mapping. */
export const IndexEquipmentPalette = createContext<boolean|'bright'|'industrial'>(false)
const INDUSTRIAL_FINISH = {
 // Separate paint from metal by luminance as well as hue, including in print.
 // Preserve warm safety markings; do not rely on red/green distinctions.
 alloy:'#c4c8ca', steel:'#89939b', light:'#e4e5df',
 blue:'#39749a', dark:'#303b45', seal:'#171d22',
}
export function industrialEquipmentColor(color:string):string {
 const mapped=indexEquipmentColor(color)
 const entry=Object.entries(INDEX_FINISH).find(([,value])=>value===mapped)
 return entry?INDUSTRIAL_FINISH[entry[0] as keyof typeof INDUSTRIAL_FINISH]:color
}
export const INDEX_FINISH = {
 alloy:'#a3afb9', steel:'#7f8f9c', light:'#c3cbd0',
 blue:'#50768e', dark:'#35434e', seal:'#202b32',
}
// H05's dense gantries cast more shade than E06/M14. Lift its equipment paint
// and metal tones without changing the floor, workpieces or dark rubber.
const BRIGHT_FINISH = {
 alloy:'#bec8cf', steel:'#9daeb9', light:'#d1d9de',
 blue:'#7297b0', dark:'#4a5b68', seal:'#202b32',
}
export function indexEquipmentColor(color:string,bright=false):string {
 if(!/^#[0-9a-f]{6}$/i.test(color))return color
 const [r,g,b]=[1,3,5].map(i=>parseInt(color.slice(i,i+2),16))
 // Keep warm identification/safety colors. Consolidate cool metal/paint tones.
 if(r>g+12 || r>b+12)return color
 const hi=Math.max(r,g,b),lo=Math.min(r,g,b)
 const finish=bright?BRIGHT_FINISH:INDEX_FINISH
 if(hi<54)return finish.seal
 if(hi<83)return finish.dark
 if(hi<145 && hi-lo>28)return finish.blue
 if(hi<164)return finish.steel
 return hi<195?finish.alloy:finish.light
}
export function useIndexEquipmentColor(color:string) {
 const palette=useContext(IndexEquipmentPalette)
 if(palette==='industrial')return industrialEquipmentColor(color)
 return palette?indexEquipmentColor(color,palette==='bright'):color
}
export function useIndustrialSurface(color:string) {
 const palette=useContext(IndexEquipmentPalette)
 if(palette!=='industrial')return {}
 const mapped=indexEquipmentColor(color)
 const painted=mapped===INDEX_FINISH.blue||mapped===INDEX_FINISH.dark
 return {roughness:painted?.78:.48,metalness:painted?.16:.72,envMapIntensity:.45}
}
