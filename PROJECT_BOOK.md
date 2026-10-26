# Jue's Baby Co. — Master Development Book
**Project identifier:** JUES_BABY_CO
**Version:** 4.2
**Last evidence review:** 2026-10-25
**Canonical source:** This GitHub repository and the `docs/` evidence files.
**Public-facing scope:** Zimbabwe-based babywear storefront. Initial delivery/collection messaging is Harare-oriented.
**Founder/operator intent:** Store owner should manage babywear products, prices, photos, sizes and stock without code changes.
**Relationship to MindCare:** INDEPENDENT. Never use, mutate, migrate or share MindCare Supabase, code, credentials, data, payment systems or authority.

## 1. Product vision
Make a usable, approachable babywear shopping website with calm cream/chocolate branding, approved "jue's. BABY CO." wordmark, headline "For every little you.", and an approved smiling brown-skinned baby hero photo. Prioritize simple mobile shopping while supporting tablet and desktop. Owner-friendly management is core, not an afterthought.

## 2. Non-negotiable rules
1. Evidence before status: distinguish DESIGNED / BUILT / SYNTAX-VERIFIED / USER-TESTED / PRODUCTION-VERIFIED. Never mark a feature live because code was committed alone.
2. Maintain the approved visual identity unless owner specifically changes it.
3. Demo merchandise, stock, prices, photos and orders are illustrative. Do not imply availability or real payment/fulfilment.
4. GitHub Pages is public. Do not commit passwords, secret/service-role keys, personal customer data, private photos, environment files or backend privileged credentials.
5. A browser-local demo dashboard is PUBLICLY ACCESSIBLE and **not** an authenticated owner dashboard. Its changes persist only on that device/browser; it cannot authorize real stock changes.
6. Cloud writes require a dedicated Jue's Baby Co. Supabase project, least privilege, owner authentication and row-level security (RLS); verify RLS under anon, owner, and unrelated signed-in users before customer use.
7. No real orders or customer PII until backend, privacy/retention, access permissions and safeguarding of records are verified. Payment methods shown today are options only, not integrations.
8. GitHub master book and evidence updates accompany every material stage. Never overwrite historical evidence; append dated entries and links/commit SHAs.
9. Staging/test first; production promotion only after explicit testing and approval. Ask before consequential paid services or irreversible operations.
10. No claims of automatic cross-device sync without observed verification from different browsers/devices.

## 3. Source of truth and recovery
- Repo: https://github.com/juesbabyco/jues-baby-website
- Current GitHub Pages: https://juesbabyco.github.io/jues-baby-website/
- Owner demo: https://juesbabyco.github.io/jues-baby-website/owner-demo.html
- Main approved demo implementation: `index.html`, `owner-demo.html`.
- New Stage 5 cloud staging (independent): `owner-cloud.html`, `cloud-preview.html`.
- Stage 5 Auth provision and acceptance instructions: `docs/STAGE5_OWNER_SETUP.md`.
- Latest verified stage ledger: `docs/STATUS.md`.
- Evidence log: `docs/EVIDENCE_LOG.md`.
- Decision record: `docs/DECISIONS.md`.
- Dedicated Supabase project: `izeezajdiawiaweffbrh` in Juesbabyco organization `cgqjblrthxmahtqmwzjz`, created 2026-10-24 after approved US$0/month cost quote.
- Verified private governance registry: `jues_internal.project_registry`, `jues_internal.stage_events` with RLS and no frontend-role grants. See `supabase/README.md` and `supabase/migrations/20261024115601_jues_private_development_registry_v1.sql`.
- To resume: fetch **all** these files from GitHub before proposing work. Check recent commits and live status. State which facts are verified and what remains untested. Never assume a previous assistant turn performed an action until its evidence is in GitHub/Supabase.

