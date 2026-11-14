/** Execute PLC programs within the scan cycle using symbol and function-block state. */
import {
  PlcError,
  coerce,
  defaultValue,
  normKey,
  type IecValue,
  type VarDecl,
} from '../types'
import type { CallArg, Expr, Pou, Stmt, StProgram } from '../st/ast'
import { BUILTIN_FBS, type FbState } from './fb'
import { STD_FUNCTIONS } from './functions'

const WATCHDOG_ITERATIONS = 200_000

export interface FbInstance {
  type: string

  builtin?: FbState

  userScope?: Scope
}

export interface Sym {
  decl: VarDecl
  value: IecValue
  array?: IecValue[]
  fb?: FbInstance

  forced?: IecValue
}

export class Scope {
  vars = new Map<string, Sym>()
  constructor(public parent?: Scope, public label = '') {}

  lookup(key: string): Sym | undefined {
    return this.vars.get(key) ?? this.parent?.lookup(key)
  }
  declare(decl: VarDecl): Sym {
    const sym: Sym = {
      decl,
      value: decl.initial ?? defaultValue(decl.type),
    }
    if (decl.dim) {
      const [lo, hi] = decl.dim
      sym.array = new Array(Math.max(0, hi - lo + 1)).fill(decl.initial ?? defaultValue(decl.type))
    }
    if (decl.fbType) {
      const b = BUILTIN_FBS[decl.fbType]
      sym.fb = { type: decl.fbType, builtin: b ? b.init() : undefined }
    }
    this.vars.set(decl.key, sym)
    return sym
  }
}

const enum Flow {
  Normal = 0,
  Exit = 1,
  Continue = 2,
  Return = 3,
}

const asBool = (v: IecValue): boolean =>
  typeof v === 'boolean' ? v : typeof v === 'number' ? v !== 0 : v.length > 0

const asNum = (v: IecValue): number =>
  typeof v === 'boolean' ? (v ? 1 : 0) : typeof v === 'number' ? v : Number(v) || 0

export interface TagInfo {
  name: string
  key: string
  decl: VarDecl

  pou: string
}

export class PlcRuntime {
  globals = new Scope(undefined, 'GLOBAL')

  programs: { pou: Pou; scope: Scope }[] = []

  private fbDefs = new Map<string, Pou>()
  private funcDefs = new Map<string, Pou>()

  scanCount = 0

  elapsed = 0

  fault: PlcError | null = null

  private iterations = 0
  private dt = 0

  constructor(private program: StProgram) {
    this.build()
  }

  private build(): void {
    for (const g of this.program.globals) this.globals.declare(g)

    for (const pou of this.program.pous) {
      if (pou.kind === 'FUNCTION_BLOCK') {
        this.fbDefs.set(normKey(pou.name), pou)
      } else if (pou.kind === 'FUNCTION') {
        this.funcDefs.set(normKey(pou.name), pou)
      }
    }

    for (const pou of this.program.pous) {
      if (pou.kind !== 'PROGRAM') continue
      const scope = new Scope(this.globals, pou.name)
      for (const v of pou.vars) this.declareIn(scope, v)
      this.programs.push({ pou, scope })
    }
  }

  private declareIn(scope: Scope, decl: VarDecl): Sym {
    const sym = scope.declare(decl)

    if (decl.fbType && !BUILTIN_FBS[decl.fbType]) {
      const def = this.fbDefs.get(decl.fbType)
      if (def) {
        const inner = new Scope(this.globals, `${decl.name}:${def.name}`)
        for (const v of def.vars) this.declareIn(inner, v)
        sym.fb = { type: decl.fbType, userScope: inner }
      }
    }
    return sym
  }

  reset(): void {
    this.globals = new Scope(undefined, 'GLOBAL')
    this.programs = []
    this.fbDefs.clear()
    this.funcDefs.clear()
    this.scanCount = 0
    this.elapsed = 0
    this.fault = null
    this.build()
  }

  findSym(name: string): Sym | undefined {
    const key = normKey(name)
    const g = this.globals.vars.get(key)
    if (g) return g
    for (const p of this.programs) {
      const s = p.scope.vars.get(key)
      if (s) return s
    }
    return undefined
  }

