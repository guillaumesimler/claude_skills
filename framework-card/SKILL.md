---
name: framework-card
description: |
  Create, enrich, or review framework cards in Guillaume's ai-stack vault (20_frameworks/),
  enforcing the SPEC-framework-library-v1.2 card contract. Trigger whenever Guillaume wants to
  add a framework to the vault, draft framework cards from course sources, work through the
  Phase 2/3 card backlog, promote an unreviewed card, enrich a card with pitfalls or adjacent
  frameworks, or says things like "create a card for Porter's Five Forces", "framework card",
  "process the inventory rows", "review this card", or names any strategy/marketing/innovation
  framework he wants filed. Also trigger when regenerating 20_frameworks/00_INDEX.md.
  Do NOT use for applying a framework to a company or deal (that output goes to
  30_finance/.../agent-drafts/), for source-note frontmatter (vault-source-frontmatter),
  or for corporate-finance material (out of library scope).
---

# framework-card

Enforcement layer for the vault framework library. The design authority is
`10_stack/specs/SPEC-framework-library-v1_2.md` in the vault — read it if a situation
falls outside this file. Cards live flat in `20_frameworks/`, one file per framework,
`<framework-name>.md` (lowercase kebab). The index `00_INDEX.md` is the selection
interface; cards are the source of truth and the index is regenerable from their frontmatter.

**Execution surface:** card writes run from Cowork on the desktop vault clone (or wherever
Guillaume invokes this skill) — one machine per session, never two on the same files.
Git is authoritative (remote `homeserver:git/ai-stack-vault.git`): `git pull` before the
first write of a session, commit after every card write. Never rely on Obsidian Sync.

## Card contract

Frontmatter — every field present, hyphenated names, CRLF file:

```yaml
---
type: framework
name: Porter's Five Forces            # canonical, attribution-correct
aliases: [Five Forces, 5F]            # what people actually type
domain: strategy                      # one primary domain
tier: core | tail
status: reviewed | unreviewed
problem-signatures: [ma-screening, market-entry, competitive-position]
lineage:
  sources:                            # actual 00_sources/ filenames, plain strings
    - "2026-07-14_strategy-w3-deck2-industry-analysis"
  enrichment: true                    # model knowledge added beyond sources
created: 2026-07-15
updated: 2026-07-15
tags: [p/frameworks, t/strategy]
---
```

Body sections, all present and in this order; write "n/a" only when true:

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
org-design · change-management · operating-model · negotiation · value-creation-plan`

Consistency here is what makes index-based selection work. You may propose an addition,
but flag it explicitly and get Guillaume's yes — never invent a tag silently.

## Modes

**create** — input: framework name + source excerpts or pointers into `00_sources/`
(Phase 1 inventory rows carry the exact filenames — copy them, don't re-derive).
Draft the full card first, then ask **max 5 clarification questions**, prioritized:
(1) which problem signatures, in Guillaume's terms; (2) practice experience — where has
he seen it break (feeds pitfalls); (3) professor variant worth keeping. File the card,
append the index row, commit.

**enrich** — existing card + model knowledge. Set `enrichment: true`; enrichment lands
mostly in *pitfalls* and *adjacent*. Bump `updated:`, commit.

**review** — promote `unreviewed → reviewed`: run the clarification loop against the
existing draft, tighten the prose, verify the contract (esp. a real pitfalls entry),
re-file, update the index row, commit.

## Hard rules

- **Dedup:** before creating, search existing cards' `name` and `aliases`. On collision,
  refuse to create a second card — merge lineage and course notes into the existing one
  instead. One card per framework, no matter how many courses teach it.
- **Lineage integrity:** every Sources wikilink must resolve to an existing
  `00_sources/*.md` file — verify before filing. No card without lineage: at least one
  source file or `enrichment: true` with the sources that do exist.
- **Scope:** no corporate-finance cards (Guillaume's native domain — cards would be noise).
- **Index:** append one row per card: `| Name | Aliases | Domain | Reach for it when… | Tier | Status |`.
  The "reach for it when" cell is one line — it does the selection work, make it earn its place.
- **Prose register:** de-slop applies — direct, concrete, no filler, no consultant-brochure
  tone. The card is for a reader who runs deals, not a student.
- **Mechanics:** CRLF line endings, valid YAML, `updated:` bumped on every body change.
  Commit message: short imperative, e.g. `framework-card: add porters-five-forces`.
- **Boundaries:** never write into `00_sources/`, `40_courses/`, or `90_meta/`.
  Framework *applications* to companies/deals go to `30_finance/.../agent-drafts/`, not here.