## 4. Version/stage ledger (summary)
| Stage | Goal | Current truth |
|---|---|---|
| S0 | Branding & visual baseline | Approved by user. V5 visual direction retained in later prototypes. |
| S1 | Catalogue and age discovery | V6–V6.3; 8 illustrative products; embedded photos; iPhone image preview user-confirmed. |
| S2 | Demo shopping bag and checkout | V7 on GitHub Pages; user-reported checkout success and reference. No real order or payment. |
| S3a | Responsive live prototype | V8 deployed; user-reported mobile/desktop success. |
| S3b | Owner management **local demo** | `owner-demo.html` deployed; user verified local price edit reflects on same-browser storefront. |
| S4 | Durable project governance | GitHub development book verified; dedicated Jue Supabase project and private governance registry installed, SQL privilege checks completed 2026-10-24. |
| S5 | Cloud product catalogue & authenticated owner | **IN PROGRESS**: S5A catalogue/owner allowlist with RLS and two staging pages committed; negative security tests passed. Owner allowlisted, login user-tested on iPhone, and first cloud draft saved and verified in Supabase. Publication and cross-device browser acceptance OPEN. |
| S6 | Ordering, per-size inventory, delivery and payment | **S6A DESIGN + FICTIONAL SIMULATOR BUILT; 22/22 local checks passed.** No order backend/stock holds/customers or payments implemented. Postgres concurrency/authorization must be proven before live staging orders. |
| S7 | Security, operational readiness, launch | NOT IMPLEMENTED. |

## 5. Current implementation: important details
- Static HTML/CSS/JavaScript; GitHub Pages host.
- Single-file storefront with embedded base64 demo photos.
- CSS responsive breakpoint improvements: mobile ~2 products/row, tablet ~3, desktop ~4 with split hero.
- Product details, size selection, cart quantity changes, browser persistence, search, filters, sorting, favorites, demo checkout.
- Validation in `placeOrder()`: nonempty name, simple phone regex, and delivery area when delivery selected. User confirmed name/phone requested. Full boundary/security testing still required.
- Dashboard is `owner-demo.html`; browser localStorage key `jues_catalog_demo_v1`. Storefront reads this local value. Product photos optionally compressed to JPEG in browser. Not cross-device nor production authoritative.
- Initial demo products: Cosy cotton romper, Little sunshine set, Soft everyday onesie, Sweet dreams sleepsuit, Playtime two-piece, Welcome baby bundle, Little garden romper, Tiny cuddles set.
- User-tested test case: edit Cosy cotton romper price from US$18 to US$15 in demo dashboard, then refreshed storefront in same browser and confirmed change.
- User-confirmed checkout completion with sample ref `JUE-DEMO-965394`; that is **not** an actual backend transaction.
- Mobile file preview initially didn't execute button JavaScript; resolved by hosting in Safari through Pages. Image assets initially broken in preview; embedded demo photos fixed it.

## 6. Current milestone acceptance (S5; OPEN)
1. Dedicated backend project exists ONLY in Juesbabyco Supabase organization; ensure every future operation targets that ID, never MindCare.
2. **Implemented:** product schema, separate owner allowlist and RLS with migration source recorded. Negative-role permissions and draft/public visibility tested via rolled-back SQL transactions; owner-positive runtime test remains open.
3. **Partially tested:** Auth owner access cannot be self-claimed, anonymous/unauthorized writes are denied by RLS or database grants. Owner login was **user-tested** on iPhone on 2026-10-24 (1 confirmed Auth user, 1 allowed owner, 1 recorded sign-in).
4. **Staging only:** `cloud-preview.html` reads published entries; SQL role simulation verifies drafts hidden. Existing customer site `index.html` remains browser-local demo until signed-off cloud integration.
5. Owner edits from one browser show on a *second* independent browser/device after refresh; cloud audit demonstrates source record changed.
6. Stock updates not accepted if inconsistent; no false reservations during checkout demos.
7. Public credentials use only publishable/anon key. Never ship Supabase secret/service_role key.
8. Graceful loading/error/offline states; catalogue and checkout cannot silently misrepresent unavailable products.
9. No customer orders/PII collected until separate consent, privacy, retention and orders stage is tested.

### Stage 5A delivered 2026-10-24
- Project `izeezajdiawiaweffbrh`, organization `cgqjblrthxmahtqmwzjz` — never use MindCare.
- Migrations `20261024121448` and `20261024122310` applied for `jues_store_owners` and `jues_products` plus optimized SELECT policies.
- Tests: anon product INSERT denied; unapproved authenticated INSERT denied by RLS; transient published row visible to anon, draft hidden; test rows rolled back and DB remains empty.
- Staging GitHub Pages owner workspace and read-only cloud preview committed. JavaScript syntax verified, live browser owner acceptance pending.
- One email-confirmed Auth identity was provisioned in the sole owner allowlist on 2026-10-24; no actual catalogue product migrated, no checkout/payments, no upload storage bucket.
- Developer governance registry updated to `S5B_OWNER_LOGIN_VERIFIED` with 13 cumulative evidence events. Owner login and cloud draft save user-tested and database-verified. Publication and cross-device acceptance still OPEN.
- Next step: `docs/STAGE5_OWNER_SETUP.md` — first draft saved and anon role cannot read it. Test preview in private browser, publish, verify second device, edit price, then unpublish.

