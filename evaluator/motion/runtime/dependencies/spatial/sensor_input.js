// Only the external sensor word is saturated. ST arithmetic and plant state are untouched.
function encodeSensorInputs(vm, inputs) {
 const delivered={...inputs}, saturated=[];
 for(const [name,value] of Object.entries(inputs)) {
  const type=vm.findSym(name)?.decl.type;
  const bounds=type==='INT'?[-32768,32767]:type==='DINT'?[-2147483648,2147483647]:null;
  if(bounds&&typeof value==='number'&&Number.isFinite(value)&&Number.isInteger(value)) {
   const encoded=Math.min(bounds[1],Math.max(bounds[0],value));
   if(encoded!==value){delivered[name]=encoded;saturated.push({name,type,delivered:encoded});}
  }
 }
 return {delivered,saturated};
}
module.exports={encodeSensorInputs};
