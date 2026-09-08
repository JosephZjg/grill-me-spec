# Workflow Guide

How a change travels from idea to archived spec, with grill-me-spec handling the interview stage. Written against OpenSpec CLI 1.9 (workflow names below are its built-in ones).

## One-time setup (per project)

```bash
cd your-project
openspec init      # creates openspec/ (specs/ + changes/ + config.yaml)
```

Then edit `openspec/config.yaml`:

- `context` — project background: tech stack, conventions, constraints.
- `rules` — per-artifact rules agents must honor when writing proposals.

Starting on an unfamiliar project? `/openspec-onboard` helps the agent build a mental model fast.

## The change loop

Every feature or fix goes around this loop:

```
 idea
  │
  ├─ still diverging ("should we even do X?" / "Postgres or SQLite?")
  │    └→ /openspec-explore       open-ended investigation: read code,
  │                                compare options, diagram — no forced output
  │
  ├─ converged (you know what to build)
  │    └→ /grill-me-spec <idea>   ★ this skill plugs in here
  │         ① preflight (CLI + project check)
  │         ② interview: one question at a time, each with a recommended
  │            answer; facts looked up in code & specs, decisions put to you
  │         ③ consensus summary → you confirm
  │         ④ capture via CLI: proposal / design / spec deltas / tasks
  │         ⑤ validate --strict → stops and waits for your go
  │
  ├─ small change, skip the interview
  │    └→ /openspec-propose <description>   (one-shot proposal; quality on you)
  ▼
 changes/<change-name>/   ← the proposal lives here; edit the files freely
  │
  ▼ after you approve it
 /openspec-apply-change <change-name>     implement per tasks.md, tick as you go
  │
  ▼ implementation done
 /openspec-verify-change <change-name>    check against the spec (optional, recommended)
  │
  ▼
 openspec archive <change-name>           deltas merge into specs/,
 │                                        the change moves to changes/archive/
 ▼
 back to "idea" — the specs baseline is now updated
```

## Side exits

| Situation | Use |
|---|---|
| Mid-implementation, design needs rework | `/openspec-explore <change>` — discuss, then edit design.md |
| Resume a half-done change next day | `/openspec-continue-change <change>` |
| New information changes the proposal itself | `/openspec-update-change <change>` |
| Code moved first, specs drifted behind | `/openspec-sync-specs` |
| Archive a pile of old changes at once | `/openspec-bulk-archive-change` |

## CLI cheat sheet

```bash
openspec list                    # active changes
openspec list --specs            # established capability specs
openspec show <change>           # inspect a change
openspec spec show <capability>  # inspect a capability spec
openspec status --change <name>  # artifact completion status
openspec validate <name> --strict # validate (always run after capture)
openspec view                    # interactive dashboard
openspec doctor                  # environment health check
```

## Three rules that keep it healthy

1. **No apply before validate passes; no archive before implementation completes.** Archiving is the only door through which the specs baseline updates (exception: tooling/doc-only changes may use `archive --skip-specs`).
2. **Never hand-edit specs.** They evolve only via change deltas merging in at archive time, or via sync-specs when code drifted ahead — that's what keeps every Requirement traceable to the change that introduced it.
3. **Don't let interview consensus live only in the chat.** That's the reason grill-me-spec exists: finish the interview, capture the change, rely on files — not memory.

---

[English](./workflow.md) | [中文](./workflow.zh-CN.md)
