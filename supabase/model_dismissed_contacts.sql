-- Run in Supabase SQL Editor once. Prevents auto-re-adding chats after the user deletes them
-- (inbound poller skips numbers recorded here until the user adds the contact manually again).

create table if not exists public.model_dismissed_contacts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  model_id uuid not null references public.models (id) on delete cascade,
  phone_key text not null,
  created_at timestamptz default now(),
  unique (user_id, model_id, phone_key)
);

create index if not exists model_dismissed_contacts_model_user_idx
  on public.model_dismissed_contacts (model_id, user_id);

alter table public.model_dismissed_contacts enable row level security;

create policy "model_dismissed_contacts_own" on public.model_dismissed_contacts
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
