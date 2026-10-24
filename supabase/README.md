# Supabase Scope — Jue's Baby Co.

**Status:** NOT DEPLOYED. Repository documentation only.

The Supabase integration for this store MUST use Juesbabyco connection and organization `cgqjblrthxmahtqmwzjz`. **NEVER** target either MindCare project.

At last check, Juesbabyco had no projects. The quote for first project creation was **US$0/month**; the API requires an explicit cost-confirmation ID before proceeding. No project creation succeeded in the recorded attempt.

## Why Supabase?
When authorized and ready, it will hold a durable project registry (to supplement GitHub), authentication, public product catalogue, authorized owner changes and later orders. GitHub is the canonical narrative/history; database registry supports structured operational state.

## First schema requirements
- `project_registry`: versioned project identity, accepted rules, current milestone and updated timestamp. No secrets.
- `stage_events`: append-only stage evidence with timestamp, actor/source, claim, verification state, commit link, next action.
- `store_owners`: store owner user IDs provisioned only through verified privileged admin process, no public self-assignment.
- `products`: public fields only, explicit visible/approved boolean, validated price/stock, safe image URL. No demo items transferred without owner confirmation.
- RLS ON for every exposed table; public may only SELECT published products; no anon/admin writes; owner writes only with DB-side authorization; stage events not publicly writable.
- No service_role/secret keys in GitHub or browser. Public publishable keys only.
- Test permissions as unauthenticated, authenticated non-owner, owner and privileged service separately. Check unauthorized writes are denied.

## Do not confuse artifacts
`index.html` and `owner-demo.html` are the LIVE DEMO. They are not yet backed by Supabase. Do not change their labels until independent multi-device tests pass.

See `PROJECT_BOOK.md`, `docs/STATUS.md`, `docs/EVIDENCE_LOG.md` for governing truth.
