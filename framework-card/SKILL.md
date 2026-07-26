---
name: framework-card
description: Create, enrich, or review framework cards in Guillaume's ai-stack vault (20_frameworks/) per the SPEC-framework-library-v1.5 contract. Trigger when he wants to add, draft, promote, or enrich a framework card, run a coherence pass over a card class, work the Phase 2/3 backlog, process inventory rows, regenerate 00_INDEX.md, or names any strategy/marketing/innovation/ops/finance framework to file. Works on any surface (Claude Code, Cowork, claude.ai); filing adapts, the card contract never does. Not for applying a framework to a company/deal (30_finance/.../agent-drafts/), source-note frontmatter (vault-source-frontmatter), or pure corporate-finance mechanics that only enrich an existing card (#131 — finance courses are otherwise in scope, #162).
---

# framework-card

Enforcement layer for the vault framework library. The design authority is
`10_stack/specs/SPEC-framework-library-v1_5.md` in the vault — read it if a situation
falls outside this file. Cards live flat in `20_frameworks/`, one file per framework,
`<framework-name>.md` (lowercase kebab). The index `00_INDEX.md` is the selection
interface; cards are the source of truth and the index is regenerable from their frontmatter.
Library state: **302 cards, 34/34 ESADE courses, ten of ten classes coherence-passed.**

## Execution surfaces

The card contract below is identical everywhere. Only the filing mechanics change.
One machine per session, never two on the same files. Git is authoritative
(remote `homeserver:git/ai-stack-vault.git`); never rely on Obsidian Sync.

**Shell on the vault clone** (Claude Code, or Cowork running on-computer):
`git pull` before the first write of a session, commit after every card write.
Commit message: short imperative, e.g. `framework-card: add porters-five-forces`.

