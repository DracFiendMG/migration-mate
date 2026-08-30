-- =========================================================
-- Rollback for: Database improvements - rename column, backfill, drop table, insert product
-- Version: V2
-- Release: release-1.0.0
-- Author: MigrationMate
-- Date: 2026-08-30T09:07:24Z
-- Reverses: V2__database-improvements.sql
-- =========================================================

-- Rollback for: Rename Column phone_number to phone.
ALTER TABLE public.users RENAME COLUMN phone_number TO phone;

-- Rollback for: Update Data where phone_number was NULL.
-- IMPORTANT: This rollback sets phone to NULL for affected users.
-- It does not restore original values if they were non-NULL before the forward migration.
-- A lossless rollback for data updates requires capturing original values, which is not implemented here.
UPDATE public.users
SET phone = NULL
WHERE id IN (
    SELECT u.id
    FROM public.users u
    JOIN public.profiles p ON u.id = p.user_id
    WHERE u.phone IS NOT NULL AND p.phone IS NOT NULL
);

-- Rollback for: Drop Table public.legacy_flags.
-- This recreates the table schema.
-- IMPORTANT: This rollback does NOT restore any data that was in legacy_flags before it was dropped.
-- Data recovery from a DROP TABLE operation requires a prior backup.
CREATE TABLE public.legacy_flags (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    flag_name text NOT NULL,
    is_active bool DEFAULT false NOT NULL,
    created_at timestamptz DEFAULT now() NOT NULL
);

-- Rollback for: Insert Data into public.products.
-- This deletes the product row inserted by the forward migration.
-- IMPORTANT: This deletion relies on matching specific attribute values.
-- If other rows with identical name, price, stock_quantity, and category_id exist (e.g., pre-existing or concurrent insertions),
-- they might also be deleted. A safer rollback would use a unique identifier (like the generated 'id').
DELETE FROM public.products
WHERE name = 'Wireless Mouse' AND price = 24.99 AND stock_quantity = 150 AND category_id = 1;
