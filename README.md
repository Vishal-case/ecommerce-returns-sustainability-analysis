# ecommerce-returns-sustainability-analysis
Advanced SQL project uncovering the root causes of retail product returns. Quantifies both financial drain and environmental impact (CO₂ &amp; waste) to help e-commerce brands optimize profitability and sustainability.

# E-Commerce Product Returns & Sustainability Performance Analysis

## 📌 Business Overview & Objective
Our e-commerce platform has been experiencing a high volume of product returns. These returns create a dual-threat to the company:
1. **Financial Impact:** Escalating reverse-logistics costs, lost margins, and reduced net profitability.
2. **Environmental Impact:** Unnecessary carbon emissions from extra shipping legs and increased packaging waste.

**The Objective:** As the Data Analyst, my goal was to use SQL to investigate the dataset from 15 distinct business perspectives to answer the core management question: *“How can the company reduce product returns, minimize financial losses, and improve corporate sustainability goals without hurting the customer experience?”*

---

## 🛠️ Tech Stack & Key SQL Concepts Used
* **Database Engine:** MySQL / PostgreSQL
* **Advanced Analytics Concepts:**
  * **Common Table Expressions (CTEs):** Used for multi-layered customer and product-level analysis.
  * **Window Functions (`OVER()`):** Utilized to calculate percentages across cumulative totals (e.g., return reason distribution).
  * **Conditional Aggregations (`CASE WHEN`):** Deployed extensively to isolate metrics specifically for returned vs. non-returned orders.
  * **Data Bucketing & Segmentation:** Grouped continuous values into clear business cohorts (Age groups, Discount tiers, Return-timing windows).
  * **Date Manipulation:** Formatted text strings into proper date metrics to evaluate Month-over-Month (MoM) macro trends.

---

## 🧩 Project Structure & SQL Coverage
The analysis script is structured systematically into 15 critical segments requested by management:

1. **Overall Return Performance:** Establishing the baseline (Total orders, overall return rate, average days to return).
2. **Return Reasons Breakdown:** Identifying the top 3 core drivers behind customer returns.
3. **Product Category Metrics:** Ranking categories by financial risk and overall return rates.
4. **Product-Level Deep Dive:** Filtering out the Top 10 worst-offending products bleeding cash.
5. **Customer Profiling:** Pinpointing high-frequency returners and identifying heavy-loss customer accounts.
6. **Age Group Cohorts:** Segmenting behavioral data across age brackets (e.g., 18–25, 26–35, etc.).
7. **Gender Analysis:** Checking if there is a statistically significant variance in gender buying behaviors.
8. **Geographical Location Analysis:** Tracking spatial clusters driving up shipping and eco-costs.
9. **Shipping Method Impact:** Correlating express vs. standard logistics choices with higher return damages.
10. **Payment Method Analysis:** Investigating if certain payment flows act as leading indicators for product abandonment.
11. **Discount-Elasticity Analysis:** Verifying if aggressive markdowns (30%+) correlate with lower customer satisfaction and higher returns.
12. **Return Timing Windows:** Mapping return cycles into day-count buckets (0–7 days, 8–14 days, etc.).
13. **Sustainability Quantifications:** Calculating exact cumulative & average CO₂ emissions and packaging wastage.
14. **The Eco-Profit Matrix:** Cross-referencing category profitability directly against environmental degradation.
15. **Time-Series Macro Trends:** Isolating the best/worst calendar months for business performance.

---

## 📈 Key Insights & Findings (Teaser)
*(Note: Replace the placeholders below with your actual data once queries are executed!)*

* **The Baseline:** The business is currently operating at an overall return rate of **[Insert Rate]%**, representing a total pure logistics loss of **$[Insert Cost]**.
* **The Root Causes:** The top 3 return reasons (**[Reason 1]**, **[Reason 2]**, and **[Reason 3]**) account for **[Insert %]%** of all returned inventory.
* **The Eco Impact 🌱:** Returned orders on average generate **[Insert %]x** more packaging waste and carbon emissions than successfully completed cycles. 
* **The Promotional Trap:** Heavy discounts exceeding 30% **[increased / stabilized]** overall returns, directly damaging net category profitability.

---

## 🚀 How To Explore This Repository
1. Clone this repository locally.
2. Load your data source into your standard SQL workbench environment.
3. Open and run the `returns_analysis.sql` script to review the complete analytical breakdown.
