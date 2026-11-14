'use client'
import {createContext,useContext,type Dispatch,type SetStateAction} from 'react'
export type ReplaySelection={id:string;name:string}
export type ReplayEquipment={key:string;id:string;name:string;poseId?:string;selected:boolean;select:()=>void}
export const ReplaySelectionContext=createContext<{equipment?:ReplayEquipment[];setEquipment?:Dispatch<SetStateAction<ReplayEquipment[]>>;selection:ReplaySelection|null;setSelection:Dispatch<SetStateAction<ReplaySelection|null>>}|null>(null)
export const useReplaySelection=()=>useContext(ReplaySelectionContext)
