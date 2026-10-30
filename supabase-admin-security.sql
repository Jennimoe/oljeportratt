-- Run this in Supabase Dashboard > SQL Editor.
-- Public visitors can read published artwork. Only jennimoe@gmail.com can change it.

do $$
begin
    if to_regclass('public.artworks') is null then
        raise exception 'Table public.artworks does not exist. Create it before running this script.';
    end if;

    if not exists (select 1 from storage.buckets where id = 'paintings') then
        raise exception 'Storage bucket paintings does not exist. Create it before running this script.';
    end if;
end
$$;

alter table public.artworks enable row level security;

revoke all privileges on table public.artworks from public, anon, authenticated;
grant select on table public.artworks to anon, authenticated;
grant insert, update, delete on table public.artworks to authenticated;

drop policy if exists "Public can read artworks" on public.artworks;
create policy "Public can read artworks"
    on public.artworks
    for select
    to anon, authenticated
    using (true);

drop policy if exists "Admin can manage artworks" on public.artworks;
create policy "Admin can manage artworks"
    on public.artworks
    for all
    to authenticated
    using (lower((select auth.jwt() ->> 'email')) = 'jennimoe@gmail.com')
    with check (lower((select auth.jwt() ->> 'email')) = 'jennimoe@gmail.com');

drop policy if exists "Restrict artwork inserts to admin" on public.artworks;
create policy "Restrict artwork inserts to admin"
    on public.artworks
    as restrictive
    for insert
    to public
    with check (lower((select auth.jwt() ->> 'email')) = 'jennimoe@gmail.com');

drop policy if exists "Restrict artwork updates to admin" on public.artworks;
create policy "Restrict artwork updates to admin"
    on public.artworks
    as restrictive
    for update
    to public
    using (lower((select auth.jwt() ->> 'email')) = 'jennimoe@gmail.com')
    with check (lower((select auth.jwt() ->> 'email')) = 'jennimoe@gmail.com');

drop policy if exists "Restrict artwork deletes to admin" on public.artworks;
create policy "Restrict artwork deletes to admin"
    on public.artworks
    as restrictive
    for delete
    to public
    using (lower((select auth.jwt() ->> 'email')) = 'jennimoe@gmail.com');

update storage.buckets
set public = true
where id = 'paintings';

drop policy if exists "Admin can manage paintings" on storage.objects;
create policy "Admin can manage paintings"
    on storage.objects
    for all
    to authenticated
    using (
        bucket_id = 'paintings'
        and lower((select auth.jwt() ->> 'email')) = 'jennimoe@gmail.com'
    )
    with check (
        bucket_id = 'paintings'
        and lower((select auth.jwt() ->> 'email')) = 'jennimoe@gmail.com'
    );

drop policy if exists "Restrict painting inserts to admin" on storage.objects;
create policy "Restrict painting inserts to admin"
    on storage.objects
    as restrictive
    for insert
    to public
    with check (
        bucket_id <> 'paintings'
        or lower((select auth.jwt() ->> 'email')) = 'jennimoe@gmail.com'
    );

drop policy if exists "Restrict painting updates to admin" on storage.objects;
create policy "Restrict painting updates to admin"
    on storage.objects
    as restrictive
    for update
    to public
    using (
        bucket_id <> 'paintings'
        or lower((select auth.jwt() ->> 'email')) = 'jennimoe@gmail.com'
    )
    with check (
        bucket_id <> 'paintings'
        or lower((select auth.jwt() ->> 'email')) = 'jennimoe@gmail.com'
    );

drop policy if exists "Restrict painting deletes to admin" on storage.objects;
create policy "Restrict painting deletes to admin"
    on storage.objects
    as restrictive
    for delete
    to public
    using (
        bucket_id <> 'paintings'
        or lower((select auth.jwt() ->> 'email')) = 'jennimoe@gmail.com'
    );
