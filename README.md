# Strategic Pivot: Multi-Brand Membership to Maximize Frequency & Profit

## Executive Summary

This project analyzes the financial and strategic viability of launching an **Annual Membership Program ($99)** across a portfolio of four casual apparel brands currently operating in silos.

The analysis reveals that while the business has a strong niche presence, it suffers from a **high churn rate (80% of customers are one-time buyers)**. The proposed membership model is designed to solve this by incentivizing **Purchase Frequency** and **Cross-Selling** through free shipping benefits.

**The Conclusion:** The financial simulation confirms that this strategy yields a **+58% Net Profit Lift** per active member. This approach projects an increase in Annual Customer Net Profit LTV from a baseline of **$142 to $225** per active member.

![Membership Strategy Dashboard](assets/main-dashboard.png)

> 💡 **Interactive Dashboard:** [View Live Dashboard on Tableau Public](https://public.tableau.com/views/E-commerceLTVMaximizationMulti-BrandMembershipStrategy/Dashboard1)

---

## Business Context: The Fandom Ecosystem

The business operates an ecosystem of four distinct **Casual/Streetwear Brands** in Bolivia, each targeting high-intent "fandoms":

1. **Pasión Albiverde (The Anchor):** Casual apparel for fans of *Oriente Petrolero* (Local Soccer Giant). High loyalty base.
2. **Rabbona (Global Soccer):** Apparel celebrating international football culture (Real Madrid, Barca, UCL).
3. **Victus (Sports Lifestyle):** Minimalist designs for fans of global sports trends (F1, Tennis, NFL).
4. **Nebula (Pop Culture):** Trend-reactive merch (Movies, Series, Viral Trends). The entry point for a broader, younger demographic.

**The Opportunity:**
Currently, these brands operate independently. A customer buying a Pasión Albiverde T-shirt likely has interests in F1 or Real Madrid, but the current model (paying separate shipping per store) creates friction against cross-brand exploration.

---

## The Challenge: High Churn & Low Frequency

Data analysis of historical transactions highlighted two critical bottlenecks:

* **The "One-Hit Wonder" Effect:** **80%** of customers purchase only once and never return.
* **Siloed Behavior:** Cross-shopping between brands is virtually non-existent.
  * **Data:** Our analysis of 2,919 unique customers revealed a **Cross-Shop Index of 1.02**.
  * **Insight:** Only **2.16%** of customers have ever purchased from more than one store, validating the "Silo" problem. The friction of separate checkouts/shipping is a hard barrier.

---

## The Solution: A Unified Membership

**Proposal:** A **$99 Annual Fee** that grants Free Shipping across **ALL 4 STORES** and 15% discount on all purchases.

**Strategic Logic:**

* **Frequency Driver:** The "sunk cost" of the membership fee psychologically incentivizes the customer to purchase more often to "amortize" their investment.
* **Cross-Sell Enabler:** By removing the shipping cost barrier, a Pasión Albiverde customer can frictionlessly try a product from Rabbona or Victus, effectively unifying the customer base.

---

## Data Analysis & Validation

The project followed a rigorous quantitative approach to validate the model's safety and profitability:

### 1. Pricing Strategy (The "Sweet Spot")

We simulated adoption rates vs. profit margins at various price points ($99, $129, $149).

* **Result:** **$99** was identified as the optimal price point. It maximizes adoption volume (Customer ROI > 1.5x) while maintaining a healthy profit margin for the business.

### 2. Financial Impact (LTV Waterfall)

A detailed P&L simulation per customer was created to compare a Standard User vs. a Member.

* **Finding:** A Member purchasing 4 times/year generates a Projected Net Profit LTV of **$225**, up from the **$142** baseline. This represents a **+58% Net Profit Lift** per customer even after accounting for the subsidized shipping costs. The Annual Fee acts as a powerful buffer that protects margins.

### 3. Risk Assessment (The Stress Test)

A "Worst-Case Scenario" was modeled to ensure the business wouldn't lose money on "bad" customers (e.g., those ordering low-margin items shipped to remote zones).

* **Result:** The model is highly resilient. A customer would need to place **>12 orders/year** of low-margin items to remote zones for the model to become unprofitable. This extreme outlier scenario represents <1% of the user base.

---

## Tools & Technologies

* **SQL:** Extraction of historical transaction data and Churn Analysis (Foundation v1 DB).
* **Excel:** Financial modeling, sensitivity analysis, and scenario planning.
* **Tableau:** Visualization of the Strategic Narrative (Frequency, Pricing, Waterfall, Stress Test).

---

## Repository Structure

* `sql/`: Queries used for data extraction and customer identity resolution.
* `data/`: Cleaned datasets used for the Tableau visualization.
* `tableau/`: The packaged workbook containing the strategic dashboard `.twbx`.
* `assets/`: Exported images of the key dashboard visualizations for reporting.
* `doc/EXECUTIVE_REPORT.md`: In-depth business memo detailing the strategic rollout.
