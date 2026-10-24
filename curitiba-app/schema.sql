-- Curitiba field app: run in a NEW Supabase project only.
create table public.curitiba_members(user_id uuid primary key references auth.users(id) on delete cascade);
create table public.curitiba_suppliers(
 id uuid primary key default gen_random_uuid(), name text not null, contact text,phone text,city text,
 category text,priority text,moq text,lead text,payment text,incoterm text,notes text,
 created_at timestamptz not null default now()
);
create table public.curitiba_products(
 id uuid primary key default gen_random_uuid(),
 supplier_id uuid not null references public.curitiba_suppliers(id) on delete cascade,
 name text not null,category text,price numeric,moq numeric,dimensions text,material text,interest text,notes text,
 created_at timestamptz not null default now()
);
create table public.curitiba_photos(
 id uuid primary key default gen_random_uuid(),
 product_id uuid not null references public.curitiba_products(id) on delete cascade,
 storage_path text not null,created_at timestamptz not null default now()
);
alter table public.curitiba_members enable row level security;
alter table public.curitiba_suppliers enable row level security;
alter table public.curitiba_products enable row level security;
alter table public.curitiba_photos enable row level security;
create policy "Members see self" on public.curitiba_members for select to authenticated using (user_id=(select auth.uid()));
create policy "Members read suppliers" on public.curitiba_suppliers for select to authenticated using (exists(select 1 from public.curitiba_members m where m.user_id=(select auth.uid())));
create policy "Members write suppliers" on public.curitiba_suppliers for all to authenticated using (exists(select 1 from public.curitiba_members m where m.user_id=(select auth.uid()))) with check (exists(select 1 from public.curitiba_members m where m.user_id=(select auth.uid())));
create policy "Members read products" on public.curitiba_products for select to authenticated using (exists(select 1 from public.curitiba_members m where m.user_id=(select auth.uid())));
create policy "Members write products" on public.curitiba_products for all to authenticated using (exists(select 1 from public.curitiba_members m where m.user_id=(select auth.uid()))) with check (exists(select 1 from public.curitiba_members m where m.user_id=(select auth.uid())));
create policy "Members read photos" on public.curitiba_photos for select to authenticated using (exists(select 1 from public.curitiba_members m where m.user_id=(select auth.uid())));
create policy "Members write photos" on public.curitiba_photos for all to authenticated using (exists(select 1 from public.curitiba_members m where m.user_id=(select auth.uid()))) with check (exists(select 1 from public.curitiba_members m where m.user_id=(select auth.uid())));
insert into storage.buckets(id,name,public,file_size_limit,allowed_mime_types) values ('curitiba-images','curitiba-images',false,8388608,array['image/jpeg','image/png','image/webp','image/heic']) on conflict(id) do nothing;
create policy "Members upload images" on storage.objects for insert to authenticated with check(bucket_id='curitiba-images' and exists(select 1 from public.curitiba_members m where m.user_id=(select auth.uid())));
create policy "Members view images" on storage.objects for select to authenticated using(bucket_id='curitiba-images' and exists(select 1 from public.curitiba_members m where m.user_id=(select auth.uid())));
-- After inviting the two users, add their UUIDs manually using SQL editor:
-- insert into public.curitiba_members(user_id) values ('USER_UUID_1'),('USER_UUID_2');
