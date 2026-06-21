---
name: market-research
description: >
  Use this skill whenever the user wants to research a market, sector, technology, or company — especially when the output should be a structured report for board-level, investor, or strategic audiences. Triggers include: "research this market", "analyze this sector", "size this market", "give me a market overview", "do a competitive analysis", "what are the key drivers of X", "analyze this company", "I'm looking at this space", or any time the user drops a company name, a PDF brief, or a short description and wants a structured intelligence output. Also trigger when the user asks about TAM/SAM, market shares, structural trends, or key growth drivers in any industry. Use even if the user doesn't say "report" — if they want market intelligence, use this skill.
---

# Market Research Skill

Produces a board-level, 2-page market intelligence report from minimal input (PDF, text, or company name). Output is a professionally formatted Word (.docx) document with charts, structured sections, and cited sources.

---

## Step 0 — Ask the framing question first

Before any research, ask:

> "Is this research for (1) general market intelligence, (2) an incumbent player, or (3) a startup entering the space?"

This shapes the entire angle:
- **General:** Neutral, balanced, sector-wide lens
- **Incumbent:** Focus on disruption threats, market share erosion, competitive moats
- **Startup:** Focus on entry points, whitespace, customer pain, incumbent weaknesses

---

## Step 1 — Parse the input

Accept any of:
- **PDF brief** → extract company name, sector, geography, stated thesis
- **Short text** → extract the same fields
- **Company name only** → infer sector, geography, stage from web search

If input is ambiguous, infer and state your assumption. Don't ask for clarification — make a call.

---

## Step 2 — Deep research phase

Run a minimum of **12–15 web searches**. Prioritize high-quality sources:

**Preferred sources (always try these first):**
- World Bank, IEA, IRENA, OECD, Eurostat, UN data
- McKinsey Global Institute, BCG Henderson Institute, Bain
- Statista, Grand View Research, MarketsandMarkets (for sizing)
- Bloomberg NEF, Wood Mackenzie (energy/cleantech)
- Crunchbase, PitchBook (competitive landscape)
- Company investor relations pages, annual reports
- Industry associations (e.g. ACEA for automotive, GSMA for telco)

**Research targets — gather data on each:**

### A. Structural drivers
Identify 3–5 macro drivers behind this market (e.g. urbanization rates, electrification penetration, demographic shifts, regulatory tailwinds, cost curve evolution). For each, find a quantified data point with source and year.

### B. Market sizing
- Global TAM ($ value + CAGR, with source + year)
- SAM by relevant geography (Europe, North America, Asia-Pacific minimum if global)
- Top 3 geographies by market size and/or growth rate
- Data format: table-ready (name, size, CAGR, horizon)

### C. Competitive landscape
- Overall market concentration (HHI or qualitative)
- Players with >10% market share → name, share %, brief descriptor
- If no market share data available, use revenue rankings or funding rounds as proxy — flag clearly
- Key competitive dynamics (consolidation trend? platform vs. point solution? etc.)

### D. Technology trends
- 3–4 technology shifts actively reshaping the market
- Adoption stage for each (emerging / scaling / mature)
- Link to competitive or commercial implications

### E. Source list
Keep a running list of every source used: title, URL, year, institution. Minimum 8 sources. Will appear as section 7.

---

## Step 3 — Build charts (illustrative, data-backed)

Create **3 charts** using Python (matplotlib) saved as PNG files for embedding:

