# Jue's Baby Co. — official website and development book

**Current status (2026-10-24):** The live storefront remains a **DEMO**. The Stage 5B authenticated Supabase owner workspace and cloud preview now support owner-tested draft creation, publishing, price editing, iPhone-to-Dell visibility and unpublishing. The test item is retained as a private draft and database SQL confirms public visibility is empty. **S5B is not yet closed**: real unrelated non-owner Auth access test is still required.

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
**S5B owner cloud workflow and iPhone-to-Dell public preview** USER-TESTED; final private database state SQL-VERIFIED. **Pending S5B security gate:** use a genuinely separate, unapproved Auth test account and confirm owner dashboard denies access and database blocks private reads/writes. No real checkout or payments. See `docs/STATUS.md` and `docs/STAGE5_OWNER_SETUP.md`.