  get(name: string): IecValue | undefined {
    const s = this.findSym(name)
    if (!s) return undefined
    return s.forced ?? s.value
  }

  set(name: string, value: IecValue): boolean {
    const s = this.findSym(name)
    if (!s) return false
    s.value = coerce(value, s.decl.type)
    return true
  }

  force(name: string, value: IecValue | undefined): void {
    const s = this.findSym(name)
    if (!s) return
    s.forced = value === undefined ? undefined : coerce(value, s.decl.type)
  }

  listTags(): TagInfo[] {
    const out: TagInfo[] = []
    for (const [key, s] of this.globals.vars) {
      if (s.decl.fbType) continue
      out.push({ name: s.decl.name, key, decl: s.decl, pou: 'GLOBAL' })
    }
    for (const p of this.programs) {
      for (const [key, s] of p.scope.vars) {
        if (s.decl.fbType) continue
        if (out.some((t) => t.key === key)) continue
        out.push({ name: s.decl.name, key, decl: s.decl, pou: p.pou.name })
      }
    }
    return out
  }

  listFbInstances(): { name: string; type: string; state: FbState }[] {
    const out: { name: string; type: string; state: FbState }[] = []
    const visit = (scope: Scope) => {
      for (const s of scope.vars.values()) {
        if (s.fb?.builtin) out.push({ name: s.decl.name, type: s.fb.type, state: s.fb.builtin })
      }
    }
    visit(this.globals)
    this.programs.forEach((p) => visit(p.scope))
    return out
  }

  snapshot(): Record<string, IecValue> {
    const out: Record<string, IecValue> = {}
    for (const t of this.listTags()) {
      const s = this.findSym(t.key)
      if (s) out[t.key] = s.forced ?? s.value
    }
    return out
  }

  scan(dt: number): void {
    this.dt = Math.max(0, dt)
    this.iterations = 0
    this.fault = null
    try {
      for (const { pou, scope } of this.programs) {
        this.execBlock(pou.body, scope)
      }
    } catch (e) {
      this.fault = e instanceof PlcError ? e : new PlcError(String((e as Error)?.message ?? e))
    }
    this.scanCount++
    this.elapsed += this.dt
  }

  private tick(pos?: { line: number; col: number }): void {
    if (++this.iterations > WATCHDOG_ITERATIONS) {
      throw new PlcError(
        `Watchdog: exceeded ${WATCHDOG_ITERATIONS} iterations in one scan. Check for a non-terminating loop.`,
        pos?.line ?? 0,
        pos?.col ?? 0,
      )
    }
  }

  private execBlock(body: Stmt[], scope: Scope): Flow {
    for (const s of body) {
      const f = this.execStmt(s, scope)
      if (f !== Flow.Normal) return f
    }
    return Flow.Normal
  }

