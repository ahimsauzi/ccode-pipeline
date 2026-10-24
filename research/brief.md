# Research Brief: ccode-pipeline

**Stage:** 1 — Research Brief
**Assigned:** Vera + Lead Dev
**Status:** Complete
**Date:** 2026-05-03

---

## Problem Space

Security practitioners working with AI agents — particularly in the identity space — lack a systematic, reproducible process for moving from raw idea to working result. Work is typically ad-hoc: ideas live in notes apps, research doesn't feed specs, specs don't feed architecture, and knowledge evaporates between sessions. For a one-person operation ramping into a new domain (identity security), this is especially acute. Without structure, every session starts from scratch and no compounding happens.

The specific problem: how does one person research, specify, architect and build identity security tooling without losing context between sessions?

## Existing Solutions

### Platform Layer (what we build ON — influences architecture decisions)

| Platform | What it provides | Architectural implication |
|---|---|---|
| **Claude Code + subagents** | Agent orchestration, tool use, persistent file state, MCP | Our execution platform — agents ARE Claude Code subagents |
| **MCP (Model Context Protocol)** | Standardized tool/resource access for agents | How agents connect to external systems (GitHub, Notion, etc.) |
| **Anthropic agent patterns** | Orchestrator-worker, evaluator-optimizer, prompt chaining | The design patterns we implement — not invented here |
| **Claude Code Projects + memory** | Persistent context via CLAUDE.md, file-based memory | How we maintain state across sessions |
| AI coding assistants (Cursor, Windsurf) | Code generation, inline AI | Different use case — editing, not orchestration |
| **RemoteTrigger / Routines** | Cloud-hosted agent runs, API-triggerable | Remote seed capture mechanism (already live) |

### Process Layer (what others have tried)

| Approach | What it does well | Where it falls short |
|---|---|---|
| GitHub Issues + PRs | Tracks work, version-controlled | No intelligence, no research integration, no learning loop |
| Notion / Linear | Product management, flexible docs | Not agent-native, no automated artifact generation |
| CrewAI / LangGraph / AutoGen | Multi-agent orchestration, LLM pipelines | Technical frameworks, not focused on the idea-to-decision lifecycle |
| Traditional software teams | Roles, processes, specialization | Requires headcount; not available to a solo practitioner |
| Personal wikis / Obsidian | Knowledge capture | Passive — doesn't drive production |

### Domain Landscape (context for identity research)

ITDR and ISPM are active areas of identity security. Knowing how existing tools approach them shapes what the research agents look for:

| Vendor | Focus | Limitation |
|---|---|---|
| CrowdStrike Falcon Identity | Enterprise ITDR, AD-centric | Heavy, expensive, requires CrowdStrike ecosystem |
| Microsoft Defender for Identity | Entra/AD ITDR | Tied to Microsoft stack |
| Silverfort | Agentless MFA + ITDR | Proprietary, not protocol-native |
| Okta ThreatInsight | Credential attack detection | Okta-only |
| SailPoint | IGA, identity governance | Compliance-focused, not real-time detection |
| Oort (Cisco) | Identity posture management | Acquired, direction uncertain |

**Common pattern:** most approaches are tied to one vendor's stack rather than built on open protocols.

None combine: named specialist agents + stage-gated process + knowledge capture + content generation + identity-domain specificity + vendor-agnostic architecture.

## Gaps

1. **No pipeline designed for solo identity security work** — the domain requires protocol depth (OAuth, SAML, OIDC), threat intelligence, ML, and compliance simultaneously. No existing tool coordinates these.

2. **Learning and building are treated as separate activities** — for a solo builder, they must be the same activity. The pipeline needs to generate learning artifacts as a byproduct of building.

3. **Context loss across sessions** — without persistent state in files, every AI-assisted session starts cold. The pipeline must be document-driven, not model-state-driven.

4. **No remote capture for asynchronous idea input** — ideas come at any time; the pipeline needs a lightweight path from mobile thought to tracked seed without opening a dev environment.

## Identity Relevance

The pipeline's working domain is identity security:
- Focus areas: ITDR (Identity Threat Detection and Response) and ISPM (Identity Security Posture Management)
- Protocol layer: vendor-agnostic, SAML 2.0, OAuth 2.0, OIDC, SCIM
- Threat scope: OAuth/OIDC misconfigurations, token theft, NHI sprawl, shadow IT identities
- Compliance scope: NIST SP 800-63, SOX, PCI-DSS Section 8, FedRAMP identity controls

The pipeline is the infrastructure that makes exploring any of these tractable for a single operator.

## Threat Model Hooks

The pipeline itself has a lightweight threat surface:
- Tokens (GitHub PAT, Anthropic OAT) embedded in routines — rotate on schedule
- Seeds may contain sensitive ideas — keep exploration repos private until reviewed for publication
- Sage (content agent) output must be reviewed before publishing — no accidental disclosure of design details

## Key Finding

The pipeline concept is sound and the gap is real. No off-the-shelf tool addresses a solo identity security practitioner who has to research and build at the same time. The closest analog is a small engineering team compressed into agents, with the owner as the decision-maker.

## Output for Stage 2

→ Reva to produce the spec for the pipeline itself: what does a working v1 look like, and what does it need to do for its owner?