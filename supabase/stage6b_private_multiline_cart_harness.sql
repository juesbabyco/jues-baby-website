-- Stage 6B EXTENSION: private fictional multi-item atomic reservation lab.
-- Apply ONLY to dedicated Jue Supabase izeezajdiawiaweffbrh.
-- No public schemas, customer orders/payments, storage or real product stock touched.
CREATE TABLE jues_stage6b.fixture_cart_orders (
 id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 request_key text NOT NULL UNIQUE,
 fingerprint text NOT NULL,
 state text NOT NULL DEFAULT 'RESERVED' CHECK (state='RESERVED'),
 subtotal_cents bigint NOT NULL CHECK (subtotal_cents>0),
 created_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE jues_stage6b.fixture_cart_items (
 cart_order_id bigint NOT NULL REFERENCES jues_stage6b.fixture_cart_orders(id),
 sku text NOT NULL REFERENCES jues_stage6b.fixture_variants(sku),
 qty integer NOT NULL CHECK (qty BETWEEN 1 AND 10),
 unit_price_cents integer NOT NULL CHECK (unit_price_cents>0),
 PRIMARY KEY(cart_order_id,sku)
);
ALTER TABLE jues_stage6b.fixture_cart_orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE jues_stage6b.fixture_cart_items ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON TABLE jues_stage6b.fixture_cart_orders,jues_stage6b.fixture_cart_items FROM PUBLIC,anon,authenticated;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA jues_stage6b FROM PUBLIC,anon,authenticated;

CREATE FUNCTION jues_stage6b.reserve_cart_fixture(
 p_request_key text, p_skus text[], p_qtys integer[]
) RETURNS TABLE(accepted boolean,result_code text,fixture_cart_order_id bigint,subtotal_cents bigint)
LANGUAGE plpgsql SECURITY INVOKER
SET search_path=pg_catalog,jues_stage6b
AS $$
DECLARE
 prior jues_stage6b.fixture_cart_orders%ROWTYPE;
 v jues_stage6b.fixture_variants%ROWTYPE;
 item record;
 fp text;
 total bigint:=0;
 new_id bigint;
 n int;
 distinct_n int;
BEGIN
 IF p_request_key IS NULL OR p_request_key !~ '^S6B-CART-[A-Za-z0-9_-]{12,70}$'
   OR p_skus IS NULL OR p_qtys IS NULL
   OR coalesce(array_length(p_skus,1),0) NOT BETWEEN 1 AND 5
   OR coalesce(array_length(p_qtys,1),0)<>array_length(p_skus,1)
   OR array_lower(p_skus,1)<>1 OR array_lower(p_qtys,1)<>1
 THEN
   RETURN QUERY SELECT false,'INVALID_CART'::text,NULL::bigint,NULL::bigint;RETURN;
 END IF;

 FOR item IN SELECT x.sku,x.qty FROM unnest(p_skus,p_qtys) AS x(sku,qty) LOOP
   IF item.sku IS NULL OR item.sku !~ '^S6B-[A-Z0-9_-]{3,50}$'
      OR item.qty IS NULL OR item.qty NOT BETWEEN 1 AND 10
   THEN RETURN QUERY SELECT false,'INVALID_LINE'::text,NULL::bigint,NULL::bigint;RETURN;
   END IF;
 END LOOP;
 SELECT count(*),count(DISTINCT x.sku) INTO n,distinct_n
 FROM unnest(p_skus,p_qtys) AS x(sku,qty);
 IF distinct_n<>n THEN
   RETURN QUERY SELECT false,'DUPLICATE_VARIANT'::text,NULL::bigint,NULL::bigint;RETURN;
 END IF;

 -- Canonical sorted item/quantity representation is unchanged by line reordering.
 SELECT jsonb_agg(jsonb_build_object('sku',x.sku,'qty',x.qty) ORDER BY x.sku)::text
 INTO fp FROM unnest(p_skus,p_qtys) AS x(sku,qty);

 PERFORM pg_advisory_xact_lock(hashtextextended('jues-stage6b-cart:'||p_request_key,0));
 SELECT * INTO prior FROM jues_stage6b.fixture_cart_orders WHERE request_key=p_request_key;
 IF FOUND THEN
  RETURN QUERY SELECT
    prior.fingerprint=fp,
    CASE WHEN prior.fingerprint=fp THEN 'REPLAYED' ELSE 'IDEMPOTENCY_CONFLICT' END::text,
    prior.id,prior.subtotal_cents;
  RETURN;
 END IF;

 -- Lock each stock row in stable SKU order. Validate *every* item
 -- without changing reserved counts. Any failure means zero writes.
 FOR item IN SELECT x.sku,x.qty FROM unnest(p_skus,p_qtys) AS x(sku,qty) ORDER BY x.sku LOOP
   SELECT * INTO v FROM jues_stage6b.fixture_variants f WHERE f.sku=item.sku FOR UPDATE;
   IF NOT FOUND THEN
     RETURN QUERY SELECT false,'UNKNOWN_FIXTURE'::text,NULL::bigint,NULL::bigint;RETURN;
   END IF;
   IF v.on_hand-v.reserved<item.qty THEN
     RETURN QUERY SELECT false,'OUT_OF_STOCK'::text,NULL::bigint,NULL::bigint;RETURN;
   END IF;
   total:=total+(v.price_cents::bigint*item.qty);
 END LOOP;

 INSERT INTO jues_stage6b.fixture_cart_orders(request_key,fingerprint,subtotal_cents)
 VALUES(p_request_key,fp,total)
 RETURNING id INTO new_id;

 FOR item IN SELECT x.sku,x.qty FROM unnest(p_skus,p_qtys) AS x(sku,qty) ORDER BY x.sku LOOP
   UPDATE jues_stage6b.fixture_variants f
   SET reserved=f.reserved+item.qty,modified_at=now()
   WHERE f.sku=item.sku
   RETURNING f.* INTO v;
   INSERT INTO jues_stage6b.fixture_cart_items(cart_order_id,sku,qty,unit_price_cents)
   VALUES(new_id,item.sku,item.qty,v.price_cents);
 END LOOP;
 RETURN QUERY SELECT true,'RESERVED'::text,new_id,total;
END;
$$;
REVOKE ALL ON FUNCTION jues_stage6b.reserve_cart_fixture(text,text[],integer[])
FROM PUBLIC,anon,authenticated;
COMMENT ON FUNCTION jues_stage6b.reserve_cart_fixture(text,text[],integer[])
IS 'PRIVATE Stage 6B fictitious multi-item atomic hold. Single DB transaction only. NOT real checkout.';
