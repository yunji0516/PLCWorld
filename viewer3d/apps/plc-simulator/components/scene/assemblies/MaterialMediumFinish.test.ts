import {describe,it,expect} from 'vitest'
import {mediumStructureFinish as finish} from './MaterialMediumFinish'
describe('Medium structure finishes',()=>{
 it('matches anchors to dark supports while retaining metal rails',()=>{
  expect(finish(undefined,[.6,.07,.5],[0,.035,0],'#365867')).toBe('#303b45')
  expect(finish('scrap-guide-anchor-foot',[.09,.07,.09],[0,.715,0],'#4d6a7b')).toBe('#303b45')
  expect(finish('linear-guide-rail',[.4,.028,.035],[0,1,0],'#35434e')).toBe('#a3afb9')
  expect(finish(undefined,[1.2,.08,.08],[0,1.5,0],'#47697e')).toBe('#a3afb9')
 })
 it('preserves working nests, grippers, tabletops and motor housings',()=>{
  for(const name of ['bench-top','v8-moving-pocket-deck','gripper-base','motor-housing','jaw-contact'])expect(finish(name,[.6,.07,.5],[0,.035,0],'#365867')).toBe('#365867')
 })
})
