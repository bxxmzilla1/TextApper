-- Run in Supabase SQL Editor once. Model Vault: media library per model + custom sections.

create table if not exists public.model_vault_sections (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  sort_order int not null default 0,
  model_id uuid not null references public.models (id) on delete cascade,
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz default now()
);

create table if not exists public.model_vault_items (
  id uuid primary key default gen_random_uuid(),
  public_url text not null,
  kind text not null check (kind in ('image', 'video')),
  caption text,
  storage_path text,
  section_id uuid references public.model_vault_sections (id) on delete set null,
  model_id uuid not null references public.models (id) on delete cascade,
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz default now()
);

create index if not exists model_vault_sections_model_user_idx
  on public.model_vault_sections (model_id, user_id);

create index if not exists model_vault_items_model_user_idx
  on public.model_vault_items (model_id, user_id);

create index if not exists model_vault_items_section_idx
  on public.model_vault_items (section_id);

alter table public.model_vault_sections enable row level security;
alter table public.model_vault_items enable row level security;

create policy "model_vault_sections_own" on public.model_vault_sections
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "model_vault_items_own" on public.model_vault_items
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
