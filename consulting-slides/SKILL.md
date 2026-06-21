---
name: consulting-slides
description: Trigger on the slash command `/consulting-slides` (always), or whenever the user wants a dense executive read-deck — built to be READ, not presented — for boards, investors, lenders, ICs, or executive committees. Natural-language triggers include board pack, IC memo, investor or lender deck, MBO/LBO plan, BP deck, DD report deck, strategy review, market entry deck, post-mortem, ops review, "deck for the board", "leave-behind", or any deck consumed offline without a presenter. Also trigger when the user shares a consulting-style deck and asks for something similar. Prefer this over the generic pptx skill when density and readability matter more than stage performance.
license: Proprietary — built for Guillaume Simler.
---

# Consulting Slides Skill

Builds dense, board-ready PPTX decks meant to be **read, not presented**. Layers on top of the public `pptx` skill — that one tells you how to emit pptx files; this one defines the design system, the slide grammar, and the mandatory structure.

**Always read `/mnt/skills/public/pptx/SKILL.md` before writing the first slide.** Use `pptxgenjs` (Node) for creation from scratch unless the user provides a template.

**Always read `/mnt/skills/user/de-slop/SKILL.md` before writing any slide text.** It is the style layer for every word on every slide — headlines, commentary bullets, key takeaways, devil's-advocate statements, glossary definitions. This skill owns structure, layout, and content; `de-slop` owns the sentence level. Where they conflict on phrasing, `de-slop` wins.

---

## When to use this skill

Trigger on any executive read-deck — board packs, IC memos, investor decks, lender decks, restructuring/MBO plans, BP decks, DD reports, strategy reviews, market entry, post-mortems, ops reviews. The defining feature is **the audience reads it alone, no presenter**, so density and self-explanatory pages matter more than stage performance.

Don't trigger for: pitch decks meant to be presented live, marketing/sales decks, training material, internal status updates that aren't going to a board.

---

## The three rules that define this skill

1. **Headline-as-conclusion.** Every content slide opens with a 2–3 line statement IN THE ACCENT COLOR that gives the reader the takeaway before they look at any number. If the headline is a topic ("Personnel costs"), it's wrong. The right form: "Personnel costs drop to €5.7m in FY24 driven by a 24-FTE reduction, with the departure plan front-loaded in Q4-23." The reader should be able to skim only the headlines and understand the deck.

2. **Self-contained pages.** A board member opening any single page must understand it without flipping back. Every table has units, every chart has a source line, every acronym beyond standard executive vocabulary is glossed.

3. **Density is a feature.** Read-decks are not pitch decks. Body text at 10–11pt is fine. Tables with 15 rows are fine. White space matters but breathing room ≠ emptiness. If a page has < 40% ink coverage, it's probably wasting the reader's time.

---

## Step 1 — Setup interview (mandatory, before any code)

Before generating anything, you must establish:

### A. Visual identity (defaults shown — confirm or override)

| Element | Default | Notes |
|---|---|---|
| Slide size | **4:3 (10" × 7.5")** | Read-decks need vertical room. Override only if user insists on 16:9. |
| Background | **White (`FFFFFF`)** | Never cream, never gray. |
| Primary text | **Near-black (`1A1A1A`)** | 17.4:1 on white — AAA contrast. |
| Secondary text | **Dark gray (`595959`)** | For sources, footnotes, captions, footer only — never for body. 7.0:1 on white. |
| **Accent (the one color)** | **Deep burnt orange (`A04308`)** | Used for headlines, key numbers, callouts, table header rules. Nothing else gets color. 6.4:1 on white — AA at any size. |
| Subtle accent | **Pale orange tint (`FBE9D7`)** | For table header fills, KPI tile fills. Use sparingly. |
| Header font | **Calibri** or **Aptos** (system) | Bold weights for titles. |
| Body font | **Calibri** or **Aptos** | Regular and light weights. |
| Numbers/tables | **Calibri** | Tabular figures if available. |

If the user wants a different accent, accept it but warn if it's a low-contrast color (yellow, light blue, pastel anything) — read-decks need the accent to pop on white.

### B. Language

- **Default: English.** If the source data is in a different language, ASK before proceeding: "Source is in [X]. Output language: English (default), [X], or another?"
- Number formatting follows output language: `1,234.56` for EN, `1 234,56` for FR/DE.
- Currency follows source unless user says otherwise.

### C. Audience

Confirm the reader profile in one sentence — "board of a mid-cap industrial group", "senior credit committee at a bank", "PE investment committee". This drives:
- Glossary auto-detection threshold (see Step 5)
- Whether to show governance/legal detail or skim it
- Whether numbers go to €k or €m

### D. Scope of the deck

Get from the user: what's the deal/situation, what decision is the deck supporting, how many pages roughly, what data they have. If they're vague, ask one round of clarifying questions — don't guess.

---

## Step 2 — The mandatory structure

Every deck this skill produces has this skeleton. Skip a section only if the user explicitly says so.

