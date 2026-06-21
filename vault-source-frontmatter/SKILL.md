---
name: vault-source-frontmatter
description: |
  Use this skill whenever a markdown report needs to be added to Guillaume's Obsidian vault
  as a `source` note — either by generating a fresh YAML frontmatter for a report that doesn't
  have one, or by fixing/upgrading an existing YAML block that doesn't conform to the v2 contract.
  Triggers include: pasted reports, Deep Research outputs, broker notes, analyst writeups,
  sector studies, regulatory filings, or any markdown the user wants to drop into `00_sources/`.
  Also triggers on legacy notes with stale or malformed frontmatter that need to be brought
  up to spec. Trigger even when the user says "add this to my vault", "fix this frontmatter",
  "this needs a header", or drops a .md file and asks to file it. Do NOT use for PDF→MD
  conversion — that's the `pdf_to_md` / `convert_reports.py` pipeline's job.
version: 2.1
last_updated: 2026-05-17
---

# vault-source-frontmatter — v2 contract

Add v2-compliant frontmatter to a markdown file destined for `00_sources/` in Guillaume's
Obsidian vault, OR migrate a v1-schema file to v2. This skill is the **authoritative spec**
for the v2 frontmatter contract — when in doubt, the canonical reference is whatever
`convert_reports.py` (post-D-016) produces; this skill mirrors that output.

## When to use this skill

- User pastes a report (Deep Research, broker note, analyst writeup, sector study, regulatory
  filing) and wants it filed in the vault.
- User uploads a .md file with v1 frontmatter (snake_case fields, no `pillar` in tags, no
  structured `authors`) and wants it upgraded.
- User uploads a .md file with no frontmatter at all.
- User says "add this to my vault", "fix this frontmatter", "this needs a header", "make
  this vault-compatible".

## When NOT to use this skill

- PDF→MD conversion — that's `convert_reports.py`, not this skill.
- The file already has v2-compliant frontmatter and the user just wants something else done
  with it (summarize, query, etc.).
- The user wants a different kind of vault note (`00_sources/` is for `type: source` only;
  `type: synthesis`, `type: decision`, etc. have different schemas).

## The v2 contract (canonical reference)

```yaml
---
type: source
status: stable
created: '2026-05-16'
updated: '2026-05-16'
source-type: annual-report
title: JORA Holding GmbH & Co. KG — Konzernabschluss zum 31. Dezember 2022
authors:
- kind: entity
  name: JORA Holding GmbH & Co. KG
date-published: '2023-12-18'
language: de
source-pdf: Jora holding konzernabschluss 2022.pdf
source-pages: 21
summary: JORA Holding GmbH & Co. KG is a mid-sized German foundry group (Franken Guss and
  Sachsen Guss) reporting consolidated results for FY2022. Group revenues rose 18% to EUR
  272.3 million, driven largely by energy and raw-material price pass-throughs, with EBIT
  recovering to TEUR 7,183 from near-zero in 2021. A net profit of TEUR 5,694 was achieved
  despite sharply higher material and energy costs, while equity increased to TEUR 47,525
  and the equity ratio improved to 47.4%.
generated-by: convert_reports.py
generated-at: '2026-05-16T17:52:56+02:00'
tags:
- p/finance
- t/annual-report
- t/jora-holding
- t/industrials
- t/foundry
- t/segment-performance
- t/capex
- t/leverage
---
```

### Field order (MANDATORY — do not reorder)

1. `type`
2. `status`
3. `created`
4. `updated`
5. `source-type`
6. `title`
7. `authors`
8. `date-published`
9. `language`
10. `source-pdf`
11. `source-pages`
12. `summary`
13. `generated-by`
14. `generated-at`
15. `tags`

Field order matters because Obsidian Properties UI displays them in source order, and
Guillaume's mental model expects this exact sequence.

### Field reference

**`type`** — always `source` for files filed in `00_sources/`. Other vault types
(`synthesis`, `decision`, `dashboard`) are out of scope for this skill.