**Chart 1 — Market Size Bar Chart**
- X-axis: geographies or years (show 2–3 data points if time series available)
- Y-axis: market size in $B
- Style: clean, minimal, single color (#2E5D9E or similar navy), no gridlines clutter

**Chart 2 — Growth Rate Comparison**
- Horizontal bar chart comparing CAGRs across geographies or segments
- Sorted descending
- Highlight the top opportunity

**Chart 3 — Competitive Landscape**
- Pie or donut chart of market share if data available
- If not: a simple 2x2 positioning matrix (scale vs. focus) or a bar chart of revenue/funding by player
- Label players directly on chart, not in legend

**Chart style guidelines:**
```python
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches

# Always use this style baseline
plt.rcParams.update({
    'font.family': 'Arial',
    'font.size': 10,
    'axes.spines.top': False,
    'axes.spines.right': False,
    'figure.dpi': 150,
    'savefig.bbox': 'tight',
    'savefig.transparent': False,
    'figure.facecolor': 'white'
})
# Primary color: #2E5D9E | Accent: #E8734A | Light: #D5E8F0
```

Save charts to `/tmp/chart1.png`, `/tmp/chart2.png`, `/tmp/chart3.png`.

---

## Step 4 — Write the report

### Document structure (7 sections, 2 pages):

```
HEADER: [Market/Company Name] — Market Intelligence Brief
        [Date] | Confidential
        Research angle: [General / Incumbent / Startup]

─────────────────────────────────────────────────────

1. THE VIEW IN TWO LINES
   ▲ BULLISH: [2 lines max — most compelling upside case, quantified if possible]
   ▼ BEARISH: [2 lines max — key structural risk or headwind]

2. KEY STRUCTURAL DRIVERS
   [3–5 drivers, each with: name | data point | implication]
   [Embed Chart 1 here]

3. MARKET SIZE & GEOGRAPHY
   [TAM/SAM narrative + geography table]
   [Embed Chart 2 here]

4. COMPETITIVE LANDSCAPE
   [Concentration assessment + player table for >10% share holders]
   [Embed Chart 3 here]

5. TECHNOLOGY TRENDS
   [3–4 trends in table format: Trend | Stage | Commercial implication]

6. BOARD QUESTIONS
   Three questions a board member should ask. These must be:
   - Specific to this market, not generic
   - Polite in tone but targeting the uncomfortable truth
   - Pointed at assumptions that are hard to defend
   
   Format: numbered list, one line setup + the actual question

7. SOURCES
   [All sources used, 9pt grey font]
   Format per line: [Institution/Author] — [Title] — [Year] — [URL]
```

---

## Step 5 — Produce the .docx

Use the docx skill (see `/mnt/skills/public/docx/SKILL.md`) to generate the Word document.

**Formatting standards:**
- Page size: A4, margins 2cm all sides
- Font: Arial throughout
- H1 (report title): 22pt bold, dark navy (#1F3864)
- H2 (section headers): 15pt bold, #2E5D9E
- Body: 12pt, black
- Section 7 (sources): 9pt, grey (#666666)
- Color accents: navy #2E5D9E, orange #E8734A, light blue #D5E8F0
- Tables: alternating row shading (#F5F8FD / white), header row #2E5D9E white text
- Charts: embedded as ImageRun, full content width (9026 DXA for A4)
- Bullish/Bearish box: shaded callout (▲ green-tinted #E8F5E9, ▼ red-tinted #FFEBEE)
- Page numbers in footer, right-aligned

**Two-page discipline:** Be ruthless. If content overflows, compress prose — not structure. Every section must exist. Sources can wrap to a third page if needed — that's acceptable.

---

## Step 6 — Output

Save to `/mnt/user-data/outputs/[MarketName]_Market_Intelligence_[YYYY-MM-DD].docx`

Present the file. Add one sentence in chat: the single most counterintuitive finding from the research.

---

## Quality checklist before output

- [ ] Framing question answered (general / incumbent / startup)
- [ ] Every data point has a source and year
- [ ] Bullish and bearish views are each max 2 lines, specific
- [ ] TAM and SAM both present with CAGR
- [ ] Competitive section has actual share data or flagged proxy
- [ ] 3 charts generated and embedded
- [ ] Board questions are specific to this market — not generic
- [ ] Sources section has ≥ 8 entries with URLs
- [ ] Document is ≤ 2 pages (sources overflow acceptable)
