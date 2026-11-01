-- Jue Baby Co. private Stage 6B: transactional state machine and per-item stock movement audit.
-- This is a fictional lab, NOT production checkout. Run only in dedicated Jue project izeezajdiawiaweffbrh.
-- Source-controlled; never run against public real product records.
ALTER TABLE jues_stage6b.fixture_cart_orders
DROP CONSTRAINT fixture_cart_orders_state_check;
ALTER TABLE jues_stage6b.fixture_cart_orders
ADD CONSTRAINT fixture_cart_orders_state_check
CHECK (state IN ('RESERVED','CONFIRMED','CANCELLED','EXPIRED','FULFILLED'));
ALTER TABLE jues_stage6b.fixture_cart_orders
ADD COLUMN expires_at timestamptz NOT NULL DEFAULT (clock_timestamp() + interval '15 minutes'),
ADD COLUMN updated_at timestamptz NOT NULL DEFAULT now(),
ADD COLUMN payment_state text NOT NULL DEFAULT 'NOT_INTEGRATED'
CHECK (payment_state = 'NOT_INTEGRATED');

CREATE TABLE jues_stage6b.fixture_cart_movements (
 id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 cart_order_id bigint NOT NULL REFERENCES jues_stage6b.fixture_cart_orders(id),
 sku text NOT NULL REFERENCES jues_stage6b.fixture_variants(sku),
 effect text NOT NULL CHECK (effect IN ('HOLD','RELEASE','CONSUME')),
 delta_on_hand integer NOT NULL,
 delta_reserved integer NOT NULL,
 recorded_at timestamptz NOT NULL DEFAULT clock_timestamp(),
 CONSTRAINT one_effect_per_line UNIQUE (cart_order_id,sku,effect),
 CONSTRAINT movement_delta_matches_effect CHECK (
   (effect='HOLD' AND delta_on_hand=0 AND delta_reserved>0)
   OR (effect='RELEASE' AND delta_on_hand=0 AND delta_reserved<0)
   OR (effect='CONSUME' AND delta_on_hand=delta_reserved AND delta_on_hand<0)
 )
);
ALTER TABLE jues_stage6b.fixture_cart_movements ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON TABLE jues_stage6b.fixture_cart_movements FROM PUBLIC,anon,authenticated;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA jues_stage6b FROM PUBLIC,anon,authenticated;

-- Capture the single previously reserved fake cart's initial hold as an audited historical backfill.
INSERT INTO jues_stage6b.fixture_cart_movements(cart_order_id,sku,effect,delta_on_hand,delta_reserved)
SELECT i.cart_order_id,i.sku,'HOLD',0,i.qty
FROM jues_stage6b.fixture_cart_items i
JOIN jues_stage6b.fixture_cart_orders o ON o.id=i.cart_order_id
WHERE o.state='RESERVED'
ON CONFLICT(cart_order_id,sku,effect) DO NOTHING;

