# E-Commerce Analytics: SQL to Tableau Portfolio Project

> **End-to-end business intelligence project demonstrating SQL proficiency, data visualization, and business insight generation.**

[![Tableau Public](https://img.shields.io/badge/Tableau-Public-E97627?logo=tableau)](https://public.tableau.com/app/profile/lenny.success.humphrey/viz/SQLPortfolioAnalyticsE-CommerceBusinessInsights/CustomerAnalyticsAndSegmentation)
[![SQL Portfolio](https://img.shields.io/badge/SQL-Portfolio-4479A1?logo=postgresql)](https://github.com/LennySHumphrey/SQL-Portfolio-105-Problems)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## 📊 Live Dashboards

**[→ View Interactive Dashboards on Tableau Public](https://public.tableau.com/app/profile/lenny.success.humphrey/viz/SQLPortfolioAnalyticsE-CommerceBusinessInsights/CustomerAnalyticsAndSegmentation)**

---

## 🎯 Project Overview

This project transforms a PostgreSQL e-commerce database into actionable business intelligence dashboards, showcasing:

- **Advanced SQL:** Window functions, aggregations, CTEs, and data transformations
- **Business Analytics:** Revenue analysis, customer segmentation, and churn detection
- **Data Visualization:** Interactive Tableau dashboards with professional design
- **Insight Generation:** Actionable recommendations backed by data

### Key Findings

🚨 **88.72% revenue drop** in February 2025 requires immediate investigation  
⚠️ **62% one-time buyers** indicate severe retention challenge  
⚠️ **46% revenue concentration** in just 2 customers creates business risk  
📈 **Actionable recommendations** for retention, growth, and risk mitigation

---

## 📁 Repository Structure

```
├── 00-Data-Sources/           # Raw and processed CSV data
│   ├── raw/                   # Direct database exports
│   ├── processed/             # Pre-aggregated views for Tableau
│   ├── data-dictionary.md     # Complete data reference
│   └── README.md
├── 01-SQL-Queries/            # All SQL code
│   ├── export-queries.sql     # Database to CSV exports
│   ├── aggregation-queries.sql # Pre-aggregation logic
│   ├── calculated-metrics.sql # Business metric definitions
│   └── README.md
├── 02-Tableau-Workbooks/      # Dashboard specifications
│   ├── dashboard-specs.md     # Technical reproduction guide
│   ├── tableau-calculations.md # Calculated field documentation
│   └── README.md
├── 03-Dashboards/             # Visual documentation & insights
│   ├── 01-Revenue-Overview/   # Revenue dashboard screenshots
│   ├── 02-Customer-Analytics/ # Customer dashboard screenshots
│   └── README.md
├── 04-Documentation/          # Process & methodology
│   ├── sql-to-tableau-workflow.md # Step-by-step guide
│   ├── methodology.md         # Analysis framework
│   ├── business-context.md    # Real-world applications
│   ├── technical-implementation.md # Architecture decisions
│   └── README.md
├── 05-Resources/              # Additional resources
│   ├── tableau-public-profile.md # Optimizing Tableau Socials
│   └── related-projects.md    # Portfolio context
├── README.md                  # This file
├── QUICKSTART.md             # 5-minute quick start guide
├── LICENSE                   # MIT License
└── .gitignore
```

---

## 🚀 Quick Start

**Want to jump right in?** See **[QUICKSTART.md](QUICKSTART.md)** for a 5-minute overview.

### View the Dashboards

1. Visit [Tableau Public Link](https://public.tableau.com/app/profile/lenny.success.humphrey/viz/SQLPortfolioAnalyticsE-CommerceBusinessInsights/CustomerAnalyticsAndSegmentation)
2. Explore interactive visualizations
3. Review insights in [`03-Dashboards/`](03-Dashboards/)

### Explore the Code

1. Browse SQL queries in [`01-SQL-Queries/`](01-SQL-Queries/)
2. Check dashboard specifications in [`02-Tableau-Workbooks/`](02-Tableau-Workbooks/)
3. Read documentation in [`04-Documentation/`](04-Documentation/)

### Reproduce the Project

**Prerequisites:**
- PostgreSQL installed OR VS Code with PostgreSQL extension
- Tableau Public installed
- [SQL-Portfolio-105-Problems](https://github.com/LennySHumphrey/SQL-Portfolio-105-Problems) database loaded

**Steps:**
1. Follow [`04-Documentation/sql-to-tableau-workflow.md`](04-Documentation/sql-to-tableau-workflow.md)
2. Estimated time: 6-8 hours (experienced analyst)

---

## 📈 Dashboards

### Dashboard 1: Revenue Overview

**Business Question:** *How is the business performing financially?*

**Key Features:**
- 📊 KPI cards: Revenue, orders, AOV, customers
- 📉 Monthly revenue trend with MoM growth annotations
- 📂 Revenue breakdown by product category
- 👥 Top 10 customers by lifetime value
- 📆 Customer acquisition trend over time

**Critical Insight:** 88.72% revenue drop from January to February 2025 signals operational crisis

**[→ View Full Dashboard](03-Dashboards/01-Revenue-Overview/)**

---

### Dashboard 2: Customer Analytics

**Business Question:** *Who are our customers and what drives their value?*

**Key Features:**
- 🎯 Customer LTV scatter plot (segmented by tier)
- 🍩 Customer tier distribution (Platinum/Gold/Silver/Bronze)
- 🔥 Churn risk heatmap (by recency and frequency)
- 📋 Top customers table with risk indicators

**Critical Insight:** 62% of customers made only one purchase—severe retention problem

**[→ View Full Dashboard](03-Dashboards/02-Customer-Analytics/)**

---

## 🛠️ Technologies Used

| Category | Tools |
|----------|-------|
| **Database** | PostgreSQL 15 |
| **Query Language** | SQL (Advanced: window functions, CTEs, aggregations) |
| **Visualization** | Tableau Public |
| **Data Format** | CSV (UTF-8) |
| **Version Control** | Git + GitHub |
| **Documentation** | Markdown |

---

## 💡 SQL Problems Solved

This project applies solutions from **[SQL-Portfolio-105-Problems](https://github.com/LennySHumphrey/SQL-Portfolio-105-Problems)**:

### Window Functions
- **Problem I11:** Month-over-month growth with LAG()
- **Problem A32:** Customer lifetime value calculation
- **Problem A17:** Revenue percentile ranking

### Aggregations
- **Problem B9:** Total revenue (SUM)
- **Problem B10:** Average order value
- **Problem B13:** Units sold per product

### Advanced Patterns
- **Problem A6:** Category revenue pivot (CROSSTAB)
- **Problem I3:** Customer segmentation logic
- **Problem B26:** Churn detection (date intervals)
- **Problem B29:** Order frequency analysis

**[→ See Complete SQL Problem Mapping](01-SQL-Queries/README.md)**

---

## 📊 Key Metrics & Insights

### Revenue Metrics

| Metric | Value | Status | Insight |
|--------|-------|--------|---------|
| **Total Revenue** | $39,385 | ⚠️ Below target | 88.72% drop in February requires investigation |
| **Average Order Value** | $1,158 | ✅ High | Suggests B2B or premium positioning |
| **Monthly Volatility** | 87.8% | 🚨 Critical | Revenue base is unstable |
| **Top 3 Customer Concentration** | 48% | 🚨 High Risk | Business vulnerable to customer loss |

### Customer Metrics

| Metric | Value | Status | Insight |
|--------|-------|--------|---------|
| **Total Customers** | 34 | ⚠️ Small base | Limited sample but adequate for analysis |
| **Repeat Purchase Rate** | 38% | ⚠️ Low | 62% are one-time buyers |
| **Churn Risk (180+ days)** | 35% | 🚨 High | 12 customers at high risk |
| **Platinum Customers** | 2 (6%) | 🚨 Very Low | Dangerous revenue concentration |

**[→ View Detailed Insights](03-Dashboards/)**

---

## 🎓 What This Project Demonstrates

### For Data Analyst Roles

✅ **SQL Proficiency**
- Complex queries with window functions
- Data aggregation and transformation
- Performance optimization strategies

✅ **Data Visualization**
- Dashboard design principles
- Interactive visualizations
- Color theory and visual hierarchy

✅ **Business Acumen**
- Insight generation from data
- Actionable recommendations
- Risk identification and quantification

✅ **Communication Skills**
- Technical and business documentation
- Visual storytelling
- Stakeholder-ready deliverables

### For Hiring Managers

This project shows **real-world readiness**:
- End-to-end analytics workflow (database → insights)
- Professional documentation standards
- Reproducible and transparent process
- Business value focus (not just technical skills)

**[→ Read Business Context](04-Documentation/business-context.md)**

---

## 📚 Documentation

Comprehensive documentation covering every aspect of the project:

- **[sql-to-tableau-workflow.md](04-Documentation/sql-to-tableau-workflow.md)** - Step-by-step reproduction guide
- **[methodology.md](04-Documentation/methodology.md)** - Analysis framework and approach
- **[business-context.md](04-Documentation/business-context.md)** - Real-world applications and use cases
- **[technical-implementation.md](04-Documentation/technical-implementation.md)** - Architecture and design decisions

---

## 🔗 Related Projects

- **[SQL-Portfolio-105-Problems](https://github.com/LennySHumphrey/SQL-Portfolio-105-Problems)** - Foundation SQL skills
- **[More Analytics Projects](related-projects.md)** - Other portfolio work

---

## 👤 Author

**Lenny Success Humphrey**

- **Tableau Public:** [View Profile](https://public.tableau.com/app/profile/lenny.success.humphrey/)
- **GitHub:** [@LennySHumphrey](https://github.com/LennySHumphrey)
- **LinkedIn:** [Connect with me](https://www.linkedin.com/in/lenny-humphrey-73217b339/)

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- **Data Source:** Synthetic e-commerce data from SQL-Portfolio-105-Problems
- **Tools:** PostgreSQL, Tableau Public
- **Inspiration:** Real-world business intelligence challenges

---

## 📧 Contact

Questions about this project? Want to discuss analytics?

- **Email:** humphreysuccess4@gmail.com
- **LinkedIn:** [Connect With Me](https://www.linkedin.com/in/lenny-humphrey-73217b339/)
- **Tableau Public:** [Visit My Tableau Public Profile](https://public.tableau.com/app/profile/lenny.success.humphrey/vizzes)

---

**⭐ If you found this project helpful, please give it a star on GitHub!**

---

*Last updated: January 2026*