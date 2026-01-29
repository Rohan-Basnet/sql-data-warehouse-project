Markdown
# 📊 End-to-End Data Warehouse & Analytics Project

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


## 🛠️ Tech Stack
* **Engine**: Microsoft SQL Server

* **Interface**: SSMS / Azure Data Studio

* **Language**: T-SQL

* **Design**: Dimensional Modeling

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

* **🔭 Working on**: Advanced SQL Data Warehousing & ETL Automation.

--

## 📫 Connect with me: LinkedIn

## ⚖️ This project is licensed under the MIT License.
