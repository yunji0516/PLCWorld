/** Numbered transport stop assemblies (body, rod, actuator and mounts).
 * Process fixtures and web clamps are not conveyor workpiece holders. */
export function isConveyorHolder(node:{id:string;anchor?:string;material?:boolean;name?:string}) {
  const id=node.anchor ?? node.id
  return !node.material && (/(?:^|_)stop_\d+(?:_|$)/.test(id) || /^(?:[ab]_arrival_\d+_jaw|clamp_(?:actuator_|backstop_|rod_)?[ab]$)/.test(id) || /^(?:core_stop|formation_stop)(?:_|$)/.test(id))
}
