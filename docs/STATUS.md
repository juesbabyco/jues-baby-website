# Jue's Baby Co. — Current State (SINGLE-PAGE HANDOFF)
**As of:** 2026-10-24
**Overall:** V8 DEMO INTACT. S5B STAGING OWNER LOGIN, DRAFT CREATE, PUBLISH, PRICE EDIT, iPHONE-TO-DELL UNPUBLISH, AND UNAPPROVED SIGN-IN DENIAL ACCEPTED. DB READ/WRITE NEGATIVE TESTS PASSED. S5 OVERALL STILL OPEN.
**Current focus:** S5C iPhone upload bug: 2 separate TEST drafts, none has a photo; owner UI changed to upload selected photo during Save and provide deliberate draft Delete. iPhone functional re-test PENDING; Stage 5 OPEN; no published items.

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

## Public price update passed (2026-10-24; JBC-E028)
- Owner updated TEST Cotton Baby Romper price from US$15.00 to **US$16.00** in the owner dashboard, then supplied iPhone cloud-preview screenshot confirming new price.
- Direct Supabase readback: price 1600 cents, stock 2, `published=true`.
- Acting as `anon`, SQL returned 1 published row matching new price. Anonymous role lacks UPDATE permission.
- This proves cloud price update and public preview but **not** that an independent second device was used.
- Next: unpublish from owner-cloud.html; confirm cloud-preview.html hides the item; verify SQL public role returns zero. Then confirm on another device and test unrelated signed-in user access.
- Keep the test product labelled TEST and original V8 storefront separate; no checkout/payment claims.

## Unpublish and private persistence verified — 2026-10-24 (JBC-E029)
- Owner reported Unpublish worked; Jue-only Supabase read-back confirmed TEST Cotton Baby Romper still exists as **private draft**, price US$16.00, stock 2, published=false.
- SQL run with `SET LOCAL ROLE anon` read **zero** products and no UPDATE privilege. No product deletion or accidental public listing.
- The owner's report of public preview disappearance is accepted as user feedback; the database permissions independently confirm public invisibility. No independent second device evidence was supplied.
- Remaining gate: repeat public preview state check from another independent browser/device, plus unrelated-authenticated-user RLS write/read denial. No real checkout, customer-data processing or stock reservations exist.
- Jue Supabase registry E029 and GitHub evidence must remain in sync.

## Follow-up public preview and simulated non-owner read (JBC-E030, 2026-10-24)
- After the prior unpublish, the user reported cloud preview reads **No products published** following the request to use an independent browser/device. This is a USER-REPORTED public preview outcome, but browser/device independence is not independently established.
- Jue Supabase read confirms the sole TEST Cotton Baby Romper is still a private draft priced US$16.00 with stock 2; 0 publicly published items.
- SQL `SET LOCAL ROLE anon` showed 0 visible products and no public UPDATE privilege.
- SQL simulated `authenticated` with an unrelated synthetic Auth UID showed **0 visible private product rows**, **0 visible owner rows**, and no privilege to insert itself into the owner allowlist. This is **role-simulation evidence, not a real non-owner sign-in**.
- Still OPEN: controlled cross-device published update (not merely both devices seeing empty preview) and a real outsider-login authorization test, plus further photo/storage and production readiness.
- Stage 5 is not closed.

## iPhone-to-Dell visibility check (2026-10-24; JBC-E031)
- User responded **Working** after instructed publish-on-iPhone, view-on-Dell-InPrivate, unpublish-on-iPhone and refresh-on-Dell test.
- Jue-only Supabase readback performed immediately after report shows TEST Cotton Baby Romper **published=true**, price US$16, stock 2, updated 2026-10-24 18:36:37 UTC. Anonymous role currently sees 1 product, and cannot UPDATE.
- Record **cross-device visibility user-reported PASS**, but **do not claim final unpublish complete**, because current live database state conflicts with expected `published=false`. The user may have stopped after checking visibility.
- Next: tap Unpublish on iPhone and refresh Dell InPrivate; verify product disappears. Check Supabase flag again before closing that gate.
- Genuine unrelated Auth identity write/read denial remains OPEN (synthetic-role checks alone are not a live login test). Existing V8 demo unchanged.

