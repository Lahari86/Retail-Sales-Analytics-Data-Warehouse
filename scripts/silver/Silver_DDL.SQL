/*
Create tables in Silver layer, drop existing tables
Updated table creation scripts are also provided for a couple of tables post data transformation

Meta Data Column : dwh_create_date
*/


IF OBJECT_ID ('silver_crm_cust_info', 'U') IS NOT NULL
	DROP TABLE silver_crm_cust_info;
CREATE TABLE silver_crm_cust_info (
cst_id INT,
cst_key NVARCHAR(50),
cst_firstname NVARCHAR(50),
cst_lastname NVARCHAR(50),
cst_marital_status NVARCHAR(50),
cst_gndr NVARCHAR(50),
cst_create_date DATE,
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver_crm_prd_info', 'U') IS NOT NULL
	DROP TABLE silver_crm_prd_info;
CREATE TABLE silver_crm_prd_info(
prd_id INT,
prd_key NVARCHAR(50),
prd_nm NVARCHAR(50),
prd_cost INT,
prd_line NVARCHAR(50),
prd_start_dt DATETIME,
prd_end_dt DATETIME,
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

-- Updated DDL  script for this table
IF OBJECT_ID ('silver_crm_prd_info', 'U') IS NOT NULL
	DROP TABLE silver_crm_prd_info;
CREATE TABLE silver_crm_prd_info(
prd_id INT,
cat_id NVARCHAR(50),
prd_key NVARCHAR(50),
prd_nm NVARCHAR(50),
prd_cost INT,
prd_line NVARCHAR(50),
prd_start_dt DATE,
prd_end_dt DATE,
dwh_create_date DATETIME2 DEFAULT GETDATE()
);


IF OBJECT_ID ('silver_crm_sales_details', 'U') IS NOT NULL
	DROP TABLE silver_crm_sales_details;
CREATE TABLE silver_crm_sales_details(
sls_ord_num NVARCHAR(50),
sls_prd_key NVARCHAR(50),
sls_cust_id INT,
sls_order_dt INT,
sls_ship_dt INT,
sls_due_dt INT,
sls_sales INT,
sls_quantity INT,
sls_price INT,
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

-- Updated DDL script for silver_crm_sales_details and then run above insert into script
IF OBJECT_ID ('silver_crm_sales_details', 'U') IS NOT NULL
	DROP TABLE silver_crm_sales_details;
CREATE TABLE silver_crm_sales_details(
sls_ord_num NVARCHAR(50),
sls_prd_key NVARCHAR(50),
sls_cust_id INT,
sls_order_dt DATE,
sls_ship_dt DATE,
sls_due_dt DATE,
sls_sales INT,
sls_quantity INT,
sls_price INT,
dwh_create_date DATETIME2 DEFAULT GETDATE()
);



IF OBJECT_ID ('silver_erp_CUST_AZ12', 'U') IS NOT NULL
	DROP TABLE silver_erp_CUST_AZ12;
CREATE TABLE silver_erp_CUST_AZ12(
CID nvarchar(50),
BDATE DATE,
GEN NVARCHAR(50),
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver_erp_LOC_A101', 'U') IS NOT NULL
	DROP TABLE silver_LOC_A101;
CREATE TABLE silver_LOC_A101(
CID NVARCHAR(50),
CNTRY NVARCHAR(50),
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver_erp_PX_CAT_G1V2', 'U') IS NOT NULL
	DROP TABLE silver_PX_CAT_G1V2;
CREATE TABLE silver_PX_CAT_G1V2(
ID NVARCHAR(50),
CAT NVARCHAR(50),
SUBCAT NVARCHAR(50),
MAINTENANCE NVARCHAR(50),
dwh_create_date DATETIME2 DEFAULT GETDATE()
);
