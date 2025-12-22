#  📊 Subscription Saas Analytics - SQL-only Project

##  🚀 Project Overview
This project simulates the **analytics layer of a Subscription SaaS product, with a focus on how raw user activity and payment data can be transformed into **business critical product and revenue metrics** using SQL alone.

The goal of this project is to demonstrate:
- Clean **relational data modeling**
- **Analytics-ready SQL** design
- Ability to answer **product, growth and revenue questions**
- Strong use of **CTEs and window functions**, similar to real analytics engineering work

I have used only **SQLite** - no application code or BI tools to mirror real interview and take-home expectations for **Analytics Engineer/Data Engineer** roles.

---


## Data Model 
I have used simplified Subscription SaaS lifecycle dataset.

### Tables
| Table | Description |
|-----|------------|
| `users` | User profile information and signup timestamp |
| `subscriptions` | Subscription plans and lifecycle status |
| `events` | Product interaction events (signup, login, feature usage, purchase) |
| `payments` | Revenue events for paid users |

### Relationships
- One user → many events  
- One user → many payments  
- One user → multiple subscription periods over time  

This schema supports **funnel analysis, retention tracking, and revenue analytics**.

---

## 📈 Business Questions & Metrics

The queries are written to answer realistic stakeholder questions across **Product, Growth, and Revenue** teams.

### 💰 Revenue & Monetization
- Monthly revenue trend (MRR-like)
- Average Revenue Per Paying User (ARPPU)
- Running revenue total over time
- Day-over-day revenue change

### 🚀 Growth & Conversion
- Signup → purchase conversion rate
- Time to first purchase per user
- Active subscriptions by plan
- Paid vs free user behavior

### 📊 Engagement & Retention
- Daily Active Users (DAU) based on login & feature usage
- 7-day retention proxy (users active ≥7 days after signup)
- Power users ranking based on feature usage frequency

---

## 🧠 Query Design Highlights

This project intentionally showcases SQL patterns used in production analytics systems.

### Common Table Expressions (CTEs)
CTEs are used to:
- Break down complex logic into readable steps
- Isolate intermediate datasets (e.g. first purchase, signup cohorts)
- Improve maintainability and clarity of analytics queries

### Window Functions
- `RANK()` → identify power users
- `SUM() OVER (ORDER BY …)` → running revenue totals
- `LAG()` → day-over-day revenue comparison

### Time-Based Analysis
- `julianday()` is used to compute:
  - Time to first purchase
  - Retention timing
- Date truncation is handled via string slicing to stay SQLite-compatible

---

## 🗂️ Repository Structure

```text
saas-subscription-sql/
├── schema.sql     # Table definitions and constraints
├── seed.sql       # Realistic sample data
├── queries.sql    # KPI, funnel, retention & revenue queries
├── saas.db        # Local SQLite database (generated)
└── README.md
▶️ How to Run Locally
No external dependencies required.

bash
Copy code
sqlite3 saas.db < schema.sql
sqlite3 saas.db < seed.sql
sqlite3 saas.db < queries.sql

🧪 Assumptions & Simplifications
- Revenue is recorded only via the payments table
- Refunds are not modeled for simplicity
- Retention is approximated using feature usage after signup
- SQLite is used for portability; queries can be easily adapted to Postgres or Snowflake











