-- Applied 2026-10-24 to Juesbabyco project izeezajdiawiaweffbrh
-- GitHub records a copy of the original deployment SQL, never MindCare.
-- Jue's Baby Co. registry foundation | APPLIED
-- Only run against project under Juesbabyco org cgqjblrthxmahtqmwzjz.
-- This schema is private, intentionally NOT exposed to Supabase Data API.
-- The GitHub PROJECT_BOOK.md remains canonical; this is structured operational evidence.
BEGIN;

CREATE SCHEMA IF NOT EXISTS jues_internal;
REVOKE ALL ON SCHEMA jues_internal FROM PUBLIC;
REVOKE ALL ON SCHEMA jues_internal FROM anon, authenticated;

CREATE TABLE IF NOT EXISTS jues_internal.project_registry (
  project_key text PRIMARY KEY CHECK (project_key = 'JUES_BABY_CO'),
  display_name text NOT NULL,
  github_repo text NOT NULL,
  current_stage text NOT NULL,
  state_label text NOT NULL,
  current_summary text NOT NULL,
  last_evidence_on date NOT NULL,
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS jues_internal.stage_events (
  id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  project_key text NOT NULL REFERENCES jues_internal.project_registry(project_key),
  event_key text NOT NULL UNIQUE,
  stage text NOT NULL,
  evidence_type text NOT NULL CHECK (evidence_type IN (
    'DESIGNED','BUILT','SYNTAX_VERIFIED','USER_TESTED','PRODUCTION_VERIFIED','BLOCKED','NOT_STARTED'
  )),
  summary text NOT NULL CHECK (length(summary) BETWEEN 1 AND 4000),
  source_reference text NOT NULL DEFAULT '',
  recorded_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS jues_stage_events_project_time_idx
  ON jues_internal.stage_events (project_key, recorded_at DESC, id DESC);

ALTER TABLE jues_internal.project_registry ENABLE ROW LEVEL SECURITY;
ALTER TABLE jues_internal.stage_events ENABLE ROW LEVEL SECURITY;
-- This schema is private and no RLS policies grant public access.
REVOKE ALL ON ALL TABLES IN SCHEMA jues_internal FROM PUBLIC, anon, authenticated;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA jues_internal FROM PUBLIC, anon, authenticated;

INSERT INTO jues_internal.project_registry
  (project_key, display_name, github_repo, current_stage, state_label, current_summary, last_evidence_on)
VALUES ('JUES_BABY_CO', 'Jue''s Baby Co.', 'juesbabyco/jues-baby-website',
'S4_GOVERNANCE', 'GITHUB_MEMORY_COMMITTED_SUPABASE_PENDING',
'Live static demo and same-browser owner demo user-tested. Cloud owner auth, orders, payments and cross-device sync NOT implemented.', '2026-10-24')
ON CONFLICT (project_key) DO NOTHING;

INSERT INTO jues_internal.stage_events
  (project_key,event_key,stage,evidence_type,summary,source_reference)
VALUES
('JUES_BABY_CO','JBC-E006','S3a','USER_TESTED','Owner reported responsive V8 storefront working on mobile and desktop.','docs/EVIDENCE_LOG.md#jbc-e006'),
('JUES_BABY_CO','JBC-E007','S2','USER_TESTED','Owner screenshot showed demo checkout confirmation, not a real order.','docs/EVIDENCE_LOG.md#jbc-e007'),
('JUES_BABY_CO','JBC-E010','S3b','USER_TESTED','Owner reported same-browser dashboard price edit reflected in storefront.','docs/EVIDENCE_LOG.md#jbc-e010'),
('JUES_BABY_CO','JBC-E012','S4','BLOCKED','Supabase registry not yet created. Separate Jue project creation requires explicit cost confirmation.','docs/EVIDENCE_LOG.md#jbc-e012')
ON CONFLICT (event_key) DO NOTHING;
COMMIT;