### Stage 5B — First cloud write verified 2026-10-24
- Owner created TEST Cotton Baby Romper in mobile `owner-cloud.html` after validation-message repair; record persisted in Jue's Supabase as a draft, price US$15, stock 2, Newborn/Everyday/Newborn size.
- Supabase anonymous role sees no unpublished row and cannot insert/update products.
- Private registry state: `S5B_CLOUD_DRAFT_SAVE_VERIFIED`, 15 evidence entries; corresponding entry `JBC-E025` in `docs/EVIDENCE_LOG.md`.
- **Do not close Stage 5** until real second-browser publication/update/unpublication and outsider denial acceptance tests.

### Stage 5B — Publish/Edit UI handoff 2026-10-24
- iPhone cloud-preview image showed correct empty public catalogue while the single draft remained unpublished.
- Owner reported Edit appeared unresponsive; preceding code only filled a form lower on the page with weak feedback. Changes at commit `6d872cb503caf0aa9ee27e4742d4430a3c3eeeda` add explicit confirmation-gated Publish/Unpublish and highlight/scroll the Edit panel.
- Code syntax verified; **actual new UI click and cross-device public visibility are still open**.
- Read-only Supabase check after commit showed 1 test draft and 0 published products. Assistant did **not** publish any product.
- Stage 5 remains OPEN until user tests visibility, edit, update and unpublish, and outsider access remains denied.

### Stage 5B — Published cloud preview verified (2026-10-24; JBC-E027)
- The user published the test product using the owner workflow and sent iPhone screenshots showing cloud-preview.html listing TEST Cotton Baby Romper at US$15.00 with demo stock 2.
- SQL persisted row and anonymous role read independently proved `published=true`, visible public read, forbidden visitor writes.
- **Publishing and public preview have passed owner functional testing.** Do not claim separate-device synchronization is proven by screenshots alone.
- Keep stage S5 OPEN pending owner price edit and refreshed read, unpublish, and a verified independent-browser/device comparison.
- The publicly visible item is clearly labelled TEST. Unpublish when experiment ends; do not treat staging preview as an order-taking site.

### Stage 5B — Price update passed (2026-10-24; JBC-E028)
- Owner used the cloud editing workflow to change TEST Cotton Baby Romper from US$15.00 to **US$16.00**, then supplied screenshot of changed public cloud preview.
- Database confirms 1600 cents, `published=true`, unchanged test stock 2. Anonymous role reads updated product, but cannot UPDATE rows.
- Stage still **OPEN**: next unpublish the published TEST item and check public disappearance, plus prove independent-device/browser visibility and unrelated user denial. Do not claim fully operational checkout.

### Stage 5B — Unpublish and draft retention verified 2026-10-24 (JBC-E029)
- After owner unpublishing, Jue database shows the test product retained at price US$16.00, stock 2, `published=false`.
- Database acting as `anon` sees 0 products; no anonymous UPDATE privileges.
- This completes owner-reported and SQL-verified draft -> publish -> edit price -> unpublish sequence.
- **Stage 5 remains OPEN** for independent cross-device/browser acceptance and unrelated authenticated user RLS test. Keep V8 demo and private governance separate; no ordering/payment claim.

### Stage 5B — Preview follow-up and outsider role simulation (JBC-E030; 2026-10-24)
- User confirmed **No products published** in public preview after owner unpublishing. Direct Jue Supabase read also confirmed 0 public rows and 1 private draft still saved at US$16.00.
- Unrelated synthetic authenticated user (SQL `SET LOCAL ROLE authenticated`, arbitrary nonowner UID) could read neither owner-allowlist entries nor unpublished products and lacked owner-allowlist insertion privileges.
- These observations are positive evidence for public-hide behavior and outsider read-policy design, but **not proof** of true two-device synchronisation during a publish event or of a real second person's authenticated session.
- Stage 5 remains OPEN. Do not promote cloud preview to live checkout or erase the saved TEST draft without owner instruction.