  private execStmt(s: Stmt, scope: Scope): Flow {
    this.tick(s.pos)
    switch (s.k) {
      case 'assign':
        this.assign(s.target, this.evalExpr(s.value, scope), scope)
        return Flow.Normal

      case 'call':
        this.invoke(s.name, s.args, scope, s.pos)
        return Flow.Normal

      case 'if': {
        for (const br of s.branches) {
          if (asBool(this.evalExpr(br.cond, scope))) return this.execBlock(br.body, scope)
        }
        return s.orElse ? this.execBlock(s.orElse, scope) : Flow.Normal
      }

      case 'case': {
        const v = asNum(this.evalExpr(s.selector, scope))
        for (const br of s.cases) {
          if (br.labels.some((l) => v >= l.lo && v <= l.hi)) return this.execBlock(br.body, scope)
        }
        return s.orElse ? this.execBlock(s.orElse, scope) : Flow.Normal
      }

      case 'for': {
        const key = normKey(s.varName)
        let sym = scope.lookup(key)
        if (!sym) {

          sym = scope.declare({ name: s.varName, key, type: 'INT', scope: 'temp' })
        }
        const from = asNum(this.evalExpr(s.from, scope))
        const to = asNum(this.evalExpr(s.to, scope))
        const by = s.by ? asNum(this.evalExpr(s.by, scope)) : 1
        if (by === 0) throw new PlcError('FOR BY cannot be zero', s.pos.line, s.pos.col)
        for (let i = from; by > 0 ? i <= to : i >= to; i += by) {
          this.tick(s.pos)
          sym.value = i
          const f = this.execBlock(s.body, scope)
          if (f === Flow.Exit) break
          if (f === Flow.Return) return f
        }
        return Flow.Normal
      }

      case 'while': {
        while (asBool(this.evalExpr(s.cond, scope))) {
          this.tick(s.pos)
          const f = this.execBlock(s.body, scope)
          if (f === Flow.Exit) break
          if (f === Flow.Return) return f
        }
        return Flow.Normal
      }

      case 'repeat': {
        for (;;) {
          this.tick(s.pos)
          const f = this.execBlock(s.body, scope)
          if (f === Flow.Exit) break
          if (f === Flow.Return) return f
          if (asBool(this.evalExpr(s.until, scope))) break
        }
        return Flow.Normal
      }

      case 'exit':
        return Flow.Exit
      case 'continue':
        return Flow.Continue
      case 'return':
        return Flow.Return
    }
  }

  private assign(target: Expr, value: IecValue, scope: Scope): void {
    if (target.k === 'var') {
      const sym = this.need(target.name, scope, target.pos)
      sym.value = coerce(value, sym.decl.type)
      return
    }
    if (target.k === 'index') {
      if (target.obj.k !== 'var') {
        throw new PlcError('Invalid array assignment target', target.pos.line, target.pos.col)
      }
      const sym = this.need(target.obj.name, scope, target.pos)
      if (!sym.array || !sym.decl.dim) {
        throw new PlcError(`${target.obj.name} is not an array`, target.pos.line, target.pos.col)
      }
      const idx = asNum(this.evalExpr(target.idx, scope)) - sym.decl.dim[0]
      if (idx < 0 || idx >= sym.array.length) {
        throw new PlcError(
          `Array index out of bounds: ${target.obj.name}[${idx + sym.decl.dim[0]}]`,
          target.pos.line, target.pos.col,
        )
      }
      sym.array[idx] = coerce(value, sym.decl.type)
      return
    }
    if (target.k === 'member') {
      if (target.obj.k !== 'var') {
        throw new PlcError('Invalid member assignment target', target.pos.line, target.pos.col)
      }
      const sym = this.need(target.obj.name, scope, target.pos)
      if (!sym.fb) {
        throw new PlcError(`${target.obj.name} is not a function-block instance`, target.pos.line, target.pos.col)
      }
      const prop = target.prop.toUpperCase()
      if (sym.fb.builtin) {
        sym.fb.builtin.in[prop] = value
      } else if (sym.fb.userScope) {
        const inner = sym.fb.userScope.vars.get(prop)
        if (!inner) {
          throw new PlcError(`${sym.fb.type} has no member ${target.prop}`, target.pos.line, target.pos.col)
        }
        inner.value = coerce(value, inner.decl.type)
      }
      return
    }
    throw new PlcError('Target is not assignable', target.pos.line, target.pos.col)
  }

  private need(name: string, scope: Scope, pos: { line: number; col: number }): Sym {
    const sym = scope.lookup(normKey(name))
    if (!sym) {
      throw new PlcError(
        `Undeclared variable: ${name}; add it to a VAR block`,
        pos.line, pos.col, name.length,
      )
    }
    return sym
  }

