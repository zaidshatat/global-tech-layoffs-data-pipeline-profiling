# 📊 Global Tech Layoffs: End-to-End SQL Data Ingestion & Cleaning Pipeline

## 📋 Project Overview
This project engineering a production-ready data pipeline using **MS SQL Server** to ingest, profile, clean, and standardize a messy, un-structured global tech layoffs dataset. The pipeline systematically handles data type conversion defense, eliminates redundant cross-row duplication, resolves formatting anomalies, and utilizes advanced database concepts like Self-Joins and Window Functions to construct an enterprise-grade data asset.

## 🛠️ Tech Stack & SQL Architecture
* **Database Engine:** Microsoft SQL Server (MS SQL Server)
* **SQL Dialect:** T-SQL (Transact-SQL)
* **Advanced Mechanisms Used:** * Window Functions (`ROW_NUMBER()` with `PARTITION BY`)
  * Defensive Type Casting (`TRY_CAST`, `TRY_CONVERT`)
  * Common Table Expressions (CTEs)
  * Relational Self-Joins for Data Imputation
  * Schema Modifications (`ALTER TABLE`)

---

## 🏗️ Pipeline Structure & Logic

The repository is modularly structured into 3 core SQL stages representing a real-world data lifecycle:

### 1️⃣ Data Ingestion & Schema Defense (`01_data_ingestion.sql`)
* **The Goal:** Build a resilient table structure to handle incoming data safely.
* **The Logic:** Enforced a targeted data type schema to block raw corrupted text entries. Implemented defensive type casting using `TRY_CAST` for numeric metrics (`total_laid_off`, `funds_raised_millions`) and date records. This guarantees that any corrupt string values are gracefully converted into `NULL` instead of crashing the database during mass ingestion.

### 2️⃣ Exploratory Data Analysis & Profiling (`02_exploratory_data_analysis.sql`)
* **The Goal:** Inspect data completeness, null density, and categorical volatility.
* **The Logic:** * Audited column constraints through system schemas (`INFORMATION_SCHEMA.COLUMNS`).
  * Calculated exact missing value volumes using multi-column conditional aggregation: `SUM(CASE WHEN Column IS NULL THEN 1 ELSE 0 END)`.
  * Merged multi-column descriptive statistics (Count, Missing, Mean, Min, Max) into a single optimized view using `UNION ALL`.

### 3️⃣ Advanced Data Cleaning & Imputation (`03_data_cleaning_pipeline.sql`)
* **The Goal:** Eliminate structural errors, purge duplicates, and fix anomalies.
* **The Logic:**
  * **Deduplication:** Isolated and permanently deleted redundant records matching across all 9 dimensions by building a `duplicateCTE` powered by `ROW_NUMBER() OVER(PARTITION BY...)`.
  * **Text Standardization:** Applied `TRIM` functions to clear whitespace contamination from company names and locations.
  * **Categorical Normalization:** Consolidated structural deviations (e.g., merging `Crypto%` variations, shifting `Fin-Tech` into standard `Finance`, and handling literal `'NULL'` strings).
  * **Geographical Corrections:** Restructured country string names containing trailing syntax dots (e.g., `United States.`) using dynamic string slicing: `TRIM(LEFT(country, LEN(country) - 1))`.
  * **Data Imputation via Self-Join:** Written a relational `Self-Join` query that automatically maps companies with blank industries (`industry IS NULL`) to matching entries of the same company that contain valid industry data, maximizing data completeness without manual input.
  * **Structural Pruning:** Purged dead records where both essential financial indicators (`total_laid_off` and `percentage_laid_off`) were concurrently missing.

---

## 📂 Repository Directory
```text
SQL-Data-Cleaning-Project/
├── data/
│   └── layoffs.csv                             # Raw unstructured dataset
└── scripts/
    ├── 01_data_ingestion.sql                   # Ingestion & type casting defense
    ├── 02_exploratory_data_analysis.sql        # Data profiling & null metrics
    └── 03_data_cleaning_pipeline.sql           # Heavy transformation & cleaning logic