### Stage 5B — Dell cross-device report and divergent final state (JBC-E031; 2026-10-24)
- User reports “Working” after iPhone-to-Dell test instruction. This supports actual user experience of cross-device sharing.
- Direct Jue Supabase readback found TEST Cotton Baby Romper still **published=true**, US$16.00, stock 2; anonymous role sees 1 entry and lacks UPDATE privilege.
- **Do not represent complete unpublish roundtrip as verified**. Ask owner to unpublish test listing again and verify DB flag `false` and Dell InPrivate disappearance.
- Remains OPEN: verified final unpublish after independent-device update; real non-owner Auth account permission tests. No real checkout/payment claims.
- Project isolated from MindCare, original V8 demo unchanged.

### Stage 5B — Cross-device unpublish roundtrip accepted (JBC-E032, 2026-10-24)
- User confirmed Done after following iPhone owner Unpublish + Dell InPrivate cloud-preview refresh test. Prior cross-device publication visibility had been user-reported working.
- Independent Jue Supabase query: TEST Cotton Baby Romper is still stored at US$16.00, stock 2, **published=false**. Anonymous SQL role sees 0 products and lacks UPDATE permission.
- The documented user-tested cross-device publish/refresh/unpublish functional flow is accepted with final database state verified. Do not overstate as independently instrumented browser test.
- **S5B NOT CLOSED**: actual unrelated, unapproved signed-in Auth account must be denied owner workspace, private drafts and all write actions. Existing synthetic role tests are useful but not the same as real Auth.
- Real orders, payment, storage photos, production frontend and launch remain future stages. MindCare remains isolated.

### Stage 5B — Separate non-owner account provisioned (JBC-E033; 2026-10-24)
- User created a second confirmed Auth test identity in Jue's Supabase, not on the owner allowlist. Auth users=2, approved owners=1.
- PostgreSQL session set to `authenticated` using the test user's **actual Auth UUID** showed no readable private product rows, no readable owner entries and no membership INSERT/UPDATE privileges.
- The owner-cloud page currently signs out users lacking `jues_store_owners` membership. **Next required owner/user test**: browser sign in as the test account in a separate private window and observe access denied; verify the test session cannot create/edit products through the Data API.
- Do not mark S5B closed until real session denial evidence. No credentials or test user's email stored in this public book. Original V8 remains a demo, no real payments/orders.

### Stage 5B — Staging owner and security acceptance PASS (JBC-E034/E035, 2026-10-24)
- Real unapproved Auth account completed browser sign-in and was denied owner dashboard access with the application's expected explicit message. Auth records confirm the second account signed in, and it is not allowlisted.
- Under authenticated DB role with second account's actual Auth UUID, attempted UPDATE of the only private product matched/returned **zero rows**; attempted INSERT was rejected by RLS (42501). Transactions were rolled back; persisted final product and membership counts unchanged.
- With prior successful owner login, shared cloud draft creation, public publish, cross-device read, price edit, and final unpublish, **S5B staging functional and authorization acceptance is complete**. This is not production penetration-test certification; direct browser HTTP JWT write attacks were not run.
- S5 **overall remains OPEN**. Next workstream S5C: secure image storage/upload with owner-only policies, product images, optional production catalogue import subject to owner confirmation, cloud catalogue storefront integration and staged validation. Never turn demo data into real business stock automatically. Do not activate real orders/payments.
- New status is visible in `docs/STATUS.md`; do not hide historical failed attempts or privacy boundaries.

### Stage 5C — Private product JPEG upload prototype (JBC-E036/E037; 2026-10-24)
- Applied Jue-only migration `20261024190037_jues_stage5c_private_product_photo_storage`: bucket `jues-product-photos` **private**, MIME `image/jpeg`, max **2 MiB**; `image_path` bound to product record. RLS restricts upload to an approved owner and existing product; read by owner or public only for photo referenced by published product; deletion only by owner when unreferenced. No upsert.
- Committed owner cloud JPEG re-encoding/upload UI and catalogue photo rendering, plus anon cloud preview Storage download code. JavaScript syntax verified and deployed files fetched; **not yet phone-tested**.
- Test dossier: `docs/STAGE5C_PRIVATE_PHOTO_ACCEPTANCE.md`. First user action: edit existing TEST Cotton Baby Romper, attach one product-only image while keeping Draft. Then check private preview on Dell before publishing.
- Stage 5C OPEN; separate external/owner real-image GET, permission denial, replacement and orphan cleanup checks required. Storage currently empty and public catalogue empty. Original V8 demo intact; no live ordering, payment or customer-data workflows.
- Jue Supabase Auth security advisor warns leaked password protection disabled; revisit before production, do not silently alter user's Auth security config.

