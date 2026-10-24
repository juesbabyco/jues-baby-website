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

## Pending decisions
- Who may be store owner/admin? Invite/provision explicitly after backend exists; do not use an open signup-as-admin flow.
- Public product publishing workflow and inventory validation.
- Delivery fee rules, payment provider choice and cost.
- Real order fulfilment and customer privacy/retention policy.
