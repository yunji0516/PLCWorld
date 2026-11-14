import {expect,it} from 'vitest'
import {joinedBoxSurfaces} from './joinedBoxSurfaces'
function area(s:NonNullable<ReturnType<typeof joinedBoxSurfaces>>,size:number[]) {
 let total=0
 for(let i=0;i<s.positions.length;i+=9){
  const a=[0,1,2].map(k=>(s.positions[i+3+k]-s.positions[i+k])*size[k])
  const b=[0,1,2].map(k=>(s.positions[i+6+k]-s.positions[i+k])*size[k])
  const cross=[a[1]*b[2]-a[2]*b[1],a[2]*b[0]-a[0]*b[2],a[0]*b[1]-a[1]*b[0]]
  expect(cross.reduce((v,x,k)=>v+x*s.normals[i+k],0)).toBeGreaterThan(0)
  total+=Math.hypot(...cross)/2
 }
 return total
}
it('joins overlapping feet into one closed external skin without duplicate faces',()=>{
 const a={shape:'box',pos:[0,0,0],size:[2,1,1]},b={...a,pos:[1,0,0]}
 const parts=[a,b],original=JSON.stringify(parts)
 expect(parts.reduce((n,p,i)=>n+area(joinedBoxSurfaces(parts,i)!,p.size),0)).toBeCloseTo(14)
 expect(JSON.stringify(parts)).toBe(original)
})
it('removes only the covered part of a T-junction face',()=>{
 const parts=[{shape:'box',pos:[0,0,0],size:[3,1,1]},{shape:'box',pos:[0,1,0],size:[1,1,1]}]
 expect(parts.reduce((n,p,i)=>n+area(joinedBoxSurfaces(parts,i)!,p.size),0)).toBeCloseTo(18)
})
it('keeps independent moving and protected parts complete',()=>{
 const p={shape:'box',pos:[0,0,0],size:[1,1,1]}
 expect(joinedBoxSurfaces([p,{...p,node:'a'}],0)).toBeNull()
 expect(joinedBoxSurfaces([{...p,node:'protected-a'},{...p,node:'protected-a'}],0)).toBeNull()
 expect(joinedBoxSurfaces([p,{...p,shape:'hidden'}],0)).toBeNull()
})
