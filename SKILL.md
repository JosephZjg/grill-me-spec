---
name: grill-me-spec
description: A relentless one-question-at-a-time interview that stress-tests a change idea, then captures the confirmed consensus as a validated OpenSpec change proposal. Use when planning or sharpening a change for an OpenSpec project, when the user says "grill" about a plan/spec/proposal/change, or when requirements need pinning down before a proposal is written.
---

# Grill-Me Spec

Two phases, never skip the first: **interview** the user until every decision is made, then **capture** the consensus as an OpenSpec change. The interview is the product — the artifacts are its transcript.

This skill is self-contained: the interview rules below are complete and require no other skill. The only runtime dependency is the OpenSpec CLI, and Phase 0 handles its absence.

## Phase 0 — Preconditions and routing

**Tooling check.** Run `openspec --version` (silently). Then:

- CLI present and the project has an OpenSpec root (`openspec/config.yaml`) → continue below.
- CLI missing → offer once: `npm install -g @fission-ai/openspec`. If the user declines, offer **interview-only mode**: run Phase 1, end with the written consensus summary, create no artifacts.
- CLI present but the project is not initialized → offer `openspec init`, or interview-only mode.

**Route.** Grilling is convergence — it needs something to converge on.

- The user has a change idea with a rough shape → Phase 1.
- The user is still diverging ("should we even do X?", "Postgres or SQLite?", no change in mind) → do NOT grill yet. If an explore skill is available, suggest it; otherwise explore openly (read code, compare options, diagram) and begin grilling only once a direction is chosen.

## Phase 1 — Grill (the interview)

Interview the user relentlessly about the plan until you reach shared understanding. Walk the design tree branch by branch, resolving decision dependencies one at a time.

- **One question at a time.** Wait for the answer before asking the next. Bundled questions get bundled answers.
- **Attach your recommended answer to every question**, with a one-line rationale. Make it easy to agree in a word.
- **Facts vs decisions.** If a fact lives in the codebase, the existing specs, or `openspec/config.yaml`, look it up — never ask the user. Decisions belong to the user: put each one to them.
- **Log every edge case you probe** ("what if the network drops mid-print?"). Each becomes a Scenario in Phase 2. An interview that surfaces no edge cases was not an interview.
- **Challenge terminology immediately.** If a term is fuzzy or conflicts with the project glossary (`CONTEXT.md`, if present) or existing specs, stop and resolve it. Update `CONTEXT.md` inline as terms crystallize.
- **Track the open decisions** and close them one by one. Shared understanding means every branch of the design tree is resolved and acknowledged.
- **Create no OpenSpec files yet.** No `new change` until the user confirms.

When the last decision closes, present the consensus summary:

- **Building** — one paragraph.
- **Decisions** — numbered, each with the rejected alternative where one existed.
- **Edge cases** — the ones to cover as scenarios.
- **Out of scope.**

Ask for explicit confirmation. The user may amend — amend and re-summarize. Only confirmed consensus proceeds. In interview-only mode, this summary (written to the user, or to a file if they ask) is the deliverable; stop there.

## Phase 2 — Capture (write it down)

First read [reference.md](./reference.md) for the exact CLI mechanics. The shape:

1. `openspec new change "<kebab-name>"` — never scaffold the change directory by hand.
2. `openspec status --change "<name>" --json` — build the required artifact set from `requires` edges, not from `status` alone.
3. For each artifact in dependency order: `openspec instructions <artifact> --change "<name>" --json`, then write to `resolvedOutputPath`, honoring `context`, `rules`, and `template`. Re-read completed dependency artifacts from disk before writing.
4. Map the interview onto the artifacts:

   | Interview produced | Artifact |
   |---|---|
   | Motivation, scope, non-goals | `proposal.md` |
   | Each decision, with the rejected alternative | `design.md` |
   | Each requirement, with every probed edge case as a Scenario | spec deltas |
   | Implementation breakdown | `tasks.md` |

   A decision is only captured if the design explains why the alternative lost. A requirement is only captured if its scenarios include the edge cases from the interview.

5. `openspec validate <name> --strict` — fix until clean.
6. Show final status, then **stop**. Planning only: never implement, never edit application code. Implementation starts when the user explicitly starts the apply workflow.

### ADRs — rarely

Capture a decision in a durable ADR (`docs/adr/`) only when it is all of: hard to reverse, surprising without context, and a real trade-off. Everything else stays in `design.md`, which lives and dies with the change.

## Guardrails

- Never write application code in either phase.
- Never hand-create anything under `openspec/changes/` — CLI scaffolding carries metadata (`.openspec.yaml`).
- Do not re-litigate a confirmed decision; if the user reopens one, update the consensus summary before proceeding.
- If implementation is already underway and the design needs rework, switch hats: suggest exploring that change instead of re-grilling from zero.
