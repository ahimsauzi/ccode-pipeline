# ccode-pipeline: Multi-Agent AI Security Development Pipeline

**Status:** Active — pipeline live, multiple explorations in flight
**Date:** 2026-05-25
**Owner:** ahimsauzi
**Lead Dev:** Claude (Sonnet 4.6)

---

## Vision

Build a multi-agent development pipeline that goes from general idea to specific implementation, using identity security as the working domain. The pipeline itself is the base infrastructure — this exploration validates the concept and establishes the pattern for all future explorations.

---

## Reporting Structure

```
Owner
  └── Lead Dev / Architect (Claude)
        ├── Vera   — Identity Threat Researcher        [active]
        ├── Reva   — Spec & Architecture Docs          [active]
        ├── Sage   — Content Strategist                [active, passive]
        ├── Marcus — Backend Engineer                  [benched]
        ├── Dani   — Identity Security Engineer        [benched]
        ├── Kai    — ML/AI Engineer                    [benched]
        └── Felix  — QA / Adversarial                  [benched]
```

---

## The Squad

Start lean. Most agents stay benched until an explicit activation trigger fires.

### Active from Day One

| Agent | Name | Domain | Stage |
|---|---|---|---|
| Lead Dev / Architect | Claude | Orchestration, architecture, owner contact | 0, 3, integration |
| Identity Threat Researcher | Vera | ITDR patterns, OAuth/OIDC attack surfaces, IAM misconfigurations, NHI risk | 1 |
| Spec & Architecture Docs | Reva | Product specs, identity architecture docs, compliance framework mapping | 2 |

### Active from Day One (continued)

| Agent | Name | Domain | Stage |
|---|---|---|---|
| Content Strategist | Sage | Converts pipeline artifacts into content. Two layers: `content/drafts/` (owner only) and `content/published/` (abstracted, public-ready — requires explicit owner GO). Nothing moves from drafts to published without approval. | Passive, all stages |

### Benched (with activation triggers)

| Agent | Name | Domain | Activates When |
|---|---|---|---|
| Backend Engineer | Marcus | IdP log ingestion, API layer, event pipelines | An exploration passes Stage 4 GO and needs code |
| Identity Security Engineer | Dani | AuthN/AuthZ hardening, FSI compliance, Zero Trust policy | Marcus has shippable code that needs hardening |
| ML/AI Engineer | Kai | Behavioral baselines, anomaly detection, model pipelines | An exploration's spec requires real model work (not just rules) |
| QA / Adversarial | Felix | Token abuse testing, privilege escalation paths, regression | There's something built to attack |

---

## Three-Layer Architecture

**Layer 1 — Strategic (ahimsauzi)**
Vision, priorities, scope changes, stage gate approvals. Does not touch implementation details unless escalated.

**Layer 2 — Lead Dev (Claude)**
Translates vision into executable work. Owns architecture. Makes final technical calls. Resolves agent conflicts. Only layer that reports directly to owner.

**Layer 3 — The Squad**
Specialized agents with narrow, deep scope. No generalists. Each owns their domain completely.

---

## Pipeline Flow

```
ahimsauzi (vision)
  → Lead Dev (architecture + work decomposition)
    → Vera  (research brief → threat model)
    → Reva  (threat model → product spec)
    → Kai + Marcus (spec → implementation)
    → Dani  (implementation → security review)
    → Felix (hardened build → red team report)
  → Lead Dev (integration + escalation filter)
→ ahimsauzi (approval gates at each phase)
```

---

## Ideas Phase Process

Every exploration runs through four stages. Each stage produces a document. Nothing advances without the output artifact.

```
STAGE 0 — SEED
  Raw idea captured (1-3 sentences, no polish required)

STAGE 1 — RESEARCH BRIEF
  Vera + Lead Dev: problem space, existing solutions, gaps, identity relevance

STAGE 2 — PRODUCT SPEC DRAFT
  Reva: problem statement, user, value prop, scope boundary

STAGE 3 — ARCHITECTURE SPIKE
  Lead Dev + Kai + Marcus: tech feasibility, stack choices, risks flagged

STAGE 4 — GO / NO-GO
  Owner reviews. Approve to build phase or park.
```

---

## Post-GO Graduation Rule

When an exploration reaches Stage 4 GO, the build repo is created as a **separate project** at:

```
~/Code/ACTIVE/{exploration-name}/
```

**This is mandatory, not optional.** The exploration directory under `~/Code/ACTIVE/AI/explorations/` becomes the planning artifact — it holds the pipeline stages (Seed → Research → Spec → Architecture → gate-review.md) and is not the working copy after GO.

