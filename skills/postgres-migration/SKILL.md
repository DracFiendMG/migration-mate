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
- Use the sandbox for all code execution.

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

## Migration Folder Structure & Versioning
- Organize migrations by release version folders under `migrations/`.
- Each release folder is named `release-<semver>` (e.g., `release-1.0.0`, `release-1.1.0`).
- Within a release folder, migrations are numbered sequentially starting at `V1`.
- Every forward migration must have a matching undo file with the same number and `_undo` suffix.

Example:
migrations/
├── release-1.0.0/
│ ├── V1__rename_users_phone.sql
│ ├── V1_undo__rename_users_phone.sql
│ ├── V2__backfill_phone_number.sql
│ └── V2_undo__backfill_phone_number.sql
└── release-1.1.0/
├── V1__add_index_orders_created_at.sql
└── V1_undo__add_index_orders_created_at.sql

## Release Version Selection
- Before planning a migration, inspect the `migrations/` directory to list existing release folders.
- Identify the latest release by semver order.
- Use the latest release folder for new migrations unless the user specifies a different release version.
- If no release folder exists, start with `release-1.0.0`.
- If the user requests a new release, ask for the version number before creating the folder.

## File Naming Convention
- Forward migration: `V<number>__<short_description>.sql`
- Rollback: `V<number>_undo__<short_description>.sql`
- Use lowercase with hyphens for descriptions.
- `<number>` is sequential within the release folder (V1, V2, ...).
- Double underscore after number, single underscore before `undo`, then double underscore before description.

Examples:
- `V1__rename_users_phone.sql`
- `V1_undo__rename_users_phone.sql`