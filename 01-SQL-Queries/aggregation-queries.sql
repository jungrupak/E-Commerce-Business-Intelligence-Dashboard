-- ============================================
-- AGGREGATION QUERIES - Pre-computed Views for Tableau
-- ============================================
-- Purpose: Generate pre-aggregated CSV files optimized for Tableau visualization
-- Database: PostgreSQL (ecommerce_practice)
-- Output Location: 00-Data-Sources/processed/
-- ============================================

-- SQL Problems Applied:
-- A32: Customer LTV calculation
-- I11: Month-over-month revenue analysis
-- B13: Product performance metrics
-- B26: Churn detection (days since last order)
-- ============================================


-- ============================================
-- 1. CUSTOMER LIFETIME VALUE (customer_ltv.csv)
-- ============================================
-- Business Use: Customer segmentation, churn analysis, LTV distribution
-- Tableau Dashboards: Customer Analytics (scatter plot, tier donut, churn matrix)
-- SQL Problems: A32 (LTV function), I3 (segmentation), B29 (order frequency)

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
    ORDER BY lifetime_value DESC
) TO '00-Data-Sources/processed/customer_ltv.csv' CSV HEADER;
-- Expected output: COPY 35


-- ============================================
-- 2. MONTHLY REVENUE (monthly_revenue.csv)
-- ============================================
-- Business Use: Time-series analysis, trend identification, MoM growth
-- Tableau Dashboards: Revenue Overview (monthly trend line, KPIs)
-- SQL Problems: I11 (MoM growth), B9 (total revenue), B10 (AOV)

\copy (
    SELECT 
        DATE_TRUNC('month', order_date)::DATE AS month,
        COUNT(DISTINCT order_id) AS total_orders,
        SUM(total_amount) AS revenue,
        COUNT(DISTINCT customer_id) AS unique_customers,
        ROUND(AVG(total_amount), 2) AS avg_order_value
    FROM orders
    WHERE status = 'paid'
    GROUP BY DATE_TRUNC('month', order_date)
    ORDER BY month
) TO '00-Data-Sources/processed/monthly_revenue.csv' CSV HEADER;
-- Expected output: COPY 10


-- ============================================
-- 3. PRODUCT PERFORMANCE (product_performance.csv)
-- ============================================
-- Business Use: Product ranking, category analysis, sales velocity
-- Tableau Dashboards: Revenue Overview (category bars, product rankings)
-- SQL Problems: B13 (units sold), A17 (revenue percentile)

\copy (
    SELECT 
        p.product_id,
        p.product_name,
        c.category_name,
        p.price,
        COALESCE(SUM(oi.quantity), 0) AS units_sold,
        COALESCE(SUM(oi.unit_price * oi.quantity), 0) AS total_revenue
    FROM products p
    LEFT JOIN categories c ON p.category_id = c.category_id
    LEFT JOIN order_items oi ON p.product_id = oi.product_id
    LEFT JOIN orders o ON oi.order_id = o.order_id
    WHERE o.status = 'paid' OR o.status IS NULL
    GROUP BY p.product_id, p.product_name, c.category_name, p.price
    ORDER BY total_revenue DESC
) TO '00-Data-Sources/processed/product_performance.csv' CSV HEADER;
-- Expected output: COPY 20


-- ============================================
-- AGGREGATION COMPLETE
-- ============================================
-- Total processed files: 3
-- Total records: 65 (35 customers + 10 months + 20 products)
-- Ready for Tableau import
-- Next step: Open Tableau and connect to processed/ folder