# Architecture Spike: ccode-pipeline

**Stage:** 3 — Architecture Spike
**Assigned:** Lead Dev
**Status:** Complete
**Date:** 2026-05-05

---

## Feasibility Assessment

The pipeline is buildable with current tooling. The core constraint is clear: the intelligence layer (all named agents) requires the Anthropic API and cannot run offline. Everything else — state, artifacts, tooling, content — is local and file-based. This is the right split. It means the pipeline survives context resets, model switches, and session ends, because nothing lives in model memory.

The open questions from Stage 0 are now answered:

**How are agents instantiated?**
Agents are Claude Code subagents invoked via the Agent tool within a Claude Code session. Each agent is a role/persona defined in the prompt, not a separate process. This is the lightest viable approach — no separate infrastructure, no MCP servers required for the core pipeline. Agents gain tool access (Bash, Read, Write, WebSearch, etc.) via Claude Code's existing tool system.

**What does a handoff schema look like?**
Each stage produces a markdown document with a defined structure. The next agent reads that document as its primary input. Handoffs are file-based, not API calls. The schema for each stage is the template in `_template/`.

---

## Architecture Decisions

### Agent Instantiation Model

```
Claude Code session (owner's laptop or remote session)
  └── Lead Dev (orchestrator — this session)
        └── Agent tool invocations → named agent subagents
              ├── Vera (subagent with researcher prompt)
              ├── Reva (subagent with spec-writer prompt)
              └── Sage (subagent with content-strategist prompt)
```

Each subagent is a fresh context window with a system prompt defining its role and scope. The subagent reads stage artifacts from the filesystem, produces output, and writes it back. No persistent memory between sessions — the files are the memory.

### State Persistence Model

All state lives in files. The pipeline is document-driven by design.

```
explorations/{name}/
├── README.md              Stage 0 — seed (input)
├── meta.yml               Current stage, active agents, status
├── seeds/                 Async thoughts dropped from anywhere
├── research/brief.md      Stage 1 — Vera output
├── spec/product.md        Stage 2 — Reva output
├── architecture/spike.md  Stage 3 — Lead Dev output (this file)
├── decisions/gate-review.md  Stage 4 — owner decision
├── tools/                 Build artifacts (Marcus activation)
├── content/
│   ├── drafts/            Sage output — owner eyes only
│   └── published/         Owner-approved — explicit GO required
└── notes/                 Observations, learnings
```

### Seed Capture (Remote)

Remote seeds flow through the `add-seed-agent` Claude.ai routine. Fired via API from mobile or desktop. Writes to `seeds/` via GitHub API. Owner pulls locally with `git pull`.

### Content Pipeline

Sage generates from pipeline artifacts (research briefs, architecture spikes, notes). Output goes to `content/drafts/`. Nothing moves to `content/published/` without explicit owner GO. Diagrams are generated locally via mermaid-cli (`tools/diagrams/`) and uploaded to Squarespace as static images. No third-party rendering services.

---

## Proposed Stack

| Layer | Technology | Rationale |
|---|---|---|
| Intelligence | Claude (Anthropic API) via Claude Code | Only viable orchestration platform for multi-agent at this complexity |
| Agent invocation | Claude Code Agent tool (subagents) | Lightest viable approach, no extra infra |
| State / artifacts | Markdown files in git | Survives context resets, version-controlled, readable |
| Remote seed capture | Claude.ai Routines + GitHub API | Mobile-to-pipeline without opening laptop |
| Dev tooling | Python 3.13 + FastAPI + mermaid-cli | Matches owner's skills, proven with OAuth2 playground |
| Diagram generation | mermaid-cli (local) + draw.io (local) | Zero third-party dependencies at runtime |
| Content hosting | Squarespace (static images + markdown) | Owner's existing platform |
| Code hosting | GitHub (private repos per exploration) | Standard, supports remote seed write-back |

---

## Key Risks

| Risk | Likelihood | Mitigation |
|---|---|---|
| Context window exhaustion in long sessions | Medium | Document-driven design — any new session reconstructs from files |
| Anthropic API unavailability | Low | Cannot mitigate without switching model; accept the dependency |
| Agent quality variance across model versions | Medium | Prompt clarity + stage artifact review by owner at each gate |
| Scope creep into process work vs building | High | Lead Dev flags drift actively |
| Pipeline overhead slowing momentum | Medium | Stage gates are lightweight for internal tools; skip formalities for tooling within explorations |

---

## Vendor-Agnostic Checks (for identity explorations)

- [x] Core logic will be protocol-native (SAML, OIDC, OAuth, SCIM)
- [x] Vendor-specific adapters will sit at the edge only
- [x] No vendor-specific APIs in core pipeline logic
- [x] OAuth2 playground validates this: works with any IdP, no vendor assumptions

---

## Agent Activation for Next Phase

- [x] Vera — active (research briefs)
- [x] Reva — active (specs)
- [x] Sage — active (content)
- [ ] Marcus — activates when first exploration reaches GO and needs code written
- [ ] Dani — activates when Marcus has shippable code
- [ ] Kai — activates when spec requires real ML model work
- [ ] Felix — activates when there is something to attack

---

## Output for Stage 4

Owner reviews this spike and the Stage 2 spec together. Decision: GO (pipeline is viable as designed, advance to build), PARK (good concept, not the right time), or KILL.

Key question for the GO decision: is the pipeline, as architecturally defined here, the right foundation for the first identity security exploration?
