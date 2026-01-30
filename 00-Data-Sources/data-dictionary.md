# Data Dictionary

Complete reference for all data sources used in the Tableau dashboards.

---

## Raw Data Sources

### customers.csv

| Column | Type | Description | Example |
|--------|------|-------------|---------|
| customer_id | INT | Unique customer identifier (PK) | 1 |
| customer_name | VARCHAR(50) | Customer full name | Amy |
| customer_email | VARCHAR(50) | Email address (nullable) | amy2@gmail |
| country | VARCHAR(50) | Customer country (nullable) | Kenya |
| created_at | TIMESTAMPTZ | Account creation timestamp | 2024-01-14 |

**Records:** 35 customers  
**Nulls:** email (3), country (2)

---

### orders.csv

| Column | Type | Description | Example |
|--------|------|-------------|---------|
| order_id | INT | Unique order identifier (PK) | 1 |
| customer_id | INT | Foreign key to customers | 1 |
| order_date | TIMESTAMPTZ | Order placement timestamp | 2025-01-05 |
| status | VARCHAR(50) | Order status | paid |
| total_amount | DECIMAL(10,2) | Order total value | 8200.00 |
| notes | VARCHAR(50) | Order notes (nullable) | Laptop order |

**Records:** 37 orders  
**Status Values:** paid, pending, shipped, cancelled  
**Date Range:** 2025-01-05 to 2025-10-01

---

### order_items.csv

| Column | Type | Description | Example |
|--------|------|-------------|---------|
| order_id | INT | Foreign key to orders | 1 |
| line_number | INT | Line item number | 1 |
| product_id | INT | Foreign key to products | 1 |
| quantity | INT | Units ordered | 1 |
| unit_price | DECIMAL(10,2) | Price per unit at time of order | 1200.00 |

**Records:** 40 line items  
**Primary Key:** (order_id, line_number)

---

### products.csv

| Column | Type | Description | Example |
|--------|------|-------------|---------|
| product_id | INT | Unique product identifier (PK) | 1 |
| sku | VARCHAR(50) | Stock keeping unit (unique) | SKU-001 |
| product_name | VARCHAR(50) | Product name | Laptop Pro |
| category_id | INT | Foreign key to categories | 1 |
| price | DECIMAL(10,2) | Current retail price | 4200.00 |
| tags | VARCHAR(50) | Comma-separated tags | laptop,pro,work |
| specs | JSONB | Product specifications | {"ram_gb":16} |

**Records:** 20 products

---

### categories.csv

| Column | Type | Description | Example |
|--------|------|-------------|---------|
| category_id | INT | Unique category identifier (PK) | 1 |
| category_name | VARCHAR(50) | Category name | Computers |

**Records:** 8 categories  
**Categories:** Computers, Mobiles, Accessories, Office, Gaming, Furniture, Appliances, Clothing

---

### payments.csv

| Column | Type | Description | Example |
|--------|------|-------------|---------|
| payment_id | INT | Unique payment identifier (PK) | 1 |
| order_id | INT | Foreign key to orders | 1 |
| amount | DECIMAL(10,2) | Payment amount | 1200.00 |
| method | VARCHAR(50) | Payment method | card |
| paid_at | TIMESTAMPTZ | Payment timestamp | 2025-01-05 |
| refunded | BOOLEAN | Refund status | FALSE |

**Records:** 39 payments  
**Methods:** card, cash, bank_transfer  
**Notable:** Order #5 has split payments, Order #2 has refund

---

## Processed Data Sources

### customer_ltv.csv

**Purpose:** Pre-aggregated customer metrics for segmentation and churn analysis

| Column | Type | Description | Calculation |
|--------|------|-------------|-------------|
| customer_id | INT | Customer identifier | From customers table |
| customer_name | VARCHAR | Customer name | From customers table |
| country | VARCHAR | Customer country | From customers table |
| created_at | TIMESTAMPTZ | Registration date | From customers table |
| total_orders | INT | Total orders placed | COUNT(order_id) |
| lifetime_value | NUMERIC | Total spending | SUM(total_amount) |
| last_order_date | DATE | Most recent order | MAX(order_date) |
| first_order_date | DATE | First order | MIN(order_date) |
| days_since_last_order | INT | Days since last purchase | EXTRACT(DAY FROM NOW() - MAX(order_date)) |

**Records:** 35 customers (all)  
**SQL Problem:** A32, I3, B29

---

### monthly_revenue.csv

**Purpose:** Time-series revenue analysis

| Column | Type | Description | Calculation |
|--------|------|-------------|-------------|
| month | DATE | Month (first day) | DATE_TRUNC('month', order_date) |
| total_orders | INT | Orders in month | COUNT(DISTINCT order_id) |
| revenue | NUMERIC | Monthly revenue | SUM(total_amount) |
| unique_customers | INT | Customers who ordered | COUNT(DISTINCT customer_id) |
| avg_order_value | NUMERIC | Average order size | AVG(total_amount) |

**Records:** 10 months (Jan 2025 - Oct 2025)  
**Filters:** status = 'paid' only  
**SQL Problem:** I11, B9, B10

---

### product_performance.csv

**Purpose:** Product-level sales analysis

| Column | Type | Description | Calculation |
|--------|------|-------------|-------------|
| product_id | INT | Product identifier | From products table |
| product_name | VARCHAR | Product name | From products table |
| category_name | VARCHAR | Category name | From categories table |
| price | NUMERIC | Current price | From products table |
| units_sold | INT | Total units sold | SUM(quantity) |
| total_revenue | NUMERIC | Revenue generated | SUM(unit_price × quantity) |

**Records:** 20 products (all)  
**Filters:** Excludes cancelled orders  
**SQL Problem:** B13, A17

---

## Usage Notes

**For Tableau Desktop/Public:**
- Use processed CSVs for faster dashboard loading
- Raw CSVs available for custom analysis
- All files UTF-8 encoded

**For Analysis:**
- Null handling: COALESCE applied where appropriate
- Date formats: ISO 8601 (YYYY-MM-DD)
- Numeric precision: 2 decimal places for currency

**For Reproduction:**
- All export queries in [`01-SQL-Queries/export-queries.sql`](../01-SQL-Queries/export-queries.sql)
- Aggregation logic in [`01-SQL-Queries/aggregation-queries.sql`](../01-SQL-Queries/aggregation-queries.sql)
```