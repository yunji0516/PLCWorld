/** Rendering may skip samples; evaluation traces and PLC scan time never change. */
export class PlaybackClock {
  private lastMs: number
  private carryMs = 0
  constructor(now: number, readonly scanMs: number, readonly rate: number) {
    if (!(scanMs > 0 && rate > 0)) throw new Error('Invalid replay clock')
    this.lastMs = now
  }
  reset(now: number) { this.lastMs = now; this.carryMs = 0 }
  advance(now: number) {
    this.carryMs += Math.max(0, now - this.lastMs) * this.rate
    this.lastMs = now
    const steps = Math.floor((this.carryMs + 1e-7) / this.scanMs)
    this.carryMs = Math.max(0, this.carryMs - steps * this.scanMs)
    return steps
  }
}
