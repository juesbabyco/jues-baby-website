# Supabase Scope — Jue's Baby Co.

**Status:** DEDICATED PROJECT AND PRIVATE GOVERNANCE REGISTRY VERIFIED; STAGE 5A PRODUCT/OWNER SCHEMA DEPLOYED; NO AUTH USERS, OWNER APPROVAL OR BROWSER CROSS-DEVICE PROOF.

The Supabase integration for this store MUST use Juesbabyco connection and organization `cgqjblrthxmahtqmwzjz`. **NEVER** target either MindCare project.

Juesbabyco project **`izeezajdiawiaweffbrh`** (name `jues-baby-co`) was created on 2026-10-24 in `eu-west-1`, after explicit user agreement to the quoted **US$0/month** cost. Project was ACTIVE_HEALTHY. Do not conflate with MindCare.

**Deployed migration:** `20261024115601_jues_private_development_registry_v1`. Source: `migrations/20261024115601_jues_private_development_registry_v1.sql`. Private schema: `jues_internal`, tables `project_registry` and `stage_events`. Verified RLS enabled, anonymous/authenticated schema privileges denied and table write/read grants denied. Registry was later advanced to `S5A_CLOUD_CATALOGUE` with 11 total evidence events. Migration was applied to Jue project only.

Security advisor: two **informational** `rls_enabled_no_policy` notices (private governance with no browser access). Performance advisor: two informational unused indexes (empty product table). A duplicate permissive SELECT policy warning was resolved by migration `20261024122310`. Revisit all notices on launch readiness.

## Why Supabase?
When authorized and ready, it will hold a durable project registry (to supplement GitHub), authentication, public product catalogue, authorized owner changes and later orders. GitHub is the canonical narrative/history; database registry supports structured operational state.

## Remaining schema requirements
- **Implemented:** `project_registry`: project identity, current stage, state and summary. `stage_events`: dated evidence type, stage, summary and source reference. Future refinements must be versioned.
- **Not implemented:** immutable database-level event enforcement; present insert-only convention is not a trigger-guaranteed append-only contract.
- **Deployed Stage 5A:** `public.jues_store_owners`: Auth UUIDs, only privileged provisioning, no authenticated inserts/updates. `public.jues_products`: validated name, US-dollar cents, age, category, sizes, stock, optional HTTPS photo URL, `published` default false. No sample inventory transferred.
- **Applied migrations:** `20261024121448_jues_stage5_owner_and_product_catalogue`, `20261024122310_jues_stage5_streamline_read_policies`. See `migrations/`.
- **Verified negative permissions:** anon write rejected; unrelated signed-in user write denied by RLS; public SELECT reveals published rows only in rolled-back transaction. Actual approved-owner login test still pending.
- RLS ON for every exposed table; public may only SELECT published products; no anon/admin writes; owner writes only with DB-side authorization; stage events not publicly writable.
- No service_role/secret keys in GitHub or browser. Public publishable keys only.
- Unauthenticated and unauthorised authenticated negative tests passed. **Approved owner positive test still open** because Auth has 0 users/approved owners. See `../docs/STAGE5_OWNER_SETUP.md`.

## Do not confuse artifacts
`index.html` and `owner-demo.html` are the LIVE DEMO. They are not yet backed by Supabase. Do not change their labels until independent multi-device tests pass.

See `PROJECT_BOOK.md`, `docs/STATUS.md`, `docs/EVIDENCE_LOG.md` for governing truth.
