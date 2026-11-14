/** Conservative solid boxes in world metres. Routing never uses PLC state. */
export type V3 = [number, number, number]
export type Solid = { min: V3; max: V3; id: string }
export const add = (a:V3,b:V3):V3=>a.map((x,i)=>x+b[i]) as V3
export const sub = (a:V3,b:V3):V3=>a.map((x,i)=>x-b[i]) as V3
export const mul = (a:V3,s:number):V3=>a.map(x=>x*s) as V3
export const length = (a:V3)=>Math.hypot(...a)
export const distance = (a:V3,b:V3)=>length(sub(a,b))
export const inflate = (b:Solid,r:number):Solid=>({...b,min:b.min.map(v=>v-r) as V3,max:b.max.map(v=>v+r) as V3})
export function contains(b:Solid,p:V3){return p.every((v,i)=>v>b.min[i]+1e-8&&v<b.max[i]-1e-8)}
export function hit(a:V3,b:V3,box:Solid):number|null {
 let lo=0,hi=1
 for(let i=0;i<3;i++){
  const d=b[i]-a[i]
  if(Math.abs(d)<1e-10){if(a[i]<=box.min[i]+1e-8||a[i]>=box.max[i]-1e-8)return null;continue}
  let u=(box.min[i]-a[i])/d,v=(box.max[i]-a[i])/d;if(u>v)[u,v]=[v,u]
  lo=Math.max(lo,u);hi=Math.min(hi,v);if(lo>=hi-1e-9)return null
 }
 return lo<1&&hi>0?lo:null
}
export function firstHit(a:V3,b:V3,boxes:Solid[]){let t=Infinity,found:Solid|undefined;for(const box of boxes){const h=hit(a,b,box);if(h!==null&&h<t){t=h;found=box}}return found}
export function simplify(points:V3[],boxes:Solid[]){const out=[points[0]];let i=0;while(i<points.length-1){let j=points.length-1;while(j>i+1&&firstHit(points[i],points[j],boxes))j--;out.push(points[j]);i=j}return out}
/** Search obstacle corners; no fixed "draw through it" fallback. */
export function route(a:V3,b:V3,boxes:Solid[]):V3[]|null {
 if(!firstHit(a,b,boxes))return [a,b]
 const key=(p:V3)=>p.map(v=>Math.round(v*10000)).join(',')
 const queue=[{p:a,path:[a],g:0}],best=new Map<string,number>([[key(a),0]])
 for(let n=0;queue.length&&n<260;n++){
  queue.sort((x,y)=>x.g+distance(x.p,b)-y.g-distance(y.p,b));const cur=queue.shift()!
  const block=firstHit(cur.p,b,boxes);if(!block)return simplify([...cur.path,b],boxes)
  const candidates:V3[]=[]
  // Corners plus projections retain short, orthogonal runs beside fixtures.
  for(let axis=0;axis<3;axis++)for(const side of [block.min[axis]-.008,block.max[axis]+.008]){
   const p=[...cur.p] as V3;p[axis]=side;candidates.push(p)
   const q=[...b] as V3;q[axis]=side;candidates.push(q)
  }
  for(const x of [block.min[0]-.008,block.max[0]+.008])for(const y of [block.min[1]-.008,block.max[1]+.008])for(const z of [block.min[2]-.008,block.max[2]+.008])candidates.push([x,y,z])
  for(const p of candidates){if(firstHit(cur.p,p,boxes)||boxes.some(box=>contains(box,p)))continue;const g=cur.g+distance(cur.p,p),k=key(p);if(g>=(best.get(k)??Infinity)-1e-8)continue;best.set(k,g);queue.push({p,path:[...cur.path,p],g})}
 }
 return null
}
/** A real terminal on a housing face, with a short outward gland neck. */
export function terminal(nominal:V3,preferred:V3,solids:Solid[],clearance:number,avoid:Solid[]=[]){
 const housings=solids.filter(b=>!b.id.startsWith('part-'))
 const nearby=housings.map(b=>({b,d:Math.hypot(...nominal.map((v,i)=>Math.max(0,b.min[i]-v,v-b.max[i])))})).filter(x=>x.d<=.03).sort((a,b)=>a.d-b.d)
 const seed=nearby[0]?.b;if(!seed)return {port:nominal,escape:nominal,host:null as string|null}
 const faces=[]
 for(let axis=0;axis<3;axis++)for(const sign of [-1,1]){
  let exit=sign<0?nominal[axis]-seed.min[axis]:seed.max[axis]-nominal[axis],host=seed
  // Buried fittings emerge at the exposed face of their overlapping housing,
  // never by rendering a wire through those bodies. Limit local relocation.
  for(let iter=0;iter<12;iter++){
   let changed=false
   for(const b of housings){if(b===host||!nominal.every((v,i)=>i===axis||(v>=b.min[i]-1e-7&&v<=b.max[i]+1e-7)))continue
    const enter=sign<0?nominal[axis]-b.max[axis]:b.min[axis]-nominal[axis],end=sign<0?nominal[axis]-b.min[axis]:b.max[axis]-nominal[axis]
    if(enter<=exit+.0001&&end>exit+1e-7&&end<.15){exit=end;host=b;changed=true}
   }
   if(!changed)break
  }
  if(exit<-.031||exit>.15)continue
  const port=[...nominal] as V3;port[axis]+=sign*exit
  const escape=[...port] as V3;let extension=clearance+.014
  do{escape[axis]=port[axis]+sign*extension;extension+=.025}while(extension<.25&&solids.some(s=>contains(inflate(s,clearance+.001),escape)))
  if(solids.some(s=>s.id!==host.id&&hit(port,escape,inflate(s,Math.max(.001,clearance-.026)+.0002))!==null))continue
  if(solids.some(s=>contains(inflate(s,clearance),escape)))continue
  const preference=Math.max(-1,Math.min(1,(preferred[axis]||0)*sign/Math.max(.001,length(preferred))))
  if(avoid.some(b=>contains(b,escape)||hit(port,escape,b)!==null))continue
  faces.push({port,escape,host:host.id,cost:Math.abs(exit)-.008*preference})
 }
 faces.sort((a,b)=>a.cost-b.cost)
 return faces[0]??{port:nominal,escape:nominal,host:seed.id}
}
