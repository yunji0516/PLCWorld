import {expect,it} from 'vitest'
import {isDisplayPlinth,displayGroundOffset} from './displayPlinth'

it('removes only the floor display slab and its feet',()=>{
  expect(isDisplayPlinth({name:'base',pos:[.3,.04,.08],size:[1.12,.06,.82]})).toBe(true)
  expect(isDisplayPlinth({name:'foot-0.79-0.42',pos:[.79,.008,.42],size:[.1,.016,.08]})).toBe(true)
  expect(isDisplayPlinth({name:'Machine base',pos:[.04,.54,.04],size:[2.25,.12,1.35]})).toBe(false)
  expect(isDisplayPlinth({name:'base',node:'moving',pos:[0,.04,0],size:[1,.06,1]})).toBe(false)
})
it('lowers the whole assembly to its lowest fixed support without inventing feet',()=>{
  const base={name:'base',pos:[.3,.04,.08],size:[1.12,.06,.82]}
  const foot={name:'tool-foot',pos:[.3,.085,-.21],size:[.16,.035,.14]}
  expect(displayGroundOffset([base,foot])).toBeCloseTo(-.0675)
  expect(displayGroundOffset([foot])).toBe(0)
  expect(displayGroundOffset([base,foot,{...foot,node:'moving',pos:[0,-.2,0]}])).toBeCloseTo(-.0675)
})

it('grounds M13 existing motor, feet and columns without shifting contact poses',async()=>{
  const {groundedInstallationPart}=await import('./displayPlinth')
  const motor={name:'a-motor',pos:[0,.155,-.22],size:[.07,.1,.07]}
  const display=groundedInstallationPart(motor,13,-.02)
  expect(display.pos[1]-display.size[1]/2-.02).toBeCloseTo(0)
  const column={name:'aperture1-column',pos:[.03,.24,.15],size:[.055,.28,.06]}
  const grounded=groundedInstallationPart(column,13,-.02)
  expect(grounded.pos[1]+grounded.size[1]/2).toBeCloseTo(.38)
  expect(grounded.pos[1]-grounded.size[1]/2-.02).toBeCloseTo(.035)
  expect(groundedInstallationPart({...column,node:'contact'},13,-.02)).toEqual({...column,node:'contact'})
  expect(groundedInstallationPart(motor,12,-.02)).toBe(motor)
  expect(motor.pos[1]).toBe(.155)
})

it('adds a thin plate only to the twelve requested Medium tasks',async()=>{
 const {mediumMountingPlate}=await import('./displayPlinth')
 const parts=[{name:'base',pos:[0,.04,0],size:[4,.06,4]},{name:'mount-foot',pos:[0,.08,0],size:[1,.04,.8]},{name:'column',pos:[.6,.3,0],size:[.2,.6,.2]}]
 for(const task of [6,7,8,9,10,11,13,15,16,17,18,19]){
  const p=mediumMountingPlate(task,parts)!
  expect(p.thickness).toBe(.025)
  expect(p.x+p.width/2).toBeCloseTo(.74)
  expect(p.x-p.width/2).toBeCloseTo(-.54)
  const offset=displayGroundOffset(parts)
  expect(offset+p.thickness-offset-p.thickness/2-p.thickness/2).toBeCloseTo(0)
 }
 for(const task of [1,2,3,4,5,12,14,20])expect(mediumMountingPlate(task,parts)).toBeNull()
})
