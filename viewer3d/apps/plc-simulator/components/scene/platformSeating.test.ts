import {expect,it} from 'vitest'
import {platformSeating} from './platformSeating'
const d=(id:string,pos:number[],size:number[],visualVariant?:string)=>({id,pos,size,visualVariant})
it('seats a photoeye foot above the bench and shortens its post with fixed sensor height',()=>{
 const bench=d('SUPPLY_A',[0,.395,0],[.4,.79,.92],'hard-workbench')
 const foot=d('SUPPLY_A_PHOTO_FOOT',[-.20,.78,0],[.18,.02,.08])
 const mount=d('SUPPLY_A_PHOTO_MOUNT',[-.26,.8225,0],[.08,.065,.08])
 const ds=[bench,foot,mount],f=platformSeating(foot,ds),m=platformSeating(mount,ds)
 expect(foot.pos[1]+f.lift-foot.size[1]/2).toBeCloseTo(.79)
 expect(foot.pos[0]+f.x!+f.width!/2).toBeCloseTo(bench.pos[0]-bench.size[0]/2)
 expect(mount.pos[1]+m.bottom!).toBeCloseTo(foot.pos[1]+f.lift+foot.size[1]/2)
 expect(mount.pos[1]+mount.size[1]/2).toBeCloseTo(.855)
 expect(platformSeating({...foot,pos:[-.20,.80,0]},ds).lift).toBe(0)
})
it('butt-joins the gauge column under its crosshead and clears the moving probe',()=>{
 const probe=d('GAUGE_PROBE',[0,1.38,0],[.08,.12,.08],'hard-probe')
 const column=d('GAUGE_COLUMN',[0,1.18,.38],[.08,.66,.08])
 const head=d('GAUGE_CROSSHEAD',[0,1.48,.18],[.22,.06,.4])
 const carriage=d('GAUGE_CARRIAGE',[0,1.4,.205],[.18,.06,.35])
 const ds=[probe,column,head,carriage]
 expect(column.pos[1]+platformSeating(column,ds).top!).toBeCloseTo(1.45)
 expect(carriage.pos[2]+platformSeating(carriage,ds).front!).toBeCloseTo(.04)
})
it('fits a rear panel between the posts rather than through their end faces',()=>{
 const panel=d('A_REAR_PANEL',[0,1.55,1.28],[1.27,1.4,.04])
 const posts=[-1,1].map(s=>d('A_REAR_POST_'+s,[s*.61,1.57,1.25],[.055,1.44,.07]))
 expect(platformSeating(panel,[panel,...posts]).width).toBeCloseTo(1.165)
 expect(platformSeating(d('OTHER',[0,0,0],[1,1,1]),posts)).toEqual({lift:0})
})
