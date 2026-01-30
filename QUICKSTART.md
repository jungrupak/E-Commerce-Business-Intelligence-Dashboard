# Quick Start Guide

> **Get up to speed in 5 minutes**

---

## 🎯 What Is This Project?

An end-to-end analytics project that transforms a PostgreSQL e-commerce database into interactive Tableau dashboards, demonstrating:
- Advanced SQL skills
- Data visualization expertise
- Business insight generation

**Result:** 2 professional dashboards identifying critical business issues and opportunities.

---

## 📊 View the Dashboards (2 minutes)

**[→ Click here for live dashboards](https://public.tableau.com/app/profile/lenny.success.humphrey/viz/SQLPortfolioAnalyticsE-CommerceBusinessInsights/CustomerAnalyticsAndSegmentation)**

### What You'll See

**Dashboard 1: Revenue Overview**
- Total revenue: $39,385
- **KEY INSIGHT:** 87.8% revenue drop in February
- Revenue by category and top customers

**Dashboard 2: Customer Analytics**
- 34 customers analyzed
- **KEY INSIGHT:** 62% are one-time buyers
- Churn risk and customer segmentation

---

## 🗂️ Explore the Project (3 minutes)

### 1. See the SQL Code
**[→ Browse SQL Queries](01-SQL-Queries/)**

```sql
-- Example: Customer LTV calculation
SELECT 
    customer_id,
    COUNT(order_id) AS total_orders,
    SUM(total_amount) AS lifetime_value,
    MAX(order_date) AS last_order_date
FROM orders
GROUP BY customer_id
ORDER BY lifetime_value DESC;
```

### 2. Review Dashboard Design
**[→ View Dashboard Specifications](02-Tableau-Workbooks/dashboard-specs.md)**

Complete technical specs for reproducing the dashboards.

### 3. Read the Insights
**[→ See Business Insights](03-Dashboards/)**

- Revenue analysis with actionable recommendations
- Customer behavior patterns and retention opportunities
- Risk assessment and mitigation strategies

---

## 🚀 Want to Reproduce This?

### Quick Path (View Only)
1. Open [Tableau Public Link](https://public.tableau.com/app/profile/lenny.success.humphrey/)
2. Download workbook
3. Explore locally

### Full Path (Build from Scratch)
**Time:** 6-8 hours

**Follow:** [`04-Documentation/sql-to-tableau-workflow.md`](04-Documentation/sql-to-tableau-workflow.md)

**Prerequisites:**
- PostgreSQL installed
- Tableau Public installed
- [SQL-Portfolio-105-Problems](https://github.com/LennySHumphrey/SQL-Portfolio-105-Problems) database

---

## 💡 Key Takeaways

### Technical Skills Demonstrated

✅ **SQL Proficiency**
- Window functions (LAG, PERCENT_RANK)
- Complex aggregations and CTEs
- Data transformation and export

✅ **Data Visualization**
- Interactive dashboard design
- Business-focused visualizations
- Professional color schemes and layouts

✅ **Business Analysis**
- Revenue volatility detection
- Customer segmentation
- Churn risk assessment
- Actionable recommendations

### Business Insights

🚨 **Critical Finding #1:** 88.72% revenue volatility  
📊 **Critical Finding #2:** 62% one-time buyers  
⚠️ **Critical Finding #3:** 46% revenue from 2 customers

---

## 📚 Next Steps

### For Portfolio Reviewers
1. **View dashboards** - See the final product
2. **Read insights** - Understand business value
3. **Review SQL** - Assess technical skills

### For Learning
1. **Study methodology** - [`methodology.md`](04-Documentation/methodology.md)
2. **Follow workflow** - [`sql-to-tableau-workflow.md`](04-Documentation/sql-to-tableau-workflow.md)
3. **Reproduce project** - Build it yourself

---

## 🔍 Repository Navigation

```
📦 Repository Root
├── 📊 00-Data-Sources/        → Data files and dictionary
├── 💻 01-SQL-Queries/         → All SQL code
├── 📈 02-Tableau-Workbooks/   → Dashboard specifications
├── 🎨 03-Dashboards/          → Screenshots and insights
├── 📚 04-Documentation/       → Detailed documentation
├── 🎯 05-Resources/           → Additional resources and guides 
├── 📄 README.md              → Full project overview
├── ⚡ QUICKSTART.md          → This file
└── 📜 LICENSE                → MIT License
```

---

## ❓ Common Questions

**Q: Is this real business data?**  
A: No, it's synthetic data from a SQL practice database, but the analysis is realistic.

**Q: Can I use this for my portfolio?**  
A: The methodology and structure, yes. Clone and adapt with your own data.

**Q: How long did this take?**  
A: ~10 hours total (SQL queries, dashboards, documentation).

**Q: What's the most impressive part?**  
A: The end-to-end workflow and business insight generation, not just technical skills.

---

## 👤 Author

**Lenny Success Humphrey**
- Tableau: [View Profile](https://public.tableau.com/app/profile/lenny.success.humphrey/)
- GitHub: [@LennySHumphrey](https://github.com/LennySHumphrey)

---

## 📧 Feedback

Found this helpful? Have questions?
- ⭐ Star this repository
- 📝 Open an issue
- 🔗 Connect on [LinkedIn](https://www.linkedin.com/in/lenny-humphrey-73217b339/)

---

**Ready for the deep dive? Check out the [full README](README.md)**