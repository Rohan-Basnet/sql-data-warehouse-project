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
```text
data-warehouse-project/
├── datasets/            # Raw ERP and CRM CSV files
├── docs/                # Architecture diagrams and Data Catalog
├── scripts/             # SQL Transformation Scripts
│   ├── bronze/          # Load raw data
│   ├── silver/          # Data cleansing
│   └── gold/            # Final Star Schema
├── tests/               # Data quality scripts
└── requirements.txt     # Dependencies <br>
🛠️ Getting Started
1. Prerequisites
SQL Server Management Studio (SSMS) or Azure Data Studio.

Basic understanding of SQL and Data Warehousing concepts.

2. Installation & Setup
Step A: Clone the Repository
Open your terminal or command prompt and run:

Bash
git clone [https://github.com/your-username/data-warehouse-project.git](https://github.com/your-username/data-warehouse-project.git)
Step B: Initialize Database
Execute the SQL scripts located in scripts/bronze/ to establish the initial tables.

Step C: Ingest Data
Import the raw CSV files from the /datasets folder into your SQL Server instance using the Import Flat File wizard or a BULK INSERT command.

Step D: Transform & Model

Run the silver layer scripts to clean and standardize the data.

Run the gold layer scripts to create the final analytical Star Schema.

📊 Documentation Links
Data Catalog – Detailed metadata and field descriptions.

Naming Conventions – Standards used for tables and columns.

⚖️ License
This project is licensed under the MIT License.