## Cross-device published-to-private roundtrip completed (2026-10-24; JBC-E032)
- User reported **Done** after follow-up instruction to unpublish on iPhone and refresh Dell InPrivate preview.
- Exact Jue-only Supabase record read-back: TEST Cotton Baby Romper US$16.00, stock 2, `published=false`, last changed `2026-10-24 18:40:14 UTC`; published items 0.
- SQL as `anon`: 0 visible products and UPDATE permission denied. No sample inventory moved to live V8 demo.
- Combined with earlier positive Dell visibility user report, this is **USER-TESTED iPhone-to-Dell publish/view/unpublish** with verified final cloud state. Device screens are user-reported, not independently instrumented.
- **Outstanding before S5B closure:** real unrelated, unapproved Supabase Auth account sign-in and negative owner/read/write authorization tests. Synthetic role simulations are positive supporting evidence only.
- Stage 5 broad production readiness, real inventory and checkout remain OUT OF SCOPE and OPEN.

## Newly created genuine non-owner test account (JBC-E033, 2026-10-24)
- User created a second test Supabase Auth account in dedicated Jue project; direct query confirms **2 Auth users, 1 approved owner**. The new email-confirmed test identity has no owner membership.
- SQL transaction using `SET LOCAL ROLE authenticated` and **new account's actual Auth UUID** as JWT sub returned **zero private product rows and zero visible owner rows**. Role has no owner-allowlist INSERT or UPDATE grant.
- The owner-cloud dashboard code requires `jues_store_owners` membership; nonowner should be signed out with **This account has not been approved as a store owner. Access denied.**
- **NOT YET USER-TESTED:** a browser actually signing in with the new nonowner account; direct attempted nonowner product mutation from a real session. Test these before S5B closure. Do not approve test account; keep passwords private.
- One TEST Cotton Baby Romper remains private and 0 items published.

## Stage 5B security negative acceptance (2026-10-24; JBC-E034/E035)
- User **actually signed in** to `owner-cloud.html` in separate private-browser flow as unapproved second Auth account and reported exact message: **This account has not been approved as a store owner. Access denied.**
- Supabase confirmed second account `last_sign_in_at=2026-10-24 18:51:01 UTC`, second account **not** allowlisted; 2 Auth identities total, 1 approved owner.
- SQL authenticated session with second user's actual Auth UUID: **UPDATE** existing private product returned 0 rows, so no row was changed. **INSERT** attempt rejected with PostgreSQL `42501` RLS violation. Both tests were wrapped in rollback transactions; follow-up SQL confirmed no unauthorized test rows, only one TEST product at US$16 and still `published=false`; owner allowlist unchanged (1).
- **S5B staging functional/security acceptance PASS.** Distinguish real-browser UI-denial proof from DB-side simulated request identity for write checks; a signed JWT REST API penetration test has not been independently performed.
- Do **not** call this production/launch acceptance. Stage 5 overall remains OPEN: secure photo uploads and product-image permissions, real-catalogue owner input, cloud/storefront integration, robust failure/reload behavior, checkout & customer privacy/payments are future gates.
- Next stage: S5C. See PROJECT_BOOK.md for scope.

