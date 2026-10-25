/* Jue's Baby Co. Stage 6A — FICTIONAL in-memory order/stock sandbox.
   NO Supabase, no API/network, no storage, no payment, no customer data.
   Models business rules only; synchronous JS is NOT a database race test. */
(function(root){
 'use strict';
 function clone(x){return JSON.parse(JSON.stringify(x))}
 function result(code){return {ok:false,code}}
 function makeSandbox(fixtureVariants){
  if(!Array.isArray(fixtureVariants)||!fixtureVariants.length)throw Error('Fixture stock required');
  const stock=Object.create(null),orders=Object.create(null),keys=Object.create(null);
  let orderSerial=0;
  for(const v of fixtureVariants){
   if(!v||!/^[A-Za-z0-9_-]{1,70}$/.test(v.id||'')||stock[v.id])throw Error('Duplicate/invalid fixture variant id');
   if(!Number.isSafeInteger(v.on_hand)||v.on_hand<0||!Number.isSafeInteger(v.price_cents)||v.price_cents<1)throw Error('Invalid fixture stock or price');
   stock[v.id]={id:v.id,name:String(v.name||v.id),size:String(v.size||'One size'),on_hand:v.on_hand,reserved:0,price_cents:v.price_cents,active:v.active!==false,published:v.published!==false};
  }
  function snapshot(){
   return clone({stock:Object.values(stock),orders:Object.values(orders).map(o=>o)});
  }
  function invariant(){
   return Object.values(stock).every(v=>
    Number.isSafeInteger(v.on_hand)&&v.on_hand>=0&&Number.isSafeInteger(v.reserved)&&v.reserved>=0&&v.reserved<=v.on_hand
   );
  }
  function attempt(req){
   if(!req||!/^[A-Za-z0-9_-]{12,128}$/.test(req.key||''))return result('BAD_IDEMPOTENCY_KEY');
   if(!Array.isArray(req.lines)||req.lines.length===0||req.lines.length>10)return result('BAD_CART');
   const seen=new Set(),canon=[];
   for(const line of req.lines){
    if(!line||typeof line.variant_id!=='string'||!stock[line.variant_id])return result('UNKNOWN_VARIANT');
    if(seen.has(line.variant_id))return result('DUPLICATE_VARIANT_LINE');
    if(!Number.isSafeInteger(line.qty)||line.qty<1||line.qty>10)return result('BAD_QUANTITY');
    seen.add(line.variant_id);canon.push({variant_id:line.variant_id,qty:line.qty});
   }
   canon.sort((a,b)=>a.variant_id.localeCompare(b.variant_id,'en'));
   const fingerprint=JSON.stringify(canon);const prior=keys[req.key];
   if(prior){
    if(prior.fingerprint!==fingerprint)return result('IDEMPOTENCY_CONFLICT');
    return {ok:true,replayed:true,order:clone(orders[prior.order_id])};
   }
   let total=0;const items=[];
   for(const c of canon){
    const v=stock[c.variant_id];
    if(!v.published||!v.active)return result('UNAVAILABLE_VARIANT');
    if((v.on_hand-v.reserved)<c.qty)return result('OUT_OF_STOCK');
    const lineTotal=v.price_cents*c.qty;
    if(!Number.isSafeInteger(lineTotal)||!Number.isSafeInteger(total+lineTotal))return result('TOTAL_OVERFLOW');
    total+=lineTotal;
    items.push({variant_id:v.id,name:v.name,size:v.size,qty:c.qty,unit_price_cents:v.price_cents,line_total_cents:lineTotal});
   }
   // All preflight checks pass before any reservation changes.
   for(const c of canon)stock[c.variant_id].reserved+=c.qty;
   const id='S6A-FICTIONAL-'+String(++orderSerial).padStart(3,'0');
   orders[id]={id,state:'RESERVED',payment_state:'NOT_INTEGRATED',currency:'USD',total_cents:total,items};
   keys[req.key]={fingerprint,order_id:id};
   if(!invariant())throw Error('Fatal sandbox invariant violation');
   return {ok:true,replayed:false,order:clone(orders[id])};
  }
  function transition(orderId,action){
   const o=orders[orderId];if(!o)return result('UNKNOWN_ORDER');
   if(action==='confirm'){
    if(o.state!=='RESERVED')return result('INVALID_TRANSITION');
    o.state='CONFIRMED';
   }else if(action==='cancel'){
    if(o.state!=='RESERVED'&&o.state!=='CONFIRMED')return result('INVALID_TRANSITION');
    for(const i of o.items)stock[i.variant_id].reserved-=i.qty;
    o.state='CANCELLED';
   }else if(action==='expire'){
    if(o.state!=='RESERVED')return result('INVALID_TRANSITION');
    for(const i of o.items)stock[i.variant_id].reserved-=i.qty;
    o.state='EXPIRED';
   }else if(action==='fulfill'){
    if(o.state!=='CONFIRMED')return result('INVALID_TRANSITION');
    for(const i of o.items){stock[i.variant_id].reserved-=i.qty;stock[i.variant_id].on_hand-=i.qty}
    o.state='FULFILLED';
   }else return result('INVALID_ACTION');
   if(!invariant())throw Error('Fatal sandbox invariant violation');
   return {ok:true,order:clone(o)};
  }
  function setFixtureStock(variantId,onHand){
   const v=stock[variantId];if(!v)return result('UNKNOWN_VARIANT');
   if(!Number.isSafeInteger(onHand)||onHand<0||onHand<v.reserved)return result('BELOW_RESERVED');
   v.on_hand=onHand;
   return {ok:true,stock:clone(v)};
  }
  function changeFixturePrice(variantId,priceCents){
   const v=stock[variantId];if(!v)return result('UNKNOWN_VARIANT');
   if(!Number.isSafeInteger(priceCents)||priceCents<1)return result('BAD_PRICE');
   v.price_cents=priceCents;return {ok:true,stock:clone(v)};
  }
  return Object.freeze({attempt,transition,snapshot,invariant,setFixtureStock,changeFixturePrice});
 }
 root.JuesOrderSimulation=Object.freeze({makeSandbox});
})(window);