### Stage 5C — Reported upload without attached photo (JBC-E038; 2026-10-24)
- User iPhone screenshot: TEST Cotton Baby Romper visible as Published US$16 with **No photo**, editor not in active Edit state; user reported prior upload success.
- Direct Supabase product record shows `image_path=NULL`, `image_url=NULL`, `published=true`: no photo linked. Do not infer successful Storage upload.
- Improved `owner-cloud.html` selection/upload feedback: picking a file displays **NOT uploaded**; upload success now requires DB readback plus private Storage download. JS syntax verified; no mobile retest evidence yet.
- Public preview link: `cloud-preview.html`. Owner editor: `owner-cloud.html?v=5c2`. User must tap Edit before choosing/uploading. After the test unpublish the TEST listing.
- S5C OPEN until photo linked with storage proof and public preview + draft privacy checked. Original V8 live demo still unchanged.

### Stage 5C — Duplicate prevention, photo Save and owner Delete (JBC-E039, 2026-10-24)
- User screenshot: 2 privately saved TEST rompers, **US$15 / stock 4** and **US$16 / stock 2**, neither with photo. SQL confirms 2 draft records, both image_path null, 0 storage objects. No witnessed Storage upload request in limited edge-log review. Do not claim photo was ever saved.
- Added draft **Delete** button gated behind an exact typed `DELETE`, unpublish-before-delete rule, owner-only database RLS, and cleanup of referenced photo after deletion; neither draft auto-deleted.
- Fixed accidental creation vs editing confusion: product reference shown, conspicuous NEW / EDIT mode, duplicate normalized-name check.
- Crucial: saving the editor with a selected file now compresses/uploads the photo in that SAME save flow; success requires DB path readback and protected download. If product saved but image fails, stay editing the same record and display actual error.
- GitHub latest owner-cloud commit `80a7e790a3b3a738b85c88066902643d2ae3f4ed` syntax verified; awaiting iPhone runtime test and further Storage RLS/anonymous browser photo evidence. No launched commerce, MindCare isolation intact.

### Stage 5C — Mobile catalogue row repair (JBC-E040; 2026-10-24)
- After adding Delete, the user screenshot showed severe word-by-word wrapping of item names in iPhone owner dashboard; existing flex row allowed action buttons to consume the text width.
- Owner cloud CSS changed to thumbnail plus details grid and a second full-width row for Edit/Publish/Delete. Small-screen widths tuned. Commit `f0df770aa94f58bcf831f0482cd7024adc85f230` inspected; JS syntax PASS.
- Stage 5C photo upload and deletion runtime remain unverified. Do not mistake appearance of Delete button for tested deletion. Existing 2 draft records must not be removed without deliberate typed confirmation by owner.

### Stage 5C — Owner photo upload successful; public photo RLS + Delete UX repaired (JBC-E041/E042; 2026-10-24)
- User iPhone owner dashboard shows photo for **US$15 stock4 TEST Cotton Baby Romper.**; direct Supabase read found attached `image_path` and one `image/jpeg` object in `jues-product-photos`. Edge requests independently show Storage upload POST 200 and owner private download GET 200. Original US$16 stock2 remains draft without photo.
- After user published photo-bearing US$15 item, Cloud Preview public Storage download GET 400. SQL evaluation as `anon` reproduced `permission denied for table jues_store_owners` due to earlier combined policy. Deployed migration `20261024195535_jues_stage5c_separate_photo_read_policies` which splits authenticated owner photo reads and public published-photo reads without granting anon owner-list rights.
- Simulated RLS: published photo visible to anonymous `object.get_authenticated` operation, unpublished photo hidden from anon and unapproved Auth account, anon object listing denied. These tests used rollback-only product state changes; they do not substitute for a real anonymous browser GET after migration.
- Owner reported Delete button not working. Replaced native `prompt()` with inline named-product confirmation requiring typed `DELETE` on GitHub commit `7317d57bab269abe98518cfee960c84216d31f4a`. SQL transaction showed owner-role DELETE could target a private draft, unapproved user could not; all rolled back. Real iPhone Delete action still needs evidence.
- **Stage 5C OPEN**. Next user test: refresh cloud preview while US$15 product published, check image; unpublish it; then optionally delete that draft using inline confirm. No auto-delete. Original V8 storefront and MindCare untouched.

