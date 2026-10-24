# Jue's Baby Co. — Current State (SINGLE-PAGE HANDOFF)
**As of:** 2026-10-24
**Overall:** LIVE STATIC DEMO; LOCAL OWNER DASHBOARD USER-TESTED; DEDICATED SUPABASE PROJECT AND PRIVATE GOVERNANCE REGISTRY VERIFIED. NO CLOUD STORE INTEGRATION.
**Current focus:** S5 — secure owner authentication and cloud catalogue, NOT YET IMPLEMENTED.

## Proven by owner-reported testing
- GitHub Pages storefront opens.
- Responsive mobile and desktop layout is working (V8).
- Demo checkout creates a simulation reference; screenshot shown.
- Name and phone fields requested as part of checkout.
- Dashboard edits a sample price and storefront reflects it in same browser.

## Code-verified but not independently browser-e2e-tested
- `index.html` includes product search, age filters, sorting, favorites, cart controls and checkout flow.
- `owner-demo.html` includes create/edit/hide/delete local sample records, JPEG compression, stock quantities, JSON export.
- Both scripts parsed successfully in prior tool validation; this is not a proof all flows work.

## Known boundaries
- Public demo: **NO real purchases, payments, reservations, shipment, stock accounting or server orders**.
- Owner dashboard is public prototype page with NO authentication.
- Catalogue edits stored in localStorage only; **NO cross-device synchronization**.
- Demo product photos and prices are NOT verified inventory.
- Real customer data must not be entered in demo.
- Old simple checkout phone regex is not country-grade phone verification; do not claim it is.

## Current account isolation
- GitHub: account `juesbabyco`, repo `juesbabyco/jues-baby-website`. MindCare GitHub must remain untouched.
- Supabase: **only** connected Juesbabyco organization `cgqjblrthxmahtqmwzjz`; dedicated project `jues-baby-co`, id `izeezajdiawiaweffbrh`, region `eu-west-1`, created 2026-10-24, status ACTIVE_HEALTHY.
- Quoted creation cost: **US$0/month**, explicitly approved by user and confirmed with Supabase. Recheck before enabling paid services.
- Separate MindCare Supabase exists under a different connection; DO NOT use it.
- Verified private schema `jues_internal` with tables `project_registry` (1 row) and `stage_events` (6 events after final status update); both RLS-enabled. Anonymous and authenticated users have no schema usage, table SELECT/INSERT/UPDATE privileges verified denied. This is internal governance only.
- Supabase migration: `20261024115601_jues_private_development_registry_v1`; matching source at `supabase/migrations/20261024115601_jues_private_development_registry_v1.sql`.
- Security advisor: 2 informational `rls_enabled_no_policy` notices on **private, intentionally inaccessible** tables; no other security advisor finding reported at check. No performance advisor findings. Informational notices are documented, not treated as vulnerabilities or ignored.

## Next action and gates
1. Design secure owner authentication and product schema with RLS; test owner/anon/outsider denial policies.
2. Decide owner provisioning route without open admin signup; never store credentials in GitHub.
3. Integrate Jue-only cloud staging storefront and dashboard, preserving public demo isolation.
4. Demonstrate *two independent devices* reflect a product update from cloud state.
5. Record test evidence in both GitHub and private Supabase registry before calling S5 complete.

## Stop conditions
- Wrong Supabase link, project, or org -> STOP.
- Unexpected bill/cost -> STOP and ask.
- Any write affecting MindCare -> STOP.
- Missing owner authority/RLS -> no production CRUD.
- Unknown stock or demo listing -> keep explicit DEMO labeling.
