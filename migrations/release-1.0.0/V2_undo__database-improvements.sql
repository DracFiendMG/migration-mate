-- =========================================================
-- Rollback for: Database improvements - rename column, backfill, add index, drop table, insert product
-- Version: V2
-- Release: release-1.0.0
-- Author: MigrationMate
-- Date: 2026-08-30T09:07:24Z
-- Reverses: V2__database-improvements.sql
-- =========================================================

-- Rollback for: Rename Column phone_number to phone
ALTER TABLE public.users RENAME COLUMN phone_number TO phone;

-- Rollback for: Update Data where phone_number was NULL
UPDATE public.users
SET phone = NULL
WHERE id IN (
    SELECT u.id
    FROM public.users u
    JOIN public.profiles p ON u.id = p.user_id
    WHERE u.phone IS NOT NULL AND p.phone IS NOT NULL
);

-- Rollback for: Create Index idx_orders_created_at
DROP INDEX IF EXISTS idx_orders_created_at;

-- Rollback for: Drop Table public.legacy_flags (recreates table, data is not recovered)
CREATE TABLE public.legacy_flags (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    flag_name text NOT NULL,
    is_active bool DEFAULT false NOT NULL,
    created_at timestamptz DEFAULT now() NOT NULL
);

-- Rollback for: Insert Data into public.products
DELETE FROM public.products
WHERE name = 'Wireless Mouse' AND price = 24.99 AND stock_quantity = 150 AND category_id = 1;
