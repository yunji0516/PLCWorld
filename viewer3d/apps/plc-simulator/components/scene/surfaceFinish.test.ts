import { expect, it } from 'vitest'
import { satinFinish } from './surfaceFinish'

it('softens polished metal and attenuates reflections', () => {
  expect(satinFinish(.2, .95)).toEqual({ roughness: .62, metalness: .72, envMapIntensity: .5 })
})
it('does not make matte rubber or paint shinier', () => {
  expect(satinFinish(.9, .08)).toEqual({ roughness: .9, metalness: .08, envMapIntensity: .5 })
})
