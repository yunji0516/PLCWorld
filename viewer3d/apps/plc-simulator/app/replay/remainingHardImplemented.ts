/** Published only after the replacement plant, ST and bounded geometry checks. */
export const remainingHardImplemented:Record<string,{title:string;primary:string}> = {
  H02:{title:'Two bypass slots, moving deck, dual-kit assembly, separate exits',primary:'Keep bypass storage accessible when FIFO order differs from the two kit recipes, and transfer each physical part into the current order.'},
  H03:{title:'Two-fixture production, product removal, end lifts, lower return',primary:'Preserve products and fixtures separately; physical empty-fixture recovery limits subsequent production. Check full lift loading and fixture generation at inspection.'},
  H15:{title:'Two layer orders, shared stacking head, lower fork support handoff',primary:'Preserve A/B layer order and the physical top surface; transfer support to the lower fork before dispatching the finished bundle.'},
  H04:{title:'Pouch opening, independent content preparation, physical insertion',primary:'Prepare separately arriving packaging and contents, then confirm both opening holds, matching IDs, and actual insertion depth before receipt.'},
  H06:{title:'Independent feed, vertical dancer storage, dual piece orders',primary:'Maintain the continuous web length shared by two drives, and verify pull encoder spans and actual cut lengths against the orders.'},
  H11:{title:'Independent two-face work, flip pad, corner regrasp',primary:'Complete flipping, regrasping, and support handoff to the B fixture; release the upper pad blocking the work face before requesting B-side work.'},
  H07:{title:'Two source-web registration spans, shared winding, roll handoff',primary:'Align leader coordinates of two independent webs, preserve corresponding segments in the wound roll, then cut, tail-wrap, and transfer roll support.'},
  H08:{title:'Four-edge product separation, perforated scrap, independent recovery',primary:'Confirm product edge separation and support before side extraction, and recover the perforated scrap and the final tail separately.'},
  H05:{title:'Four-pocket shared index, independent insertion, generation inspection',primary:'Retract tools before indexing all pockets together; preserve physical pairs and inspection generations, then eject completed parts with the radial ejector.'},
}
