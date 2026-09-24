---
name: "vault-briefing"
description: "Produce a structured session-to-vault briefing for Guillaume's ai-stack vault (C:\\dev\\_ai_vault) or career vault (C:\\dev\\_career_vault); lands it in 01_inbox/. The only way a career application chat changes the spine."
---

# Vault briefing

## What this is

A briefing is the **structured handoff** between a working session and a vault. The
session that produced the material does not write the spine of the vault — a separate
reconciliation conversation does, after checking the brief against the live files.

So the job here is **not** to produce finished vault notes. It is to produce a clean,
correctly-classified, fully-linked briefing the downstream conversation can apply
**mechanically**, without re-deriving intent. Get the classification and the
cross-references right; let the downstream own final numbering and the on-disk write.

## Mode gate — settle this first, before anything else

The two vaults have **disjoint numbering spaces and different target files.** Mixing
them is the exact collision `C-001` was created to prevent. So:

1. Determine the mode from the work in the session — which vault it read or wrote, or
   what it was about (an application, a hand-off, a CV or letter → career; an agent, the
   stack, `C:\dev\ai-stack-agents`, `pdf_to_md` → ai-stack):
   - `C:\dev\_ai_vault` → **ai-stack mode** → read `references/ai-stack.md`
   - `C:\dev\_career_vault` → **career mode** → read **§ Career mode** at the foot of this file.
     (The claude.ai copy's `references/career.md` is superseded by it — 2026-09-24,
     `C-233` — and is not carried here.)
2. If the session touched both, or neither is clear, **ask which vault this brief is
   for.** Do not guess, and never write one brief spanning both.
3. Read **only** the reference file for the active mode. The other vault's numbering,
   file names and classification tree are not to appear in the brief. `#NNN` always
   means an ai-stack decision, in both vaults; `C-NNN` always means a career decision
   and is never re-minted in ai-stack.

Everything below is common to both modes, up to § Career mode. The mode's reference (the ai-stack file, or § Career mode) holds the targets, the
classification tree, the entry formats and the mode-specific guardrails, and it wins
wherever it is more specific.

## Workflow

1. **Inventory the session.** Walk what was actually *settled* — not what was
   discussed. A decision is something that changed the design or the plan. Exploration
   that led nowhere is not a vault entry. Argument and iteration stay in the chat and
   evaporate by design; that is what the chat is for.
2. **Read the live files** for the active mode (cheap, best-effort — one read each) to
   get the current numbering and the live entry shape. The vault is the source of
   truth; prefer it over the templates in the reference file. If the files are not
   reachable, fall back to the templates and mark numbering `(next available — confirm)`.
3. **Classify each item** with the mode's decision tree.
4. **Draft each entry** in the matching format, with its cross-reference line.
5. **Run the guardrails** — the shared ones below, then the mode's own.
6. **Write the brief, then deliver it** per Delivery. State plainly that it is an input
   for the reconciliation conversation, not a vault write.

## Shared guardrails

**Settled, not discussed.** If it needs one more decision from Guillaume before it can
be applied, it is not a brief item — it is an open question, and it goes in the
carry-forward section at the bottom, marked as such.

**Numbering is proposed, never assigned.** Propose sequential numbers from the live max
you actually read, and say once near the top: *numbers proposed; the reconciliation
conversation greps the live max and assigns final ones.* Never trust a number quoted in
a chat or in an earlier brief. Do not renumber mid-brief.

**Amendment needs a real edit.** When a new entry *changes* an old one — removes a
carve-out, redefines a category, flips a default — say so explicitly under
**Amendments needing an edit (not just append)**, naming the old entry and what in its
body must change. Cross-referencing is not amending; a silently diverging pair of
entries is worse than either alone.

**Linkage discipline.** Every entry carries what it amends or supersedes, the principle
or ruling it applies, its siblings from the same session, and the file it touches. An
entry with no link line is almost always under-linked — check again before accepting it.

