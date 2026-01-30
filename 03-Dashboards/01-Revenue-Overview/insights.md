# Revenue Overview Dashboard - Key Insights

## Executive Summary

Analysis of $39,385 in revenue across 37 orders reveals critical volatility and concentration risks requiring immediate operational attention.

**Dashboard Link:** [View Interactive Dashboard](https://public.tableau.com/app/profile/lenny.success.humphrey/viz/SQLPortfolioAnalyticsE-CommerceBusinessInsights/CustomerAnalyticsAndSegmentation)

---

## Critical Findings

### 🚨 Finding 1: Revenue Volatility

**Observation:**
88.72% month-over-month revenue decline from January to February 2025
- January 2025: $8,780 (13 orders)
- February 2025: $933 (2 orders)
- Drop: $7,847 (-88.72%)

**Business Implications:**
- Suggests seasonal pattern or one-time bulk order in January
- Revenue base is highly unstable
- Cannot reliably forecast future performance
- Operational capacity planning is challenged by volatility

**Recommended Actions:**
1. Investigate January orders: Were they from single customer or campaign?
2. Analyze seasonality: Review historical patterns if available
3. Diversify revenue streams to reduce volatility
4. Establish minimum monthly revenue targets
5. Create early warning system for order volume drops

**SQL Problem Applied:** I11 (Month-over-month growth with LAG window function)

---

### ⚠️ Finding 2: Customer Concentration Risk

**Observation:**
Top 3 customers represent 48% of total revenue
- Hank: $9,350 (24%)
- Amy: $8,740 (22%)
- Rita: $4,200 (11%)
- Combined: $22,290 (57% from top 3)

**Business Implications:**
- Single customer loss could devastate revenue
- No redundancy in customer base
- Pricing power is limited (dependent on few accounts)
- Business valuation would reflect this concentration risk

**Recommended Actions:**
1. Implement VIP customer retention program for top 3
2. Set target: No single customer > 15% of revenue
3. Accelerate new customer acquisition to dilute concentration
4. Develop early warning indicators for top customer health
5. Consider customer success team to protect key accounts

**SQL Problem Applied:** B33 (Top customers by spending, aggregation + ranking)

---

### 📊 Finding 3: Category Imbalance

**Observation:**
Computers category dominates revenue
- Computers: $5,400 (58% of category revenue)
- All other categories: $3,885 (42%)
- Next highest: Mobiles at $1,000 (11%)

**Business Implications:**
- Category risk similar to customer concentration
- Limited product diversification
- Inventory and supplier relationships may be imbalanced
- Marketing and merchandising likely under-optimized for other categories

**Recommended Actions:**
1. Analyze why Computers performs better (pricing, quality, marketing?)
2. Apply winning strategies to underperforming categories
3. Review inventory allocation across categories
4. Test marketing campaigns for Mobiles, Accessories, Office categories
5. Consider phasing out consistently poor performers (Gaming, Clothing)

**SQL Problem Applied:** A6 (Category revenue CROSSTAB pivot)

---

### 💰 Finding 4: High Average Order Value

**Observation:**
Average order value of $1,158 significantly above typical B2C e-commerce
- 10 orders > $1,000
- 5 orders > $2,000
- Largest order: $8,200 (Laptop order)

**Business Implications:**
- Suggests B2B or premium consumer positioning
- Customer acquisition cost tolerance is higher
- Payment terms and credit may be important factors
- Sales cycle likely longer than typical e-commerce

**Recommended Actions:**
1. Clarify target market positioning (B2B vs premium B2C)
2. Optimize checkout for high-value orders (payment plans, quotes)
3. Adjust marketing spend based on higher LTV
4. Consider account management for enterprise customers
5. Implement fraud detection for high-value transactions

**SQL Problem Applied:** B10 (Average aggregation)

---

## Secondary Observations

### Customer Acquisition Trend

**Pattern:** Steady growth from January to December 2025
- Started: ~5 customers
- Current: 34 customers
- Growth: Relatively linear (no viral spikes)

**Implication:** Organic growth pattern, consistent acquisition but not explosive

---

### Order Status Distribution

**Breakdown:**
- Paid: 34 orders (92%)
- Pending: 2 orders (5%)
- Cancelled: 1 order (3%)

**Implication:** Healthy conversion rate, minimal cancellations

---

## Connections to Customer Analytics Dashboard

Revenue analysis raises questions answered by customer behavior data:

**Question 1:** Why did February revenue drop?
**Answer:** Dashboard 2 shows customer purchase frequency - may indicate seasonal buying patterns

**Question 2:** Are top customers at risk?
**Answer:** Dashboard 2 churn matrix shows Hank is active (recent orders). Amy should benefit from VIP retention campaigns to change churn risk status.

**Question 3:** How do we reduce concentration?
**Answer:** Dashboard 2 reveals 62% Bronze tier (one-time buyers) - retention opportunity

---

## Metrics Summary

| Metric | Value | Benchmark | Status |
|--------|-------|-----------|--------|
| Total Revenue | $39,385 | $50,000 target | ⚠️ Below |
| Average Order Value | $1,158 | $800 expected | ✅ Above |
| Customer Concentration (Top 3) | 48% | <30% ideal | 🚨 High Risk |
| MoM Volatility | 88.72% drop | <20% acceptable | 🚨 Critical |
| Category Concentration | 58% Computers | <40% ideal | ⚠️ Moderate Risk |

---

## Dashboard Effectiveness

**What This Dashboard Does Well:**
✅ Immediately surfaces the February revenue crisis
✅ Shows customer concentration risk at a glance
✅ Provides trend context (not just point-in-time)
✅ Includes actionable customer ranking

**What Could Be Enhanced:**
- Add year-over-year comparison if historical data available
- Include profit margin by category (if cost data exists)
- Show order volume trend separately from revenue
- Add predicted revenue based on current trajectory

---

## For Technical Interviews

**How to discuss this dashboard:**

1. **Start with the problem:** "88.72% revenue drop in February immediately caught my attention"
2. **Show the analysis:** "I used LAG window functions to calculate month-over-month growth"
3. **Connect to business:** "This volatility suggests either seasonal pattern or customer concentration"
4. **Demonstrate next steps:** "Which led me to build the customer analytics dashboard to investigate"

**Technical depth:**
- Explain pre-aggregation strategy (SQL → CSV → Tableau)
- Discuss why area chart vs line chart (shows magnitude better)
- Describe annotation approach (manual vs calculated)
- Reference SQL problem I11 specifically

---

## Related Documentation

- **SQL Queries:** [`01-SQL-Queries/aggregation-queries.sql`](../../01-SQL-Queries/aggregation-queries.sql)
- **Technical Specs:** [`02-Tableau-Workbooks/dashboard-specs.md`](../../02-Tableau-Workbooks/dashboard-specs.md)
- **Customer Analysis:** [`02-Customer-Analytics/insights.md`](../02-Customer-Analytics/insights.md)