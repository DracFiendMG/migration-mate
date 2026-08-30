-- =========================================================
-- Migration: Increase price of electronics products
-- Version: V5
-- Release: release-1.0.0
-- Author: MigrationMate (AI agent)
-- Date: 2026-08-30T12:45:31.480Z
-- Database: Supabase PostgreSQL
-- Risk: medium
-- Rollback: V5_undo__increase-price-of-electronics-products.sql
-- =========================================================

-- Create a temporary table to store product IDs and their original prices.
CREATE TABLE products_price_snapshot (
    product_id INTEGER PRIMARY KEY,
    original_price NUMERIC(10, 2)
);

-- Populate the snapshot table with affected product IDs and their current prices.
INSERT INTO products_price_snapshot (product_id, original_price)
SELECT p.id, p.price
FROM public.products p
JOIN public.categories c ON p.category_id = c.id
WHERE c.name = 'Electronics';

-- Increase the price of all products in the 'Electronics' category by 10%.
UPDATE public.products
SET price = price * 1.10
WHERE category_id IN (SELECT id FROM public.categories WHERE name = 'Electronics');