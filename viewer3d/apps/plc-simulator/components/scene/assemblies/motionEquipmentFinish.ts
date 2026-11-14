/** Material's neutral structural metal, with shared gripper and workpiece finishes preserved. */
export function motionEquipmentColor(name:string,color:string,style?:string){
 if(/protected|workpiece|payload|warning|indicator|contact-insert|gripper|Workpiece|Protected area/.test(name))return color
 if(/column|mast|structural|anchor|footplate|cell-adapter-base|slide-support|support-frame|track-support|Column|Support frame/.test(name)||style==='base')return '#35434e'
 if(style==='motor'||/(?:drive-motor|axis-motor|side-motor|hoist-motor|trunnion-motor)$/.test(name))return '#35434e'
 if(/installation-riser/.test(name))return '#a3afb9'
 if(/tooling-plate|service-cover|service-panel/.test(name))return '#486d7c'
 if(style==='rail'||style==='actuator'||style==='carriage'||/linear-rail|guide-rail|guide-track|bored-carriage|table-slide-jaw/.test(name))return '#a3afb9'
 if(/sensor|photoeye|through-beam|probe-tip/.test(name)&&!/lens|status|optical/.test(name))return '#35434e'
 return color
}
