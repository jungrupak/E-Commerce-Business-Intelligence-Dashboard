# Tableau Calculated Fields

Complete reference for all calculated fields used in the dashboards.

---

## Customer Segmentation

### 1. Customer Tier

**Purpose:** Classify customers into value tiers (Platinum/Gold/Silver/Bronze)

**Data Source:** customer_ltv.csv

**Formula:**
```
IF [Lifetime Value] >= 5000 THEN "Platinum"
ELSEIF [Lifetime Value] >= 1000 THEN "Gold"
ELSEIF [Lifetime Value] >= 500 THEN "Silver"
ELSE "Bronze"
END
```

**Used In:**
- Dashboard 2: LTV Scatter (color)
- Dashboard 2: Customer Tier Donut
- Dashboard 2: Top Customers Table

**Business Logic:**
- Platinum: $5,000+ lifetime value (VIP customers)
- Gold: $1,000-$4,999 (high-value)
- Silver: $500-$999 (medium-value)
- Bronze: $0-$499 (low-value or one-time buyers)

**SQL Equivalent:** See `01-SQL-Queries/calculated-metrics.sql`

---

### 2. Churn Risk Status

**Purpose:** Identify at-risk customers based on purchase recency

**Data Source:** customer_ltv.csv

**Formula:**
```
IF [Days Since Last Order] > 180 THEN "High Risk"
ELSEIF [Days Since Last Order] > 90 THEN "At Risk"
ELSEIF ISNULL([Days Since Last Order]) THEN "Never Ordered"
ELSE "Active"
END
```

**Used In:**
- Dashboard 2: Churn Risk Matrix (tooltip)
- Dashboard 2: Top Customers Table (conditional formatting)

**Business Logic:**
- Active: Purchased within last 90 days
- At Risk: 91-180 days since last order (needs re-engagement)
- High Risk: 181+ days inactive (likely churned)
- Never Ordered: Registered but no purchases (acquisition failure)

**Thresholds Rationale:**
- 90 days: Industry standard for e-commerce churn window
- 180 days: Point of likely permanent churn without intervention

---

### 3. Order Frequency Bucket

**Purpose:** Group customers by purchase frequency for churn matrix

**Data Source:** customer_ltv.csv

**Formula:**
```
IF [Total Orders] = 0 THEN "0 orders"
ELSEIF [Total Orders] = 1 THEN "1 order"
ELSEIF [Total Orders] <= 3 THEN "2-3 orders"
ELSE "4+ orders"
END
```

**Used In:**
- Dashboard 2: Churn Risk Matrix (columns)

**Business Logic:**
- 0 orders: Never converted (green in matrix)
- 1 order: One-time buyers (highest churn risk)
- 2-3 orders: Occasional buyers (moderate loyalty)
- 4+ orders: Repeat customers (high retention)

---

### 4. Days Since Last Order (bins)

**Purpose:** Create time buckets for churn matrix heatmap

**Data Source:** customer_ltv.csv

**Type:** Binned dimension (not calculated field)

**Configuration:**
- Field: Days Since Last Order
- Bin Size: 30 days
- Range: 0 to 360+ days

**Bins Created:**
- 0-30 days
- 31-60 days
- 61-90 days
- 91-120 days
- 121-150 days
- 151-180 days
- 181-210 days
- 211-240 days
- 241-270 days
- 271-300 days
- 301-330 days
- 331+ days
- NULL (never ordered)

**Used In:**
- Dashboard 2: Churn Risk Matrix (rows)

---

## Revenue Metrics

### 5. Month-over-Month Growth %

**Purpose:** Calculate percentage change in revenue from previous month

**Data Source:** monthly_revenue.csv

**Formula (Table Calculation):**
```
(([Revenue] - LOOKUP([Revenue], -1)) / LOOKUP([Revenue], -1)) * 100
```

**Compute Using:** Table (across)  
**Direction:** Next

**Used In:**
- Dashboard 1: Monthly Revenue Trend (annotation)

**Example:**
- January: $9,360 (no previous month)
- February: $933 → ($933 - $9,360) / $9,360 * 100 = -87.8%

**Note:** LOOKUP(-1) references the previous row in the table calculation

---

