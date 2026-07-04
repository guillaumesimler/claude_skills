# Corporate Finance — Class Prep: WACC, Capital Structure & MM Theorem

**Building on:** MM Theorem, Leverage, Tax Shield, Tradeoff Theory, Tesla case (2019–2023)

---

## 1. Recap of Last Session — The Core Framework

### Modigliani-Miller Theorem

Franco Modigliani and Merton Miller's foundational insight (1958/1963) is that in **perfect capital markets**, capital structure does not matter. What matters is the left side of the balance sheet (asset quality, cash flows), not how you finance it.

**Perfect market assumptions (when MM holds):** No taxes, no transaction or bankruptcy costs, symmetric information, no agency costs, investors can borrow/lend at the same rate as firms.

---

### MM Proposition I — Capital Structure Irrelevance (No Taxes)

**The claim:** `V_L = V_U`

**Intuition:** Investors can "undo" any capital structure through *homemade leverage*. So the firm cannot create value just by rearranging its financing.

---

### MM Proposition II — Cost of Equity Rises with Leverage (No Taxes)

```
r_E = r_U + (D/E) × (r_U - r_D)
```

Higher leverage concentrates the same operating risk on a smaller equity base — equity holders demand a higher return. But this exactly offsets the "cheap debt" benefit. **WACC remains constant.**

---

### MM With Taxes — The Tax Shield

```
V_L = V_U + T_c × D
```

Every dollar of permanent debt saves `T_c` dollars in taxes. At 21% US corporate rate, $1B of debt = ~$210M of value from the tax shield.

**Effect on WACC:** WACC falls as leverage increases because after-tax cost of debt < pre-tax.

```
WACC = (E/V) × r_E + (D/V) × r_D × (1 - T_c)
```

---

### The Tradeoff Theory

Optimal capital structure balances tax shield benefits against financial distress costs:

```
V* = V_U + PV(Tax Shield) - PV(Financial Distress Costs)
```

**High optimal leverage:** Stable cash flows, tangible assets (utilities, real estate, mature industrials)  
**Low optimal leverage:** Volatile cash flows, intangible assets, high growth options (tech, biotech)

---

## 2. Tesla Capital Structure Evolution (2019–2023)

| Year | Event | Implication |
|---|---|---|
| 2019 | Near-bankruptcy; high-yield debt; Model 3 ramp | High distress risk; expensive debt |
| 2020 | Multiple equity offerings; stock +700% | Drastically reduced leverage; cash war chest |
| 2021 | S&P 500 inclusion; $5B equity offering | Near-zero leverage; growth optionality preserved |
| 2022 | Rising rates; Twitter/Musk perception risk | Corporate structure clean but CEO overhang |
| 2023 | GAAP profitability; IG credit pursuit | Transition to mature, lower-WACC structure |

**Key analytical point:** Tesla's growth options (Gigafactories, FSD, energy) are destroyed in financial distress — indirect bankruptcy costs dominate. Tradeoff theory correctly predicts low leverage for this asset profile.

---

## 3. Devil's Advocate Challenges

**The leverage puzzle:** Profitable firms systematically under-leverage vs. tradeoff theory predictions — Graham (2000) estimated 10% of firm value left on table.

**Pecking order (Myers & Majluf):** Firms follow a hierarchy — internal funds, then debt, then equity last. Equity issuance signals overvaluation. Tesla's 2020 equity raises *should* have tanked the stock under this theory; they didn't — worth raising.

**Market timing (Baker & Wurgler):** Capital structure is the accumulated result of opportunistic timing, not optimization. No "optimal target" — just history.

**Miller (1977) — investor-level taxes:** The corporate tax shield on debt may be competed away at the investor level if equity is taxed more favorably than interest income.
