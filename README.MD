# MigrationMate

**Human-in-the-loop database migration agent built on TrueForge.**

MigrationMate connects to your Supabase/PostgreSQL database, inspects the schema, plans changes, tests them in an isolated sandbox, and opens a reviewed pull request—all while pausing for human approval before any irreversible action. Every migration includes a tested rollback script, making database changes safe, transparent, and audit-ready.

> *Give AI a license to act—but not a license to break production.*

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

MigrationMate automates database migrations with strict safety controls. Given a natural-language request, it:

1. **Inspects** the current schema using the Supabase connector.
2. **Plans** the migration: exact SQL, affected rows, risk score, and rollback script.
3. **Tests** in a Daytona sandbox by creating a temporary schema, copying affected tables, applying the change, and verifying.
4. **Asks for human approval** before any irreversible action (DROP, ALTER, DELETE, etc.).
5. **Creates a pull request** on GitHub with the migration SQL, test results, and rollback script.
6. **Awaits Qodo review**, then executes only after the PR is approved and the user gives explicit go-ahead.

It is designed for developers who want the speed of AI without losing control over production databases.

---

## How It Uses TrueForge

MigrationMate is built entirely on TrueForge, using its core features:

- **MCP connectors**: Supabase for database access, GitHub for repository operations.
- **Skills**: Reusable instruction packs for `postgres-migration`, `risk-scoring`, `rollback-author`, `schema-analysis`, and `query-review`.
- **Dynamic Sub-agents**: The main agent delegates schema analysis, risk assessment, rollback authoring, and SQL review to specialized subagents backed by the skills.
- **Sandbox (Daytona)**: All code and SQL testing happens in an isolated environment before touching production.
- **Human approval**: TrueForge's approval mechanisms are used to pause before irreversible steps.
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
- Create sample tables by running the SQL in `examples/schema.sql` (see repo).

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

### Step 7: Create the Agent
- Start a new chat, choose the Gemini model, enable all tools and skills.
- Paste the system prompt from `agent-system-prompt.md` into the agent instructions.
- Save the agent.

---

## Running the Demo

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
4. After you approve and merge, tell the agent to execute. It will apply the migration to the public schema.

---

## Safety Features

- **Sandbox testing**: All SQL runs first in an isolated schema copied from production.
- **Human approval**: Any destructive operation stops for explicit user confirmation.
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
│   └── query-review/
│       └── SKILL.md
├── migrations/
│   └── release-1.0.0/
│       ├── V1__rename-users-phone.sql
│       └── V1_undo__rename-users-phone.sql
├── examples/
│   └── schema.sql
└── (optional) ui/

---

## License

MIT