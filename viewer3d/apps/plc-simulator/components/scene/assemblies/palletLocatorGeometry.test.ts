import { expect, test } from 'vitest'
import { DoubleSide, Mesh, MeshBasicMaterial, Raycaster, Vector3 } from 'three'
import { boredPlate } from './geometry'
import { LOCATE_GEOMETRY as g } from './PalletLocatorAssembly'

test('M08 pallet has real through bores at both locating pins', () => {
  const geo = boredPlate(.4,.64,.05,.008,g.pins.map(([x,z])=>({x,y:-z,radius:g.boreRadius})))
  const mat = new MeshBasicMaterial({side:DoubleSide}), mesh = new Mesh(geo,mat)
  mesh.rotation.x=-Math.PI/2;mesh.updateMatrixWorld(true)
  const cast=(x:number,z:number)=>new Raycaster(new Vector3(x,1,z),new Vector3(0,-1,0)).intersectObject(mesh)
  for (const [x,z] of g.pins) {
    for(let i=0;i<16;i++) {
      const a=i*Math.PI/8
      expect(cast(x+Math.cos(a)*g.pinRadius,z+Math.sin(a)*g.pinRadius)).toHaveLength(0)
    }
    expect(cast(x+.02,z).length).toBeGreaterThan(0)
  }
  expect(cast(0,0)[0].point.y).toBeCloseTo(.025,6)
  geo.dispose();mat.dispose()
})

test('M08 locator clears transport at home and lifts only pallet by 35 mm',()=>{
  expect(g.homeTop+g.pinHeight).toBeLessThan(g.beltTop)
  expect(g.homeTop+g.stroke-g.beltTop).toBeCloseTo(.035,8)
  for(let i=0;i<=100;i++) {
    const rise=g.stroke*i/100
    expect(.48+.065+rise).toBeCloseTo(g.homeTop+rise-g.plateThickness,8)
  }
})
