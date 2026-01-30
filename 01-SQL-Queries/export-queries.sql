-- ============================================
-- EXPORT QUERIES - PostgreSQL to CSV
-- ============================================
-- Purpose: Export raw tables from PostgreSQL database to CSV files
-- Database: ecommerce_practice (from SQL-Portfolio-105-Problems)
-- Output Location: 00-Data-Sources/raw/
-- ============================================

-- ============================================
-- USAGE INSTRUCTIONS
-- ============================================

-- OPTION A: Using PostgreSQL Command Line (psql)
-- -----------------------------------------------
-- 1. Connect to database:
--    psql -U your_username -d ecommerce_practice
-- 2. Run this file:
--    \i 01-SQL-Queries/export-queries.sql
-- 3. Files will be exported using \copy commands below


-- OPTION B: Using VS Code with PostgreSQL Extension
-- --------------------------------------------------
-- 1. Replace \copy with COPY and use absolute paths:
--    Change: \copy (...) TO 'relative/path/file.csv' CSV HEADER;
--    To:     COPY (...) TO '/absolute/path/to/file.csv' WITH CSV HEADER;
-- 
-- 2. Or use the manual export method (RECOMMENDED for VS Code):
--    a. Run each SELECT query individually
--    b. Right-click on results table → "Export Results"
--    c. Choose CSV format
--    d. Save to 00-Data-Sources/raw/ folder
--
-- Example for manual export:
--    SELECT * FROM customers;
--    -- Then export results as customers.csv


-- OPTION C: Using pgAdmin or DBeaver
-- -----------------------------------
-- 1. Execute each SELECT query
-- 2. Use the GUI export function to save as CSV


-- ============================================
-- CORE TABLES EXPORT
-- ============================================
-- NOTE: The \copy commands below work with psql (Option A)
-- For VS Code (Option B), see instructions above

-- Export Customers table
\copy (SELECT * FROM customers) TO '00-Data-Sources/raw/customers.csv' CSV HEADER;
-- Expected output: COPY 35
-- VS Code alternative: SELECT * FROM customers; → Export as CSV

-- Export Orders table
\copy (SELECT * FROM orders) TO '00-Data-Sources/raw/orders.csv' CSV HEADER;
-- Expected output: COPY 37
-- VS Code alternative: SELECT * FROM orders; → Export as CSV

-- Export Order Items table
\copy (SELECT * FROM order_items) TO '00-Data-Sources/raw/order_items.csv' CSV HEADER;
-- Expected output: COPY 40
-- VS Code alternative: SELECT * FROM order_items; → Export as CSV

-- Export Products table
\copy (SELECT * FROM products) TO '00-Data-Sources/raw/products.csv' CSV HEADER;
-- Expected output: COPY 20
-- VS Code alternative: SELECT * FROM products; → Export as CSV

-- Export Categories table
\copy (SELECT * FROM categories) TO '00-Data-Sources/raw/categories.csv' CSV HEADER;
-- Expected output: COPY 8
-- VS Code alternative: SELECT * FROM categories; → Export as CSV

-- Export Payments table
\copy (SELECT * FROM payments) TO '00-Data-Sources/raw/payments.csv' CSV HEADER;
-- Expected output: COPY 39
-- VS Code alternative: SELECT * FROM payments; → Export as CSV

-- ============================================
-- EXPORT COMPLETE
-- ============================================
-- Total files exported: 6
-- Total records: 179
-- Next step: Run aggregation-queries.sql to generate processed views


-- ============================================
-- TROUBLESHOOTING
-- ============================================

-- Issue: "Permission denied" or "could not open file"
-- Solution (psql): Use absolute paths instead of relative
-- Example: \copy (...) TO '/full/path/to/00-Data-Sources/raw/customers.csv' CSV HEADER;

-- Issue: VS Code - "COPY command not supported"
-- Solution: Use manual export method (run SELECT, then export results)

-- Issue: Files not in correct location
-- Solution: Check your current working directory with \! pwd (in psql)
--          or use absolute paths in the COPY command