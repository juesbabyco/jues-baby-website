# Jue's Baby Co. — Master Development Book
**Project identifier:** JUES_BABY_CO
**Version:** 1.9
**Last evidence review:** 2026-10-24
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
| S6 | Production ordering, stock, delivery, payment | NOT IMPLEMENTED. Requires independent testing and approvals. |
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
