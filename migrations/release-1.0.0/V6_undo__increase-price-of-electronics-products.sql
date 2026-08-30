-- =========================================================
-- Rollback for: Increase price of Electronics products by 25%
-- Version: V6
-- Release: release-1.0.0
-- Author: MigrationMate
-- Date: 2026-08-30T13:22:41.876Z
-- Reverses: V6__increase-price-of-electronics-products.sql
-- =========================================================

-- Rollback for: Update product prices
UPDATE public.products
SET price = price / 1.25
WHERE category_id = (SELECT id FROM public.categories WHERE name = 'Electronics');