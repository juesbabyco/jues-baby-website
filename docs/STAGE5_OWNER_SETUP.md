# Stage 5A — Owner access setup & cross-device acceptance

**Status as of 2026-10-24:** Dedicated cloud product table, owner allowlist and browser staging pages are built. Database negative authorization tests passed. **Exactly one confirmed owner has been provisioned. Owner login USER-TESTED on iPhone on 2026-10-24; cloud draft creation PASSED (read-back verified); publishing and cloud preview USER-TESTED on iPhone. Price edit and unpublish completed and database-verified; independent second-device browser and non-owner tests remain OPEN.**

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

## Latest mobile editing test — 2026-10-24
- First cloud draft save and anon privacy SQL role query PASSED. The cloud preview screenshot showed no published product, as expected.
- Mobile Edit interaction was confusing, so the owner dashboard now has direct **Publish/Unpublish** actions beside each listing, plus a highlighted Edit form. This is a staged UI fix, not a claimed browser success.
- **Next:** Reload `owner-cloud.html`. In Shared catalogue, tap **Publish** beside `TEST Cotton Baby Romper` and explicitly confirm. Then refresh `cloud-preview.html` on another device/browser.
- Confirm remote product display **US$15.00** and then separately test edit price, preview refresh and unpublish.

## Publish checkpoint 2026-10-24
- Owner screenshots show TEST Cotton Baby Romper listed on cloud-preview.html at US$15.00 and stock 2.
- Jue Supabase direct read confirmed `published=true`; anon role can read the published item but cannot insert/update.
- **Next test:** In owner-cloud.html tap **Edit**, change price to **16.00**, tap **Save changes**. Refresh cloud-preview.html and verify **US$16.00**.
- Then in owner-cloud.html tap **Unpublish**, confirm and verify cloud preview has **no published products** after refresh.
- Repeat the cloud preview visibility check from another independent browser/device; evidence so far is iPhone screenshots only, not proven cross-device.

## Actual user acceptance test (not yet performed)
- **PASSED 2026-10-24:** Owner created test-only product as an unpublished cloud **draft** (TEST Cotton Baby Romper, US$15, stock 2).
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
- Auth positive test with approved owner: **USER-TESTED 2026-10-24** (iPhone screenshot of signed-in cloud workspace; Jue Auth verifies a recorded login).
- First cloud draft insert positive test: **VERIFIED 2026-10-24** from owner mobile save and persisted SQL record; anonymous SQL role could not view the unpublished draft.
- Browser end-to-end: owner mobile login and first draft insert passed; multi-device published preview, price update and unpublish remain **NOT PERFORMED**.
- Supabase Storage photo uploads: **NOT IMPLEMENTED**; staging editor accepts only HTTPS image URLs.
- Real frontend `index.html` is **NOT connected** to the cloud catalogue.
- Real inventory reservations, orders, fulfilment, payments and privacy/retention workflows: **NOT IMPLEMENTED**.
- Existing public `owner-demo.html` is browser-local and unauthenticated; DO NOT treat as real owner portal.

## Price change checkpoint 2026-10-24
- **PASSED:** mobile owner cloud editor changed TEST Cotton Baby Romper from US$15.00 to US$16.00. Public cloud preview screenshot and anonymous-role Supabase read-back agree.
- **NEXT:** In `owner-cloud.html`, tap **Unpublish** for TEST Cotton Baby Romper, confirm. Refresh `cloud-preview.html`: it should show **No products published yet**.
- Then verify from a genuinely independent browser/device and test a second, non-owner account is denied access to drafts and product mutations.
- Stage 5 remains OPEN until verified. This preview is not real checkout.

## Unpublish checkpoint 2026-10-24 (JBC-E029)
- Owner reported Unpublish worked. Supabase confirmed test record remains stored as a **draft** at US$16.00 and stock 2.
- Anonymous SQL role now sees 0 published items; still cannot edit products.
- Next test: open `cloud-preview.html` in a genuinely different browser/device (not the authenticated owner session), refresh, and confirm **No products published yet**. Later repeat a harmless draft/public roundtrip on both devices for cross-device synchronization evidence.
- Still required for Stage 5 closure: verify non-owner authenticated account cannot view draft or write a product. Do not grant second user owner rights just to test.
- No real sale/order/payment integration.

