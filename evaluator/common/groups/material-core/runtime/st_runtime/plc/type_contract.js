'use strict';
// One expression type model for admission and execution. See TYPE_CONTRACT.txt.
const integers = new Set(['SINT','INT','DINT','BYTE','WORD','DWORD']);
const bits = new Set(['BYTE','WORD','DWORD']);
const integer = t => integers.has(t);
const numeric = t => integer(t) || t === 'REAL';
const scalar = t => numeric(t) || t === 'TIME' || t === 'BOOL';
const ranges = {SINT:[-128,127],INT:[-32768,32767],DINT:[-2147483648,2147483647],BYTE:[0,255],WORD:[0,65535],DWORD:[0,4294967295],TIME:[-Number.MAX_SAFE_INTEGER,Number.MAX_SAFE_INTEGER]};
function checked(value,type) {
 if(type==='STRING') {if(typeof value!=='string')throw Error('STRING value required');return value;}
 if(type==='BOOL') {if(typeof value!=='boolean')throw Error('BOOL value required');return value;}
 if(typeof value!=='number'||!Number.isFinite(value))throw Error('Non-finite or nonnumeric '+type+' value');
 if(type==='REAL')return value; // Published local REAL uses binary64; not an IEC REAL32 portability claim.
 const bounds=ranges[type];
 if(!bounds||!Number.isSafeInteger(value)||value<bounds[0]||value>bounds[1])throw Error('Out-of-range or fractional '+type+' value: '+value);
 return value;
}
function roundEven(x) {checked(x,'REAL');const lo=Math.floor(x),d=x-lo;return d<0.5?lo:d>0.5?lo+1:lo%2===0?lo:lo+1;}
function common(ts) {
 if(!ts.length)return null;
 if(ts.every(t=>t===ts[0]))return ts[0];
 if(ts.every(numeric))return ts.includes('REAL')?'REAL':ts.includes('DWORD')?'DWORD':ts.some(t=>['DINT','WORD'].includes(t))?'DINT':'INT';
 return null;
}
function assignable(to,from) {
 if(!to||!from)return false;
 if(to===from)return true;
 if(to==='REAL'&&numeric(from))return true;
 if(integer(to)&&integer(from))return ranges[to][0]<=ranges[from][0]&&ranges[to][1]>=ranges[from][1];
 return false;
}
const exact={BOOL_TO_INT:['BOOL','INT'],INT_TO_BOOL:['INT','BOOL'],INT_TO_REAL:['INT','REAL'],REAL_TO_INT:['REAL','INT'],TIME_TO_INT:['TIME','INT'],INT_TO_TIME:['INT','TIME']};
const casts={BOOL:'BOOL',INT:'INT',DINT:'DINT',SINT:'SINT',REAL:'REAL',LREAL:'REAL',TIME:'TIME',BYTE:'BYTE',WORD:'WORD',DWORD:'DWORD'};
const realFns=new Set('SQRT LN LOG EXP SIN COS TAN ASIN ACOS ATAN ATAN2 ROUND FLOOR CEIL'.split(' '));
const bitFns=new Set('SHL SHR ROL ROR AND_WORD OR_WORD XOR_WORD NOT_WORD'.split(' '));
const width=t=>t==='BYTE'?8:t==='DWORD'||t==='DINT'?32:16;
const bitType=t=>width(t)===8?'BYTE':width(t)===32?'DWORD':'WORD';
function callType(name,ts) {
 if(exact[name])return exact[name][1];if(casts[name])return casts[name];
 if(realFns.has(name))return 'REAL';
 if(['TRUNC','LEN'].includes(name))return 'DINT';
 if(name==='CONCAT')return 'STRING';if(name==='MOVE')return ts[0];
 if(['SEL','MUX'].includes(name))return common(ts.slice(1));
 if(['MIN','MAX','LIMIT'].includes(name))return common(ts);
 if(name==='ABS')return ts[0];
 if(bitFns.has(name))return ['SHL','SHR','ROL','ROR','NOT_WORD'].includes(name)?bitType(ts[0]):bitType(common(ts));
 return null;
}
function binaryType(op,a,b) {
 if(['=','<>','<','>','<=','>='].includes(op))return 'BOOL';
 if(['AND','OR','XOR'].includes(op))return a==='BOOL'&&b==='BOOL'?'BOOL':common([a,b]);
 if(op==='**')return 'REAL';
 if(a==='TIME'||b==='TIME')return 'TIME';
 return common([a,b]);
}
// Pure integer-literal arithmetic is sized by its exact value. Variables, calls,
// conversions, TIME/REAL and bit operations are deliberately not constant-folded.
function integerConstant(e) {
 if(!e)return null;
 if(e.k==='lit' && ['INT','DINT'].includes(e.type) && Number.isSafeInteger(e.value))return BigInt(e.value);
 if(e.k==='un' && ['+','-'].includes(e.op)){const v=integerConstant(e.e);return v===null?null:e.op==='-'?-v:v;}
 if(e.k==='bin' && ['+','-','*'].includes(e.op)){
  const a=integerConstant(e.l),b=integerConstant(e.r);if(a===null||b===null)return null;
  // Bound intermediate diagnostic computation; execution still checks DINT overflow.
  if(a < -2147483648n || a > 2147483648n || b < -2147483648n || b > 2147483648n)return null;
  return e.op==='+'?a+b:e.op==='-'?a-b:a*b;
 }
 return null;
}
function infer(e,lookup) {
 if(!e)return null;
 switch(e.k){
 case 'lit':return e.type;
 case 'var':{const d=lookup(e.name);return d?.fbType||d?.type||null;}
 case 'index':return infer(e.obj,lookup);
 case 'member':return ['ET','PT'].includes(e.prop.toUpperCase())?'TIME':'BOOL';
 case 'un':return e.op === '-' && e.e.k === 'lit' && integer(e.e.type) ? (-e.e.value >= -32768 && -e.e.value <= 32767 ? 'INT' : 'DINT') : infer(e.e,lookup);
 case 'bin':{const t=binaryType(e.op,infer(e.l,lookup),infer(e.r,lookup));const v=integerConstant(e);return t==='INT' && v!==null && (v < -32768n || v > 32767n) ? 'DINT' : t;}
 case 'call':return callType(e.name.toUpperCase(),e.args.map(a=>infer(a.value,lookup)));
 default:return null;
 }
}
function bitOperation(name,values,ts) {
 const type=callType(name,ts),w=width(type),mask=(1n<<BigInt(w))-1n;
 const u=x=>BigInt.asUintN(w,BigInt(x));
 let out;
 if(['SHL','SHR','ROL','ROR'].includes(name)){
  const count=values[1];if(!Number.isSafeInteger(count)||count<0)throw Error('Shift count must be a nonnegative integer');
  const v=u(values[0]);const c=BigInt(count);
  if(name==='SHL')out=count>=w?0n:(v<<c)&mask;
  if(name==='SHR')out=count>=w?0n:v>>c;
  if(name==='ROL'||name==='ROR'){const n=BigInt(count%w),back=BigInt(w)-n;out=name==='ROL'?((v<<n)|(v>>back))&mask:((v>>n)|(v<<back))&mask;}
 }else if(name==='NOT_WORD')out=(~u(values[0]))&mask;
 else out=values.map(u).reduce((a,b)=>name==='AND_WORD'?a&b:name==='OR_WORD'?a|b:a^b);
 return Number(out);
}
function bitwise(op,a,b,type) {
 const w=width(type),x=BigInt(a),y=b===undefined?0n:BigInt(b);
 const v=op==='NOT'?~x:op==='AND'?x&y:op==='OR'?x|y:x^y;
 return Number(bits.has(type)?BigInt.asUintN(w,v):BigInt.asIntN(w,v));
}
module.exports={integer,numeric,scalar,bits,ranges,checked,roundEven,common,assignable,exact,casts,realFns,bitFns,width,bitType,callType,binaryType,infer,bitOperation,bitwise};
