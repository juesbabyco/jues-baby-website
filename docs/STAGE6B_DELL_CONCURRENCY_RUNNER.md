# Stage 6B — Real Two-Connection Race on the Dell

**2026-11-01: RUNNER SOURCE BUILT / LIVE RACE NOT EXECUTED.** Do not claim Stage 6B concurrency PASS until a real run returns PASS with distinct backend PIDs and overlapping database timestamps.

## What this does

Runs **two genuinely independent PostgreSQL client connections** from the owner's Dell against *only* the private fictional `jues_stage6b` schema of Jue's dedicated Supabase project `izeezajdiawiaweffbrh` (org `cgqjblrthxmahtqmwzjz`).

1. Two different request keys compete for the **last one-unit fictional item**. Expected: one `RESERVED`, one `OUT_OF_STOCK`, one order row, final on_hand=1/reserved=1.
2. Two clients send the **same request key and same item**. Expected: one `RESERVED`, one `REPLAYED`, matching order IDs, one order row, final on_hand=1/reserved=1.

Separate, freshly named **fictional variants** are inserted for these two tests. No existing fake inventory is reset or overwritten; no `public.jues_products` change, real orders, payments, customer data or store downtime. The script checks Jue's private project marker and denies non-private schema access before inserting anything.

**Proof rule:** both sessions must report different database backend PIDs, their `started_at`–`completed_at` intervals must **overlap**, and stock/order/code results must match the expectations. The script reports `INCONCLUSIVE` for sequential calls even when final inventory looks correct; reports `FAIL` for wrong effects. A no-network offline `--self-test` checks the verdict logic without connecting.

## On the Dell (Windows PowerShell)

1. In [GitHub: Jue's Baby Co. repository](https://github.com/juesbabyco/jues-baby-website), download/clone the main branch, then open PowerShell in its root. If Git is installed:
   ```powershell
   git clone https://github.com/juesbabyco/jues-baby-website.git
   cd jues-baby-website
   ```
   If already cloned, run `git pull --ff-only` after checking you have no uncommitted changes. Do not discard or overwrite other project work.
2. Check Python, install **psycopg 3** locally, and run the offline code-verdict test:
   ```powershell
   py --version
   py -m pip install "psycopg[binary]>=3,<4"
   py scripts/stage6b_concurrency_probe.py --self-test
   ```
   Expect four `PASS` checks. If these fail, STOP before entering any database credentials.
3. Open only the **Jue** Supabase dashboard: [Jue database project](https://supabase.com/dashboard/project/izeezajdiawiaweffbrh). Under **Connect** select a PostgreSQL **direct URI** (when IPv6 works) or the **Session pooler** (commonly helpful on IPv4 networks); consult [Supabase connection documentation](https://supabase.com/docs/guides/database/connecting-to-postgres). Never select MindCare or use a browser/anon API key as a PostgreSQL connection string. The connection URI contains a **secret database password**.
4. In the **same local PowerShell window**, read the URI without saving it to shell command history:
   ```powershell
   $secure = Read-Host "Paste Jue database URI (input hidden)" -AsSecureString
   $ptr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
   try {
     $env:JUES_STAGE6B_DATABASE_URL = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr)
   } finally {
     [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr)
   }
   ```
   **Do not paste the URI into ChatGPT**, GitHub, a screenshot or a shared log. Do not pass it on the `py` command line.
5. Run the private concurrent test and then clear the environment variable:
   ```powershell
   try {
     py scripts/stage6b_concurrency_probe.py --execute
   } finally {
     Remove-Item Env:JUES_STAGE6B_DATABASE_URL -ErrorAction SilentlyContinue
   }
   ```
   The process uses two worker threads plus independent PostgreSQL connections, an in-process start barrier and a test-only 1.8-second row-lock delay. It prints only fictional SKU/request keys, result codes, backend IDs, timestamps, and final inventory/order counts. **No credential is ever printed or saved by the script.** Only the authorized SQL administrator can run it; private functions remain unavailable to anonymous or ordinary signed-in visitors.

## How to report results back

Copy **only the redacted JSON output** after inspecting it, or send a screenshot with browser account names/credentials cropped. It should contain `"overall": "PASS"`, two PASS scenario blocks and distinct overlapping backend PIDs. The output has no connection URI or passwords by design.

- `PASS` means this **specific two-session single-SKU test** passed on a real database. It is not production order certification.
- `INCONCLUSIVE` means overlap, timing or connection evidence was missing. Do not say pass.
- `FAIL` means an explicit invariant failed. Stop, retain test evidence, do not enable ordering.
- `BLOCKED`/Python exit code 3 means connection, permission, marker or local dependency trouble. Do not relax private schema grants to get a pass.

The test persists **two new fictional inventory rows and two fictional order records** in the restricted lab when both expected operations work. It performs no deletion. Any costs from your database network plan remain subject to your existing Supabase account.

## Remaining even if both scenarios PASS

- Database tests for **multi-line opposite-order overlapping cart reservations** (not just single SKU), worker/deadlock timing and repeatability;
- Approve and implement real per-size inventory, customer actor authentication, rate limits, address/privacy/retention rules, delivery charges, order payment settlement and webhook proof;
- Automatic hold expiry cleanup and failure recovery (not enabled now);
- Resolve Auth leaked-password protection warning, review all RLS/privileges and conduct staged customer acceptance;
- Founder signoff before replacing original V8 demo or enabling real payment or checkout.

Source code: `scripts/stage6b_concurrency_probe.py`. Existing manual SQL alternative: `docs/STAGE6B_TWO_SESSION_RACE_PROTOCOL.md`. Never request the user's connection URI in chat.
