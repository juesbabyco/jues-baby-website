# Supabase Scope — Jue's Baby Co.

**Status:** DEDICATED PROJECT CREATED; PRIVATE GOVERNANCE REGISTRY DEPLOYED AND VERIFIED; CLOUD PRODUCT CATALOGUE/OWNER AUTH NOT DEPLOYED.

The Supabase integration for this store MUST use Juesbabyco connection and organization `cgqjblrthxmahtqmwzjz`. **NEVER** target either MindCare project.

Juesbabyco project **`izeezajdiawiaweffbrh`** (name `jues-baby-co`) was created on 2026-10-24 in `eu-west-1`, after explicit user agreement to the quoted **US$0/month** cost. Project was ACTIVE_HEALTHY. Do not conflate with MindCare.

**Deployed migration:** `20261024115601_jues_private_development_registry_v1`. Source: `migrations/20261024115601_jues_private_development_registry_v1.sql`. Private schema: `jues_internal`, tables `project_registry` and `stage_events`. Verified RLS enabled, anonymous/authenticated schema privileges denied and table write/read grants denied. Registry now carries `PRIVATE_REGISTRY_INSTALLED_VERIFIED` and six stage events. Migration was applied to Jue project only.

Security advisor: two **informational** `rls_enabled_no_policy` notices. This is deliberate for private registry with no browser access. Revisit if future access rules are proposed; do not add open policies merely to clear informational lints.

## Why Supabase?
When authorized and ready, it will hold a durable project registry (to supplement GitHub), authentication, public product catalogue, authorized owner changes and later orders. GitHub is the canonical narrative/history; database registry supports structured operational state.

## Remaining schema requirements
- **Implemented:** `project_registry`: project identity, current stage, state and summary. `stage_events`: dated evidence type, stage, summary and source reference. Future refinements must be versioned.
- **Not implemented:** immutable database-level event enforcement; present insert-only convention is not a trigger-guaranteed append-only contract.
- `store_owners`: store owner user IDs provisioned only through verified privileged admin process, no public self-assignment.
- `products`: public fields only, explicit visible/approved boolean, validated price/stock, safe image URL. No demo items transferred without owner confirmation.
- RLS ON for every exposed table; public may only SELECT published products; no anon/admin writes; owner writes only with DB-side authorization; stage events not publicly writable.
- No service_role/secret keys in GitHub or browser. Public publishable keys only.
- Test permissions as unauthenticated, authenticated non-owner, owner and privileged service separately. Check unauthorized writes are denied.

## Do not confuse artifacts
`index.html` and `owner-demo.html` are the LIVE DEMO. They are not yet backed by Supabase. Do not change their labels until independent multi-device tests pass.

See `PROJECT_BOOK.md`, `docs/STATUS.md`, `docs/EVIDENCE_LOG.md` for governing truth.