  private evalExpr(e: Expr, scope: Scope): IecValue {
    switch (e.k) {
      case 'lit':
        return e.value

      case 'var': {
        const sym = this.need(e.name, scope, e.pos)
        return sym.forced ?? sym.value
      }

      case 'member': {
        if (e.obj.k !== 'var') {
          throw new PlcError('Invalid member-access target', e.pos.line, e.pos.col)
        }
        const sym = this.need(e.obj.name, scope, e.pos)
        const prop = e.prop.toUpperCase()
        if (!sym.fb) {
          throw new PlcError(`${e.obj.name} is not a function-block instance`, e.pos.line, e.pos.col)
        }
        if (sym.fb.builtin) {
          const st = sym.fb.builtin
          if (prop in st.out) return st.out[prop]
          if (prop in st.in) return st.in[prop]
          throw new PlcError(`${sym.fb.type} has no output ${e.prop}`, e.pos.line, e.pos.col)
        }
        const inner = sym.fb.userScope?.vars.get(prop)
        if (!inner) throw new PlcError(`${sym.fb.type} has no member ${e.prop}`, e.pos.line, e.pos.col)
        return inner.value
      }

      case 'index': {
        if (e.obj.k !== 'var') throw new PlcError('Invalid array-access target', e.pos.line, e.pos.col)
        const sym = this.need(e.obj.name, scope, e.pos)
        if (!sym.array || !sym.decl.dim) {
          throw new PlcError(`${e.obj.name} is not an array`, e.pos.line, e.pos.col)
        }
        const idx = asNum(this.evalExpr(e.idx, scope)) - sym.decl.dim[0]
        if (idx < 0 || idx >= sym.array.length) {
          throw new PlcError(
            `Array index out of bounds: ${e.obj.name}[${idx + sym.decl.dim[0]}]`,
            e.pos.line, e.pos.col,
          )
        }
        return sym.array[idx]
      }

      case 'un': {
        const v = this.evalExpr(e.e, scope)
        if (e.op === 'NOT') return typeof v === 'number' ? ~v & 0xffff : !asBool(v)
        if (e.op === '-') return -asNum(v)
        return asNum(v)
      }

      case 'bin':
        return this.evalBin(e, scope)

      case 'call':
        return this.invoke(e.name, e.args, scope, e.pos)
    }
  }

  private evalBin(e: Extract<Expr, { k: 'bin' }>, scope: Scope): IecValue {

    if (e.op === 'AND') {
      const l = this.evalExpr(e.l, scope)
      if (typeof l === 'number') return l & asNum(this.evalExpr(e.r, scope))
      if (!asBool(l)) return false
      return asBool(this.evalExpr(e.r, scope))
    }
    if (e.op === 'OR') {
      const l = this.evalExpr(e.l, scope)
      if (typeof l === 'number') return l | asNum(this.evalExpr(e.r, scope))
      if (asBool(l)) return true
      return asBool(this.evalExpr(e.r, scope))
    }

    const l = this.evalExpr(e.l, scope)
    const r = this.evalExpr(e.r, scope)

    switch (e.op) {
      case 'XOR':
        return typeof l === 'number' && typeof r === 'number' ? l ^ r : asBool(l) !== asBool(r)
      case '=':
        return typeof l === 'string' || typeof r === 'string' ? String(l) === String(r) : asNum(l) === asNum(r)
      case '<>':
        return typeof l === 'string' || typeof r === 'string' ? String(l) !== String(r) : asNum(l) !== asNum(r)
      case '<': return asNum(l) < asNum(r)
      case '>': return asNum(l) > asNum(r)
      case '<=': return asNum(l) <= asNum(r)
      case '>=': return asNum(l) >= asNum(r)
      case '+':
        return typeof l === 'string' || typeof r === 'string' ? String(l) + String(r) : asNum(l) + asNum(r)
      case '-': return asNum(l) - asNum(r)
      case '*': return asNum(l) * asNum(r)
      case '/': {
        const d = asNum(r)

        if (d === 0) throw new PlcError('Division by zero', e.pos.line, e.pos.col)
        return asNum(l) / d
      }
      case 'MOD': {
        const d = asNum(r)
        if (d === 0) throw new PlcError('MOD divisor is zero', e.pos.line, e.pos.col)
        return asNum(l) % d
      }
      case '**': return Math.pow(asNum(l), asNum(r))
    }
  }

