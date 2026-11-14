/** Define the Structured Text AST shared by parser, analysis, and runtime. */
import type { IecType, IecValue, VarDecl } from '../types'

export interface Pos {
  line: number
  col: number
}

export type Expr =
  | { k: 'lit'; value: IecValue; type: IecType; pos: Pos }
  | { k: 'var'; name: string; pos: Pos }

  | { k: 'member'; obj: Expr; prop: string; pos: Pos }
  | { k: 'index'; obj: Expr; idx: Expr; pos: Pos }
  | { k: 'un'; op: 'NOT' | '-' | '+'; e: Expr; pos: Pos }
  | { k: 'bin'; op: BinOp; l: Expr; r: Expr; pos: Pos }

  | { k: 'call'; name: string; args: CallArg[]; pos: Pos }

export type BinOp =
  | 'OR' | 'XOR' | 'AND'
  | '=' | '<>' | '<' | '>' | '<=' | '>='
  | '+' | '-' | '*' | '/' | 'MOD' | '**'

export interface CallArg {

  name?: string

  isOutput?: boolean
  value: Expr
}

export type Stmt =
  | { k: 'assign'; target: Expr; value: Expr; pos: Pos }

  | { k: 'call'; name: string; args: CallArg[]; pos: Pos }
  | { k: 'if'; branches: { cond: Expr; body: Stmt[] }[]; orElse?: Stmt[]; pos: Pos }
  | { k: 'case'; selector: Expr; cases: CaseBranch[]; orElse?: Stmt[]; pos: Pos }
  | { k: 'for'; varName: string; from: Expr; to: Expr; by?: Expr; body: Stmt[]; pos: Pos }
  | { k: 'while'; cond: Expr; body: Stmt[]; pos: Pos }
  | { k: 'repeat'; body: Stmt[]; until: Expr; pos: Pos }
  | { k: 'exit'; pos: Pos }
  | { k: 'continue'; pos: Pos }
  | { k: 'return'; pos: Pos }

export interface CaseBranch {

  labels: { lo: number; hi: number }[]
  body: Stmt[]
}

export type PouKind = 'PROGRAM' | 'FUNCTION_BLOCK' | 'FUNCTION'

export interface Pou {
  kind: PouKind
  name: string
  vars: VarDecl[]
  body: Stmt[]
  returnType?: IecType
  line: number
}

export interface StProgram {
  pous: Pou[]

  globals: VarDecl[]
}

export function collectRefs(e: Expr, out: Set<string> = new Set()): Set<string> {
  switch (e.k) {
    case 'var':
      out.add(e.name.toUpperCase())
      break
    case 'member':
      collectRefs(e.obj, out)
      break
    case 'index':
      collectRefs(e.obj, out)
      collectRefs(e.idx, out)
      break
    case 'un':
      collectRefs(e.e, out)
      break
    case 'bin':
      collectRefs(e.l, out)
      collectRefs(e.r, out)
      break
    case 'call':
      out.add(e.name.toUpperCase())
      e.args.forEach((a) => collectRefs(a.value, out))
      break
  }
  return out
}

export function walkStmts(body: Stmt[], visit: (s: Stmt) => void | false): void {
  for (const s of body) {
    if (visit(s) === false) continue
    switch (s.k) {
      case 'if':
        s.branches.forEach((b) => walkStmts(b.body, visit))
        if (s.orElse) walkStmts(s.orElse, visit)
        break
      case 'case':
        s.cases.forEach((b) => walkStmts(b.body, visit))
        if (s.orElse) walkStmts(s.orElse, visit)
        break
      case 'for':
      case 'while':
      case 'repeat':
        walkStmts(s.body, visit)
        break
    }
  }
}

export function collectWrites(body: Stmt[]): Set<string> {
  const out = new Set<string>()
  walkStmts(body, (s) => {
    if (s.k === 'assign') {
      let t = s.target
      while (t.k === 'member' || t.k === 'index') t = t.obj
      if (t.k === 'var') out.add(t.name.toUpperCase())
    } else if (s.k === 'call') {

      for (const a of s.args) {
        if (a.isOutput && a.value.k === 'var') out.add(a.value.name.toUpperCase())
      }
    }
  })
  return out
}

export function collectReads(body: Stmt[]): Set<string> {
  const out = new Set<string>()
  walkStmts(body, (s) => {
    switch (s.k) {
      case 'assign':
        collectRefs(s.value, out)
        if (s.target.k === 'index') collectRefs(s.target.idx, out)
        break
      case 'call':
        s.args.forEach((a) => { if (!a.isOutput) collectRefs(a.value, out) })
        break
      case 'if':
        s.branches.forEach((b) => collectRefs(b.cond, out))
        break
      case 'case':
        collectRefs(s.selector, out)
        break
      case 'for':
        collectRefs(s.from, out)
        collectRefs(s.to, out)
        if (s.by) collectRefs(s.by, out)
        break
      case 'while':
        collectRefs(s.cond, out)
        break
      case 'repeat':
        collectRefs(s.until, out)
        break
    }
  })
  return out
}
