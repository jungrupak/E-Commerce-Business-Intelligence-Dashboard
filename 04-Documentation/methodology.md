# Methodology

Analysis framework and approach for the e-commerce analytics project.

---

## Project Objective

**Primary Goal:** Translate SQL database proficiency into business intelligence deliverables that demonstrate insight generation capability.

**Secondary Goals:**
- Showcase end-to-end analytics workflow (database → SQL → visualization)
- Demonstrate business understanding (not just technical skills)
- Creating a portfolio piece that differentiates from tutorial projects

---

## Analysis Framework

### Phase 1: Problem Definition

**Business Questions Identified:**

**Revenue Analysis:**
- How is the business performing financially?
- Where is revenue coming from?
- What patterns indicate risk or opportunity?

**Customer Behavior:**
- Who are our customers?
- What drives customer value?
- Which customers are at risk of leaving?

**Rationale:** These questions align with real-world analytics priorities - understanding revenue health and customer dynamics.

---

### Phase 2: Data Assessment

**Source Database:** PostgreSQL (from SQL-Portfolio-105-Problems)

**Data Quality Checks:**
1. **Completeness:** Verified all 15 tables populated
2. **Accuracy:** Validated foreign key relationships
3. **Consistency:** Checked for duplicate records
4. **Timeliness:** Confirmed date ranges (Jan 2024 - Oct 2025)

**Data Characteristics:**
- Total records: 300+ across 15 tables
- Time span: 22 months
- Customers: 35 (sufficient for segmentation)
- Orders: 37 (limited but adequate for analysis)
- Data quality: High (designed dataset, minimal nulls)

**Limitations Acknowledged:**
- Synthetic data (not real business transactions)
- Limited historical depth (< 2 years)
- Small sample size (35 customers)
- No external data (market trends, competitors)

---

### Phase 3: SQL Analysis

**SQL Problems Applied:**

**Aggregations (Basics):**
- B9: Total revenue calculation
- B10: Average order value
- B12: Customer distribution by country
- B13: Product units sold

**Window Functions (Intermediate):**
- I11: Month-over-month growth with LAG()
- I7: Previous order comparison with LAG()
- I4: Latest order per customer

**Advanced Techniques (Advanced):**
- A32: Customer LTV function creation
- A6: Category revenue pivot (CROSSTAB)
- A17: Revenue percentile ranking

**Query Development Process:**
1. Start with simple aggregations (totals, averages)
2. Add time-series analysis (monthly trends)
3. Implement customer-level calculations (LTV, recency)
4. Create pre-aggregated views for Tableau

**Performance Considerations:**
- Pre-aggregation in SQL vs. live calculations in Tableau
- Index strategy for date and foreign key columns
- CSV export vs. live database connection

---

### Phase 4: Data Transformation

**Export Strategy:**

**Raw Tables:**
- Direct `\copy` exports from PostgreSQL
- Minimal transformation (preserve original structure)
- Use case: Reference data, custom analysis

**Processed Views:**
- Pre-aggregated at appropriate grain
- Customer-level: All metrics per customer (LTV, orders, recency)
- Time-series: Monthly aggregations for trend analysis
- Product-level: Performance metrics per product

**Transformation Logic:**
```sql
-- Example: Customer LTV
SELECT 
    customer_id,
    SUM(total_amount) AS lifetime_value,
    COUNT(order_id) AS total_orders,
    MAX(order_date) AS last_order_date,
    EXTRACT(DAY FROM NOW() - MAX(order_date)) AS days_since_last_order
FROM orders
GROUP BY customer_id
```

**Rationale:** Pre-aggregation improves Tableau performance and simplifies dashboard maintenance.

---

### Phase 5: Visualization Design

**Dashboard Design Principles:**

**1. Clarity First**
- One clear message per dashboard
- Minimal cognitive load
- Progressive disclosure (overview → details)

**2. Business Focus**
- Lead with insights, not data
- Annotations explain "so what"
- Actionable findings prominent

**3. Visual Hierarchy**
- KPIs at top (immediate context)
- Main insight center-stage (monthly trend, LTV scatter)
- Supporting details below

**Dashboard 1 Layout:**
```
[KPIs: 4 cards across]
[Monthly Trend: Full width, prominent]
[Category + Customers: Side-by-side]
[Acquisition: Full width]
```

**Dashboard 2 Layout:**
```
[LTV Scatter: 65% width] [Tier Donut: 35%]
[Churn Matrix: Full width]
[Top Customers: Full width]
```

**Color Strategy:**
- Consistent palette across dashboards
- Semantic colors (red = risk, green = safe)
- Tier colors memorable (purple = Platinum)

---

### Phase 6: Insight Generation

**Analysis Process:**

**Step 1: Observe Patterns**
- Revenue volatility immediately visible
- Customer concentration apparent
- Tier imbalance clear

**Step 2: Quantify Impact**
- 88.72% revenue drop (specific metric)
- 48% from top 3 customers (concentration)
- 62% one-time buyers (retention issue)

**Step 3: Business Translation**
- What does this mean for the business?
- What action should be taken?
- What's the potential impact?

**Step 4: Validate Insights**
- Cross-reference between dashboards
- Check SQL calculations
- Verify edge cases (nulls, zeros)

