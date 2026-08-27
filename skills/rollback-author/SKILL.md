# Rollback Author Skill

## Purpose
Generate a rollback script for every migration.

## Instructions
- For each forward migration step, write the exact reverse SQL.
- Include data restoration steps for backfills or updates.
- Test the rollback in the sandbox before execution.
- Attach the rollback script to the PR and show it before approval.

## Output Format
```sql
-- Rollback for: <describe change>
<reverse SQL statements>