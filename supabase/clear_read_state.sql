-- Clear all unread / read-position data for a fresh start with notification badges.
-- Run in Supabase Dashboard → SQL Editor → New query → Run.
--
-- Requires a table named read_state (columns like user_id, model_id, contact_num, updated_at).
-- If the table does not exist yet, skip this or create the table first.

DELETE FROM read_state;

-- Faster reset (same effect; reclaims storage more aggressively):
-- TRUNCATE TABLE read_state;
