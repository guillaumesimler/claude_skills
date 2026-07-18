---
name: framework-card
description: |
  Create, enrich, or review framework cards in Guillaume's ai-stack vault (20_frameworks/)
  per the SPEC-framework-library-v1.3 contract. Trigger when he wants to add, draft, promote,
  or enrich a framework card, work the Phase 2/3 backlog, process inventory rows, regenerate
  00_INDEX.md, or names any strategy/marketing/innovation/ops framework to file. Works on any
  surface (Claude Code, Cowork, claude.ai); filing adapts, the card contract never does.
  Not for applying a framework to a company/deal (30_finance/.../agent-drafts/), source-note
  frontmatter (vault-source-frontmatter), or pure corporate-finance mechanics that only enrich
  an existing card (#131 — finance courses are otherwise in scope, #162).
---

# framework-card

Enforcement layer for the vault framework library. The design authority is
`10_stack/specs/SPEC-framework-library-v1_3.md` in the vault — read it if a situation
falls outside this file. Cards live flat in `20_frameworks/`, one file per framework,
`<framework-name>.md` (lowercase kebab). The index `00_INDEX.md` is the selection
interface; cards are the source of truth and the index is regenerable from their frontmatter.

## Execution surfaces

The card contract below is identical everywhere. Only the filing mechanics change.
One machine per session, never two on the same files. Git is authoritative
(remote `homeserver:git/ai-stack-vault.git`); never rely on Obsidian Sync.

**Shell on the vault clone** (Claude Code, or Cowork running on-computer):
`git pull` before the first write of a session, commit after every card write.
Commit message: short imperative, e.g. `framework-card: add porters-five-forces`.

**Cloud Cowork** (vault reached over the device bridge, no shell on Guillaume's machine):
- Get the vault folder connected, then stage what the session needs: `_template_framework.md`,
  `00_INDEX.md`, the Phase 1 inventory, and the card's source files from `00_sources/`.
- Staged copies are snapshots. Before writing back, guard `00_INDEX.md` (and any edited card)
  with the mtime captured at staging — a guard rejection means Guillaume edited it meanwhile:
  re-stage, re-apply, don't force.
- Bridge cache quirk: the stage result's metadata (bytes/mtime) is authoritative for device
  state, but the staged file's *content* can lag the mount cache. Before appending to a
  re-staged file, verify the local working copy matches the reported byte size; if it does,
  build on the local copy rather than the possibly-stale staged content.
- You cannot run git. End every card write by handing Guillaume the exact
  `git add … && git commit -m "framework-card: …" && git push` block. The card is not "done"
  until he has committed or explicitly deferred — say so rather than letting it hang silently.

**claude.ai chat** (no vault access at all):
- Produce the card file and the index row as downloadable output; never claim anything was
  filed — filing is Guillaume's step or a follow-up Cowork/Claude Code session.
- Dedup and wikilink resolution can't be verified against the live vault. Compensate:
  take lineage filenames verbatim from the Phase 1 inventory row (validated at generation),
  and ask Guillaume to confirm the card doesn't already exist before drafting.
- Hand the result to the vault-brief flow if one is running; otherwise state plainly what
  still needs doing (file card, append index row, commit).

## Card contract

Frontmatter — every field present, hyphenated names, CRLF file:

```yaml
---
type: framework
name: Porter's Five Forces            # canonical, attribution-correct
aliases: [Five Forces, 5F]            # what people actually type
domain: strategy                      # one primary; enum: strategy|marketing|innovation|ops|org|negotiation|other
tier: core | tail
status: reviewed | unreviewed
problem-signatures: [ma-screening, market-entry, competitive-position]
lineage:
  sources:                            # actual 00_sources/ filenames, plain strings
    - "2026-07-14_strategy-w3-deck2-industry-analysis"
  enrichment: true                    # model knowledge added beyond sources
generated-by-model: Opus 4.8          # drafting model — set once, immutable (short name, not the API id)
enriched-by-model: Opus 4.8           # latest enrichment pass — overwritten each pass
created: 2026-07-15
updated: 2026-07-15
tags: [p/frameworks, t/strategy]
---
```

Body sections, all present and in this order; write "n/a" only when true. **No top-level H1**
— the body opens at `## What it is` (legacy Fable cards that carry a `# Name` line keep it; no retrofit):

1. **What it is** — 3–5 lines, board-level.
2. **When to reach for it** — situations Guillaume actually faces (MD/DG-level strategy,
   M&A, turnaround, innovation work), mapped to the problem-signature vocabulary.
3. **When NOT to use it / pitfalls** — the section slides never contain; primary
   enrichment target. A reviewed card needs at least one non-trivial entry here.
4. **Inputs required** — data/facts needed before the framework produces anything.
5. **Steps** — how to run it, compressed.
6. **Outputs** — what a completed application looks like.
7. **Adjacent & confusable** — pairs-with and mistaken-for (e.g. Porter ≠ 4 Ps).
8. **Course notes** — professor variant, emphasis, worked examples, labelled by provider
   (**ESADE:** … / **HEC:** …). The only section allowed to be empty.
9. **Sources** — `[[wikilinks]]` to every `00_sources/` note the card draws on, decks AND
   articles. Canonical for the Obsidian graph; `lineage.sources` mirrors the same filenames
   as plain strings. Model enrichment is flagged in frontmatter, never linked.

Template: `20_frameworks/_template_framework.md`.

### Problem-signature controlled vocabulary

`turnaround-diagnosis · ma-screening · market-entry · competitive-position ·
portfolio-allocation · pricing · growth-strategy · innovation-pipeline · go-to-market ·
org-design · change-management · operating-model · negotiation · value-creation-plan ·
nonmarket-ethics · talent-management`

(`nonmarket-ethics` added 2026-07-16 — political/regulatory/nonmarket problems plus the
business-ethics corpus; communication content has no domain of its own, folding into
`negotiation` or `other`. `talent-management` added 2026-07-17 — hiring, performance,
development, derailment.) The set is **frozen**: it carried the full 28-course extraction
without strain-driven additions. You may propose an addition, but flag it explicitly and
get Guillaume's yes — never invent a tag silently.

## Modes

**create** — input: framework name + source excerpts or pointers into `00_sources/`
(Phase 1 inventory rows carry the exact filenames — copy them, don't re-derive spellings).
Draft the full card first, then ask **max 5 clarification questions**, prioritized:
(1) which problem signatures, in Guillaume's terms; (2) practice experience — where has
he seen it break (feeds pitfalls); (3) professor variant worth keeping. File the card,
append the index row, close out per the surface's filing mechanics.

**course batch** — the default for working the inventory (GS ruling 2026-07-16: this
replaces the solo disposition pass; the Disposition column is a record, not a gate).
Flow: pull the course's rows → propose a disposition cut (core / tail / drop / merge
candidates) in ONE question set, GS rules → stage sources → draft all cards → ONE batched
clarification pass (≤5 questions across the batch) → file everything together → one
`vault-briefing`-shaped brief to `01_inbox/` + the `esade-course-status.md` tracker update.
**Dedup-hit protocol:** a row whose framework is already carded is a dedup hit — do not
re-create; add the new course's occurrences to lineage and a labelled entry to Course
notes only where the new sources actually add content, plus the mandatory cross-reference
at batch time; heavy enrichment is deferred to a backward pass.
**Integrated-course pattern:** when a course is one framework taught in per-session
fragments (Bertini pricing #158; the ops systems #159), map the architecture first with a
dedicated agent over syllabus + decks, propose an umbrella + hub-and-spoke card set, and get
Guillaume's structural ruling — never card atomic tool-rows.

**enrich** — existing card + model knowledge. Set `enrichment: true`, bump `enriched-by-model`;
enrichment lands mostly in *pitfalls* and *adjacent*. Bump `updated:`, file per surface.

**review** — promote `unreviewed → reviewed`: run the clarification loop against the
existing draft, tighten the prose, verify the contract (esp. a real pitfalls entry),
re-file, update the index row, file per surface.

## Hard rules

- **Dedup:** before creating, search existing cards' `name` and `aliases`. On collision,
  refuse to create a second card — merge lineage and course notes into the existing one
  instead. One card per framework, no matter how many courses teach it.
- **Lineage integrity:** every Sources wikilink must resolve to an existing
  `00_sources/*.md` file — verify where the surface allows. No card without lineage: at
  least one source file or `enrichment: true` with the sources that do exist.
- **Provenance:** `generated-by-model` is the original drafter — set once, never overwritten,
  forward-only (cards predating 2026-07-17 may lack it; don't backfill from guesswork).
  `enriched-by-model` is overwritten on every enrichment pass. Both carry the model's short
  name (`Opus 4.8`, `Fable 5`), never the API id (`claude-opus-4-8`).
- **Draws-on beats verbatim** (GS ruling, 2026-07-16, first card): the inventory row's
  occurrence list is the authoritative *spelling* of filenames, not an obligation to cite
  them all. An occurrence that doesn't actually inform the card (a passing mention, an
  extraction false positive) is struck from lineage — flag the strikes to Guillaume so he
  can veto, and so the inventory row can carry the note.
- **Scope (#162, reverses the old finance ban):** finance courses are in scope, carded
  **drop-heavy / thin-core / near-zero-tail** — for a domain Guillaume knows cold, drop beats
  tail (a finance tail card is dead inventory). Card only finance frameworks non-obvious even
  to him or genuinely cross-domain. The #131 boundary holds: cross-domain finance mechanics
  (LTV/CAC/payback/burn) enrich existing cards, not new ones; pure accounting/corporate-finance
  content stays out.
- **Index:** append one row per card: `| Name | Aliases | Domain | Reach for it when… | Tier | Status |`.
  The "reach for it when" cell is one line — it does the selection work, make it earn its place.
- **Prose register:** de-slop applies — direct, concrete, no filler, no consultant-brochure
  tone. The card is for a reader who runs deals, not a student.
- **Mechanics:** CRLF line endings, valid YAML, `updated:` bumped on every body change
  (index frontmatter too, when a row is appended).
- **Boundaries:** never write into `00_sources/`, `40_courses/`, `90_meta/`, or the **vault
  root** (`00_README.md`, `CLAUDE.md`, the `06_*` logs, `07_backlog.md`, …). Never write
  `06c_update-log.md` or `06_decisions-log.md` — the reconciliation line owns both. Framework
  *applications* to companies/deals go to `30_finance/.../agent-drafts/`, not here.
