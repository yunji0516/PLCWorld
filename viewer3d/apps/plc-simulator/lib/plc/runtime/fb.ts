/** Implement IEC 61131-3 stateful function blocks with millisecond scan timing. */
import type { IecValue } from '../types'

export interface FbDef {

  inputs: string[]

  outputs: string[]

  init(): FbState

  call(s: FbState, get: (name: string) => IecValue | undefined, dt: number): void
}

export interface FbState {

  out: Record<string, IecValue>

  mem: Record<string, number | boolean>

  in: Record<string, IecValue>
}

const bool = (v: IecValue | undefined, dflt = false): boolean =>
  v === undefined ? dflt : typeof v === 'boolean' ? v : Number(v) !== 0

const num = (v: IecValue | undefined, dflt = 0): number =>
  v === undefined ? dflt : typeof v === 'boolean' ? (v ? 1 : 0) : Number(v) || 0

const TON: FbDef = {
  inputs: ['IN', 'PT'],
  outputs: ['Q', 'ET'],
  init: () => ({ out: { Q: false, ET: 0 }, mem: {}, in: {} }),
  call(s, get, dt) {
    const IN = bool(get('IN'))
    const PT = num(get('PT'))
    if (!IN) {
      s.out.ET = 0
      s.out.Q = false
      return
    }
    const et = Math.min(PT, num(s.out.ET) + dt)
    s.out.ET = et
    s.out.Q = et >= PT
  },
}

const TOF: FbDef = {
  inputs: ['IN', 'PT'],
  outputs: ['Q', 'ET'],
  init: () => ({ out: { Q: false, ET: 0 }, mem: {}, in: {} }),
  call(s, get, dt) {
    const IN = bool(get('IN'))
    const PT = num(get('PT'))
    if (IN) {
      s.out.ET = 0
      s.out.Q = true
      return
    }
    if (!s.out.Q) {
      s.out.ET = PT
      return
    }
    const et = Math.min(PT, num(s.out.ET) + dt)
    s.out.ET = et
    s.out.Q = et < PT
  },
}

const TP: FbDef = {
  inputs: ['IN', 'PT'],
  outputs: ['Q', 'ET'],
  init: () => ({ out: { Q: false, ET: 0 }, mem: { prev: false, running: false }, in: {} }),
  call(s, get, dt) {
    const IN = bool(get('IN'))
    const PT = num(get('PT'))
    const prev = !!s.mem.prev
    if (!s.mem.running && IN && !prev) {
      s.mem.running = true
      s.out.ET = 0
      s.out.Q = true
    } else if (s.mem.running) {
      const et = Math.min(PT, num(s.out.ET) + dt)
      s.out.ET = et
      if (et >= PT) {
        s.out.Q = false

        if (!IN) {
          s.mem.running = false
          s.out.ET = 0
        }
      }
    }
    s.mem.prev = IN
  },
}

const CTU: FbDef = {
  inputs: ['CU', 'R', 'PV'],
  outputs: ['Q', 'CV'],
  init: () => ({ out: { Q: false, CV: 0 }, mem: { prev: false }, in: {} }),
  call(s, get) {
    const CU = bool(get('CU'))
    const R = bool(get('R'))
    const PV = num(get('PV'))
    if (R) {
      s.out.CV = 0
    } else if (CU && !s.mem.prev) {
      s.out.CV = Math.min(32767, num(s.out.CV) + 1)
    }
    s.out.Q = num(s.out.CV) >= PV
    s.mem.prev = CU
  },
}

const CTD: FbDef = {
  inputs: ['CD', 'LD', 'PV'],
  outputs: ['Q', 'CV'],
  init: () => ({ out: { Q: false, CV: 0 }, mem: { prev: false }, in: {} }),
  call(s, get) {
    const CD = bool(get('CD'))
    const LD = bool(get('LD'))
    const PV = num(get('PV'))
    if (LD) {
      s.out.CV = PV
    } else if (CD && !s.mem.prev) {
      s.out.CV = Math.max(-32768, num(s.out.CV) - 1)
    }
    s.out.Q = num(s.out.CV) <= 0
    s.mem.prev = CD
  },
}

const CTUD: FbDef = {
  inputs: ['CU', 'CD', 'R', 'LD', 'PV'],
  outputs: ['QU', 'QD', 'CV'],
  init: () => ({ out: { QU: false, QD: false, CV: 0 }, mem: { prevU: false, prevD: false }, in: {} }),
  call(s, get) {
    const CU = bool(get('CU'))
    const CD = bool(get('CD'))
    const R = bool(get('R'))
    const LD = bool(get('LD'))
    const PV = num(get('PV'))
    if (R) s.out.CV = 0
    else if (LD) s.out.CV = PV
    else {
      let cv = num(s.out.CV)
      if (CU && !s.mem.prevU) cv++
      if (CD && !s.mem.prevD) cv--
      s.out.CV = Math.max(-32768, Math.min(32767, cv))
    }
    s.out.QU = num(s.out.CV) >= PV
    s.out.QD = num(s.out.CV) <= 0
    s.mem.prevU = CU
    s.mem.prevD = CD
  },
}

const R_TRIG: FbDef = {
  inputs: ['CLK'],
  outputs: ['Q'],
  init: () => ({ out: { Q: false }, mem: { prev: false }, in: {} }),
  call(s, get) {
    const CLK = bool(get('CLK'))
    s.out.Q = CLK && !s.mem.prev
    s.mem.prev = CLK
  },
}

const F_TRIG: FbDef = {
  inputs: ['CLK'],
  outputs: ['Q'],
  init: () => ({ out: { Q: false }, mem: { prev: true }, in: {} }),
  call(s, get) {
    const CLK = bool(get('CLK'))
    s.out.Q = !CLK && !!s.mem.prev
    s.mem.prev = CLK
  },
}

const RS: FbDef = {
  inputs: ['SET', 'RESET1'],
  outputs: ['Q1'],
  init: () => ({ out: { Q1: false }, mem: {}, in: {} }),
  call(s, get) {
    if (bool(get('RESET1'))) s.out.Q1 = false
    else if (bool(get('SET'))) s.out.Q1 = true
  },
}

const SR: FbDef = {
  inputs: ['SET1', 'RESET'],
  outputs: ['Q1'],
  init: () => ({ out: { Q1: false }, mem: {}, in: {} }),
  call(s, get) {
    if (bool(get('SET1'))) s.out.Q1 = true
    else if (bool(get('RESET'))) s.out.Q1 = false
  },
}

export const BUILTIN_FBS: Record<string, FbDef> = {
  TON, TOF, TP, CTU, CTD, CTUD, R_TRIG, F_TRIG, RS, SR,
}

export function fbOutputNames(type: string): string[] {
  return BUILTIN_FBS[type]?.outputs ?? []
}
