import { describe, expect, it } from 'vitest'
import { Vector3 } from 'three'
import { aimPhotoeye, aimedPhotoeyeLength } from './photoeyeAim'

describe('targeted material photoeyes',()=>{
  it('does not clip the beam on an unoccupied magazine slot placeholder',()=>{
    const aim=aimPhotoeye([.70,.715,.40],[.70,.735,0])
    const part={x:.70,y:.735,z:0,materialDimensions:[.30,.03,.22] as [number,number,number]}
    const empty=aimedPhotoeyeLength(aim,.55,[],0)
    expect(aimedPhotoeyeLength(aim,.55,[{...part,visible:false}],0)).toBe(empty)
    expect(aimedPhotoeyeLength(aim,.55,[{...part,visible:true}],0)).toBeLessThan(empty)
  })
  it('points the lens axis at the declared target including the lens offset',()=>{
    const aim=aimPhotoeye([-.45,.99,-.29],[-.69,.735,.06])
    const toTarget=new Vector3(-.69,.735,.06).sub(aim.origin)
    expect(toTarget.clone().cross(aim.direction).length()).toBeLessThan(1e-8)
    expect(toTarget.dot(aim.direction)).toBeGreaterThan(0)
    expect(aim.direction.y).toBeLessThan(0)
  })
  it('keeps the three revised installations orthogonal and detects both datum offset extremes',()=>{
    const cases=[
      {p:[-.75,.715,.35],t:[-.75,.735,0],axis:[0,0,-1]},
      {p:[-.615,1.62,.105],t:[-.615,.735,.085],axis:[0,-1,0]},
      {p:[-1.14,.715,0],t:[-.85,.735,0],axis:[1,0,0]},
    ]
    for(const c of cases){
      const aim=aimPhotoeye(c.p as [number,number,number],c.t as [number,number,number])
      expect(aim.direction.distanceTo(new Vector3(...c.axis))).toBeLessThan(1e-8)
    }
    const aim=aimPhotoeye([-.615,1.62,.105],[-.615,.735,.085])
    for(const x of [0,.12])for(const z of [0,.12]){
      const part={x:-.75+x,y:.735,z,materialDimensions:[.3,.03,.18] as [number,number,number]}
      const length=aimedPhotoeyeLength(aim,.90,[part],0)
      expect(aim.origin.clone().addScaledVector(aim.direction,length).y).toBeCloseTo(.75,8)
    }
    expect(aim.origin.clone().addScaledVector(aim.direction,aimedPhotoeyeLength(aim,.90,[],0)).y).toBeCloseTo(.72,8)
  })
  it('ends on a 30 mm sheet, including rotated and offset parts',()=>{
    const aim=aimPhotoeye([-.45,.99,-.29],[-.69,.735,.06])
    for(const offset of [0,.12]) {
      const part={x:-.75+offset,y:.735,z:offset,materialDimensions:[.3,.03,.18] as [number,number,number]}
      const length=aimedPhotoeyeLength(aim,.65,[part],0)
      const hit=aim.origin.clone().addScaledVector(aim.direction,length)
      expect(length).toBeLessThan(.65-.058)
      expect(hit.y).toBeCloseTo(.75,8)
      expect(Math.abs(hit.x-part.x)).toBeLessThanOrEqual(.15)
      expect(Math.abs(hit.z-part.z)).toBeLessThanOrEqual(.09)
    }
    const part={x:-.75,y:.735,z:0,rotation:[0,Math.PI/2,0] as [number,number,number],materialDimensions:[.3,.03,.18] as [number,number,number]}
    const other=aimPhotoeye([-1.05,.99,-.28],[-.75,.735,0])
    expect(aimedPhotoeyeLength(other,.65,[part],0)).toBeLessThan(.592)
  })
  it('does not stop in empty space at the old generic cube envelope',()=>{
    const aim=aimPhotoeye([0,1,0],[0,0,0])
    const length=aimedPhotoeyeLength(aim,2,[{x:0,y:.4,z:0,materialDimensions:[.3,.03,.18]}],0)
    expect(aim.origin.clone().addScaledVector(aim.direction,length).y).toBeCloseTo(.415,8)
    expect(aimedPhotoeyeLength(aim,2,[],0)).toBe(2-.058)
  })
})
