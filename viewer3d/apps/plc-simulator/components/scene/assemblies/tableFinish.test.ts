import {expect,it} from 'vitest'
import {tablePartRole} from './tableFinish'

it('shares support and tabletop roles across both suites',()=>{
  for(const name of ['bench-leg','conveyor-support-leg','connected-frame-leg','structural-column','Support frame00'])
    expect(tablePartRole(name)).toBe('leg')
  for(const name of ['bench-top','v7-tabletop','easy-focus-tabletop','Machine base'])
    expect(tablePartRole(name)).toBe('top')
})
it('keeps functional contact surfaces and workpieces out of the furniture palette',()=>{
  for(const name of ['table-slide-jaw','roller-machined-shell','workpiece-1','conveyor-belt-support'])
    expect(tablePartRole(name)).toBeUndefined()
})
