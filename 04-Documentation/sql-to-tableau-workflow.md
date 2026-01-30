# SQL to Tableau Workflow

Step-by-step process for building the e-commerce analytics dashboards from scratch.

---

## Overview

**Total Time:** 6-8 hours (experienced analyst)

**Prerequisites:**
- **Database:** PostgreSQL installed (or access via VS Code PostgreSQL extension)
- **IDE/Editor:** VS Code with PostgreSQL extension (recommended) OR PostgreSQL command line (psql)
- **Visualization:** Tableau Public installed
- **Source Data:** SQL-Portfolio-105-Problems database loaded

---

## Phase 1: Database Setup (30 minutes)

### Step 1: Load Database Schema

**Option A: Using PostgreSQL Command Line (psql)**

```bash
# Clone SQL portfolio repository
git clone https://github.com/LennySHumphrey/SQL-Portfolio-105-Problems.git
cd SQL-Portfolio-105-Problems

# Create database
psql -U postgres
CREATE DATABASE ecommerce_practice;
\c ecommerce_practice

# Load schema
\i 00-Database-Schema/schema.sql
```

**Option B: Using VS Code (Recommended)**

1. **Install VS Code Extensions:**
   - Install "PostgreSQL" extension by Chris Kolkman
   - Or "SQLTools" + "SQLTools PostgreSQL Cockroach Driver"

2. **Clone Repository:**
   ```bash
   git clone https://github.com/LennySHumphrey/SQL-Portfolio-105-Problems.git
   cd SQL-Portfolio-105-Problems
   ```

3. **Connect to PostgreSQL:**
   - Open VS Code
   - Click PostgreSQL extension icon in sidebar
   - Click "+" to add connection:
     - Host: localhost
     - Port: 5432
     - Database: postgres (initially)
     - Username: postgres
     - Password: your_password
     - Save connection

4. **Create Database:**
   - Right-click connection → "New Query"
   - Run: `CREATE DATABASE ecommerce_practice;`
   - Refresh connections
   - Connect to ecommerce_practice database

5. **Load Schema:**
   - Open `00-Database-Schema/schema.sql` in VS Code
   - Select all (Ctrl/Cmd + A)
   - Right-click → "Run Query" (or F5)
   - Wait for completion

**Verify:**
```sql
-- Check table count
SELECT COUNT(*) FROM information_schema.tables 
WHERE table_schema = 'public';
-- Expected: 12 tables

-- Check data loaded
SELECT COUNT(*) FROM customers;  -- Expected: 35
SELECT COUNT(*) FROM orders;     -- Expected: 37
```

---

## Phase 2: Data Export (1 hour)

### Step 2: Export Raw Tables

**Create export directory:**
```bash
mkdir -p tableau-project/00-Data-Sources/raw
cd tableau-project
```

**Option A: Using PostgreSQL Command Line (psql)**

Run export queries:
```bash
psql -U postgres -d ecommerce_practice
\i export-queries.sql
```

**Export commands:**
```sql
\copy (SELECT * FROM customers) TO '00-Data-Sources/raw/customers.csv' CSV HEADER;
\copy (SELECT * FROM orders) TO '00-Data-Sources/raw/orders.csv' CSV HEADER;
\copy (SELECT * FROM order_items) TO '00-Data-Sources/raw/order_items.csv' CSV HEADER;
\copy (SELECT * FROM products) TO '00-Data-Sources/raw/products.csv' CSV HEADER;
\copy (SELECT * FROM categories) TO '00-Data-Sources/raw/categories.csv' CSV HEADER;
\copy (SELECT * FROM payments) TO '00-Data-Sources/raw/payments.csv' CSV HEADER;
```

**Option B: Using VS Code**

1. **Open export-queries.sql in VS Code**

2. **Modify for VS Code (COPY instead of \copy):**
   - VS Code PostgreSQL extension uses `COPY` command
   - Requires absolute paths

3. **Update queries to use COPY:**
   ```sql
   -- Replace \copy with COPY and use absolute paths
   COPY (SELECT * FROM customers) TO '/absolute/path/to/tableau-project/00-Data-Sources/raw/customers.csv' WITH CSV HEADER;
   COPY (SELECT * FROM orders) TO '/absolute/path/to/tableau-project/00-Data-Sources/raw/orders.csv' WITH CSV HEADER;
   COPY (SELECT * FROM order_items) TO '/absolute/path/to/tableau-project/00-Data-Sources/raw/order_items.csv' WITH CSV HEADER;
   COPY (SELECT * FROM products) TO '/absolute/path/to/tableau-project/00-Data-Sources/raw/products.csv' WITH CSV HEADER;
   COPY (SELECT * FROM categories) TO '/absolute/path/to/tableau-project/00-Data-Sources/raw/categories.csv' WITH CSV HEADER;
   COPY (SELECT * FROM payments) TO '/absolute/path/to/tableau-project/00-Data-Sources/raw/payments.csv' WITH CSV HEADER;
   ```

