-- ============================================================
-- Futsal Ledger — bill/receipt photos
-- Run this in Supabase → SQL Editor → Run (one time).
-- ============================================================

-- 1. Column to store each expense's receipt image URL
alter table public.expenses add column if not exists receipt_url text;

-- 2. A public storage bucket to hold the photos
insert into storage.buckets (id, name, public)
values ('receipts', 'receipts', true)
on conflict (id) do update set public = true;

-- 3. Open policies on the bucket (matches the app's open access model)
drop policy if exists "receipts read"   on storage.objects;
drop policy if exists "receipts insert" on storage.objects;
drop policy if exists "receipts update" on storage.objects;
drop policy if exists "receipts delete" on storage.objects;

create policy "receipts read"   on storage.objects for select using (bucket_id = 'receipts');
create policy "receipts insert" on storage.objects for insert with check (bucket_id = 'receipts');
create policy "receipts update" on storage.objects for update using (bucket_id = 'receipts');
create policy "receipts delete" on storage.objects for delete using (bucket_id = 'receipts');
