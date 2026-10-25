# Jue's Baby Co. — Stage 6A: Order & Inventory Safety Design

**Design status:** 2026-10-25 · Stage 6A **DESIGNED / SIMULATION-ONLY**; no order database, ordering endpoint, customer cart, payment integration or real inventory reservation has been deployed.
**Scope:** Jue-only `juesbabyco/jues-baby-website`; dedicated Supabase `izeezajdiawiaweffbrh` in org `cgqjblrthxmahtqmwzjz`. Never touch MindCare or replace V8 `index.html` by inference.
**Source facts:** `public.jues_products` currently has `stock_qty` **per product**, `sizes text[]`, `price_cents`, `published` and an optional private image path. At design time exactly **1 TEST item**, **0 published**, **1 attached JPEG**. There are NO orders, inventory reservation or payment tables yet. Existing test stock 4 is NOT confirmed physical merchandise.

## 1 — Decisions and non-negotiable invariants

1. **Staging-first.** No guest checkout, personal information intake, irreversible paid action or inventory deduction from the public site at Stage 6A. The existing V8 demo remains untouched; any order simulator uses conspicuously fictional fixtures kept in browser memory only.
2. **Separate stock by sellable variant.** A purchase references one **product + size**, not the global product `stock_qty`. Future `jues_product_variants`: `id`, `product_id`, canonical `size`, `on_hand`, `reserved`, `active`, `updated_at`; unique (`product_id`, `size`). Invariant `0 <= reserved <= on_hand`; availability = `on_hand - reserved`. Product-level stock is an existing **demo display field** until a tested migration reconciles it.
3. **Server owns prices and stock.** The customer can submit variant ID and quantity only. The server reads current product/variant price and published/sale-enabled state, snapshots USD cents/size/name into order lines. Browser-submitted prices or claimed totals must never decide what is charged.
4. **Atomic all-or-nothing stock reservation.** Validate every cart line and reserve ALL variants in ONE database transaction. Lock variant rows in deterministic sorted ID order (`SELECT ... FOR UPDATE` or an equivalent conditional atomic update with checked row counts). Fail with no order or stock changes if ANY line is out of stock, unpublished, invalid or inactive. Never check stock in browser and update it later as separate requests.
5. **Idempotency and retries.** Each checkout attempt uses a client-generated high-entropy request key scoped to the actor/session. Store UNIQUE (`actor_scope`,`idempotency_key`) plus a canonical request fingerprint; same key+same payload returns the SAME order/receipt without new reservation. Same key+different payload is a **409 conflict**. Idempotency records survive cancellation/expiry/fulfilment, retries and restarts for a defined retention policy. A new key represents a new attempt, subject to rate controls.
6. **Strict transitions.** Initially `RESERVED` (not payment, not accepted), then only the approved owner can `CONFIRM` (or cancel). `FULFILLED` only from `CONFIRMED`; `CANCELLED` from `RESERVED` or `CONFIRMED`; `EXPIRED` from `RESERVED` only. Terminal states never transition. Cancellation/expiry releases a hold ONCE. Fulfilment consumes held quantity ONCE. `payment_state` is **separate** and initially `NOT_INTEGRATED`; neither reservation nor owner confirmation means paid. Do not automatically hand over goods without an approved settlement or explicit authorised pay-on-collection flow.
7. **Hold expiry / cleanup.** A new `RESERVED` order has a bounded server timestamp `expires_at` (proposed 15 minutes, *not approved as a business policy*). A governed server job releases expired unconfirmed holds transactionally; accepted orders cannot expire silently. Cron delays must not allow overselling. On access, stale pending holds can be detected and rejected/released safely, with row locks.
8. **Owner adjustments vs active holds.** Owner stock corrections are server validated; on-hand cannot be set below reserved. Owner product deletion must become archive/unpublish/soft-retire once historical orders exist. Existing owner dashboard Delete is staging-only and must be reviewed before enabling ordering.
9. **Inventory ledger and history.** Record signed, idempotent stock events (received, correction, reserved, released, fulfilled, returned) with actor/request ID, variant, quantity, order and timestamps; historical order-line snapshots remain immutable even when catalogue names/prices change. No direct anonymous table writes.
10. **Safety and customer-data boundary.** Do not collect names, phone numbers, addresses, delivery details or payments before a privacy notice, retention/deletion policy, security access tests and founder approval. No owner secrets/service keys in GitHub Pages. Order submission eventually needs a trusted, authenticated or tightly governed backend endpoint with abuse controls; public read-only catalogue RLS does not authorize orders. Owner approval via server-checked allowlist, never user-editable claims.
11. **Money and delivery.** Currency USD cents, integer-only; order totals calculated from server snapshots (include delivery quote and tax if applicable before final consent). Customer choice of Harare delivery/collection, pickup location, return/refund terms and payment provider are BUSINESS DECISIONS **not yet approved**. Do not invent rates or payment method support.
12. **Capacity/cost.** Review Jue's free-tier Supabase database, storage, functions, quota and expected paid costs before backend orders are enabled. No services or paid providers activated in this stage.

