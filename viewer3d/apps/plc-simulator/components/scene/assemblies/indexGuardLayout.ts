/** H05 visual enclosure. These are illustration clearances, not safety-rated
 * distances. Closed doors have no new I/O or simulated interlock behavior. */
export const INDEX_GUARD = {left:-1.62,right:1.72,rear:-1.55,front:1.53,height:2.32}
type Point=[number,number]
export type GuardBay={id:string;a:Point;b:Point;door?:boolean;outfeed?:boolean}
export const INDEX_GUARD_BAYS:GuardBay[]=[
 {id:'front-fixed-left',a:[-1.62,1.53],b:[-.82,1.53]},
 {id:'insert-access-left',a:[-.82,1.53],b:[.05,1.53],door:true},
 {id:'insert-access-right',a:[.05,1.53],b:[.92,1.53],door:true},
 {id:'front-fixed-right',a:[.92,1.53],b:[1.72,1.53]},
 {id:'body-side-rear',a:[1.72,-1.55],b:[1.72,-.55]},
 {id:'body-loading-access',a:[1.72,-.55],b:[1.72,.55],door:true},
 {id:'body-side-front',a:[1.72,.55],b:[1.72,1.53]},
 {id:'rework-side-rear',a:[-1.62,-1.55],b:[-1.62,-.45]},
 {id:'service-access',a:[-1.62,-.45],b:[-1.62,.75],door:true},
 {id:'rework-side-front',a:[-1.62,.75],b:[-1.62,1.53]},
 {id:'rear-fixed-left',a:[-1.62,-1.55],b:[-.28,-1.55]},
 {id:'outfeed-portal',a:[-.28,-1.55],b:[.28,-1.55],outfeed:true},
 {id:'rear-fixed-right',a:[.28,-1.55],b:[1.72,-1.55]},
]
export const INDEX_GUARD_POSTS:Point[]=Array.from(new Map(INDEX_GUARD_BAYS.flatMap(b=>[b.a,b.b]).map(p=>[p.join(':'),p])).values())
export function isRetiredIndexGuard(id:string){return /^(loader_guard_|insert_guard_)/.test(id)}
