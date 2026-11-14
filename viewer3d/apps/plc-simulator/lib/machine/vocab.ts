/** Recognize device kinds and signal roles in PLC tag names and comments. */
export type DeviceKind =
  | 'conveyor' | 'servo' | 'cylinder' | 'stopper' | 'door' | 'clamp' | 'gripper' | 'spindle'
  | 'lift' | 'turntable' | 'robot' | 'press' | 'pump' | 'valve' | 'vacuum'
  | 'vertical_slide' | 'fixture' | 'platform' | 'support_frame'
  | 'rack' | 'fork'
  | 'heater' | 'lamp' | 'motor' | 'feeder' | 'sensor' | 'button' | 'estop'

export type Motion =

  | 'linear'

  | 'continuous'

  | 'discrete'

  | 'operator'

export interface KindInfo {
  kind: DeviceKind
  motion: Motion
  /** English display name. */
  label: string

  strokeMs: number
  color: string
}

export const KIND_INFO: Record<DeviceKind, KindInfo> = {
  conveyor:  { kind: 'conveyor',  motion: 'continuous', label: 'Conveyor',   strokeMs: 0,    color: '#5b6673' },
  servo:     { kind: 'servo',     motion: 'linear',     label: 'Servo axis', strokeMs: 1000, color: '#4f78a8' },
  cylinder:  { kind: 'cylinder',  motion: 'linear',     label: 'Cylinder',   strokeMs: 800,  color: '#8a9199' },
  stopper:   { kind: 'stopper',   motion: 'linear',     label: 'Stopper',    strokeMs: 400,  color: '#d79a3b' },
  door:      { kind: 'door',      motion: 'linear',     label: 'Door',       strokeMs: 1400, color: '#4a5568' },
  clamp:     { kind: 'clamp',     motion: 'linear',     label: 'Clamp',      strokeMs: 600,  color: '#7c8794' },
  gripper:   { kind: 'gripper',   motion: 'linear',     label: 'Gripper',    strokeMs: 500,  color: '#6b7684' },
  spindle:   { kind: 'spindle',   motion: 'continuous', label: 'Spindle',    strokeMs: 0,    color: '#9aa3ad' },
  lift:      { kind: 'lift',      motion: 'linear',     label: 'Lift',       strokeMs: 1600, color: '#5f6b78' },
  vertical_slide: { kind: 'vertical_slide', motion: 'linear', label: 'Vertical slide', strokeMs: 800, color: '#667786' },
  fixture:   { kind: 'fixture',   motion: 'discrete',   label: 'Fixture',    strokeMs: 0,    color: '#59616b' },
  platform:  { kind: 'platform',  motion: 'discrete',   label: 'Platform',   strokeMs: 0,    color: '#69737e' },
  support_frame: { kind: 'support_frame', motion: 'discrete', label: 'Support frame', strokeMs: 0, color: '#6d7f92' },
  rack:      { kind: 'rack',      motion: 'discrete',   label: 'Storage rack', strokeMs: 0,  color: '#65717d' },
  fork:      { kind: 'fork',      motion: 'linear',     label: 'Lift fork',  strokeMs: 500,  color: '#8a9199' },
  turntable: { kind: 'turntable', motion: 'continuous', label: 'Turntable',  strokeMs: 0,    color: '#66707c' },
  robot:     { kind: 'robot',     motion: 'linear',     label: 'Robot',      strokeMs: 1200, color: '#c98a3c' },
  press:     { kind: 'press',     motion: 'linear',     label: 'Press',      strokeMs: 900,  color: '#4f5a66' },
  pump:      { kind: 'pump',      motion: 'continuous', label: 'Pump',       strokeMs: 0,    color: '#5a6b7a' },
  valve:     { kind: 'valve',     motion: 'discrete',   label: 'Valve',      strokeMs: 200,  color: '#6d7c8a' },
  vacuum:    { kind: 'vacuum',    motion: 'discrete',   label: 'Vacuum pickup', strokeMs: 0, color: '#4b93a8' },
  heater:    { kind: 'heater',    motion: 'discrete',   label: 'Heater',     strokeMs: 0,    color: '#b5563a' },
  lamp:      { kind: 'lamp',      motion: 'discrete',   label: 'Indicator lamp', strokeMs: 0, color: '#d9a441' },
  motor:     { kind: 'motor',     motion: 'continuous', label: 'Motor',      strokeMs: 0,    color: '#6f7a86' },
  feeder:    { kind: 'feeder',    motion: 'discrete',   label: 'Feeder',     strokeMs: 400,  color: '#7a6b58' },
  sensor:    { kind: 'sensor',    motion: 'discrete',   label: 'Sensor',     strokeMs: 0,    color: '#3fa7d6' },
  button:    { kind: 'button',    motion: 'operator',   label: 'Button',     strokeMs: 0,    color: '#4a9d5f' },
  estop:     { kind: 'estop',     motion: 'operator',   label: 'Emergency stop', strokeMs: 0, color: '#c0392b' },
}

