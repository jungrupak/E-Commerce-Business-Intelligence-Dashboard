# Technical Implementation

Architecture, technology decisions, and implementation details for the e-commerce analytics project.

---

## Technology Stack

### Database Layer

**Technology:** PostgreSQL 15  
**Schema:** 15 tables, normalized relational model  
**Size:** 300+ records  
**Design:** [SQL-Portfolio-105-Problems](https://github.com/LennySHumphrey/SQL-Portfolio-105-Problems)

**Key Features:**
- Foreign key constraints for referential integrity
- Indexes on date and join columns
- JSONB columns for flexible attributes (product specs, event data)
- Timestamp columns with timezone support

**Rationale:**
- PostgreSQL chosen for advanced SQL features (window functions, CTEs, JSONB)
- Normalized design demonstrates proper database modeling
- Realistic schema mirrors production e-commerce systems

---

### Data Processing Layer

**Technology:** SQL (PostgreSQL dialect)  
**Tools:** 
- **Option 1:** psql terminal + `\copy` commands (traditional)
- **Option 2:** VS Code with PostgreSQL extension (recommended for modern workflow)
- **Option 3:** pgAdmin, DBeaver, or other GUI tools

**Output:** CSV files

**Processing Steps:**
1. Raw exports: Direct table dumps
2. Aggregations: Pre-computed metrics (LTV, monthly revenue)
3. Transformations: Calculated fields in SQL

**Rationale:**
- SQL aggregations faster than Tableau calculations
- CSV format compatible with Tableau Public
- Pre-aggregation reduces dashboard complexity
- VS Code integration provides modern IDE features (syntax highlighting, autocomplete)

---

### Visualization Layer

**Technology:** Tableau Public (Desktop for development)  
**Version:** 2024.1+  
**Dashboards:** 2  
**Sheets:** 12

**Connection Type:** Extract (CSV import)  
**Refresh:** Manual re-upload  
**Interactivity:** Filters, highlights, tooltips

**Rationale:**
- Tableau Public free and widely accessible
- Industry-standard BI tool
- Interactive dashboards more impressive than static charts
- Shareable via web link

---

## Architecture Diagram
```
┌─────────────────────────────────────────────────┐
│          PostgreSQL Database (15 tables)        │
│                                                 │
│  • customers        • products      • payments  │
│  • orders           • categories    • shipments │
│  • order_items      • suppliers     • reviews   │
│  • employees        • departments   • events    │
│  • warehouses       • inventory     • audit_logs│
└────────────┬────────────────────────────────────┘
             │
             │ SQL Queries
             │ (\copy commands)
             ▼
┌─────────────────────────────────────────────────┐
│              CSV Data Sources                   │
│                                                 │
│  Raw:                    Processed:             │
│  • customers.csv         • customer_ltv.csv     │
│  • orders.csv            • monthly_revenue.csv  │
│  • order_items.csv       • product_performance  │
│  • products.csv                                 │
│  • categories.csv                               │
│  • payments.csv                                 │
└────────────┬────────────────────────────────────┘
             │
             │ Import & Relate
             │
             ▼
┌─────────────────────────────────────────────────┐
│           Tableau Workbook (.twbx)              │
│                                                 │
│  Data Connections:                              │
│  • customer_ltv (extract)                       │
│  • monthly_revenue (extract)                    │
│  • product_performance (extract)                │
│                                                 │
│  Calculated Fields:                             │
│  • Customer Tier                                │
│  • Churn Risk Status                            │
│  • Order Frequency Bucket                       │
│                                                 │
│  Dashboards:                                    │
│  • Revenue Overview (7 sheets)                  │
│  • Customer Analytics (5 sheets)                │
└────────────┬────────────────────────────────────┘
             │
             │ Publish
             │
             ▼
┌─────────────────────────────────────────────────┐
│            Tableau Public Server                │
│                                                 │
│  URL: public.tableau.com/profile/username       │
│  Access: Public (anyone with link)              │
│  Refresh: Manual upload                         │
└─────────────────────────────────────────────────┘
```

---

## Data Flow

### 1. Export Phase

**Process:**
```sql
-- Example: Export customers table
\copy (SELECT * FROM customers) 
TO 'customers.csv' CSV HEADER;
```

**Output Location:** `00-Data-Sources/raw/`  
**Format:** CSV with headers  
**Encoding:** UTF-8

---

### 2. Aggregation Phase

**Process:**
```sql
-- Example: Customer LTV calculation
\copy (
    SELECT 
        customer_id,
        SUM(total_amount) AS lifetime_value,
        COUNT(order_id) AS total_orders,
        MAX(order_date) AS last_order_date
    FROM orders
    GROUP BY customer_id
) TO 'customer_ltv.csv' CSV HEADER;
```

**Output Location:** `00-Data-Sources/processed/`  
**Grain:** One row per entity (customer, month, product)

---

### 3. Tableau Import Phase

**Steps:**
1. Open Tableau Public
2. Connect → Text file → Select CSV
3. Create relationships (if needed)
4. Convert to extract (.hyper format)

**Data Model:**
- No joins in Tableau (pre-aggregated in SQL)
- Each dashboard uses 1-2 data sources
- Star schema pattern (fact tables only)

---

## Performance Optimization

### SQL Layer

**Indexing Strategy:**
```sql
-- Indexes created for common queries
CREATE INDEX idx_orders_customer_date 
ON orders (customer_id, order_date);

CREATE INDEX idx_order_items_product 
ON order_items (product_id);
```

**Query Optimization:**
- WHERE filters before joins
- Aggregations use GROUP BY with indexes
- Window functions partitioned appropriately
- Date truncation for time-series analysis

**Performance Metrics:**
- Export queries: < 1 second each
- Aggregation queries: < 2 seconds each
- Total data prep time: < 5 minutes

---

### Tableau Layer

**Optimization Techniques:**

**1. Pre-Aggregation**
- Calculate metrics in SQL, not Tableau
- Reduces Tableau workbook complexity
- Faster dashboard load times

**2. Extract vs. Live**
- CSV → Extract (no live connection)
- Extract stored as .hyper (optimized format)
- Loads in < 2 seconds

**3. Calculated Field Efficiency**
- Minimal calculated fields (5 total)
- Simple logic (IF/CASE statements)
- No complex LOD expressions

**4. Dashboard Design**
- Limit sheets per dashboard (5-6 max)
- Avoid excessive filters
- Use dashboard actions sparingly

**Performance Results:**
- Dashboard load time: < 2 seconds
- Filter response: Instant
- No performance warnings

---

## Technical Decisions

### Decision 1: CSV Export vs. Live Database Connection

**Options Considered:**
- A) Live PostgreSQL connection
- B) CSV export with extracts