**Enforced by:**
- All local work (code review, fixes, commits) happens in `~/Code/ACTIVE/{name}/`
- build-kit is installed inside the build repo, not the exploration

**Why:** Discovered 2026-05-28 when fixes were pushed from the exploration copy instead of the build repo, causing diverged git histories on the same remote. The build repo is the canonical working copy from GO forward.

**Archival rule:** once GO'd and the build repo exists, move the exploration folder out of the active list — from `~/Code/ACTIVE/AI/explorations/{name}/` to `~/Code/ACTIVE/AI/explorations/built/{name}/`. This keeps the root of `AI/explorations/` showing only in-flight (pre-GO) explorations; `built/` is the frozen planning-artifact archive. Move it as-is (it's often its own git clone of the build repo's remote — don't push from it after archiving, and strip or leave the remote as convenient, just don't treat it as a working copy).

**build-kit install:** see the checklist in [`docs/build-phase.md`](docs/build-phase.md).

---

## Build Platform

When an exploration reaches Stage 4 GO, **build-kit** is brought in as the build agency. Think of it as a third-party hire: the pipeline produces the artifacts (research brief, product spec, architecture spike) and hands them off — build-kit owns execution from GO to ship.

**Where it sits in the flow:**

```
Stage 4 GO (owner approval)
  → build-kit — agency runs the build
      ├── Full build execution, iteration, shipping
      ├── Marcus, Dani, Kai, Felix → observer role
      │     (available for context, domain input if needed)
      └── Sage → content pipeline unaffected
            (receives build artifacts → drafts/ as normal)
  → Lead Dev reviews, escalates blockers to owner
→ Ship
```

**Roles during build phase:**

| Role | During GO→Ship |
|---|---|
| build-kit | Owns execution — builds, iterates, ships |
| Lead Dev (Claude) | Oversight, escalation filter, owner interface |
| Marcus, Dani, Kai, Felix | Observers — consulted if build-kit needs domain input |
| Sage | Active — content pipeline continues from build artifacts |
| Vera, Reva | Passive — pipeline work complete; available if spec needs revision |

**Scope boundary:**
- Pipeline (Stages 0–4): Seed → Research → Spec → Architecture → GO/NO-GO
- build-kit: everything after GO — implementation through ship

