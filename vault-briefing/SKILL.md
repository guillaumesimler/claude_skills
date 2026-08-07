---
name: vault-briefing
description: >-
  Produce a structured session-to-vault briefing for one of Guillaume's two vaults —
  the ai-stack vault at C:\dev\_ai_vault, or the career vault at C:\dev\_career_vault.
  Use whenever he says "prepare the brief", "wrap up the work for the vault", "vault
  read", "prepare the vault element", or runs /vault-brief — and at the end of any
  session that settled something the vault has to hold: decisions, amendments,
  deferrals, principles, backlog, index rows, application state. In the career vault
  this is also the ONLY way an application chat may change the spine files
  (00_INDEX.md, 00_README.md, 06_decisions-log.md, 07_backlog.md, CLAUDE.md,
  90_meta/) — it briefs, the governance chat writes. Sorts each item into its correct
  vault home and enforces the cross-reference discipline. Always lands the finished
  brief in that vault's 01_inbox/ when a desktop is connected, not just as a chat
  download. Do NOT write the spine directly, and do NOT handle source-note frontmatter
  (that's vault-source-frontmatter).
---

# Vault briefing

## What this is

A briefing is the **structured handoff** between a working session and one of the two
vaults. The session that did the work does not write the governed files; it states the
change it needs, and a single downstream owner applies it with final numbering.

The job is **not** to produce finished vault notes. It is to produce a clean,
correctly-classified, fully-linked brief the downstream can apply mechanically without
re-deriving intent. Get classification and cross-references right; let the downstream
own final numbering and the on-disk write of the governed files.

Two vaults, two contracts. **Pick the mode first — they differ in filename, YAML,
targets, number space, and who applies the brief.** Everything below is marked
`[ai-stack]`, `[career]`, or applies to both.

## Step 0 — which vault

Ask, in order:

- Did the session touch `C:\dev\_career_vault`, an application, a hand-off, a CV or
  letter, a touchpoint, a closure? → **career mode**.
- Did it touch `C:\dev\_ai_vault`, an agent, the stack, code in `C:\dev\ai-stack-agents`
  or `pdf_to_md`? → **ai-stack mode**.
- Both? → **two briefs, one per vault.** Never one brief spanning both. `90_meta/bridge.md`
  is explicit: a file that exists in both vaults is a defect, and so is a brief that
  proposes into both. If a career ruling turns out to be about the stack, it is
  *proposed* into `_ai_vault/01_inbox/` and **re-minted there as its own `#NNN`** — it
  never keeps its `C-` number.

Vault roots are `C:\dev\_ai_vault` and `C:\dev\_career_vault` on both machines. If a
root is missing, locate it by marker — **both vaults contain `06_decisions-log.md`, so
that file alone does not disambiguate**: `04_agents/` means ai-stack, `20_applications/`
means career. Do **not** fall back to the scratchpad or a temp directory. If the inbox
cannot be found, say so and ask, rather than saving where nobody looks.

## Where the brief lands

**`[ai-stack]`** — `<vault>\01_inbox\YYYY-MM-DD_vault-brief-<area>.md`. Plain LF is fine;
the reconciliation line enforces CRLF on the vault write. Applied by the **separate
vault-reconciliation conversation**, which has been the single source of truth for that
vault's decisions log since VII.

**`[career]`** — `<vault>\01_inbox\YYYY-MM-DD_brief_<slug>.md`. Two in one day from one
chat take `_a` / `_b`. Required YAML:

```yaml
---
type: inbox
status: draft
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [p/career, t/brief]
brief-from: <the emitting chat — application slug, or the campaign-wide task>
applied:
---
```

`applied:` stays blank; the **campaign-documentation chat** stamps it. An applied brief
is not deleted — it goes `status: archived` with `applied:` filled, because it is the
only record that the handoff happened.

**Always write the file when a desktop is connected.** A brief that exists only as chat
text or a download has not been handed off. If there is no filesystem (plain claude.ai),
say so plainly and give the full file content for Guillaume to paste.

## Trigger

`/vault-brief`, or: "prepare the brief", "wrap up the work for the vault", "vault read",
"prepare the vault element", "log this to the vault". Also fire proactively at the end of
a session that settled vault-worthy items, and offer to brief.

**`[career]` this is not optional.** Any session that wrote to the career vault ends with
a brief. A session that changed application state and left no brief **has lost that state
to the chat** — the folder holds the application, the spine holds the campaign, and
nothing else reconciles them.

## Workflow

1. **Inventory the session.** What was *settled*, not what was discussed. A decision
   changed the design or the plan. Exploration that led nowhere is not an entry.
2. **Read the live format and current numbering** (cheap, best-effort — one read each).
   `[ai-stack]` `06_decisions-log.md` for max `#NNN`, `06b_deferred-decisions.md`,
   `01_principles.md`. `[career]` `06a_decisions-index.md` for max `C-NNN`, `00_INDEX.md`
   for the live row shape, `07_backlog.md` for section names. The live files beat the
   templates below.
3. **Classify each item** into its vault home (tree below).
4. **Draft each entry** in the matching format, with a **Related:** line.
5. **Run the guardrails.**
6. **Write the brief to `01_inbox/`** and present it. State plainly that it is an input,
   not an application.

## Classification — `[ai-stack]`

- **Reusable rule that should govern future decisions?** → **PRINCIPLE** →
  `01_principles.md`. *Rare.* Most things that feel like principles are decisions that
  *apply* one.
- **Concrete choice made and acted on?** → **DECISION** → `06_decisions-log.md`. If it
  changes an existing decision's rubric/policy/scope it is still a *new numbered
  decision*, titled `(amends #MMM)`, linking #MMM in **Related:**.
- **Considered and explicitly parked, with a revisit trigger?** → **DEFERRED** →
  `06b_deferred-decisions.md`. No trigger → it's backlog.
- **Not-built-yet work, no fork?** → **BACKLOG** → `07_backlog.md`.
- **Agent spec/status/runbook changed?** → **AGENT SPEC** → `04_agents/NN_*.md`, plus a
  decision if a *choice* drove it.

## Classification — `[career]`

The spine is seven files: `00_INDEX.md`, `00_README.md`, `06_decisions-log.md`,
`06a_decisions-index.md`, `07_backlog.md`, `CLAUDE.md`, everything in `90_meta/`.
**A change to any of them is briefed, never written** (C-014).

- **A ruling — anything normative, or anything that resolves a contradiction?** →
  **`C-NNN`** → `06_decisions-log.md`, appended by the documentation chat. Propose the
  number as *unassigned*.
- **An application moved** (created, sent, stage change, closed)? → **INDEX ROW** →
  `00_INDEX.md`. Buckets: 1 Drafting · 2 Applying · 3 Negotiating · 4 Closed
  (4a Rejected — ended by them / 4b Refused — ended by me). State the row **as it should
  read**, and the bucket it moves from and to.
- **Work not yet done?** → **BACKLOG** → `07_backlog.md`, **naming the section**: §0
  Dated · §1 Blocking · §2 To build or decide · §3 Parked · §4 Owed register · §5 Mirror
  register.
- **Considered and parked?** → `07_backlog.md` **§3**, with the reason. There is no
  `06b_deferred-decisions.md` in this vault — do not invent one.
- **A GS-owned or profile file now needs a change** (`10_profile/`)? → say which file and
  what it needs. Do not edit an existing one unless you are the documentation chat (C-023).
- **`06a_decisions-index.md` is generated from the log and never hand-edited.** Never
  brief a change to it; it follows the log automatically.

**State the change, not the rewritten file.** A brief containing a rewritten
`00_INDEX.md` is a chat writing the spine through a side door.

## Formats (prefer the live files)

**Decision — `[ai-stack]`** (`06_decisions-log.md`), ADR, entries separated by `---`:

```
## NNN — YYYY-MM-DD — Title  [· optional ✅ CLOSED / ⚠️ REVISED badge]

**Decision:** what was decided, in one line.
**Alternatives considered:** what else was on the table ("rejected — why").
**Rationale:** why this won.   ← or **Fix:** / **Mechanism:** / **Firing rules:** /
                                  **Live result:** as content demands; labels flexible,
                                  the one-line Decision is not.
**Revisit when:** the condition that should trigger reconsideration.
**Related:** #NNN, `01_principles.md #NN`, `04_agents/..md`.  *Files:* code touched.
```

**Decision — `[career]`** (`06_decisions-log.md`) — same discipline, `C-NNN` space,
number proposed unassigned. Two rules specific to this vault:

- **A `C-NNN` entry never cites an `01_inbox/` path** (C-019). Inbox notes are
  incorporated and deleted; an append-only log must not name a disposable file.
- If the ruling belongs in `CLAUDE.md`, say so — that file is **derived**, and a clause
  there without a `C-NNN` citation is an agent legislating for itself.

**Deferred — `[ai-stack]`** (`06b_deferred-decisions.md`), under a `## AGENT` header:

```
### Title
**Origin:** which decision/spec/fork this came out of (#NNN, file).
**What:** the parked option, concretely.
**Why parked:** the reason it was set aside now (link the principle if one governs).
**Revisit trigger:** the specific condition/data that should bring it back.
```

**Principle** (`_ai_vault/01_principles.md`) — `## N. Title` + short prose. Rare, and
**ai-stack only**: `01_principles.md` is the constitution above both vaults and lives
there. A career session proposing one is proposing into `_ai_vault`.

**Backlog** — a line item, not an ADR. No rationale block. `[career]` name the section.

## Guardrails (run before presenting)

**Principle vs decision** — the recurring error. Recall-over-precision is **principle
#16**, not a decision; decisions *cite* it. Test: "Would this sentence still be true and
useful across unrelated future agents?" Yes → principle. A choice about *this* system
*now* → decision. When unsure, decision.

**Reported vs inferred — `[career]`, and the rule that makes the record trustworthy.**
Every agent-written line distinguishes them and labels the inference. "GS reports the
recruiter cited seniority" and "the reply reads as a seniority objection" are different
claims. A record that blurs them is worse than none, because it reads as evidence.

**Linkage discipline** — every decision's **Related:** carries, where they exist: what it
amends or supersedes, the principle(s) it applies, sibling decisions from the session, the
agent/spec file it touches, `*Files:*` for code. No Related line is almost always
under-linked.

**Reference namespace — never un-prefix.** `C-NNN` = career decision. Bare `#NNN` =
always an ai-stack decision, never re-minted in career. `#N` inside a principles
quotation = a principle. `D-NNN` = ai-stack deferred. `C-` is prefix-disjoint from the
others, which is the only reason a fourth space is acceptable.

**Amendment needs a real edit** — when a new decision *changes* an old one (removes a
carve-out, redefines a category, flips a default), list it under "Amendments needing an
edit (not just append)", naming the old number and what in its body must change.

**Numbering is proposed, downstream-authoritative.** Propose from the max you read, and
state once near the top: *"Numbers proposed; the downstream owner greps the live max
before appending."* Don't renumber mid-brief.

**Never copy the golden record.** The job-search SQLite row id belongs to the DB on
`homeserver`. Reference it; never restate `fit_score` or the scorer's reasoning in either
vault outside a frozen `handoff.md`. That is `01_principles.md` #3 breaking.

**Terse house style** — conclusions first, no filler, no hedging, no marketing verbs.
Composes with `de-slop`. The brief is read by a process and by Guillaume; both want signal.

## Output shape — `[ai-stack]`

```
# Vault brief — <area/agent>, YYYY-MM-DD

<1–2 line session summary: what materially changed.>

Numbers proposed; the vault-reconciliation skill assigns final ones (current max in
06_decisions-log.md = #NNN). Apply prior unapplied briefs first if any are open.

## Principles  → 01_principles.md        (omit if none — usually none)
## Decisions   → 06_decisions-log.md
## Deferred    → 06b_deferred-decisions.md
## Backlog     → 07_backlog.md
## Agent spec  → 04_agents/NN_*.md

## Amendments needing an edit (not just append)
- #NNN — <what in the old note must change, and why>

## Open / next (carry-forward — NOT for the vault)
```

## Output shape — `[career]`

```
<YAML: type: inbox · tags: [p/career, t/brief] · brief-from: · applied: blank>

# Brief — <slug>, YYYY-MM-DD

<1–2 lines: what changed, and what is now due.>

Numbers proposed; the documentation chat greps the live max before appending.

## Index rows  → 00_INDEX.md
- <row as it should read> — bucket N → bucket M, and why

## Decisions   → 06_decisions-log.md   (C-NNN, number unassigned)
## Backlog     → 07_backlog.md         (name the section: §0–§5)
## Constitution → CLAUDE.md            (only transcribing a C-NNN, cite it)
## Profile     → 10_profile/<file>     (what it needs; do not edit it here)

## Amendments needing an edit (not just append)

## Open / next (carry-forward — NOT for the vault)
```

Omit empty sections. Lead with whatever dominated the session.

## Ending a career session

The brief is step 1 of three. Also produce:

2. **One copy-pasteable git block**, opening with `cd C:\dev\_career_vault` (see
   `90_meta/git.md`). Message convention `<slug>: <what changed>`; vault-wide work uses
   `vault: <what>`. **Keep the *why* in the message** — for a `.docx` the diff shows
   almost nothing. In a surface with no shell, this block is how the commit happens at
   all; in Claude Code, offer to run it rather than assuming.
3. **Two lines**: what changed, and what is now due.

Commit points: hand-off landing · end of every drafting session, even mid-draft · send ·
every stage transition and touchpoint · the monthly pass.

**The project-doc mirror is not this session's job** — the documentation chat writes and
stamps the five mirrored files (C-015, C-016).

## After presenting

State where the file was written and who applies it: `[ai-stack]` the
vault-reconciliation conversation, `[career]` the campaign-documentation chat. Be precise
about what did and did not happen — **dropping a file into `01_inbox/` is staging, not a
vault write.** No governed entry (decisions log, principles, index row, agent spec) was
created or edited from here. The downstream owns application, final numbering, and CRLF.
