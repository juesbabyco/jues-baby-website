# Supabase Scope — Jue's Baby Co.

**Status (2026-10-24):** Dedicated Jue project and private governance verified. S5B owner and cross-device catalogue tests PASSED. S5C private photo Storage migration deployed with zero stored files; owner photo upload and public/private photo download still require user acceptance.

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
- **Verified negative permissions:** anon write rejected; unrelated signed-in user write denied by RLS; public SELECT reveals published rows only in rolled-back transaction. Actual approved-owner login and cross-device product workflow user-tested and accepted.
- RLS ON for every exposed table; public may only SELECT published products; no anon/admin writes; owner writes only with DB-side authorization; stage events not publicly writable.
- No service_role/secret keys in GitHub or browser. Public publishable keys only.
- Unauthenticated and unauthorised authenticated negative tests passed. **Owner positive login and catalogue tests PASSED** with exactly one approved owner; second Auth test identity denied owner access; database RLS negative insert and update tests passed. See `../docs/STAGE5_OWNER_SETUP.md`.

## Stage 5C private product photos (2026-10-24)
- Applied migration `20261024190037_jues_stage5c_private_product_photo_storage`, mirrored in GitHub `supabase/migrations/` with the same prefix.
- Bucket: `jues-product-photos` PRIVATE, JPEG-only, max 2,097,152 bytes. Photo paths scoped to existing product UUID. Owner-only upload, restricted SELECT, owner-only unreferenced DELETE.
- `public.jues_products.image_path` is new and nullable; existing `image_url` remains for optional external HTTPS link.
- No images uploaded yet; staged phone upload and cross-device public download tests OPEN. See `../docs/STAGE5C_PRIVATE_PHOTO_ACCEPTANCE.md`.
- Security advisor: leaked password protection WARN disabled, must be addressed before production: https://supabase.com/docs/guides/auth/password-security#password-strength-and-leaked-password-protection
- Real storefront remains the original static V8 demo. No customer data, payments, or order acceptance.

## Do not confuse artifacts
`index.html` and `owner-demo.html` are the LIVE DEMO. They are not yet backed by Supabase. Do not change their labels until independent multi-device tests pass.

See `PROJECT_BOOK.md`, `docs/STATUS.md`, `docs/EVIDENCE_LOG.md` for governing truth.
