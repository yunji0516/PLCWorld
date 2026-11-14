import { useThree } from '@react-three/fiber'
import { useEffect } from 'react'
import { PMREMGenerator } from 'three'
import { RoomEnvironment } from 'three/examples/jsm/environments/RoomEnvironment.js'

/** Locally generated soft-box reflections, no external HDR downloads. */
export function WorkshopReflections() {
  const { gl, scene } = useThree()
  useEffect(() => {
    const room = new RoomEnvironment()
    const generator = new PMREMGenerator(gl)
    const target = generator.fromScene(room, .12)
    const previous = scene.environment
    const previousIntensity = scene.environmentIntensity
    scene.environment = target.texture
    scene.environmentIntensity = .3
    room.dispose()
    generator.dispose()
    return () => {
      scene.environment = previous
      scene.environmentIntensity = previousIntensity
      target.dispose()
    }
  }, [gl, scene])
  return null
}