**One conversation, one brief, written and committed at its close (C-104).** The unit is
the conversation, not the topic and not the work item: a session that settled four
subjects emits one brief covering four subjects. **A companion proposal is not a second
brief** — `C-049` rules them different objects, and a brief plus the proposal it
incorporates is one emission.

**A second brief is permitted in exactly one case: a fact arrived after the first was
committed.** It names the commit of the first and states what could not have been known
when the first was written. Nothing else qualifies — not length, not a new topic, not a
convenient checkpoint. *A committed brief cannot be amended without editing the record,
so the second file is the honest remedy; the rule's job is to keep it the exception
rather than a cadence.* **The interim-checkpoint exception was offered and refused** — it
hands the judgement of *long* to the chat, and a chat that has just done a lot of work
believes itself long.

⚠ **The cost is real and accepted: a session that dies before its close takes its brief
with it.** The mitigation is `C-080` — say how much context is left, as a statement and
never as a question, at roughly a fifth remaining — and it is a warning, not an
instrument.

*Ruled in the career vault, binding on every chat there. In ai-stack mode the same shape
applies as house practice; it is not separately ruled.*

**One brief per session, applied once, then deleted.** The brief is transport, not
archive. When the reconciliation conversation has applied every item, it **deletes the
file from `01_inbox/`, in the same commit that carries the applied spine changes.** The
record of the handoff lives in git — `git log --diff-filter=D -- 01_inbox/` is the
ledger, and the deleting commit is also the one that shows what the brief became — not
in a stamped file left behind. An inbox that accumulates archived briefs stops answering
the only question it exists to answer: *what is still pending?*

Two preconditions bind the delete, and both are hard:
- **Committed first.** Never delete a brief that has never been in a commit — that
  erases the handoff outright instead of archiving it. If the vault is not a git repo,
  or the brief is untracked, it is not deleted; say so and stop.
- **Fully applied.** A partially applied brief is not deleted. It stays with the applied
  items struck through and `status: partial`, and the remainder carries to the next pass.

The briefing chat does not perform this delete — it never touches `01_inbox/` beyond
landing the file. It carries the instruction *inside* the brief, where the reconciliation
conversation will read it.

**Terse house style.** Conclusions first. No filler, no hedging, no marketing verbs.
Composes with `de-slop`. The brief is read by a reconciliation process and by Guillaume;
both want signal.

## Output shape

```
# Vault brief — <vault> · <area / slug>, YYYY-MM-DD

<1–2 lines: what materially changed this session.>

Numbers proposed; the reconciliation conversation assigns final ones (live max read =
<N>). Apply any earlier unapplied brief first.

## <sections, per the active mode's classification tree — omit the empty ones>

## Amendments needing an edit (not just append)
- <entry> — what in the old body must change, and why

## Open / next — carry-forward, NOT for the vault
<the running thread for the next session, and every question still owed a ruling>

---
**Disposal.** Applied in full → delete this file from `01_inbox/` in the same commit as
the spine changes it produced (`vault: apply <filename>`). Applied in part → strike the
applied items, set `status: partial`, keep it. Never delete it before it is committed.
```

Lead with whatever dominated the session. **The disposal footer is not optional** — it is
what makes the delete happen, since the reconciliation conversation reads the brief and
not this skill.

## Delivery — always land it in that vault's 01_inbox/

`01_inbox/` is the standing staging folder for exactly this kind of written-but-not-yet-
applied material, in both vaults. The brief belongs there every time, not only when asked.

This is the Claude Code copy: the vaults are on local disk, so the brief is written
straight into the inbox. There is no `/mnt/user-data/outputs/` and no desktop bridge.

1. **Resolve the vault root.** `C:\dev\_ai_vault` and `C:\dev\_career_vault`, on both
   machines. If the root is missing, find it by marker. **Both vaults contain
   `06_decisions-log.md`, so that file alone does not tell them apart**: `04_agents/`
   means ai-stack, `20_applications/` means career. Never fall back to the scratchpad or
   a temp dir. If the inbox cannot be found, say so and ask, rather than saving the file
   where nobody will look.
