---
name: de-slop
description: >-
  Trigger on the slash command `/de-slop` (always), or whenever producing or
  editing prose meant to be read by humans — reports, memos, emails, executive
  summaries, deck copy, LinkedIn posts, blog posts, documentation, case
  studies, cover letters, vault notes. Also trigger when the user says a text
  "sounds like AI", "reads like ChatGPT", "too wordy", "tighten this", "cut
  the fluff", or asks for plainer, more direct language. Two modes: (1) apply
  silently as a style layer while drafting any prose deliverable — it composes
  with content skills like consulting-slides, market-research, and
  career-path; (2) run an explicit edit pass on existing text and report what
  was cut. Do NOT use for code, raw data tables, or config/YAML output.
---

# De-slop: kill AI speech in prose

The goal is prose a senior operator would sign. Not shorter for its own sake —
denser. Every sentence carries information specific to this document. Anything
that could appear in any document about any topic gets cut.

## Core rules (apply always, both modes)

1. **Lead with the conclusion.** First sentence states the point. No
   warm-up ("In today's fast-paced environment…"), no scene-setting.
2. **End on the last substantive point.** No recap paragraph, no "In
   conclusion", no "Ultimately", no closing question or offer.
3. **Numbers over adjectives.** "Revenue fell 23%" not "revenue declined
   significantly". If no number exists, say what you observed instead of
   grading it.
4. **Plain verbs.** Use, help, run, show, build, buy, cut. Not leverage,
   utilize, facilitate, harness, unlock, foster, empower.
5. **Take a position.** Hedging is allowed only when the specific
   uncertainty is named ("depends on whether the lease renews" — fine;
   "depends on your specific needs" — banned).
6. **One claim per sentence. Vary sentence length.** Uniform 20-word
   sentences are an AI fingerprint as much as any word choice.
7. **Formatting is earned.** Prose by default. Bullets only when items are
   genuinely parallel and order-free. Never bold-phrase-colon bullets
   ("**Speed:** the system…") as a reflex.
8. **The portability test.** Read each sentence and ask: could this appear
   unchanged in a document about a different company, market, or topic?
   If yes, delete or rewrite with specifics.

## Top offenders (memorize; full catalog in references/banned-patterns.md)

| Pattern | Fix |
|---|---|
| "It's worth noting that X" | "X" |
| "It's important to note/remember" | Delete |
| "Great question" / "I'd be happy to" | Start with the answer |
| "Let's dive in / delve into" | Delete |
| "essentially / basically / fundamentally" | Delete |
| "could potentially" | "could" |
| "not only X, but also Y" | "X and Y", or two sentences |
| "It's not just X — it's Y" | State Y |
| "truly / incredibly / deeply / highly" | Delete, or replace with a number |
| "In conclusion / In summary / Overall" | Delete the paragraph it opens |
| "You're absolutely right" | "Correct." — or just make the fix |
| Rule-of-three list ("fast, reliable, and scalable") | Two items, or four, or one |
| Em-dash more than ~once per paragraph | Periods and commas |
| "Would you like me to…" closer | End when done |

When drafting, also load `references/banned-patterns.md` if the deliverable
is over ~300 words — it contains the full vocabulary list and before/after
rewrites by category.

## Mode 1 — Drafting (silent)

When writing any prose deliverable, apply the rules while writing. Do not
announce the skill, do not report what was avoided. Just write clean.

If another skill is active (consulting-slides, career-path, market-research),
that skill owns structure and content; this skill owns the sentence level.
Where they conflict on phrasing, this skill wins.

## Mode 2 — Edit pass (`/de-slop` or "tighten this")

Procedure, in order:

1. **Cut candidates first**: the opening paragraph (throat-clearing) and the
   closing paragraph (recap). Delete unless they carry unique content.
2. **Pattern sweep**: search the text against `references/banned-patterns.md`
   and rewrite each hit.
3. **Portability test** on every remaining sentence.
4. **Density check**: merge sentences that split one claim; split sentences
   that stack two.

Then report, briefly:
- Word count before → after
- The 3–5 worst patterns found, with one example each (original → rewrite)
- Anything ambiguous left untouched, with the reason

Do not pad the report. Two short paragraphs or a compact table, not a
slide deck.

## Calibration — do not over-correct

- Banned vocabulary is banned **as default filler**, not absolutely.
  "Robust" in "robust standard errors" or "comprehensive" in "comprehensive
  income" are technical terms — keep them.
- Hedging that names a real uncertainty is good writing, not slop.
- Do not strip voice from creative or personal writing; the target is
  professional prose that reads as written by its author, not text
  flattened to a telegram.
- French and German output: the same principles apply (no "il convient de
  noter que", no "es ist wichtig zu beachten"), but do not transplant
  English brevity norms wholesale — keep the register native.
