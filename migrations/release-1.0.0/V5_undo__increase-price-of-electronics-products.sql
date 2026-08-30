-- =========================================================
-- Rollback for: Increase price of electronics products
-- Version: V5
-- Release: release-1.0.0
-- Author: MigrationMate
-- Date: 2026-08-30T12:45:31.480Z
-- Reverses: V5__increase-price-of-electronics-products.sql
-- =========================================================

-- Restore original prices using the snapshot table.
UPDATE public.products AS p
SET price = sp.original_price
FROM products_price_snapshot AS sp
WHERE p.id = sp.product_id;

-- Drop the snapshot table.
DROP TABLE products_price_snapshot;