# Jue's Baby Co. — Master Development Book
**Project identifier:** JUES_BABY_CO
**Version:** 1.0
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
- Main implementation: `index.html`, `owner-demo.html`.
- Latest verified stage ledger: `docs/STATUS.md`.
- Evidence log: `docs/EVIDENCE_LOG.md`.
- Decision record: `docs/DECISIONS.md`.
- Durable Supabase database schema (draft, **not deployed**): `supabase/README.md`, `supabase/migrations/` after database is approved.
- To resume: fetch **all** these files from GitHub before proposing work. Check recent commits and live status. State which facts are verified and what remains untested. Never assume a previous assistant turn performed an action until its evidence is in GitHub/Supabase.

## 4. Version/stage ledger (summary)
| Stage | Goal | Current truth |
|---|---|---|
| S0 | Branding & visual baseline | Approved by user. V5 visual direction retained in later prototypes. |
| S1 | Catalogue and age discovery | V6–V6.3; 8 illustrative products; embedded photos; iPhone image preview user-confirmed. |
| S2 | Demo shopping bag and checkout | V7 on GitHub Pages; user-reported checkout success and reference. No real order or payment. |
| S3a | Responsive live prototype | V8 deployed; user-reported mobile/desktop success. |
| S3b | Owner management **local demo** | `owner-demo.html` deployed; user verified local price edit reflects on same-browser storefront. |
| S4 | Durable project governance | This master book & evidence ledger committed to GitHub. Supabase registry requires a dedicated project. |
| S5 | Cloud product catalogue & authenticated owner | NOT IMPLEMENTED; next development milestone after dedicated backend setup. |
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

## 6. Next milestone acceptance (S5)
1. Create backend project only in Juesbabyco Supabase organization, not MindCare.
2. Schema and migrations reviewed for permissions, explicit public visibility, validation and safe catalog authoring.
3. Auth: owner access cannot be self-claimed. Unauthenticated/other-user writes denied by RLS.
4. Public customer site reads only active approved products; inaccessible drafts and any sensitive fields cannot leak.
5. Owner edits from one browser show on a *second* independent browser/device after refresh; cloud audit demonstrates source record changed.
6. Stock updates not accepted if inconsistent; no false reservations during checkout demos.
7. Public credentials use only publishable/anon key. Never ship Supabase secret/service_role key.
8. Graceful loading/error/offline states; catalogue and checkout cannot silently misrepresent unavailable products.
9. No customer orders/PII collected until separate consent, privacy, retention and orders stage is tested.

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
