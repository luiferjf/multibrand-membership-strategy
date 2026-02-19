# Executive Report: Membership Strategy Viability

## 1. Strategic Recommendation: LAUNCH
Based on the financial simulation and historical data analysis, the recommendation is to **LAUNCH the Annual Membership Program at a price point of 99$**.

**Key Drivers for Decision:**
*   **Profit Maximization:** Projected **+58% Net Profit Lift** per active member.
*   **Risk Mitigation:** The model remains profitable even in worst-case shipping scenarios (up to 12 orders/year to remote zones).
*   **Market Fit:** Strong overlap between brand audiences (Soccer/Sports) supports the cross-selling hypothesis.

---

## 2. The Problem: "One-and-Done" Customers
Analysis of the current transactional database shows a critical weakness in retention.
*   **Insight:** **80% of customers purchase only once**.
*   **Diagnosis:** The friction of paying shipping fees per order discourages retention and cross-shopping.
*   **Metric:** **Cross-Shop Index: 1.02**. Only 2% of our customers shop across brands. This confirms we are operating as 4 isolated silos, not an ecosystem.

![Churn Distribution Chart](assets/churn_distro.png) 
*(See `tableau/Visualizations/Churn_Analysis` for interactive view)*

---

## 3. The Solution: Ecosystem Unification
The Annual Membership (99$) acts as a bridge between our 4 siloed brands:
*   **Pasión Albiverde (Local Soccer Team)** ↔ **Rabbona (Global Soccer)**: High affinity overlap.
*   **Victus (Sports Lifestyle)** ↔ **Nebula (Trend/Pop Culture)**: Broader lifestyle appeal.

By charging an upfront fee, we create a "sunk cost" effect that motivates the customer to consolidate their apparel spending within our ecosystem to maximize their free shipping benefit.

---

## 4. Pricing Analysis: Why 99$?
We conducted a sensitivity analysis simulating adoption rates at different price points.

*   **99$ (Recommended):**
    *   **Adoption:** High (Low barrier to entry).
    *   **Customer ROI (1.6x):**
        *   *Scenario:* A Standard Member places 4 orders/year with an Average Order Value (AOV) of 142$.
        *   *Savings:* ~72$ (Shipping) + ~85$ (15% Discount) = **157$ Total Benefit**.
        *   *Cost:* 99$ Fee.
        *   *Result:* The customer recovers their investment in ~3 orders, making the membership a "no-brainer".
    *   **Outcome:** Maximizes total market penetration (Volume strategy).

*   **149$ (Rejected):**
    *   **Adoption:** Significantly lower because the break-even point pushes to ~5 orders, making the value proposition unclear for casual buyers.

![Pricing Sensitivity Curve](assets/price_sensitivity.png)
*(See `tableau/Visualizations/Pricing_Model`)*

---

## 5. Profitability Mechanics (Financial Waterfall)
Does "Free Shipping" kill our margins? **No.**
The upfront fee (99$) + increased frequency covers the logistics cost.

**Unit Economics Comparison:**
*   **Standard User (2 Orders/Year):**
    *   Revenue: 284$
    *   Net Profit: ~142$
*   **Member (4 Orders/Year - Conservative Estimate):**
    *   Revenue: 568$
    *   Plus Fee: +99$
    *   Less Shipping + 15% OFF: (Subsidized)
    *   **Net Profit: ~225$ (+58% Uplift)**

The simulation proves that the **Volume + Fee** structure outperforms the **Margin-per-unit** model.

![Profitability Waterfall](assets/waterfall_profit.png)
*(See `tableau/Visualizations/Financial_Waterfall`)*

---

## 6. Risk Audit: The "Stress Test"
We modeled a "Worst-Case Scenario" to identify the break-even point for the business.
*   **Scenario:** A customer ordering the lowest margin item (1 Mug) shipped to the most expensive zone (Remote/Cobija).
*   **Result:** The model only breaks (becomes unprofitable) if a customer places **>12 separate orders per year** under these specific conditions.
*   **Cannibalization Check:** We analyzed the impact on "Heavy Users" (5+ orders/year). The upfront fee covers the discount subsidy, meaning we do not lose margin even on our most loyal customers. We only profit *less* per unit, but significantly *more* per year due to retention.
*   **Stat:** Such behavior represents <0.1% of purely transactional probability. The risk is negligible.

![Stress Test Visualization](assets/stress_test.png)
*(See `tableau/Visualizations/Stress_Test`)*
