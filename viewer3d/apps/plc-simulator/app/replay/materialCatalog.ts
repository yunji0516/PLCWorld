// Display aliases only: physical renderers and old links retain stable IDs.
export const MATERIAL_MEDIUM20 = {
  "MAT-V6-D01": "MAT-M01",
  "MAT-V6-D03": "MAT-M02",
  "MAT-V6-D04": "MAT-M03",
  "MAT-V6-D06": "MAT-M04",
  "MAT-V6-D10": "MAT-M05",
  "MAT-V7-D11": "MAT-M06",
  "MAT-V7-D12": "MAT-M07",
  "MAT-V7-D13": "MAT-M08",
  "MAT-V7-D14": "MAT-M09",
  "MAT-V7-D15": "MAT-M10",
  "MAT-V8-D16": "MAT-M11",
  "MAT-V8-D17": "MAT-M12",
  "MAT-V8-D18": "MAT-M13",
  "MAT-V8-D19": "MAT-M14",
  "MAT-V8-D20": "MAT-M15",
  "MAT-V8-D21": "MAT-M16",
  "MAT-V8-D22": "MAT-M17",
  "MAT-M18-TAPE-R1": "MAT-M18",
  "MAT-V8-D24": "MAT-M19",
  "MAT-V8-D25": "MAT-M20"
} as const
export function materialDisplayId(id: string): string {
  if (/^MAT-EASY15-E\d{2}$/.test(id)) return id.replace('MAT-EASY15-', 'MAT-')
  return MATERIAL_MEDIUM20[id as keyof typeof MATERIAL_MEDIUM20] ?? id
}
export function materialInternalId(id: string | null): string | null {
  if (id === 'MAT-V8-D23') return 'MAT-M18-TAPE-R1'
  if (id && /^MAT-E(?:0[1-9]|1[0-5])$/.test(id)) return id.replace('MAT-', 'MAT-EASY15-')
  return Object.entries(MATERIAL_MEDIUM20).find(([, alias]) => alias === id)?.[0] ?? id
}
