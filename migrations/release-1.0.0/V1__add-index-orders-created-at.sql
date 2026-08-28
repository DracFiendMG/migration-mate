-- =========================================================
-- Migration: add index on orders.created_at
-- Version: V1
-- Release: release-1.0.0
-- Author: MigrationMate (AI agent)
-- Date: 2026-08-28T09:17:59.388Z
-- Database: Supabase PostgreSQL
-- Risk: low
-- Rollback: V1_undo__add-index-orders-created-at.sql
-- =========================================================

-- Add a non-concurrent B-tree index on the created_at column of the orders table.
-- This will improve query performance for queries filtering or ordering by created_at.
CREATE INDEX CONCURRENTLY idx_orders_created_at ON public.orders (created_at);