export interface KindRule {
  kind: DeviceKind

  keywords: string[]

  weight: number
}

export const KIND_RULES: KindRule[] = [
  { kind: 'estop', weight: 100, keywords: ['EMERGENCY', 'ESTOP', 'E_STOP', 'EMSTOP', 'EMG', 'EMO'] },
  { kind: 'conveyor', weight: 90, keywords: ['CONVEYOR', 'CONVEY', 'CONV', 'BELT'] },
  { kind: 'turntable', weight: 88, keywords: ['TURNTABLE', 'TURN_TABLE', 'INDEXER', 'INDEX', 'ROTARY', 'DIVIDER'] },
  { kind: 'servo', weight: 87, keywords: ['SERVO', 'POSITIONING', 'AXIS'] },
  { kind: 'stopper', weight: 87, keywords: ['STOPPER', 'STOP_GATE', 'STOPGATE'] },
  { kind: 'cylinder', weight: 86, keywords: ['CYLINDER', 'CYL', 'PUSHER', 'PUSH', 'ROD'] },
  { kind: 'gripper', weight: 85, keywords: ['GRIPPER', 'GRIP', 'VACUUM', 'VAC', 'SUCTION', 'HAND'] },
  { kind: 'clamp', weight: 84, keywords: ['CLAMP', 'CLMP', 'CHUCK', 'JIG'] },
  { kind: 'door', weight: 83, keywords: ['DOOR', 'SHUTTER', 'GATE', 'COVER', 'HATCH'] },
  { kind: 'press', weight: 82, keywords: ['PRESS', 'PUNCH', 'STAMP'] },
  { kind: 'spindle', weight: 81, keywords: ['SPINDLE', 'SPDL', 'DRILL', 'GRIND', 'SAW'] },
  { kind: 'lift', weight: 80, keywords: ['LIFT', 'ELEVATOR', 'HOIST', 'JACK'] },
  { kind: 'support_frame', weight: 79, keywords: ['GANTRY', 'FRAME', 'STAND'] },
  { kind: 'robot', weight: 79, keywords: ['ROBOT', 'RBT', 'MANIPULATOR'] },
  { kind: 'feeder', weight: 78, keywords: ['FEEDER', 'FEED', 'HOPPER'] },
  { kind: 'heater', weight: 76, keywords: ['HEATER', 'HEAT', 'DRYER', 'OVEN'] },
  { kind: 'pump', weight: 74, keywords: ['PUMP', 'COMPRESSOR', 'COMP', 'BLOWER', 'FAN'] },
  { kind: 'valve', weight: 72, keywords: ['VALVE', 'SOLENOID', 'SOL'] },
  { kind: 'lamp', weight: 70, keywords: ['LAMP', 'TOWER', 'LED', 'BUZZER', 'ALARM', 'ALM', 'SIREN'] },
  { kind: 'button', weight: 68, keywords: ['BUTTON', 'BTN', 'PUSHBUTTON', 'SWITCH'] },
  { kind: 'motor', weight: 40, keywords: ['MOTOR', 'MOT', 'MTR'] },
  { kind: 'sensor', weight: 30, keywords: ['SENSOR', 'SENS', 'SNS', 'DETECT', 'DET', 'PROX', 'PHOTO', 'PHOTOEYE'] }]

