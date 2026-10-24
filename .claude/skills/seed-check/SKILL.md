---
name: seed-check
description: Scan ccode-pipeline/seeds/ for untriaged seeds and surface them for decision. A seed is untriaged when its YAML frontmatter has no `triaged:` field. Use when the user runs /seed-check, or when invoked by the daily cron via tools/seed-check.sh (which passes the `report` argument for non-interactive output).
---

# seed-check

Surfaces untriaged seeds from `seeds/` so the user can decide what to do with each one. Stays human-in-the-loop — never auto-dispatches to other agents.

## Mode detection

- If the invocation includes the argument `report`, run in **non-interactive cron mode**: print a summary and exit. Do not prompt the user, do not modify any files.
- Otherwise, run in **interactive mode**: walk the user through each untriaged seed.

## Procedure

1. List every `.md` file in `seeds/` (exclude `.gitkeep` and anything in subdirectories).
2. Read each file's YAML frontmatter. A seed is **untriaged** when the frontmatter has no `triaged:` key.
3. Sort untriaged seeds oldest-first by their `date:` field.

### Report mode

Print a single block. Example:

```
seed-check @ 2026-05-17 — 3 untriaged
  • 2026-05-01-oauth2-playground-fastapi-tracer.md (16 days old)
  • 2026-05-10-example-seed.md (7 days old)
  • 2026-05-17-another-example-seed.md (today)
```

If zero untriaged, print: `seed-check @ <today> — inbox clear`. Then exit.

### Interactive mode

For each untriaged seed (oldest first):

1. Show filename, age in days, `source:` value, and the seed body (first ~3 lines).
2. Ask what to do. Standard decisions:
   - **promote** — worth moving into the pipeline (Research / Spec stage)
   - **draft** — hand to Sage for a content draft later
   - **archive** — acknowledge and bury, not pursuing
   - **hold** — leave it untriaged, decide later (no marker added, no file change)
3. For any decision other than **hold**, append two lines to the seed's YAML frontmatter:
   ```
   triaged: <today YYYY-MM-DD>
   triage_decision: <decision>
   ```
   Preserve the existing frontmatter exactly. Do not modify the body.

After all seeds are handled, summarize what changed: how many triaged, how many held.

## What not to do

- Do not move, rename, or delete seed files.
- Do not invoke other agents (Sage, Vera, etc.) automatically. Triage records intent only — the user fires the agent separately.
- Do not modify any seed that already has a `triaged:` field.
- Do not write to git or push anything.
