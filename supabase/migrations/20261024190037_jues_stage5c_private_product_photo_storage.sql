-- Jue's Baby Co. Stage 5C. Private product JPEGs: only approved owner uploads.
-- Public read is limited to photos attached to PUBLISHED catalogue rows.
-- No production checkout or inventory migration.
BEGIN;
INSERT INTO storage.buckets(id,name,public,file_size_limit,allowed_mime_types)
VALUES ('jues-product-photos','jues-product-photos',false,2097152,ARRAY['image/jpeg']::text[])
ON CONFLICT(id) DO NOTHING;

ALTER TABLE public.jues_products
ADD COLUMN IF NOT EXISTS image_path text;

ALTER TABLE public.jues_products
ADD CONSTRAINT jues_products_image_path_scope
CHECK (
 image_path IS NULL OR (
 image_path ~ '^products/[0-9a-f-]{36}/[0-9a-f-]{36}\.jpg$'
 AND split_part(image_path,'/',2)=id::text
 )
);

CREATE POLICY jues_storage_owner_upload ON storage.objects
FOR INSERT TO authenticated WITH CHECK (
 bucket_id='jues-product-photos'
 AND name ~ '^products/[0-9a-f-]{36}/[0-9a-f-]{36}\.jpg$'
 AND EXISTS(
  SELECT 1 FROM public.jues_store_owners o
  WHERE o.user_id=(SELECT auth.uid())
 )
 AND EXISTS(
  SELECT 1 FROM public.jues_products p
  WHERE p.id::text=split_part(storage.objects.name,'/',2)
 )
);

CREATE POLICY jues_storage_owner_or_published_read ON storage.objects
FOR SELECT TO anon,authenticated USING (
 bucket_id='jues-product-photos'
 AND (
  EXISTS(SELECT 1 FROM public.jues_store_owners o
         WHERE o.user_id=(SELECT auth.uid()))
  OR (
   storage.allow_any_operation(ARRAY['object.get_authenticated','object.get_authenticated_info'])
   AND EXISTS(
    SELECT 1 FROM public.jues_products p
    WHERE p.published=true AND p.image_path=storage.objects.name
   )
  )
 )
);

CREATE POLICY jues_storage_owner_delete_unreferenced ON storage.objects
FOR DELETE TO authenticated USING (
 bucket_id='jues-product-photos'
 AND EXISTS(SELECT 1 FROM public.jues_store_owners o
            WHERE o.user_id=(SELECT auth.uid()))
 AND NOT EXISTS(SELECT 1 FROM public.jues_products p WHERE p.image_path=storage.objects.name)
);
COMMIT;