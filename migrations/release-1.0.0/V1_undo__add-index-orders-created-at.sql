-- =========================================================
-- Rollback for: add index on orders.created_at
-- Version: V1
-- Release: release-1.0.0
-- Author: MigrationMate (AI agent)
-- Date: 2026-08-28T09:17:59.388Z
-- Reverses: V1__add-index-orders-created-at.sql
-- =========================================================

-- Drop the index created by the forward migration.
-- This statement reverses the forward migration, does not delete table rows,
-- and removes an index used to accelerate `created_at` queries.
-- Dropping the index can degrade the performance of queries that filter or order by `created_at`.
DROP INDEX public.idx_orders_created_at;
