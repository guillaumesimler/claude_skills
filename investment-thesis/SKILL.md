---
name: investment-thesis
description: "Use this skill whenever evaluating a startup, company, deal, deck, or investment opportunity through Guillaume's investment thesis. Triggers include: 'evaluate this startup', 'should I invest in X', 'what do you think of [company]', 'review this deck', 'analyse this opportunity', 'is this a good deal', or whenever the user drops a company name, URL, deck, or one-pager and asks for a take. Also trigger when the user asks about co-founder fit with a venture, joining an early-stage team, or whether a deal matches their thesis. Use even if the user doesn't say 'thesis' explicitly — if they want a structured opinion on an investable opportunity, use this skill. Apply for any stage from pre-seed through Series A. Do NOT use for public-market stock analysis, M&A advisory on mature companies, or general industry/market research (use market-research skill for the latter)."
---

# Investment Thesis — Guillaume Simler

## Purpose

Evaluate any startup, deal, or co-founder opportunity through Guillaume's two-step investment thesis. Output is a structured verdict — pass, conditional, or yes — with explicit reasoning grounded in buyer-side reality and non-technology moat.

This skill exists because Guillaume is actively scouting deals as both potential investor and co-founder candidate. Every evaluation must pass through the same lens to keep judgment consistent and rejections principled.

---

## The Thesis (the lens itself)

Guillaume backs early-stage B2B software in **two steps**, applied in this order. A deal must clear step 1 before step 2 is even evaluated.

### Step 1 — The Gate: buyer-side reality

The deal must clear all three buyer-side conditions. If any one fails, the verdict is **pass** regardless of technology, team, or TAM.

1. **Operational pain.** A buyer with budget authority loses time, money, or compliance margin *today* because the problem is unsolved. Not aspirational. Not "executive wants innovation." A line manager has a P&L hit they can name.

2. **Single-signer buyer.** ROI is legible to one person — typically a function head with discretionary spend. If the sale requires a committee, the cycle kills the company before product-market fit closes.

3. **Asymmetric switching cost.** The pain of staying with the current solution (spreadsheet, incumbent, manual process) is greater than the pain of adopting the new one. Integration risk, retraining, and data migration all sit below the threshold of the pain being solved.

These are properties of *how the buyer experiences the problem*, not properties of the product. Testable in 30 minutes of customer interviews.

### Step 2 — The Filter: non-technology moat

Once the gate clears, ask: **what compounds with each customer acquired that a well-funded entrant cannot replicate by spending more?** Only four kinds count:

1. **Distribution moat** — proprietary access to a buyer cohort that incumbents structurally cannot reach. Vertical channels, regulator relationships, embedded partnerships.

2. **Workflow-locked data moat** — customer data accumulates inside the workflow such that switching means losing accumulated state. Each customer's data makes their next action faster, and the data is unportable.

3. **Buyer-side network effects** — the product gets better for buyer N+1 because buyer N is on it. Marketplaces, benchmark data, peer comparison.

4. **Regulatory or trust moat** — certification, compliance, audit trail that takes 18+ months to replicate, in a domain where buyer risk tolerance is zero.

**Technology is not on the list.** Algorithms get copied. Models get distilled. Technology buys a head start, never a moat.

### Tagline

**Gate first, moat second.**

---

## What Guillaume brings (used to assess co-founder fit)

When evaluating co-founder opportunities (not just investments), check whether Guillaume's contribution actually compounds the venture:

- **Industrial CFO/MD experience** — 15+ years buying enterprise SaaS as the buyer.
- **Hands-on technical literacy** — ML, automation, full-stack (Velchanos).
- **Network of industrial SMB decision-makers across France, Germany, Switzerland.**
- **Bicultural FR/DE distribution access.**
- **Domain depth in industrial, financial, legal workflows in Europe.**

If a venture targets buyers Guillaume cannot reach (e.g., Asian SMB, US enterprise, consumer), his network adds zero — co-founder fit fails even if the investment thesis passes.

---

## Workflow — How to evaluate a deal

When the user drops a company, URL, deck, or one-pager, follow this sequence.

### Step A — Gather what's in front of you

Identify the company name, sector, stage (if visible), founders (if visible), pricing/business model, target buyer, and geography. If the user provided a URL, web-fetch it. If they provided a deck, read it. If they only gave a name, web-search for the basics — pricing page, founders, recent news, comparable companies.

If essential information is missing (e.g., you can't tell who the buyer is, or there's no pricing visible), **say so explicitly** and either ask the user or flag the assumption you're making.

### Step B — Apply the gate

