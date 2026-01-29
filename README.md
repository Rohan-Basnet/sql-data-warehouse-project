# 📊 End-to-End Data Warehouse & Analytics Project

## 🚀 Project Overview
This project demonstrates a professional end-to-end data warehousing solution. It focuses on the integration of fragmented data from **ERP** and **CRM** systems, transforming raw CSV files into a centralized, business-ready **Star Schema** to drive actionable insights.

---

## 🏗️ Data Architecture
The project implements a **Medallion Architecture**, ensuring a structured flow and high data quality:

* **🟫 Bronze (Raw):** Landing zone for raw ingestion from ERP and CRM CSV files.
* **🥈 Silver (Cleansed):** Data standardization, deduplication, and cleansing.
* **🥇 Gold (Analytical):** Final dimensional model (Fact & Dimension tables) optimized for BI tools.

---

## 🎯 Project Requirements

### **Objective**
Develop a modern data warehouse using **SQL Server** to consolidate sales and customer data, enabling data-driven decision-making.

### **Specifications**
* **Data Sources:** CSV-based data from ERP (Sales/Products) and CRM (Customer info).
* **Data Quality:** Implementation of cleaning logic to resolve structural and formatting inconsistencies.
* **Integration:** Unified data model designed for complex analytical queries.
* **Scope:** Focus on the latest data state (Historization/SCD not required for this iteration).
* **Documentation:** Comprehensive metadata and data lineage tracking.

---

## 🛠️ Tech Stack & Tools
* **Database:** Microsoft SQL Server
* **Client Interface:** SQL Server Management Studio (SSMS) or Azure Data Studio
* **Language:** T-SQL (Transact-SQL)
* **Data Modeling:** Dimensional Modeling (Star Schema)

---

## 🚀 Getting Started

### 1. Prerequisites
Ensure you have **SQL Server** and **SSMS** installed on your local machine.

### 2. Installation & Setup
Clone the repository and execute the SQL scripts in the following order:

1.  **`bronze_layer.sql`**: Creates the environment and loads raw data.
2.  **`silver_layer.sql`**: Performs data transformation and quality checks.
3.  **`gold_layer.sql`**: Finalizes the Star Schema for reporting.

```bash
git clone [https://github.com/rohan-basnet/your-repo-name.git](https://github.com/rohan-basnet/your-repo-name.git)
