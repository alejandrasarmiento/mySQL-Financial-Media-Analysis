# mySQL-Financial-Media-Analysis
SQL project analyzing Q1 202x paid media performance. Includes KPI analysis across channels using MySQL.

# 📊 Financial Services Paid Media — SQL Project
**Alejandra Sarmiento | Q1 202x**

---

## 🗂️ About This Project

This project analyzes **real paid media performance data** from a financial services client across multiple digital channels during Q1 202x (January–March).

The data was imported from a live dashboard export into MySQL and queried to answer key business questions around spend efficiency, channel performance, and conversion KPIs.

---

## 📁 Dataset — `raw_data`

| Column | Description |
|---|---|
| `date` | Report date |
| `channel` | Media channel (Digital Search, Social, Video, etc.) |
| `client_name` | Client / market segment |
| `campaign_name` | Campaign identifier |
| `datasource_name` | Ad platform (Google Ads, Meta, CM360, etc.) |
| `region` | Geographic region (LACA, NA, etc.) |
| `spend` | Media spend in USD |
| `impressions` | Total impressions |
| `clicks` | Total clicks |
| `money_transfers` | Conversions: money transfers completed |
| `registrations` | Conversions: new user registrations |
| `new_customers` | Conversions: new customers acquired |

**Total rows: 12,142**

---

## 🔍 Queries

### Basic — Exploring the Data

| # | Question |
|---|---|
| Q1 | What channels ran in Q1? |
| Q2 | What regions are in the data? |
| Q3 | What datasources (platforms) were used? |
| Q4 | Which campaigns had zero spend? |
| Q5 | What does LACA region data look like? |

### Performance — Channel & Region Analysis

| # | Question |
|---|---|
| Q6 | Total spend, impressions and clicks by channel |
| Q7 | Total KPIs by region |
| Q8 | Which channel drove the most money transfers? |
| Q9 | Which channel drove the most registrations? |
| Q10 | Which channel had the best CTR (Click-Through Rate)? |

### Efficiency — Cost per KPI

| # | Question |
|---|---|
| Q11 | Cost per Money Transfer by channel |
| Q12 | Full dashboard: all KPIs and costs per channel |

---

## 💡 Key Metrics Calculated

| Metric | Formula |
|---|---|
| CTR | `clicks / impressions * 100` |
| CPC | `spend / clicks` |
| Cost per Transfer | `spend / money_transfers` |
| Cost per Registration | `spend / registrations` |
| Cost per New Customer | `spend / new_customers` |

> `NULLIF()` is used to avoid division by zero errors.

---

## 🛠️ Tools Used

- **MySQL 8.4** — database and queries
- **MySQL Workbench** — interface
- **Excel** — data cleaning before import
- **GitHub** — version control

---

## 📌 Skills Demonstrated

- Importing real CSV data into MySQL
- Writing aggregate queries with `GROUP BY`, `SUM()`, `ROUND()`
- Calculating business KPIs with SQL
- Handling division by zero with `NULLIF()`
- Organizing and documenting a SQL project