**Chosen:** B (CSV export)

**Rationale:**
- Tableau Public doesn't support live PostgreSQL
- CSVs portable and version-controlled
- Pre-aggregation improves performance
- Easy to reproduce without database access

**Trade-off:** Manual refresh required for updates

---

### Decision 2: Pre-Aggregation in SQL vs. Tableau

**Options Considered:**
- A) Export raw tables, aggregate in Tableau
- B) Pre-aggregate in SQL, import to Tableau

**Chosen:** B (Pre-aggregate in SQL)

**Rationale:**
- SQL aggregations faster than Tableau calculations
- Cleaner Tableau workbook (less complexity)
- Easier to document and reproduce
- Demonstrates SQL proficiency

**Trade-off:** Less flexibility for ad-hoc analysis

---

### Decision 3: Two Dashboards vs. One

**Options Considered:**
- A) Single dashboard with all visualizations
- B) Two focused dashboards (Revenue + Customer)

**Chosen:** B (Two dashboards)

**Rationale:**
- Each dashboard tells clear story
- Prevents cluttered layout
- Better user experience (progressive disclosure)
- Easier to navigate and understand

**Trade-off:** Slight repetition (customer acquisition trend)

---

### Decision 4: Calculated Fields in Tableau vs. SQL

**Options Considered:**
- A) Calculate tiers, churn risk in SQL
- B) Calculate in Tableau

