import {expect,it} from 'vitest'
import {reviewFloorBounds} from './reviewBounds'
import type {Node,Review,Run} from './ReviewCanvas'

const node=(changes:Partial<Node>={}):Node=>({id:'m',name:'machine',p:[0,1,0],r:0,size:[1,1,1],shape:'box',color:'gray',...changes})
const run=(nodes:Node[],poses:Run['frames'][number]['poses']={},failure:string|null=null):Run=>({nodes,frames:[{t:1,poses,raw:{},phase:'',received:[],requests:[]}],failure,duration:1,events:[],received:[]})
const review=(runs:Review['runs']):Review=>({id:'test',title:'',primary:'',nodes:[],runs,scope:'',benchmark_accepted:false})

it('contains moving cylinders and alternate paths, but ignores failed escape and labels',()=>{
  const cylinder=node({shape:'cylinder',axis:'x',size:[.2,1,.2]})
  const label=node({id:'label',shape:'label',p:[100,0,100]})
  const r=review({normal:run([cylinder,label],{m:{p:[3,1,0],r:Math.PI/2}}),alternate:run([cylinder],{m:{p:[0,1,-2],r:0}}),negative:run([cylinder],{m:{p:[100,1,100],r:0}},'unsupported')})
  const b=reviewFloorBounds(r)!
  expect(b.x-b.width/2).toBeCloseTo(-.85)
  expect(b.x+b.width/2).toBeCloseTo(3.55)
  expect(b.z-b.depth/2).toBeCloseTo(-2.55)
  expect(b.z+b.depth/2).toBeCloseTo(.85)
})

it('uses world beam endpoints and the displayed pose size; excludes hidden material',()=>{
  const beam=node({shape:'beam',size:[.1,1,.1],points:[[0,1,0],[1,1,0]]})
  const hidden=node({id:'hidden',p:[50,0,50],visible:false})
  const b=reviewFloorBounds(review({normal:run([beam,hidden],{m:{p:[0,0,0],r:0,s:[.2,1,.2],points:[[2,1,1],[4,1,1]]}})}))!
  expect(b.x-b.width/2).toBeCloseTo(-.45)
  expect(b.x+b.width/2).toBeCloseTo(4.55)
  expect(b.z+b.depth/2).toBeCloseTo(1.55)
})

it('includes film width and material that becomes visible later in a normal run',()=>{
  const film=node({shape:'ribbon',size:[.004,.18,.004],points:[[0,1,0],[1,1,0]],width_axis:[0,0,1]})
  const material=node({id:'part',p:[0,1,0],size:[.2,.2,.2],visible:false})
  const b=reviewFloorBounds(review({normal:run([film,material],{part:{p:[0,1,2],r:0,visible:true}})}))!
  expect(b.z-b.depth/2).toBeLessThanOrEqual(-.09-.35)
  expect(b.z+b.depth/2).toBeCloseTo(2.45)
})


it('includes the vertical extent swept into Z by an X-axis rotating holder',()=>{
  const tall=node({size:[.5,2,.4]})
  const b=reviewFloorBounds(review({normal:run([tall],{m:{p:[0,1,0],r:0,rx:Math.PI/2}})}))!
  expect(b.depth).toBeCloseTo(2.7)
  expect(b.width).toBeCloseTo(1.2)
})
