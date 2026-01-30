# Data Sources

## Overview

This folder contains all data exported from the PostgreSQL database used for the Tableau dashboards.

**Source Database:** [SQL-Portfolio-105-Problems](https://github.com/LennySHumphrey/SQL-Portfolio-105-Problems)

**Total Records:** 300+ across 15 tables  
**Time Period:** January 2024 - October 2025  
**Export Date:** January 2026

---

## Folder Structure

### `raw/`
Original CSV exports directly from PostgreSQL tables.

**Files:**
- `customers.csv` - Customer profiles (35 records)
- `orders.csv` - Order transactions (37 records)
- `order_items.csv` - Line items per order (40 records)
- `products.csv` - Product catalog (20 records)
- `categories.csv` - Product categories (8 records)
- `payments.csv` - Payment transactions (39 records)

### `processed/`
Pre-aggregated views optimized for Tableau visualization.

**Files:**
- `customer_ltv.csv` - Customer lifetime value metrics
- `monthly_revenue.csv` - Monthly revenue aggregations
- `product_performance.csv` - Product-level performance metrics

---

## Data Dictionary

See [`data-dictionary.md`](data-dictionary.md) for complete column definitions and data types.

---

## Export Queries

All SQL queries used to generate these files are documented in [`01-SQL-Queries/export-queries.sql`](../01-SQL-Queries/export-queries.sql)