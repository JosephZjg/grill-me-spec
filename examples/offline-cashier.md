# Example — hold & recall for an offline cashier

Input:

```
/grill-me-spec I want cashiers to be able to hold an order and recall it later, even offline
```

The excerpt below is abridged — a real interview typically runs 8–20 questions, one at a time.

## The interview

> **Q1. Where does a held order live while offline — server, or local device?**
> Recommended: local (IndexedDB via Dexie). The whole point is surviving a network drop; a server-side hold is a different feature.
> → *User: local, obviously. Server can come later.*

> **Q3. Register A is offline, register B is online — can B recall an order held on A?**
> Recommended: no in v1. Local-only recall; cross-register sync is out of scope. Surface that as a UI limitation, not a surprise.
> → *User: agreed, but put a warning somewhere.*

> **Q5. Shift closes with a held order that was never recalled — what happens to that money?**
> Recommended: auto-void with a line on the shift-end report. Silent carry-over hides cash discrepancies.
> → *User: void it, but keep it queryable for that shift's report.*

Edge cases logged along the way: network drops mid-hold; device reboots with held orders present; held order references a price change deleted meanwhile; shift close with outstanding holds.

## The consensus summary (presented for confirmation)

- **Building** — local-only hold & recall for the offline cashier, scoped to a single device.
- **Decisions** — (1) storage is local; server-side hold rejected as v2. (2) no cross-register recall in v1, surfaced as a UI warning. (3) unretrieved holds auto-void at shift close, recorded on the shift report.
- **Edge cases** — the four above, as scenarios.
- **Out of scope** — cross-device sync, customer-facing receipts for holds.

## What Phase 2 writes

`openspec new change add-hold-recall`, then `proposal.md` (motivation, scope, the three limitations), `design.md` (decisions 1–3, each with its rejected alternative), and the spec delta:

```markdown
## ADDED REQUIREMENTS

### Requirement: Held orders survive offline

The cashier SHALL place an order on hold while the device is offline, and the hold
SHALL persist across application restarts.

#### Scenario: Device reboots with a held order
- **WHEN** the device reboots while an order is held
- **THEN** the held order is still recallable after relaunch

#### Scenario: Shift closes with outstanding holds
- **WHEN** the shift is closed while orders remain held
- **THEN** the holds are voided
- **AND** each voided hold appears as a line on the shift report
```

…then `tasks.md` breaks implementation into steps, and `openspec validate add-hold-recall --strict` must pass before the skill stops.

Note how the interview maps onto the artifacts: every "what if…" from Phase 1 reappears as a `#### Scenario:` block — nothing probed gets lost between the conversation and the spec.
