# Jue's Baby Co. — Immutable-in-principle Evidence Log
This log records observations, not inferred functionality. Append new rows. Date: 2026-10-24 unless stated otherwise.

| Evidence ID | Source | Outcome | Meaning / limitation |
|---|---|---|---|
| JBC-E001 | User approval in design sessions | V5 visual baseline accepted | Brand direction approved, not production deployment evidence. |
| JBC-E002 | User iPhone screenshots/feedback | V6.3 embedded images display | Local preview issue solved for images. |
| JBC-E003 | User tested static iPhone preview | 'View sizes & details' did not react | File preview not a valid full JavaScript browser validation. |
| JBC-E004 | GitHub API commit `2870f1d6f67cbe99f8eb63e6d5db789aca93761b` | V7 `index.html` uploaded; subsequent fetch confirmed 807303 chars and 17 embedded image tokens | Code committed, not yet proof of runtime. |
| JBC-E005 | GitHub API commit `e1c2b2ad793bf5e487f55a7ee532e5535b5c6d56` | Responsive CSS in V8 | Code verified for desktop 4-column grid and split hero. |
| JBC-E006 | User message 'done working' | V8 mobile/desktop responsive layout accepted | User-reported functional check; detailed viewport captures not retained here. |
| JBC-E007 | User checkout screenshot | 'Demo order created', sample `JUE-DEMO-965394` | Demo UI completed; not proof of payment, backend persistence or actual order. |
| JBC-E008 | User confirmed checkout requested name and phone | Form interaction exists | Not proof of strict validation on all edge cases. |
| JBC-E009 | GitHub commits `da05e9a391a9d2c1d6715166ecc8b77771ade991` and `9f202c145eb07611c9cdfe0c41ad9c8f33e516e9` | Owner demo created and local catalogue bridge linked | JavaScript syntax checked for both files; no server sync. |
| JBC-E010 | User message 'done its working' after price-change test | Product price edited from $18 to $15 and reflected on same-browser storefront | User-tested browser-local bridge; not cross-device sync. |
| JBC-E011 | Supabase Juesbabyco organization listing | Org `cgqjblrthxmahtqmwzjz`, 0 projects | Separate Supabase connected; do not conflate with MindCare. |
| JBC-E012 | Supabase get_cost and create_project attempt | Cost quoted $0/month; create attempt blocked by requirement for explicit confirmation ID | No evidence a Supabase project exists or project registry is deployed. |

## Evidence handling
Write only non-sensitive observations here. Before announcing a stage complete, attach a reproducible test method plus commit/Supabase reference where applicable. Never replace lack of evidence with optimistic inferences.
