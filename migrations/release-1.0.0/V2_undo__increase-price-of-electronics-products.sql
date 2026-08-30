-- =========================================================
-- Rollback for: Increase price of electronics products
-- Version: V2
-- Release: release-1.0.0
-- Author: MigrationMate
-- Date: 2026-08-30T12:45:31.480Z
-- Reverses: V2__increase-price-of-electronics-products.sql
-- =========================================================

-- Decrease the price of all products in the 'Electronics' category by 10%.
UPDATE public.products
SET price = price / 1.10
WHERE category_id IN (SELECT id FROM public.categories WHERE name = 'Electronics');