### Stage 5C — Public photo verified; inline Delete panel user-tested (JBC-E043; 2026-10-24)
- Public iPhone Cloud Preview screenshot shows uploaded US$15 stock4 romper image and catalogue details. Edge logs independently confirm two HTTP Storage GET 200 responses after photo RLS split. Public media delivery ACCEPTED for this test object.
- Owner screenshot shows inline Delete form for **US$16 stock2 draft**, with disabled Confirm button. Field visually showed DELETE as **placeholder**, not entered text. New owner-cloud commit `eb4c521fe8264d2aefb8a58d072bdc3c343ed36a` uses a nonmisleading placeholder and explicit explanation. JavaScript parses.
- No actual deletion was executed by ChatGPT or confirmed by DB; both products still present. The image-bearing US$15 product is currently **published**, so unpublish it once no longer testing. Stage 5C remains OPEN for actual Delete and privacy-after-unpublish acceptance. Original V8/demo and MindCare remain untouched.

### JBC-E044/E045 — Stage 5C photo lifecycle accepted (2026-10-24)
- On iPhone, deletion of the duplicate US$16 draft was confirmed by HTTP 200 and Supabase SQL.
- The remaining US$15 test product now has a JPEG photo and is unpublished. Its owner thumbnail persists; public Cloud Preview reports no published items.
- As anonymous SQL role, zero products or photo objects were visible. Owner role sees its one saved photo; unrelated Auth role sees zero.
- Stage 5C browser functionality passed. A real anonymous direct HTTP request against the previously published private photo URL after unpublishing is still not verified. Keep Stage 5 overall open for security and real-store workflows.

### Stage 5C direct anonymous photo GET and Stage 5D isolated storefront (JBC-E046/E047; 2026-10-24)
- Added private-draft photo security check button to Jue's authenticated `owner-cloud.html`. It verifies actual owner download before making a **no-cookies anonymous HTTP Storage GET** using public key only; any HTTP 200 is a security failure. Code/static syntax verified; **mobile browser HTTP result still PENDING**.
- Created `storefront-cloud-staging.html`: polished separate mobile-responsive Jue-branded page backed by `jues_products` published-only SELECT and private photo Storage downloads, with search/age/price filters and view-details dialog; **no bag, simulated checkout or real transactions**. API errors never silently switch to V8 demo products. JavaScript parses.
- Original `index.html` V8 static demo remains unchanged. One unpublished TEST product with photo remains in Supabase. Stage 5D is **built, not browser user-tested**. Detailed verification in `docs/STAGE5D_CLOUD_STOREFRONT_ACCEPTANCE.md`.
- Next: iPhone owner runs anonymous-photo security check while item remains draft; if blocked, briefly Publish, test cloud storefront on Dell/iPhone, then Unpublish and confirm disappearance. Separate signoff required before any live customer storefront migration.
- Keep MindCare project and credentials entirely isolated.

### Stage 5C direct unpublished-photo HTTP denial accepted (JBC-E048; 2026-10-24)
- Real owner iPhone ran private photo security button. It first verified approved-owner download, then performed no-cookie HTTP Storage GET with the publishable key only. HTTP **400** returned with `NoSuchKey` / "Object not found". This is an intentional-looking private-object hiding result, not proof of file deletion.
- Supabase edge log independently records matching image GET HTTP 400 at 20:46:28.597Z. Dedicated Jue product row stays private (US$15 stock4, photo path linked) and object still exists in bucket; simulated anon DB sees 0 downloaded objects.
- With previous owner photo upload, public GET 200 when published, owner draft Delete and post-Unpublish preview privacy, **S5C scoped staging acceptance COMPLETE**. Do not call it full security certification or launch.
- **S5D remains OPEN**: new `storefront-cloud-staging.html` is built but not browser tested. Test privacy empty state, publish on owner iPhone, view photo/details on Dell, then unpublish. The original V8 `index.html` remains unchanged; no orders/payments.