4. **Run queries:**
   - Select each query
   - Right-click → "Run Query" (or F5)
   - Check for success messages

**Option C: Manual Export via Query Results (Simplest in VS Code)**

For each table:
1. Open new query in VS Code
2. Run: `SELECT * FROM customers;`
3. Right-click result table → "Export Results"
4. Choose CSV format
5. Save to `00-Data-Sources/raw/customers.csv`
6. Repeat for all 6 tables

**Verify exports:**
```bash
ls -lh 00-Data-Sources/raw/*.csv
# Should see 6 CSV files
```

---

### Step 3: Create Aggregated Views

**Create processed directory:**
```bash
mkdir -p 00-Data-Sources/processed
```

**Option A: Using PostgreSQL Command Line**

Run aggregation queries:
```sql
\i aggregation-queries.sql
```

**Option B: Using VS Code**

1. **Open `aggregation-queries.sql` in VS Code**

2. **Update \copy commands to COPY with absolute paths** (same as Step 2)

3. **Or use manual export method:**
   - Run each aggregation query
   - Export results as CSV
   - Save to `00-Data-Sources/processed/`

**Key aggregations:**

**Customer LTV:**
```sql
\copy (
    SELECT 
        c.customer_id,
        c.customer_name,
        c.country,
        c.created_at,
        COUNT(o.order_id) AS total_orders,
        COALESCE(SUM(o.total_amount), 0) AS lifetime_value,
        MAX(o.order_date) AS last_order_date,
        MIN(o.order_date) AS first_order_date,
        EXTRACT(DAY FROM (NOW() - MAX(o.order_date))) AS days_since_last_order
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    WHERE o.status != 'cancelled' OR o.status IS NULL
    GROUP BY c.customer_id, c.customer_name, c.country, c.created_at
) TO '00-Data-Sources/processed/customer_ltv.csv' CSV HEADER;
```

**Verify aggregations:**
```bash
wc -l 00-Data-Sources/processed/*.csv
# customer_ltv.csv: 36 lines (35 customers + header)
# monthly_revenue.csv: 11 lines (10 months + header)
# product_performance.csv: 21 lines (20 products + header)
```

---

## Phase 3: Tableau Setup (30 minutes)

### Step 4: Create New Tableau Workbook

1. Open Tableau Public
2. Connect → Text file
3. Navigate to `00-Data-Sources/processed/`
4. Select `monthly_revenue.csv`
5. Click "Open"

---

### Step 5: Add Data Sources

**Add customer_ltv.csv:**
1. Data → New Data Source
2. Text file → `customer_ltv.csv`

**Add product_performance.csv:**
1. Data → New Data Source
2. Text file → `product_performance.csv`

**Convert to Extracts:**
1. For each data source, right-click
2. Select "Extract Data"
3. Click "Extract"

**You should now have 3 data sources.**

---

### Step 6: Create Calculated Fields

**In customer_ltv data source:**

**Customer Tier:**
```tableau
IF [Lifetime Value] >= 5000 THEN "Platinum"
ELSEIF [Lifetime Value] >= 1000 THEN "Gold"
ELSEIF [Lifetime Value] >= 500 THEN "Silver"
ELSE "Bronze"
END
```

**Churn Risk Status:**
```tableau
IF [Days Since Last Order] > 180 THEN "High Risk"
ELSEIF [Days Since Last Order] > 90 THEN "At Risk"
ELSEIF ISNULL([Days Since Last Order]) THEN "Never Ordered"
ELSE "Active"
END
```

**Order Frequency Bucket:**
```tableau
IF [Total Orders] = 0 THEN "0 orders"
ELSEIF [Total Orders] = 1 THEN "1 order"
ELSEIF [Total Orders] <= 3 THEN "2-3 orders"
ELSE "4+ orders"
END
```

**Create Bins:**
1. Right-click `Days Since Last Order`
2. Create → Bins
3. Size of bins: 30
4. Click OK

