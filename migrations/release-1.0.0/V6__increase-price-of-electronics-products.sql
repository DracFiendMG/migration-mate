-- =========================================================
-- Migration: Increase price of Electronics products by 25%
-- Version: V6
-- Release: release-1.0.0
-- Author: MigrationMate (AI agent)
-- Date: 2026-08-30T13:22:41.876Z
-- Database: Supabase PostgreSQL
-- Risk: Medium
-- Rollback: V6_undo__increase-price-of-electronics-products.sql
-- =========================================================

-- Increase the price of products in the 'Electronics' category by 25%
UPDATE public.products
SET price = price * 1.25
WHERE category_id = (SELECT id FROM public.categories WHERE name = 'Electronics');