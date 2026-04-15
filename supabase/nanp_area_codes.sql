-- Run in Supabase SQL Editor once.
-- Stores NANP (+1) area codes so the app can show an accurate "Area code" location label in Insights.

create table if not exists public.nanp_area_codes (
  area_code text primary key,
  region text,
  description text,
  timezone_offset_utc int,
  updated_at timestamptz default now()
);

alter table public.nanp_area_codes enable row level security;

-- Read-only for authenticated users (safe: no user-specific data here).
do $$
begin
  if not exists (
    select 1 from pg_policies
    where schemaname = 'public'
      and tablename = 'nanp_area_codes'
      and policyname = 'nanp_area_codes_read'
  ) then
    create policy "nanp_area_codes_read"
      on public.nanp_area_codes
      for select
      to authenticated
      using (true);
  end if;
end $$;

-- Seed a few common codes (extend/import the full list as you like).
insert into public.nanp_area_codes (area_code, region, description, timezone_offset_utc) values
  ('212','NY','New York City, Manhattan',-5),
  ('213','CA','Los Angeles',-8),
  ('305','FL','Miami',-5),
  ('312','IL','Chicago',-6),
  ('404','GA','Atlanta',-5),
  ('415','CA','San Francisco',-8),
  ('702','NV','Las Vegas',-8),
  ('713','TX','Houston',-6),
  ('786','FL','Miami (overlay)',-5),
  ('813','FL','Tampa Metro',-5),
  ('818','CA','San Fernando Valley / Los Angeles',-8),
  ('917','NY','New York (overlay)',-5)
on conflict (area_code) do update set
  region = excluded.region,
  description = excluded.description,
  timezone_offset_utc = excluded.timezone_offset_utc,
  updated_at = now();

