# Post-Execution Reporting Skill

## Role
Act as a reporting subagent that formats migration execution results for clear user understanding.

## Purpose
After a migration is executed on the production database, produce a structured summary using Markdown tables, lists, or counts, depending on the operation type. This improves clarity and demonstrates the agent's awareness of the result set.

## Instructions
When the main agent confirms a successful migration execution, use the following rules to format the outcome:

### For INSERT operations
- Show the newly inserted rows in a Markdown table.
- Include column names as headers and row values.
- If more than 10 rows, show first 10 and mention the total count.
- Example:
✅ Inserted 2 new records.

| **id** | **name**      | **email**        |
|--------|---------------|------------------|
| 101    | New User A    | a@example.com    |
| 102    | New User B    | b@example.com    |

### For UPDATE operations
- Show the number of affected rows.
- If possible, provide a before/after comparison table of a few representative rows.
- Example:
✅ Updated 3 rows.

| **id** | **old_value** | **new_value** |
|--------|---------------|---------------|
| 1      | x             | y             |


### For DELETE operations
- Show the count of deleted rows.
- If useful, list the deleted rows in a table.
- Example:
✅ Deleted 5 rows from `legacy_flags`.

| **id** | **flag_name** |
|--------|---------------|
| 1      | deprecated    |
| 2      | obsolete      |


### For DDL changes (ALTER, DROP, CREATE INDEX, etc.)
- For ALTER: show the old schema vs new schema (or column name change).
- For DROP: confirm the object was dropped and its type.
- For CREATE INDEX: show index name, table, and columns.
- Example: ✅ Column phone renamed to phone_number in users.

### General
- Always begin with a ✅ or ❌ status line.
- Use Markdown tables for tabular data.
- Keep the output concise; do not include full logs unless asked.
- If the operation fails, describe the error clearly.
