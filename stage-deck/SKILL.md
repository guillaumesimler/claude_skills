---
name: stage-deck
description: Trigger on the slash command `/stage-deck` (always), or whenever the user wants a deck built to be PRESENTED LIVE — not read alone — for a keynote, conference talk, fundraising pitch, sales pitch, internal town hall, demo day, or any setting with a speaker on stage and an audience watching a screen. Natural-language triggers include "pitch deck", "keynote", "fundraising deck", "investor pitch", "demo day deck", "sales pitch", "town hall slides", "conference talk", "TED-style deck", "stage deck", "deck I'm presenting", "speaker notes", or any deck where the slide is a backdrop to a human voice. Prefer this over the consulting-slides skill when the deck is presented live with a speaker; prefer this over the generic pptx skill when stage performance and one-idea-per-slide discipline matter more than density.
license: Proprietary — built for Guillaume Simler.
---

# Stage Deck Skill

Builds **stage decks** — slides designed to back a live speaker, not to be read alone. Layers on top of the public `pptx` skill (which handles the file mechanics) and is the deliberate opposite of the `consulting-slides` skill (which builds dense read-decks).

**Always read `/mnt/skills/public/pptx/SKILL.md` before writing the first slide.** Use `pptxgenjs` (Node) for creation from scratch unless the user provides a template.

**Always read `/mnt/skills/user/de-slop/SKILL.md` before writing any narrative or slide text.** It is the style layer for every word the audience or speaker reads — the Phase 1 narrative, slide copy, and especially speaker notes. This skill owns structure and stagecraft; `de-slop` owns the sentence level. Where they conflict on phrasing, `de-slop` wins. With a ≤15-word budget per slide, a single "seamless" or "journey" is 7% of the slide — slop discipline matters *more* here, not less.

This skill operates in **two phases with a hard-stop checkpoint between them**. Do not skip the checkpoint. The checkpoint is the whole point: it forces the narrative to be approved before any pixels get pushed.

---

## When to use this skill

Trigger on any deck meant to be **presented live** — keynotes, conference talks, investor/fundraising pitches, demo days, sales pitches, internal town halls, all-hands, executive presentations, customer kickoffs. The defining feature is **a human is talking while the slide is on screen**, so the slide's job is to anchor and amplify the speaker — not to carry the argument alone.

**Don't trigger for:**
- Read-decks meant to be sent and consumed offline (board packs, IC memos, lender decks, DD reports) → use `consulting-slides`
- Generic slide tasks with no presentation context → use `pptx` directly

If the user is ambiguous ("I need a deck for the board"), ask: **"Will you be presenting live, or sending it to read alone?"** That single question routes the work.

---

## The five rules that define this skill

1. **One idea per slide.** Not one topic — one *idea*. "Our market" is a topic; "The market is 10× bigger than anyone thinks" is an idea. If the slide has two ideas, split it. Most stage decks fail because slides try to say three things at once.

2. **The slide is punctuation, the speaker is the sentence.** The slide should make sense in 3 seconds — long enough for the audience to register it and return their eyes to the speaker. Anything that takes longer to read steals attention from the speaker. Default text budget: **under 15 words per slide for keynote, under 30 for pitch.**

3. **Visual dominates, text supports.** Every content slide has a dominant visual element — a number, an image, a chart, a single bold word, a diagram. Text is the caption, not the content.

4. **Speaker notes carry the substance.** The slide is the headline; the speaker notes are the article. This skill writes speaker notes for every content slide — not as a transcript, but as **3–6 bullet talking points** the presenter can glance at. This is non-negotiable. Notes are written under `de-slop` rules: a confidence monitor showing "leverage our robust ecosystem" gives the speaker nothing to say; "3 of top-5 OEMs signed, €4.2m pipeline" does.

5. **Designed for the back row.** Anything on screen must be readable from the back of the room. Default minimum body size: **24pt.** Default minimum headline size: **44pt.** Big-number callouts: **120pt+.** If you're tempted to go below 24pt, you have too much on the slide.

---

## The two-phase workflow

### Phase 1 — Narrative extraction
### → HARD STOP CHECKPOINT ←
### Phase 2 — Slide rendering

The checkpoint is mandatory. Phase 2 does not start until the user explicitly approves the narrative from Phase 1.

---

## Phase 1 — Narrative extraction

**Goal:** turn whatever the user gave you (a brief, a document, a meeting transcript, a rough idea, a competing deck, a strategy paper) into a **storyline** the audience will follow. Storyline first, slides never.

