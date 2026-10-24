# Build Phase (after GO)

ccode-pipeline stops at Stage 4. When the owner approves a GO, the exploration gets its own build
repo, and the build runs on a Claude Code agent kit installed into that repo. This repo never runs
the kit itself.

## Dependency

[developer.ai](https://github.com/Ethanon/developer.ai) by Ethanon (MIT). I keep a configured copy
of it, called **ethanon-app**, and install that into each build repo. It is not included here.

## What the kit does in a build repo

| Group | Agents | Trigger |
|---|---|---|
| Audits | security, naming, class size, hanging references, flaky tests, ecosystem watch | Scheduled |
| Backlog | audit groomer, story groomer, developer agent, scrum master | Scheduled |
| PR review | Alice (security), Bob (engineering), Gomez (clean code), Jekyll and Hyde (white-hat / black-hat pair) | Every PR |

Audits file issues, the developer agent picks them up and opens PRs, and the review fleet leaves
advisory comments. None of the reviewers can block a merge. The owner decides.

My pipeline agents (Vera, Reva, Dani, Felix) own Stages 0 to 4. The kit owns implementation after
GO. Dani and Felix stay available as observers if the build needs identity-specific review.

## Where things have to live

Claude Code and GitHub Actions only look in fixed places, so the layout in the build repo matters:

```
{build-repo}/
├── .github/workflows/        ← pr-review.yml, scheduled-agents.yml (GitHub only runs workflows from the root)
├── ethanon-app/              ← the kit: agents, skills, engineering docs
│   ├── .claude/agents/       ← audits/, backlog/, pr-review/
│   └── docs/PROJECT_CONTEXT.md
└── meta.yml                  ← build_repo + kit_subdirectory: "ethanon-app"
```

The workflow prompts point each agent at its spec under `ethanon-app/.claude/agents/...`.

## Install checklist (at GO)

- [ ] Copy `ethanon-app/` into the build repo
- [ ] Copy its two workflows into the build repo's root `.github/workflows/`
- [ ] Rewrite `ethanon-app/docs/PROJECT_CONTEXT.md` for this project. Every kit agent reads it first.
- [ ] `.claude/settings.json` with a least-privilege tool allowlist per agent
- [ ] `pr-review.yml` `allowed_bots` includes `claude[bot]`
- [ ] Add the `CLAUDE_CODE_OAUTH_TOKEN` secret in the build repo's settings (never in a file)
- [ ] Update `meta.yml` with `build_repo` and `kit_subdirectory`

## Operating notes

- **Secrets stay in GitHub's secret store.** Workflows reference `${{ secrets.CLAUDE_CODE_OAUTH_TOKEN }}`
  and skip themselves when it is not set. PRs from forks stop before any agent runs.
- **Scheduled agents use the token's usage on every run.** Disable the workflows
  (`gh workflow disable`) in any repo that is idle or holds only the template.
- **Keep the kit current.** A configured copy drifts from upstream, so re-check developer.ai
  before installing it into a new build repo.
