# Dashboard Specifications

Technical specifications for reproducing the Tableau dashboards.

---

## Dashboard 1: Revenue Overview

### Layout Configuration

**Dashboard Size:** Custom Size(1350x850)  
**Background:** Kawaii Cream (#f5ead7)  
**Title Font:** Tahoma, 15pt, Bold  
**Padding:** 10px around all objects

### Sheet Specifications

#### 1. KPI Cards (Row 1)

**Sheet Names:** KPI - Total Revenue, KPI - Total Orders, KPI - Average Order Value, KPI - Total Customers

**Dimensions:**
- Height: 265px
- Width: 25% each (4 cards across)

**Data Source:** monthly_revenue.csv

**Calculations:**
- Total Revenue: `SUM([Revenue])`
- Orders Processed: `SUM([Total Orders])`
- Avg Monthly Revenue: `AVG([Avg Order Value])`
- Total Customers: `SUM([Unique Customers])`

**Formatting:**
- Number: Size 48pt, Bold, White text
- Label: Size 12pt, Regular, Gray (#666666)
- Background: Gradient blue (#2E5F8A to #4A7BA7)
- Alignment: Center

**Mark Type:** Text  
**Show Axes:** No  
**Show Gridlines:** No

---

#### 2. Monthly Revenue Trend

**Data Source:** monthly_revenue.csv

**Dimensions:**
- Height: 260px
- Width: Full width

**Marks:**
- Type: Area
- Color: Blue gradient (#4A7BA7 fill, 60% opacity)
- Border: Dark blue line (#2E5F8A)

**Axes:**
- X-axis: Month (continuous, format: MMM YYYY)
- Y-axis: Revenue (currency, $0K format)

**Reference Lines:**
- Average revenue: Dashed line, gray
- Label: "Average: <Value>"

**Annotations:**
- February point: "Feb: $933 | ▼ 88.72% From Jan"
- Font: 10pt, bold
- Background: White with border

**Tooltip:**
```
Month: <Month>
Revenue: <Revenue>
Orders: <Total Orders>
```

---

#### 3. Revenue by Category

**Data Source:** product_performance.csv

**Dimensions:**
- Height: 260px
- Width: 50% (left side)

**Marks:**
- Type: Bar (horizontal)
- Color: Blue (#4A7BA7)
- Sort: Descending by Total Revenue

**Axes:**
- Rows: Category Name
- Columns: SUM(Total Revenue)

**Labels:**
- Show: Yes
- Format: Currency ($0K)
- Position: End of bar

**Tooltip:**
```
Category: <Category Name>
Revenue: <Total Revenue>
```

---

#### 4. Top 10 Customers

**Data Source:** customer_ltv.csv

**Dimensions:**
- Height: 260px
- Width: 50% (right side)

**Marks:**
- Type: Bar (horizontal)
- Color: Teal (#2E8B91)
- Sort: Descending by Lifetime Value

**Filters:**
- Top 10 by Lifetime Value

**Axes:**
- Rows: Customer Name
- Columns: Lifetime Value

**Labels:**
- Show: Yes
- Format: Currency ($0K)
- Position: End of bar

**Tooltip:**
```
Customer: <Customer Name>
Lifetime Value: <Lifetime Value>
```

---

#### 5. Customer Acquisition Trend

**Data Source:** customer_ltv.csv

**Dimensions:**
- Height: 260px
- Width: Full width

**Marks:**
- Type: Area
- Color: Teal gradient (#2E8B91 fill, 50% opacity)

**Calculation:**
- Running Total: `RUNNING_SUM(COUNTD([Customer ID]))`

**Axes:**
- X-axis: Created At (month)
- Y-axis: Cumulative Customers

**Tooltip:**
```
Month: <Created At>
Total Customers: <Running Sum>
```

---

## Dashboard 2: Customer Analytics

### Layout Configuration

**Dashboard Size:** Custom Size(1350x850) 
**Background:** Kawaii Cream (#f5ead7) 
**Title Font:** Tahoma, 15pt, Bold

### Sheet Specifications

#### 1. Customer LTV Scatter Plot

**Data Source:** customer_ltv.csv

**Dimensions:**
- Height: 348px
- Width: 50% (left side)

**Marks:**
- Type: Circle
- Size: Based on Total Orders
- Color: Customer Tier (calculated field)

**Axes:**
- X-axis: Created At (exact date)
- Y-axis: Lifetime Value

**Color Palette:**
- Platinum: Purple (#8E44AD)
- Gold: Orange (#E67E22)
- Silver: Light Blue (#5DADE2)
- Bronze: Gray (#95A5A6)

**Reference Lines:**
- Average LTV: Horizontal dashed line

**Labels:**
- Show for: Top 5 customers only
- Field: Customer Name

**Tooltip:**
```
Customer: <Customer Name>
Tier: <Customer Tier>
Lifetime Value: <Lifetime Value>
Total Orders: <Total Orders>
Days Since Last Order: <Days Since Last Order>
```

---

#### 2. Customer Tier Donut Chart

**Data Source:** customer_ltv.csv

**Dimensions:**
- Height: 348px
- Width: 50% (right side)

**Marks:**
- Type: Pie (with dual axis for donut effect)
- Color: Customer Tier
- Angle: COUNTD(Customer ID)

**Labels:**
- Show: Yes
- Format: Count 
- Position: Outside

**Donut Center:**
- Text: "Total Customers: 34"
- Font: 9pt, Bold

**Color Palette:** Same as scatter plot

---

#### 3. Churn Risk Matrix (Heatmap)

**Data Source:** customer_ltv.csv

**Dimensions:**
- Height: 436px
- Width: Full width

**Marks:**
- Type: Square
- Color: COUNTD(Customer ID)
- Text: COUNTD(Customer ID)

**Axes:**
- Columns: Order Frequency Bucket
- Rows: Days Since Last Order (bins of 30)

**Color Scale:**
- Low (0-2 customers): White → Light Red
- Medium (3-5): Orange
- High (6+ customers): Dark Red (#C0392B)

**Sorting:**
- Rows: Descending (330+ days at top)
- Columns: Ascending (0 orders at left)

**Special Handling:**
- NULL bin (never ordered): Green (#27AE60)

**Tooltip:**
```
Days Inactive: <Days Since Last Order (bins)>
Order Frequency: <Order Frequency Bucket>
Customer Count: <COUNTD(Customer ID)>
Risk Status: <Churn Risk Status>
```

---

#### 4. Top Customers Table

**Data Source:** customer_ltv.csv

**Dimensions:**
- Height: 436px
- Width: Full width

**Columns:**
- Customer Name
- Lifetime Value
- Total Orders
- Days Since Last Order

**Filters:**
- Top 15 by Lifetime Value

**Sorting:**
- Descending by Lifetime Value

**Formatting:**
- Lifetime Value: Currency ($0,0)
- Days Since Last Order: Color-coded
  - 0-90 days: Green
  - 91-180 days: Yellow
  - 181+ days: Red

**Conditional Formatting:**
- Row color: Alternating gray (#F8F9FA / White)
- Header: Bold, gray background

---

## Color Palette Reference

### Primary Colors
- Blue: #2E5F8A (primary brand)
- Teal: #2E8B91 (secondary)
- Light Blue: #4A7BA7 (accents)

### Tier Colors
- Platinum: #8E44AD (purple)
- Gold: #E67E22 (orange)
- Silver: #5DADE2 (light blue)
- Bronze: #95A5A6 (gray)

### Risk Colors
- Safe/Active: #27AE60 (green)
- Warning/At Risk: #F39C12 (yellow)
- Danger/High Risk: #C0392B (red)

### Neutrals
- Background: #FFFFFF (white)
- Text: #2C3E50 (dark gray)
- Secondary Text: #7F8C8D (medium gray)
- Borders: #ECF0F1 (light gray)

---

## Dashboard Actions

### Highlight Actions

**Action Name:** Highlight Customer Tier  
**Source:** Customer Tier (donut chart)  
**Target:** All sheets on Dashboard 2  
**Run On:** Hover  
**Clearing:** On mouse leave

**Action Name:** Highlight Category  
**Source:** Revenue by Category  
**Target:** All sheets on Dashboard 1  
**Run On:** Select  
**Clearing:** On select of different mark

---

## Filters

### Dashboard 1 Filters
- Month (slider): Affects Monthly Revenue Trend only (Not shown in final dashboard)
- Category: Affects category-related sheets

### Dashboard 2 Filters
- Customer Tier (multi-select): Affects all sheets (Not shown in final dashboard)
- Churn Risk Status: Affects scatter and table

**Filter Display:** Right side of dashboard, compact list (Not shown in final dashboard)

---

## Performance Settings

**Data Extract:** Yes (CSV sources converted to .hyper)  
**Aggregate Data:** Yes (pre-aggregated in SQL)  
**Compute Calculations:** Now (no lazy loading)

**Disable for performance:**
- Automatic updates
- Show empty rows/columns
- Include "All" value in filters