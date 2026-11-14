/** Define IEC values, types, symbols, addresses, and display conversion. */
export type IecType = 'BOOL' | 'INT' | 'DINT' | 'WORD' | 'REAL' | 'TIME' | 'STRING'

export type IecValue = boolean | number | string

export type VarScope = 'input' | 'output' | 'memory' | 'temp' | 'global' | 'inout'

export interface PlcAddress {
  raw: string
  area: 'I' | 'Q' | 'M'
  size: 'X' | 'B' | 'W' | 'D'
  byte: number
  bit: number
}

export interface VarDecl {
  name: string

  key: string
  type: IecType
  scope: VarScope
  address?: PlcAddress
  initial?: IecValue
  comment?: string

  fbType?: string

  dim?: [number, number]

  line?: number
}

export const normKey = (name: string): string => name.toUpperCase()

export function defaultValue(type: IecType): IecValue {
  switch (type) {
    case 'BOOL':
      return false
    case 'STRING':
      return ''
    default:
      return 0
  }
}

export interface Diagnostic {
  severity: 'error' | 'warning' | 'info'
  message: string
  line: number
  col: number
  length?: number
}

export class PlcError extends Error {
  constructor(
    message: string,
    public line = 0,
    public col = 0,
    public length = 1,
  ) {
    super(message)
    this.name = 'PlcError'
  }
  toDiagnostic(): Diagnostic {
    return {
      severity: 'error',
      message: this.message,
      line: this.line,
      col: this.col,
      length: this.length,
    }
  }
}

export function parseAddress(raw: string): PlcAddress | null {
  const m = /^%([IQM])([XBWD]?)(\d+)(?:\.(\d+))?$/i.exec(raw.trim())
  if (!m) return null
  const area = m[1].toUpperCase() as 'I' | 'Q' | 'M'
  const size = (m[2] || 'X').toUpperCase() as 'X' | 'B' | 'W' | 'D'
  return {
    raw: raw.trim().toUpperCase(),
    area,
    size,
    byte: Number(m[3]),
    bit: m[4] ? Number(m[4]) : 0,
  }
}

export function typeFromAddress(a: PlcAddress): IecType {
  switch (a.size) {
    case 'X':
      return 'BOOL'
    case 'B':
      return 'INT'
    case 'W':
      return 'INT'
    case 'D':
      return 'DINT'
  }
}

export function isNumericType(t: IecType): boolean {
  return t === 'INT' || t === 'DINT' || t === 'WORD' || t === 'REAL' || t === 'TIME'
}

export function coerce(value: IecValue, type: IecType): IecValue {
  switch (type) {
    case 'BOOL':
      return typeof value === 'boolean' ? value : Number(value) !== 0
    case 'REAL':
      return typeof value === 'boolean' ? (value ? 1 : 0) : Number(value)
    case 'STRING':
      return String(value)
    case 'INT':
    case 'DINT':
    case 'WORD':
    case 'TIME': {
      const n = typeof value === 'boolean' ? (value ? 1 : 0) : Number(value)
      return Math.trunc(n)
    }
  }
}

export function formatTime(ms: number): string {
  if (!isFinite(ms)) return 'T#0ms'
  let rest = Math.max(0, Math.trunc(ms))
  const h = Math.floor(rest / 3_600_000)
  rest -= h * 3_600_000
  const m = Math.floor(rest / 60_000)
  rest -= m * 60_000
  const s = Math.floor(rest / 1000)
  const msec = rest - s * 1000
  let out = ''
  if (h) out += `${h}h`
  if (m) out += `${m}m`
  if (s) out += `${s}s`
  if (msec || !out) out += `${msec}ms`
  return `T#${out}`
}

export function formatValue(v: IecValue, type: IecType): string {
  if (type === 'TIME') return formatTime(Number(v))
  if (typeof v === 'boolean') return v ? 'TRUE' : 'FALSE'
  if (typeof v === 'number') return Number.isInteger(v) ? String(v) : v.toFixed(3)
  return String(v)
}