**`status`** — `stable`. The semantically-imperfect default (raw converter outputs aren't
"reviewed and stable" — but this is the contract). Other values reserved for future use.

**`created`** — original conversion date if migrating from v1 (`date_converted` field), or
today if generating from scratch. Single-quoted YYYY-MM-DD string. Do NOT use today's date
when migrating — preserve the original conversion date.

**`updated`** — today's date when this skill runs. Single-quoted YYYY-MM-DD.

**`source-type`** — kebab-case enum. Allowed values:
- `annual-report`
- `quarterly-report`
- `broker-note`
- `article`
- `sector-study`
- `presentation`
- `regulatory-filing`
- `book-chapter`
- `other`

Falls back to `other` for anything that doesn't fit. Drives `t/<source-type>` tag and
shapes `authors` extraction (see below).

**`title`** — full document title. Do NOT quote unless YAML requires it (em-dash, ampersand,
parentheses, colons in titles are all fine unquoted in YAML — `title: Foo — bar & baz` is
valid). Only quote when the string starts with a digit, contains `: ` (colon-space, which
YAML reads as a mapping), or begins with a YAML indicator char.

**`authors`** — structured list, never `[]` if information is available. Rules:
- Block style (newline + `- kind:`), NOT flow style.
- `kind` is `individual` or `entity`.
- Indent rule: list items flush-left (no extra indent). Two-space indent for `name` line:
  ```yaml
  authors:
  - kind: entity
    name: Foo GmbH
  ```
- Author = whoever the document is **published by**, NOT signatories inside it. Default
  rules by source-type:
  - `annual-report` / `quarterly-report` / `regulatory-filing` → entity (publishing company)
  - `broker-note` → individual (named analyst on byline)
  - `article` → individual(s) (named author)
  - `sector-study` → mixed: entity (consulting firm) + named lead partners
  - `presentation` → context-dependent
  - `book-chapter` → individual (academic citation)
  - `other` → judgment
- Individual name format: APA family-name-first (`Vives, Luis`). Strip titles (Dr., Prof.,
  MD, PhD). Spanish double surnames: both, space-joined (`García López, María`). German
  particles: with surname proper, display as suffix (`Müller, Hans von`). CJK: surname
  already first, insert comma (`Wang, Wei`).
- Entity name: preserve raw (`Festool GmbH`, `McKinsey & Company` — no reformatting).
- Cap at 10 entries.
- If no author info clearly stated, return `authors: []`. Never guess.

**`date-published`** — single-quoted YYYY-MM-DD string. The date the source document was
published (NOT the date converted).

**`language`** — ISO 639-1 two-letter code, lowercase. `de`, `en`, `fr`, `es`. Unquoted.

**`source-pdf`** — original PDF filename if known, otherwise omit or use a placeholder.
Unquoted (filenames typically don't need YAML quoting).

**`source-pages`** — integer, page count of the source PDF. `0` is a known converter bug
state — flag to user but preserve.

**`summary`** — folded plain scalar, 2-4 sentences, neutral business description. Width
~95 chars, continuation lines indented 2 spaces. Match this exact style:
```yaml
summary: Long first line of summary content that wraps somewhere around 95 characters
  and continuation lines are indented exactly two spaces. No leading dash, no quotes
  around the scalar itself, just folded text.
```

**`generated-by`** — unquoted, e.g. `convert_reports.py`, or `claude-via-vault-source-frontmatter-skill`
when this skill generated the frontmatter (not the converter).

**`generated-at`** — ISO 8601 timestamp with timezone offset, single-quoted, e.g.
`'2026-05-16T17:52:56+02:00'`. When this skill runs, use the current time in Europe/Madrid
(or wherever Guillaume is — default Europe/Madrid).

**`tags`** — flat list, kebab-case, with prefix system:
- **First tag MUST be `p/<pillar>`**. Pillar enum: `finance` | `strategy` | `management` |
  `technology` | `policy` | `science` | `other`. Selection rule: document's dominant theme.
  Annual/quarterly reports, broker notes, valuation, M&A → `finance`. Business transformation,
  positioning → `strategy`. Leadership, governance, ops → `management`. AI/software/deeptech
  primers → `technology`. Regulation/geopolitics → `policy`. Academic research → `science`.
  Fallback → `other`.
- **Second tag SHOULD be `t/<source-type>`** (mirror of the `source-type` field).
- **Subsequent tags**: `t/<topic-slug>` with descriptive slugs (entity name, industry,
  themes). 5-10 tags total is typical. Slug = lowercase, kebab-case, no underscores.

**There is NO top-level `pillar` field.** Pillar lives ONLY inside the `tags` list as
`p/<value>`. D-016's earlier prose suggested a top-level field; the actual contract (per
`convert_reports.py` output) does not have one. Do not emit one.

