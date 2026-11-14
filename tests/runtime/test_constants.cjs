const releaseRoot=require('path').resolve(__dirname,'../../evaluator');
const fs=require('fs'),assert=require('assert/strict'),O=__dirname,roots=process.env.CONTRACT_TEST_ROOT?[process.env.CONTRACT_TEST_ROOT]:JSON.parse(fs.readFileSync(O+'/runtime-roots.json')).map(r=>releaseRoot+'/'+r),rows=[];
for(const root of roots){const {parseST}=require(root+'/st/parser'),{PlcRuntime}=require(root+'/runtime/vm');const source=(d,b)=>`PROGRAM Main VAR ${d} END_VAR ${b} END_PROGRAM`;
 for(const [expr,val] of [['-350*100',-35000],['450*100',45000],['32767+1',32768],['-32768-1',-32769],['-(200*200)',-40000],['(200*200)/3',13333],['200*200-10000',30000],['32767*32767',1073676289],['3/2',1],['3.0/2',1.5]]){
 const vm=new PlcRuntime(parseST(source('y:REAL;',`y:=${expr};`)));vm.scan(10);assert.equal(vm.fault,null,expr);assert.equal(vm.get('y'),val,expr);rows.push({root,expr,value:val});}
 for(const [d,b] of [['a:INT:=32767;y:DINT;','y:=a+1;'],['a:INT:=32640;','a:=a+160;'],['y:INT;','y:=INT(200*200);'],['y:DINT;','y:=2147483647+1;'],['a:TIME:=T#32770ms;y:DINT;','y:=TIME_TO_INT(a);'],['y:DINT;','y:=1/0;']]){
 const vm=new PlcRuntime(parseST(source(d,b)));vm.scan(10);assert.ok(vm.fault,b);rows.push({root,fault:b});}
 for(const [d,b] of [['y:INT;','y:=200*200;'],['y:TIME;','y:=INT_TO_TIME(200*200);']]){assert.throws(()=>parseST(source(d,b)));rows.push({root,reject:b});}
 const vm=new PlcRuntime(parseST(source('target:DINT:=45000;y:BOOL;','y:=(target>=-350*100) AND (target<=450*100);')));vm.scan(10);assert.equal(vm.fault,null);assert.equal(vm.get('y'),true);rows.push({root,range_comparison:true});
}
console.log('Constant checks',rows.length);
