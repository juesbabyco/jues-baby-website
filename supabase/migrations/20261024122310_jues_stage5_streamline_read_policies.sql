-- Applied to Jue project izeezajdiawiaweffbrh on 2026-10-24.
-- Optimizes published + owner SELECT permissions by splitting role-specific policies.
BEGIN;
DROP POLICY IF EXISTS jues_product_public_read ON public.jues_products;
DROP POLICY IF EXISTS jues_product_owner_read ON public.jues_products;
CREATE POLICY jues_product_public_read ON public.jues_products
FOR SELECT TO anon USING (published = true);
CREATE POLICY jues_product_authenticated_read ON public.jues_products
FOR SELECT TO authenticated USING (
 published = true OR EXISTS (
  SELECT 1 FROM public.jues_store_owners AS owner_membership
  WHERE owner_membership.user_id = (SELECT auth.uid())
 )
);
COMMIT;
