# ai-stack mode — `C:\dev\_ai_vault`

Active when the ai-stack vault is the target. Numbering here is `#NNN` for decisions and
`#N` for principles in `01_principles.md`. `C-NNN` belongs to the career vault and never
appears here.

This copy runs in Claude Code, which can reach the vault on disk. That does not make it
the writer. The briefing session lands the brief in `01_inbox/` and stops there. A
separate vault-reconciliation conversation reads the brief, checks it against the master
vault, and writes the entries with final numbering and CRLF.

## Live files to read (one read each, best-effort)

`06_decisions-log.md` for the current max `#NNN` and the live ADR shape ·
`06b_deferred-decisions.md` · `01_principles.md` · `07_backlog.md` · `04_agents/NN_*.md`.

## Classification tree

For each settled item, ask in order:

- **Is it a reusable rule that should govern future decisions** — a commitment, not a
  specific choice? → **PRINCIPLE** → `01_principles.md`. *Rare.* See the guardrail below:
  most things that feel like principles are decisions that *apply* one.
- **Was a concrete choice made and acted on** — built, adopted, fixed, reversed? →
  **DECISION** → `06_decisions-log.md`. If it changes an existing decision's
  rubric, policy or scope it is still a *new numbered decision*, titled `(amends #MMM)`,
  linking `#MMM`.
- **Was something considered and explicitly parked, with a revisit trigger?** →
  **DEFERRED** → `06b_deferred-decisions.md`. Deferred means the decision is real and
  logged as *not now*. No trigger → it is backlog, not 06b.
- **Is it not-built-yet work** — no decision, no fork, just a task? → **BACKLOG** →
  `07_backlog.md`.
- **Did an agent's spec, status or runbook change** — `live`→…, new trigger, new I/O? →
  **AGENT SPEC** → `04_agents/NN_*.md`, plus a decision entry if a *choice* drove it.

One item can produce entries in several places. List all.

## Formats

**Decision** (`06_decisions-log.md`) — ADR, entries separated by `---`:

```
## NNN — YYYY-MM-DD — Title  [· optional ✅ CLOSED / ⚠️ REVISED badge]

**Decision:** what was decided, in one line.
**Alternatives considered:** what else was on the table (bulleted; "rejected — why").
**Rationale:** why this won.   ← or **Fix:** / **Mechanism:** / **Firing rules:** /
                                  **Live result:** as the content demands; the labels
                                  are flexible, the one-line Decision is not.
**Revisit when:** the condition that should trigger reconsideration.
**Related:** #NNN (amended/sibling), `01_principles.md #NN`, `04_agents/..md`.  *Files:* code touched.
```

Keep **Decision:** to one line. If you cannot, it is not crisp yet — split it.

**Deferred** (`06b_deferred-decisions.md`), grouped under a `## AGENT` header:

```
### Title
**Origin:** which decision/spec/fork this came out of (#NNN, file).
**What:** the parked option, concretely.
**Why parked:** the reason it was set aside now (link the principle if one governs).
**Revisit trigger:** the specific condition or data that should bring it back.
```

**Principle** (`01_principles.md`) — `## N. Title` plus a short prose paragraph stating
the commitment and its consequence. Rare. Every decision that applies it should cite
`01_principles.md #N`.

**Backlog** (`07_backlog.md`) — a line item, not an ADR. No rationale block.

## Guardrails — on top of the shared ones

**Principle vs decision — the recurring error.** Recall-over-precision is **principle
#16**, not a decision; decisions *cite* it. Test: would this sentence still be true and
useful across unrelated future agents? Yes → principle. A choice about *this* system
*now* → decision. When unsure, it is a decision. Do not mint principles to dignify
ordinary decisions.

**Related: is mandatory** and carries, where they exist: what it amends or supersedes,
the principles it applies, its siblings from this session, the agent or spec file it
touches, and `*Files:*` for code.

**The mirror is a production input, not a cache** (`#369`). If the session changed a file
that is mirrored into project knowledge, say so in the brief — six integrity checks
passed once while the mirror sat four versions stale and the scheduled run read the stale
copy.

## Filename

`C:\dev\_ai_vault\01_inbox\<YYYY-MM-DD>_vault-brief_<topic>.md`, written directly.
