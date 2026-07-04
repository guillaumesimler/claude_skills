## Class Prep: Corporate Finance — Session on WACC & Capital Structure

### Previous Session Summary

Last session covered the theoretical foundations of capital structure through the Modigliani-Miller (MM) framework and its real-world extensions.

**MM Proposition I (no taxes):** In perfect capital markets, firm value is independent of how it is financed — `V_L = V_U`. The intuition is that investors can replicate any firm leverage through homemade leverage, so a firm can't create value by simply reshuffling its financing.

**MM Proposition II (no taxes):** As leverage increases, the cost of equity rises proportionally — `r_E = r_U + (D/E)(r_U - r_D)` — exactly offsetting the cheaper cost of debt. WACC stays flat. Equity becomes riskier as more fixed debt obligations sit ahead of it, so equity holders demand higher returns.

**MM with taxes — the tax shield:** Interest is tax-deductible, giving debt a government subsidy. Levered firm value rises: `V_L = V_U + T_c × D`. This means WACC *falls* as leverage rises. At the US 21% corporate rate, every $1B of permanent debt adds ~$210M in value from the shield alone.

**Tradeoff theory:** If debt were purely free money (tax shield), every firm would be 100% debt-financed. The tradeoff theory adds financial distress costs to the equation: `V* = V_U + PV(Tax Shield) - PV(Distress Costs)`. Optimal capital structure is firm-specific — stable, asset-heavy firms (utilities, real estate) carry more debt; high-growth, intangible-asset firms (tech, biotech) stay lightly leveraged because distress would destroy their option value.

**Tesla case (2019–2023):** Tesla exemplified the tradeoff. In 2019, near-bankruptcy and junk-rated, it had expensive debt and precarious growth options. After stock price surged, it raised cheap equity multiple times (2020–2021), drastically cutting leverage — preserving growth optionality for Gigafactories and FSD. By 2023, achieving sustained GAAP profitability, it began transitioning toward a more conventional, investment-grade capital structure.

---

### In the News

1. **Tech Sector Debt Surge Signals Shifting Capital Structures** — *OECD Global Debt Report 2026, February 2026*
   Technology firms issued $122B in bonds in 2025 — 3× their historical average — primarily to fund AI infrastructure capex. The OECD warns this rapid leverage build-up could prompt credit rating downgrades if AI returns fail to materialize quickly. This is a live test of MM's limits: when markets doubt the quality of the assets debt is funding, the tax shield is outweighed by rising distress risk premiums. Directly relevant to class discussions of when the tradeoff optimum shifts.

2. **Private Credit vs. Banks: Tug of War for Leveraged Buyout Financing** — *CNBC, March 27, 2026*
   After private credit funds peaked at ~80% of LBO financing in 2023–2024, banks have clawed back to ~50% of deals above $1B. Private credit is showing strain: years of aggressive lending at high leverage ratios are producing rising defaults as high rates erode borrower cash flows. This is a real-world stress test of LBO capital structure — the cases where debt/equity ratios of 70–80% were pushed to the limit. Connects directly to the tradeoff theory's financial distress cost curve.

3. **Hidden Leverage in Leveraged Finance Raises Systemic Risk Concerns** — *Moody's / Octus, January 2026*
   Moody's flagged growing use of Payment-In-Kind (PIK) debt and Net Asset Value (NAV) lending — forms of leverage that sit off the rated entity's balance sheet, making them difficult to monitor. PIK debt defers cash interest by adding it to principal, which looks like lower near-term leverage but amplifies eventual distress. This is MM's information asymmetry assumption violated in practice: when true leverage is hidden, market discipline on capital structure breaks down.

---

### Devil's Advocate

Here's the other side of the MM/tradeoff framework: **the leverage puzzle suggests firms are systematically leaving money on the table — and they may be doing it rationally.**

Graham (2000) estimated that profitable firms under-leverage by enough to forgo ~10% of firm value in tax shields. Tradeoff theory predicts they should borrow more. They don't. Why?

One answer is **pecking order theory** (Myers & Majluf, 1984): managers know more about firm value than markets do. Issuing debt or equity signals information — equity issuance signals the stock is overvalued, debt issuance reveals capacity constraints. Firms therefore prefer internal funds first, then debt, then equity last — not because of taxes and distress costs, but because of asymmetric information. The "optimal leverage" from tradeoff theory is irrelevant if firms can't move toward it without triggering adverse market reactions.

A second challenge is **market timing** (Baker & Wurgler, 2002): capital structure reflects the accumulated history of when firms happened to find cheap financing, not a deliberate optimization. If true, there is no optimal target — just path dependency.

The Tesla case cuts against tradeoff theory too: Tesla issued equity multiple times when its stock was sky-high, not when it was cheap — classic market timing, not tradeoff optimization. Yet the outcome was excellent. The theory predicts behavior; the data shows something messier and perhaps smarter.

**For class:** Frame every capital structure question as: "What does MM say? Which specific assumption is violated? Which theory — tradeoff, pecking order, or market timing — best explains the deviation?"