### 1.1 Setup interview (mandatory, before extraction)

Establish these in one round of focused questions. Don't ask in a vacuum — read the source material first, then ask only what you can't infer.

| Question | Why it matters |
|---|---|
| **What type of presentation?** Keynote / fundraising / sales / town hall / demo / other | Each type has a different default structure (see 1.3). |
| **Who is the audience?** One sentence — "Series A VCs at a demo day", "300 sales reps at the annual kickoff", "the executive committee plus department heads" | Determines vocabulary, what's assumed vs explained, what they care about. |
| **How long is the slot?** Minutes on stage | Drives slide count. Rule of thumb: **1 slide per 1–2 minutes for keynote, 1 per 30–60 seconds for pitch.** |
| **What's the single outcome you want?** One sentence: "investors want to take a meeting", "team commits to the new strategy", "customer signs the LOI" | This is the deck's job. Every slide either advances this or gets cut. |
| **What's the room?** Big stage with screen / conference room / Zoom / hybrid | Big stage = more visual, less text. Zoom = can tolerate slightly more text. |
| **Language?** Default English; if source is FR/DE, ask. | Output language. |

If the user is in a hurry and waves these off, set defaults and **state your assumptions in writing** at the top of Phase 1 output. Don't proceed silently with guesses.

### 1.2 Visual identity (defaults shown — confirm or override)

| Element | Default | Notes |
|---|---|---|
| Slide size | **16:9 (13.333" × 7.5")** | Stage standard. Override only if user insists. |
| Background | **White (`FFFFFF`)** | TED-style. Generous whitespace. |
| Primary text | **Near-black (`1A1A1A`)** | 17.4:1 on white — AAA contrast. |
| Secondary text | **Dark gray (`595959`)** | For attribution, captions only — never for body. 7.0:1 on white. |
| **Accent (the one color)** | **Deep burnt orange (`A04308`)** | Same accent as `consulting-slides` for visual coherence across the pair. Used for big numbers, key words, single highlights. Nothing else gets color. 6.4:1 on white — AA at any size. |
| Subtle accent | **Pale orange tint (`FBE9D7`)** | For sparing block fills. Use almost never. |
| Header font | **Calibri Bold** or **Aptos Bold** | Big, simple, screen-friendly. |
| Body font | **Calibri** or **Aptos** | |
| Numbers | **Calibri** | For big-number callouts. |

**One accent. Only one.** If the user asks for a brand palette with multiple colors, accept it but pick one as the dominant accent and demote the rest to secondary use.

### 1.3 Default narrative structures by type

The narrative skeleton depends on the presentation type. Use the right one, then adapt.

#### Keynote / conference talk (TED-style)
1. **Hook** — a story, a counterintuitive claim, a vivid image, or a question. 1 slide.
2. **The tension** — what is broken, missing, or misunderstood. 2–4 slides.
3. **The shift** — the new way of seeing it. 1 slide (the pivot).
4. **The evidence** — 2–3 supporting points, each with a concrete example. 4–8 slides.
5. **The implication** — what changes if the audience accepts this. 1–2 slides.
6. **The call** — what you want them to do, think, or feel. 1 slide.

#### Fundraising / investor pitch
1. **The line** — one sentence on what the company does. 1 slide.
2. **The problem** — visceral, specific, expensive. 1–2 slides.
3. **The insight** — what you see that others don't. 1 slide.
4. **The product** — show, don't tell. Demo screenshot or short clip. 1–2 slides.
5. **The traction** — numbers, logos, growth. 1–2 slides.
6. **The market** — bottoms-up sizing, not "$X billion TAM". 1 slide.
7. **The model** — how money is made. 1 slide.
8. **The competition** — honest, with your wedge. 1 slide.
9. **The team** — why these people, this problem, now. 1 slide.
10. **The ask** — round size, use of funds, milestones. 1 slide.
11. **(Appendix)** — for Q&A backup, not part of the live flow.

#### Sales pitch (external)
1. **The world they live in** — show you understand their reality. 1–2 slides.
2. **The cost of the status quo** — quantify the pain. 1–2 slides.
3. **The new way** — your category positioning. 1 slide.
4. **How it works** — at the level they need (not the demo). 2–3 slides.
5. **Proof** — case study with named customer + outcome number. 1–2 slides.
6. **The path** — what working together looks like, timeline, next step. 1 slide.

