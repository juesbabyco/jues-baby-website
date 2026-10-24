# Jue's Baby Co. — Current State (SINGLE-PAGE HANDOFF)
**As of:** 2026-10-24
**Overall:** V8 DEMO INTACT. S5B OWNER LOGIN, DRAFT CREATE, DRAFT PRIVACY, AND PUBLISHED CLOUD PREVIEW USER-TESTED / DATABASE VERIFIED. PRICE EDIT, UNPUBLISH AND INDEPENDENT CROSS-DEVICE TEST STILL OPEN.
**Current focus:** S5B — test price edit, cloud preview refresh, unpublish and independent second-device visibility. S5 remains OPEN.

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
- Git commits `dda4c2d1dcdb14f341aca6ef637b53e8caa4062b` and `1896190c7d0072f3ac0d3bf6d4c5ada63438de8b`. JavaScript syntax checked. User retried successfully; database read-back independently confirmed first draft save. Browser form validation repair is user-tested through successful save.

## First cloud draft verified (JBC-E025, 2026-10-24)
- User reported 'done' after saving test product; direct query verified exactly one record named **TEST Cotton Baby Romper**, price US$15.00, stock 2, age/size Newborn, category Everyday, `published=false`.
- Anonymous SQL role query saw **zero** products, with no INSERT or UPDATE privilege. This confirms database-side draft privacy, not yet a separate unauthenticated browser check.
- Supabase private development registry reports `S5B_CLOUD_DRAFT_SAVE_VERIFIED` and 15 evidence entries.
- Still OPEN: public cloud preview browser check, publishing test, remote-device refreshed view, owner price update, unpublish and external user security checks. Existing `index.html` remains the demo.
- Next work instructions: `docs/STAGE5_OWNER_SETUP.md`.

## Mobile Edit / Publish usability repair — 2026-10-24
- User supplied iPhone screenshot of `cloud-preview.html`: correctly displays **No products published yet** because `TEST Cotton Baby Romper` is still unpublished.
- User reported tapping Edit in the owner flow produced no visible change. Earlier `owner-cloud.html` populated the editor farther down the page and scrolled to the form body without a strong feedback indicator; the exact device interaction failure remains unproven.
- Git commit `6d872cb503caf0aa9ee27e4742d4430a3c3eeeda`: **Publish/Unpublish** explicit buttons in owner list (with confirmation and Supabase returned-value check); highlighted editor banner and scroll to form heading when **Edit** tapped. Javascript syntax passed; user browser confirmation pending.
- Post-commit DB recheck: 1 product, 0 public records, test item still draft. No server-side product publication was initiated by assistant.
- Next test: reload `owner-cloud.html` and tap **Publish** beside `TEST Cotton Baby Romper`, confirm; then refresh `cloud-preview.html` on a different browser/device. This is STAGING only, not an order-taking website. Verify publish before proceeding to price-change/unpublish test.

## First publish + anonymous visibility proof (2026-10-24, JBC-E027)
- User supplied iPhone screenshots showing cloud preview lists 1 published **TEST Cotton Baby Romper** for US$15.00 with demo stock 2. Direct project SQL confirmed `published=true`, price 1500 cents, stock 2, Newborn/Everyday.
- Anonymous SQL role read showed 1 published record (the matching test product) and INSERT/UPDATE privileges false. Stage 5B **publish and public display** USER-TESTED, independently database-verified.
- No independent second-device evidence yet: screenshots alone do not prove two devices were used.
- Still outstanding: edit from owner page to US$16, verify preview change, unpublish and check it disappears; test from another independent browser/device, unauthorized signed-in user access test.
- This published record is **staging test content**, not a real store offering; it should be unpublished after testing. Original V8 storefront remains demo.

## Stop conditions
- Wrong Supabase link, project, or org -> STOP.
- Unexpected bill/cost -> STOP and ask.
- Any write affecting MindCare -> STOP.
- Missing owner authority/RLS -> no production CRUD.
- Unknown stock or demo listing -> keep explicit DEMO labeling.
