'use strict';
const C = require('../type_contract.js');
function validateProfile(ast, source) {
 const issues=[];
 const add=(kind,node,detail)=>issues.push({kind,line:node?.pos?.line||node?.line||1,detail});
 const req=(ok,n,detail)=>{if(!ok)add('invalid_type',n,detail);};
 const unary='ABS SQRT LN LOG EXP SIN COS TAN ASIN ACOS ATAN TRUNC ROUND FLOOR CEIL REAL LREAL INT DINT SINT WORD BYTE DWORD BOOL TIME BOOL_TO_INT INT_TO_BOOL INT_TO_REAL REAL_TO_INT TIME_TO_INT INT_TO_TIME NOT_WORD MOVE LEN'.split(' ');
 const fixed=Object.fromEntries(unary.map(k=>[k,1]));for(const k of ['ATAN2','SHL','SHR','ROL','ROR'])fixed[k]=2;fixed.LIMIT=3;fixed.SEL=3;
 const variadic=new Set(['MIN','MAX','MUX','AND_WORD','OR_WORD','XOR_WORD','CONCAT']);
 const tokens=require('./lexer.js').tokenize(source);const constants=new Set();let inConstant=false;
 for(let i=0;i<tokens.length;i++){const t=tokens[i];if(/^VAR(?:_INPUT|_OUTPUT|_IN_OUT|_TEMP)?$/.test(t.value||'')){let k=i+1;inConstant=false;while(['CONSTANT','RETAIN'].includes(tokens[k]?.value)){if(tokens[k].value==='CONSTANT')inConstant=true;k++;}}if(t.value==='END_VAR')inConstant=false;if(inConstant&&t.kind==='ident'&&[':',','].includes(tokens[i+1]?.value||tokens[i+1]?.text))constants.add(t.text.toUpperCase());}
 if(tokens[0]?.value!=='PROGRAM')add('explicit_PROGRAM_required',null,'PROGRAM declaration required');
 for(const pou of ast.pous){
  const syms=new Map(pou.vars.map(v=>[v.name.toUpperCase(),v]));const controls=[];
  function symbol(name,n){const v=syms.get(name.toUpperCase());if(!v)add('undeclared_variable',n,name);return v;}
  const inferred=n=>C.infer(n,name=>syms.get(name.toUpperCase()));
  function writable(name,n){if(constants.has(name.toUpperCase()))add('constant_write',n,name);if(controls.includes(name.toUpperCase()))add('for_control_write',n,name);}
  function expr(n){if(!n)return null;
   switch(n.k){
    case 'lit':try{C.checked(n.value,n.type);}catch(e){add('invalid_literal',n,e.message);}break;
    case 'var':{const v=symbol(n.name,n);if(v?.dim)add('array_requires_index',n,n.name);if(v?.fbType)add('FB_requires_member',n,n.name);break;}
    case 'index':{const v=n.obj.k==='var'?symbol(n.obj.name,n.obj):null;if(!v?.dim)add('index_requires_array',n,'scalar or nested array');req(C.integer(expr(n.idx)),n,'array index must be integer');break;}
    case 'member':{const v=n.obj.k==='var'?symbol(n.obj.name,n.obj):null;const prop=n.prop.toUpperCase();if(!v?.fbType||v.dim||!(v.fbType==='TON'?['IN','PT','Q','ET']:['CLK','Q']).includes(prop))add('invalid_FB_member',n,n.prop);break;}
    case 'un':{
     // Signed minimum literals have no representable positive value of the same signed type.
     if(n.op==='-'&&n.e.k==='lit'&&C.integer(n.e.type)){try{C.checked(-n.e.value,inferred(n));}catch(e){add('invalid_literal',n,e.message);}break;}
     const t=expr(n.e);req(n.op==='NOT'?(t==='BOOL'||C.integer(t)):(C.numeric(t)||t==='TIME'),n,'invalid unary operand');break;
    }
    case 'bin':{const a=expr(n.l),b=expr(n.r),op=n.op;
     if(['AND','OR','XOR'].includes(op))req((a==='BOOL'&&b==='BOOL')||(C.integer(a)&&C.integer(b)),n,'logical operands must both be BOOL or integer');
     else if(['=','<>','<','>','<=','>='].includes(op)){req(!!C.common([a,b]),n,'incompatible comparison operands');if(a==='STRING'&& !['=','<>'].includes(op))add('unsupported_string_ordering',n,'String equality is supported; ordering is outside the local subset');}
     else if(a==='TIME'||b==='TIME')req((['+','-'].includes(op)&&a==='TIME'&&b==='TIME')||(['*','/'].includes(op)&&a==='TIME'&&C.numeric(b))||(op==='*'&&C.numeric(a)&&b==='TIME'),n,'invalid TIME arithmetic');
     else {req(C.numeric(a)&&C.numeric(b),n,'arithmetic requires numbers, not TIME/BOOL');if(op==='MOD')req(C.integer(a)&&C.integer(b),n,'MOD requires integers');}
     break;}
    case 'call':return call(n,false);
    default:add('unsupported_expression',n,n.k);
   }
   return inferred(n);
  }
  function target(n){
   if(n.k==='member'){const v=n.obj.k==='var'?symbol(n.obj.name,n.obj):null;const allowed=v?.fbType==='TON'?['IN','PT']:v?.fbType==='R_TRIG'?['CLK']:[];if(!allowed.includes(n.prop.toUpperCase()))add('invalid_FB_write',n,n.prop);if(n.obj.k==='var')writable(n.obj.name,n);return expr(n);}
   const name=n.k==='var'?n.name:n.k==='index'&&n.obj.k==='var'?n.obj.name:null;
   if(!name){add('invalid_assignment_target',n,'only scalar or array elements writable');return expr(n);}writable(name,n);return expr(n);
  }
  function call(n,statement){const name=n.name.toUpperCase(),decl=syms.get(name),fb=decl?.fbType,args=n.args;
   if(fb){if(!statement)add('FB_call_in_expression',n,name);if(decl.dim)add('array_requires_index',n,name);if(constants.has(name))add('constant_write',n,name);
    const ins=fb==='TON'?['IN','PT']:['CLK'],outs=fb==='TON'?['Q','ET']:['Q'];const used=new Set();let idx=0;
    for(const a of args){const key=(a.name||ins[idx++]||'').toUpperCase();if(used.has(key))add('duplicate_argument',n,key);used.add(key);if(!(a.isOutput?outs:ins).includes(key))add('invalid_FB_argument',n,key);const t=a.isOutput?target(a.value):expr(a.value),expected=['PT','ET'].includes(key)?'TIME':'BOOL';req(t===expected,n,'FB argument '+key+' requires '+expected);}
    return null;
   }
   if(!Object.hasOwn(fixed,name)&&!variadic.has(name)){add('unsupported_function',n,name);args.forEach(a=>expr(a.value));return null;}
   if((Object.hasOwn(fixed,name)&&args.length!==fixed[name])||(variadic.has(name)&&args.length<(name==='MUX'?3:2)))add('function_arity',n,name);
   if(args.some(a=>a.name||a.isOutput))add('unsupported_named_function_argument',n,name);
   const ts=args.map(a=>expr(a.value));
   if(C.exact[name])req(ts[0]===C.exact[name][0],n,name+' requires '+C.exact[name][0]);
   else if(C.casts[name])req(ts.every(C.scalar),n,name+' requires a supported scalar value');
   else if(['LEN','CONCAT'].includes(name))req(ts.every(t=>t==='STRING'),n,name+' requires strings');
   else if(name==='SEL'||name==='MUX'){req(name==='SEL'?ts[0]==='BOOL':C.integer(ts[0]),n,'invalid '+name+' selector');req(!!C.common(ts.slice(1)),n,name+' value types');}
   else if(C.bitFns.has(name))req(ts.every(C.integer),n,name+' requires integer/bit arguments');
   else if(name==='MOVE'){} // Return preserves its operand type.
   else req(ts.every(C.numeric),n,name+' requires numeric arguments');
   return C.callType(name,ts);
  }
  function stmts(body,depth=0){for(const n of body||[]){switch(n.k){
   case 'assign':{const to=target(n.target),from=expr(n.value);req(C.assignable(to,from),n,'assignment '+from+' -> '+to+' requires explicit conversion');break;}
   case 'call':call(n,true);break;
   case 'if':for(const b of n.branches){req(expr(b.cond)==='BOOL',b.cond,'IF condition must be BOOL');stmts(b.body,depth);}stmts(n.orElse,depth);break;
   case 'case':{req(C.integer(expr(n.selector)),n,'CASE selector must be integer');const labels=[];for(const b of n.cases){for(const l of b.labels){req(Number.isSafeInteger(l.lo)&&Number.isSafeInteger(l.hi)&&l.lo<=l.hi,n,'invalid CASE label range');if(labels.some(x=>l.lo<=x.hi&&l.hi>=x.lo))add('overlapping_CASE_labels',n,'overlapping labels');labels.push(l);}stmts(b.body,depth);}stmts(n.orElse,depth);break;}
   case 'for':{const v=symbol(n.varName,n);req(C.integer(v?.type)&&!v?.dim,n,'FOR control must be declared integer scalar');writable(n.varName,n);for(const e of [n.from,n.to,n.by].filter(Boolean)){const t=expr(e);req(C.integer(t)&&C.assignable(v?.type,t),e,'FOR bounds require compatible integers');}controls.push(n.varName.toUpperCase());stmts(n.body,depth+1);controls.pop();break;}
   case 'while':req(expr(n.cond)==='BOOL',n,'WHILE condition must be BOOL');stmts(n.body,depth+1);break;
   case 'repeat':stmts(n.body,depth+1);req(expr(n.until)==='BOOL',n,'UNTIL condition must be BOOL');break;
   case 'exit':case 'continue':if(!depth)add('loop_control_outside_loop',n,n.k);break;
   case 'return':break;
   default:add('unsupported_statement',n,n.k);
  }}}
  for(const v of pou.vars){if(v.initial!==undefined){if(v.fbType)add('unsupported_FB_initializer',v,'Scalar initializer cannot initialize an FB instance');req(C.assignable(v.type,v.initialType),v,'initializer '+v.initialType+' -> '+v.type);try{C.checked(v.initial,v.type);}catch(e){add('invalid_initializer',v,e.message);}}}
  stmts(pou.body);
 }
 return issues;
}
module.exports={validateProfile};
