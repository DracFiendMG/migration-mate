-- =========================================================
-- Rollback for: Add last_login_at column and index to users table
-- Version: V4
-- Release: release-1.0.0
-- Author: MigrationMate (AI agent)
-- Date: 2026-08-30T11:11:26.314Z
-- Reverses: V4__add-last-login-to-users.sql
-- =========================================================

-- Drop the index idx_users_last_login
DROP INDEX IF EXISTS public.idx_users_last_login;

-- Drop the last_login_at column from the users table.
-- This operation will permanently remove all stored last login timestamps.
-- This is necessary to fully revert the forward migration.
ALTER TABLE public.users
DROP COLUMN IF EXISTS last_login_at;