2. **Write the brief to `<vault root>\01_inbox\<filename>`.** The mode's reference gives
   the filename convention. Plain LF is fine; the reconciliation write enforces CRLF.
   Writing into `01_inbox/` is the one write this skill makes. It stages the handoff and
   does not write the vault.
3. Call `SendUserFile` on it so it also appears in the chat, then say plainly: *saved to
   `01_inbox/<filename>`. Pick it up from there in the reconciliation conversation.*
   **Never claim it reached `01_inbox/` when the write failed.**
4. **Commit the brief.** The message is `vault: brief <filename>`. The reconciliation
   conversation later commits `vault: apply <filename>`, and that second commit removes
   the file. The two commits are the whole audit trail: one creates the handoff and one
   consumes it. There is a shell here, so **offer to run the commit instead of assuming
   you should**, staging only the brief (`git add 01_inbox/<filename>`), never `-A`. If he
   would rather run it himself, give the block: open with `cd <absolute vault path>`, then
   bare git commands. Do not put `git -C` on every line. He switches between the two
   vaults within the same hour, and `cd` leaves his shell in the right repo for whatever he
   types after the paste; `git -C` does not. Watch for the autocrlf phantom-dirty status
   in `_ai_vault` and do not stage files the session did not touch.

Delivery runs every time this skill produces a brief. He does not have to ask for it.

## After presenting

Say explicitly: this is the input for the reconciliation conversation. Nothing was
written to the vault spine from here, and in career mode nothing may be. Two lines to
close: what changed, and what is now due.

Add one line on the file's fate, so he is never surprised by its disappearance: *this
brief is consumed on apply — it is deleted from `01_inbox/` in the same commit as the
spine changes, and git holds the record.*

## Career mode — `C:\dev\_career_vault`

Active when the career vault is the target. Numbering here is `C-NNN`. A bare `#NNN` in
this vault always means an **ai-stack** decision and is never re-minted — reference it,
never renumber it.

### The rule this mode exists to enforce (C-014 · C-019, 2026-08-06)

**Only the campaign-documentation chat writes the spine.** Every other chat — one per
application, and the campaign-wide chats too (index sweeps, the monthly lessons pass,
positioning rewrites) — writes its own folder and **briefs everything else.**

| | Spine — brief it, never write it | Own territory — write it directly |
|---|---|---|
| Files | `00_INDEX.md` · `00_README.md` · `06_decisions-log.md` · `06a_decisions-index.md` · `07_backlog.md` · `CLAUDE.md` · everything in `90_meta/` | `20_applications/<slug>/` · `20_applications/_network/<surname>/` · `30_lessons/agent-output/` · `01_inbox/` (the brief itself, and proposals) · `02_outbox/` |

`06a_decisions-index.md` is **generated** from the log and never hand-edited. Never brief a change to it — brief the decision, and the index regenerates.

Ten chats editing one index produce ten half-right indexes. One chat applying ten briefs
produces one index and a record of who changed what. That is the whole trade, and the
cost is real and accepted: **the index lags until the documentation chat runs.** A brief
that has sat unapplied for a week is a signal about session cadence, not a reason to
reach into the spine.

Unchanged and absolute regardless of chat: `handoff_<x>.md` is verbatim and never edited ·
nothing under `sent/` is ever modified · one live draft per document, no `_vN` siblings ·
**an existing file in `10_profile/` is never edited from an application chat** (C-023 - the documentation chat may edit it; the create-only limit binds every other chat), **except on GS's explicit in-session instruction, which any chat may act on, recording that it did and on whose instruction (C-036).**

**Nothing in this vault is GS-authored (C-019).** He rules, reviews and authorises; an agent
writes. The old wording called four targets GS-authored, which left nine drafted proposals
queued for five days behind a gate that was a category error. **For a briefing chat nothing
practical changes** — you still brief rather than write. What changes is the destination: the
documentation chat now **incorporates** your brief into the target file and deletes the note,
instead of parking a second proposal beside it.

### Classification tree

