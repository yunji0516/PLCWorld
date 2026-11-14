import type {V3} from './ReviewCanvas'
const mix=(a:V3,b:V3,t:number)=>a.map((v,k)=>v+(b[k]-v)*t) as V3
export const chuteHeight=(side:'a'|'b',x:number)=>side==='a'?.79-(x+1.25)*.05/1.41:.64+(x-1.25)*.05/1.41
/** Separate front/rear entries; every lane on each tray shares one physical plane. */
export function scrapPath(side:'a'|'b',slot:number):V3[]{
 const x=side==='a'?-.16:.16,y=chuteHeight(side,x)
 const start:V3=[side==='a'?-1.25:1.25,side==='a'?.79:.64,side==='a'?-.135+slot*.135:-.09+slot*.18]
 return [start,[x,y,side==='a'?.52+slot*.13:.55+slot*.20]]
}
export function pathPoint(path:V3[],u:number):V3{
 const lengths=path.slice(1).map((p,i)=>Math.hypot(p[0]-path[i][0],p[2]-path[i][2])),total=lengths.reduce((a,b)=>a+b,0)
 let distance=Math.max(0,Math.min(1,u))*total
 for(let i=0;i<lengths.length;i++){if(distance<=lengths[i]||i===lengths.length-1)return mix(path[i],path[i+1],distance/lengths[i]);distance-=lengths[i]}
 return path.at(-1)!
}
/** Straight gravity lanes stop short of the landing column; no horizontal corner. */
function chuteLane(id:string):V3[]{
 const side=id.includes('_a')?'a':'b',slot=Number(id.at(-1)),path=scrapPath(side,slot)
 const start=path[0],end=path[1],dx=end[0]-start[0],dz=end[2]-start[2],length=Math.hypot(dx,dz)
 const stop=mix(start,end,1-.14/length),nx=-dz/length*.061,nz=dx/length*.061
 return [[start[0]+nx,chuteHeight(side,start[0]+nx),start[2]+nz],
  [start[0]-nx,chuteHeight(side,start[0]-nx),start[2]-nz],
  [stop[0]-nx,chuteHeight(side,stop[0]-nx),stop[2]-nz],
  [stop[0]+nx,chuteHeight(side,stop[0]+nx),stop[2]+nz]]
}

/** Merge coplanar lanes into one sheet, avoiding overlapping metal skins. */
export function chuteTray(id:string):V3[]{
 if(!id.endsWith('0'))return []
 const side=id.includes('_a')?'a':'b',count=side==='a'?3:2
 const points=Array.from({length:count},(_,i)=>chuteLane(`scrap_chute_${side}${i}`)).flat().sort((a,b)=>a[0]-b[0]||a[2]-b[2])
 const cross=(a:V3,b:V3,c:V3)=>(b[0]-a[0])*(c[2]-a[2])-(b[2]-a[2])*(c[0]-a[0])
 const half=(pts:V3[])=>{const hull:V3[]=[];for(const p of pts){while(hull.length>1&&cross(hull.at(-2)!,hull.at(-1)!,p)<=0)hull.pop();hull.push(p)}hull.pop();return hull}
 return [...half(points),...half([...points].reverse())]
}