## Additional Calculations (Not Saved as Fields)

### Total Revenue (KPI)

**Formula:** `SUM([Revenue])`  
**Source:** monthly_revenue.csv  
**Result:** $39,385

### Total Orders (KPI)

**Formula:** `SUM([Total Orders])`  
**Source:** monthly_revenue.csv  
**Result:** 37

### Average Order Value (KPI)

**Formula:** `AVG([Avg Order Value])`  
**Source:** monthly_revenue.csv  
**Result:** $1,158

### Total Customers (KPI)

**Formula:** `SUM([Unique Customers])`  
**Source:** monthly_revenue.csv  
**Result:** 34

### Cumulative Customers (Acquisition Trend)

**Formula (Table Calculation):** `RUNNING_SUM(COUNTD([Customer ID]))`  
**Source:** customer_ltv.csv  
**Compute Using:** Table (across), by Created At (month)

---

## LOD Expressions

**Note:** No LOD expressions used in this workbook. All aggregations pre-computed in SQL for performance.

**Alternative approach if using live database connection:**
```
// Customer LTV (if not pre-aggregated)
{ FIXED [Customer ID] : SUM([Total Amount]) }

// Monthly Revenue (if not pre-aggregated)
{ FIXED [Order Date] : SUM([Total Amount]) }
```

---

## Syntax Reference

### Common Functions

**Conditional Logic:**
- `IF condition THEN value ELSEIF condition THEN value ELSE value END`
- `CASE [Field] WHEN value THEN result END`

**Null Handling:**
- `ISNULL([Field])` - returns TRUE if null
- `IFNULL([Field], default)` - replaces null with default
- `ZN([Field])` - Zero if Null

**Aggregations:**
- `SUM([Field])` - Total
- `AVG([Field])` - Average
- `COUNT([Field])` - Count of records
- `COUNTD([Field])` - Count distinct

**Table Calculations:**
- `LOOKUP([Field], offset)` - Reference another row
- `RUNNING_SUM([Field])` - Cumulative total
- `PERCENT_RANK()` - Percentile ranking

**Date Functions:**
- `DATETRUNC('month', [Date])` - First day of month
- `DATEDIFF('day', [Start], [End])` - Days between dates

---

## Testing Calculated Fields

### Validation Queries
```sql
-- Verify Customer Tier distribution
SELECT 
    CASE 
        WHEN lifetime_value >= 5000 THEN 'Platinum'
        WHEN lifetime_value >= 1000 THEN 'Gold'
        WHEN lifetime_value >= 500 THEN 'Silver'
        ELSE 'Bronze'
    END AS tier,
    COUNT(*) as customer_count
FROM customer_ltv
GROUP BY tier;

-- Expected Results:
-- Platinum: 2
-- Gold: 5
-- Silver: 6
-- Bronze: 21


-- Verify Churn Risk Status
SELECT 
    CASE 
        WHEN days_since_last_order > 180 THEN 'High Risk'
        WHEN days_since_last_order > 90 THEN 'At Risk'
        WHEN days_since_last_order IS NULL THEN 'Never Ordered'
        ELSE 'Active'
    END AS status,
    COUNT(*) as customer_count
FROM customer_ltv
GROUP BY status;

-- Expected Results:
-- Active: ~15
-- At Risk: ~5
-- High Risk: ~12
-- Never Ordered: ~3
```

---

## Troubleshooting

**Issue:** Calculated field returns null
**Solution:** Check for null values in source data, use IFNULL() or ZN()

**Issue:** Table calculation not working
**Solution:** Verify "Compute Using" settings match your data structure

**Issue:** Customer Tier not displaying in color legend
**Solution:** Convert calculated field to Dimension (right-click → Convert to Dimension)

**Issue:** MoM Growth showing incorrect values
**Solution:** Ensure table calculation is computing across Table (not Pane or Cell)

---

## Best Practices

✅ **Do:**
- Use meaningful field names
- Comment complex calculations
- Test with edge cases (nulls, zeros, extremes)
- Pre-aggregate in SQL when possible for performance

❌ **Don't:**
- Create redundant calculated fields
- Use nested IFs when CASE is clearer
- Mix aggregated and non-aggregated fields
- Ignore null handling
```