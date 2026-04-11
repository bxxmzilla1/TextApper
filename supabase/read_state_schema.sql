-- Invisible read checkpoints for chat badges (run once in SQL Editor if the table/columns are missing).
-- RLS: enable RLS and add policies so users only read/write rows where user_id = auth.uid().

create table if not exists read_state (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  model_id uuid not null,
  contact_num text not null,
  last_read_sid text,
  unread_count integer not null default 0,
  updated_at timestamptz not null default now(),
  unique (user_id, model_id, contact_num)
);

-- If the table already exists without last_read_sid, run:
-- alter table read_state add column last_read_sid text;
