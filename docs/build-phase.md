# Build Phase (after GO)

ccode-pipeline stops at Stage 4. When the owner approves a GO, the exploration gets its own build
repo, and the build runs on the agent kit in [`build-kit/`](../build-kit/), installed into that
repo. This repo never runs the kit itself.

## Where the kit comes from

`build-kit/` is [developer.ai](https://github.com/Ethanon/developer.ai) by Ethanon (MIT), imported
unmodified at upstream commit `9b0b070`. See [`build-kit/NOTICE`](../build-kit/NOTICE) and
[`build-kit/LICENSE`](../build-kit/LICENSE). The import is one commit in this repo's history, and
every change after it is mine, so `git log -- build-kit/` shows exactly what I changed.

Only the build loop was imported: audits, backlog, PR review, workflows, engineering principles and
project templates. Upstream's installer, CI configs for other platforms, examples, and its testing
and UX reviewers were left out.

## What the kit does in a build repo

| Group | Agents | Trigger |
|---|---|---|
| Audits | security, naming, class size, hanging references, flaky tests, ecosystem watch, prompt audit | Scheduled |
| Backlog | audit groomer, story groomer, feature agent, scrum master | Scheduled |
| PR review | Alice (security), Bob (engineering), Gomez (clean code), Jekyll and Hyde (white-hat / black-hat pair) | Every PR |

Audits file issues, the feature agent picks them up and opens PRs, and the review fleet leaves
advisory comments. None of the reviewers can block a merge. The owner decides.

My pipeline agents (Vera, Reva, Dani, Felix) own Stages 0 to 4. The kit owns implementation after
GO. Dani and Felix stay available as observers if the build needs identity-specific review.

## Where things have to live

Claude Code and GitHub Actions only look in fixed places, and the workflows look for each agent at
`.claude/agents/{agent}.md`, so in the build repo the agent files sit flat at the root:

```
{build-repo}/
├── .github/workflows/        ← build-kit/workflows/*.yml and scripts/ (GitHub only runs workflows from here)
├── .claude/agents/           ← every file from build-kit/agents/{audits,backlog,pr-review}/, flattened
├── docs/                     ← PROJECT_CONTEXT.md, SECURITY.md, ARCHITECTURE.md from build-kit/templates/
├── engineering/              ← build-kit/engineering/
└── CLAUDE.md                 ← build-kit/CLAUDE.md, edited for the project
```

Inside this repo the kit is inert: its workflows are not under `.github/workflows/`, and its
agents are not under `.claude/agents/`, so nothing in `build-kit/` runs against ccode-pipeline.

## Install checklist (at GO)

- [ ] Copy `build-kit/agents/*/*.md` into the build repo's `.claude/agents/`
- [ ] Copy `build-kit/workflows/` (YAML and `scripts/`) into the build repo's `.github/workflows/`
- [ ] Copy `build-kit/engineering/` and `build-kit/CLAUDE.md` to the build repo root
- [ ] Copy the `build-kit/templates/` files into `docs/`, then write `docs/PROJECT_CONTEXT.md` for this project. Every kit agent reads it first.
- [ ] `.claude/settings.json` with a least-privilege tool allowlist per agent
- [ ] `pr-review.yml` `allowed_bots` includes `claude[bot]`
- [ ] Add the `CLAUDE_CODE_OAUTH_TOKEN` secret in the build repo's settings (never in a file)
- [ ] Update `meta.yml` with `build_repo`

## Operating notes

- **Secrets stay in GitHub's secret store.** Workflows reference `${{ secrets.CLAUDE_CODE_OAUTH_TOKEN }}`
  and skip themselves when it is not set. PRs from forks stop before any agent runs.
- **Scheduled agents use the token's usage on every run.** Disable the workflows
  (`gh workflow disable`) in any repo that is idle.
- **Upstream keeps moving.** To pick up later developer.ai changes, diff upstream against the
  import commit and bring changes over as separate, reviewed commits.
- **The kit's `readme.md` links to upstream install guides** (`INSTALL.md`, `ADAPTING.md`) that
  were not imported. Read them in the upstream repo.