#### Internal exec / town hall
1. **The frame** — why we're here, in plain language. 1 slide.
2. **Where we are** — honest assessment, no spin. 2–3 slides.
3. **What's changing** — the decisions, the why. 2–4 slides.
4. **What we're asking of you** — specific, role-relevant. 1–2 slides.
5. **What happens next** — dates, owners, where to ask questions. 1 slide.

#### Demo day (3-min variant)
Compressed pitch: line → problem → product (demo) → traction → ask. 5–8 slides max.

### 1.4 Phase 1 deliverable (what you hand the user at the checkpoint)

Output a **plain-text narrative document** (no slides yet) with:

1. **Setup recap** — the 6 setup answers, plus any assumptions you made.
2. **The single outcome** restated.
3. **The narrative arc** — the chosen structure with each section labeled.
4. **One line per slide** — every slide as a single sentence headline. This is the deck's spine. The user must be able to skim only these headlines and understand the talk.
5. **The hook** — written out. The opening 2–3 sentences the speaker will say. This is critical; rewrite until it's good.
6. **The close** — written out. The final 2–3 sentences. The audience remembers the first and last 30 seconds.
7. **The cuts** — what you deliberately left out, and why. Forces discipline. If you can't name 3+ things you cut, you haven't been ruthless enough.

Then **stop and ask explicitly**:

> "This is the narrative. Approve to proceed to slides, or tell me what to change. I won't build any slides until you approve."

Do not proceed without an explicit "approved" / "go" / "build it" / equivalent. Comments-without-approval = iterate on Phase 1.

---

## Phase 2 — Slide rendering

Triggered only by explicit approval. Goal: render the approved narrative as slides that obey the five rules.

### 2.1 The slide archetypes (stage deck inventory)

Pick the right archetype for each slide. Don't invent new layouts. Don't mix archetypes within a slide.

| # | Archetype | When to use | Spec |
|---|---|---|---|
| 1 | **Title slide** | Opening | Title centered, optional subtitle. No date, no logo grid, no metadata clutter. |
| 2 | **Big word / sentence** | The hook, pivots, calls to action | 1–8 words, **80–120pt**, centered, vast whitespace. |
| 3 | **Big number** | A stat that anchors the moment | The number at **140–200pt** in accent color, 1-line label below at 28pt. Source line at bottom in gray, 14pt. |
| 4 | **Image-dominant** | Show, don't tell | Full-bleed or near-full-bleed image. Caption max 8 words, bottom-left or bottom-right. |
| 5 | **Quote** | Customer testimonial, expert validation | Quote in 36–48pt italic, attribution below in 18pt regular. No quote marks larger than the text itself. |
| 6 | **Two-side compare** | Before/after, us/them, old/new | Two halves, equal weight, single label per side, single visual or stat per side. |
| 7 | **Build / progressive reveal** | Concepts that unfold in 2–4 steps | Same slide repeated with elements added; each version is one slide in the deck. PowerPoint animations are unreliable on stage — bake the build into separate slides. |
| 8 | **Simple chart** | One insight from one chart | One chart, one headline-as-conclusion above it ("Revenue 4×'d in 18 months"), max 2 series, no legend if avoidable. Strip every non-essential chart element. |
| 9 | **Three-up icons** | Three pillars, three benefits, three steps | Three columns, each = icon + 3-word title + 1-line description. Never four columns (too cramped). |
| 10 | **Section divider** | Marking the structure for the audience | Big section title, optional Roman numeral or number, vast whitespace. |
| 11 | **Demo screenshot** | Product slides | One screenshot, cropped tight, optional callout arrow + 3-word annotation. |
| 12 | **Closing slide** | The call | Either a Big-word slide (the call to action) or a contact slide (name + email + nothing else). Never a "Thank you / Questions?" slide — that's the speaker's voice, not a slide. |

### 2.2 What every content slide must have

- **Headline-as-conclusion** when applicable (chart, comparison, data slide) — the takeaway, not the topic. Same rule as `consulting-slides`. "Revenue grew" is wrong. "Revenue 4×'d in 18 months" is right.
- **Speaker notes** — 3–6 bullet talking points, written as the speaker would think them, not as the speaker would say them. Include any number, name, or fact the speaker shouldn't have to remember. This populates the PPTX speaker notes pane.
- **No footers, no page numbers, no source line on the slide itself.** Stage decks do not need pagination; the audience is not flipping back. Sources go in speaker notes if needed.
- **No logo on every slide.** Logo on title slide and closing slide only. Putting a logo on every slide is read-deck behavior.

