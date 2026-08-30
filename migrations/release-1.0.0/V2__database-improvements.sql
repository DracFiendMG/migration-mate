-- =========================================================
-- Migration: Database improvements - rename column, backfill, drop table, insert product
-- Version: V2
-- Release: release-1.0.0
-- Author: MigrationMate (AI agent)
-- Date: 2026-08-30T09:07:11Z
-- Database: Supabase PostgreSQL
-- Risk: high
-- Rollback: V2_undo__database-improvements.sql
-- =========================================================

-- Rename the 'phone' column in 'users' to 'phone_number'.
ALTER TABLE public.users RENAME COLUMN phone TO phone_number;

-- Backfill any missing 'phone_number' values in 'users' using the 'phone' column from 'profiles'.
UPDATE public.users u
SET phone_number = p.phone
FROM public.profiles p
WHERE u.id = p.user_id AND u.phone_number IS NULL AND p.phone IS NOT NULL;

-- DESTRUCTIVE: Drop the unused table 'legacy_flags'.
-- This operation permanently removes the table and all its data.
-- Data cannot be restored by the rollback script.
DROP TABLE public.legacy_flags;

-- Insert a new product with name 'Wireless Mouse', price 24.99, stock_quantity 150, category 'Electronics' (using category_id = 1).
INSERT INTO public.products (name, price, stock_quantity, category_id)
VALUES ('Wireless Mouse', 24.99, 150, 1);
