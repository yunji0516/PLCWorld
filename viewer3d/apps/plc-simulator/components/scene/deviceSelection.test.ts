import { describe, expect, it } from 'vitest'
import { Box3, BoxGeometry, Group, Mesh, MeshStandardMaterial, Vector3 } from 'three'
import { deviceBadgePosition, highlightDevice, equipmentSelectionTarget } from './deviceSelection'

describe('equipment selection', () => {
  it('tints only selected equipment and restores shared materials on deselection', () => {
    const original = new MeshStandardMaterial({color:'#123456'})
    const chosen = new Mesh(new BoxGeometry(), original)
    const other = new Mesh(new BoxGeometry(), original)
    const restore = highlightDevice(chosen)
    expect(chosen.material).not.toBe(original)
    expect(chosen.material.color.getHexString()).toBe('f0c16a')
    expect(other.material.color.getHexString()).toBe('123456')
    restore()
    expect(chosen.material).toBe(original)
  })
  it('anchors to equipment geometry and follows its movement, excluding hidden parts', () => {
    const root = new Group(), visible = new Mesh(new BoxGeometry(2, 2, 2))
    visible.position.set(3, 4, 5); root.add(visible)
    const hidden = new Mesh(new BoxGeometry(10, 10, 10)); hidden.visible=false; root.add(hidden)
    const p = deviceBadgePosition(root, new Vector3())
    expect(p.toArray()).toEqual([3, 4.13, 5])
    root.position.x=7;root.position.y=.5
    expect(deviceBadgePosition(root,new Vector3()).x).toBe(10)
    expect(deviceBadgePosition(root,new Vector3()).y).toBe(4.63)
    expect(deviceBadgePosition(root,new Vector3(),new Box3(),true).y).toBe(5.63)
  })
  it('supports meshes with several materials', () => {
    const materials = [new MeshStandardMaterial(), new MeshStandardMaterial()]
    const mesh = new Mesh(new BoxGeometry(), materials)
    const restore=highlightDevice(mesh)
    expect(mesh.material.every(m=>m.color.getHexString()==='f0c16a')).toBe(true)
    restore();expect(mesh.material).toBe(materials)
  })
})

describe('composite equipment selection',()=>{
 it('does not select the entire conveyor cell when an unnamed table surface is clicked',()=>{
  const cell=new Group(),assembly=new Group(),top=new Mesh(new BoxGeometry(),new MeshStandardMaterial());assembly.name='easy-single-piece-conveyor';top.name='easy-focus-tabletop';cell.add(assembly);assembly.add(top)
  expect(equipmentSelectionTarget(top,cell)).toBeUndefined()
 })
 it('selects an explicitly marked mechanism without including its neighboring table',()=>{
  const cell=new Group(),deck=new Group(),roller=new Mesh(new BoxGeometry(),new MeshStandardMaterial());deck.userData.deviceDisplayName='Conveyor';deck.add(roller);cell.add(deck)
  expect(equipmentSelectionTarget(roller,cell)).toBe(deck)
 })
})

it('ignores a named table leg under a functional conveyor group',()=>{
 const cell=new Group(),conveyor=new Group(),leg=new Mesh(new BoxGeometry(),new MeshStandardMaterial())
 conveyor.userData.deviceDisplayName='Conveyor';leg.name='conveyor-table-leg';cell.add(conveyor);conveyor.add(leg)
 expect(equipmentSelectionTarget(leg,cell)).toBeUndefined()
})

it('leaves support furniture untinted when its actuator is selected',()=>{
 const root=new Group(),motor=new Mesh(new BoxGeometry(),new MeshStandardMaterial({color:'#123456'})),leg=new Mesh(new BoxGeometry(),new MeshStandardMaterial({color:'#654321'}))
 motor.name='drive-motor';leg.name='table-leg';root.add(motor,leg)
 const restore=highlightDevice(root)
 expect(motor.material.color.getHexString()).toBe('f0c16a')
 expect(leg.material.color.getHexString()).toBe('654321')
 restore();expect(motor.material.color.getHexString()).toBe('123456')
})

it('does not expose a workpiece rail as equipment',()=>{
 const root=new Group(),stock=new Group(),rail=new Mesh(new BoxGeometry(),new MeshStandardMaterial())
 stock.userData.selectionDisabled=true;rail.name='magazine-cage-rail';root.add(stock);stock.add(rail)
 expect(equipmentSelectionTarget(rail,root)).toBeUndefined()
})
