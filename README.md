# 🚀 Global Tech Layoffs Analytics: End-to-End T-SQL Pipeline

## 📝 1. Short Description
An end-to-end data engineering and analytics pipeline built with MS SQL Server (T-SQL) to ingest, clean, and analyze global tech layoff events (2020–2023). The project maps out data profiling, removes structural duplicates, standardizes messy entries, and materializes complex multi-axis analytical queries into BI-ready SQL Views.

---

## 📖 2. Full Description
This portfolio project demonstrates an advanced implementation of relational database development and exploratory data analysis using **Microsoft SQL Server (T-SQL)**. The pipeline ingests raw, unpolished records containing over 2,300 global tech layoff events across 60 countries and 32 industries. 

The pipeline transitions systematically through distinct architectural layers: from safe schema mapping (`TRY_CAST` ingestion) to granular data profiling, followed by a rigorous 7-stage data scrubbing pipeline (deduplication via Window functions, text standardization, and self-join data imputation). Post-cleaning, the dataset is subjected to robust analytical reporting—including rolling time-series trend tracking and segmented peer-group ranking. The final structural layer abstracts these complex analytics into optimized database `Views`, creating a clean, scalable data-access layer ready for immediate integration with business intelligence tools like Power BI or Tableau.

---

## 🔍 3. The Problem
During macroeconomic shifts, global tech layoff data serves as a vital indicator of market health. However, real-world raw datasets are highly fragmented and unreliable. In this project, the initial staging environment revealed severe data anomalies:
* **Redundancy:** Identical scraping/data-entry errors resulted in exact multi-row duplicates.
* **Inconsistent Categorization:** Text entries were corrupted with trailing spaces, and semantic synonyms were duplicated (e.g., `Crypto`, `CryptoCurrency`, and `Crypto Currency` co-existing as separate industries).
* **Missing Structural Dimensions:** Crucial fields like `industry` were left blank (`NULL`) even when previous records for the same company explicitly contained that information.
* **Data Type Corruption:** Dates and numerical values were loaded as raw strings, preventing chronological ordering or statistical mathematical aggregations.

Without building a robust, repeatable programmatic cleaning layer, any visualization or business report derived from this data would produce fundamentally flawed metrics and distorted operational trends.

---

## ⚙️ 4. Process & Methodology (File Breakdown)

The pipeline is engineered modularly across 7 independent script phases to enforce clean execution boundaries and maintainable database code.

### 📁 01_data_ingestion.sql
* **Function & Logic:** Establishes the core target table structure (`dbo.layoffs_clean`) with strict relational data types. It populates the table by selecting from raw staging data using `TRY_CAST` wrappers around all volatile text-to-numeric and text-to-date mappings. This architectural safeguard ensures that malformed data records convert smoothly to `NULL` indicators rather than throwing catastrophic execution exceptions that halt the ingestion process.

### 📁 02_exploratory_data_analysis.sql
* **Function & Logic:** Executes initial structural data profiling and system health checks on the newly ingested data layer. It targets the metadata layer using `INFORMATION_SCHEMA.COLUMNS` to validate precise field configurations. Additionally, it aggregates explicit Boolean checks via `CASE WHEN` clauses to map out the exact density and distribution of missing values (`NULL` counts) across every attribute, identifying critical cleanup frontiers.

### 📁 03_data_cleaning_pipeline.sql
* **Function & Logic:** The execution core of the ETL transformation engine. It carries out a sequential cleansing workflow: removes exact duplicates using a Common Table Expression (CTE) and `ROW_NUMBER() OVER (PARTITION BY...)`, strips trailing/leading whitespaces via `TRIM()`, consolidates fragmented naming variants using logical branching, and executes an optimized **Self-Join** to dynamically impute missing `industry` properties by copying known dimensions from historical company rows.

### 📁 04_eda_volume_analysis.sql
* **Function & Logic:** Handles macroeconomic mass and volume calculations across structural dimensions. It applies robust multi-column group-by aggregations to calculate absolute layoffs (`SUM`) alongside corporate funding metrics (`AVG`). This process effectively isolates the top 10 individual corporate entities driving down-sizing numbers and lists the most heavily impacted industrial sectors globally.

### 📁 05_eda_time_series_analysis.sql
* **Function & Logic:** Conducts advanced chronological pattern evaluation and historical timeline mapping. It breaks down raw timeline events into granular year-and-month intervals to monitor monthly volatility. Inside a tracking CTE, it implements an advanced analytical window function (`SUM() OVER (ORDER BY...)`) to compute a continuous, cumulative monthly **Rolling Total** of layoffs, isolating macro-economic contraction triggers over time.

### 📁 06_eda_segmentation_ranking.sql
* **Function & Logic:** Performs localized market segmentation and corporate peer-group benchmarking. Rather than evaluating companies globally, it utilizes an advanced `DENSE_RANK() OVER(PARTITION BY industry ORDER BY...)` window function inside a filtering CTE. This structure partitions the global tech market by industry sector, ranking and extracting the top 3 laying-off entities strictly within their own specific domain.

### 📁 07_create_analytical_views.sql
* **Function & Logic:** Builds the formal production reporting layer (Data Mart/Access Layer). It encapsulates all advanced EDA logic from scripts 04, 05, and 06 into permanent database `Views` (`dbo.v_*`). By abstracting multi-layered CTEs, joins, and window definitions behind a clean view interface, it provides downstream BI dashboards with instantaneous, high-performance query points without forcing the dashboard to process raw calculations.

---

## 📊 5. Insights & Results
* **The Scale of Impact:** Highly capitalized entities were not immune; the analysis explicitly reveals a direct correlation between massive funding rounds (`funds_raised_millions`) and high-volume layoff actions during contraction cycles.
* **Sector Vulnerability:** Consumer-facing and Retail sectors experienced the most volatile down-sizing spikes, outstripping deep-tech or enterprise-software fields in absolute employee numbers.
* **Temporal Velocity:** The rolling totals clearly illustrate specific inflection months where layoff velocity accelerated exponentially, providing sharp insights into global market correction windows.
* **Intra-Industry Leaders:** The dense ranking isolated dominant market players within niche categories, showing that even smaller sub-sectors suffered from top-heavy layoff concentrations.

---

## 🏆 6. Outcome & Impact
* **Production-Grade Data Integrity:** Transformed a highly volatile, unverified raw file into a mathematically sound, standardized relational database schema completely free of structural duplicates.
* **Decoupled Architecture:** By abstracting all complex windowing calculations, time-series parsing, and self-joins inside optimized **SQL Views**, the operational overhead on visualization engines is reduced to a minimum.
* **BI Dashboard Acceleration:** Downstream BI applications (Power BI/Tableau) can connect directly to the views, allowing for sub-second report rendering, seamless filtering, and zero localized data manipulation.

---

## 👤 Author

**Zaid Shatat**
