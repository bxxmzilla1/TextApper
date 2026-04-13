-- Run in Supabase SQL editor. Adds archive flag for sidebar (main Chats vs Archive tab).
alter table public.contacts add column if not exists archived boolean not null default false;
