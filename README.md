# Data Warehouse & Analytics Project

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
data-warehouse-project/
├── datasets/            # Raw ERP and CRM CSV files (Input Data)
├── docs/                # Architecture diagrams, ERDs, and Data Catalog
│   ├── data_flow.drawio
│   └── data_catalog.md
├── scripts/             # SQL Transformation Scripts (Core Logic)
│   ├── bronze/          # DDL for raw data ingestion
│   ├── silver/          # Cleaning, Deduplication, & Normalization
│   └── gold/            # Final Star Schema (Facts & Dimensions)
├── tests/               # SQL scripts for data validation & quality checks
├── .gitignore           # Files to exclude from Git (e.g., local logs)
├── LICENSE              # Legal usage rights (MIT)
└── requirements.txt     # Environment dependencies

📊 Documentation Links
Data Catalog – Detailed metadata and field descriptions.

Naming Conventions – Standards used for tables and columns.

⚖️ License
This project is licensed under the MIT License.
