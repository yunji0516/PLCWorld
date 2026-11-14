import {useEffect,useMemo} from 'react'
import {makeSlottedProfile} from '../profileGeometry'

/** Only upright structural members; sliding/contact surfaces keep their original geometry. */
export function isMotionProfile(name:string,size:readonly number[]){
 const [w,h,d]=size
 return /(?:support-column|structural-column|track-support|lift-mast|crane-column|press-column|reference-frame-post|door-track-post)$/.test(name)
  &&Math.min(w,d)>=.035&&h>Math.max(w,d)*2
}
export function MotionStructuralGeometry({size}:{size:readonly number[]}){
 const [w,h,d]=size
 const geometry=useMemo(()=>{const g=makeSlottedProfile(1,1);g.scale(w,h,d);return g},[w,h,d])
 useEffect(()=>()=>geometry.dispose(),[geometry])
 return <primitive object={geometry} attach="geometry"/>
}
