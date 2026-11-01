# Jue's Baby Co. — Stage 6B Private Order Lifecycle SQL Acceptance

**Reviewed:** 2026-11-01. **PRIVATE FIXTURE DATABASE STATE MACHINE: TESTED IN SEQUENTIAL SQL.**
**Critical hold:** Real **overlapping-session concurrency NOT PROVEN**; Stage 6B remains OPEN. No customer checkout, real inventory, payments or customer data.

## Exact scope
- GitHub: `juesbabyco/jues-baby-website`.
- Supabase: dedicated Jue project `izeezajdiawiaweffbrh`; org `cgqjblrthxmahtqmwzjz`. Not MindCare.
- New private migration: `jues_stage6b_private_cart_lifecycle_lab`, source `supabase/stage6b_private_cart_lifecycle_lab.sql` (commit `41b206b1e31bab00158046c230a87b1faf99c7d3`).
- Evolved private `jues_stage6b.fixture_cart_orders` to strict RESERVED → CONFIRMED → FULFILLED or CANCELLED/EXPIRED states, with `payment_state='NOT_INTEGRATED'` enforced and **fictional** 15-minute hold expiry timestamp. No cron installed and no automatic expiry job.
- Private `jues_stage6b.fixture_cart_movements`: per-order/line HOLD, RELEASE and CONSUME records, UNIQUE(order,sku,effect), checks on effect quantity signs. Existing earlier fictional cart HOLD backfilled, subsequent reserve function writes HOLD in the same transaction as the order and reserved-stock increment.
- Private SECURITY INVOKER function `transition_cart_fixture(bigint,text)` takes a row lock on the order, locks variant stock rows in sorted SKU order, validates state and hold age, then atomically updates state, stock and movement entries. No grant on function, schema or RLS tables for anon or ordinary authenticated roles.
- No public product, photo, owner approval, V8 `index.html`, customer order or payment changes. Real product at verification remains TEST baby romper US$15 stock4, published=false.

## Real PostgreSQL test evidence (not browser simulations)

| Case | Observed PostgreSQL result | Stock/movement outcome |
|---|---|---|
| RESERVED → FULFIL | INVALID_TRANSITION | No stock effect |
| RESERVED → CONFIRM | CONFIRMED | Holds retained |
| Repeat CONFIRM on confirmed | INVALID_TRANSITION | No repeat effect |
| CONFIRMED → FULFIL, two sizes | FULFILLED, changed_lines=2 | Each on_hand 2→1; reserved 1→0; one CONSUME each |
| Repeat FULFIL | TERMINAL_STATE | No repeat event or deduction |
| CANCEL after fulfilled | TERMINAL_STATE | No release |
| CANCEL reserved | CANCELLED, changed_lines=1 | on_hand unchanged 2; reserved 1→0 |
| Repeat CANCEL | TERMINAL_STATE | No repeat effect |
| EXPIRE before timestamp | TOO_EARLY_TO_EXPIRE | Holds retained |
| Mark **fictional** pending hold timestamp in past; then CONFIRM | RESERVATION_EXPIRED | Not confirmed |
| EXPIRE after timestamp | EXPIRED, changed_lines=1 | Hold released, on_hand unchanged |
| Repeat EXPIRE / CANCEL expired | TERMINAL_STATE | No repeat effect |
| CONFIRM then EXPIRE | INVALID_TRANSITION | Confirmed hold not silently released |
| CONFIRM then CANCEL | CANCELLED | One release |
| Transaction BEGIN/CONFIRM/ROLLBACK | Order stayed RESERVED | No lasting confirmation |
| Transaction BEGIN/FULFIL/ROLLBACK | Order stayed CONFIRMED, on_hand2 reserved1 | Zero persisted CONSUME events |
| Actual subsequent FULFIL | FULFILLED | on_hand1 reserved0, exactly one CONSUME event |

All tested resulting orders had `payment_state='NOT_INTEGRATED'`. Movement audit sums for every lifecycle fixture match final inventory: fulfilled lines HOLD + CONSUME, cancelled/expired lines HOLD + RELEASE. SQL postchecks returned a total of **6 private fictional cart orders**, **14 private movement rows** (including old private cart), **0 real published products**. These counts reflect the testing checkpoint only, not sales.

## Security and open issues
- Real catalogue unchanged: one private TEST photo product with US$15 price and stock4. No real orders or stock deductions.
- `anon` and `authenticated`: no `jues_stage6b` schema USAGE, no fixture table read/write access, no `transition_cart_fixture` EXECUTE. All 5 private tables have RLS enabled with no public policies. This is Postgres privilege proof, not a separately run external HTTP negative test.
- Supabase security advisor: existing WARN `auth_leaked_password_protection` disabled; INFO 7 private no-policy RLS tables. Performance advisor INFO 3 missing fictional-lab FK indexes. None was changed by this stage.
- Unique movement constraint helps prevent duplicate side-effect records, but the private administrative lab has no enforcement against privileged SQL writes. It is NOT a tamperproof production ledger.
- **Most important:** previous connected-tool “parallel” calls did not overlap. Real row-lock competition between two active PostgreSQL clients has **not** been run. Follow `docs/STAGE6B_TWO_SESSION_RACE_PROTOCOL.md` on independently connected authorised SQL sessions, capturing started/completed times and PIDs. No paid branch or extension needed/activated here.
- **No automatic expiry worker or customer-approved 15-minute hold policy.** Database expiry was manually invoked for the staged test.
- Real backend risk gates not done: customer actor authorization, rate limits, multi-line adversarial concurrency, return/refund after fulfillment, stock receipts/corrections, genuine merchandise size counts, customer PII privacy, delivery/consumer terms, price/currency rules, payment settlement/webhook idempotency, load tests and launch signoff.

## Status labels

- `S6B_PRIVATE_CART_LIFECYCLE_SEQUENTIAL_SQL_PASS`: acceptable precise milestone wording.
- `S6B_REAL_CONCURRENCY_CLOSED`: **not permitted** until two genuinely overlapping database sessions and repeatable evidence prove last-item stock + idempotency safety.
- `CUSTOMER_ORDERING_ENABLED`, `PAYMENTS_READY`, `STAGE6_CLOSED`: **false**.

See GitHub `docs/EVIDENCE_LOG.md` and dedicated Jue private `jues_internal.stage_events` for checkpoint events.
