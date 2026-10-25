# Jue's Baby Co. — Current State (SINGLE-PAGE HANDOFF)
**As of:** 2026-10-25
**Overall:** V8 DEMO INTACT. S5B STAGING OWNER LOGIN, DRAFT CREATE, PUBLISH, PRICE EDIT, iPHONE-TO-DELL UNPUBLISH, AND UNAPPROVED SIGN-IN DENIAL ACCEPTED. DB READ/WRITE NEGATIVE TESTS PASSED. S5 OVERALL STILL OPEN.
**Current focus:** Stage 5C scoped acceptance PASSED. Stage 5D new cloud storefront **IPHONE DYNAMIC PUBLISH/PHOTO/DETAILS/UNPUBLISH ACCEPTED**, Supabase API logs and private final DB state verified; Dell independent-device test, search/age filter & resilience remain OPEN. Original V8 untouched; 1 private photographed TEST draft, 0 published, no commerce.

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

## Stage 5C first real photo + public read and inline Delete repairs (JBC-E041/E042; 2026-10-24)
- User's iPhone screenshot now shows real image on **US$15 stock4 TEST Cotton Baby Romper.**; US$16 stock2 duplicate remains without photo. Direct DB read `image_path` exists only on US$15 and Storage metadata has exactly one JPEG in the private bucket.
- API evidence: authorized iPhone POST Storage 200, image_path PATCH 200, owner private Storage GET 200. Owner photo UI confirmed USER-TESTED.
- After owner published US$15 item, anonymous Cloud Preview image GET requests returned **HTTP 400**. Reproduction in role-simulated SQL identified combined Storage READ policy that queried `jues_store_owners` under `anon`, resulting in `permission denied for table jues_store_owners`. Never grant anon owner-list access to work around this.
- Supabase migration `20261024195535_jues_stage5c_separate_photo_read_policies` now separates owner-authenticated photo read from published photo read (anon and authenticated). Rolled-back SQL policy tests: published photo accessible to anon for object GET, temporarily-unpublished photo inaccessible, anon object LIST denied, non-owner cannot read draft photo. Actual public HTTP download re-test still required.
- User reported Delete not working. Native iPhone JavaScript `prompt()` may be blocked/unreliable; no successful DELETE API request observed. Replaced it with an **inline on-page typed DELETE confirmation** in GitHub `7317d57bab269abe98518cfee960c84216d31f4a`; JS syntax PASS. Owner-only RLS DELETE SQL transaction matched a draft and rolled back; nonowner matched zero; owner delete of a published item under `published=false` guard matched zero. Actual owner iPhone DELETE test still OPEN.
- The US$15 photo-bearing item is **currently published**. After public preview test, unpublish before deleting it. Two stored TEST records were preserved by assistant. Original V8 demo untouched.
- Security advisor still notes [Leaked password protection disabled](https://supabase.com/docs/guides/auth/password-security#password-strength-and-leaked-password-protection); production gate still OPEN.

## Stage 5C public photo and delete-panel acceptance (JBC-E043; 2026-10-24)
- Owner supplied two iPhone screenshots at local 22:04-22:05 showing **US$15 stock4 TEST romper photo successfully displayed on public cloud-preview** and photo thumbnail on authenticated owner-cloud.
- Independent edge HTTP evidence: image `GET | 200` at 20:04:34 UTC and 20:05:17 UTC, confirming Storage published-photo download fix with actual browser requests.
- Owner tapped **Delete** on separate **US$16 stock2 no-photo draft**; on-page Delete confirmation displays exact target and text-entry field. Button appears disabled in screenshot because `DELETE` was the field **placeholder**, not yet an actual entered value. No backend DELETE request proven; SQL readback confirms both product records still exist.
- Fixed confusing placeholder in owner-cloud commit `eb4c521fe8264d2aefb8a58d072bdc3c343ed36a`: now 'Tap here and type the word' and explicit status explaining that typing uppercase DELETE enables confirmation. JS syntax PASS; actual typed delete still OPEN.
- Staging test product US$15 stock4 **currently published** and pictured; US$16 stock2 **draft**. Don't delete either without owner typed confirmation. If user wishes to keep photo, retain US$15 and delete US$16; alternatively transfer picture via approved editing instead of deleting photo-bearing item.
- Next verify on iPhone clicking Confirm delete actually removes only intended draft. Afterwards unpublish US$15 test listing unless explicitly kept publicly as test. No customer checkout exists and production V8 untouched.

## Real mobile draft Delete verified (JBC-E044; 2026-10-24)
- User twice confirmed "Deleted." Supabase edge logs show actual iPhone `DELETE 200` of exact **US$16 / stock2** draft UUID `917d954a-69e3-4dd4-aa52-9070710484ba` with `published=false` condition at `20:11:04.812Z`.
- Direct dedicated Jue product readback confirms this record **no longer exists**. Exactly one product remains: **US$15 / stock4 TEST Cotton Baby Romper.**, `published=true`, linked to the one uploaded JPEG. Photo Storage still has exactly 1 file. No other products deleted.
- **Owner mobile inline typed-confirmation Delete PASSED.** Previous ambiguous placeholder repaired in `eb4c521fe8264d2aefb8a58d072bdc3c343ed36a`.
- **NEXT:** User must tap Unpublish on remaining photo product and refresh independent Cloud Preview; read SQL draft and anonymous Storage GET negative to confirm photo no longer publicly served. Keep image and draft for future test unless owner explicitly deletes them.
- Public Cloud Preview is staging only, and static V8 customer storefront and MindCare remain unchanged.

## Final photo unpublish / anonymous role privacy (JBC-E045; 2026-10-24)
- Owner submitted 2 iPhone screenshots at local 22:16 showing **US$15 stock4 TEST Cotton Baby Romper.** still present in owner catalogue with photo and **Draft** badge; public cloud-preview displays **No products published yet**.
- Jue-only Supabase readback confirms only one record, `published=false`, price 1500 cents, stock 4 and same `image_path` as before; one JPEG object remains in private `jues-product-photos` bucket.
- SQL `SET LOCAL ROLE anon` and `set_config('storage.operation','object.get_authenticated',true)` returns **0 products and 0 readable photo objects**. With `object.list`, anonymous listing also returns zero. Simulated approved owner Auth UUID can read one object; unapproved Auth UUID can read none.
- **User-tested Stage 5C flow** owner image upload, public image GET 200 when published, mobile delete of extra draft, final unpublish + empty preview are all accepted with final DB state verified. **Remaining security limitation:** actual direct HTTP GET to the photo path as a nonowner after unpublishing has NOT been independently run. Database-role simulation does not substitute for that API negative test.
- Keep the private TEST product for future regression proof; do not silently delete it. The original live `index.html` remains static V8 demo. No checkout, orders, payment, real stock or commercial launch authorization.

## Stage 5C anonymous HTTP check + Stage 5D cloud storefront candidate (JBC-E046/E047; 2026-10-24)
- Jue owner-cloud `ef053d8e7a330a325102e73edb1be214cd839b5f`: when a product is unpublished with `image_path`, a **Test anonymous access to this private photo** button appears under details. The test first downloads via approved owner Storage SDK (proof that object exists), then performs an independent GET with *only* Jue public publishable key, no cookies and no owner access token. Shows blocked HTTP status or FAIL for HTTP 200; inconclusive on errors. Linked to new storefront candidate via subsequent owner-cloud commit `c98b919e5f797f705eeb9a79c925e370586f12b6`.
- **Not yet executed by user**; do not mark S5C direct unauthorised GET security gate closed.
- New `storefront-cloud-staging.html` commit `5d930b9c71c627def132336aeb7bd409150bf48f` is a responsive Jue-branded customer storefront *candidate*. Cloud SELECT uses `published=true` only, private Storage photo downloads, filters/search/sort/product details, explicit empty state, and **no bag, checkout, orders or payments**.
- JS source re-fetch/parser PASS, static checks confirmed no persistent Auth, no HTML injection via innerHTML, no fallback to demo products on API error, and no production index.html change. These are static/code checks **not** real browser acceptance.
- Dedicated Jue Supabase state after implementation: 1 saved TEST product private (`published=false`), 1 linked private JPEG, 0 public products; no DB mutation was made for Stage 5D.
- Acceptance protocol: `docs/STAGE5D_CLOUD_STOREFRONT_ACCEPTANCE.md`. Test anonymous photo GET denial while still private; then briefly publish TEST product on owner iPhone, verify cloud storefront on Dell, and unpublish again. Never treat TEST stock/photo as real merchandise.
- Stage 5 overall remains OPEN and original V8 live customer demo remains untouched.

## Stage 5C direct anonymous HTTP denial accepted (JBC-E048; 2026-10-24)
- Owner supplied iPhone screenshot of authenticated owner-cloud test at 22:46: saved Draft photo downloaded successfully with owner credentials; separate public-key-only anonymous photo GET returned HTTP **400** and body `{"statusCode":"404","error":"not_found","message":"Object not found","code":"NoSuchKey"}`.
- Jue-only Supabase **edge logs** independently confirm anonymous Storage `GET | 400` against the same private object at `2026-10-24T20:46:28.597Z` (preflight OPTIONS 200 earlier). The HTTP response masked the object's existence; it was not deleted.
- Backend SQL: exactly 1 saved `TEST Cotton Baby Romper.` US$15/stock4, `published=false`, linked to 1 private JPEG; anonymous Storage SELECT for download returns 0 objects.
- **Stage 5C STAGING acceptance complete for targeted owner photo upload, public viewing when published, unpublish/draft retention, duplicate draft Delete and direct anonymous GET blocked while unpublished.** No guarantee about all security threats, cross-provider authorization, quotas or production readiness. Staging test content is not real commercial inventory.
- **NEXT:** Stage 5D new candidate `storefront-cloud-staging.html` needs browser test: first empty as draft, then owner briefly publishes TEST listing, Dell/phone preview shows photo/details, then owner unpublishes and preview clears. Real checkout, payment/order systems and migrating to `index.html` remain out of scope.

## Stage 5D first complete iPhone storefront cycle (JBC-E049; 2026-10-24)
- User shared four iPhone screenshots (22:54–22:55): cloud storefront initially **0 published products**, published US$15 stock4 TEST romper with JPEG, functioning **View sizes & details** modal (Newborn size, category, price and no checkout), then empty catalogue after owner unpublish.
- Independent Jue Supabase product readback: the sole item is `published=false`, stock 4 at US$15, with same protected `image_path` and updated 2026-10-24 20:55:33 UTC. SQL as `anon` sees zero products and zero readable JPEGs.
- API logs around 20:54–20:55 UTC recorded `PATCH 200` for publish and unpublish, published-catalogue `GET 200`, and Storage photo `GET 200`. Browser screenshots plus logs corroborate **iPhone functional lifecycle PASS**.
- **Stage 5D NOT CLOSED:** no independently verified Dell InPrivate viewing of the new storefront while it is published; no meaningful multi-item price sorting test; search/age filtering positive/negative cases and failure/offline recovery still open.
- Customer `index.html` V8 demo remains unchanged; no live checkout, payment, ordering, customer PII or stock reservation added.
- Next action: Dell InPrivate standalone storefront empty-state check; brief owner-controlled publish on iPhone, Dell live photo/detail & search filters; then unpublish. Keep TEST as a private draft.

## First logged Windows Edge cross-device storefront GET (JBC-E052, 2026-10-25)
- User confirmed **the romper appeared on the Dell** after publishing it from the approved iPhone owner dashboard. Independent Jue Supabase logs distinguish the clients by user agent and sequence.
- Windows 10 Edge `GET jues_products?published=eq.true` HTTP 200 while initially private at **07:05:09 UTC**. Owner iPhone `PATCH published` HTTP 200 **07:07:11 UTC**.
- After publish, Windows 10 Edge `GET published catalogue` 200 at **07:07:14 / 07:07:18 UTC**, and private Storage object photo `GET` **200** at **07:07:14 UTC**. DB readback: single US$15 stock4 `TEST Cotton Baby Romper.` is currently `published=true` with linked JPEG.
- **Cross-device iPhone-to-Dell dynamic catalogue/photo visibility VERIFIED** by user report and distinct-device HTTP logs; not yet full Dell feature acceptance.
- Outstanding: Dell detail modal, search positive/negative, age filter, Dell disappearance after iPhone Unpublish, multi-item price sort and failure paths. Do not invent completed tests. The remaining TEST item is public right now; ensure owner unpublishes after checks.
- No change to original V8 `index.html`, no real stock/payment/order processing or MindCare writes.

## Stop conditions
- Wrong Supabase link, project, or org -> STOP.
- Unexpected bill/cost -> STOP and ask.
- Any write affecting MindCare -> STOP.
- Missing owner authority/RLS -> no production CRUD.
- Unknown stock or demo listing -> keep explicit DEMO labeling.
