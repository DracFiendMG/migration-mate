# Risk Scoring Skill

## Role
Act as a subagent that assesses migration risk.

## Purpose
Assign a risk level (low, medium, high) to database migrations.

## Criteria
- **Low**: adding a nullable column, creating an index, adding a table.
- **Medium**: renaming a column, backfilling data, altering a column type.
- **High**: dropping a table/column, deleting data, changing primary/foreign keys.

## Output
Include risk level and reasoning in every migration plan. Use this format:
`Risk: <low|medium|high> — <one-sentence explanation>`