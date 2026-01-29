# Data Warehouse & Analytics Project

## 🚀 Overview
This project demonstrates an end-to-end data warehousing solution, transforming raw ERP and CRM data into actionable business insights.

---

## 🏗️ Data Architecture
The project follows the **Medallion Architecture**:

* **Bronze Layer:** Raw data ingestion.
* **Silver Layer:** Data cleansing and standardization.
* **Gold Layer:** Business-ready Star Schema.

---

## 📂 Repository Structure


```text
data-warehouse-project/
├── datasets/            # Raw CSV files
├── docs/                # Diagrams and Catalog
├── scripts/             # SQL Transformation Scripts
│   ├── bronze/          # Load raw data
│   ├── silver/          # Data cleansing
│   └── gold/            # Final Star Schema
├── tests/               # Quality scripts
└── requirements.txt     # Dependencies

---

```markdown
---

## 🛠️ Getting Started
1. **Prerequisites**: SQL Server Management Studio (SSMS) or Azure Data Studio.
2. **Installation**: Clone the repository and run the scripts in order: `bronze` -> `silver` -> `gold`.

---

## 👤 About Me
### Hi, I'm Rohan Basnet 👋
I am a **Data Engineering enthusiast** focused on building clean, scalable data architectures. I enjoy transforming raw data into meaningful business stories.

* **🔭 Working on:** SQL Data Warehousing Projects.
* **📫 Connect with me:** [LinkedIn](https://linkedin.com/in/rohan-basnet)

---

## 📊 Documentation & License
* **[Data Catalog](docs/data_catalog.md)** – Metadata and field descriptions.
* **[Naming Conventions](docs/naming-conventions.md)** – Project standards.

⚖️ This project is licensed under the **MIT License**.
