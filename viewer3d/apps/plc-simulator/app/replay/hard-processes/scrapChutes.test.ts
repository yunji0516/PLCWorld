import {describe,it,expect} from 'vitest'
import {Box3,Vector3,Triangle} from 'three'
import {chuteTray,scrapPath,pathPoint} from './scrapChutes'
const triangles=['scrap_chute_a0','scrap_chute_a1','scrap_chute_a2','scrap_chute_b0','scrap_chute_b1'].flatMap(id=>{
 const points=chuteTray(id).map(v=>new Vector3(...v))
 return points.slice(2).map((v,i)=>new Triangle(points[0],points[i+1],v))
})
const clear=(p:number[])=>{
 const box=new Box3(new Vector3(p[0]-.06,p[1]-.003,p[2]-.06),new Vector3(p[0]+.06,p[1]+.003,p[2]+.06))
 return !triangles.some(t=>box.intersectsTriangle(t))
}
describe('H12 nonintersecting scrap trays',()=>{
 it('uses a straight descending path for each gravity lane',()=>{
  for(const side of ['a','b'] as const)for(let slot=0;slot<(side==='a'?3:2);slot++){const p=scrapPath(side,slot);expect(p).toHaveLength(2);expect(p[1][1]).toBeLessThan(p[0][1])}
 })
 it('supports full-size scraps above the tray, including neighbouring lanes',()=>{
  for(const side of ['a','b'] as const)for(let slot=0;slot<(side==='a'?3:2);slot++)for(let i=0;i<=100;i++){
   const p=pathPoint(scrapPath(side,slot),i/100);p[1]+=.01;expect(clear(p),`${side}${slot} slide ${i}`).toBe(true)
  }
 })
 it('keeps every landing column clear of every tray, not only its own',()=>{
  for(const side of ['a','b'] as const)for(let slot=0;slot<(side==='a'?3:2);slot++){
   const end=scrapPath(side,slot).at(-1)!
   for(let y=.5;y<=end[1]+.01;y+=.005)expect(clear([end[0],y,end[2]]),`${side}${slot} fall ${y}`).toBe(true)
  }
 })
})
