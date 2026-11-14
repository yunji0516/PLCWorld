/** Extract the public objective without exposing the full evaluator prompt. */
export function taskObjective(markdown: string | undefined, fallback: string): string {
  if (!markdown) return fallback
  const lines = markdown.split(/\r?\n/)
  const start = lines.findIndex(line => /^#{1,6}\s+Objective\s*$/i.test(line.trim()))
  if (start < 0) return fallback
  const body: string[] = []
  for (const line of lines.slice(start + 1)) {
    if (/^#{1,6}\s+/.test(line.trim())) break
    const clean = line.trim().replace(/^[-*+]\s+/, '')
    if (clean) body.push(clean)
  }
  return body.join(' ') || fallback
}