For each settled item, ask in order:

- **Is it state about one application** — stage moved, touchpoint held, closure written,
  a draft cut? → **write it in `20_applications/<slug>/`**, not in the brief. Then brief
  the *index consequence* (below), because the row is spine.
- **Is it state about one network contact** — a recruiter, forwarder or investor exchange
  that no application holds? → **write it in `20_applications/_network/<surname>/`**. A new
  contact gets the folder and `_hub_<surname>.md` from `_templates/_template_contact-hub.md`.
  No index row; a next step or due date is a `07_backlog.md` §0a row → **BACKLOG** (C-233).
- **Filenames and links (C-233).** Inside `<slug>/`, `<x>` is the slug minus its hand-off
  date: `_hub_<x>.md`, `_closure_<x>.md`, `handoff_<x>.md`. Every new note carries
  `hub: "[[_hub_<x>]]"` or `hub: "[[_hub_<surname>]]"` in its frontmatter; start from the
  template in `_templates/` and the field is already there.
- **Does it change a row in `00_INDEX.md`** — new row, stage or bucket move, next step,
  due date, sent date, counts? → **INDEX** → brief the row exactly as it should read
  after the change, plus the one-line *reported / inferred* note that belongs under it.
- **Was a campaign-level choice made** — a rule, a convention, a reversal, something that
  will govern the next application too? → **DECISION** → `06_decisions-log.md`, proposed
  as `C-NNN`. A choice that only affects this application is hub content, not a decision.
- **Is it work not yet done, a blocker, or something owed on a date?** → **BACKLOG** →
  `07_backlog.md`, and name the section: `§0` dated (give the date and the owner) · `§1`
  blocking before application number one · `§2` to build or decide · `§3` parked, with
  the reason · `§5` the mirror register, stamps only.
- **Does the vault now refer to a file that does not exist?** → **OWED REGISTER** →
  `07_backlog.md` §4, with what tracks it and who owns it. Skipping this is what makes
  the dangling-reference check fire on everything and catch nothing.
- **Does a spine or profile file need to change** — `10_profile/`, `90_meta/`, `CLAUDE.md`,
  `00_README.md`? → **INCORPORATION** → brief *what* must change and *why*, naming the target
  file. The documentation chat writes it into that file directly (C-019). Do not draft the
  finished file inside the brief.
- **Does `CLAUDE.md` need to change?** → **it also needs a `C-NNN`.** The constitution is a
  derived document: it may only be *transcribed* from a ruling that already exists in
  `06_decisions-log.md`, and every clause cites its decision. **A brief that proposes a
  `CLAUDE.md` change without proposing the decision behind it cannot be applied** — the
  documentation chat would have to legislate to act on it, which is exactly what the hash
  check in `07_backlog.md` §5 shouts about.
- **Does something have to leave this vault** — a spec for the job-search agent, a lesson
  bound for `_ai_vault`? → **OUTBOX** → `02_outbox/`. GS carries it by hand, one hop.
- **Is it a durable lesson from a closure?** → write it into `30_lessons/agent-output/`
  directly and mention it in the brief in one line. Never promote to `_ai_vault` from
  here; the aggregate is the unit, never a single application.

One item can land in several places — a decision that also moves an index row and opens
a dated backlog item. That is normal. List all of them.

### Formats

**Index row** — give the finished row, in the target bucket's column order, ready to
paste. Say which bucket it leaves and which it enters. If the change needs a note under
the table, write the note in full, labelled.

**Decision** (`06_decisions-log.md`), entries separated by `---`:

```
### C-NNN — Title in one line

**YYYY-MM-DD · GS ruling | agent-proposed · in force | proposed — awaiting GS**

What was decided, in one line.

**Why:** the reasoning that survives the week.

**Consequence:** what now has to change elsewhere — files, checks, obligations.
```

Status vocabulary is exactly: `in force` · `proposed — awaiting GS` · `superseded by
C-NNN` · `retracted`.

**Status depends on how the item was settled, not on who typed it (C-019, clarified
2026-08-06).** Authorisation takes three forms and **all three are sufficient**:

