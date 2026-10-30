-- Run this once in Supabase Dashboard > SQL Editor, before using the updated site.
-- Adds "kind" (Porträtt/Tavla) and "sort_order" (manual ordering) to public.artworks.
-- Existing rows get kind = 'portratt' and keep their current order (sort_order null -> sorted by id).

alter table public.artworks
    add column if not exists kind text not null default 'portratt';

alter table public.artworks
    drop constraint if exists artworks_kind_check;

alter table public.artworks
    add constraint artworks_kind_check check (kind in ('portratt', 'tavla'));

alter table public.artworks
    add column if not exists sort_order integer;