## Follow-up 2026-10-24 — JBC-E030
- User reported public cloud preview shows **No products published** after unpublish. Supabase confirms zero public products; saved TEST draft remains at US$16.00.
- Synthetic unrelated authenticated UID inspected under `SET LOCAL ROLE authenticated` saw no private owner rows and no draft rows; could not self-add to owner allowlist.
- An independent different-browser/device dynamic publish and price-update roundtrip is still OPEN. A truly separate, non-owner Auth account test is also OPEN. The simulated role is useful but does not replace an actual sign-in.
- Do not mark Stage 5 closed or introduce real transactions yet.

## Cross-device test report and verification gap (JBC-E031, 2026-10-24)
- User reports test between iPhone and Dell laptop **working**, following instruction to publish, refresh on Dell, unpublish and refresh again.
- Supabase check afterward shows TEST Cotton Baby Romper still **published=true**, US$16.00, stock 2; anonymous visitor can read it. Thus publication is demonstrably live; final unpublish not confirmed in cloud.
- Repeat last step: open `owner-cloud.html` on iPhone, tap **Unpublish**, confirm, then refresh Dell `cloud-preview.html`. Check that 0 published products remain, and record SQL readback.
- A separate **real non-owner Auth identity** must still be tested for no access to owner dashboard or draft/write capability. Simulated non-owner role tests alone are insufficient. Keep user credentials out of chats/repository.
- Stage 5 remains OPEN.

## Second-device final unpublish verified 2026-10-24 (JBC-E032)
- User confirmed Done after unpublishing on iPhone and refreshing Dell InPrivate cloud preview. SQL independently confirmed TEST Cotton Baby Romper at US$16 remains stored as `published=false`, with zero visible public items.
- This completes the user-tested cross-device publication/visibility/removal acceptance with independently checked final persistence.
- **Remaining S5B security gate:** provision a *separate unapproved test user* in Jue Supabase Auth (do not add its UUID to `jues_store_owners`), sign in and verify the owner-cloud page denies access; also test that this account cannot read the unpublished draft or mutate a product.
- Never share real passwords with ChatGPT or commit account emails in GitHub. A synthetic UUID role read previously passed but is not a live-user substitute.
- The public `cloud-preview.html` remains staging-only and currently empty. No real commerce.

## Non-owner account checked 2026-10-24 — JBC-E033
- Second Supabase Auth test account created and email-confirmed; the approved owner count remains exactly one.
- SQL under the second account's **real UUID** but simulated authenticated database role showed 0 owner rows, 0 draft rows and no owner-list insert/update privileges.
- **Required next: browser sign in** at `owner-cloud.html` in a separate InPrivate/Incognito session with the new test user's credentials. Expect explicit **Access denied** and no Shared catalogue or editing controls.
- This is not yet a completed production-auth negative test. Do not share password here; do not add the test user to `jues_store_owners`.
- After browser denial, record evidence and verify no products were changed. A true direct nonowner INSERT/UPDATE attempt remains to be tested or explicitly documented as pending.

## Stage 5B owner access/security check accepted 2026-10-24 (JBC-E034/E035)
- Real second confirmed Auth account signed in at owner-cloud.html and was rejected with exact expected **Access denied** owner message. Auth sign-in was independently recorded and account was not on owner allowlist.
- Under authenticated role with test user's actual UUID, UPDATE of the private TEST product returned zero rows and INSERT rejected with RLS 42501. Both tested within rollback transactions; persistence unchanged.
- **S5B staging acceptance PASS.** Unlike an actual HTTP/JWT write security probe, these tests use PostgreSQL role impersonation for mutation-path verification; broader production security review remains OPEN.
- Next: S5C cloud photo uploads, safe Storage RLS, image rendering, and controlled storefront integration. Retain real-order and checkout locks. `TEST Cotton Baby Romper` is unpublished, saved at US$16 and stock 2.

## Migration records
- `supabase/migrations/20261024121448_jues_stage5_owner_and_product_catalogue.sql`
- `supabase/migrations/20261024122310_jues_stage5_streamline_read_policies.sql`
- For original private project memory migration, see `supabase/migrations/20261024115601_jues_private_development_registry_v1.sql`.

Do not use or modify MindCare's GitHub or Supabase project. Check organization `cgqjblrthxmahtqmwzjz` and project ID `izeezajdiawiaweffbrh` before any write.
