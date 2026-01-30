# Customer Analytics Dashboard - Key Insights

## Executive Summary

Analysis of 34 customers reveals severe retention challenges and dangerous revenue concentration, with 62% one-time buyers and 48% of revenue dependent on just 2 customers.

**Dashboard Link:** [View Interactive Dashboard](https://public.tableau.com/app/profile/lenny.success.humphrey/viz/SQLPortfolioAnalyticsE-CommerceBusinessInsights/CustomerAnalyticsAndSegmentation)

---

## Critical Findings

### 🚨 Finding 1: One-Time Buyer Crisis

**Observation:**
62% of customer base (21 customers) made only one purchase
- Bronze tier: 21 customers (62%)
- Single order average: $1,158
- Never returned after first purchase
- Combined one-time buyer value: ~$24,000

**Business Implications:**
- Acquisition cost wasted on non-returning customers
- No customer lifetime value expansion
- Indicates product/service issue or poor post-purchase experience
- Marketing spend ROI is severely limited

**Recommended Actions:**
1. **Immediate:** Implement post-purchase email sequence
2. **30 days:** Create loyalty program (10% off second order)
3. **60 days:** Survey one-time buyers for feedback
4. **90 days:** Launch Bronze → Silver conversion campaign
5. **Ongoing:** Track repeat purchase rate as primary KPI

**Target:** Increase repeat purchase rate from 38% to 50% within 6 months
**Potential Impact:** Converting 30% of Bronze = $7,200+ additional revenue

**SQL Problem Applied:** B29 (Order count per customer, frequency analysis)

---

### ⚠️ Finding 2: Platinum Customer Dependency

**Observation:**
Only 2 Platinum customers (6% of base) drive 46% of revenue
- Hank: $9,350 (24% of total revenue)
- Amy: $8,740 (22% of total revenue)
- Combined: $18,090 (46%)
- Next closest: Rita at $4,200 (11%)

**Business Implications:**
- Losing either Platinum customer = immediate 22-24% revenue loss
- Business continuity risk is extreme
- No redundancy in high-value segment
- Acquisition strategy has failed to build depth

**Recommended Actions:**
1. **Urgent:** Assign dedicated account manager to Hank and Amy
2. **Immediate:** Implement VIP program (exclusive benefits, priority support)
3. **Strategic:** Target acquisition of similar high-value customers
4. **Defensive:** Monitor Platinum customer health indicators daily
5. **Long-term:** Develop 10 customers to Gold tier to reduce dependency

**Target:** Add 3 new Platinum customers OR grow 5 Gold to Platinum within 12 months

**SQL Problem Applied:** A32 (Customer LTV calculation with window functions)

---

### 📉 Finding 3: Silent Churn in Progress

**Observation:**
12 customers inactive for 180+ days (high churn risk)
- Combined historical value: ~$8,200
- 5 customers: 1 order, 270-330 days inactive (likely lost)
- 2 customers: Multiple orders, 300+ days inactive (critical)
- Zero re-engagement attempts visible in data

**Churn Matrix Breakdown:**
- 🟢 Safe zone (0-90 days, multiple orders): 8 customers
- 🟡 Warning zone (90-180 days): 5 customers
- 🔴 Danger zone (180+ days): 12 customers
- 🟢 Never ordered (acquisition failure): 7 customers

**Business Implications:**
- $8K in historical customer value at risk
- Churn likely permanent without immediate intervention
- Customer lifetime value projections are overstated
- Indicates poor customer engagement strategy

**Recommended Actions:**
1. **This week:** Launch win-back email campaign to 180+ day inactive
2. **Offer:** 20% discount + free shipping to recover high-risk customers
3. **90-180 day inactive:** Gentle reminder email + new product showcase
4. **Process:** Implement automated re-engagement at 60/90/120/180 day marks
5. **Analysis:** Conduct exit interviews/surveys for churned customers

**Target:** Recover 25% of high-risk customers (3 out of 12) = $2,000+ revenue

**SQL Problem Applied:** B26 (Date interval arithmetic for churn detection)

---

### 📊 Finding 4: Tier Imbalance

**Observation:**
Customer tier distribution heavily skewed to Bronze
- Platinum: 2 customers (6%)
- Gold: 5 customers (15%)
- Silver: 6 customers (18%)
- Bronze: 21 customers (62%)

**Tier Value Contribution:**
- Platinum: $18,090 (46%)
- Gold: $12,800 (33%)
- Silver: $6,200 (16%)
- Bronze: $2,295 (6%) 

**Business Implications:**
- Top 20% of customers drive 79% of revenue (Pareto principle confirmed)
- Bronze tier is acquisition cost sink (high spend, low return)
- Massive opportunity in tier upgrades
- Current strategy optimized for acquisition, not retention/expansion

**Recommended Actions:**
1. **Bronze → Silver:** Target customers who spent $200-400 on first order
2. **Silver → Gold:** Offer bundle deals to push above $1,000 threshold
3. **Gold → Platinum:** Exclusive products/services for $5K+ spenders
4. **Tiered Benefits:** Create clear incentives for each tier progression
5. **Measurement:** Track tier progression as success metric

**Target:** Move 5 Bronze to Silver, 2 Silver to Gold within 6 months

**SQL Problem Applied:** I3 (Customer segmentation with CASE logic)

---

## Secondary Observations

### Customer Acquisition Pattern

**LTV Scatter Plot Shows:**
- Early customers (2023-2024) have higher LTV on average
- Recent acquisitions (2025) mostly in Bronze tier
- Acquisition quality declining over time

**Implication:** Recent marketing channels may be lower quality or pricing has changed

---

### Geographic Concentration

**Top Countries by Customer Count:**
- Nigeria: 9 customers
- Ghana: 6 customers
- Kenya: 5 customers
- Others: 14 customers

**Implication:** Africa-focused but not over-dependent on single market

---

## Connections to Revenue Dashboard

Customer analysis explains revenue volatility observed in Dashboard 1:

**Question:** Why did February revenue drop 88.72%?
**Answer:** 62% one-time buyers + high churn = no recurring revenue base

**Question:** Why is revenue concentrated in 3 customers?
**Answer:** Only 2 Platinum customers exist, and Gold tier only has 5

**Question:** Can revenue grow sustainably?
**Answer:** Not without fixing retention - current model is leaky bucket

---

## Churn Risk Matrix Analysis

### Matrix Quadrants

**Bottom-Right (Safe):** 8 customers
- Multiple orders (4+), purchased recently (0-90 days)
- **Action:** Maintain engagement, upsell opportunities

**Top-Right (Warning):** 5 customers  
- Multiple orders (2-3), but 90-180 days inactive
- **Action:** Re-engagement campaign with new product info

**Top-Left (Critical):** 12 customers
- Few orders (1-2), 180+ days inactive
- **Action:** Aggressive win-back with discount

**Bottom-Left (Never Converted):** 7 customers
- Registered, browsed, never ordered
- **Action:** Welcome series, first-purchase incentive

---

## Metrics Summary

| Metric | Value | Benchmark | Status |
|--------|-------|-----------|--------|
| Repeat Purchase Rate | 38% | 50-60% ideal | ⚠️ Low |
| Customer Concentration (Top 2) | 46% | <20% ideal | 🚨 Critical |
| Churn Risk (180+ days) | 35% | <15% acceptable | 🚨 High |
| Tier Distribution (Bronze) | 62% | <40% ideal | ⚠️ Poor |
| Average LTV | $1,159 | $2,000 target | ⚠️ Below |

---

## Retention Economics

**Current State:**
- 21 Bronze customers @ $1,158 avg = $24,318 one-time revenue
- If 30% repeat: $7,295 additional revenue
- If 50% repeat: $12,159 additional revenue

**Cost Analysis:**
- Customer acquisition cost (estimated): $50/customer
- Bronze tier wasted acquisition: 21 × $50 = $1,050
- ROI on retention campaign: High (existing relationships)

**Break-Even:**
Recovering just 6 churned customers ($6K × 25% = $1.5K) covers campaign costs

---

## Dashboard Effectiveness

**What This Dashboard Does Well:**
✅ Immediately shows one-time buyer problem
✅ Churn risk matrix makes inactive customers visible
✅ LTV scatter reveals Platinum outliers
✅ Tier donut quantifies the imbalance

**What Could Be Enhanced:**
- Add cohort analysis (by acquisition month)
- Show customer lifetime over time (not just snapshot)
- Include customer acquisition cost if available
- Add projected LTV based on tier

---

## For Technical Interviews

**How to discuss this dashboard:**

1. **Start with the insight:** "62% one-time buyers immediately indicated a retention problem"
2. **Show the methodology:** "I calculated LTV using running totals over customer history in SQL"
3. **Explain the visualization:** "Churn matrix color-codes risk - red means immediate action needed"
4. **Connect to action:** "This led to three specific recommendations: loyalty program, win-back campaign, tier upgrade incentives"

**Technical depth:**
- Explain tier classification logic (CASE statement thresholds)
- Discuss churn detection approach (recency scoring)
- Describe scatter plot design (time + value + tier color)
- Reference SQL problems A32, B26, I3

---

## Combined Story (Both Dashboards)

**Revenue Dashboard showed:** 88.72% drop, customer concentration
**Customer Dashboard explains:** Why - no retention, only 2 Platinum customers, 62% one-timers

**The complete diagnosis:**
1. Revenue is volatile because customer base isn't sticky
2. Revenue is concentrated because only 2 high-value customers exist
3. Fixing retention is THE priority - revenue can't grow sustainably otherwise

---

## Related Documentation

- **SQL Queries:** [`01-SQL-Queries/aggregation-queries.sql`](../../01-SQL-Queries/aggregation-queries.sql)
- **Technical Specs:** [`02-Tableau-Workbooks/dashboard-specs.md`](../../02-Tableau-Workbooks/dashboard-specs.md)
- **Revenue Analysis:** [`01-Revenue-Overview/insights.md`](../01-Revenue-Overview/insights.md)
```