# Reference — Capturing a change with the OpenSpec CLI

Mechanics for Grill-Me Spec Phase 2. Written against OpenSpec CLI 1.9; when output disagrees with this file, the CLI is the source of truth.

## 0. Preconditions

- `openspec --version` works. If not: `npm install -g @fission-ai/openspec` (Node 18+).
- The project has an OpenSpec root — an `openspec/` directory containing `config.yaml`. If not, Phase 0 should have already offered `openspec init` or interview-only mode; do not silently proceed.
- Standalone stores: if the project registers stores (`openspec store`), keep the confirmed `--store "<id>"` on every command below that accepts it. Otherwise omit it.

## 1. Scaffold the change

```bash
openspec new change "<kebab-name>"
```

Derive the kebab-case name from the confirmed scope ("add hold & recall to offline cashier" → `add-hold-recall`). Never create a directory under `openspec/changes/` by hand — the scaffold writes `.openspec.yaml` and related metadata that later commands read.

## 2. Build the required artifact set

```bash
openspec status --change "<name>" --json
```

Parse:

| Field | Meaning |
|---|---|
| `applyRequires` | artifact IDs required before implementation (e.g. `["tasks"]`) |
| `artifacts` | every artifact with its `status` and `requires` edges |
| `planningHome`, `changeRoot`, `artifactPaths` | resolved paths — use these instead of assuming repo-local paths |

The **required set** is `applyRequires` plus everything reachable by following `requires` edges transitively. `status` is file-existence only: a `done` artifact does not prove its dependencies exist — build the set from the edges. With the default spec-driven schema the set closes over proposal, specs, design (conditional), and tasks.

## 3. Create artifacts in dependency order

Use a todo list to track progress. For each artifact whose dependencies are satisfied:

```bash
openspec instructions <artifact-id> --change "<name>" --json
```

The response carries:

| Field | Meaning |
|---|---|
| `context` | project background — a constraint on you; never copy it into output |
| `rules` | artifact-specific rules — same: constraint, not content |
| `template` | the structure for the output file |
| `instruction` | schema guidance; may mark the artifact conditional ("create only if…") |
| `skipped` / `warning` | present when the change declares `skip_specs` — this artifact must NOT be created; pick another |
| `resolvedOutputPath` | where to write; may be a glob, in which case `instruction` picks the concrete path |
| `dependencies` | completed artifacts to read — always re-read from disk, the user may have edited them |

Rules of the loop:

- Re-run `openspec status --change "<name>" --json` after each artifact.
- Skip an artifact only when `status` already reports it `skipped`, or its own `instruction` marks it conditional and the condition fails (spec-driven's `design.md` is the classic conditional). Announce a deliberate skip; do not revisit it.
- Dependencies are enablers, not gates: if an artifact is blocked only by a deliberately skipped conditional dependency, write it anyway.
- Creating one artifact can unblock others; keep looping until every artifact in the required set is `done` or deliberately skipped.

## 4. Validate and finish

```bash
openspec validate <name> --strict
openspec status --change "<name>"
```

Fix validation errors until clean, show the final status, and stop. Implementation begins only when the user explicitly starts the apply workflow.
