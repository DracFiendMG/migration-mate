# MigrationMate

**Human-in-the-loop database migration agent built on TrueForge.**

MigrationMate connects to your Supabase/PostgreSQL database, inspects the schema, plans changes, tests them in an isolated sandbox, and opens a reviewed pull request—all while pausing for human approval before any irreversible action. Every migration includes a tested rollback script, making database changes safe, transparent, and audit-ready.

The agent can also **merge pull requests and execute migrations directly from the chat**, and it provides **structured post-execution reports** with Markdown tables showing inserted, updated, or deleted rows.

> *Give AI a license to act—but not a license to break production.*

---

## Live Demo

You can try the deployed agent at:  
`http://139.84.222.183:8791/agents/migration-mate-v1`

> Note: The instance is temporarily available for the hackathon judging period. If it's not reachable, please refer to the video demo or run locally using the instructions below.

---

## Table of Contents
- [What MigrationMate Does](#what-migrationmate-does)
- [How It Uses TrueForge](#how-it-uses-trueforge)
- [Setup Instructions](#setup-instructions)
- [Running the Demo](#running-the-demo)
- [Safety Features](#safety-features)
- [Qodo Code Review Evidence](#qodo-code-review-evidence)
- [Project Structure](#project-structure)
- [License](#license)

---

## What MigrationMate Does

MigrationMate automates database migrations with strict safety controls. Given a natural-language request, it can handle multiple migrations in one session:

- **Inspect** the current schema using the Supabase connector.
- **Plan** each migration: exact SQL, affected rows, risk score, and rollback script.
- **Test** in a Daytona sandbox by creating a temporary schema, copying affected tables, applying the change, and verifying.
- **Ask for human approval** before any irreversible action (DROP, ALTER, DELETE, etc.).
- **Create a pull request** on GitHub with the migration SQL, test results, and rollback script.
- **Wait for Qodo review**, then ask for approval to merge the PR.
- **Merge the PR** from within the chat (no need to visit GitHub).
- **Execute** the migration on the production database and **report results** using clear Markdown tables (e.g., inserted rows, affected counts).

It is designed for developers who want the speed of AI without losing control over production databases.

---

## How It Uses TrueForge

MigrationMate is built entirely on TrueForge, using its core features:

- **MCP connectors**: Supabase for database access, GitHub for repository operations.
- **Skills**: Reusable instruction packs for `postgres-migration`, `risk-scoring`, `rollback-author`, `schema-analysis`, `query-review`, and `post-execution-reporting`.
- **Dynamic Sub-agents**: The main agent delegates schema analysis, risk assessment, rollback authoring, SQL review, and post-execution reporting to specialized subagents backed by the skills.
- **Sandbox (Daytona)**: All code and SQL testing happens in an isolated environment before touching production.
- **Human approval**: TrueForge's approval mechanisms are used to pause before irreversible steps, PR merging, and execution.
- **Generative UI / structured output**: The agent formats execution results as Markdown tables or summaries, improving user clarity.
- **Persistent sessions**: Migration workflows survive reconnects and refreshes.

This is not a thin wrapper; TrueForge is the backbone of the agent's control plane.

---

## Setup Instructions

### Prerequisites
- Node.js 22+ (if running TrueForge locally)
- Docker (optional, for running TrueForge via Docker Compose)
- Supabase account (free tier works)
- GitHub account and a fine-grained PAT with `Contents` and `Pull requests` read/write scoped to the target repo
- Google AI Studio API key (or any OpenAI-compatible model key)
- Daytona account and API key (for sandbox)

### Step 1: Run TrueForge
```bash
npx @truefoundry/trueforge
```

Open http://localhost:8790.

### Step 2: Add Model Provider
- Go to **Settings → Models**.
- Add an OpenAI-compatible provider with:
  - Base URL: `https://generativelanguage.googleapis.com/v1beta/openai/`
  - API key: your Google AI Studio key
  - Model: `gemini-2.5-flash`

### Step 3: Connect Supabase
- Go to **Settings → Connectors → Supabase**.
- Enter your Supabase project ID and service role key (or anon key if read-only).
- Run the SQL script in `examples/schema.sql` to create the demo tables and data.

### Step 4: Connect GitHub
- Go to **Settings → Connectors → GitHub**.
- Add your fine-grained PAT with repo scope.

### Step 5: Configure Sandbox
- Go to **Settings → Sandbox providers → Daytona**.
- Enter your Daytona API key.

### Step 6: Import Skills
- Clone this repo and push the skills (or use the provided files).
- In TrueForge, go to **Settings → Skills → Import from GitHub**.
- Import the following skills from your repo:
  - `skills/postgres-migration`
  - `skills/risk-scoring`
  - `skills/rollback-author`
  - `skills/schema-analysis`
  - `skills/query-review`
  - `skills/post-execution-reporting`

### Step 7: Create the Agent
- Start a new chat, choose the Gemini model, enable all tools and skills.
- Paste the system prompt from `agent-system-prompt.md` into the agent instructions.
- Save the agent as "MigrationMate".

---

## Running the Demo

### Simple single migration
1. Ensure Supabase has sample tables (see `examples/schema.sql`).
2. Ask the agent:
   > "Rename the `phone` column in `users` to `phone_number`. Plan the migration, test it, and ask for my approval before applying."
3. Watch the agent:
   - Inspect schema.
   - Create a plan with SQL and rollback.
   - Test in Daytona sandbox (temporary schema).
   - Pause for approval.
   - Create a branch and PR.
   - Qodo reviews; agent may address comments.
   - After your approval, the agent merges the PR and executes.
   - It shows a summary of the result.

### Advanced multi-step demo
Use the following prompt to showcase multiple migration types:
Perform the following database improvements on Supabase project **idlthepdoqgvxjzdwibr**:

1. Rename the phone column in users to phone_number.
2. Backfill any missing phone_number values in users using the phone column from profiles where users.phone_number is null.
3. Add an index named idx_orders_created_at on orders.created_at.
4. Drop the unused table legacy_flags.
5. Insert a new product with name 'Wireless Mouse', price 24.99, stock_quantity 150, category 'Electronics'.
6. For each item, plan, test, ask approval, create PR, wait for Qodo, merge, execute, and report.

---

## Safety Features

- **Sandbox testing**: All SQL runs first in an isolated schema copied from production.
- **Human approval**: Any destructive operation, PR merge, and execution stops for explicit user confirmation.
- **Rollback scripts**: Every migration includes a tested undo file.
- **Qodo review**: All code changes go through a PR with automated review.
- **No secrets**: API keys and tokens are kept out of the repository (see `.env.example`).

---

## Qodo Code Review Evidence

### Representative PR
- Link: [PR #<number>](https://github.com/DracFiendMG/migration-mate/pull/<number>)

### What Qodo surfaced
- [Describe the main findings, e.g., "Qodo flagged a missing rollback file and a potential lock issue."]

### What changed or was dismissed
- [Explain your decisions: "Added the rollback file and added a comment explaining the lock. Dismissed a style suggestion because ..."]

### PR history
- [Link to the PR's review comments and commits showing Qodo review, your responses, and final merge. Example: "See the PR conversation: <link>"]

---

## Project Structure

```text
migration-mate/
├── README.md
├── agent-system-prompt.md
├── .env.example
├── .gitignore
├── skills/
│   ├── postgres-migration/
│   │   └── SKILL.md
│   ├── risk-scoring/
│   │   └── SKILL.md
│   ├── rollback-author/
│   │   └── SKILL.md
│   ├── schema-analysis/
│   │   └── SKILL.md
│   ├── query-review/
│   │   └── SKILL.md
│   └── post-execution-reporting/
│       └── SKILL.md
├── migrations/
│   └── release-1.0.0/
│       ├── V1__rename-users-phone.sql
│       └── V1_undo__rename-users-phone.sql
├── examples/
│   └── schema.sql
└── (optional) ui/
```
---

## License

MIT