### Stage 5D — iPhone cloud storefront lifecycle passed (JBC-E049; 2026-10-24)
- Four iPhone screenshots show **empty catalogue → owner published US$15 stock4 TEST romper → cloud customer JPEG card and details dialog → unpublish restores empty catalogue**.
- Jue database final readback shows the only product private (`published=false`) with JPEG intact. Edge logs record owner PATCH 200, catalogue GET 200 and Storage photo GET 200 during the test; anon database role reads no private catalogue/photo.
- This is **user-tested iPhone browser acceptance**, not proof of Dell/desktop sync. Stage 5D still OPEN for independent-device published preview, search and age filters (and multi-item sorting later), connectivity/error behavior, and distinct final acceptance before replacing any demo storefront.
- Original large V8 `index.html` and MindCare remain untouched; no real orders, payment, stock reservation or real product signoff.

### Stage 5D — Dell Windows Edge synced publish/photo from iPhone (JBC-E052, 2026-10-25)
- User reports newly published US$15 stock4 TEST romper appeared on Dell. Supabase logs independently show Windows 10 Edge catalogue GET when unpublished (07:05:09Z), iPhone owner PATCH publish (07:07:11Z), then Windows 10 Edge published catalogue GET 200 and private Storage photo GET 200 (07:07:14Z). This is actual distinct-device read evidence.
- Jue database currently shows TEST item `published=true`, photo linked. Stage 5D **Dell cross-device positive visibility PASS**; Dell modal/filters, disappearing after final unpublish on this cycle, multi-item sort and offline resilience remain unverified.
- Do not treat public TEST listing as real merchandise; restore private draft once acceptance checks finish. Original V8 storefront and MindCare untouched, no checkout/payment/real order functionality.

### Stage 5D — Full Dell core workflow user-tested, final private state verified (JBC-E053, 2026-10-25)
- User replied “done all working” after Dell view-details, Romper/Towel searches, Newborn/3–6m filter checks and owner iPhone Unpublish → Dell Refresh. Treat UI specifics as **USER-REPORTED**.
- Backend corroboration: iPhone Unpublish `PATCH 200` at 07:14:14 UTC and a separate Windows 10 Edge published-only catalogue `GET 200` at 07:14:19 UTC. Final Jue database confirms one private US$15 stock4 TEST baby romper and attached JPEG, no public items. Anonymous Storage photo download role cannot see draft.
- **Stage 5D core cross-device staging experience ACCEPTED** (published-only cloud source, photo, detail modal, search/age filter, owner visibility controls). **Still open**: 2+-item price sorting, offline/network recovery, wider error-path/accessibility/performance testing and any commercial checkout/inventory/payment integration.
- Do NOT replace demo `index.html` or expose real buying paths on the strength of this pilot. True owner inventory, photographs, pricing and legal/customer policies need independent signoff. MindCare remains isolated.

### Stage 5E — Isolated fixture sorting & safe offline fallback prototype (JBC-E054/E055; 2026-10-25)
- Added `catalogue-logic.js` as shared, pure catalogue filtering/sorting function (stable prices, age and text filters); `storefront-cloud-staging.html` now uses it.
- `catalogue-stage5e-tests.html` contains only local **fictional** 4-product fixture data, never a cloud database insertion. Executed actual test script in DOM stub: **11/11 PASS**. This is not yet user browser acceptance or multi-item production sorting.
- Hardened staging storefront: empty old product cards/photos before refresh; hide everything on offline/API error, explicit retry/online reload, invalidate stale promises, preserve error state when filters change, 15-second bounded query via Supabase `abortSignal`.
- Executed actual staging script with mock DOM/network: initial displayed item -> offline clears -> search input doesn't hide warning -> reconnect fetches current empty state; **5/5 PASS**. This is simulated execution, NOT real Dell network outage proof.
- Remaining user test: `catalogue-stage5e-tests.html?v=5e1` should show all green; leave staging page open on Dell, briefly publish TEST romper, disable only Dell Wi-Fi, unpublish from iPhone, reconnect laptop; ensure stale published product does not come back. Instructions: `docs/STAGE5E_SORTING_OFFLINE_ACCEPTANCE.md`.
- No modifications to original live demo `index.html`, no Jue schema/data/photo writes, no MindCare use, and no orders/payments/verified real stock.

