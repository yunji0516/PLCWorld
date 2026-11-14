import {hardControlExtensions} from './hardControlExtensions'
import {remainingHardImplemented} from './remainingHardImplemented'
import type { Trace } from '@/lib/replay/adapter'

export const HARD_PROCESS_FAMILY = 'material_hard_process_review'
export const STATION_PROCESS_FAMILY = 'material_stations_v7'
const models = [
  {
    "id": "H02",
    "title": "Order-adjusted supply and consumption at two assembly stations",
    "primary": "Keep required parts accessible when FIFO supply differs from consumption order, and deliver physical parts to the active request.",
    "scope": "3D machinery and physical handoff review / new ST evaluation contract not frozen",
    "design_status": "3d_review_candidate"
  },
  {
    "id": "H03",
    "title": "Reusable fixture circulation with physical lifts",
    "primary": "Recover empty fixtures after product dispatch through a physical route and reuse them while tracking products and fixtures separately.",
    "scope": "3D machinery and physical handoff review / new ST evaluation contract not frozen",
    "design_status": "3d_review_candidate"
  },
  {
    "id": "H04",
    "title": "Merge pouch preparation and content insertion",
    "primary": "Match separately prepared packaging and contents to one order, maintaining opening and support until physical insertion is complete.",
    "scope": "3D machinery and physical handoff review / new ST evaluation contract not frozen",
    "design_status": "3d_review_candidate"
  },
  {
    "id": "H05",
    "title": "Shared-index assembly and extraction cell",
    "primary": "Preserve shared motion of all pockets alongside unfinished operations and physical handoffs in each pocket.",
    "scope": "3D machinery and physical handoff review / new ST evaluation contract not frozen",
    "design_status": "3d_review_candidate"
  },
  {
    "id": "H06",
    "title": "Intermittent feed and variable-length piece production",
    "primary": "Maintain stored length = initial stock + physical feed − physical pull while completing different-length orders and independent supply.",
    "scope": "3D machinery and physical handoff review / new ST evaluation contract not frozen",
    "design_status": "3d_review_candidate"
  },
  {
    "id": "H07",
    "title": "Dual-strip winding, leader separation, and roll receipt",
    "primary": "Wind corresponding physical web spans, retain both leaders, then separate and receive the roll.",
    "scope": "R11 synthetic mini-process machinery review · Python reference control · before new ST evaluation",
    "design_status": "design_pass_kinematic_review"
  },
  {
    "id": "H08",
    "title": "Product extraction and connected-scrap recovery",
    "primary": "Separate and receive both product and scrap so the next indexing pitch does not drag the previous product.",
    "scope": "3D machinery and physical handoff review / new ST evaluation contract not frozen",
    "design_status": "3d_review_candidate"
  },
  {
    "id": "H09",
    "title": "Shared tank replenishment and dual metered fills",
    "primary": "Manage shared tank consumption and per-branch hold-up to match each vessel's physically received volume.",
    "scope": "3D machinery and physical handoff review / new ST evaluation contract not frozen",
    "design_status": "3d_review_candidate"
  },
  {
    "id": "H10",
    "title": "Single-piece stack separation and supply to two assembly cells",
    "primary": "Support the remaining stack while releasing one piece at a time and continuing replenishment and consumption.",
    "scope": "R11 synthetic mini-process machinery review · Python reference control · before new ST evaluation",
    "design_status": "design_pass_kinematic_review"
  },
  {
    "id": "H11",
    "title": "Two-face component assembly and rotary support handoff",
    "primary": "Change the physically exposed face of a held product and attach components to opposite sides.",
    "scope": "R11 synthetic mini-process machinery review · Python reference control · before new ST evaluation",
    "design_status": "design_pass_kinematic_review"
  },
  {
    "id": "H12",
    "title": "Dual punches and falling-scrap bin exchange",
    "primary": "Reserve landing space for scrap that cannot be stopped after punching, then exchange the bin after the drop completes.",
    "scope": "R11 synthetic mini-process machinery review · Python reference control · before new ST evaluation",
    "design_status": "design_pass_kinematic_review"
  },
  {
    "id": "H13",
    "title": "Bundle side banding and tape finishing",
    "primary": "Close the physical film path around the bundle, cut the source film, and secure the matching tape.",
    "scope": "R11 synthetic mini-process machinery review · Python reference control · before new ST evaluation",
    "design_status": "design_pass_kinematic_review"
  },
  {
    "id": "H14",
    "title": "Vessel tare handoff, mass inspection, and routing",
    "primary": "Classify actual net mass using fully transferred scale load and the tare of the same vessel.",
    "scope": "R11 synthetic mini-process machinery review · Python reference control · before new ST evaluation",
    "design_status": "design_pass_kinematic_review"
  },
  {
    "id": "H15",
    "title": "Two stacking orders and finished-bundle handoff",
    "primary": "Preserve prior layer order and physical top height, receive subsequent layers, and transfer support before dispatching the completed bundle.",
    "scope": "3D machinery and physical handoff review / new ST evaluation contract not frozen",
    "design_status": "3d_review_candidate"
  }
]

