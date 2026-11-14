/** Functionally expanded tasks; all use the existing replay workspace. */
export const hardControlExtensions: Record<string,{title:string;primary:string}> = {
  "H02": {
    "title": "FIFO kit assembly, shared packing head, combined dispatch by order",
    "primary": "Keep bypass storage accessible when FIFO order differs from two kit recipes. Transfer real parts into the active kits, pack both kits in one matching box, and control empty-box supply and finished-box dispatch."
  },
  "H04": {
    "title": "Double-sheet separation, content alignment, pouch opening and insertion",
    "primary": "Coordinate separate packaging and content preparation. Confirm opening holds, matching IDs, and physical insertion depth. Separate overlapping pouches into single feeds and correct content offset and rotation with two alignment axes."
  },
  "H05": {
    "title": "Shared-index assembly, seating inspection, reject rework, retest",
    "primary": "Retract all tools before shared pocket indexing, preserve physical pairs and inspection generations, and eject finished parts. Detect seating gaps, disassemble and reinsert rejects in a separate fixture, then return them for a fresh inspection."
  },
  "H06": {
    "title": "Source-reel exchange, leader splice, dancer storage, piece production, splice-waste separation",
    "primary": "Exchange and splice source reels while dancer storage sustains downstream production, then exclude the splice region from normal orders and receive it as physical waste."
  },
  "H07": {
    "title": "Single-core feed, dual-web registered winding, tail tape, roll dispatch",
    "primary": "Align independent web leaders so each roll segment contains matching materials. Cut both connections, transfer roll support, feed and lock one core, prepare tape independently, and secure the cut tails before dispatch."
  },
  "H08": {
    "title": "Four-edge separation, scrap storage, spent-roll exchange and rethreading",
    "primary": "Sever all edges connecting product and scrap, transfer product support, and store and wind perforated scrap separately. Clamp and cut both scrap tails, exchange the spent roll, rethread side strips, and resume recovery."
  },
  "H11": {
    "title": "Variable-width fixture setup, physical tool exchange, two-face regrasp",
    "primary": "After flipping, release any pad obscuring the work face only after a corner holder takes support. Prepare shared tools and two fixtures for different widths, and verify rack support and coupling during tool exchange."
  },
  "H13": {
    "title": "Single-piece feed, alignment, bundle forming, sized wrapping and dispatch",
    "primary": "Control independent piece feeds and bundle formation, then coordinate gripper/chuck handoff, size-specific film and tape, and physical outfeed."
  },
  "H15": {
    "title": "Single empty-pallet feed, dual stacking orders, shared fork contention",
    "primary": "Preserve independent A/B layer order and actual stack height. Transfer support to the lower fork, supply finite empty pallets with the same fork, and dispatch completed palletized stacks."
  }
}