| # | Section | Pages | Purpose |
|---|---|---|---|
| 1 | **Cover** | 1 | Title, subtitle, date, "Working document / Confidential" if relevant. |
| 2 | **Table of contents** | 1 | Numbered sections with page refs. |
| 3 | **Executive summary** | 1–2 | KPI-tile-heavy. The reader who reads only this should get the deal. |
| 4 | **Content** | 5–25 | The actual analysis. One topic per slide. |
| 5 | **Key takeaways** | 1 | 3–5 numbered, declarative statements. Not a summary — *conclusions*. |
| 6 | **Devil's advocate / red team** | 1–2 | The non-BS section. Format below. |
| 7 | **Glossary** | 1–2 | Auto-built from acronyms used (see Step 5). |
| 8 | **Sources** | 1 | Numbered list referenced by footnote markers throughout. |

Section dividers (large number + section title on white background, accent color) go between sections 3→4, 4→5, and 5→6 if the deck is long enough to warrant them (>15 pages).

---

## Step 3 — The slide archetypes

Read `references/slide-archetypes.md` for full layout specs and pptxgenjs code patterns. Pick the right archetype for the content you're presenting — don't invent layouts.

The archetypes are:

1. **Cover** — title, subtitle, metadata strip, optional photo treatment.
2. **TOC** — numbered sections, page numbers right-aligned.
3. **KPI tiles** (executive summary workhorse) — 6–9 tiles in a 3×2 or 3×3 grid, big number + label.
4. **Headline + table + commentary** (the workhorse content slide) — headline at top, table left ~55%, bullet commentary right ~40%.
5. **Headline + chart + commentary** — same proportions, chart instead of table.
6. **Bridge / waterfall** — for EBITDA bridges, cash bridges, value walks. Footnoted callouts (A, B, C) below.
7. **Sensitivity table** — base case + sensitivities stacked, with cumulative/non-cumulative note.
8. **Driver breakdown** — line-item table with letter callouts referenced in commentary.
9. **Two-column compare** — before/after, base/bear, or two scenarios side by side.
10. **Section divider** — large number, section title, mini-TOC of subsections.
11. **Key takeaways** — 3–5 numbered statements, each with a one-line elaboration.
12. **Devil's advocate** — see Step 4 (special structure).
13. **Glossary** — two-column term/definition list.
14. **Sources** — numbered list, each entry with type (Mgmt info / Public source / 3rd party report) and date.

**Rule: every content slide carries a footer line at the bottom in mid-gray, 8pt:** `Source: [n] [n] [n]   |   [Deck title]   |   [page]`. Source numbers tie back to the sources slide.

---

## Step 4 — The devil's advocate slide (specific structure)

This is the differentiator. Don't water it down. Format:

**Top of slide — entry statement (max 3 lines, accent color, italic):**
> A short, plain-language statement of what the bear case is, in one breath. Example: "The plan assumes the largest customer holds flat at €6m and a single new logo ramps from zero to €3m in 24 months. Both are credible but neither is contracted. If either slips, year-3 EBITDA halves."

**Below — three columns of equal width:**

| What could go wrong | What needs to be checked | Consequences |
|---|---|---|
| Specific risk #1 | What evidence would resolve the doubt | Quantified impact on the case |
| Specific risk #2 | … | … |
| Specific risk #3 | … | … |

Use 3–5 rows. Each row is a real risk, not a generic "market risk".

**Bottom of slide — preparation statement (no BS, in body color, normal weight, max 2 lines):**

State plainly how prepared the case actually is. Examples of acceptable phrasing:
- "Stress tests cover sales and margin sensitivities but not customer concentration. The single-name risk on the top customer is unaddressed."
- "Mitigation plans exist on paper for items 1 and 2; item 3 has no plan."
- "Management has thought hard about cost — much less about revenue resilience."

Do NOT write things like "Management is well prepared" or "All risks are mitigated" — that defeats the point of the slide. If the case really is well prepared, say specifically why and specifically where it isn't.

---

## Step 5 — Glossary auto-detection

Build the glossary by scanning the deck's text content for:

1. **All-caps tokens of length 2–6** (EBITDA, FTE, MBO, LTM, DSO, BP, IC, TSA, PSE, …).
2. **Acronyms with a parenthetical expansion** the first time they appear ("days payable outstanding (DPO)").
3. **Capitalized multi-word industry terms** that aren't proper nouns (e.g., "Working Capital Requirement").

Then **filter against the executive baseline** — do NOT include items the audience already knows:

**Excluded from glossary by default** (assume executive audience knows):
EBITDA, EBIT, P&L, B/S, CF, ROI, ROE, ROIC, WACC, NPV, IRR, CAGR, YoY, FY, H1/H2, Q1–Q4, KPI, M&A, IPO, CEO, CFO, COO, HR, IT, R&D, B2B, B2C, SKU, CapEx, OpEx, USD/EUR/GBP, VAT, MBA.

