-- Run in Supabase SQL Editor once. Adds optional profile image for each model (public URL + storage path for cleanup).

alter table public.models
  add column if not exists avatar_url text,
  add column if not exists avatar_storage_path text;

comment on column public.models.avatar_url is 'Public Supabase Storage URL for model profile picture';
comment on column public.models.avatar_storage_path is 'Object key in the media bucket (e.g. model-avatar-<uuid>-<timestamp>.jpg; for replace/delete)';
