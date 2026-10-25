# Jue's Baby Co. — Stage 5E Sorting and Offline Recovery

**As of 2026-10-25: BUILT, SCRIPT-CHECKED AND LOCAL SIMULATION PASSED. Real iPhone/Dell offline-browser acceptance OPEN.**
This stage adds NO merchandise, fake stock, production checkout or costs to Jue Supabase. The only real TEST product remains unpublished. Stage 5 overall stays OPEN.

## Dedicated scope and boundaries
- GitHub-only Jue repo: `juesbabyco/jues-baby-website`. Never touch MindCare, and never replace original V8 `index.html` without a separate controlled signoff.
- `catalogue-logic.js`: shared pure filter and sort routine used by isolated `storefront-cloud-staging.html` and `catalogue-stage5e-tests.html`.
- `catalogue-stage5e-tests.html`: LOCAL fictitious fixtures, no Data API calls, no database writes and no simulated checkout. Four fixture entries with prices US$12/15/15/20; page highlights that they are NOT real stock.
- Staging customer page now clears **previously displayed products, photos and open details dialogs before every request** and on offline/network errors. It doesn't fall back to V8 demo records or cached cloud items.
- On browser `offline` event: invalidate in-flight results, clear catalogue, hide formerly visible products, show explicit status and a **Try connecting again** control. On `online`: re-fetch current published catalogue. If Supabase returns an error, display it rather than pretending there are zero legitimate published products.
- Supabase JS PostgREST `abortSignal` attaches a **15-second timeout** to catalogue fetch; this is supported in the official JS API. An aborted request is a failure, not an empty successful catalogue.
- Search/filters cannot overwrite a visible offline/error message with a misleading `0 published` status, because rendering requires `catalogueVerified=true`.
- A new request and offline event invalidate older asynchronous result generations so late replies should not reinsert stale photo/product UI.

## Tests already executed — code and isolated simulation
- JavaScript parsing of shared utility, fixture page and customer staging page: PASS.
- Evaluated `catalogue-logic.js` directly with an independent four-row fixture: latest input order preserved; ascending and descending numeric prices; tied-price stability.
- The **actual `catalogue-stage5e-tests.html` test script** was executed against minimal DOM stubs: **11 of 11 PASS** including case-insensitive search, newborn/sizes, nonmatching filters, empty source, and source immutability. Confirmed displayed sample sort changes to highest-first on selecting `high`.
- Ran isolated customer staging script against DOM mock and simulated Supabase response: initial published product rendered (1 item); simulated browser offline event cleared cards and showed retry warning; entering search text while offline did not erase warning; simulated reconnect reloaded current empty response. All five explicit assertions PASS.
- **These are local execution simulations, not a real browser, real Wi-Fi failure or genuine network timeout.** Do not report Stage 5E mobile/desktop acceptance yet.
- Dedicated Jue DB read-only checkpoint before changes: 1 product, 0 published, 1 linked image. GitHub code only; no Jue DB schema/product writes.

## Test A — sorting without fake inventory (user action OPEN)
1. Open `https://juesbabyco.github.io/jues-baby-website/catalogue-stage5e-tests.html?v=5e1` on the Dell or iPhone.
2. Confirm the page prominently says fictitious fixtures only and **11/11 local sorting/filter checks passed**.
3. In the sample dropdown select **Price low to high**. Expect `FIXTURE Romper US$12`, `FIXTURE Socks US$15`, `FIXTURE Blanket US$20`.
4. Select **Price high to low**. Expect `FIXTURE Blanket US$20`, `FIXTURE Socks US$15`, `FIXTURE Romper US$12`.
5. If any test shows FAIL, STOP before attempting production storefront. One real cloud product cannot by itself establish real multi-product sort.

## Test B — real Dell offline/reconnect while owner unpublishes (user action OPEN)
1. On **Dell Edge InPrivate**, open `https://juesbabyco.github.io/jues-baby-website/storefront-cloud-staging.html?v=5e1` while connected; it should show 0 published products.
2. On the approved iPhone owner dashboard, temporarily **Publish** the existing TEST Cotton Baby Romper. (US$15 stock4, illustrative JPEG). Refresh Dell; verify visible.
3. **Leave Dell browser tab open** and turn off **Dell Wi-Fi only**, without disabling the iPhone's connection. Expected: photo/card immediately disappears and an **offline warning** plus **Try connecting again** control appears. Don't navigate to a new page during offline mode; HTML/CDN dependencies may not load from cold offline.
4. While Dell stays offline, use online iPhone owner dashboard to **Unpublish** the TEST item. Confirm it is Draft.
5. Turn Dell Wi-Fi on again; wait for online event, or press **Try connecting again** / **Refresh** if needed. The Dell must fetch current published state and show **0 published items**. The prior TEST photo/card must not reappear. Explicit error with no stale product is a safe inconclusive recovery case, not a success.
6. If Dell cannot reconnect, keep TEST product unpublished and report exact warning; do not silently republish. Do not use Wi-Fi disconnection if it disconnects the iPhone too unless phone cellular data is still available.
7. Cross-check Supabase one TEST draft `published=false` and one retained private JPEG. No checkout or payment capability.
8. Record screenshots or user observation and Supabase activity logs. Do not conflate simulated results with actual browser proof.

## Remaining after Stage 5E
- Real HTTP 5xx / transient CDN/library loading, 15-second abort, repeated retry behavior, accessibility and multi-product sorting with owner-verified actual items all need future separate evidence.
- This never authorizes production storefront replacement, stock deductions, payment webhooks, checkout or customer personal data collection.