-- Reuse the existing validated private cart-reservation logic; add HOLD audit rows in the same transaction.
CREATE OR REPLACE FUNCTION jues_stage6b.reserve_cart_fixture(
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
   INSERT INTO jues_stage6b.fixture_cart_movements(cart_order_id,sku,effect,delta_on_hand,delta_reserved)
   VALUES(new_id,item.sku,'HOLD',0,item.qty);
 END LOOP;
 RETURN QUERY SELECT true,'RESERVED'::text,new_id,total;
END;
$$;

REVOKE ALL ON FUNCTION jues_stage6b.reserve_cart_fixture(text,text[],integer[])
 FROM PUBLIC,anon,authenticated;

-- Transition order lock -> variant locks in sorted SKU order. No direct public client can execute this.
CREATE FUNCTION jues_stage6b.transition_cart_fixture(p_cart_order_id bigint,p_action text)
RETURNS TABLE(accepted boolean,result_code text,resulting_state text,changed_lines integer)
LANGUAGE plpgsql SECURITY INVOKER
SET search_path=pg_catalog,jues_stage6b
AS $$
DECLARE
 o jues_stage6b.fixture_cart_orders%ROWTYPE;
 i record;
 v jues_stage6b.fixture_variants%ROWTYPE;
 next_state text;
 movement text;
 count_lines integer:=0;
BEGIN
 IF p_cart_order_id IS NULL OR p_cart_order_id<1 OR p_action IS NULL OR p_action NOT IN ('CONFIRM','CANCEL','EXPIRE','FULFIL') THEN
  RETURN QUERY SELECT false,'INVALID_ACTION'::text,NULL::text,0; RETURN;
 END IF;
 SELECT * INTO o FROM jues_stage6b.fixture_cart_orders co WHERE co.id=p_cart_order_id FOR UPDATE;
 IF NOT FOUND THEN
  RETURN QUERY SELECT false,'UNKNOWN_FIXTURE_ORDER'::text,NULL::text,0; RETURN;
 END IF;

 IF o.state IN ('CANCELLED','EXPIRED','FULFILLED') THEN
  RETURN QUERY SELECT false,'TERMINAL_STATE'::text,o.state,0;RETURN;
 END IF;

 IF p_action='CONFIRM' AND o.state='RESERVED' THEN
  IF clock_timestamp()>=o.expires_at THEN
   RETURN QUERY SELECT false,'RESERVATION_EXPIRED'::text,o.state,0; RETURN;
  END IF;
  next_state:='CONFIRMED';
 ELSIF p_action='CANCEL' AND o.state IN ('RESERVED','CONFIRMED') THEN
  next_state:='CANCELLED';movement:='RELEASE';
 ELSIF p_action='EXPIRE' AND o.state='RESERVED' THEN
  IF clock_timestamp()<o.expires_at THEN
   RETURN QUERY SELECT false,'TOO_EARLY_TO_EXPIRE'::text,o.state,0;RETURN;
  END IF;
  next_state:='EXPIRED';movement:='RELEASE';
 ELSIF p_action='FULFIL' AND o.state='CONFIRMED' THEN
  next_state:='FULFILLED';movement:='CONSUME';
 ELSE
  RETURN QUERY SELECT false,'INVALID_TRANSITION'::text,o.state,0;RETURN;
 END IF;

 IF movement IS NOT NULL THEN
  FOR i IN SELECT sku,qty FROM jues_stage6b.fixture_cart_items WHERE cart_order_id=o.id ORDER BY sku LOOP
   SELECT * INTO v FROM jues_stage6b.fixture_variants f WHERE f.sku=i.sku FOR UPDATE;
   IF NOT FOUND OR v.reserved<i.qty OR (movement='CONSUME' AND v.on_hand<i.qty) THEN
     RAISE EXCEPTION 'Private fixture stock invariant failed on cart %',o.id;
   END IF;
   UPDATE jues_stage6b.fixture_variants f
   SET reserved=f.reserved-i.qty,
       on_hand=CASE WHEN movement='CONSUME' THEN f.on_hand-i.qty ELSE f.on_hand END,
       modified_at=now()
   WHERE f.sku=i.sku;
   INSERT INTO jues_stage6b.fixture_cart_movements(cart_order_id,sku,effect,delta_on_hand,delta_reserved)
   VALUES(o.id,i.sku,movement,
          CASE WHEN movement='CONSUME' THEN -i.qty ELSE 0 END,-i.qty);
   count_lines:=count_lines+1;
  END LOOP;
 END IF;

 UPDATE jues_stage6b.fixture_cart_orders
 SET state=next_state,updated_at=now() WHERE id=o.id;
 RETURN QUERY SELECT true,next_state::text,next_state,count_lines;
END;
$$;
REVOKE ALL ON FUNCTION jues_stage6b.transition_cart_fixture(bigint,text)
 FROM PUBLIC,anon,authenticated;
COMMENT ON FUNCTION jues_stage6b.transition_cart_fixture(bigint,text)
IS 'PRIVATE fictional Stage 6B transactional terminal-state and stock movement exercise, not customer-order API.';
