# PostgreSQL Migration Skill

## Purpose
Guide the agent through safe database migrations, including planning, sandbox testing, human approval, PR creation, execution, and rollback.

## Branch Naming Convention
- Use branch prefix `migration/<type>/<short-description>`.
- `<type>` must be one of: `schema`, `data`, `index`, `cleanup`.
- Example: `migration/schema/rename-users-phone`, `migration/data/backfill-phone-number`, `migration/index/add-orders-created-at`, `migration/cleanup/drop-legacy-flags`.
- Use lowercase with hyphens, no underscores or spaces.

## Migration Script Typography
Every SQL migration file must include a header comment block and inline comments where useful.

### Forward migration files (`V<number>__<description>.sql`)
Header:
```sql
-- =========================================================
-- Migration: <short description>
-- Version: V<number>
-- Release: <release-version> (e.g., release-1.0.0)
-- Author: MigrationMate (AI agent)
-- Date: <timestamp>
-- Database: Supabase PostgreSQL
-- Risk: <low|medium|high>
-- Rollback: V<same-number>_undo__<description>.sql
-- =========================================================
```

### Rollback migration files (`V<number>_undo__<description>.sql`)
Header:
```sql
-- =========================================================
-- Rollback for: <short description>
-- Version: V<number>
-- Release: <release-version>
-- Author: MigrationMate
-- Date: <timestamp>
-- Reverses: V<number>__<description>.sql
-- =========================================================
```

### Inline comments
- Add a brief `--` comment before each statement explaining what it does and why.
- For data migrations, include row counts or conditions in comments.

### Sandbox Testing Protocol
- Never modify the `public` schema during testing.
- Create a temporary schema named `sandbox_test_<timestamp>` in the same database.
- Copy affected tables from `public` to the temp schema using:
  - `CREATE TABLE temp.<table> (LIKE public.<table> INCLUDING ALL);`
  - `INSERT INTO temp.<table> SELECT * FROM public.<table>;`
- Apply forward migration to the temp schema only.
- Run verification queries (column existence, data integrity, constraints).
- If required, test rollback as well.
- Drop the temp schema after successful test.
- Record results for PR description.