# Retail-Sales-Analytics-Data-Warehouse
Built a Retail Sales Analytics Data Warehouse using Medallion Architecture, integrating customer, product, sales, and location data through Bronze, Silver, and Gold layers to support scalable analytics and business reporting.

----------------------------------------------------------------------------------
This project implements a Retail Sales Analytics Data Warehouse using the Medallion Architecture (Bronze, Silver, and Gold). It consolidates customer, product, sales, category, and location data from multiple source files into a structured analytical model.

The architecture follows a layered approach to ensure data quality, consistency, and scalability for business intelligence and reporting.

---

##  Architecture

The project is organized into three Medallion layers:

### 🥉 Bronze Layer
- Ingests raw data from source CSV files.
- Stores data in its original format.
- Serves as the historical source of truth.

### 🥈 Silver Layer
- Cleans and validates data.
- Removes duplicates and handles missing values.
- Standardizes column names and data types.
- Joins related datasets where required.

### 🥇 Gold Layer
- Creates business-ready datasets.
- Optimized for reporting and analytics.
- Supports business intelligence dashboards and SQL queries.


--------------------------------------------------------------------------------------
## Datasets

Imported data from two source systems (CRM and ERP) that are provided as CSV files

---------------------------------------------------------------------------------------
## 💡 Technologies Used

- SQL
- Data Warehousing
- ETL
- Medallion Architecture
- Git & GitHub

---------------------------------------------------------------------------------------
## 📄 License

This project is intended for learning and portfolio purposes.
