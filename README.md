# Jue's Baby Co. — official website and development book

**Current status (2026-10-24):** The live storefront remains a **DEMO**. The Stage 5B authenticated Supabase owner workspace and cloud preview now support owner-tested draft creation, publishing, price editing, iPhone-to-Dell visibility and unpublishing. The test item is retained as a private draft and database SQL confirms public visibility is empty. **S5B staging acceptance has passed**: real unapproved account login denied, and simulated request-identity database RLS write tests blocked. Stage 5 overall remains open. Stage 5C photo safety and Stage 5D core iPhone/Dell storefront use are user-tested. Stage 5E sorting and offline/retry hardening is built and simulated but not yet phone/Dell network-tested; original V8 customer shop is not replaced.

## Start here — always read these first
1. [Master development book](PROJECT_BOOK.md) — vision, stages, governing rules, recovery.
2. [Current development status](docs/STATUS.md) — what passed and what is blocked.
3. [Evidence log](docs/EVIDENCE_LOG.md) — dated observations, commits and tests.
4. [Decision record](docs/DECISIONS.md) — intentional architecture choices.
5. [Stage 5 owner setup](docs/STAGE5_OWNER_SETUP.md) — next login/approval and cross-device test.
6. [Supabase scope and migrations](supabase/README.md) — dedicated database, roles, evidence.

## Website links
- [Working approved storefront demo](https://juesbabyco.github.io/jues-baby-website/) — `index.html`
- [Browser-local owner demo](https://juesbabyco.github.io/jues-baby-website/owner-demo.html) — **NOT an authenticated dashboard**
- [New cloud owner staging](https://juesbabyco.github.io/jues-baby-website/owner-cloud.html) — owner account and manual approval required
- [New cloud public catalogue preview](https://juesbabyco.github.io/jues-baby-website/cloud-preview.html) — published cloud products only; **NOT a checkout**
- [Jue's dedicated Supabase project](https://supabase.com/dashboard/project/izeezajdiawiaweffbrh)

## Critical safety / isolation
- Jue's GitHub account: `juesbabyco`, repo: `juesbabyco/jues-baby-website`.
- Jue's Supabase org: `cgqjblrthxmahtqmwzjz`, project `izeezajdiawiaweffbrh`.
- **MindCare GitHub and Supabase are unrelated and must never be used or altered for Jue's.**
- This public GitHub repository must never contain passwords, customer data or server-side secret keys.
- The approved V8 storefront is a **demonstration**. No real orders, payments or stock reservations exist.
- Do not announce a stage closed without actual test evidence and a corresponding update to both GitHub and private Supabase registry.

## Latest development position
**S5B owner cloud workflow and iPhone-to-Dell public preview** USER-TESTED; final private database state SQL-VERIFIED. **Stage 5B staging functional and access-control tests PASSED**; the unapproved Auth account was rejected in the real browser and unauthorized database INSERT/UPDATE tests were denied. **Stage 5C functional flow USER-TESTED:** owner JPEG upload, published public image display, guarded deletion and unpublish with draft photo retention passed. Direct anonymous photo HTTP denial remains a final security check. **Stage 5D CORE TESTS PASSED:** isolated cloud storefront iPhone and Dell show published-only products, photo, search/filter and details, and clear after Unpublish. **Stage 5E CODE/SIMULATION VERIFIED, REAL NETWORK TEST OPEN:** `catalogue-stage5e-tests.html` uses fictional fixtures to test sorting; `storefront-cloud-staging.html` now fails closed on offline/error with retry. No real checkout, and `index.html` remains the original V8 demo. See `docs/STAGE5D_CLOUD_STOREFRONT_ACCEPTANCE.md`. See `docs/STATUS.md` and `docs/STAGE5_OWNER_SETUP.md`.
