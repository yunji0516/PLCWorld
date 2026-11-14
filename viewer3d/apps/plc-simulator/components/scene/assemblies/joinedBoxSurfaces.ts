/** Exposed surfaces of intersecting boxes in one rigid installation.
 * Remove buried/duplicate faces instead of moving a whole part or biasing depth.
 * Coordinates are normalized for the recorded part's existing mesh transform.
 */
type Box = {shape?:string;node?:string;pos:number[];size:number[]}
type Rect = [number,number,number,number]
const EPS=1e-7
function subtract(a:Rect,b:Rect):Rect[] {
 const x0=Math.max(a[0],b[0]),x1=Math.min(a[1],b[1]),y0=Math.max(a[2],b[2]),y1=Math.min(a[3],b[3])
 if(x1-x0<EPS||y1-y0<EPS)return [a]
 return [[a[0],x0,a[2],a[3]],[x1,a[1],a[2],a[3]],[x0,x1,a[2],y0],[x0,x1,y1,a[3]]].filter(r=>r[1]-r[0]>EPS&&r[3]-r[2]>EPS) as Rect[]
}
export function joinedBoxSurfaces(parts:readonly Box[],index:number):{positions:number[];normals:number[]}|null {
 const p=parts[index]
 if((p.shape??'box')!=='box'||p.node?.startsWith('protected'))return null
 const lo=p.pos.map((x,i)=>x-p.size[i]/2),hi=p.pos.map((x,i)=>x+p.size[i]/2)
 const peers=parts.flatMap((q,j)=>{
  if(j===index||(q.shape??'box')!=='box'||q.node!==p.node||q.size.some(v=>v<=0))return []
  const a=q.pos.map((x,i)=>x-q.size[i]/2),b=q.pos.map((x,i)=>x+q.size[i]/2)
  return a.some((v,i)=>v>hi[i]+EPS||b[i]<lo[i]-EPS)?[]:[{a,b,j}]
 })
 if(!peers.length)return null
 const positions:number[]=[],normals:number[]=[]
 let changed=false
 for(let axis=0;axis<3;axis++)for(const sign of [-1,1]) {
  const u=(axis+1)%3,v=(axis+2)%3,plane=sign<0?lo[axis]:hi[axis]
  let rects:Rect[]=[[lo[u],hi[u],lo[v],hi[v]]]
  for(const {a,b,j} of peers) {
   // A face belongs to the union only if the neighbouring volume does not
   // occupy its outward side. Coplanar outer faces get one stable owner.
   const outward=sign>0?b[axis]-plane:plane-a[axis]
   const inward=sign>0?plane-a[axis]:b[axis]-plane
   if(inward<-EPS||outward<-EPS||(Math.abs(outward)<=EPS&&j>index))continue
   const next=rects.flatMap(r=>subtract(r,[a[u],b[u],a[v],b[v]]))
   if(JSON.stringify(next)!==JSON.stringify(rects))changed=true
   rects=next
  }
  for(const [u0,u1,v0,v1] of rects) {
   const corners=[[u0,v0],[u1,v0],[u1,v1],[u0,v1]]
   for(const i of sign>0?[0,1,2,0,2,3]:[0,2,1,0,3,2]) {
    const point=[0,0,0],normal=[0,0,0]
    point[axis]=plane;point[u]=corners[i][0];point[v]=corners[i][1];normal[axis]=sign
    positions.push(...point.map((x,k)=>(x-p.pos[k])/p.size[k]));normals.push(...normal)
   }
  }
 }
 return changed?{positions,normals}:null
}
