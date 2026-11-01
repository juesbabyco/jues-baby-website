# Jue's Baby Co. — Stage 6B private database reservation test

**Checked 2026-11-01. Status: PARTIAL DB PASS / REAL OVERLAPPING SESSION CONCURRENCY NOT PROVEN.**

## Scope and live safety
- Dedicated Jue Supabase project: `izeezajdiawiaweffbrh` and organization `cgqjblrthxmahtqmwzjz`. No MindCare access.
- Applied Supabase migration named `jues_stage6b_private_fixture_reservation_sandbox` from exact GitHub source [`supabase/stage6b_private_fixture_sandbox.sql`](../supabase/stage6b_private_fixture_sandbox.sql), GitHub commit `389d6a1050dd1175931c4b0e87d7c7ea60682b01`.
- Created **private, non-Data-API `jues_stage6b`** schema, two fictional fixture tables, and **SECURITY INVOKER** SQL function `reserve_fixture`.
- `anon` and `authenticated`: no schema USAGE, no table SELECT/INSERT, no function EXECUTE. Both tables RLS enabled and intentionally lack policies (private/inaccessible). Neither new table is in public schema.
- No change to actual `public.jues_products`, owner allowlist, images, public storefront, checkout or customer identities. Existing real product remains TEST Cotton Baby Romper, US$15 stock 4, **unpublished**, with one private photograph. Jue project still has no publicly exposed order tables.
- All 4 rows inside `jues_stage6b.fixture_variants` and 4 resulting rows in `fixture_orders` are **fictional private lab data**. These database test orders do not represent real customers or sales.
- This harness covers **one stock variant per order attempt**. It is not a complete multi-item order transaction, owner order lifecycle, settlement system or payment processor.

## Observed private Postgres tests

| Test | Observed result | Evidence level |
|---|---|---|
| First request on Newborn stock 1 | RESERVED, fixture order #1, held 1 | Real Postgres SQL |
| Retry identical request key/payload | REPLAYED, same fixture order #1, held still 1 | Real Postgres SQL |
| Same key, different quantity | IDEMPOTENCY_CONFLICT | Real Postgres SQL |
| New request after sole item reserved | OUT_OF_STOCK, no second order | Real Postgres SQL |
| Other size fixture | Separate reservation succeeds, without affecting Newborn | Real Postgres SQL |
| Two requests scheduled through connector Promise.all for same last unit | Exactly **one** resulting test order / held 1 | Invariant PASS, simultaneous overlap **not proved** because tool scheduling discarded timestamps on first attempt |
| Two same-key requests scheduled through connector Promise.all | First RESERVED order #4; later REPLAYED order #4, reserved 1 | DB correct, but **NOT concurrent**: first started 12:31:40.562Z, ended 12:31:41.967Z; next started 12:31:59.507Z; different backend PIDs, no overlap |
| Check access by anon/signed-in | All schema/table/function grants false, RLS enabled | Real Postgres catalogue inspection |
| Final lab stock | Each of four variants has on_hand=1, reserved=1, available=0; exactly four fictitious orders | Real DB readback |
| Public catalogue | Exactly one TEST product unpublished, no exposed public order tables | Real DB readback |

**Do not report a real concurrency race passed.** Connector traffic is staggered, even when tool calls are sent as a Promise.all. Row lock syntax and a successful sequential invariant are insufficient to demonstrate how two independent, truly simultaneous connections behave.

## Security advisor observations (2026-11-01)

- Security advisor WARN: **leaked-password protection disabled** for the existing Jue Supabase Auth configuration. This pre-existed the new private lab; do not claim it is caused by Stage 6B. Recommended remediation link: https://supabase.com/docs/guides/auth/password-security#password-strength-and-leaked-password-protection . Auth configuration was **not changed**.
- INFO: private `jues_stage6b` tables have RLS but no policies; **intended denial** because public and signed-in roles have no grants.
- Performance INFO: `jues_stage6b.fixture_orders.sku` foreign key has no separate index; very small fictional test table only. No index was added yet. Reference: https://supabase.com/docs/guides/database/database-linter?lint=0001_unindexed_foreign_keys .

## What must pass before Stage 6B can be closed

1. Execute same-stock different-key and same-key repeat tests using **two independently connected PostgreSQL sessions with overlapping database timestamps**, ideally through a secure staging-only harness with no exposed DB password. Do not use a new paid database branch without consent.
2. Assert that with on_hand=1 **exactly one wins**, second is OUT_OF_STOCK; and with duplicate key exactly one order ID is created and second is REPLAYED, under genuine overlap.
3. Extend prototype beyond a single variant: multi-line all-or-nothing reservations with deterministic locking order, intentional rollback, and conflicting multi-item carts; test deadlock handling.
4. Implement and test atomic CANCEL/EXPIRE/CONFIRM/FULFIL transitions with exactly-once inventory ledger events, hold expiry, repeated requests and hard terminal states. The existing single-variant `reserve_fixture` deliberately does not implement these transitions yet.
5. Validate direct API access denial for anonymous and unrelated signed-in accounts; verify security advisor status and actual schema exposure.
6. Inspect finance/delivery policy, real physical merchandise/variant stock, customer data privacy, no double-charge payment webhook and specific founder approvals before enabling any customer order.

## Evidence handling

- **JBC-E063:** User responded “Done” to instruction to tap Cancel after FULFILLED; completion is **user-reported** and exact rejection message not independently shown. Do not mark the terminal-state post-fulfil browser rejection screenshot verified.
- **JBC-E064:** Source-controlled private migration applied; privilege/RLS verification and original product unchanged.
- **JBC-E065:** Real DB sequential reservations/retry/conflict/out-of-stock pass; attempted parallel test outputs show no true overlap; concurrency still open; advisor warnings captured.

**Stage 6B is open; Stage 6C public checkout and all payment flows are not implemented. Do not promote these fixture database functions to a public API.**
