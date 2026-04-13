-- Run in Supabase SQL Editor. One insights row per contact (primary key = contact_id).

create table if not exists public.contact_insights (
  contact_id uuid primary key references public.contacts (id) on delete cascade,
  user_id uuid not null references auth.users (id) on delete cascade,
  model_id uuid not null references public.models (id) on delete cascade,
  birthday date,
  location_label text,
  location_lat double precision,
  location_lon double precision,
  timezone text,
  source text,
  salary numeric,
  salary_period text,
  last_pay_date date,
  job text,
  preferences text,
  hobbies text,
  nationality text,
  gender text,
  gf text,
  other_notes text,
  updated_at timestamptz default now()
);

create index if not exists contact_insights_model_user_idx
  on public.contact_insights (model_id, user_id);

alter table public.contact_insights enable row level security;

create policy "contact_insights_own" on public.contact_insights
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
