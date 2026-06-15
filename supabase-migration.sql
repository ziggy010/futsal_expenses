-- ============================================================
-- Futsal Ledger — migration: deleted archive + engineer expenses
-- Run this in Supabase → SQL Editor → Run (you already ran the base schema).
-- ============================================================

-- 1. Soft-delete columns on expenses (deleted ones stay as a permanent record)
alter table public.expenses add column if not exists deleted    boolean not null default false;
alter table public.expenses add column if not exists deleted_at bigint;

-- 2. Engineer expenses: tracked separately, never deducted from the fund
create table if not exists public.engineer_expenses (
  id          text primary key,
  date        text not null,
  item        text not null,
  category    text not null,
  amount      numeric not null,
  note        text default '',
  created_at  bigint default 0
);

alter table public.engineer_expenses enable row level security;
drop policy if exists "open engineer" on public.engineer_expenses;
create policy "open engineer" on public.engineer_expenses for all to anon, authenticated using (true) with check (true);

alter publication supabase_realtime add table public.engineer_expenses;