**Cloud Cowork** (vault reached over the device bridge, no shell on Guillaume's machine):
- Stage what the session needs: `_template_framework.md`, `00_INDEX.md`, the Phase 1 inventory,
  the card's sources from `00_sources/`. Staged copies are snapshots.
- Guard every write with the mtime captured at staging. A rejection means Guillaume edited it
  meanwhile: re-stage, re-apply, never force.
- **The bridge throttles (HTTP 429).** Batches of ~20–30, serialised — never parallel stage
  calls. Batches return per-file errors; re-stage failures, don't assume the batch landed.
- **Mount-cache trap:** stage metadata (bytes/mtime) is authoritative for device state, but
  staged *content* can lag. Verify the local copy matches the reported byte size before
  building on it; if it matches, trust the local copy over a re-stage.
- **For a sweep over >50 files, hand Guillaume a validated script rather than committing each
  file over the bridge** — cheaper, atomic under git, dodges the throttle. Test it against the
  staged copies and report the exact file count and byte delta so he can verify the run.
- You cannot run git. End every write with the exact
  `git add … && git commit -m "framework-card: …" && git push` block. The card is not done
  until he has committed or explicitly deferred — say so rather than letting it hang.

**claude.ai chat** (no vault access at all):
- Produce the card file and the index row as downloadable output; never claim anything was
  filed — filing is Guillaume's step or a follow-up Cowork/Claude Code session.
- Dedup and wikilink resolution can't be verified against the live vault. Compensate:
  take lineage filenames verbatim from the Phase 1 inventory row, and ask Guillaume to
  confirm the card doesn't already exist before drafting.
- Hand the result to the vault-brief flow if one is running; otherwise state plainly what
  still needs doing (file card, append index row, commit).

## Card contract

Frontmatter — every field present, hyphenated names, CRLF file:

```yaml
---
type: framework
name: Porter's Five Forces            # canonical, attribution-correct
aliases: [Five Forces, 5F]            # what people actually type
domain: strategy                      # one primary; enum: strategy|marketing|innovation|ops|org|negotiation|finance|other
tier: core | tail
status: reviewed | unreviewed          # reviewed requires a NON-DRAFTER pass
problem-signatures: [ma-screening, market-entry, competitive-position]
lineage:
  sources:                            # actual 00_sources/ filenames, plain strings
    - "2026-07-14_strategy-w3-deck2-industry-analysis"
  enrichment: true                    # model knowledge added beyond sources
generated-by-model: Opus 5            # drafting model — set once, immutable (short name, not the API id)
enriched-by-model: Opus 5             # latest enrichment pass — overwritten each pass
created: 2026-07-15
updated: 2026-07-15
tags: [p/frameworks, t/strategy]      # optional 3rd slot: k/<knowledge-class>
---
```

`finance` is a legal domain (v1.5); **`macro` is not** — macro and basic-business-knowledge
material stays `domain: other` and carries `k/basic-business-knowledge`. The `k/` slot is
optional and its namespace is open **flag-then-rule**: propose a new value, never mint one silently.

Body sections, all present and in this order; write "n/a" only when true. **No top-level H1 —
absolute, no exemption:** the body opens at `## What it is`. (The 204 legacy cards that carried
one were retrofitted 2026-07-26; there is nothing left to grandfather.)

1. **What it is** — 3–5 lines, board-level.
2. **When to reach for it** — situations Guillaume actually faces (MD/DG-level strategy,
   M&A, turnaround, innovation work), mapped to the problem-signature vocabulary.
3. **When NOT to use it / pitfalls** — the section slides never contain; primary
   enrichment target. A reviewed card needs at least one non-trivial entry here.
4. **Inputs required** — data/facts needed before the framework produces anything.
5. **Steps** — how to run it, compressed.
6. **Outputs** — what a completed application looks like.
7. **Adjacent & confusable** — pairs-with and mistaken-for (e.g. Porter ≠ 4 Ps).
   **Card references are `[[wikilinks]]` to the card slug;** non-carded concepts
   (Schein, Kübler-Ross, …) stay plain text. **A wikilink may not point at a card that does
   not exist, unless that card lands in the same batch** — otherwise plain text until it does.
   Legacy plain-name refs conform on every card you touch; ~30 remain (innovation, org,
   other, marketing) — don't mass-rewrite.
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

The set is **frozen**: it carried the full 34-course extraction, finance included, without a
strain-driven addition. You may propose an addition, but flag it explicitly and get
Guillaume's yes — never invent a tag silently. Known overload (parked, 06b): `ma-screening`
sits on 41 of 78 strategy cards.

## Modes

**create** — framework name + source excerpts or pointers into `00_sources/` (inventory rows
carry the exact filenames — copy them, don't re-derive spellings). Draft the full card first,
then ask **max 5 clarification questions**, prioritized: (1) which problem signatures, in
Guillaume's terms; (2) where has he seen it break in practice (feeds pitfalls); (3) professor
variant worth keeping. File the card, append the index row, close out per the surface.

**course batch** — the default for working the inventory: pull the course's rows → propose a
disposition cut (core / tail / drop / merge) in ONE question set, GS rules → stage sources →
draft all cards → ONE batched clarification pass (≤5 questions total) → file together → one
`vault-briefing`-shaped brief to `01_inbox/` + the `esade-course-status.md` tracker update.
**Dedup-hit protocol:** an already-carded row is a dedup hit — merge lineage/course notes
into the existing card, mandatory cross-reference at batch time, heavy enrichment deferred.
**Integrated-course pattern:** a course that is one framework in per-session fragments gets
architecture-mapped first, then an umbrella / hub-and-spoke proposal for GS's structural
ruling — never atomic tool-rows.

**enrich** — existing card + model knowledge. Set `enrichment: true`, bump `enriched-by-model`;
enrichment lands mostly in *pitfalls* and *adjacent*. Bump `updated:`, file per surface.

**review** — promote `unreviewed → reviewed`: run the clarification loop against the
existing draft, tighten the prose, verify the contract (esp. a real pitfalls entry),
re-file, update the index row. **You may not promote a card you drafted.** `reviewed`
asserts a second reader checked it, not that the drafter was satisfied. Self-stamped flags
have been reset twice (#190 ethics 19/19; #191 strategy 52 → 4 survivors). A genuine
non-drafter review pass has never been run — say so rather than implying otherwise.

**coherence pass** — per-class dedup & cross-reference maintenance. Scope a class (a domain
or problem-signature slice) → stage it → frontmatter/alias collision scan + Adjacent
cross-walk → full-body verification by a second agent (test suspected overlaps, hunt missed
ones, check shared facts across cards) → **report first**: merges, missing backlinks,
prose-overlap, consistency nits, each with a recommendation → GS rules → batch-edit. Merges
obey the one-card rule: absorb aliases, lineage, course notes; delete the loser via git;
repoint inbound refs; one index row. Ends with the standard brief to `01_inbox/`.
All ten classes are passed — there is no next class; remaining work is verification.

## Hard rules

- **Dedup:** before creating, search existing cards' `name` and `aliases`. On collision,
  refuse to create a second card — merge lineage and course notes into the existing one
  instead. One card per framework, no matter how many courses teach it.
- **Lineage integrity:** every Sources wikilink must resolve to an existing
  `00_sources/*.md` file — verify where the surface allows. No card without lineage.
- **Provenance:** `generated-by-model` is the original drafter — set once, never overwritten.
  `enriched-by-model` is overwritten on every enrichment pass. Both carry the model's short
  name (`Opus 5`, `Fable 5`), never the API id. Open debt: 84 cards carry `enrichment: true`
  with no `enriched-by-model`.
- **CRLF is a post-edit gate, not a final check.** After *every* file write, assert
  `raw.count(b"\n") == raw.count(b"\r\n")` on the bytes you just wrote. The `$`-anchored
  `re.sub` landmine matches before the `\r` and silently leaves a bare LF; it has bitten
  twice while documented (13 files in pass XII). Gate per write so damage stays local.
- **Verify against the source before correcting a card.** A card is wrong against its source
  only if the source has been read. Model knowledge about the canonical version of a
  framework is evidence about the canon, not about the deck.
- **Measure before scoping.** A defect count inherited from prior passes is a floor, not a
  measurement. Three counts have been off by 2–4.5x when measured library-wide (wikilink debt
  45→189, H1 drift 45→204, provenance holes 20→84). Count across all cards before you scope,
  cost or close a sweep, and record the measurement.
- **`updated:`** bumped on every body change — but **not** for provenance or cosmetic-convention
  edits (the #147 precedent; the 204-card H1 retrofit left `updated:` untouched).
- **Draws-on beats verbatim:** the inventory row's occurrence list is the authoritative
  *spelling* of filenames, not an obligation to cite them all. Strike occurrences that don't
  inform the card — flag the strikes so GS can veto.
- **Tier is operator usefulness**, not evidence quality or depth (`six-sigma` kept core on
  thin sources; `scor` demoted on the same evidence).
- **Scope (#162):** finance courses in scope, carded drop-heavy / thin-core / near-zero-tail.
  Card the topic where *the number drives a debate or a decision*, not the number itself.
  The #131 boundary holds: cross-domain finance mechanics enrich existing cards, not new ones.
- **Index:** one row per card: `| Name | Aliases | Domain | Reach for it when… | Tier | Status |`.
  The "reach for it when" cell is one line — it does the selection work. 7 pipes per row.
- **Prose register:** de-slop applies — direct, concrete, no filler. The card is for a
  reader who runs deals, not a student.
- **Boundaries:** never write into `00_sources/`, `40_courses/`, `90_meta/`, or the **vault
  root**. Never write `06c_update-log.md` or `06_decisions-log.md` — the reconciliation line
  owns both. Framework *applications* go to `30_finance/.../agent-drafts/`, not here.
