-- ============================================
-- CALCULATED METRICS - Business Logic & KPI Definitions
-- ============================================
-- Purpose: Document calculated fields used in Tableau dashboards
-- These are NOT queries to run - they are reference formulas
-- ============================================


-- ============================================
-- CUSTOMER SEGMENTATION
-- ============================================

-- Customer Tier (Platinum/Gold/Silver/Bronze)
-- SQL Problem: I3 (Customer segmentation by spending)
-- Used in: Customer Analytics Dashboard (tier donut, LTV scatter)

/*
Tableau Calculated Field: "Customer Tier"

IF [Lifetime Value] >= 5000 THEN "Platinum"
ELSEIF [Lifetime Value] >= 1000 THEN "Gold"
ELSEIF [Lifetime Value] >= 500 THEN "Silver"
ELSE "Bronze"
END

SQL Equivalent:
*/

SELECT 
    customer_id,
    lifetime_value,
    CASE 
        WHEN lifetime_value >= 5000 THEN 'Platinum'
        WHEN lifetime_value >= 1000 THEN 'Gold'
        WHEN lifetime_value >= 500 THEN 'Silver'
        ELSE 'Bronze'
    END AS customer_tier
FROM customer_ltv;


-- ============================================
-- CHURN RISK ANALYSIS
-- ============================================

-- Churn Risk Status
-- SQL Problem: B26 (Date interval filtering)
-- Used in: Customer Analytics Dashboard (churn risk matrix)

/*
Tableau Calculated Field: "Churn Risk Status"

IF [Days Since Last Order] > 180 THEN "High Risk"
ELSEIF [Days Since Last Order] > 90 THEN "At Risk"
ELSEIF ISNULL([Days Since Last Order]) THEN "Never Ordered"
ELSE "Active"
END

SQL Equivalent:
*/

SELECT 
    customer_id,
    days_since_last_order,
    CASE 
        WHEN days_since_last_order > 180 THEN 'High Risk'
        WHEN days_since_last_order > 90 THEN 'At Risk'
        WHEN days_since_last_order IS NULL THEN 'Never Ordered'
        ELSE 'Active'
    END AS churn_risk_status
FROM customer_ltv;


-- ============================================
-- ORDER FREQUENCY SEGMENTATION
-- ============================================

-- Order Frequency Bucket
-- SQL Problem: B29 (Order count per customer)
-- Used in: Customer Analytics Dashboard (churn matrix rows)

/*
Tableau Calculated Field: "Order Frequency Bucket"

IF [Total Orders] = 0 THEN "0 orders"
ELSEIF [Total Orders] = 1 THEN "1 order"
ELSEIF [Total Orders] <= 3 THEN "2-3 orders"
ELSE "4+ orders"
END

SQL Equivalent:
*/

SELECT 
    customer_id,
    total_orders,
    CASE 
        WHEN total_orders = 0 THEN '0 orders'
        WHEN total_orders = 1 THEN '1 order'
        WHEN total_orders <= 3 THEN '2-3 orders'
        ELSE '4+ orders'
    END AS order_frequency_bucket
FROM customer_ltv;


-- ============================================
-- REVENUE METRICS
-- ============================================

-- Month-over-Month Growth Percentage
-- SQL Problem: I11 (LAG window function for MoM analysis)
-- Used in: Revenue Overview Dashboard (monthly trend annotations)

/*
Tableau Calculated Field: "MoM Growth %"

(([Revenue] - LOOKUP([Revenue], -1)) / LOOKUP([Revenue], -1)) * 100

SQL Equivalent:
*/

WITH monthly_revenue AS (
    SELECT 
        DATE_TRUNC('month', order_date) AS month,
        SUM(total_amount) AS revenue
    FROM orders
    WHERE status = 'paid'
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT 
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) AS previous_month_revenue,
    ROUND(
        ((revenue - LAG(revenue) OVER (ORDER BY month)) / 
        LAG(revenue) OVER (ORDER BY month)) * 100, 
        1
    ) AS mom_growth_pct
FROM monthly_revenue
ORDER BY month;


-- ============================================
-- PRODUCT PERFORMANCE
-- ============================================

-- Revenue Percentile Rank
-- SQL Problem: A17 (PERCENT_RANK window function)
-- Used in: Revenue Overview Dashboard (product ranking)

/*
Tableau Calculated Field: "Revenue Percentile"

PERCENT_RANK([Total Revenue])

SQL Equivalent:
*/

SELECT 
    product_id,
    product_name,
    total_revenue,
    PERCENT_RANK() OVER (ORDER BY total_revenue) AS revenue_percentile
FROM product_performance
ORDER BY total_revenue DESC;


-- ============================================
-- KPI CALCULATIONS
-- ============================================

-- Total Revenue (paid orders only)
-- SQL Problem: B9 (SUM aggregation)

SELECT SUM(total_amount) AS total_revenue
FROM orders
WHERE status = 'paid';
-- Result: $39,385


-- Average Order Value
-- SQL Problem: B10 (AVG aggregation)

SELECT ROUND(AVG(total_amount), 2) AS avg_order_value
FROM orders
WHERE status = 'paid';
-- Result: $1,158


-- Total Unique Customers (with paid orders)

SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM orders
WHERE status = 'paid';
-- Result: 34


-- ============================================
-- TABLEAU LOD EXPRESSIONS
-- ============================================

-- Customer LTV (Level of Detail expression)
-- Used for: Scatter plots, customer ranking

/*
Tableau LOD Expression:

{ FIXED [Customer ID] : SUM([Total Amount]) }

This calculates total spending per customer regardless of dashboard filters
*/


-- ============================================
-- NOTES
-- ============================================

-- 1. All calculated fields are case-insensitive in Tableau but case-sensitive in SQL
-- 2. Tableau's ISNULL() = SQL's IS NULL
-- 3. Tableau's LOOKUP() = SQL's LAG()/LEAD()
-- 4. Tableau's PERCENT_RANK() works the same as SQL's PERCENT_RANK()
-- 5. Date truncation: Tableau uses DATE_TRUNC() same as PostgreSQL

-- For complete Tableau calculated field syntax, see:
-- 02-Tableau-Workbooks/tableau-calculations.md
```