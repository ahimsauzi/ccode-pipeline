# ccode-pipeline — Claude Instructions

Multi-agent AI development pipeline: Seed → Research → Spec → Architecture → GO/NO-GO.
Working domain: identity security (vendor-agnostic, protocol-native).

**Read DESIGN.md first.** It is the authoritative source for squad roles, stage-gate process, exploration folder structure, post-GO rules, and the full pipeline design.

## Critical Rules (do not violate)

**Post-GO working copy:** When an exploration reaches Stage 4 GO, all work moves to `~/Code/ACTIVE/{exploration-name}/`. The exploration directory under `AI/explorations/` becomes the planning artifact only — never push fixes from there after GO.

**Squad hierarchy:** Owner manages Lead Dev (Claude). Lead Dev manages the squad. Never interact directly with benched agents.

**Stage gates:** Nothing advances without an output artifact. Owner approves every GO/NO-GO.

**Content pipeline:** Sage drafts go to `content/drafts/` only. Nothing moves to `content/published/` without explicit owner GO.