For each of the three gate conditions, write 2–3 sentences:
- **Operational pain**: yes / no / unclear, and why.
- **Single-signer buyer**: yes / no / unclear, and why.
- **Asymmetric switching cost**: yes / no / unclear, and why.

If any gate fails clearly, the verdict is **pass** and you can stop here — no need to evaluate moat. State that explicitly: *"Gate fails on [condition]. Moat evaluation skipped per thesis."*

### Step C — Apply the moat (only if gate clears)

For each of the four moat types, write 2–3 sentences:
- Distribution: present? at what strength?
- Workflow-locked data: present? what data, what lock?
- Buyer-side network effects: present? real or claimed?
- Regulatory trust: present? barrier height?

If at least one is **strongly** present and credible, moat clears. If all four are weak or absent, verdict is **pass**.

### Step D — Co-founder fit (if user asked about joining, not just investing)

Two questions:
1. Does Guillaume's network/skill set actually move the needle for this venture?
2. Does the venture give Guillaume something he values (domain learning, equity at the right stage, role with real authority)?

Both must clear for co-founder fit. Even a passing investment verdict can fail co-founder fit if Guillaume adds no leverage.

### Step E — Verdict + conditions to revisit

End with one of three verdicts:

- **Yes** — both gate and moat clear; pursue (invest, or interview as co-founder if applicable).
- **Conditional yes** — clear path to pass, but specific milestones must be hit. List 2–3 measurable conditions.
- **Pass** — at least one structural reason it does not fit the thesis. Always include 2–3 conditions to revisit, so the rejection is principled, not reflexive.

Always include conditions to revisit, even on a pass. A no-with-conditions is more defensible than a no-with-vibes.

---

## Output format

```
## [Company Name] — [one-line description]

### Gate (buyer-side reality)
- **Operational pain**: [yes/no/unclear] — [reasoning]
- **Single-signer buyer**: [yes/no/unclear] — [reasoning]
- **Asymmetric switching cost**: [yes/no/unclear] — [reasoning]

[If gate fails: "Gate fails on [condition]. Moat evaluation skipped."]

### Moat (only if gate cleared)
- **Distribution**: [strong/weak/absent] — [reasoning]
- **Workflow-locked data**: [strong/weak/absent] — [reasoning]
- **Buyer-side network effects**: [strong/weak/absent] — [reasoning]
- **Regulatory trust**: [strong/weak/absent] — [reasoning]

### Co-founder fit (if relevant)
- **Does Guillaume add leverage?**: [yes/no] — [reasoning]
- **Does the venture serve Guillaume?**: [yes/no] — [reasoning]

### Verdict: [Yes / Conditional yes / Pass]
[1–2 sentence summary]

### Conditions to revisit
1. [Specific, measurable signal]
2. [Specific, measurable signal]
3. [Optional third]
```

---

## Tone and rules

- **No sycophancy.** Guillaume wants stances, not hedges. If the deal is bad, say so. If it's good, say so.
- **Take a stance even on partial information.** State the assumption, then commit to a verdict. "I cannot evaluate without more data" is rarely the right answer at this level.
- **Never rationalize a yes.** If you find yourself building three-step reasoning chains to justify a yes, the answer is probably no. Strong yeses read clean.
- **Never soften with TAM.** TAM is irrelevant if the product cannot capture it economically. If you catch yourself writing "but the market is large," delete it.
- **Be specific.** Name competitors, name buyers, name pricing. "Crowded market" without naming Ironclad, DealHub, etc. is lazy.
- **Language follows the deal.** If the deck is in French, evaluate in French. If German, German. Default English.

---

## Defense readiness

Every evaluation should be ready for hostile probing — by an LP, an MBA jury, or the user themselves on second thought. Two recurring attack lines deserve prepared answers; both are documented in `references/defense-questions.md`:

- The "Grumpy LP" contradiction (gate vs. moat coherence).
- "What does a yes actually look like?" (concrete profile of an ideal deal).

Read `references/defense-questions.md` whenever the user pushes back on a verdict, asks "are you sure?", or runs the evaluation in an academic/jury context where defense questions will follow.

---

## What this skill does NOT do

- **Public-market analysis.** Different game, different math.
- **Mature-company M&A.** Use general M&A judgment, not this thesis.
- **Industry research without a specific company.** Use the `market-research` skill for that.
- **Generic "should I start a company about X" questions.** Bring a target or a real opportunity.

---

## Process summary

1. Gather what's in front of you (web-fetch, web-search, read deck if provided).
2. Apply the gate. If it fails, stop and write the pass.
3. Apply the moat. If all four are weak, write the pass.
4. If co-founder fit is in scope, evaluate both directions.
5. Write verdict + conditions to revisit.
6. Read `references/defense-questions.md` if the user pushes back or wants defense-readiness.
