# Stage 5D — Cloud Storefront Candidate: Acceptance and Safety

**Status (2026-10-24): iPHONE BROWSER PUBLISH/PHOTO/DETAILS/UNPUBLISH ACCEPTED; DELL/SEARCH/FILTER, MULTI-ITEM & FAILURE TESTS OPEN.**
Stage 5C targeted anonymous-photo HTTP negative test **PASSED** via real iPhone request and Supabase edge GET 400 log (JBC-E048, 2026-10-24). Stage 5D browser acceptance and Stage 5 overall remain OPEN.

## Scope and boundaries

- Jue-only GitHub repository: `juesbabyco/jues-baby-website`. New HTML source: `storefront-cloud-staging.html`.
- Jue-only Supabase project: `izeezajdiawiaweffbrh`, org `cgqjblrthxmahtqmwzjz`.
- **Protected original:** `index.html` V8 812,690-byte self-contained demo, with local sample photos/bag/cart/checkout, remains unchanged. The new cloud page is a separate path, not a replacement or launch.
- Cloud page makes read-only anonymous `SELECT` of `public.jues_products` with `published=true`; RLS is an essential second barrier. It renders published photos via private `jues-product-photos` Storage SDK download, or validates optional HTTPS external image link.
- Built mobile-responsive product cards, search by product/category/age, age filters, price sort, View sizes & details dialog, zero-published-products empty state, and refresh.
- No fake stock reservations, no shopping bag, no checkout, no contact-details form, no payments, no order creation, and **no fallback from cloud errors to browser-local demo products**.
- This is preview-only. The saved `TEST Cotton Baby Romper.` is AI-generated example content, **not verified real merchandise**. Prices and stock are demo values, not a commercial offer.
- No new subscriptions, hosting fees, storage buckets, or non-Jue accounts involved.

## Before first publication: Stage 5C anonymous photo security gate
**Completed 2026-10-24 (JBC-E048):** Owner iPhone first downloaded the private image, then a separate anonymous public-key-only Storage GET returned HTTP 400 with `NoSuchKey`; matching Supabase edge log and still-stored private JPEG verified. Do not repeat this gate unless photo policies change.


1. Open `owner-cloud.html?v=5d1` as the approved owner; find the **US$15 stock4 TEST Cotton Baby Romper.** private draft with its saved image.
2. Tap **Test anonymous access to this private photo** beneath its details.
3. The page must first verify that owner download works, then perform a **direct GET** to the same known photo object with **only the public publishable key**, no cookies and **no owner session bearer token**.
4. **FAIL** if HTTP 200 (photo bytes returned to anonymous visitor). **Candidate PASS** if HTTP 400/401/403/404 with owner read verified; capture the actual response text/status and independently inspect the relevant Jue Storage logs before declaring final security acceptance. Network/CORS errors and HTTP 5xx are INCONCLUSIVE.
5. Do **not** publicize private image paths or owner credentials in public documentation or screenshots. The path is used in the owner browser check only.

## First Stage 5D iPhone browser cycle (JBC-E049 — 2026-10-24)
- User's four iPhone screenshots confirm zero-product empty state before publishing, published TEST romper visible with its JPEG, working sizes/details dialog with Newborn, stock 4, US$15 and no-checkout messaging, then empty state again after Unpublish.
- Supabase Jue edge logs independently record catalogue GET 200, Storage GET 200 and PATCH 200 around 20:54–20:55 UTC. Final private draft `published=false` with saved image, and anon read permissions for product/photo return zero.
- **iPhone mobile functional cycle PASSED**. NOT proof of Dell/InPrivate cross-device handling, search/age filters, multiple-item sort, or network/error resilience.
- Next Dell verification: open `storefront-cloud-staging.html?v=5d2` in Dell InPrivate to see zero products. Temporarily publish from approved owner's iPhone; Dell refresh should show product photo and details. Search by `romper`, then `zznomatch` (should be empty); choose `Newborn` and a nonmatching age; restore All ages; then Unpublish on iPhone and refresh Dell to zero. Do not create fake extra sale inventory solely to test sorting.

## Stage 5D live browser acceptance (OPEN)

1. While every product is private, open `storefront-cloud-staging.html?v=5d1` in iPhone Safari and Dell InPrivate. Confirm **0 published products** and empty-state message. A cloud error must not silently show static demo products.
2. After Stage 5C photo privacy gate passes, in the owner dashboard **Publish** the existing **US$15 stock4 TEST** product. This is staging data and should stay public only during testing.
3. Refresh new cloud storefront on laptop. Product name, photo, US$15, Newborn category and demo stock 4 should appear. Open **View sizes & details** and verify description, category, supported sizes, stock disclaimer and absence of checkout.
4. Test search, age filtering, sort (one item limits sort proof), photo display, responsiveness and refresh in both browsers. Validate JS on a physical phone or Dell browser; static parsing alone is insufficient.
5. On iPhone owner dashboard **Unpublish** same test product. Refresh laptop cloud storefront and old `cloud-preview.html`: both must show no products. Verify SQL `published=false`, photo persists, anonymous role GET permission disallows draft.
6. Confirm `index.html` retains original demo products and behavior. No checkout or actual product data has been migrated into V8.

## Later production readiness (explicitly out of scope)
- Owner approval and real product inventory, photographic licensing, stock accuracy, delivery/collection process, refunds/returns policy and privacy notices.
- Safe cloud shopping cart/order transactions, idempotent stock reservation, payment provider choice, webhook confirmation, fraud/risk controls, security and customer-data retention.
- Full actual request-level unauthorised Storage tests; failure and offline recovery; rate limits, quotas and costs.
- Production launch requires distinct founder acceptance. Avoid publishing TEST/demo products as real stock.

## Evidence and stop conditions

- Record HTML commit and JS parser output as `SYNTAX_VERIFIED`, not `USER_TESTED`.
- The owner privacy check is a user-run HTTP test; do not claim it passed merely because code exists.
- A single published photo does not validate multi-item ordering/sorting or payment workflows.
- Stop immediately if the photo is available by anonymous HTTP GET while `published=false`.
- Wrong repo/project/org or MindCare involvement is an absolute STOP.
