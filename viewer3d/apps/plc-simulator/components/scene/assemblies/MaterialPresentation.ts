'use client'

import {createContext,useContext} from 'react'

/** Selected Material display family; never alters plant state or kinematics. */
export const MaterialPresentation=createContext(false)
export const useMaterialPresentation=()=>useContext(MaterialPresentation)
export const MATERIAL_WORKBENCH_BRIGHTNESS=.65
