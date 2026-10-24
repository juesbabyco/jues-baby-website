-- Jue's Baby Co. Stage 5C repair deployed to Jue Supabase project only.
-- Supabase migration 20261024195535. Split Storage SELECT policies by role:
-- public anonymous Storage GET previously errored when the combined SELECT
-- policy referenced private public.jues_store_owners without anon privileges.
-- NEVER grant anon SELECT on jues_store_owners to work around that error.
BEGIN;
DROP POLICY IF EXISTS jues_storage_owner_or_published_read ON storage.objects;
CREATE POLICY jues_storage_owner_read
ON storage.objects FOR SELECT TO authenticated
USING (
 bucket_id='jues-product-photos'
 AND EXISTS(SELECT 1 FROM public.jues_store_owners o
            WHERE o.user_id=(SELECT auth.uid()))
);
CREATE POLICY jues_storage_published_photo_read
ON storage.objects FOR SELECT TO anon, authenticated
USING (
 bucket_id='jues-product-photos'
 AND storage.allow_any_operation(ARRAY['object.get_authenticated','object.get_authenticated_info'])
 AND EXISTS(
  SELECT 1 FROM public.jues_products p
  WHERE p.published=true AND p.image_path=storage.objects.name
 )
);
COMMIT;