---

## Phase 4: Build Dashboard 1 - Revenue Overview (2 hours)

### Step 7: Create KPI Sheets

**Sheet 1: KPI - Total Revenue**
1. New Worksheet → Rename "KPI - Total Revenue"
2. Data source: `monthly_revenue`
3. Drag `Revenue` to canvas
4. Change to SUM
5. Format:
   - Number: Currency, 0 decimals
   - Font: 9pt, bold, white
   - Background: Blue (#2E5F8A)
6. Hide axes and gridlines

**Repeat for:**
- KPI - Orders Processed (SUM of Total Orders)
- KPI - Average Monthly Revenue (AVG of Avg Order Value)
- KPI - Total Customers (SUM of Unique Customers)

---

### Step 8: Create Monthly Revenue Trend

1. New Worksheet → "Monthly Revenue Trend"
2. Data source: `monthly_revenue`
3. Drag `Month` to Columns
4. Drag `Revenue` to Rows
5. Change mark type to Area
6. Color: Blue gradient, 60% opacity
7. Add reference line: Average, dashed

**Add annotation for February:**
1. Right-click February data point
2. Annotate → Point
3. Text: "Feb: $933 ▼ 88.72% From Jan"

---

### Step 9: Create Category Breakdown

1. New Worksheet → "Revenue by Category"
2. Data source: `product_performance`
3. Drag `Category Name` to Rows
4. Drag `Total Revenue` to Columns
5. Sort: Descending
6. Add labels (currency format)

---

### Step 10: Create Top 10 Customers

1. New Worksheet → "Top 10 Customers"
2. Data source: `customer_ltv`
3. Drag `Customer Name` to Rows
4. Drag `Lifetime Value` to Columns
5. Filter: Top 10 by Lifetime Value
6. Sort: Descending
7. Add labels

---

### Step 11: Create Customer Acquisition Trend

1. New Worksheet → "Customer Acquisition"
2. Data source: `customer_ltv`
3. Drag `Created At` to Columns (change to Month)
4. Drag `Customer ID` to Rows (change to COUNTD)
5. Add table calculation: Running Total
6. Change to Area chart
7. Color: Teal gradient

---

### Step 12: Assemble Dashboard 1

1. New Dashboard → "1 - Revenue Overview"
2. Size: Automatic
3. Drag sheets in this order:
   - Row 1: 4 KPI cards (horizontal)
   - Row 2: Monthly Revenue Trend (full width)
   - Row 3: Revenue by Category (left 50%) + Top 10 Customers (right 50%)
   - Row 4: Customer Acquisition (full width)
4. Add title text box at top
5. Adjust spacing and alignment

---

## Phase 5: Build Dashboard 2 - Customer Analytics (2 hours)

### Step 13: Create LTV Scatter Plot

1. New Worksheet → "Customer LTV Scatter"
2. Data source: `customer_ltv`
3. Drag `Created At` to Columns (exact date)
4. Drag `Lifetime Value` to Rows
5. Change mark type to Circle
6. Drag `Customer Tier` to Color
7. Drag `Total Orders` to Size
8. Add reference line: Average LTV
9. Add labels for top 5 customers

---

### Step 14: Create Customer Tier Donut

1. New Worksheet → "Customer Tiers"
2. Data source: `customer_ltv`
3. Drag `Customer Tier` to Color
4. Drag `Customer ID` (COUNTD) to Angle
5. Change to Pie chart
6. Duplicate to Rows for donut effect
7. Make second circle white and smaller

---

### Step 15: Create Churn Risk Matrix

1. New Worksheet → "Churn Risk Matrix"
2. Data source: `customer_ltv`
3. Drag `Order Frequency Bucket` to Columns
4. Drag `Days Since Last Order (bins)` to Rows
5. Drag `Customer ID` (COUNTD) to Color
6. Drag `Customer ID` (COUNTD) to Label
7. Change mark type to Square
8. Color scale: White → Orange → Red
9. Sort rows descending (330+ at top)

---

### Step 16: Create Top Customers Table

1. New Worksheet → "Top Customers Table"
2. Data source: `customer_ltv`
3. Drag these to Rows:
   - Customer Name
   - Lifetime Value
   - Total Orders
   - Days Since Last Order
4. Filter: Top 15 by Lifetime Value
5. Format columns (currency, numbers)
6. Add conditional formatting on Days Since Last Order

---

### Step 17: Assemble Dashboard 2

1. New Dashboard → "2 - Customer Analytics"
2. Size: Automatic
3. Drag sheets in this order:
   - Row 1: LTV Scatter (left 50%) + Customer Tiers (right 50%)
   - Row 2: Churn Risk Matrix (full width)
   - Row 3: Top Customers Table (full width)
4. Add title text box
5. Add filters: Customer Tier, Churn Risk Status

---

## Phase 6: Polish & Publish (1 hour)

### Step 18: Format Dashboards

**Consistent Formatting:**
- Font: Tableau Book
- Title size: 16pt, bold
- Background: White
- Padding: 10px

**Color Palette:**
- Primary: #2E5F8A (blue)
- Secondary: #2E8B91 (teal)
- Platinum: #8E44AD (purple)
- Gold: #E67E22 (orange)
- Silver: #5DADE2 (light blue)
- Bronze: #95A5A6 (gray)

---

### Step 19: Add Dashboard Actions

**Highlight Action (Optional):**
1. Dashboard → Actions
2. Add Action → Highlight
3. Source: Customer Tier donut
4. Target: All sheets
5. Run on: Hover

---

### Step 20: Publish to Tableau Public

1. File → Save to Tableau Public As
2. Sign in to account
3. Workbook name: "E-Commerce Business Analytics: Revenue Performance & Customer Segmentation"
4. Add description (from documentation)
5. Click Save

**Get link:**
- Copy workbook URL
- Share on LinkedIn, GitHub

---

## Phase 7: Documentation (1 hour)

### Step 21: Take Screenshots

**For Dashboard 1:**
- Full dashboard (1350x850)
- Monthly trend close-up
- Category breakdown close-up

**For Dashboard 2:**
- Full dashboard
- LTV scatter close-up
- Churn matrix close-up

**Save as PNG** in `03-Dashboards/` folders

---

### Step 22: Create GitHub Repository

**Repository Structure:**
```
tableau-portfolio-ecommerce/
├── 00-Data-Sources/
│   ├── raw/                     # Original CSV exports
│   ├── processed/               # Pre-aggregated views
│   ├── data-dictionary.md
│   └── README.md
├── 01-SQL-Queries/
│   ├── export-queries.sql
│   ├── aggregation-queries.sql
│   ├── calculated-metrics.sql
│   └── README.md
├── 02-Tableau-Workbooks/
│   ├── dashboard-specs.md
│   ├── tableau-calculations.md
│   └── README.md
├── 03-Dashboards/
│   ├── 01-Revenue-Overview/
│   │   ├── dashboard-full.png
│   │   ├── monthly-trend.png
│   │   ├── category-breakdown.png
│   │   ├── insights.md
│   │   └── README.md
│   ├── 02-Customer-Analytics/
│   │   ├── dashboard-full.png
│   │   ├── ltv-distribution.png
│   │   ├── churn-matrix.png
│   │   ├── insights.md
│   │   └── README.md
│   └── README.md
├── 04-Documentation/
│   ├── methodology.md
│   ├── business-context.md
│   ├── technical-implementation.md
│   ├── sql-to-tableau-workflow.md
│   └── README.md
├── .gitignore
├── LICENSE
├── README.md
└── QUICKSTART.md
```

**Initialize Repository:**
```bash
cd tableau-portfolio-ecommerce
git init
git add .
git commit -m "Initial commit: E-commerce analytics dashboards"
```

**Create GitHub repo:**
1. Go to github.com
2. New Repository
3. Name: `tableau-portfolio-ecommerce`
4. Description: "End-to-end analytics: SQL to Tableau dashboards showcasing revenue analysis and customer segmentation"
5. Public
6. Don't initialize with README (you already have one)
7. Create repository

**Push to GitHub:**
```bash
git remote add origin https://github.com/YOUR_USERNAME/tableau-portfolio-ecommerce.git
git branch -M main
git push -u origin main
```

---

### Step 23: Write Documentation

**Create insights documentation:**
1. Review dashboards thoroughly
2. Identify 3-5 key insights per dashboard
3. Document in `insights.md` files
4. Include business implications and recommendations

**Write methodology:**
1. Document analysis approach
2. Explain SQL-to-Tableau workflow
3. Describe business context
4. Add technical implementation notes

**Files to complete:**
- `03-Dashboards/01-Revenue-Overview/insights.md`
- `03-Dashboards/02-Customer-Analytics/insights.md`
- `04-Documentation/methodology.md`
- `04-Documentation/business-context.md`
- `04-Documentation/technical-implementation.md`

---

## Phase 8: Quality Assurance (30 minutes)

### Step 24: Validate Data Accuracy

**Check SQL calculations:**
```sql
-- Verify revenue total
SELECT SUM(total_amount) FROM orders WHERE status = 'paid';
-- Should match Tableau KPI: $39,385

-- Verify customer count
SELECT COUNT(DISTINCT customer_id) FROM orders WHERE status = 'paid';
-- Should match Tableau KPI: 34

-- Verify top customer LTV
SELECT customer_name, SUM(total_amount) as ltv
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE status = 'paid'
GROUP BY customer_name
ORDER BY ltv DESC
LIMIT 1;
-- Should match Hank: $9,350
```

---

### Step 25: Test Dashboard Functionality

**Dashboard 1 Tests:**
- [ ] All KPI cards display correctly
- [ ] Monthly trend shows February annotation
- [ ] Category bars are sorted descending
- [ ] Top 10 customers filter works
- [ ] Acquisition trend shows cumulative growth

**Dashboard 2 Tests:**
- [ ] LTV scatter colors by tier correctly
- [ ] Donut chart shows correct percentages
- [ ] Churn matrix color scale appropriate
- [ ] Top customers table sorted by LTV
- [ ] Filters affect all sheets

**Interaction Tests:**
- [ ] Highlight action works on hover
- [ ] Filters update dashboard dynamically
- [ ] Tooltips show correct data
- [ ] All navigation works

---

### Step 26: Review Documentation

**Checklist:**
- [ ] All SQL queries have comments
- [ ] Data dictionary complete
- [ ] Dashboard specs are detailed
- [ ] Insights are actionable
- [ ] README is comprehensive
- [ ] No broken links in markdown
- [ ] All images load correctly

---

## Phase 9: Presentation Prep (30 minutes)

### Step 27: Create LinkedIn Post (Optional)

**Example Post Template (Optional):**
```
📊 New Project: E-Commerce Analytics Dashboard

Just completed an end-to-end analytics project showcasing:
✅ SQL data extraction & transformation (PostgreSQL)
✅ Business insight generation
✅ Interactive Tableau dashboards

Key findings:
• 88.72% revenue volatility identified → requires immediate action
• 62% one-time buyers → retention opportunity
• Customer concentration risk quantified

Project demonstrates:
• Advanced SQL (window functions, aggregations, CTEs)
• Data visualization best practices
• Business acumen & actionable recommendations

🔗 Live Dashboard: [Tableau Public Link]
💻 GitHub: [Repository Link]

#DataAnalytics #SQL #Tableau #BusinessIntelligence #DataVisualization

[Include dashboard screenshot]
```

---

### Step 28: Update Portfolio (Optional)

**Add to portfolio site:**
- Project title and description
- Dashboard screenshots
- Links to Tableau Public and GitHub
- Brief summary of insights
- Technologies used

**GitHub Profile README:**
- Add project to featured repositories
- Include thumbnail image
- Link to live dashboards

---

## Troubleshooting

### Issue: CSV Export Fails

**Error:** `Permission denied` or `could not open file`

**Solution:**
```bash
# Check directory permissions
ls -la 00-Data-Sources/raw/

# Create directory with correct permissions
mkdir -p 00-Data-Sources/raw
chmod 755 00-Data-Sources/raw

# Use absolute path in \copy command
\copy (...) TO '/full/path/to/00-Data-Sources/raw/customers.csv' CSV HEADER;
```

---

### Issue: Tableau Can't Connect to CSV

**Error:** `Unable to connect to the file`

**Solution:**
1. Verify file exists and is not empty
2. Check CSV format (UTF-8 encoding)
3. Ensure no special characters in filename
4. Try importing a different CSV first

---

### Issue: Calculated Field Error

**Error:** `Cannot mix aggregate and non-aggregate arguments`

**Solution:**
- Use LOD expression: `{ FIXED [Customer ID] : SUM([Amount]) }`
- Or aggregate both sides: `SUM([Field1]) / SUM([Field2])`

---

### Issue: Dashboard Performance Slow

**Solutions:**
1. Use extracts instead of live connections
2. Pre-aggregate data in SQL
3. Reduce number of marks displayed
4. Simplify calculated fields
5. Remove unnecessary filters

---

### Issue: Tableau Public Upload Fails

**Error:** `Your workbook could not be saved`

**Solutions:**
1. Reduce workbook size (< 10MB for free accounts)
2. Limit data to essential rows
3. Remove unused data sources
4. Optimize extracts (hide unused fields)

---

## Optimization Tips

### SQL Performance
- Index foreign keys and date columns
- Use `WHERE` before `JOIN` when possible
- Pre-aggregate in CTEs for readability
- Test queries on small datasets first

### Tableau Performance
- Use extracts (not live connections)
- Pre-aggregate in SQL
- Limit marks per chart (< 10,000)
- Use filters efficiently
- Hide unused fields in extract

### Documentation
- Write as you go (don't save for the end)
- Screenshot iteratively (capture evolution)
- Comment SQL queries immediately
- Version control regularly

---

## Time Breakdown

**Actual time estimates:**
- Phase 1 (Database Setup): 30 min
- Phase 2 (Data Export): 1 hour
- Phase 3 (Tableau Setup): 30 min
- Phase 4 (Dashboard 1): 2 hours
- Phase 5 (Dashboard 2): 2 hours
- Phase 6 (Polish & Publish): 1 hour
- Phase 7 (Documentation): 1 hour
- Phase 8 (QA): 30 min
- Phase 9 (Presentation): 30 min

**Total: 8-10 hours**

---

## Next Steps

**After Completing This Project:**

1. **Add More Analysis:**
   - Cohort analysis by acquisition month
   - Product recommendation engine
   - Predictive churn modeling (Python/R)
   - Market basket analysis

2. **Expand Skills:**
   - Learn advanced Tableau (LOD, parameters, actions)
   - Add Python for data prep (pandas)
   - Build automated refresh pipeline
   - Create Tableau Server deployment

3. **Portfolio Enhancement:**
   - Add video walkthrough
   - Write blog post about process
   - Present at local meetup
   - Get feedback from professionals

---

## Related Resources

### Learning Resources
- **Tableau:** [Tableau Desktop Specialist Certification](https://www.tableau.com/learn/certification/desktop-specialist)
- **SQL:** [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- **BI Best Practices:** [Kimball Group](https://www.kimballgroup.com/)

### Similar Projects
- [Customer Segmentation with RFM Analysis](https://github.com/topics/customer-segmentation)
- [Revenue Analytics Dashboards](https://public.tableau.com/app/discover)
- [E-commerce Analytics Case Studies](https://www.tableau.com/solutions/ecommerce)

### Community
- **Tableau Public Forums:** Share and get feedback
- **r/dataisbeautiful:** Post visualizations
- **LinkedIn Analytics Groups:** Network with professionals

---

## Feedback & Iteration

**How to Improve This Project:**

1. **Gather Feedback:**
   - Share with mentors
   - Post in Tableau community
   - Get peer review from other analysts

2. **Common Suggestions:**
   - Add year-over-year comparison
   - Include profitability analysis
   - Build predictive models
   - Add more interactivity

3. **Iterate Based on Feedback:**
   - Prioritize high-impact improvements
   - Document changes in git commits
   - Update documentation accordingly

---

## Success Criteria

**Project is complete when:**
- All dashboards published to Tableau Public
- GitHub repository fully documented
- SQL queries validated and commented
- Insights documented with business context
- Screenshots captured and organized
- README is comprehensive
- Project shared on LinkedIn
- Portfolio updated

---

## For Hiring Managers

**What This Workflow Demonstrates:**

**End-to-End Capability**
- Database extraction to final dashboard
- No black boxes or hidden steps
- Reproducible process

**Technical Proficiency**
- Advanced SQL (window functions, aggregations)
- Tableau calculated fields and LODs
- Data modeling and optimization

**Business Acumen**
- Insight generation, not just visualization
- Actionable recommendations
- Risk identification and quantification

**Communication Skills**
- Clear documentation
- Visual storytelling
- Technical and business audiences considered

**Professional Practices**
- Version control (Git)
- Documentation standards
- Quality assurance process
- Iterative improvement

---

## Related Documentation

- **Methodology:** [`methodology.md`](methodology.md)
- **Business Context:** [`business-context.md`](business-context.md)
- **Technical Details:** [`technical-implementation.md`](technical-implementation.md)
- **SQL Reference:** [`../01-SQL-Queries/README.md`](../01-SQL-Queries/README.md)
- **Dashboard Specs:** [`../02-Tableau-Workbooks/dashboard-specs.md`](../02-Tableau-Workbooks/dashboard-specs.md)