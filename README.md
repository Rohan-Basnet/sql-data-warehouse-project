# Data Warehouse & Analytics Project

---

## 🚀 Overview
This project demonstrates an end-to-end data warehousing solution, transforming raw ERP and CRM data into actionable business insights. It showcases industry-standard practices in **Data Engineering**, **ETL Pipeline Development**, and **Analytical Modeling**.

---

## 🏗️ Data Architecture
The project follows the **Medallion Architecture**, ensuring a structured flow of data through three distinct stages:



* **Bronze Layer (Raw):** Ingests raw CSV files from source systems into SQL Server without modifications.
* **Silver Layer (Cleaned):** Standardizes data types, handles nulls, and removes duplicates.
* **Gold Layer (Analytical):** Houses business-ready data modeled into a **Star Schema** optimized for BI tools.

---

## 📖 Key Features & Objectives
* **ETL Pipelines:** Automated scripts for seamless data movement.
* **Data Modeling:** Implementation of a Star Schema (Fact & Dimension tables).
* **Data Quality:** Automated cleaning and reconciliation across sources.
* **Business Intelligence:** SQL-based analytics focusing on Customer Behavior, Product Performance, and Sales Trends.

---

## 📂 Repository Structure
```text
data-warehouse-project/
├── datasets/            # Raw ERP and CRM CSV files
├── docs/                # Architecture diagrams and Data Catalog
├── scripts/             # SQL Transformation Scripts
│   ├── bronze/          # Load raw data
│   ├── silver/          # Data cleansing
│   └── gold/            # Final Star Schema
├── tests/               # Data quality scripts
└── requirements.txt     # Dependencies
