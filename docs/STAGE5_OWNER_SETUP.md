# Stage 5A — Owner access setup & cross-device acceptance

**Status as of 2026-10-24:** Dedicated cloud product table, owner allowlist and browser staging pages are built. Database negative authorization tests passed. **Exactly one confirmed owner has been provisioned. Owner login, actual product save and cross-device browser testing remain OPEN.**

## Links
- Dedicated project: https://supabase.com/dashboard/project/izeezajdiawiaweffbrh
- Auth users: https://supabase.com/dashboard/project/izeezajdiawiaweffbrh/auth/users
- Auth URL configuration: https://supabase.com/dashboard/project/izeezajdiawiaweffbrh/auth/url-configuration
- Cloud owner workspace (staging): https://juesbabyco.github.io/jues-baby-website/owner-cloud.html
- Cloud read-only preview: https://juesbabyco.github.io/jues-baby-website/cloud-preview.html
- Existing V8 working demo (unchanged): https://juesbabyco.github.io/jues-baby-website/
- Existing browser-local owner demo (unchanged): https://juesbabyco.github.io/jues-baby-website/owner-demo.html

## Provision the intended real owner (COMPLETED 2026-10-24)
1. In the **Juesbabyco** Supabase project, open **Authentication → Users**.
2. Use **Add user / Invite user** to create or invite the intended owner with their own email. Do not share their password in ChatGPT or GitHub. Follow email verification / invitation instructions provided by Supabase. For invitation links, configure allowed site/redirect URL to the staging owner page above as needed.
3. Obtain the created user's **Auth UUID**, verify it belongs to the intended owner, then insert that **UUID only** into the owner allowlist from Supabase's **SQL Editor** in the Jue project, or ask ChatGPT to perform that scoped change after confirmation:

```sql
-- Run only after verifying the exact intended Auth user UUID.
-- Run ONLY in Juesbabyco project izeezajdiawiaweffbrh.
INSERT INTO public.jues_store_owners (user_id)
VALUES ('REPLACE_WITH_VERIFIED_AUTH_USER_UUID'::uuid)
ON CONFLICT (user_id) DO NOTHING;
```

4. **NEXT TEST:** Sign in at the staging owner workspace with the confirmed, allowlisted account. The application checks Supabase Auth and database owner membership. RLS remains authoritative.
5. Optionally restrict public self-signups in **Authentication → Providers** for this owner-only staging project after the owner is created. Do not disable email/password login itself.

## Actual user acceptance test (not yet performed)
- Owner creates one harmless **test-only** product as a **draft**.
- Independent private-browser/cloud-preview visit confirms the draft is **not visible**.
- Owner publishes the test product, then checks from a **different device/browser** that cloud preview displays the same name and price after refresh.
- Owner updates the price; different device refresh shows new price.
- Owner unpublishes it; different device no longer sees it.
- Confirm that an unrelated Supabase Auth user cannot read private drafts or write any product.
- Record test input/expected/actual in `docs/EVIDENCE_LOG.md` and `jues_internal.stage_events`.
- Delete/unpublish test item as agreed. No false real-store ordering claims.
- Do not close Stage 5 until both positive owner tests AND negative outsider tests run.

## Implemented security boundaries
- User-identity to owner-allowlist link: `public.jues_store_owners.user_id` references `auth.users.id`. No `INSERT/UPDATE/DELETE` grant to `authenticated` or `anon`; authenticated may SELECT only its own membership record.
- `public.jues_products` is RLS-enabled; public reads only published entries, and no anonymous writes are permitted.
- Authenticated non-owner INSERT was explicitly rejected by RLS in a transaction using a synthetic UUID. Anonymous INSERT was explicitly rejected at SQL grant layer.
- Transactional visible/draft test: anonymous saw one temporary published row and **zero** temporary drafts; all temporary rows rolled back.
- All store tables start empty: no imported sample inventory, no customer records.
- Browser pages use the project's **publishable** key only; server-side secret/service_role key must never be committed.
- `jues_internal` governance registry is a separate PRIVATE schema and remains unreachable by the public browser roles.

## Known gaps
- Auth positive test with approved owner: **NOT PERFORMED** (1 email-confirmed user, 1 approved owner as of 2026-10-24).
- Browser end-to-end test: **NOT PERFORMED**; JavaScript syntax and database policy checks passed.
- Supabase Storage photo uploads: **NOT IMPLEMENTED**; staging editor accepts only HTTPS image URLs.
- Real frontend `index.html` is **NOT connected** to the cloud catalogue.
- Real inventory reservations, orders, fulfilment, payments and privacy/retention workflows: **NOT IMPLEMENTED**.
- Existing public `owner-demo.html` is browser-local and unauthenticated; DO NOT treat as real owner portal.

## Migration records
- `supabase/migrations/20261024121448_jues_stage5_owner_and_product_catalogue.sql`
- `supabase/migrations/20261024122310_jues_stage5_streamline_read_policies.sql`
- For original private project memory migration, see `supabase/migrations/20261024115601_jues_private_development_registry_v1.sql`.

Do not use or modify MindCare's GitHub or Supabase project. Check organization `cgqjblrthxmahtqmwzjz` and project ID `izeezajdiawiaweffbrh` before any write.
