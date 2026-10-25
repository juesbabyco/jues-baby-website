/* Jue's Baby Co. — shared, pure catalogue filtering/sorting helpers.
   This file never queries Supabase or creates product records.
   Used by the isolated Stage 5D/5E staging storefront and its fixture test page. */
(function(root){
 'use strict';
 function filterAndSort(source,options){
  const opts=options||{};
  const q=String(opts.query||'').trim().toLocaleLowerCase('en');
  const age=String(opts.age||'');
  const sort=String(opts.sort||'recent');
  const items=Array.isArray(source)?source:[];
  const rows=items.map((item,index)=>({item,index})).filter(({item})=>{
   if(!item||typeof item!=='object')return false;
   const matchesAge=!age||item.age_group===age||(Array.isArray(item.sizes)&&item.sizes.includes(age));
   if(!matchesAge)return false;
   return !q||[item.name,item.category,item.age_group].some(v=>String(v||'').toLocaleLowerCase('en').includes(q));
  });
  // Numeric cents only; ties preserve the backend's newest-first input order.
  if(sort==='low'||sort==='high'){
   rows.sort((a,b)=>{
    const pa=Number(a.item.price_cents),pb=Number(b.item.price_cents);
    const na=Number.isFinite(pa)?pa:Number.POSITIVE_INFINITY;
    const nb=Number.isFinite(pb)?pb:Number.POSITIVE_INFINITY;
    const diff=na-nb;
    // Treat invalid price as last for either direction.
    if(!Number.isFinite(pa)&&!Number.isFinite(pb))return a.index-b.index;
    if(!Number.isFinite(pa))return 1;
    if(!Number.isFinite(pb))return -1;
    return (sort==='low'?diff:-diff)||(a.index-b.index);
   });
  }
  return rows.map(x=>x.item);
 }
 root.JuesCatalogueLogic=Object.freeze({filterAndSort});
})(window);
