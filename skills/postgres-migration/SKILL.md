# PostgreSQL Migration Skill

## Purpose
Guide the agent through safe database migrations, including planning, sandbox testing, human approval, PR creation, execution, and rollback.

## Workflow
1. **Inspect schema** using the Supabase connector.
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