## File mechanics — DO NOT GET THIS WRONG

### Line endings: CRLF, always

The vault and `convert_reports.py` use **CRLF (`\r\n`) line endings throughout**. This is
non-negotiable. Files with LF-only line endings render with broken line wrapping in the
Obsidian Properties UI on Windows (and on the Anthropic web preview in browsers, which is
how Guillaume usually reviews output).

Python on Linux/Mac silently strips CRLF in text mode. Always write with `newline=""` and
explicit `\r\n`:

```python
out_text = frontmatter + "\n\n" + body
out_text = out_text.replace("\r\n", "\n").replace("\n", "\r\n")
path.write_text(out_text, encoding="utf-8", newline="")
```

Verify with:
```python
raw = path.read_bytes()
assert raw.count(b"\n") == raw.count(b"\r\n"), "bare LFs detected"
```

### Frontmatter delimiter

Opening `---` and closing `---` on their own lines. Single blank line between closing `---`
and body. Body preserved verbatim with CRLF (do not normalize body content — preserve any
tables, code blocks, HTML comments from the converter exactly).

### YAML quoting rules

- Dates (`created`, `updated`, `date-published`): **always single-quote** (`'2026-05-16'`)
  to prevent YAML parsing them as date objects and re-emitting in a different format.
- ISO 8601 timestamps (`generated-at`): single-quote for the same reason.
- Strings starting with a digit: single-quote.
- Strings containing `: ` (colon-space): single-quote.
- Strings starting with YAML indicator chars (`!&*?|>%@\`{}[],#`): single-quote.
- Everything else: unquoted (em-dashes, ampersands, parentheses, German umlauts, accented
  chars all fine unquoted).

## Workflow

### Case A: pasted report or .md with no frontmatter

1. Read the body. Identify: title, publishing entity, source-type, language, publication date.
2. Generate a 2-4 sentence summary.
3. Pick pillar (default `finance` for company docs, adjust for clear non-finance content).
4. Generate 5-10 tags following the prefix convention.
5. Set `created` and `updated` to today. Set `generated-by: claude-via-vault-source-frontmatter-skill`.
6. Compose YAML in the mandatory field order. Quote where needed.
7. Emit with CRLF.

### Case B: file with v1 frontmatter (migration)

v1 = snake_case fields (`date_published`, `source_pdf`, `date_converted`, `generated_by`),
flat author-less, tags without `p/`/`t/` prefix system.

1. Parse v1 frontmatter. Extract: `title`, `type`, `date_published`, `date_converted`,
   `source_pdf`, `source_pages`, `summary`, `tags`, `generated_by`, `generated_at`.
2. Map v1 `type` → v2 `source-type` (replace underscores with hyphens, e.g.
   `annual_report` → `annual-report`).
3. Derive entity from title/body, construct `authors` list (one entry, kind=entity for
   most cases).
