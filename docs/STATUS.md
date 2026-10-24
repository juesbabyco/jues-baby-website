# Jue's Baby Co. — Current State (SINGLE-PAGE HANDOFF)
**As of:** 2026-10-24
**Overall:** V8 LIVE DEMO INTACT; S5A CLOUD CATALOGUE + OWNER ALLOWLIST DEPLOYED AND NEGATIVE RLS TESTS PASSED; ONE EMAIL-CONFIRMED OWNER PROVISIONED; POSITIVE LOGIN AND CROSS-DEVICE BROWSER TEST STILL OPEN.
**Current focus:** S5B — owner login user-tested; cloud draft submit validation improved after user's error. Product-save and cross-device acceptance still OPEN.

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
- Existing `owner-demo.html` is a PUBLIC browser-local prototype with NO authentication. New `owner-cloud.html` has Supabase Auth and database-enforced owner membership but is still STAGING; exactly one owner is now approved in the database, not yet browser-tested.
- Old demo edits use localStorage only. New staged cloud products are centrally stored in Supabase, but user-level cross-device acceptance has **NOT** been tested.
- Demo product photos and prices are NOT verified inventory.
- Real customer data must not be entered in demo.
- Old simple checkout phone regex is not country-grade phone verification; do not claim it is.

## Current account isolation
- GitHub: account `juesbabyco`, repo `juesbabyco/jues-baby-website`. MindCare GitHub must remain untouched.
- Supabase: **only** connected Juesbabyco organization `cgqjblrthxmahtqmwzjz`; dedicated project `jues-baby-co`, id `izeezajdiawiaweffbrh`, region `eu-west-1`, created 2026-10-24, status ACTIVE_HEALTHY.
- Quoted creation cost: **US$0/month**, explicitly approved by user and confirmed with Supabase. Recheck before enabling paid services.
- Separate MindCare Supabase exists under a different connection; DO NOT use it.
- Verified private schema `jues_internal` with tables `project_registry` (1 row) and `stage_events` (12 events after latest onboarding verification); both RLS-enabled. Anonymous and authenticated users have no schema usage, table SELECT/INSERT/UPDATE privileges verified denied. This is internal governance only.
- Supabase migration: `20261024115601_jues_private_development_registry_v1`; matching source at `supabase/migrations/20261024115601_jues_private_development_registry_v1.sql`.
- Security advisor: 2 INFO `rls_enabled_no_policy` on intentionally inaccessible private governance tables; no other security lint returned. Performance advisor: 2 INFO unused indexes (new, empty product table). Overlapping permissive SELECT policy warning was fixed in migration `20261024122310`.

## Stage 5A implementation and evidence
- SQL migration `20261024121448_jues_stage5_owner_and_product_catalogue` created `public.jues_store_owners` and `public.jues_products`, both RLS-enabled, six policies overall after optimization.
- SQL migration `20261024122310_jues_stage5_streamline_read_policies` removes authenticated duplicate-permissive SELECT lint. Both migration files mirrored in GitHub.
- Permission tests: `anon` INSERT denied (42501); `authenticated` unapproved-user INSERT denied by RLS (42501); authenticated cannot grant itself owner membership.
- Rolled-back public visibility test showed one temporary published record and zero temporary draft records; subsequent row count was 0 products and 0 approved owners, 0 Auth users.
- Staged pages committed: `owner-cloud.html` and `cloud-preview.html`; both JavaScript syntax-verified, **not** browser end-to-end confirmed. Pinned supabase-js 2.118.0, publishable key only; no privileged key.
- Supabase governance registry now reports `S5B_OWNER_ONBOARDING`, 12 events; Stage 5 still OPEN.
- Current user guide: `docs/STAGE5_OWNER_SETUP.md`.

## Next action and gates
1. **Done 2026-10-24:** exactly one confirmed Auth user was found in the Jue project. It was added to `public.jues_store_owners`; database read-back confirmed exactly one approved owner.
2. Open `owner-cloud.html`, sign in as that newly confirmed owner, and report exact success/error; never post password.
3. Owner creates one obviously fictitious product as a **draft**, then verifies it is not displayed in the public cloud preview.
4. Publish that test item; open `cloud-preview.html` on a **different browser/device**. Change its price and verify the remote display updates after refresh. Unpublish test item.
5. Test an unrelated Auth account cannot read drafts or mutate products; then record success/failure evidence before calling S5 closed. Existing V8 demo must remain unchanged.

## Form-validation repair (2026-10-24)
- User reported unhelpful generic 'Check the name, price, stock, at least one size, and HTTPS photo URL' message while creating first product draft.
- `owner-cloud.html` updated to show specific validation errors, distinguish age group from size selection, and support decimal comma entry on iPhone.
- Git commits `dda4c2d1dcdb14f341aca6ef637b53e8caa4062b` and `1896190c7d0072f3ac0d3bf6d4c5ada63438de8b`. JavaScript syntax checked. User retry and actual cloud save PENDING; do not assert fixed in the browser yet.

## Stop conditions
- Wrong Supabase link, project, or org -> STOP.
- Unexpected bill/cost -> STOP and ask.
- Any write affecting MindCare -> STOP.
- Missing owner authority/RLS -> no production CRUD.
- Unknown stock or demo listing -> keep explicit DEMO labeling.
