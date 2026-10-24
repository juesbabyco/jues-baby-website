# Jue's Baby Co. — Stage 5B Login Handoff (2026-10-24)

**Latest verified truth:** Owner authentication **USER-TESTED**. Stage 5 is still **OPEN**.

## Proof
- Owner supplied screenshots of the cloud owner workspace on iPhone.
- Screenshots show connected cloud catalogue, signed-in owner session, shared catalogue panel and a blank 'Add a product draft' form.
- Independent read-only query on the dedicated Juesbabyco Supabase project `izeezajdiawiaweffbrh` found exactly one Auth account with a recorded sign-in and exactly one matching entry in `public.jues_store_owners`.
- Project `jues_internal.project_registry` state: `S5B_OWNER_LOGIN_VERIFIED` and `OWNER_LOGIN_USER_TESTED_CLOUD_DRAFT_SAVE_OPEN`.
- Private stage evidence event: `JBC-E023`. See `docs/EVIDENCE_LOG.md`.
- Cloud products remain **zero**. Nothing has been offered to real customers.

## Next acceptance steps
1. On `owner-cloud.html`, save a clearly fictional **draft-only** catalogue product with a harmless name, price, stock and at least one size; leave **Publish to cloud preview** unchecked.
2. Verify the draft appears in the signed-in owner's **Shared catalogue**.
3. Open `cloud-preview.html` in a separate browser and verify draft is not visible.
4. Publish the test item from the owner workspace, then refresh cloud preview on a different device/browser; compare product details and update price.
5. Unpublish it; verify it disappears from public cloud preview, and test unauthorized account writes denied.
6. Record actual test evidence and roll back test visibility. **Do not mark Stage 5 complete until verified**.

## Boundaries
- No browser-level product create/update/public preview acceptance yet.
- No real orders, reservations or payments.
- The approved `index.html` storefront is still the separate local demo and was not changed.
- Private operator email/password do not belong in public repo.
- NEVER write to MindCare Supabase or GitHub for this project.
- GitHub canonical references: `PROJECT_BOOK.md`, `docs/EVIDENCE_LOG.md`, `docs/STAGE5_OWNER_SETUP.md`.
- A previous in-place update of `docs/STATUS.md` was blocked by tooling. This handoff and the current master book supersede the older "positive login still open" wording in that status file until reconciliation.
