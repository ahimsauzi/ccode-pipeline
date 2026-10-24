# Product Spec: ccode-pipeline

**Stage:** 2 — Product Spec Draft
**Assigned:** Reva
**Status:** Complete
**Date:** 2026-05-03

---

## Problem Statement

A solo identity security practitioner needs a systematic, AI-assisted pipeline that coordinates research, specification, architecture, and content generation across sessions — preserving context, enforcing quality gates, and compounding knowledge over time.

## Target User

**Primary:** A solo security practitioner with deep domain expertise and no team. Operates across laptop and mobile. Needs the system to do the coordination work so they can focus on the decisions.

## Value Proposition

**Why this:** No existing tool combines named specialist agents, stage-gated process, persistent document-driven state, and automatic content generation in a single opinionated system.

**Why now:** LLM-native development pipelines are just becoming viable. The multi-agent pattern (Anthropic "Building Effective Agents") is mature enough to build on.

**Why this design:** The owner is the domain expert and the decision-maker. The pipeline is built to support that judgment, not replace it.

## Scope Boundary

**In scope:**
- Stage-gated exploration process (Stages 0–4) for identity security ideas
- Named specialist agents with single-purpose scope (Vera, Reva, Marcus, Dani, Kai, Felix, Sage)
- Document-driven state — all context lives in files, not model memory
- Remote seed capture (mobile → GitHub → pipeline)
- Content generation pipeline (Sage): drafts layer + published layer with explicit owner gate
- Dev tooling within explorations (e.g. OAuth2 playground)
- Vendor-agnostic, protocol-native design

**Out of scope:**
- Multi-user or team collaboration features (v1 is single-operator)
- A hosted version of the pipeline
- Automated publishing to external platforms (owner always approves)
- Offensive security tooling

## Success Criteria

**Stage gate:** Each exploration advances from Seed to GO/NO-GO with a complete artifact at every stage. No gaps.

**Knowledge compounding:** After 90 days, the owner can articulate architecture decisions without referencing notes. Research briefs from Month 1 inform Month 3 specs.

**Content output:** By Month 3, Sage has produced ≥5 drafts. At least 1 has been approved for publishing.

**Build signal:** By Month 6, at least one exploration has reached Stage 4 GO and moved into its own build repo.

## Output for Stage 3

→ Lead Dev to assess technical feasibility of the pipeline architecture itself: how are agents instantiated, what is the handoff schema, how does state persist, and what does the full build sequence look like for the first exploration?
