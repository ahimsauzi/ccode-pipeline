# Security Policy

## Scope

This repo is a design and orchestration layer: agent definitions, stage-gate templates, decision
records, and small shell tooling. It holds no credentials and runs no network services.

The parts with a real security surface are:

- **Agent tool scoping** in `.claude/agents/*.md`. Each agent's `tools:` allowlist is the control
  that keeps it to its stage. A definition that grants more than its role needs is a valid report.
- **Remote seed capture.** The routine that writes seeds from mobile authenticates with tokens that
  live outside this repo. If you find a token, trigger ID, or endpoint secret committed here, report it.
- **Seed and content handling.** Anything that would let unreviewed agent output reach
  `content/published/` without the owner gate.

## Reporting a vulnerability

Please use GitHub's private vulnerability reporting on this repo
(**Security → Report a vulnerability**). Do not open a public issue for security findings.

Expect an acknowledgement within 7 days. This is a personal project maintained by one person, so
fixes are best effort.

## Supported versions

Only the `main` branch is maintained.
