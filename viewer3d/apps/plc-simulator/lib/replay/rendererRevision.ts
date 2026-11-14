/** Bump with replay renderer capabilities; shared by API and browser. */
export const REPLAY_RENDERER_REVISION = 'plcworld-industrial-appearance-20261114-r7'
export const REPLAY_RENDERER_HEADER = 'x-plc-renderer-revision'
export function replayRendererMatches(server: string | null) {
  return !server || server === REPLAY_RENDERER_REVISION
}