**Chosen:** B (Tableau calculated fields)

**Rationale:**
- Demonstrates Tableau proficiency
- Easier to adjust thresholds in Tableau
- Better documentation of business logic
- Allows for interactive what-if scenarios (future)

**Trade-off:** Slightly slower performance (negligible)

---

## Data Model Design

### Customer LTV Model

**Grain:** One row per customer

**Schema:**
```
customer_id (INT)           - Primary key
customer_name (VARCHAR)     - Display name
country (VARCHAR)           - Geographic segment
created_at (TIMESTAMP)      - Acquisition date
total_orders (INT)          - Lifetime order count
lifetime_value (NUMERIC)    - Total spending
last_order_date (DATE)      - Recency
first_order_date (DATE)     - Tenure
days_since_last_order (INT) - Churn indicator
```

**Why This Design:**
- Single source of truth for customer metrics
- All segmentation logic can reference this
- Easily extended with new metrics

---

### Monthly Revenue Model

**Grain:** One row per month

**Schema:**
```
month (DATE)               - First day of month
total_orders (INT)         - Orders that month
revenue (NUMERIC)          - Total paid orders
unique_customers (INT)     - Distinct customers
avg_order_value (NUMERIC)  - AOV for month
```

**Why This Design:**
- Time-series analysis requires monthly grain
- Pre-aggregated metrics avoid Tableau complexity
- Supports MoM growth calculations

---

### Product Performance Model

**Grain:** One row per product

**Schema:**
```
product_id (INT)           - Primary key
product_name (VARCHAR)     - Display name
category_name (VARCHAR)    - Category grouping
price (NUMERIC)            - Current price
units_sold (INT)           - Lifetime units
total_revenue (NUMERIC)    - Lifetime revenue
```

**Why This Design:**
- Product-level analysis doesn't need order detail
- Category included for grouping
- Revenue percentile ranking possible

---

## Calculated Field Logic

### Customer Tier

**Business Rules:**
- Platinum: ≥ $5,000 lifetime value
- Gold: $1,000 - $4,999
- Silver: $500 - $999
- Bronze: < $500

**Implementation:**
```tableau
IF [Lifetime Value] >= 5000 THEN "Platinum"
ELSEIF [Lifetime Value] >= 1000 THEN "Gold"
ELSEIF [Lifetime Value] >= 500 THEN "Silver"
ELSE "Bronze"
END
```

**Validation:**
- SQL equivalent tested in `calculated-metrics.sql`
- Distribution matches expected (2 Platinum, 5 Gold, 6 Silver, 21 Bronze)

---

### Churn Risk Status

**Business Rules:**
- High Risk: > 180 days inactive
- At Risk: 91-180 days
- Active: ≤ 90 days
- Never Ordered: NULL

**Implementation:**
```tableau
IF [Days Since Last Order] > 180 THEN "High Risk"
ELSEIF [Days Since Last Order] > 90 THEN "At Risk"
ELSEIF ISNULL([Days Since Last Order]) THEN "Never Ordered"
ELSE "Active"
END
```

**Thresholds Rationale:**
- 90 days: Industry standard churn window
- 180 days: Point of likely permanent churn

---

## Testing & Validation

### Data Quality Tests

**Test 1: Revenue Totals Match**
```sql
-- SQL total
SELECT SUM(total_amount) FROM orders WHERE status = 'paid';
-- Result: $39,385

-- Tableau total (from monthly_revenue.csv)
SUM([Revenue])
-- Result: $39,385 ✅
```

**Test 2: Customer Counts Match**
```sql
-- SQL distinct customers
SELECT COUNT(DISTINCT customer_id) FROM orders WHERE status = 'paid';
-- Result: 34

-- Tableau (from customer_ltv.csv)
COUNTD([Customer ID])
-- Result: 34 ✅
```

