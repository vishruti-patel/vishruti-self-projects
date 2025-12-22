# 🛡️ Data Quality Mini Framework  
### *Because dashboards deserve better than “hope the data is right”*

---

## 🚀 Project Overview
This project is a **lightweight, developer-friendly data quality framework** designed to act as a protective gate between raw data and downstream analytics, dashboards, and machine learning systems. It allows teams to define **data contracts declaratively**, run automated validation checks, and prevent bad or unexpected data from silently flowing into critical decision workflows.

It supports:
- schema validation  
- null constraints  
- uniqueness checks  
- allowed categorical values  
- numeric ranges  
- datetime parsing  
- data freshness monitoring  

The framework produces both:
- **human-readable CLI summaries**, and  
- a **machine-readable JSON report**  

making it suitable for CI/CD pipelines, Airflow, dbt, and modern data platforms.

> **This project is intentionally minimal but inspired by production-grade tools like Great Expectations and Soda, which are used by modern data teams at tech companies and enterprises to enforce data contracts and prevent bad data from reaching dashboards and ML systems.**

The goal is not to reinvent enterprise tooling, but to demonstrate **data engineering maturity, practical design thinking, and real-world reliability mindset** in a clean, approachable way.

---

## 💡 Why I Built This
Bad data doesn’t just “break pipelines” — it breaks trust.  
Leaders make wrong decisions, ML models learn garbage, dashboards lose credibility, and engineers scramble after the fact.

I built this project to:
- showcase **data engineering thinking beyond ETL**
- demonstrate how **data quality can be proactive**, not reactive
- reflect modern best practices like **data contracts**
- build something **simple, clear, and actually useful**
- and yes — to create a strong, real-world portfolio project 😊

This framework represents what many real teams wish they had before adopting full enterprise tools: a simple, reliable guardrail.

---