1. an explicit GS ruling;
2. a standing rule already in `06_decisions-log.md` — transcription follows automatically;
3. **work done with GS in session, with the choice announced and not vetoed.**

Form 3 is the common one and it is the one briefs get wrong. **If your session settled
something that way, the entry is `in force`, and the brief says which form applies** — one
line naming it, because the documentation chat cannot see your session.

`proposed — awaiting GS` is for a question genuinely open to GS: a trade-off only he can
price, a fact only he holds. **It is not a place to park a judgement you are capable of
making.** *An agent's own idea, unannounced, arriving inside a brief is not authorised, and
that status is correct for it.*

**Backlog** — a line item in the named section. `§0` rows are a table: date, item, owner.
No rationale block; a backlog item that needs an ADR is a decision wearing a disguise.

**Owed register** — `| owed file | tracked by | owner |`.

### Guardrails — on top of the shared ones

**Reported vs inferred, on every line.** Not a style preference: it is the rule that
makes the record admissible. ***Reported (GS, YYYY-MM-DD):*** *what he actually said or
what the artefact actually contains.* ***Inferred:*** *the reading, owned as a reading.*
A brief that blurs them writes an impression into the vault as evidence, and the monthly
pass will read it back as fact.

**No `fit_score`, no band, no scorer reasoning — anywhere in the brief.** Those live in
the job-search DB (authoritative) and in the frozen `handoff_<x>.md` (snapshot). A brief that
carries one into `00_INDEX.md` creates two answers to one question. Reference the DB row
id instead.

**`C-NNN` is proposed only.** Grep the live max in `06_decisions-log.md` if reachable;
otherwise write `C-NNN (next available — confirm)`. The documentation chat greps before
appending. This rule cost the other vault four days to learn.

**Do not draft the spine text wholesale.** Brief the *change*: the row as it should read,
the decision entry, the backlog line. A brief that contains a rewritten `00_INDEX.md` is
a chat writing the spine through a side door.

**Never write the spine to route around staleness.** The index lags until the documentation
chat runs; that is the accepted cost of C-014, not a defect. C-019 widened who may write, not
which chat.

**A stale due date is a brief item.** If a date in `§0` or in the index passed, or the
preconditions it was set against have closed, say so and propose the new date with the
reason. Nothing triggers that sweep — no artefact appears when a date passes.

### Filename and YAML

`01_inbox/YYYY-MM-DD_brief_<slug>.md`, where `<slug>` is the application slug for an
application chat (`2026-08-01_mediane_conf`) or a short topic for a campaign-wide chat
(`lessons-pass`, `index-sweep`).

**Two briefs in one day from one chat take `_a` / `_b` — and this is a filename rule, not
a licence.** Under `C-104` a second brief exists only where a fact arrived after the first
was committed; the suffix names that file, it does not authorise it. **If you are reaching
for `_b` for any other reason, the brief is not finished — it is not a second one.**

```yaml
---
type: inbox
status: draft
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [p/career, t/brief]
brief-from: <slug or topic>          # the chat that emitted it
applied:                             # blank; stamped only when the brief is applied in part
---
```

`type: inbox` because `CLAUDE.md`'s vocabulary has no other value for it and inventing
one breaks the YAML check. The `_brief_` infix is what makes briefs globbable and keeps
them distinguishable from proposals at a glance.

**One brief per session, applied once, then deleted** (`C-049` as amended). When the
reconciliation conversation has applied every item, it deletes the file from `01_inbox/`
in the same commit that carries the applied spine changes. **The record of the handoff
lives in git** — `git log --diff-filter=D -- 01_inbox/` is the ledger, and the deleting
commit is also the one that shows what the brief became. An inbox that accumulates
archived briefs stops answering the question it exists to answer.

**A partially applied brief is not deleted.** It stays with the applied items struck
through and `status: partial`, and the remainder carries to the next pass. Never delete a
brief that has never been in a commit — that erases the handoff instead of archiving it.