### Stage 5E — Dell offline/reconnect acceptance (JBC-E056, 2026-10-25)
- Owner supplied physical Dell Edge screenshots proving offline warning + retry visible with product cards hidden, followed by normal empty published catalogue when Wi-Fi restored after iPhone Unpublish. Backend edge log supports iPhone PATCH 200 at 07:40:38 UTC and distinct Windows Edge published-only GET200 at 07:41:04 UTC. Final dedicated Jue SQL: one TEST US$15 stock4 with photo, published=false; 0 public products.
- **Real Dell offline/reconnect core behavior USER-TESTED PASS**; the earlier 11/11 sorting fixture checks remain **local code-executed**, not real 2+ cloud product test, and no live API outage/5xx or race-condition proof exists.
- Stage 5 core owner/photo/cloud storefront preview functionality is sufficiently proven to design the next controlled commerce phase, **not** to launch sales or replace the live demo. Keep original V8 `index.html` untouched and MindCare independent.
- Remaining gated roadmap: real owner merchandise/images/pricing/stock verification, customer delivery/privacy/refunds terms, safe order lifecycle and inventory consistency, payment provider only after dry-run tests, and separate launch approval.

### JBC-E057: iPhone fixture test
Screenshot shows 11 of 11 fixture checks passing in Safari, with only fictional in-browser products. The sort dropdown was shown in its default state, so manual low/high selection is not yet verified. No real Jue catalogue writes were made.

### Stage 5E iPhone interactive sorting acceptance (JBC-E058; 2026-10-25)
- Three owner screenshots show manual **Recently added**, **Price low-to-high** and **Price high-to-low** ordering correct for 3 fictional fixture items. iPhone browser sorting interaction is USER-TESTED. This is not a test of 2+ cloud-published owner inventory items.

### Stage 6A — Safe order and per-size stock rules (JBC-E059/E060; 2026-10-25)
- Dedicated Jue Supabase schema reviewed: current shared product table has a single `stock_qty` per product plus sizes array. **Cannot claim per-size availability or transactional customer reservations.** No customer orders, inventory variants, order logs or payment tables exist.
- Stage 6A design: `docs/STAGE6_ORDER_INVENTORY_DESIGN.md`, committed `89bdb17ef01ebb0e7f9cce996c2e68c8445bc6a4`. Requires protected server-side atomic per-variant stock holds, deterministic row locking, scoped request idempotency/fingerprint, immutable price/size snapshots, strict cancel/confirm/fulfil/expire transitions, no duplicate stock effects, privileged audit, separate payment state and customer privacy signoff.
- **FICTIONAL in-memory, not backend:** `order-stage6a-engine.js` (`d723c8b56c275621ff61d3267216675221697f17`) and `order-stage6a-tests.html` (`edeedbf5cde75aaf3688b9899c2e0850720479f2`). Ran the actual test-page JavaScript against a DOM stub plus real engine implementation: **22/22 PASS**. Also simulated Reserve, replay, owner Confirm, Fulfil and forbidden second Cancel transitions. Price ignored when supplied by caller; no real customer data, charges or Supabase mutations.
- **Stage 6A designed / local executable simulation verified**, **physical-device browser acceptance pending**. This does not verify parallel PostgreSQL transactions or justify opening public ordering. Stage 6B later may propose governed isolated backend tables/functions and real concurrency tests, only after review.
- Original V8 `index.html`, authenticated owner catalogue, photo storage and MindCare unchanged; only Jue GitHub docs and deliberately isolated simulator files added.

### Stage 6A iPhone acceptance — JBC-E061, 2026-10-26
Four iPhone screenshots verify simulated reserve (2 on hand, 1 held), same-key replay without second hold, owner confirmation preserving the hold and cancellation releasing it. **Fulfilment on iPhone has not been shown.** The 22/22 scripted checks were already verified separately in local execution. No real customer/order/transaction/payment was created. Evidence synchronized to GitHub log and Jue private stage events (50 events); registry current-stage update blocked. Keep production launch closed.

## 7. Testing vocabulary

- **DESIGNED:** documented intention, no code.
- **BUILT:** code/files committed, not user tested.
- **SYNTAX-VERIFIED:** parser/static validation, not full runtime behavior.
- **USER-TESTED:** owner reports behavior, but may lack repeatable automated proof.
- **PRODUCTION-VERIFIED:** deployed environment, independent reproducible functional/security evidence.
- **BLOCKED:** prerequisite absent, with exact blocker.
- **NOT STARTED:** no implementation.

## 8. Session handoff protocol
Each session reads `docs/STATUS.md` and `docs/EVIDENCE_LOG.md`, verifies current GitHub state and backend scope, then advances only a targeted stage. Each change records date, intent, file(s), tests, outcome, unresolved defects and next action. Do not fabricate test runs. If unable to update either registry, report it and leave a written handoff here.
