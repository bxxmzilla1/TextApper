-- Run in Supabase SQL Editor once. Groups are scoped per model and user.

create table if not exists public.contact_groups (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  model_id uuid not null references public.models (id) on delete cascade,
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz default now()
);

create table if not exists public.contact_group_members (
  group_id uuid not null references public.contact_groups (id) on delete cascade,
  contact_id uuid not null references public.contacts (id) on delete cascade,
  primary key (group_id, contact_id)
);

create index if not exists contact_groups_model_user_idx
  on public.contact_groups (model_id, user_id);

create index if not exists contact_group_members_contact_idx
  on public.contact_group_members (contact_id);

alter table public.contact_groups enable row level security;
alter table public.contact_group_members enable row level security;

create policy "contact_groups_own" on public.contact_groups
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "contact_group_members_via_group" on public.contact_group_members
  for all using (
    exists (
      select 1 from public.contact_groups g
      where g.id = group_id and g.user_id = auth.uid()
    )
  )
  with check (
    exists (
      select 1 from public.contact_groups g
      where g.id = group_id and g.user_id = auth.uid()
    )
  );
