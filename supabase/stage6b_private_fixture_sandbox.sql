-- Jue's Baby Co. Stage 6B — PRIVATE fictional order-concurrency test fixtures.
-- This file is a source-controlled deployment companion, not a public ordering migration.
-- No changes to public.jues_products, owner approvals, Storage, index.html or MindCare.
-- Apply only to dedicated Jue Supabase izeezajdiawiaweffbrh and verify organization.
-- Run this through Supabase apply_migration with name jues_stage6b_private_fixture_reservation_sandbox.
CREATE SCHEMA IF NOT EXISTS jues_stage6b;
REVOKE ALL ON SCHEMA jues_stage6b FROM PUBLIC, anon, authenticated;

CREATE TABLE IF NOT EXISTS jues_stage6b.fixture_variants (
 sku text PRIMARY KEY CHECK (sku ~ '^S6B-[A-Z0-9_-]{3,50}$'),
 size_label text NOT NULL,
 on_hand integer NOT NULL CHECK (on_hand >= 0),
 reserved integer NOT NULL DEFAULT 0 CHECK (reserved >= 0),
 price_cents integer NOT NULL CHECK (price_cents > 0),
 modified_at timestamptz NOT NULL DEFAULT now(),
 CONSTRAINT fixture_reserved_not_more_than_onhand CHECK (reserved <= on_hand)
);
CREATE TABLE IF NOT EXISTS jues_stage6b.fixture_orders (
 id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 request_key text NOT NULL UNIQUE,
 sku text NOT NULL REFERENCES jues_stage6b.fixture_variants(sku),
 qty integer NOT NULL CHECK (qty BETWEEN 1 AND 10),
 unit_price_snapshot_cents integer NOT NULL CHECK (unit_price_snapshot_cents > 0),
 state text NOT NULL DEFAULT 'RESERVED' CHECK (state IN ('RESERVED','CANCELLED','FULFILLED')),
 created_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE jues_stage6b.fixture_variants ENABLE ROW LEVEL SECURITY;
ALTER TABLE jues_stage6b.fixture_orders ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON ALL TABLES IN SCHEMA jues_stage6b FROM PUBLIC, anon, authenticated;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA jues_stage6b FROM PUBLIC, anon, authenticated;

-- This is a tiny one-variant transaction harness, NOT a production checkout.
-- It serializes identical idempotency keys and locks the stock row, allowing
-- two independent SQL sessions to race for the final fictional item.
CREATE OR REPLACE FUNCTION jues_stage6b.reserve_fixture(
 p_request_key text,
 p_sku text,
 p_qty integer,
 p_test_lock_delay_ms integer DEFAULT 0
) RETURNS TABLE(
 accepted boolean,
 result_code text,
 fixture_order_id bigint,
 backend_pid integer,
 started_at timestamptz,
 completed_at timestamptz,
 resulting_on_hand integer,
 resulting_reserved integer
) LANGUAGE plpgsql SECURITY INVOKER
SET search_path = pg_catalog, jues_stage6b
AS $$
DECLARE
 t0 timestamptz := clock_timestamp();
 prior jues_stage6b.fixture_orders%ROWTYPE;
 variant jues_stage6b.fixture_variants%ROWTYPE;
 oid bigint;
BEGIN
 IF p_request_key IS NULL OR p_request_key !~ '^S6B-[A-Za-z0-9_-]{12,80}$'
    OR p_sku IS NULL OR p_sku !~ '^S6B-[A-Z0-9_-]{3,50}$'
    OR p_qty IS NULL OR p_qty NOT BETWEEN 1 AND 10
    OR p_test_lock_delay_ms IS NULL OR p_test_lock_delay_ms NOT BETWEEN 0 AND 2500
 THEN
  RETURN QUERY SELECT false,'INVALID_TEST_INPUT'::text,NULL::bigint,pg_backend_pid(),t0,clock_timestamp(),NULL::integer,NULL::integer;
  RETURN;
 END IF;

 -- Lock the logical checkout attempt against same-key duplicate requests.
 PERFORM pg_advisory_xact_lock(hashtextextended('jues-stage6b:'||p_request_key,0));

 SELECT * INTO prior FROM jues_stage6b.fixture_orders WHERE request_key=p_request_key;
 IF FOUND THEN
  SELECT * INTO variant FROM jues_stage6b.fixture_variants WHERE sku=prior.sku;
  RETURN QUERY SELECT
    (prior.sku=p_sku AND prior.qty=p_qty),
    (CASE WHEN prior.sku=p_sku AND prior.qty=p_qty THEN 'REPLAYED' ELSE 'IDEMPOTENCY_CONFLICT' END)::text,
    prior.id, pg_backend_pid(),t0,clock_timestamp(),variant.on_hand,variant.reserved;
  RETURN;
 END IF;

 -- FOR UPDATE ensures a second checkout session must wait on the stock row.
 SELECT * INTO variant FROM jues_stage6b.fixture_variants WHERE sku=p_sku FOR UPDATE;
 IF NOT FOUND THEN
  RETURN QUERY SELECT false,'UNKNOWN_FIXTURE'::text,NULL::bigint,pg_backend_pid(),t0,clock_timestamp(),NULL::integer,NULL::integer;
  RETURN;
 END IF;

 -- Optional test-only lock delay makes independent concurrent sessions measurable.
 IF p_test_lock_delay_ms>0 THEN
   PERFORM pg_sleep(p_test_lock_delay_ms::numeric/1000);
 END IF;

 IF variant.on_hand-variant.reserved < p_qty THEN
  RETURN QUERY SELECT false,'OUT_OF_STOCK'::text,NULL::bigint,pg_backend_pid(),t0,clock_timestamp(),variant.on_hand,variant.reserved;
  RETURN;
 END IF;

 UPDATE jues_stage6b.fixture_variants AS f
 SET reserved=f.reserved+p_qty,modified_at=now()
 WHERE f.sku=p_sku
 RETURNING f.* INTO variant;

 INSERT INTO jues_stage6b.fixture_orders(request_key,sku,qty,unit_price_snapshot_cents)
 VALUES(p_request_key,p_sku,p_qty,variant.price_cents)
 RETURNING id INTO oid;

 RETURN QUERY SELECT true,'RESERVED'::text,oid,pg_backend_pid(),t0,clock_timestamp(),variant.on_hand,variant.reserved;
END;
$$;
REVOKE ALL ON FUNCTION jues_stage6b.reserve_fixture(text,text,integer,integer)
  FROM PUBLIC, anon, authenticated;

COMMENT ON SCHEMA jues_stage6b IS
'Jue-only PRIVATE fictional test for Stage 6B inventory row-lock and idempotency evidence. NOT the customer-order schema.';
COMMENT ON FUNCTION jues_stage6b.reserve_fixture(text,text,integer,integer) IS
'PRIVATE invoker-only lab function for independent-session race tests, not public RPC or real orders.';