## 2 — Proposed server-side schema (DESIGN ONLY; no DDL deployed)

| Future table | Important fields and invariants | Allowed access |
|---|---|---|
| `jues_product_variants` | UUID PK, product UUID FK; size; integer `on_hand >= 0`, `reserved >= 0`, `reserved <= on_hand`; unique product+size; active flag | Public may read only sellable published variants via safe invoker/API; owner can adjust with audited server operation, not unrestricted changes |
| `jues_orders` | UUID, opaque checkout actor scope, idempotency key/fingerprint, status, currency USD, subtotal cents, expires_at, created_at, payment_state NOT_INTEGRATED | No anonymous direct table access; trusted backend handles creation; approved owner gets least-privileged reads |
| `jues_order_items` | order FK, variant FK, product/size/name and unit-price-cents snapshots, qty, line total; unique (order,variant) | Immutable after creation except tightly controlled operations; no public direct writes |
| `jues_inventory_events` | UUID, unique effect key, variant, order, signed effect, event type, actor/authority evidence and timestamp | Append-only from trusted transactional server code; restricted read for audit |
| `jues_order_transitions` | order FK, old/new state, actor identity, event time, reason, unique transition event | Append-only internal/owner audit |
| `jues_idempotency_requests` | actor scope + key UNIQUE, canonical request hash, order FK, created/expiry metadata | Backend-only. A duplicate key cannot reserve stock again |

No real customer PII columns are included until a separate Stage 6 privacy and customer-identity design is accepted. Public visitor identity/security model is still OPEN.

## 3 — Future create/reserve algorithm (pseudocode, NOT deployed)

```text
POST /staging/order-attempts (future trusted backend ONLY)
validate rate-limit, session scope, key (random), bounded distinct cart lines, integer qty
BEGIN TRANSACTION
  lock idempotency row/key scoped by actor; canonicalise payload
  if matching key already committed:
     same fingerprint => return existing snapshot, NEVER reserve again
     changed fingerprint => reject with conflict
  fetch variant rows in deterministic order; lock ALL relevant rows
  validate active + published + correct size + current price and positive quantity
  for every line assert available(on_hand - reserved) >= requested qty
  create RESERVED order + server price snapshots + owner-independent hold expiry
  atomically increment reserved for all items
  insert inventory hold events + idempotency binding
COMMIT
return opaque order reference (NOT a payment receipt)
```

Cancel/expiry: transactional state compare-and-set + release holds exactly once + append ledger once. Confirm: owner-only transition, holds stay. Fulfil: owner-only compare-and-set + decrement both on_hand and reserved once. Retrying transitions after state changes must be idempotent or rejected, never repeated effects.

## 4 — Required adversarial tests before enabling an order endpoint

- Two customers request the LAST item simultaneously: precisely one reservation wins; other gets OUT_OF_STOCK; no negative available stock.
- Multi-size lines: stock for Newborn cannot satisfy 3–6m; invalid/unpublished variants never sell.
- Idempotency: double-tap / refresh / same key yields same order, not two; same key different cart gets conflict; key survives expiry and reconnect.
- Multi-line insufficient stock rolls the *entire* operation back. Simultaneous differently ordered carts do not deadlock indefinitely.
- Cancellation, expiry, fulfilment and retries preserve `reserved <= on_hand`, never release/consume twice; terminal transitions blocked; no silent pay-state changes.
- Negative authorization: anon/nonowner cannot insert/update orders, stock, owner approval or inventory events via Data API; security-definer functions, if eventually needed, are non-exposed/private and grant-controlled.
- Malformed quantities, overflow, >max cart lines, renamed/unpublished products, changed prices and stock corrections are denied or handled with fresh snapshots.
- Fake payment callbacks and duplicated or out-of-order webhooks have **no effect** until a separate approved payment stage; no secrets in code.
- No customer PII stored during simulations. Evidence for real PostgreSQL transaction/concurrency and direct HTTP RLS must precede any live customer test.

## 5 — Stage 6A deliverables and go/no-go

Stage 6A delivers this reviewable design plus `order-stage6a-engine.js` and `order-stage6a-tests.html`: a **local, fictional, in-memory order/stock simulation**. It does not prove multi-user database concurrency. Later Stage 6B can propose isolated SQL migrations and transactional tests with explicit founder review; Stage 6C would implement staging-only ordering behind verified backend authorization; a separate Stage 6D+ addresses policies, fulfilment/returns and payments only after approval.

**Current gate:** Stage 6A may be called **DESIGNED** when this file is committed; simulator must have code/runtime checks before it can be called BUILT/VERIFIED. Stage 6 overall remains **OPEN**; Stage 7 launch not authorized. Keep the previously tested private TEST romper, photo, owner login and old V8 site unchanged.