4. Migrate tags:
   - Map snake_case slugs to kebab-case (`tts_tooltechnic_systems` → `tts-tooltechnic-systems`).
   - Drop redundant tags already covered by prefix system (e.g. v1 `annual_report` tag
     when `t/annual-report` already exists).
   - Prepend `p/<pillar>` (default `finance`) and `t/<source-type>`.
5. Set `created` = v1 `date_converted`. Set `updated` = today.
6. Set `status: stable`.
7. Keep v1's `generated-by` and `generated-at` as audit trail (these were set by the
   original converter run — preserve them, don't overwrite).
8. Replace the v1 frontmatter block entirely with v2. Do NOT preserve v1 fields alongside.
9. Emit with CRLF.

### Case C: file with malformed/partial v2 frontmatter

Same as Case B but more forgiving about which fields exist. Re-emit in correct order with
all required fields populated. If a field can't be derived, use a sensible default and
flag it to the user.

## Lessons learned (do not repeat)

These are mistakes made in past sessions. If the model finds itself doing any of these,
stop and re-read this section:

1. **Do not invent a top-level `pillar` field.** D-016's schema diff suggested adding one
   as a sibling of `tags`; the actual contract puts it inside `tags` as `p/<value>` only.
   The reference (Jora 2022 file) is canonical.

2. **Do not use `status: source`.** Use `status: stable`. The semantic mismatch ("raw
   converter output isn't really stable") is a known wart in the contract — live with it.

3. **Do not output LF-only line endings.** Always CRLF. The Anthropic web preview renders
   YAML block scalars (folded `summary`) with broken visual line breaks when the file is
   LF-only, which Guillaume reports as "all lines are being broken up." File is technically
   valid, but it looks wrong in the preview, and his Windows tools want CRLF anyway.

4. **Do not ask the user to clarify between `created/updated = today` vs `created = date_converted`.**
   The answer is: `created = date_converted` (preserve provenance), `updated = today`.

5. **Do not emit redundant v1 fields alongside v2.** Clean break: v1 frontmatter goes,
   v2 replaces it entirely. The only fields preserved across migration are the
   semantically-meaningful ones (title, summary, dates, source-pdf, source-pages, tags
   after remapping, generated-by, generated-at as audit trail).

6. **Do not skip the body line-ending fix.** When normalizing body content, the original
   CRLF is stripped if you do `body.replace("\r\n", "\n")` for parsing. You must re-add
   CRLF to the whole output (frontmatter + body) before writing.

7. **Do not quote strings unnecessarily.** Reference uses unquoted titles even with
   em-dashes. Only quote when YAML actually requires it.

8. **Do not reorder fields.** Field order is part of the contract.

## Validation checklist before delivering output

For every file emitted, verify:

- [ ] YAML parses (use `yaml.safe_load` on the frontmatter block).
- [ ] `type == 'source'` and `status == 'stable'`.
- [ ] No top-level `pillar` key.
- [ ] First tag starts with `p/`. Second tag starts with `t/`.
- [ ] `authors` is a non-empty list (or explicitly `[]` if no info), each entry has
      `kind` and `name`.
- [ ] All field names are kebab-case (no `date_published`, no `source_pdf`).
- [ ] Field order matches the mandatory sequence above.
- [ ] File contains only `\r\n` line endings (no bare `\n`).
- [ ] Body content is byte-identical to input body (frontmatter is the only thing changed).

## Pointers

- The canonical reference file: any recent output of `convert_reports.py` post-D-016. As
  of this skill version, the Jora Holding 2022 file is the working reference.
- The schema-design discussion: D-015 (initial v2 contract), D-016 (pillar enum + structured
  authors). These docs live in Guillaume's decision log.
- The converter pipeline that produces v2 directly: `pdf_to_md` / `convert_reports.py`.
  When this skill and the converter disagree, the converter wins — update this skill to match.

## Changelog

- **v2.1** (2026-05-17): Added "Lessons learned" section after CRLF / status-value / pillar
  field mistakes in production use. Made line-ending rules explicit. Locked field order.
- **v2.0** (initial): D-016 schema specification.
