# Jue Stage 6B — independent two-session stock race protocol

**STATUS: PREPARED / NOT EXECUTED.** This procedure is for an approved maintainer on **Jue's dedicated Supabase project only**: `izeezajdiawiaweffbrh`. It does not ask for or store passwords, checkout payments or customer data. Never use MindCare projects.

## Purpose and isolation

Private `jues_stage6b.fixture_variants` SKU `S6B-RACE_MANUAL_01` was seeded with **on_hand=1 / reserved=0** on 2026-11-01. It is fake inventory completely distinct from the public TEST Cotton Baby Romper. No real checkout, customer records or account data are involved.

**Prerequisites:** two genuinely separate PostgreSQL connections (not sequential SQL calls through one serialized connector). Two SQL Editor tabs may or may not create separate backend sessions; inspect returned `backend_pid` before claiming they do. The `jues_stage6b` schema is private, so this requires an authorized project SQL administrator. Never supply a DB password, service key or connection URI in a chat or GitHub issue. Do not change privilege grants to make this test easier.

## Connection A — launch first, start connection B while A sleeps

```sql
BEGIN;
SELECT * FROM jues_stage6b.reserve_fixture(
 'S6B-RACE_FIRST_20261101',
 'S6B-RACE_MANUAL_01',1,0
);
SELECT clock_timestamp() AS a_lock_held_before_sleep;
SELECT pg_sleep(12);
SELECT clock_timestamp() AS a_about_to_commit;
COMMIT;
```

Connection A should reserve the only unit, then **hold its row lock** for approximately twelve seconds until COMMIT. If SQL Editor can't maintain a transaction over several statements, STOP; do not claim simultaneous-session proof.

## Connection B — while connection A is still sleeping

```sql
SELECT * FROM jues_stage6b.reserve_fixture(
 'S6B-RACE_SECOND_20261101',
 'S6B-RACE_MANUAL_01',1,0
);
```

Expected: B waits for A's row lock. After A commits, B returns `OUT_OF_STOCK`, **no second order ID**.

## Verify all evidence (run after both finish)

```sql
SELECT sku,on_hand,reserved,on_hand-reserved AS available
FROM jues_stage6b.fixture_variants
WHERE sku='S6B-RACE_MANUAL_01';
SELECT request_key,id,sku,qty,state FROM jues_stage6b.fixture_orders
WHERE request_key IN ('S6B-RACE_FIRST_20261101','S6B-RACE_SECOND_20261101')
ORDER BY id;
```

Required before claiming PASS: A returns **RESERVED**, B returns **OUT_OF_STOCK**, exactly ONE order row, final on_hand=1/reserved=1, and B's `started_at` precedes A's `a_about_to_commit` with B's `completed_at` after A's COMMIT. Different `backend_pid` values support distinct sessions; absence of a demonstrable overlapping time window means **CONCURRENCY UNPROVEN**, not PASS. Capture the full SQL output including timestamp/session ID and any error.

Do **not** rerun this same SKU/keys expecting a fresh race. A new trial requires a separately approved **new** private fixture SKU and new keys; never reset a real published product. Don't delete test evidence to force a green result.

## Duplicate-key overlap follow-up

Once last-unit distinct-key concurrency is proven, prepare a second private one-unit fixture and run both sessions using the **same high-entropy request key and same payload** with a transaction delay. Expect one `RESERVED`, one `REPLAYED`, the same order ID, one held unit and distinct overlapping PostgreSQL sessions. If tool scheduling serializes them, record NOT PROVEN even though the final data is consistent.

## Alternatives

An independently controlled local test runner using two `psql` connections to the existing Jue project can also establish overlap, with connection credentials kept in secure local environment configuration. Do not commit credentials or activate a new paid branch or extension just for this test. `pg_cron`, `dblink`, and `pg_net` were **not installed** as of 2026-11-01 and are not prerequisites.

This Stage 6B fixture schema has **no anon/authenticated grants**. Do not expose private SQL functions to browser clients.

## Stop conditions

Any real customer data, actual `public.jues_products` mutation, unknown auth rights, secret handling, unexpected cost, nonexistent distinct sessions, or server error => STOP. Stage 6B remains OPEN until genuine overlapping-session proof and order-state/expiry requirements are satisfied. No payments or public order placement authorized.
