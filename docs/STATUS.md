# Jue's Baby Co. — Current State (SINGLE-PAGE HANDOFF)
**As of:** 2026-10-24
**Overall:** LIVE STATIC DEMO; LOCAL OWNER DASHBOARD USER-TESTED; CLOUD BACKEND NOT YET CREATED.
**Current focus:** Durable governance + dedicated cloud project gate.

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
- Supabase: connected Juesbabyco organization `cgqjblrthxmahtqmwzjz`; last checked 2026-10-24: **0 projects**.
- Separate MindCare Supabase exists under a different connection; DO NOT use it.
- Supabase project cost check returned **US$0/month** as of 2026-10-24, but API requested separate explicit cost confirmation before creation. **No project created by that attempted call.** Confirm actual current status before acting.

## Next action and gates
1. Confirm zero-cost project creation with user as required by Supabase API; create ONLY in Juesbabyco organization.
2. Bootstrap `project_registry` and `stage_events` within Jue-only project. Secure registry access.
3. Build separate owner auth and product schema with RLS. Verify owner/anon/outsider denial policies.
4. Integrate staging frontend; demonstrate second-device product price change.
5. Record test evidence before calling S5 complete.

## Stop conditions
- Wrong Supabase link, project, or org -> STOP.
- Unexpected bill/cost -> STOP and ask.
- Any write affecting MindCare -> STOP.
- Missing owner authority/RLS -> no production CRUD.
- Unknown stock or demo listing -> keep explicit DEMO labeling.
