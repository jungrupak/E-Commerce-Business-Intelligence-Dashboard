# Tableau Workbooks

Technical specifications and calculated field documentation for the Tableau dashboards.

---

## Overview

**Tableau Public Workbook:** [E-Commerce Business Analytics: Revenue Performance & Customer Segmentation](https://public.tableau.com/app/profile/lenny.success.humphrey/)

**Dashboards:** 2  
**Sheets:** 12  
**Data Sources:** 3 (customer_ltv.csv, monthly_revenue.csv, product_performance.csv)  
**Calculated Fields:** 5  
**Parameters:** 0 (static dashboards)

---

## Workbook Structure

### Dashboard 1: Revenue Overview
**Sheets (7):**
- KPI - Total Revenue
- KPI - Total Orders  
- KPI - Average Order Value
- KPI - Total Customers
- Monthly Revenue Trend
- Revenue by Category
- Top 10 Customers
- Customer Acquisition Trend

### Dashboard 2: Customer Analytics
**Sheets (5):**
- Customer LTV Scatter
- Customer Tiers (Donut)
- Churn Risk Matrix
- Top Customers Table
- (Customer Acquisition Trend - shared from Dashboard 1)

---

## Data Connections

### Primary Data Sources

**1. customer_ltv.csv**
- **Used in:** Dashboard 2 (all sheets)
- **Relationships:** None (single table)
- **Records:** 35 customers
- **Key fields:** customer_id (PK), lifetime_value, total_orders, days_since_last_order

**2. monthly_revenue.csv**
- **Used in:** Dashboard 1 (monthly trend, KPIs)
- **Relationships:** None (pre-aggregated)
- **Records:** 10 months
- **Key fields:** month (PK), revenue, total_orders, avg_order_value

**3. product_performance.csv**
- **Used in:** Dashboard 1 (category bars)
- **Relationships:** None (pre-aggregated)
- **Records:** 20 products
- **Key fields:** product_id (PK), category_name, total_revenue

**Data Model:** Star schema (pre-aggregated fact tables, no dimension joins needed in Tableau)

---

## Calculated Fields

All calculated fields documented in [`tableau-calculations.md`](tableau-calculations.md)

**Summary:**
1. Customer Tier (Platinum/Gold/Silver/Bronze)
2. Churn Risk Status (Active/At Risk/High Risk)
3. Order Frequency Bucket (0/1/2-3/4+ orders)
4. Days Since Last Order (bins for heatmap)

---

## Dashboard Specifications

Complete technical details in [`dashboard-specs.md`](dashboard-specs.md)

**Includes:**
- Sheet dimensions and layouts
- Color palettes and formatting
- Filter configurations
- Tooltip customizations
- Dashboard actions

---

## Performance Considerations

**Optimization techniques applied:**
- Pre-aggregated data sources (no live database connection)
- Extract instead of live connection (faster loading)
- Minimal calculated fields (logic in SQL where possible)
- No complex LOD expressions (aggregations done in SQL)
- Efficient filter configurations

**Load time:** < 2 seconds for both dashboards

---

## Tableau Public Limitations

**Features NOT available in Tableau Public:**
- Live database connections (using CSV extracts instead)
- Data refresh scheduling (manual re-upload required)
- Private/password-protected dashboards
- Custom SQL queries (pre-aggregated CSVs instead)

**Workarounds implemented:**
- Pre-aggregated views exported as CSVs
- Manual refresh when source data updates
- Public dashboard with clear synthetic data disclaimer

---

## How to Reproduce

### Option 1: Download from Tableau Public
1. Visit [Tableau Public workbook link](https://public.tableau.com/app/profile/lenny.success.humphrey/)
2. Click "Download" (top-right)
3. Open in Tableau Desktop/Public

### Option 2: Build from Data Sources
1. Download CSVs from `00-Data-Sources/processed/`
2. Open Tableau Desktop/Public
3. Connect to CSV files
4. Follow [`dashboard-specs.md`](dashboard-specs.md) to rebuild

---

## Version History

**v1.0** (January 2026)
- Initial release
- 2 dashboards, 12 sheets
- Revenue overview + customer analytics