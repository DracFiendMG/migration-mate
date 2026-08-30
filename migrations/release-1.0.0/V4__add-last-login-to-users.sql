-- =========================================================
-- Migration: Add last_login_at column and index to users table
-- Version: V4
-- Release: release-1.0.0
-- Author: MigrationMate (AI agent)
-- Date: 2026-08-30T11:11:26.314Z
-- Database: Supabase PostgreSQL
-- Risk: medium
-- Rollback: V4_undo__add-last-login-to-users.sql
-- =========================================================

-- Add a new column last_login_at of type TIMESTAMPTZ to the users table
ALTER TABLE public.users
ADD COLUMN last_login_at TIMESTAMPTZ;

-- Update all users to set last_login_at to now() where last_login_at is null in batches
DO
$$
BEGIN
    WHILE (SELECT count(*) FROM public.users WHERE last_login_at IS NULL) > 0 LOOP
        UPDATE public.users
        SET last_login_at = now()
        WHERE last_login_at IS NULL
        LIMIT 1000;
        RAISE NOTICE 'Updated 1000 users. Remaining: %.', (SELECT count(*) FROM public.users WHERE last_login_at IS NULL);
        PERFORM pg_sleep(0.1); -- Wait for 100ms to reduce load
    END LOOP;
END;
$$
LANGUAGE plpgsql;

-- Create an index named idx_users_last_login on users(last_login_at) concurrently to avoid locking
CREATE INDEX CONCURRENTLY idx_users_last_login ON public.users(last_login_at);