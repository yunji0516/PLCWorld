const releaseRoot=require('path').resolve(__dirname,'../../evaluator');
const fs=require('fs'),path=require('path'),assert=require('node:assert/strict');
const base=__dirname;let checks=[];
const roots=[];
function walk(dir){for(const e of fs.readdirSync(dir,{withFileTypes:true})){const p=path.join(dir,e.name);if(e.isDirectory())walk(p);else if(e.name==='vm.js'&&p.includes('/runtime/'))roots.push(path.dirname(path.dirname(p)));}}
walk(releaseRoot);
for(const root of roots){
 const mode='division-only';
 const {parseST}=require(path.join(root,'st/parser.js'));const {PlcRuntime}=require(path.join(root,'runtime/vm.js'));
 function runtime(src){const p=parseST(src);return new PlcRuntime(p.program??p);}
 for(const [expr,div,ton] of [['a / b',1,1.5],['-a / b',-1,-1.5],['r / b',1.5,1.5],['(a / b) * 2.0',2,3],['a / 2.0',1.5,1.5]]){
 const r=runtime(`PROGRAM MAIN VAR a:DINT:=3; b:DINT:=2; r:REAL:=3.0; v:REAL; END_VAR v:=${expr}; END_PROGRAM`);r.scan(10);assert.equal(r.fault,null);assert.equal(r.get('v'),mode==='division-only'?div:ton);checks.push({root,mode,expr,value:r.get('v')});}
 for(const calls of [1,2]){
 const r=runtime(`PROGRAM MAIN VAR t:TON; END_VAR ${'t(IN:=TRUE,PT:=T#100ms);'.repeat(calls)} END_PROGRAM`);let times=[];for(let i=0;i<3;i++){r.scan(10);times.push(r.listFbInstances()[0].state.out.ET);}assert.deepEqual(times,[0,10,20]);checks.push({root,mode,calls,times});}
 const r=runtime('PROGRAM MAIN VAR t:TON; enable:BOOL:=TRUE; END_VAR IF enable THEN t(IN:=TRUE,PT:=T#100ms); END_IF; END_PROGRAM');r.scan(10);r.set('enable',false);r.scan(10);r.scan(10);r.set('enable',true);r.scan(10);const et=r.listFbInstances()[0].state.out.ET;assert.equal(et,30);checks.push({root,mode,skipped_call_ET:et});
}
console.log('Passed',checks.length);