**Tooling note:** build-kit is [developer.ai](https://github.com/Ethanon/developer.ai), an MIT-licensed Claude Code agent kit by Ethanon, imported into [`build-kit/`](build-kit/). It is installed into each build repo at GO, and is not part of this repo's `.claude/agents/`. Install steps and layout: [`docs/build-phase.md`](docs/build-phase.md).

---

## Working Domain

**Domain:** identity security. Research focuses on identity threat detection and response (ITDR) and identity security posture management (ISPM) patterns.

**Exploration topics:**
- Security posture at the identity layer
- Compliance automation
- Detection of identity-based threats

**Out of scope:**
- Offensive tools

**Hard constraint — Vendor Agnostic:**
- Explorations must work with any IdP: Okta, Entra, Ping, Auth0, Cognito, Keycloak
- Interface layer is protocol-native: SAML 2.0, OIDC, OAuth 2.0, SCIM
- Vendor-specific adapters sit at the edge only; core logic never assumes a vendor

---

## Owner Role

| Function | Description |
|---|---|
| Vision & Gate Keeper | Sets direction, approves/rejects at every stage gate |
| Context Injector | Goals, constraints, priorities |

**What you do day-to-day:**
- Drop seeds (raw idea, 1-3 sentences) when something hits
- Review and approve at each stage gate (GO / PARK / KILL)
- Inject context the agents don't have (goals, constraints, domain context)
- Ask hard questions on architecture; push back on weak reasoning

**What you don't do:**
- Write specs (Reva), do research (Vera), make solo architecture calls (Lead Dev with your review)
- Manage the squad directly (you manage Lead Dev; Lead Dev manages the squad)

---

## Reference Resources

**Multi-Agent Architecture (read first):**
- Anthropic — "Building Effective Agents" (canonical)
- Anthropic — "How we built our multi-agent research system"
- Claude Code subagents documentation

**Identity Security Foundation:**
- NIST SP 800-63-4 (Digital Identity Guidelines)
- NIST SP 800-207 (Zero Trust Architecture)
- Identiverse YouTube archive
- OAuth 2.0 (RFC 6749) and OIDC Core 1.0 specs

**ITDR/ISPM Landscape:**
- Gartner ITDR Market Guide
- KuppingerCole ITDR Leadership Compass
- Vendor docs: Silverfort, CrowdStrike Falcon Identity, Microsoft Defender for Identity

**AI Security:**
- MITRE ATLAS
- OWASP Top 10 for LLM Applications
- NIST AI Risk Management Framework

**Architect Craft:**
- "Software Architecture: The Hard Parts" (Neal Ford et al.)
- charity.wtf (Charity Majors blog)

---

## Folder Structure

`_template/` ships in this repo. Copy it to your explorations root to spawn new ideas. The underscore prefix marks it as scaffolding, not a real exploration.

```
AI/explorations/
├── _template/                    ← scaffolding (copy to spawn new exploration)
│   ├── README.md                 ← Stage 0 seed stub
│   ├── meta.yml                  ← status, current stage, active agents
│   ├── research/brief.md         ← Stage 1 stub
│   ├── spec/product.md           ← Stage 2 stub
│   ├── architecture/spike.md     ← Stage 3 stub
│   ├── decisions/gate-review.md  ← Stage 4 stub
│   └── seeds/                    ← async seed inbox
├── ccode-pipeline/               ← first exploration (the pipeline itself)
│   ├── content/
│   │   ├── drafts/               ← Sage's raw drafts (owner eyes only)
│   │   └── published/            ← approved for public (explicit owner GO)
│   └── ...
└── {future-explorations}/
```

**Spawn a new exploration:** `cp -r _template my-new-idea` — fill `README.md`, update `meta.yml`.

**Open design questions (owner to decide before template is finalized):**
1. Should Stage 0 seed capture which agents are relevant, or just the raw idea?
2. Gate reviews: simple GO/PARK/KILL, or include reasoning for a decision log?
3. File format: pure markdown, or YAML frontmatter (status, date, assigned agents) for future queryability?

---

## Remote Seed Capture

**Goal:** Drop a thought or raw idea into an existing exploration from anywhere — phone, laptop, or Siri — without opening Claude Code.

**What this is NOT:** spawning new explorations. New explorations start on desktop. Seeds go into existing ones.

### Seed Flow

```
You (anywhere — phone or laptop)
  ↓ "add seed to ccode-pipeline: <thought>"
claude.ai (web or mobile)
  ↓ invokes
RemoteTrigger: add-seed-agent
  ↓
  1. Creates seeds/YYYY-MM-DD-{short-slug}.md in the target exploration
  2. Writes the thought + timestamp to that file
  3. git commit + push to the exploration's GitHub repo
  ↓
GitHub repo (private, per exploration)
  ↓ git pull (manual or auto)
Laptop: seeds/YYYY-MM-DD-{slug}.md now exists locally
  ↓
Next Claude Code session picks it up for processing
```

### Each Seed File Format

```
seeds/YYYY-MM-DD-short-slug.md

---
date: YYYY-MM-DD HH:MM
source: mobile | desktop
---

[Raw thought, 1-3 sentences. No polish required.]
```

### New Exploration Flow (Desktop Only)

```bash
cd AI/explorations
cp -r /path/to/ccode-pipeline/_template/ my-new-idea
cd my-new-idea
git init
# fill README.md and meta.yml, then first commit
```

`_template/` is a copy source only. Each new exploration gets its own git repo.

### Live Trigger

The `add-seed-agent` routine is fired on demand over the Claude Code Routines API. The trigger ID, the bearer token that fires it, and the GitHub token it pushes with are kept out of the repo and rotated from the Routines UI.

### Prerequisites (per exploration repo)

1. Each exploration has its own private GitHub repo
2. `seeds/` folder exists (included in `_template/`)
3. RemoteTrigger `add-seed-agent` credentialed to push to that repo

### RemoteTrigger Prompt

```
You are the seed intake agent for the explorations pipeline.
Input: exploration name + 1-3 sentence thought.
Action:
1. Identify the target repo from the exploration name
2. Create seeds/YYYY-MM-DD-{short-slug}.md
3. Write the thought with date and source: mobile
4. git commit "seed: {short-slug}" and push
5. Reply with the filename and a link to the GitHub file
```

### Invocation — Three Ways

| Method | Best For |
|---|---|
| claude.ai mobile/web — "add seed to ccode-pipeline: \<thought\>" | Phone, fastest path |
| iOS Shortcut wrapping the trigger API | Siri-callable, hands-free |
| Claude Code (desktop) — drop directly into seeds/ | Laptop, no ceremony |

### Local Sync

- **Manual** — `git pull` before starting a work session (start here)
- **Auto** — `CronCreate` a 5-min `git pull` job inside Claude Code sessions (`durable: true`)

---

## Notes

- Pipeline is vendor-agnostic by design constraint — enforced at the architecture layer