  private invoke(name: string, args: CallArg[], scope: Scope, pos: { line: number; col: number }): IecValue {
    const key = normKey(name)

    const sym = scope.lookup(key)
    if (sym?.fb) return this.callFb(sym, args, scope, pos)

    const fn = this.funcDefs.get(key)
    if (fn) return this.callUserFunction(fn, args, scope, pos)

    const std = STD_FUNCTIONS[key]
    if (std) {
      const vals = args.map((a) => this.evalExpr(a.value, scope))
      return std(vals)
    }

    throw new PlcError(
      `Unknown call: ${name}; check whether its function-block instance is declared in VAR`,
      pos.line, pos.col, name.length,
    )
  }

  private callFb(sym: Sym, args: CallArg[], scope: Scope, pos: { line: number; col: number }): IecValue {
    const fb = sym.fb!

    if (fb.builtin) {
      const def = BUILTIN_FBS[fb.type]
      const st = fb.builtin

      let positional = 0
      const outBinds: { prop: string; target: Expr }[] = []
      for (const a of args) {
        if (a.isOutput) {
          if (a.name) outBinds.push({ prop: a.name.toUpperCase(), target: a.value })
          continue
        }
        const pname = a.name ? a.name.toUpperCase() : def.inputs[positional++]
        if (!pname) {
          throw new PlcError(`Too many arguments for ${fb.type}`, pos.line, pos.col)
        }
        st.in[pname] = this.evalExpr(a.value, scope)
      }
      def.call(st, (k) => st.in[k], this.dt)

      for (const ob of outBinds) {
        if (ob.prop in st.out) this.assign(ob.target, st.out[ob.prop], scope)
      }
      return st.out[def.outputs[0]] ?? false
    }

    const def = this.fbDefs.get(fb.type)
    const inner = fb.userScope
    if (!def || !inner) {
      throw new PlcError(`Definition not found for ${fb.type}`, pos.line, pos.col)
    }
    const inputs = def.vars.filter((v) => v.scope === 'input' || v.scope === 'inout')
    let positional = 0
    const outBinds: { prop: string; target: Expr }[] = []
    for (const a of args) {
      if (a.isOutput) {
        if (a.name) outBinds.push({ prop: normKey(a.name), target: a.value })
        continue
      }
      const pkey = a.name ? normKey(a.name) : inputs[positional++]?.key
      if (!pkey) throw new PlcError(`Too many arguments for ${fb.type}`, pos.line, pos.col)
      const target = inner.vars.get(pkey)
      if (!target) throw new PlcError(`${fb.type} has no input ${a.name ?? pkey}`, pos.line, pos.col)
      target.value = coerce(this.evalExpr(a.value, scope), target.decl.type)
    }
    this.execBlock(def.body, inner)
    for (const ob of outBinds) {
      const src = inner.vars.get(ob.prop)
      if (src) this.assign(ob.target, src.value, scope)
    }
    const firstOut = def.vars.find((v) => v.scope === 'output')
    return firstOut ? (inner.vars.get(firstOut.key)?.value ?? false) : false
  }

  private callUserFunction(fn: Pou, args: CallArg[], scope: Scope, pos: { line: number; col: number }): IecValue {
    const local = new Scope(this.globals, fn.name)
    for (const v of fn.vars) this.declareIn(local, v)

    const retKey = normKey(fn.name)
    if (!local.vars.has(retKey)) {
      local.declare({ name: fn.name, key: retKey, type: fn.returnType ?? 'INT', scope: 'temp' })
    }
    const inputs = fn.vars.filter((v) => v.scope === 'input' || v.scope === 'inout')
    let positional = 0
    for (const a of args) {
      if (a.isOutput) continue
      const pkey = a.name ? normKey(a.name) : inputs[positional++]?.key
      if (!pkey) throw new PlcError(`Too many arguments for ${fn.name}`, pos.line, pos.col)
      const target = local.vars.get(pkey)
      if (!target) throw new PlcError(`${fn.name} has no input ${a.name ?? pkey}`, pos.line, pos.col)
      target.value = coerce(this.evalExpr(a.value, scope), target.decl.type)
    }
    this.execBlock(fn.body, local)
    return local.vars.get(retKey)?.value ?? 0
  }
}