**Insight Quality Criteria:**
- ✅ Specific (quantified with metrics)
- ✅ Surprising (non-obvious finding)
- ✅ Actionable (clear next steps)
- ✅ Credible (data-backed)

---

### Phase 7: Documentation

**Documentation Strategy:**

**For Technical Audience:**
- SQL queries with comments
- Tableau calculated fields explained
- Performance optimization notes

**For Business Audience:**
- Insights in plain language
- Business implications clear
- Recommendations actionable

**For Portfolio:**
- Process documented (this methodology)
- Reproducible (step-by-step workflow)
- Professional (comprehensive README)

---

## Analytical Techniques Applied

### Descriptive Analytics
**What happened?**
- Revenue trends over time
- Customer distribution by tier
- Order status breakdown

**Tools:** Aggregations, GROUP BY, time-series analysis

---

### Diagnostic Analytics
**Why did it happen?**
- Why did February revenue drop? (MoM analysis)
- Why are customers churning? (Recency analysis)
- Why is revenue concentrated? (Customer segmentation)

**Tools:** LAG window functions, CASE statements, comparative analysis

---

### Predictive Analytics (Limited)
**What might happen?**
- Churn risk scoring (180+ days inactive)
- Customer tier trajectory (Bronze → Silver potential)

**Tools:** Recency scoring, behavioral patterns

**Note:** Not true predictive modeling (no ML), but risk indicators

---

## Quality Assurance

**Validation Checks:**

**Data Integrity:**
- [x] Foreign key relationships intact
- [x] No duplicate primary keys
- [x] Date ranges logical
- [x] Nulls appropriately handled

**Calculation Accuracy:**
- [x] Revenue totals match across sources
- [x] Customer counts consistent
- [x] MoM growth calculated correctly
- [x] LTV sums validated against order totals

**Visualization Accuracy:**
- [x] Chart axes labeled correctly
- [x] Colors semantically appropriate
- [x] Tooltips display correct data
- [x] Filters work as expected

**Business Logic:**
- [x] Customer tiers calculated correctly
- [x] Churn risk thresholds reasonable
- [x] Insights supported by data
- [x] Recommendations actionable

---

## Limitations & Assumptions

### Data Limitations
- Synthetic data (not real business)
- Small sample (35 customers)
- Limited time span (22 months)
- No cost data (can't calculate profitability)

### Analytical Limitations
- No statistical significance testing
- No predictive modeling (ML)
- No A/B testing or causal inference
- No customer acquisition cost data

### Assumptions Made
- Customer tier thresholds ($5K, $1K, $500) are industry-reasonable
- 90/180 day churn windows are appropriate
- One-time buyers indicate retention problem (vs. intentional purchase)
- Revenue volatility is problematic (vs. expected seasonality)

---

## Alternative Approaches Considered

### Approach 1: Live Database Connection
**Rejected:** Tableau Public doesn't support live PostgreSQL connections

**Alternative:** CSV exports with pre-aggregation

---

### Approach 2: Python Data Prep
**Rejected:** Adds unnecessary complexity for this dataset size

**Alternative:** SQL aggregations sufficient and more transparent

---

### Approach 3: Single Dashboard
**Rejected:** Too cluttered, confusing narrative

**Alternative:** Two focused dashboards (revenue + customer)

---

## Lessons Learned

**What Worked Well:**
- Pre-aggregation strategy (fast dashboards)
- Two-dashboard structure (clear narrative)
- Insight annotations on charts (context)
- Connection to SQL portfolio (builds credibility)

**What Could Be Improved:**
- Add year-over-year comparison (if more data)
- Include profitability analysis (if cost data)
- Build predictive churn model (if larger dataset)
- Add cohort analysis (by acquisition month)

**Process Improvements:**
- Document dashboard iterations (show evolution)
- Track time spent per phase (for future projects)
- Gather feedback earlier (from peers)

---

## Reproducibility

**To Reproduce This Analysis:**

1. Clone [SQL-Portfolio-105-Problems](https://github.com/LennySHumphrey/SQL-Portfolio-105-Problems)
2. Load database schema
3. Run export queries from `01-SQL-Queries/`
4. Connect Tableau to CSVs from `00-Data-Sources/processed/`
5. Follow specifications in `02-Tableau-Workbooks/dashboard-specs.md`

**Estimated Time:** 4-6 hours (experienced analyst)

---

## For Interviewers

**Discussion Points:**

**Process Questions:**
- "Walk me through your analytical process"
  → Reference this methodology document

**Technical Questions:**
- "Why pre-aggregate in SQL vs. calculate in Tableau?"
  → Performance, transparency, reusability

**Business Questions:**
- "What would you recommend to this business?"
  → Fix retention (62% one-time buyers), protect top 2 customers

**Trade-off Questions:**
- "What are the limitations of your analysis?"
  → Synthetic data, no cost data, small sample, no ML

---

## Related Documentation

- **Technical Implementation:** [`technical-implementation.md`](technical-implementation.md)
- **Business Context:** [`business-context.md`](business-context.md)
- **Workflow:** [`sql-to-tableau-workflow.md`](sql-to-tableau-workflow.md)