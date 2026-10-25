# Architecture and Product Decisions — Jue's Baby Co.

| ID | Date | Decision | Rationale / effect |
|---|---|---|---|
| JBC-D001 | 2026-10-24 | Separate Jue's infrastructure from MindCare | Prevent cross-project authority, billing, data, and deployment contamination. |
| JBC-D002 | 2026-10-24 | GitHub docs are master development book | Durable versioned, reviewable memory survives separate chats and context limits. |
| JBC-D003 | 2026-10-24 | Approved identity: cream/chocolate and 'For every little you.' | Preserve established design while extending device support. |
| JBC-D004 | 2026-10-24 | Live GitHub Pages demo and `owner-demo.html` are PUBLIC demonstrations | No private owner account, orders or payment claims without backend. |
| JBC-D005 | 2026-10-24 | Supabase is chosen only from the independently connected Juesbabyco account | Dedicated project `izeezajdiawiaweffbrh` created after owner cost approval; Juesbabyco org only. |
| JBC-D006 | 2026-10-24 | Evidence-based stage closures | User reports are valid UX acceptance evidence but not independent production/security proof. |
| JBC-D007 | 2026-10-24 | No customer PII in version-control project memory | GitHub repository is publicly accessible; store only non-sensitive decisions and evidence. |

| JBC-D008 | 2026-10-24 | Internal project records use dedicated private schema `jues_internal` | Neither anonymous nor signed-in frontend roles get access to the governance registry. |
| JBC-D009 | 2026-10-24 | Historical blocked events remain recorded when unblocked | Audit trail preserves actual sequence rather than retroactively rewriting failed attempts. |

| JBC-D010 | 2026-10-24 | Maintain `index.html` and local demo unchanged during Stage 5 | Prevent disruption of the user-approved working storefront before cloud acceptance. |
| JBC-D011 | 2026-10-24 | Introduce `owner-cloud.html` and `cloud-preview.html` for staging | Distinguish centrally stored cloud products from browser-local demo data. |
| JBC-D012 | 2026-10-24 | Owner login must match explicitly privileged `jues_store_owners` Auth UUID | No self-claim by normal signup, and all product writes controlled by database RLS. |
| JBC-D013 | 2026-10-24 | Cloud catalogue defaults to zero records and draft-only publishing | No AI-generated placeholder photo or demo item is implicitly live stock; owner must approve public publishing. |
| JBC-D014 | 2026-10-24 | Public client uses publishable key and pinned Supabase JS 2.118.0 | No service-role/secret key reaches public GitHub Pages. Actual browser functional validation still required. |

| JBC-D011 | 2026-10-25 | Order stock must be per sellable size/variant; no purchase against product-level `stock_qty` demo field | Existing product stores one stock number despite multiple sizes. Server should hold/reserve per size with atomic concurrency tests before enabling orders. |
| JBC-D012 | 2026-10-25 | Idempotent transactional order attempt and immutable price snapshot | Prevent double-tap/retry duplication, changed cart under same key, partial multiline orders, oversell and price tampering. Transaction must lock affected variants and commit effects together. |
| JBC-D013 | 2026-10-25 | Stage 6A begins as offline fictional simulator, not a customer checkout or real Supabase migration | Do not collect PII, trust browser authority or activate money flows before order backend/RLS/concurrency, consumer policies and founder review. |

## Pending decisions
- Who may be store owner/admin? Invite/provision explicitly after backend exists; do not use an open signup-as-admin flow.
- Public product publishing workflow and inventory validation.
- Delivery fee rules, payment provider choice and cost.
- Real order fulfilment and customer privacy/retention policy.