## Stage 5C private photo storage + browser upload (JBC-E036/E037; 2026-10-24)
- Supabase migration `20261024190037_jues_stage5c_private_product_photo_storage` APPLIED to Jue project only. Bucket `jues-product-photos` is private, JPEG-only, max 2 MiB; added nullable product-owned `jues_products.image_path`, CHECK ensures product folder.
- Storage policies: owner-only INSERT under existing product folder, SELECT owner or published product's named photo during permitted download operation, owner DELETE only when no product references photo. No UPDATE/upsert.
- Bucket and policies inspected in Supabase; valid JPEG storage path regex positive match, malformed and PNG paths rejected. No images uploaded (0 Storage objects) and no published products.
- `owner-cloud.html` committed: owner Edit → select photo → confirm → JPEG resize/compress (<=1400px, <=2 MiB) → private Storage upload → product image_path update → gallery display. `cloud-preview.html` committed: download protected photos only for published products.
- Both browser scripts JavaScript syntax verified; live iPhone upload / publicly readable published image / private draft download-denial **NOT YET USER-TESTED**. A signed HTTP Storage API negative test is also pending.
- Detailed acceptance dossier: `docs/STAGE5C_PRIVATE_PHOTO_ACCEPTANCE.md`. Original V8 customer website unchanged, test draft still private.
- Security advisor: leaked-password protection disabled WARN; raise before production; internal no-policy INFO intentional.

## Stage 5C duplicate draft / missing photo repair (JBC-E039, 2026-10-24)
- Screenshot showed TWO saved TEST romper drafts: new one name with period, US$15, stock 4; original US$16, stock 2. Both draft, thumbnail No photo.
- Dedicated Jue Supabase product readback confirmed 2 items and both `image_path=NULL`. Storage objects count verified 0. Edge logs 19:15–19:31Z included product POST 201 and PATCH requests but no observed Storage upload request; this supports not having actually uploaded the file, but does NOT independently establish the precise user's button sequence.
- Implemented in owner-cloud.html: **Delete** button on draft only; requires typing DELETE, uses owner-authenticated DB `DELETE` with `published=false` predicate and readback; linked photo cleanup after successful product deletion. **No draft was deleted by assistant.**
- Added each product's unique short reference ID, prominent NEW PRODUCT vs EDIT EXISTING banner; duplicate-normalized-name prevention for new records.
- Form **Save product draft/Save changes** now uploads any selected photo as JPEG, saves product `image_path`, performs fresh DB readback and private Storage download before success. If product saved but photo failed, UI returns to editing that same saved record and displays exact failure text instead of encouraging another draft.
- Commit `80a7e790a3b3a738b85c88066902643d2ae3f4ed` (with Delete precursor `db41cb1c1acc8eff9cac968d00632191fb9adce2`). GitHub fetch + JS syntax PASS; zero code changed in index.html, MindCare untouched.
- Under actual unapproved test account UUID in a rolled-back SQL transaction, unauthorized DELETE returned 0 rows; DB confirms both drafts still remain private. Real user Delete + Save-with-photo workflows NOT YET TESTED.
- Next: owner refresh cache-busted `owner-cloud.html?v=5c3`; delete the **US$15/stock4 duplicate** if desired; EDIT US$16/stock2 original, choose the sample photo and tap Save changes. Verify `image_path` and Storage object then Dell preview before declaring success.

## Mobile owner card layout repair (JBC-E040; 2026-10-24)
- User iPhone screenshot showed shared product names rendered vertically because 3 inline actions (Edit/Publish/Delete) consumed most horizontal space in the flex row. Not a database product-name corruption.
- Corrected `owner-cloud.html` CSS: 2-column grid for thumbnail and name/details, actions now span a full second row with even button widths; narrow phone media rule included.
- GitHub commit `f0df770aa94f58bcf831f0482cd7024adc85f230`, source re-fetch, JavaScript syntax PASS. Browser visual re-test NOT YET CONFIRMED.
- Existing two draft products remain as-is; owner should check updated `owner-cloud.html?v=5c4`, then optionally delete US$15/stock4 extra draft using typed DELETE. Photo upload remains Stage 5C OPEN.

## Stop conditions
- Wrong Supabase link, project, or org -> STOP.
- Unexpected bill/cost -> STOP and ask.
- Any write affecting MindCare -> STOP.
- Missing owner authority/RLS -> no production CRUD.
- Unknown stock or demo listing -> keep explicit DEMO labeling.
