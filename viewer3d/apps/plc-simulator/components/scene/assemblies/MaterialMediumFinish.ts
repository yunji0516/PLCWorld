'use client'
import {createContext,useContext} from 'react'
import {TABLE_FINISH} from './tableFinish'
export const MaterialMediumFinish=createContext(false)
export const useMaterialMediumFinish=()=>useContext(MaterialMediumFinish)
/** Anchor plates match the dark supports; running rails retain the Hard alloy finish. */
export function mediumStructureFinish(name:string|undefined,size:number[],position:number[],color:string){
 const id=name??''
 if(/feed-axis-housing|gantry-linear-beam|under-bed-feed-bridge/.test(id))return '#a3afb9'
 if(/bench|table|belt|rubber|seal|contact|jaw|finger|hose|workpiece|cover|panel|gripper|pocket|nest|tray|motor|housing|cartridge/.test(id))return color
 const floorPlate=position[1]>=0&&position[1]<=.09&&size[1]<=.10&&Math.min(size[0],size[2])>=.20
 const rail=/rail|fixed-travel-beam|crosshead-beam|guide-track/.test(id)
 const unnamedRail=!name&&Math.max(size[0],size[2])>=.65&&size[1]<=.14&&Math.min(size[0],size[2])<=.18
 if(floorPlate||/anchor-foot|baseplate|mount-foot/.test(id))return TABLE_FINISH.leg
 return rail||unnamedRail?'#a3afb9':color
}
