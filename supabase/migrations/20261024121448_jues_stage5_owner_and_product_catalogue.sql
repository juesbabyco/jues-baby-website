-- Jue's Baby Co. Stage 5A: owner allowlist + shared cloud product catalogue.
-- Deployed 2026-10-24 by Supabase migration 20261024121448, project izeezajdiawiaweffbrh ONLY.
-- No sample products, passwords, users or personal data were inserted.
BEGIN;

CREATE TABLE public.jues_store_owners (
 user_id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
 created_at timestamptz NOT NULL DEFAULT now()
);
COMMENT ON TABLE public.jues_store_owners IS 'Privileged owner allowlist. Provision through verified privileged SQL only; users cannot self-assign.';

CREATE TABLE public.jues_products (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
 name text NOT NULL CHECK (char_length(btrim(name)) BETWEEN 2 AND 100),
 description text NOT NULL DEFAULT '' CHECK (char_length(description) <= 1000),
 price_cents integer NOT NULL CHECK (price_cents BETWEEN 1 AND 10000000),
 age_group text NOT NULL CHECK (age_group IN ('Newborn','0–3m','3–6m','6–12m','12–24m','Gifts')),
 category text NOT NULL CHECK (category IN ('Everyday','Outfits','Sleepwear','Gifts')),
 sizes text[] NOT NULL CHECK (
    cardinality(sizes) BETWEEN 1 AND 5
    AND sizes <@ ARRAY['Newborn','0–3m','3–6m','6–12m','12–24m']::text[]
 ),
 stock_qty integer NOT NULL DEFAULT 0 CHECK (stock_qty BETWEEN 0 AND 9999),
 image_url text CHECK (image_url IS NULL OR (char_length(image_url) <= 1024 AND image_url ~ '^https://[^[:space:]]+$')),
 published boolean NOT NULL DEFAULT false,
 created_at timestamptz NOT NULL DEFAULT now(),
 updated_at timestamptz NOT NULL DEFAULT now()
);
COMMENT ON TABLE public.jues_products IS 'Shared Jue product catalogue. Empty at migration; draft by default. Public sees published items only. No real checkout or reservation system.';

CREATE INDEX jues_products_published_idx ON public.jues_products (published, updated_at DESC);
CREATE INDEX jues_products_owner_idx ON public.jues_products (created_at DESC);

ALTER TABLE public.jues_store_owners ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.jues_products ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON TABLE public.jues_store_owners FROM PUBLIC, anon, authenticated;
REVOKE ALL ON TABLE public.jues_products FROM PUBLIC, anon, authenticated;
GRANT SELECT ON TABLE public.jues_store_owners TO authenticated;
GRANT SELECT ON TABLE public.jues_products TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.jues_products TO authenticated;

CREATE POLICY jues_owner_read_self ON public.jues_store_owners
 FOR SELECT TO authenticated USING (user_id = (SELECT auth.uid()));

CREATE POLICY jues_product_public_read ON public.jues_products
 FOR SELECT TO anon, authenticated USING (published = true);

CREATE POLICY jues_product_owner_read ON public.jues_products
 FOR SELECT TO authenticated
 USING (EXISTS (
  SELECT 1 FROM public.jues_store_owners AS owner_membership
  WHERE owner_membership.user_id = (SELECT auth.uid())
 ));

CREATE POLICY jues_product_owner_create ON public.jues_products
 FOR INSERT TO authenticated
 WITH CHECK (EXISTS (
  SELECT 1 FROM public.jues_store_owners AS owner_membership
  WHERE owner_membership.user_id = (SELECT auth.uid())
 ));

CREATE POLICY jues_product_owner_update ON public.jues_products
 FOR UPDATE TO authenticated
 USING (EXISTS (
  SELECT 1 FROM public.jues_store_owners AS owner_membership
  WHERE owner_membership.user_id = (SELECT auth.uid())
 ))
 WITH CHECK (EXISTS (
  SELECT 1 FROM public.jues_store_owners AS owner_membership
  WHERE owner_membership.user_id = (SELECT auth.uid())
 ));

CREATE POLICY jues_product_owner_delete ON public.jues_products
 FOR DELETE TO authenticated
 USING (EXISTS (
  SELECT 1 FROM public.jues_store_owners AS owner_membership
  WHERE owner_membership.user_id = (SELECT auth.uid())
 ));

COMMIT;