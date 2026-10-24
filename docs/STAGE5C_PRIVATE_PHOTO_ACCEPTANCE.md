# Stage 5C — Private Product Photo Upload and Public Preview Acceptance

**As of 2026-10-24: BUILT / SYNTAX-VERIFIED / DATABASE POLICY INSPECTED; MOBILE AND PUBLIC-DOWNLOAD TESTS OPEN.**
No existing V8 storefront changes; not production checkout. One Jue-specific private photo bucket and a new nullable `image_path` column.

## Current trusted setup
- Jue organization: `cgqjblrthxmahtqmwzjz`; Supabase project: `izeezajdiawiaweffbrh`. Never modify MindCare.
- Supabase migration: `20261024190037_jues_stage5c_private_product_photo_storage` mirrored at `supabase/migrations/20261024190037_jues_stage5c_private_product_photo_storage.sql`.
- Bucket `jues-product-photos` is **private**, size limit **2,097,152 bytes (2 MiB)**, only `image/jpeg`. SQL verified bucket config and zero objects as of setup.
- Owner upload paths: `products/<existing-product-id>/<random-uuid>.jpg`; UUID folder must match an existing product record.
- Storage SELECT permits owner access to their bucket. For public guests it permits download requests only when a published product references the specific `image_path`.
- Storage INSERT is owner-only and existing-product-only; DELETE allows owners to remove **unreferenced** objects. No Storage UPDATE/upsert policy.
- `jues_products.image_path` is nullable with a DB CHECK binding it to the product UUID. Existing optional HTTPS `image_url` remains supported for backward compatibility.
- Owner browser scales image to <=1400 px longest edge and JPEG-compresses to <=2 MiB before uploading; it re-encodes rather than forwarding the original file (most photo metadata is removed). Photos must be product-only; never use images of customers or children.
- `owner-cloud.html` displays an upload picker after tapping **Edit** on an existing draft; uploaded path is attached to the product. `cloud-preview.html` uses authenticated Storage download and a short-lived local object URL after checking published catalogue rows.

## Owner feedback 2026-10-24 — JBC-E038
- User screenshot shows TEST Cotton Baby Romper **Published** with No photo and the separate form heading Add a product draft. Database image_url and image_path were NULL. Thus no photo was linked, regardless of previous uploader wording.
- Fixed owner UI in commit `338223c9ac828191da964dde38447b432ac84913` to clearly distinguish selected file vs uploaded file and verify SQL product readback plus private Storage GET before claiming saved.
- Test safely: Open https://juesbabyco.github.io/jues-baby-website/owner-cloud.html?v=5c2, tap Edit next to product, select a photo, tap **Upload photo to this product**. Look for exact status **PHOTO SAVED AND VERIFIED**. If an error appears, report the text.
- Current product is published; it can show in public preview once image actually attached. After verifying, tap Unpublish to restore privacy. Do not claim preview photo worked without browser proof.

## Test 1 — owner photo as unpublished draft (PENDING)
1. Sign into https://juesbabyco.github.io/jues-baby-website/owner-cloud.html on the authorized iPhone. Refresh to fetch Stage 5C changes.
2. Confirm `TEST Cotton Baby Romper` still says **Draft**, stock 2, price US$16.00.
3. Tap **Edit**, choose a harmless **product-only** babywear photo using **Choose a photo**, then tap **Upload photo to this product**, confirm.
4. Verify the owner catalogue shows the photo and the upload status says it was saved. Do not publish yet.
5. Open https://juesbabyco.github.io/jues-baby-website/cloud-preview.html in Dell InPrivate. The draft and private photo **must not appear**. The original `index.html` must remain unchanged.
6. Read database: image_path nonnull and within the product folder; bucket object count increments by one; `published=false`. Do not record image contents or personal data.

## Test 2 — publish and public download (PENDING)
1. On iPhone tap **Publish** for the test product; confirm.
2. Refresh Dell InPrivate cloud preview. Product should appear at **US$16.00 with its uploaded photo**, after loading indicator.
3. If photo says **Photo unavailable**, record exact browser error and do not claim public Storage SELECT policy passed. Keep test item published only for troubleshooting.
4. Independently query database for `published=true`; confirm exactly 1 owner-uploaded Storage object linked to product.
5. Tap **Unpublish** and refresh Dell InPrivate. Entire product/photo must disappear; owner preview must still show it privately.
6. Verify SQL `published=false`, anon product SELECT returns zero. The underlying object should remain in private bucket for future editing.

## Security negative tests (PENDING)
- Simulate unapproved user's real UID and assert no owner membership and no access to draft `image_path` via RLS.
- Verify anonymous and nonowner cannot INSERT or DELETE Storage objects through **actual Storage API**, not just simulated SQL. Do not write into the Storage schema directly.
- Verify private bucket cannot serve unpublished photo to an anonymous direct download request. Verify published photo downloads succeed only through allowed GET operation.
- Invalid filename/MIME/size rejected by server; JPG re-encode handles iPhone file types.
- Review uploaded file quotas/billing, unexpected orphan objects, owner permission revocation, and cleanup logic before production.

## Evidence and stop rules
- Status stays OPEN until owner iPhone and Dell browser tests prove both private and public photo behavior.
- Rollbacks are browser-driven Publish/Unpublish and owner-only photo replacement; **no production DB or MindCare writes**.
- The company remains a demo with NO payments, orders, checkout, customer identity data or real stock validation. S5C does not authorize cloud product migration to `index.html`.
- Supabase security advisory as of setup: `auth_leaked_password_protection` WARN remains disabled (see https://supabase.com/docs/guides/auth/password-security#password-strength-and-leaked-password-protection). The two `jues_internal` RLS-without-policy INFO items are deliberate no-access internal tables.
