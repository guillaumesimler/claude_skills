---
name: vault-briefing
description: >-
  Produce a structured session-to-vault briefing that Guillaume's separate Claude
  Code vault-reconciliation conversation applies to his Obsidian ai-stack vault. Use
  whenever he says "prepare the brief", "wrap up the work for the vault", "vault
  read", "prepare the vault element", or runs /vault-brief — or at the end of any
  session that produced decisions, amendments, deferrals, or new principles for the
  vault. Sorts each item into its correct vault home (decisions, deferred,
  principles, backlog, agent specs), enforces the cross-reference discipline, and
  keeps principles distinct from decisions. Do NOT write the vault directly (chat
  Claude can't) or handle source-note frontmatter (that's vault-source-frontmatter).
---

# Vault briefing

## What this is

A briefing is the **structured handoff** between a working session (here, in chat)
and Guillaume's vault. Chat Claude **cannot write the vault** — the vault is plain
markdown on the homeserver, and only **Claude Code** edits it, human-triggered. A
*separate* vault-reconciliation conversation ingests this briefing, checks it for
consistency against the master vault, and writes the actual entries with final
numbering and CRLF.

So the job here is **not** to produce finished vault notes. It is to produce a clean,
correctly-classified, fully-linked briefing that the downstream skill can apply
mechanically without having to re-derive intent. Get the classification and the
cross-references right; let the downstream own final numbering and the on-disk write.

Output is one markdown file in `/mnt/user-data/outputs/`. Plain LF is fine — Claude
Code enforces CRLF on the vault write.

## Trigger

`/vault-brief`, or any of: "prepare the brief", "wrap up the work for the vault",
"vault read", "prepare the vault element", "log this to the vault". Also fire
proactively at the natural end of a session that produced vault-worthy decisions, and
offer to brief.

## Workflow

1. **Inventory the session.** Walk what was actually settled — not what was merely
   discussed. A decision is something that *changed the design or the plan*. Idle
   exploration that led nowhere is not a vault entry.
2. **Read the live vault format and current numbering** (cheap, best-effort). If the
   project files are mounted/connected, peek at `06_decisions-log.md` for the current
   max `#NNN` and the live ADR shape, `06b_deferred-decisions.md` and
   `01_principles.md` for their formats. This is the single source of truth; prefer it
   over the templates embedded below. Don't spend many tokens here — one read each.
   If the files aren't available, fall back to the embedded templates and mark
   numbering `#NNN (next available — confirm)`.
3. **Classify each item** into its vault home (decision tree below).
4. **Draft each entry** in the matching format, with a **Related:** line.
5. **Run the guardrails** (principle-vs-decision, linkage, amendment-needs-edit).
6. **Write the briefing** and present it. State plainly that it's an input for the
   vault-reconciliation conversation, not a vault write.

## Classification decision tree

For each settled item, ask in order:

- **Is it a reusable rule that should govern future decisions** (a commitment, not a
  specific choice)? → **PRINCIPLE** → `01_principles.md`. *Rare.* See the guardrail
  below — most things that feel like principles are actually decisions that *apply* an
  existing principle. A new principle is a genuine addition to the constitution, not a
  restatement.
- **Was a concrete choice made and acted on** (built, adopted, fixed, reversed)? →
  **DECISION** → `06_decisions-log.md`.
  - If it changes an existing decision's rubric/policy/scope → it's still a *new
    numbered decision*, titled `(amends #MMM)`, and it links #MMM in **Related:**.
    Flag separately if the old note's body must actually be *edited* (e.g. a carve-out
    removed), not merely cross-referenced.
- **Was something considered and explicitly parked**, with a revisit trigger? →
  **DEFERRED** → `06b_deferred-decisions.md`. Deferred means *the decision is real and
  logged as "not now"* — not "might be nice." If it has no trigger, it's backlog.
- **Is it just not-built-yet work** (no decision, no fork — a task)? → **BACKLOG** →
  `07_backlog.md`. Do **not** put these in 06b.
- **Did an agent's spec/status/runbook change** (status `live`→…, new trigger, new
  I/O)? → **AGENT SPEC** → `04_agents/NN_*.md`, plus a decision entry if a *choice*
  drove the change.

One session item can produce entries in more than one place (a decision that also
bumps an agent's status and adds a backlog follow-up). That's normal — list all.

## Formats (fall back to these; prefer the live vault files)

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

Keep **Decision:** to one line. If you can't, the decision isn't crisp yet — split it.

**Deferred** (`06b_deferred-decisions.md`) — grouped under a `## AGENT` header:

```
### Title
**Origin:** which decision/spec/fork this came out of (#NNN, file).
**What:** the parked option, concretely.
**Why parked:** the reason it was set aside now (link the principle if one governs).
**Revisit trigger:** the specific condition/data that should bring it back.
```

**Principle** (`01_principles.md`) — `## N. Title` + a short prose paragraph stating
the commitment and its consequence. Rare. If added, every decision that applies it
should reference `01_principles.md #N`.

**Backlog** (`07_backlog.md`) — a line item, not an ADR. No rationale block.

## Guardrails (run before presenting)

**Principle vs decision** — the recurring error. Recall-over-precision is **principle
#16**, *not* a decision; decisions *cite* it. Test: "Would this sentence still be true
and useful across unrelated future agents?" If yes → principle. If it's a choice about
*this* system *now* → decision. When unsure, it's a decision. Do not mint new
principles to dignify ordinary decisions.

**Linkage discipline** — every decision's **Related:** must carry, where they exist:
(a) the decision(s) it amends or supersedes, (b) the principle(s) it applies,
(c) sibling decisions from the same session, (d) the agent/spec file it touches, and
`*Files:*` for code. A decision with no Related line is almost always under-linked —
check again before accepting it.

**Amendment needs a real edit** — when a new decision *changes* an old one (removes a
carve-out, redefines a category, flips a default), say so explicitly in the briefing
under a short "Amendments needing an edit (not just append)" list, naming the old
`#NNN` and what in its body must change. The downstream skill edits the old note;
don't let it silently diverge from the new one.

**Numbering is best-effort and downstream-authoritative.** Propose sequential numbers
from the current max you read in `06_decisions-log.md`, but state once, near the top:
*"Numbers proposed; the vault-reconciliation skill assigns final ones — confirm against
the live max."* Don't agonize, don't renumber mid-briefing, don't burn tokens
reconciling — that's the other conversation's job.

**Terse house style** — conclusions first, no filler, no hedging, no marketing verbs.
Composes with the `de-slop` style layer. The briefing is read by a reconciliation
process and by Guillaume; both want signal.

## Output shape

```
# Vault brief — <area/agent>, YYYY-MM-DD

<1–2 line session summary: what materially changed.>

Numbers proposed; the vault-reconciliation skill assigns final ones (current max in
06_decisions-log.md = #NNN). Apply prior unapplied briefs first if any are open.

## Principles  → 01_principles.md        (omit the section if none — usually none)
## Decisions  → 06_decisions-log.md
## Deferred   → 06b_deferred-decisions.md
## Backlog    → 07_backlog.md
## Agent spec → 04_agents/NN_*.md         (status/trigger/IO changes)

## Amendments needing an edit (not just append)
- #NNN — <what in the old note must change, and why>

## Open / next (carry-forward — NOT for the vault)
<the running thread for the next session; not vault content>
```

Omit empty sections. Lead with whatever dominated the session (often Decisions).

## After presenting

Say explicitly: this is the input for the vault-reconciliation conversation — paste it
there and let Claude Code write the vault. Don't claim anything was written to the
vault from here.