### 2.3 What stage decks do NOT have

Forbidden by default — push back if requested:

- Bullet lists with more than 3 items (split into multiple slides)
- Tables with more than 4 rows or 4 columns (find another way)
- Slide titles in the same size as headlines (pick one)
- Footers, page numbers, breadcrumbs, "Confidential" stamps
- Logos repeated on every slide
- Stock photography of handshakes, lightbulbs, gears, puzzle pieces, or diverse smiling people in offices
- "Thank you" or "Questions?" slides
- Decorative full-width colored bars at top/bottom (read as AI-generated)
- Underlines beneath titles (also reads as AI-generated)
- Cream/beige backgrounds when unrequested
- More than one accent color
- Anything that requires the audience to read for >5 seconds

### 2.4 Speaker notes — the format

For every content slide, write speaker notes in this format:

```
[Beat / purpose of this slide in 5–10 words]

• Talking point 1 (one short line, the speaker's thought, not a script)
• Talking point 2
• Talking point 3
• [Optional] Specific number/name/quote: 47.3% / "Acme Corp" / "as Drucker said..."
• [Optional] Transition cue: "this leads to the next point about X"
```

Notes are for the speaker's eye in the green room or on the confidence monitor — not for printing. Keep them scannable.

### 2.5 Build workflow

1. **Read** `/mnt/skills/public/pptx/SKILL.md` for pptxgenjs mechanics, and `/mnt/skills/user/de-slop/SKILL.md` (with its `references/banned-patterns.md`) for the text style layer.
2. **For each approved slide in the narrative** — pick the right archetype from 2.1, render it. All slide copy and speaker notes are written under `de-slop` Mode 1.
3. **Speaker notes for every content slide** — non-negotiable.
4. **No fabricated data, no fabricated quotes, no fabricated logos.** If the narrative needs a stat the user didn't give you, leave a placeholder `[STAT: revenue growth %]` and flag it in your handoff message.
5. **QA — stage readability gate (mandatory before shipping):** following the public pptx skill's QA process (extract-text + image inspection), check each slide against:
   - **Back-row test:** at thumbnail size (~3" wide), is every word still legible? If not, simplify or enlarge.
   - **3-second test:** can the slide be understood in 3 seconds? If not, it's too dense.
   - **Word count:** ≤15 words for keynote slides, ≤30 for pitch slides. Count them.
   - **Font sizes:** no text below 24pt anywhere on a content slide. Captions/attribution can go to 18pt. Source lines (rare) can go to 14pt. Anything below 14pt is forbidden.
   - **One idea per slide:** if you can't say what the one idea is in five words, the slide has more than one idea.
   - **Speaker notes present** on every content slide.
   - **De-slop pass:** sweep slide copy and speaker notes against `de-slop` `references/banned-patterns.md`. At stage word counts, any banned word is a headline-level error, not a footnote.
   - **No forbidden elements** (see 2.3).
   - **Contrast:** all text passes WCAG AA on its background.

---

## Things to push back on

This skill is opinionated. Push back when the user asks for:

- **A read-deck disguised as a presentation deck** ("add more detail to each slide so people can read it later") — these are two different deliverables. Offer to build a `consulting-slides` companion as a leave-behind.
- **A "thank you" or "questions?" closing slide** — explain why these are speaker-not-slide moments. If they insist, do it but warn it's amateur.
- **Logos on every slide** — push back once. If insisted, comply.
- **A pitch deck longer than 12 live slides** — long pitch decks lose the room. Anything beyond 12 belongs in the appendix or the data room.
- **Multi-color brand palettes used at full strength** — pick the dominant accent, demote the rest.
- **Numbers without units, sources, or comparison** — a stat with no anchor is a floating number. Either add the anchor or cut the stat.
- **Skipping speaker notes** — these are the value-add. The slide alone is half the deliverable.
- **Skipping the Phase 1 checkpoint** — never skip. If the user says "just build it", produce the narrative anyway and ask for explicit approval, framed as "30 seconds of your time saves a wrong deck".

---

## Quick mental check before shipping

Before declaring the deck done, mentally walk through it as if you were:

1. **The speaker** at the back of the room rehearsing — can you remember what you'll say from the slide alone + your notes?
2. **The audience** in row 30 — can you read everything on screen?
3. **A skeptical board member** watching the recording — does the deck respect your time?

If any of those three would push back, fix it before shipping.