const stationMetadata: Record<string,{title:string;primary:string}> = {
  ...remainingHardImplemented,
  "H09": {
    "title": "Shared tank refill, dual filling lines, shared capping and outfeed",
    "primary": "Coordinate batch refill, vessel arrivals, and delayed outfeed while two lines share one tank and capper; preserve each vessel's actual received volume and cap ownership."
  },
  "H14": {
    "title": "Empty-tray tare, dual-kit work, shared final weighing and routing",
    "primary": "Link before/after measured masses of the same tray across arrivals, differing kit completion orders, shared final weighing, and delayed accept/hold exits; route by net added mass."
  },
  "H12": {
    "title": "Dual presses, committed-scrap reservation, shared bin exchange",
    "primary": "Before accepting irreversible production requests, account for current occupancy and committed incoming scrap; coordinate good-part outfeed and shared bin exchange independently."
  },
  "H13": {
    "title": "Fixed feed, gripper handoff, independent wrapping chuck and tape",
    "primary": "Extract bundles from the conveyor into a separate wrapping chuck; confirm physical grip and tool withdrawal while coordinating finite film, order tape, and delayed outfeed."
  },
  "H10": {
    "title": "ID magazine exchange, upper/lower support, dual consumption cells",
    "primary": "Physically exchange finite supply magazines while separately tracking magazine stock, outstanding extraction transactions, and two consumption requests."
  },
  ...hardControlExtensions
}

/** Catalogue metadata only: no fabricated PLC frames or verdicts. */
export function withHardProcessModels(trace: Trace): Trace {
  const merged = {...trace}
  for (const model of models) {
    if (merged[`MAT-${model.id}`]?.evaluation_release === 'plcworld-evaluation/5.2.6'
        || merged[`MAT-${model.id}`]?.task_version === 'priority-redesign/1') continue
    const row = {...model,...stationMetadata[model.id]}
    merged[`MAT-${row.id}`] = {title: row.title, aim: row.primary, req: row.primary, suite: 'material', difficulty: 'hard', family: HARD_PROCESS_FAMILY, candidate_status: 'design_accepted', design_accepted: true, io: {}, devices: [], observed: [], runs: {}}
    if (stationMetadata[row.id]) merged[`MAT-${row.id}`] = {...merged[`MAT-${row.id}`], family:STATION_PROCESS_FAMILY, task_version:['H09','H14'].includes(row.id)?'16.0-outfeed':['H10','H12'].includes(row.id)?'15.0-physical-handoff':hardControlExtensions[row.id]?'14.0-control-expansion':remainingHardImplemented[row.id]?'10.0-independent-process':row.id==='H13'?'8.0-grip-transfer':'7.0-stations', replay_deferred:true}
  }
  return merged
}
