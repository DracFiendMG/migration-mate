# PostgreSQL Migration Skill

## Purpose
Guide the agent through safe database migrations, including planning, sandbox testing, human approval, PR creation, execution, and rollback.

## Workflow
1. **Inspect schema** using the Supabase connector, and **inspect the repository's `migrations/` directory** to determine the correct release folder and next version number.
2. **Plan migration**: write exact SQL, identify affected rows, assign risk score.
3. **Test in sandbox**: create a temporary schema, apply changes, verify data integrity.
4. **Pause for human approval** before any irreversible action (DROP, ALTER, DELETE, etc.).
5. **Create a pull request** on GitHub with migration SQL and test results.
6. **Execute only after approval**, then verify and keep rollback script ready.

## Safety Rules
- Never run destructive SQL directly on production.
- Always include a rollback script.
- Use the sandbox for **all code execution during testing**.
- After human approval, execute the approved migration on the production database using the SQL script (via the Supabase connector or SQL editor). Do not use the sandbox for the final execution.
- If a migration fails before making any changes (e.g., duplicate object error, syntax error), do not run the rollback script. Only run rollback if the forward migration has partially or fully applied changes that need reversing. Before running rollback, verify what changes were made (e.g., check if the index exists and was created by this migration).

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
- Before applying the forward migration to the temporary schema, ensure that all schema-qualified object references (e.g., `public.table_name`) are rewritten to target the temporary schema instead (e.g., `sandbox_test_<timestamp>.table_name`). If the migration SQL uses unqualified table names, set the search_path to the temporary schema first (`SET search_path TO sandbox_test_<timestamp>;`). Never run schema-qualified SQL directly against `public` during testing.
Example:
- Original: `CREATE INDEX idx_orders_created_at ON public.orders(created_at);`
- Modified for sandbox: `CREATE INDEX idx_orders_created_at ON sandbox_test_123456.orders(created_at);`

## Migration Folder Structure & Versioning
- Organize migrations by release version folders under `migrations/`.
- Each release folder is named `release-<semver>` (e.g., `release-1.0.0`, `release-1.1.0`).
- Within a release folder, migrations are numbered sequentially starting at `V1`.
- Every forward migration must have a matching undo file with the same number and `_undo` suffix.

Example:
migrations/
├── release-1.0.0/
│   ├── V1__rename-users-phone.sql
│   ├── V1_undo__rename-users-phone.sql
│   ├── V2__backfill-phone-number.sql
│   └── V2_undo__backfill-phone-number.sql
└── release-1.1.0/
    ├── V1__add-index-orders-created-at.sql
    └── V1_undo__add-index-orders-created-at.sql

## Release Version Selection
- Before planning a migration, inspect the `migrations/` directory to list existing release folders.
- Identify the latest release by semver order.
- Use the latest release folder for new migrations unless the user specifies a different release version.
- If no release folder exists, start with `release-1.0.0`.
- If the user requests a new release, ask for the version number before creating the folder.

## File Naming Convention
- Forward migration: `V<number>__<short_description>.sql`
- Rollback: `V<number>_undo__<short_description>.sql`
- Use lowercase with **hyphens** for descriptions (no underscores).
- `<number>` is sequential within the release folder (V1, V2, ...).
- Double underscore after number, single underscore before `undo`, then double underscore before description.

Examples:
- `V1__rename-users-phone.sql`
- `V1_undo__rename-users-phone.sql`