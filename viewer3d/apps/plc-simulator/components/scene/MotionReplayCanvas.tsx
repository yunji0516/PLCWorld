'use client'

import { Component, Suspense, useEffect, useLayoutEffect, useRef, useState, type ReactNode } from 'react'
import { createRoot, events, extend, useFrame, type CanvasProps, type RootStore } from '@react-three/fiber'
import * as THREE from 'three'

extend(THREE as unknown as Parameters<typeof extend>[0])

class GraphBoundary extends Component<{ children: ReactNode; onError: (error: Error) => void }, { failed: boolean }> {
  state = { failed: false }
  static getDerivedStateFromError() { return { failed: true } }
  componentDidCatch(error: Error) { this.props.onError(error) }
  render() { return this.state.failed ? null : this.props.children }
}

type Props = Pick<CanvasProps, 'children' | 'camera' | 'shadows' | 'dpr' | 'gl' | 'onPointerMissed' | 'resize'>

/** Local diagnostics only: no requests, identifiers, or remote logging. */
function SceneHealth() {
  const next = useRef(0)
  useFrame(({ gl, scene, camera }) => {
    const now = performance.now()
    if (now < next.current) return
    next.current = now + 1000
    let equipmentMeshes = 0
    scene.traverse(object => {
      if (object.name.startsWith('motion-hard-hardware-') || object.name.startsWith('material-miniprocess-') || object.name.startsWith('material-mini-process-r8-') || object.name.startsWith('material-flowcell-r9-') || object.name.startsWith('composable-hardware-') || object.name.startsWith('material-v8-hardware-')) object.traverse(child => {
        if ((child as THREE.Mesh).isMesh) equipmentMeshes++
      })
    })
    // Opt-in local inspection: bound visible equipment, excluding floor/walls/labels.
    const deviceBounds: {id:string;min:number[];max:number[]}[] = []
    let floorInspection: {min:number[];max:number[];cornersNdc:number[][]} | undefined
    if (gl.domElement.dataset.inspectGeometry === '1') {
      scene.updateMatrixWorld(true)
      const paint=scene.getObjectByName('factory-floor-markings')
      if(paint){const b=new THREE.Box3().setFromObject(paint);floorInspection={min:b.min.toArray(),max:b.max.toArray(),cornersNdc:[b.min.x,b.max.x].flatMap(x=>[b.min.z,b.max.z].map(z=>new THREE.Vector3(x,.008,z).project(camera).toArray()))}}
      scene.traverse(root => {
        if (!root.name.startsWith('device-') && root.name !== 'replay-workpieces') return
        const box = new THREE.Box3()
        root.traverse(child => {
          const mesh = child as THREE.Mesh
          if (!mesh.isMesh) return
          let visible = true
          for (let n:THREE.Object3D|null=child;n;n=n.parent) if (!n.visible) visible=false
          if (!visible) return
          if (!mesh.geometry.boundingBox) mesh.geometry.computeBoundingBox()
          if (!mesh.geometry.boundingBox) return
          if ((mesh as THREE.InstancedMesh).isInstancedMesh) {
            const inst=mesh as THREE.InstancedMesh, matrix=new THREE.Matrix4()
            for(let i=0;i<inst.count;i++) { inst.getMatrixAt(i,matrix);matrix.premultiply(inst.matrixWorld);const b=mesh.geometry.boundingBox.clone().applyMatrix4(matrix);if(b.max.y>=0)box.union(b) }
          } else { const b=mesh.geometry.boundingBox.clone().applyMatrix4(mesh.matrixWorld);if(b.max.y>=0)box.union(b) }
        })
        if(!box.isEmpty())deviceBounds.push({id:root.name,min:box.min.toArray(),max:box.max.toArray()})
      })
    }
    gl.domElement.dataset.sceneHealth = JSON.stringify({
      renderer: 'motion-canvas-r3', updatedAt: Date.now(),
      drawFrames: gl.info.render.frame, drawCalls: gl.info.render.calls,
      deviceBounds, floorInspection, equipmentMeshes, contextLost: gl.getContext().isContextLost(),
      cameraValid: [...camera.matrixWorld.elements, ...camera.projectionMatrix.elements].every(Number.isFinite),
    })
  })
  return null
}

/**
 * The installed Canvas starts async configure() without catching its rejection.
 * Own that lifecycle so failed WebGL creation reaches the DOM SceneBoundary.
 * The scene, geometry, camera, pointer events and replay frames are unchanged.
 */
export function MotionReplayCanvas(props: Props) {
  const host = useRef<HTMLDivElement>(null)
  const latest = useRef(props)
  latest.current = props
  const rootRef = useRef<ReturnType<typeof createRoot<HTMLCanvasElement>> | null>(null)
  const storeRef = useRef<RootStore | null>(null)
  const [error, setError] = useState<Error | null>(null)

  useLayoutEffect(() => {
    const element = host.current
    if (!element) return
    // Each mount owns its canvas, including Strict Mode's setup/cleanup replay.
    // A delayed dispose must never destroy a subsequent mount's live context.
    const canvas = document.createElement('canvas')
    canvas.style.cssText = 'display:block;width:100%;height:100%'
    element.appendChild(canvas)
    const root = createRoot(canvas)
    rootRef.current = root
    let active = true, started = false
    let store: RootStore | null = null

    const render = () => root.render(<GraphBoundary onError={setError}>
      <SceneHealth />
      <Suspense fallback={null}>{latest.current.children}</Suspense>
    </GraphBoundary>)

    const measure = () => {
      const rect = element.getBoundingClientRect()
      if (!active || rect.width <= 0 || rect.height <= 0) return
      if (store) {
        store.getState().setSize(rect.width, rect.height, rect.top, rect.left)
        return
      }
      if (started) return
      started = true
      canvas.dataset.scenePhase = 'initializing'
      const config = latest.current
      void root.configure({
        camera: config.camera, shadows: config.shadows, dpr: config.dpr,
        gl: config.gl, events,
        size: { width: rect.width, height: rect.height, top: rect.top, left: rect.left },
        onPointerMissed: event => latest.current.onPointerMissed?.(event),
        // Drei HTML overlays use the event target as their DOM host.
        // Canvas fallback children are not displayed, so attach to the wrapper.
        onCreated: state => state.events.connect?.(element),
      }).then(() => {
        if (!active) return
        store = render()
        storeRef.current = store
        canvas.dataset.scenePhase = 'configured'
        measure()
      }).catch((reason: unknown) => {
        if (!active) return
        setError(reason instanceof Error ? reason : new Error(String(reason)))
      })
    }
    const observer = new ResizeObserver(measure)
    observer.observe(element)
    measure()
    return () => {
      active = false
      observer.disconnect()
      if (rootRef.current === root) { rootRef.current = null; storeRef.current = null }
      // Detach before disposal so intentional context loss is not a fault.
      canvas.remove()
      root.unmount()
    }
  }, [])

  useEffect(() => {
    if (!storeRef.current || !rootRef.current) return
    rootRef.current.render(<GraphBoundary onError={setError}>
      <SceneHealth />
      <Suspense fallback={null}>{props.children}</Suspense>
    </GraphBoundary>)
  }, [props.children])

  if (error) throw error
  return <div ref={host} data-testid="motion-replay-canvas"
    style={{ position: 'absolute', inset: 0, overflow: 'hidden' }} />
}