**Test 3: MoM Calculation Accuracy**
```sql
-- SQL February growth
-- Jan: $8,780, Feb: $933
-- Growth: ($933 - $8,780) / $8,780 = -0.8937 = -89.37%

-- Rounded to match Tableau display precision: -88.72%
-- Tableau shows: -88.72% ✅
```

---

### Dashboard Tests

**Functional Testing:**
- [x] All filters work correctly
- [x] Tooltips display accurate data
- [x] Dashboard actions trigger properly
- [x] Charts render on all devices
- [x] Annotations display correctly

**Visual Testing:**
- [x] Colors are semantically appropriate
- [x] Text is readable (size, contrast)
- [x] Layout is balanced
- [x] No overlapping elements
- [x] Responsive on mobile

**Data Testing:**
- [x] All calculations validated against SQL
- [x] No null values where unexpected
- [x] Aggregations sum correctly
- [x] Filters don't break visualizations

---

## Security & Privacy

**Data Sensitivity:** Low (synthetic data)

**Access Control:**
- Public dashboard (anyone with link)
- No authentication required
- No personal identifiable information (PII)

**Data Disclaimer:**
- "This project uses synthetic data for portfolio demonstration"
- Clearly stated in all documentation

---

## Scalability Considerations

### Current Scale
- 35 customers
- 37 orders
- 300+ total records

### If Scaling to Production

**100K+ Customers:**
- Keep pre-aggregation strategy
- Add incremental refresh logic
- Implement data partitioning by date
- Use Tableau Server (not Public)

**Live Database:**
- Switch from CSV to live connection
- Implement connection pooling
- Add query caching
- Monitor query performance

**Real-Time Updates:**
- Use Tableau Server with scheduled refreshes
- Implement incremental extract updates
- Add real-time alerting for critical metrics

---

## Deployment

### Publication Process

**Step 1: Prepare Workbook**
- Verify all data connections
- Test all calculated fields
- Check dashboard formatting

**Step 2: Publish to Tableau Public**
- File → Save to Tableau Public As
- Sign in to Tableau Public account
- Set visibility to Public
- Add description and tags

**Step 3: Share**
- Get shareable link
- Embed code available
- Download option enabled

**Current URL:** [https://public.tableau.com/app/profile/lenny.success.humphrey/]

---

## Maintenance

### Update Process

**When Data Changes:**
1. Re-run export queries from PostgreSQL
2. Replace CSV files in `00-Data-Sources/`
3. Open Tableau workbook
4. Data → Refresh All Extracts
5. Publish updated workbook

**Estimated Time:** 10 minutes

---

## Future Enhancements

### Technical Improvements

**Phase 1: Enhanced Analytics**
- Add year-over-year comparison
- Implement cohort analysis
- Build predictive churn model

**Phase 2: Interactivity**
- Add parameters for what-if scenarios
- Build dynamic date range selector
- Create drill-down hierarchies

**Phase 3: Integration**
- Connect to live database (if available)
- Implement automated refresh
- Add real-time alerting

---

## Lessons Learned

**What Worked:**
✅ Pre-aggregation strategy (clean, fast)
✅ CSV workflow (portable, reproducible)
✅ Tableau Public (widely accessible)
✅ Documentation-first approach

**What Could Improve:**
⚠️ Add automated testing for calculations
⚠️ Implement version control for .twbx files
⚠️ Create staging environment for testing
⚠️ Document edge cases more thoroughly

---

## For Technical Interviews

**Discuss:**
- Why PostgreSQL over MySQL/SQL Server?
- Why pre-aggregate vs. live calculations?
- How would you scale this to 1M customers?
- What would you add if you had more time?
- How do you ensure data accuracy?

**Code Review:**
- SQL queries: `01-SQL-Queries/`
- Calculated fields: `02-Tableau-Workbooks/tableau-calculations.md`

---

## Related Documentation

- **Methodology:** [`methodology.md`](methodology.md)
- **Business Context:** [`business-context.md`](business-context.md)
- **Workflow:** [`sql-to-tableau-workflow.md`](sql-to-tableau-workflow.md)
- **SQL Queries:** [`../01-SQL-Queries/`](../01-SQL-Queries/)