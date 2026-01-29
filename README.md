# 📊 Data Warehouse Project

## 🚀 Project Overview
This project demonstrates a professional end-to-end data warehousing solution. It focuses on the integration of fragmented data from **ERP** and **CRM** systems, transforming raw CSV files into a centralized, business-ready **Star Schema** to drive actionable insights.

---

## 🏗️ Data Architecture
The project follows the **Medallion Architecture**, providing a clear separation of concerns:

| Layer | Status | Purpose |
| :--- | :--- | :--- |
| **🟫 Bronze** | Raw | Ingests data "as-is" from CSV sources into the `bronze` schema. |
| **🥈 Silver** | Cleansed | Handles data type casting, trims whitespace, and removes duplicates. |
| **🥇 Gold** | Curated | Final Star Schema (Facts & Dimensions) optimized for Power BI/Tableau. |

---

## 🎯 Project Requirements & Specifications

### **1. Objective**
Consolidate sales and customer data from disparate systems into a single "Source of Truth" using **SQL Server**.

### **2. Technical Scope**
* **Data Sources:** CSV exports from ERP (Sales, Products) and CRM (Customers).
* **Transformation:** Standardization of date formats, handling NULL values, and mapping related keys.
* **Modeling:** Implementation of a **Star Schema** (Fact & Dimension tables).
* **Historical Scope:** Focuses on the current snapshot; no SCD Type 2 tracking is applied.

---
---

## 📂 Repository Structure
This tree outlines the organization of the SQL scripts and documentation within this project.

```text
data-warehouse-project/
│
├── datasets/                           # Raw datasets used for the project (ERP and CRM data)
│
├── docs/                               # Project documentation and architecture details                   
│   ├── data_architecture.drawio        # Draw.io file shows the project's architecture
│   ├── data_catalog.md                 # Catalog of datasets, including field descriptions and metadata
│   ├── data_flow.drawio                # Draw.io file for the data flow diagram
│   ├── data_models.drawio              # Draw.io file for data models (star schema)
│   ├── naming-conventions.md           # Consistent naming guidelines for tables, columns, and files
│
├── scripts/                            # SQL scripts for ETL and transformations
│   ├── bronze/                         # Scripts for extracting and loading raw data
│   ├── silver/                         # Scripts for cleaning and transforming data
│   ├── gold/                           # Scripts for creating analytical models
│
├── tests/                              # Test scripts and quality files
│
├── LICENSE                             # License information for the repository
├── .gitignore                          # Files and directories to be ignored by Git
└── README.md                           # Project overview and instructions
```
## 🛠️ Tech Stack
* **Engine:** Microsoft SQL Server

* **Interface:** SSMS / Azure Data Studio

* **Language:** T-SQL

* **Design:** Dimensional Modeling

---

## 🚀 Getting Started
* **1. Prerequisites**
SQL Server 2019 or later.

SQL Server Management Studio (SSMS).

* **2. Deployment**
Execute the scripts in the following order:

* **01_bronze_layer.sql**: Run this to create the database and load raw data.

* **02_silver_layer.sql**: Run this to cleanse and standardize the raw data.

* **03_gold_layer.sql**: Run this to build the final analytical layer.

---

## 📊 Key Transformations Applied
* **Data Cleaning**: Used TRIM(), ISNULL(), and CASE statements to handle missing or messy data.

* **Format Standardization**: Converted varied date strings into standard DATE types.

* **Relationship Mapping**: Created Surrogate Keys to link ERP and CRM data efficiently.

---

## 👤 About Me
Hi, I'm Rohan Basnet 👋
I am a Data Engineering enthusiast focused on building clean, scalable data architectures. I enjoy the challenge of turning raw, messy data into meaningful business stories.


## 📫 Connect with me: [![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/rohan-basnet-74b95b305/)

⚖️ This project is licensed under the MIT License.
