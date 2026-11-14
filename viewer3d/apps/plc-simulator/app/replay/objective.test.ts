import { describe, expect, it } from 'vitest'
import { taskObjective } from './objective'

describe('taskObjective', () => {
  it('shows only the Objective section of a task markdown', () => {
    expect(taskObjective('# MOT-E01\n\n## Objective\n\n- Move the axis.\n- Hold it.\n\n## I/O Interface\n\nSecret detail', 'fallback'))
      .toBe('Move the axis. Hold it.')
  })

  it('uses the summary when Objective is absent or empty', () => {
    expect(taskObjective('## I/O Interface\nX10', 'Move the axis.')).toBe('Move the axis.')
    expect(taskObjective('## Objective\n\n## Safety Constraints\nText', 'Move the axis.')).toBe('Move the axis.')
  })
})