**Always included** (specific or jurisdictional):
- Country/jurisdiction-specific terms (PSE in France, Schuldscheindarlehen in Germany, Chapter 11 in US).
- Company-specific terms (project codenames, internal segment names, proprietary KPIs).
- Industry-specific terms outside the audience's likely domain.
- Any acronym used more than twice that's not in the excluded list.

If unsure, include it. A glossary entry costs nothing; a confused reader costs the deal.

For each glossary entry, format as: **TERM** — *expansion* — one-line plain-language definition (skip jargon-by-jargon definitions like "DPO: days payable outstanding". Write: "DPO — days payable outstanding — average time the company takes to pay suppliers, in days").

---

## Step 6 — Sources

Two-layer source citation system:

1. **Inline footnote markers** at the end of every claim that needs sourcing: superscript number `¹` `²` `³` placed right after the claim, in mid-gray.
2. **Sources slide** at the end, numbered list with format:
   - `[1] Source type — specific document/dataset — date — accessed by`
   - Example: `[1] Management information — FY23F P&L draft — 28 Sep 2023 — provided by CFO`
   - Example: `[2] Public — IHS Markit Global Light Vehicle Production Forecast — Sep 2023`

Plus the **per-page footer** (from Step 3) gives source numbers used on that page, so the reader can either trace inline or page-level.

---

## Step 7 — Build workflow

1. **Read** `/mnt/skills/public/pptx/SKILL.md` for pptxgenjs mechanics.
2. **Read** `references/slide-archetypes.md` for layout specs of each archetype.
3. **Read** `references/design-tokens.md` for the exact color/font/spacing constants. Pay particular attention to the **Contrast & readability rules** section — those are non-negotiable.
4. **Plan the deck** — write a one-line outline of every slide before coding any of them. Show this to the user for approval if the deck is >10 pages.
5. **Generate** with pptxgenjs using the helper functions in `references/helpers.md` (KPI tile, headline-table-commentary, bridge, devil's-advocate, etc.). Write all slide text under `de-slop` Mode 1 — for decks, also load `de-slop`'s `references/banned-patterns.md` first. Headlines-as-conclusions are the most slop-prone text in the deck: "robust performance driven by key initiatives" is a topic dressed as a conclusion; "EBITDA up €1.4m on 24 fewer FTEs" is the conclusion.
6. **Auto-build glossary and sources** by scanning the content you generated.
7. **QA — readability gate (mandatory before shipping):** following the public pptx skill's QA process (extract-text + image inspection), check each slide against this list:
   - **Font sizes:** no body text below 10pt, no footer/source line below 9pt. Search the rendered XML or the source for any `fontSize: 8` and fix.
   - **Contrast:** all text passes WCAG AA on its background — INK on white, INK on tint, INK_MUTED on white only for footer/source/captions, never INK_MUTED for content. ACCENT only on white or on ACCENT_TINT (never on a darker fill).
   - **Headline visibility:** open each rendered slide image at 50% zoom — the headline should still be the first thing the eye lands on.
   - **Table density:** if any cell wraps to 3+ lines, the table is too tight. Either widen the column or split the table.
   - **Print test:** mentally render the slide in grayscale. The headline should still pop (it does, because ACCENT at 6.4:1 maps to dark gray). If a chart relies on color to distinguish series, it fails.
   - **Phone test:** at thumbnail size (~3" wide), can you still read the headline and find the key number? If not, simplify.
   - **Footer present** on every content slide.
   - **Devil's advocate slide** actually has specific risks, not generic ones.
   - **De-slop pass:** sweep all headlines, commentary, and takeaways against `de-slop` `references/banned-patterns.md`. No "key drivers", "comprehensive plan", "leverage synergies", or numberless "significant" survives QA. Every headline passes the portability test: if it could sit atop a slide about a different company, rewrite it with this company's numbers.
   - **No overflow** in dense tables — better to split than to compress.

---

## Step 8 — Things to push back on

This skill is opinionated. Push back on the user when they ask for:

- **A pitch-deck-style version** ("make it more visual, less text") — that's a different deliverable. Offer to build a separate pitch deck instead.
- **No devil's advocate slide** — this is the most valuable page in the deck. If the user wants it removed, ask why. Acceptable reasons: deck is for internal management who already know the risks. Unacceptable: "it might upset the board" — that's exactly when it's needed.
- **A green-light executive summary when the numbers don't support it** — the headline must match the data. Decline to write "Strong FY24 trajectory" if EBITDA is €1.1m on €19m sales (5.8% — that's not strong, it's thin).
- **More than one accent color** — the discipline is the point. Two accents = no accent.
- **Decorative filler** — no stock photos of handshakes, no shutterstock skylines, no gradient backgrounds. Industrial photography is acceptable on the cover only if it's specific to the company/sector.

---

## Reference files

- `references/slide-archetypes.md` — Layout specs and pptxgenjs patterns for every archetype.
- `references/design-tokens.md` — Exact colors, fonts, spacing, font sizes.
- `references/helpers.md` — Reusable pptxgenjs helper function patterns.
- `references/example-prompts.md` — Worked examples showing how to translate user requests into deck plans.
