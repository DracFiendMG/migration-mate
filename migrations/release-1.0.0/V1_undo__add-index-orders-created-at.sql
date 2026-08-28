-- =========================================================
-- Rollback for: add index on orders.created_at
-- Version: V1
-- Release: release-1.0.0
-- Author: MigrationMate (AI agent)
-- Date: 2026-08-28T09:17:59.388Z
-- Reverses: V1__add-index-orders-created-at.sql
-- =========================================================

-- Drop the index created by the forward migration.
DROP INDEX public.idx_orders_created_at;
