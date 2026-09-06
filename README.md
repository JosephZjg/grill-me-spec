# grill-me-spec

[English](./README.md) | [简体中文](./README.zh-CN.md)

> Grill the plan. Ship the spec.

An agent skill that pairs a **relentless interview** with **[OpenSpec](https://github.com/Fission-AI/OpenSpec)'s** spec-driven workflow: it stress-tests a change idea one question at a time, then captures the confirmed consensus as a validated OpenSpec change proposal.

## Why

Two failure modes it fixes:

- AI-generated proposals built from a one-line prompt are confident guesses about your requirements.
- Conversations that *do* sharpen a plan evaporate in the chat history the moment the session ends.

grill-me-spec closes the loop by making the interview itself the input to the proposal:

- Every decision questioned → `design.md`, **with the rejected alternative**
- Every edge case probed ("what if the network drops mid-print?") → a `Scenario:` in the spec delta
- Scope boundaries and non-goals → `proposal.md`

Nothing discussed gets lost between the conversation and the spec.

## Where it fits

```
vague idea ──▶ explore ──▶ direction chosen ──▶ grill-me-spec ──▶ apply ──▶ archive
              (diverge)                        (interview +
                                                capture)
```

| | OpenSpec explore mode | grill-me-spec |
|---|---|---|
| Stance | diverge — open threads, follow what resonates | converge — walk the design tree, branch by branch |
| Pace | free-form | one question at a time, each with a recommended answer |
| Ends | optional ("want a proposal?") | always — confirmed consensus → validated change |
| Mid-change rework | yes | no — it reroutes you to explore |

grill-me-spec does not replace `explore`, `apply`, or `archive`. It replaces the *input* to `propose`: a one-line prompt becomes a grilled consensus.

## Requirements

- An agent that loads skills from a skills directory (Claude Code, Codex, ZCode, …).
- For the full workflow: the [OpenSpec CLI](https://www.npmjs.com/package/@fission-ai/openspec) (`npm i -g @fission-ai/openspec`, Node 18+) and a project initialized with `openspec init`.

**No other skills needed.** The interview rules are embedded — you do not need grill-me/grilling or any OpenSpec agent skills installed. Without the OpenSpec CLI the skill degrades gracefully to an interview that ends with a written consensus summary you can paste into an issue or doc.

## Install

One-liner — auto-detects claude/codex/zcode (append `-s -- --tool <name>` or `-s -- --dest <path>` to choose explicitly):

```bash
curl -fsSL https://raw.githubusercontent.com/JosephZjg/grill-me-spec/main/install.sh | bash
```

```powershell
irm https://raw.githubusercontent.com/JosephZjg/grill-me-spec/main/install.ps1 | iex
```

Works on macOS (system bash 3.2+), Linux, Git Bash, and Windows PowerShell 5.1+.

Or clone straight into your agent's skills directory:

```bash
git clone https://github.com/JosephZjg/grill-me-spec ~/.claude/skills/grill-me-spec   # Claude Code
git clone https://github.com/JosephZjg/grill-me-spec ~/.codex/skills/grill-me-spec   # Codex
git clone https://github.com/JosephZjg/grill-me-spec ~/.zcode/skills/grill-me-spec   # ZCode
```

> Mainland China? Clone the [Gitee mirror](https://gitee.com/gather_limon/grill-me-spec) instead — replace the GitHub URL above with `https://gitee.com/gather_limon/grill-me-spec`.

Or from a local clone: `./install.sh` / `.\install.ps1` (same auto-detection and flags).

## Use

```
/grill-me-spec add hold & recall to the offline cashier
```

The agent will:

1. **Check & route** — verify the OpenSpec CLI and project; if the idea is still divergent, it sends you to explore mode first.
2. **Interview** — one question at a time, each with a recommended answer. Facts it looks up in the codebase; decisions it puts to you.
3. **Summarize for confirmation** — building, decisions, edge cases, out of scope. Nothing proceeds until you confirm.
4. **Capture** — `openspec new change` → `status` → `instructions` → write each artifact honoring your project's `context` and `rules` → `validate --strict`.
5. **Stop.** Implementation starts only when you explicitly say so.

A full worked example (interview excerpt → artifacts): [examples/offline-cashier.md](examples/offline-cashier.md).

## FAQ

**Do I need grill-me / grilling installed?**
No. The interview stance is embedded in this skill. (Credit where due: the stance is inspired by Matt Pocock's grilling skills.)

**Do I need OpenSpec?**
For capture, yes — artifacts are created through the OpenSpec CLI, which also enforces validation. Without it, the skill runs in interview-only mode and hands you a consensus summary.

**Does it replace `openspec-propose`?**
It replaces its input. Capture uses the same CLI mechanics as propose, but the artifacts are transcribed from a confirmed interview instead of extrapolated from a one-line prompt.

**Where do ADRs fit?**
Rarely, by design. A decision earns a durable ADR only if it is hard to reverse, surprising without context, and a real trade-off. Everything else lives in the change's `design.md`, which lives and dies with the change.

## License

[MIT](./LICENSE)
