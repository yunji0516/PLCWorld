import { expect, test } from 'vitest'
import { PlaybackClock } from './playbackClock'

for (const rate of [.25,.5,1,2,4]) test(`${rate}x follows elapsed simulation time, not frame count`,()=>{
  const c=new PlaybackClock(0,10,rate);let steps=0
  for(let i=1;i<=600;i++) steps+=c.advance(i*1000/60)
  expect(steps).toBe(1000*rate)
})
test('dropped render frames catch up without losing PLC samples',()=>{
  const c=new PlaybackClock(0,10,1)
  expect(c.advance(16)).toBe(1)
  expect(c.advance(1016)).toBe(100)
  expect(c.advance(1020)).toBe(1)
})
test('pause / hidden tab reset does not jump ahead on resume',()=>{
  const c=new PlaybackClock(0,10,1);c.advance(15);c.reset(10000)
  expect(c.advance(10010)).toBe(1)
})
