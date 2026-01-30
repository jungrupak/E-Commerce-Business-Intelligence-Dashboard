# SQL Queries

All SQL queries used to generate data sources for the Tableau dashboards.

---

## Overview

This folder documents the complete SQL workflow:
1. **Export queries** - Extract data from PostgreSQL to CSV
2. **Aggregation queries** - Pre-compute metrics for Tableau
3. **Calculated metrics** - Business logic and KPI definitions

**Source Database:** [SQL-Portfolio-105-Problems](https://github.com/LennySHumphrey/SQL-Portfolio-105-Problems)  
**Database:** PostgreSQL 15  
**Schema:** 15 tables, normalized e-commerce model

---

## Files

### `export-queries.sql`
PostgreSQL commands to export raw tables to CSV files.

**Exports:**
- Core tables: customers, orders, order_items, products, categories, payments
- Output location: `00-Data-Sources/raw/`

**Usage Options:**
- **Option A:** PostgreSQL command line (psql)
- **Option B:** VS Code with PostgreSQL extension (recommended)
- **Option C:** pgAdmin, DBeaver, or other GUI tools

### `aggregation-queries.sql`
Pre-aggregation queries that create processed views for Tableau.

**Creates:**
- `customer_ltv.csv` - Customer lifetime value metrics
- `monthly_revenue.csv` - Time-series revenue data
- `product_performance.csv` - Product-level sales metrics

**Usage Options:**
- **Option A:** PostgreSQL command line (psql)
- **Option B:** VS Code - Run SELECT queries and export results manually (recommended)
- **Option C:** Other database GUI tools

### `calculated-metrics.sql`
Business metric definitions and Tableau calculated field equivalents.

**Includes:**
- Customer tier classification (Platinum/Gold/Silver/Bronze)
- Churn risk status (Active/At Risk/High Risk)
- Month-over-month growth calculations
- Order frequency buckets

---

## Usage

### Option A: PostgreSQL Command Line (psql)

**Setup:**
1. Ensure PostgreSQL is installed on your system
2. Have access to the ecommerce_practice database
3. Navigate to your project directory in terminal

**To Export Data from PostgreSQL:**

1. **Connect to your database:**
   ```bash
   psql -U your_username -d ecommerce_practice
   ```
   - Replace `your_username` with your PostgreSQL username
   - You'll be prompted for your password

2. **Navigate to project directory (if needed):**
   ```bash
   \! cd /path/to/your/project
   ```

3. **Run the export file:**
   ```bash
   \i 01-SQL-Queries/export-queries.sql
   ```
   - This executes all `\copy` commands in the file
   - Files will be saved to `00-Data-Sources/raw/`

4. **Verify exports:**
   ```bash
   \! ls -lh 00-Data-Sources/raw/*.csv
   ```
   - You should see 6 CSV files
   - Check file sizes to ensure data was exported

**Expected Output:**
```
COPY 35   (customers)
COPY 37   (orders)
COPY 40   (order_items)
COPY 20   (products)
COPY 8    (categories)
COPY 39   (payments)
```

**To Generate Aggregated Views:**

1. **Still connected to database:**
   ```bash
   \i 01-SQL-Queries/aggregation-queries.sql
   ```
   - Executes all aggregation queries
   - Files saved to `00-Data-Sources/processed/`

2. **Verify aggregated files:**
   ```bash
   \! ls -lh 00-Data-Sources/processed/*.csv
   ```

**Expected Output:**
```
COPY 35   (customer_ltv)
COPY 10   (monthly_revenue)
COPY 20   (product_performance)
```

**Alternative: Run Individual Commands**

If you prefer to run commands one at a time:

1. **Open the SQL file in a text editor**
2. **Copy each `\copy` command**
3. **Paste into psql terminal**
4. **Press Enter to execute**

Example:
```bash
psql -U postgres -d ecommerce_practice

ecommerce_practice=# \copy (SELECT * FROM customers) TO '00-Data-Sources/raw/customers.csv' CSV HEADER;
COPY 35
```

**Troubleshooting psql:**
- **Relative paths not working?** Use absolute paths:
  ```sql
  \copy (...) TO '/full/path/to/project/00-Data-Sources/raw/customers.csv' CSV HEADER;
  ```
- **Permission denied?** Check folder permissions:
  ```bash
  chmod 755 00-Data-Sources/raw/
  ```
- **File not found?** Check your current directory:
  ```bash
  \! pwd
  ```

---

### Option B: VS Code with PostgreSQL Extension (Recommended)

**Setup:**
1. Install VS Code
2. Install "PostgreSQL" extension and SQL Tools by Matheau Teixeira(Cockroach Driver). Alternatively, install Chris Kolman (PostgreSQL) for a stand alone extension.
3. Connect to your PostgreSQL database

**To Export Data:**

**Method 1: Manual Export (Simplest)**
1. Open `export-queries.sql` in VS Code
2. For each table, run the SELECT query (e.g., `SELECT * FROM customers;`)
3. Right-click on results table → "Export Results"
4. Choose CSV format
5. Save to `00-Data-Sources/raw/` folder
6. Repeat for all 6 tables

**Method 2: Using COPY Command**
1. Modify `\copy` commands to `COPY` with absolute paths
2. Example:
   ```sql
   -- Change from:
   \copy (SELECT * FROM customers) TO 'file.csv' CSV HEADER;
   
   -- To:
   COPY (SELECT * FROM customers) TO '/absolute/path/to/file.csv' WITH CSV HEADER;
   ```
3. Run each command

**To Generate Aggregated Views:**
1. Open `aggregation-queries.sql`
2. Copy each SELECT query (without the `\copy` wrapper)
3. Run in VS Code
4. Export results as CSV
5. Save to `00-Data-Sources/processed/` folder

**Example for Customer LTV:**
```sql
-- Run this in VS Code:
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
ORDER BY lifetime_value DESC;

-- Then: Right-click results → Export as customer_ltv.csv
```

---

### Option C: Other Database GUI Tools

**pgAdmin:**
1. Execute each query
2. Use "Download as CSV" option from results grid

**DBeaver:**
1. Execute query
2. Right-click results → Export Data → CSV
3. Save to appropriate folder

---

## To Reference Calculated Metrics:

See [`calculated-metrics.sql`](./aggregation-queries.sql) for formulas used in Tableau calculated fields.

---

## SQL Problems Applied

These queries demonstrate solutions from the SQL portfolio:

**Window Functions:**
- **Problem I11:** Month-over-month growth with LAG()
- **Problem A32:** Customer LTV calculation
- **Problem I7:** Previous order comparison

**Aggregations:**
- **Problem B9:** Total revenue (SUM)
- **Problem B10:** Average order value
- **Problem B13:** Units sold per product

**Advanced Patterns:**
- **Problem A6:** Category revenue pivot (CROSSTAB)
- **Problem I3:** Customer segmentation logic
- **Problem B26:** Churn detection (date intervals)

---

## Query Optimization

All queries follow performance best practices:
- Use of indexes on date and foreign key columns
- Efficient aggregations with GROUP BY
- WHERE filters applied before joins
- Date truncation for time-series analysis

See [`04-Documentation/technical-implementation.md`](../04-Documentation/technical-implementation.md) for detailed optimization notes.

---

## Verification

After running exports, verify record counts:

```sql
-- Should get 35 customers
SELECT COUNT(*) FROM customers;

-- Should get 37 orders
SELECT COUNT(*) FROM orders;

-- Should get 10 months of paid orders
SELECT COUNT(DISTINCT DATE_TRUNC('month', order_date)) 
FROM orders 
WHERE status = 'paid';
```

---

## Troubleshooting

### Issue: Permission denied when exporting
**Solution (psql):** Use absolute paths instead of relative paths

### Issue: VS Code doesn't recognize \copy
**Solution:** Use manual export method (run SELECT, then export results)

### Issue: Getting different record counts
**Solution:** Check WHERE clauses:
- customer_ltv: excludes cancelled orders
- monthly_revenue: only 'paid' orders
- product_performance: only 'paid' orders

### Issue: NULL values appearing
**Solution:** Use COALESCE to convert NULL to 0 (already in queries)

---

## Files Generated

After running all queries successfully, you should have:

**In `00-Data-Sources/raw/`:**
- customers.csv (35 records)
- orders.csv (37 records)
- order_items.csv (40 records)
- products.csv (20 records)
- categories.csv (8 records)
- payments.csv (39 records)

**In `00-Data-Sources/processed/`:**
- customer_ltv.csv (35 records)
- monthly_revenue.csv (10 records)
- product_performance.csv (20 records)

---

## Next Steps

Once all CSV files are generated:
1. Verify file sizes and record counts
2. Open files in text editor to check formatting
3. Proceed to Tableau connection. See [`04-Documentation/sql-to-tableau-workflow.md`](../04-Documentation/sql-to-tableau-workflow.md)