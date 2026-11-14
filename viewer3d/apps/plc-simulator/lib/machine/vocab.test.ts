import { describe, expect, it } from 'vitest'
import { containsKeyword } from './infer'
import { KIND_RULES, matchesToken, tokenizeName } from './vocab'

describe('PLC tag vocabulary', () => {
  it('recognizes device keywords with tag boundaries', () => {
    const cylinder = KIND_RULES.find((rule) => rule.kind === 'cylinder')
    expect(cylinder?.keywords).toContain('CYLINDER')
    expect(containsKeyword('CYLINDER1_FWD', 'CYLINDER')).toBe(true)
    expect(containsKeyword('RECYCLE', 'CYL')).toBe(false)
  })

  it('splits numbered tag names and matches complete role tokens', () => {
    expect(tokenizeName('Cylinder1_Fwd')).toEqual(['CYLINDER', '1', 'FWD'])
    expect(matchesToken('FWD', 'FWD')).toBe(true)
    expect(matchesToken('FWD_LS', 'FWD')).toBe(false)
  })
})
