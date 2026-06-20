-- ============================================================
-- Futsal Ledger — Supabase schema
-- Paste this whole file into Supabase → SQL Editor → Run.
-- Access model: OPEN (anyone with the app link can read/write).
-- ============================================================

-- Settings: a single shared row (project name + currency)
create table if not exists public.settings (
  id            int  primary key default 1,
  project_name  text not null default 'Futsal Ledger',
  currency      text not null default 'Rs',
  constraint settings_single_row check (id = 1)
);
insert into public.settings (id) values (1) on conflict (id) do nothing;

-- Deposits: money pooled into the shared bank account
create table if not exists public.deposits (
  id      text primary key,
  date    text not null,           -- 'YYYY-MM-DD'
  amount  numeric not null,
  name    text default '',         -- who deposited (partner name)
  method  text default '',         -- Cash | Bank deposit | Bank transfer | Cheque | Other
  note    text default ''
);
-- If the deposits table already exists, add the new columns:
alter table public.deposits add column if not exists name   text default '';
alter table public.deposits add column if not exists method text default '';

-- Expenses: each cost, deducted from the fund (soft-deleted ones kept as a record)
create table if not exists public.expenses (
  id          text primary key,
  date        text not null,       -- 'YYYY-MM-DD'
  item        text not null,
  category    text not null,       -- materials | labor | equipment | transport | advance | misc
  amount      numeric not null,
  note        text default '',
  created_at  bigint default 0,    -- client timestamp, used for ordering within a day
  deleted     boolean not null default false,
  deleted_at  bigint
);

-- Engineer expenses: tracked separately, never deducted from the fund
create table if not exists public.engineer_expenses (
  id          text primary key,
  date        text not null,
  item        text not null,
  category    text not null,
  amount      numeric not null,
  note        text default '',
  created_at  bigint default 0
);

-- ---------- Row Level Security: open policies ----------
alter table public.settings enable row level security;
alter table public.deposits enable row level security;
alter table public.expenses enable row level security;
alter table public.engineer_expenses enable row level security;

drop policy if exists "open settings" on public.settings;
drop policy if exists "open deposits" on public.deposits;
drop policy if exists "open expenses" on public.expenses;
drop policy if exists "open engineer" on public.engineer_expenses;

create policy "open settings" on public.settings for all to anon, authenticated using (true) with check (true);
create policy "open deposits" on public.deposits for all to anon, authenticated using (true) with check (true);
create policy "open expenses" on public.expenses for all to anon, authenticated using (true) with check (true);
create policy "open engineer" on public.engineer_expenses for all to anon, authenticated using (true) with check (true);

-- ---------- Realtime (live sync across devices) ----------
alter publication supabase_realtime add table public.settings;
alter publication supabase_realtime add table public.deposits;
alter publication supabase_realtime add table public.expenses;
alter publication supabase_realtime add table public.engineer_expenses;