export type Role =
  | 'fwd'       
  | 'rev'       
  | 'enable'    
  | 'speed'     
  | 'atMax'     
  | 'atMin'     
  | 'present'   
  | 'running'   
  | 'fault'     
  | 'none'

export interface RoleToken {
  role: Role
  tokens: string[]

  feedback?: boolean
}

export const ROLE_TOKENS: RoleToken[] = [
  { role: 'fault', tokens: ['FAULT', 'FLT', 'ERR', 'ERROR', 'ALARM', 'ALM', 'TRIP', 'OL'] },
  { role: 'running', tokens: ['RUNNING', 'RUN_ST', 'ONLINE', 'ACT', 'ACTIVE', 'STS', 'STATUS'] },
  { role: 'present', tokens: ['PRESENT', 'PRES', 'DETECT', 'DET', 'PART', 'WORK', 'WORKPIECE'] },
  { role: 'atMax', tokens: ['EXT_LS', 'EXTLS', 'OPEN_LS', 'UP_LS', 'FWD_LS', 'ADV_LS'] },
  { role: 'atMin', tokens: ['RET_LS', 'RETLS', 'CLOSE_LS', 'DN_LS', 'DOWN_LS', 'REV_LS', 'HOME_LS'] },
  { role: 'speed', tokens: ['SPEED', 'SPD', 'FREQ', 'HZ', 'RPM', 'REF', 'SETPOINT', 'SP'] },
  { role: 'enable', tokens: ['ENABLE', 'ENA', 'EN', 'PERMIT', 'READY', 'RDY'] },
  { role: 'fwd', tokens: ['EXTEND', 'EXT', 'ADVANCE', 'ADV', 'FORWARD', 'FWD', 'OPEN', 'OP', 'UP', 'RAISE', 'CW', 'ON', 'RUN', 'START', 'STRT'] },
  { role: 'rev', tokens: ['RETRACT', 'RET', 'REVERSE', 'REV', 'CLOSE', 'CL', 'DOWN', 'DN', 'LOWER', 'CCW', 'BACK', 'HOME', 'OFF', 'STOP', 'STP'] }]

export const NEUTRAL_TOKENS = [
  'MODE', 'MD', 'SIG', 'SIGNAL', 'CMD', 'COMMAND', 'FLAG', 'BIT', 'RLY', 'RELAY', 'MC', 'PB']

export const FEEDBACK_MARKS = [
  'LS', 'LIMIT', 'LIMITSW', 'SENSOR', 'SENS', 'SNS', 'SW', 'SQ', 'PROX', 'PHOTO', 'PE',
  'CHK', 'CHECK', 'CONFIRM', 'DONE', 'CMPL', 'COMPLETE']

export const OPERATOR_WORDS: { role: string; tokens: string[]; label: string }[] = [
  { role: 'start', tokens: ['START', 'STRT', 'RUN'], label: 'Start' },
  { role: 'stop', tokens: ['STOP', 'STP'], label: 'Stop' },
  { role: 'reset', tokens: ['RESET', 'RST', 'CLEAR', 'CLR'], label: 'Reset' },
  { role: 'auto', tokens: ['AUTO'], label: 'Auto' },
  { role: 'manual', tokens: ['MANUAL', 'MAN', 'JOG'], label: 'Manual' },
  { role: 'estop', tokens: ['EMG', 'ESTOP', 'E_STOP', 'EMERGENCY'], label: 'Emergency stop' }]

export function tokenizeName(name: string): string[] {
  const cleaned = name.replace(/^%[IQM][XBWD]?[\d.]*/i, '').replace(/^_+|_+$/g, '')
  return cleaned
    .replace(/([a-z])([A-Z])/g, '$1_$2')
    .replace(/([A-Za-z])(\d)/g, '$1_$2')
    .replace(/(\d)([A-Za-z])/g, '$1_$2')
    .split(/[^0-9A-Za-z]+/)
    .filter(Boolean)
    .map((t) => t.toUpperCase())
}

export function matchesToken(token: string, candidate: string): boolean {
  return token === candidate
}
