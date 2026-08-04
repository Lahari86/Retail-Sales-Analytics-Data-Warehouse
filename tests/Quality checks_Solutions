/*
---------------------------------------------------------------------------------------------------------------------------------------------
This script contains 
- All the data quality checks for data accuracy, consistency, standarization throughout the Silver layer. The following checks are included,
    - Unwanted spaces in the string fields.
    - Null or duplicate primary keys.
    - Invalid date ranges and orders.
    - Data consistency between related fields of different tables.
- Transformation performed on the data.
- Insert queries for the Silver table.
-----------------------------------------------------------------------------------------------------------------------------------------------
*/



/*
==================================================
crm_cust_info table
==================================================
*/

-- QUALITY CHECK1 BRONZE -  Check for NULL values or Duplicates in primary key.

SELECT cst_id, 
COUNT(*) AS Duplicated_count
FROM bronze_crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;


/*
SELECT *,
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
FROM bronze_crm_cust_info
WHERE cst_id = 29449;
*/


-- Eliminates duplicates and NULL values in primary key
SELECT *
FROM (
SELECT *,
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
FROM bronze_crm_cust_info
)t WHERE flag_last = 1 AND cst_id IS NOT NULL-- AND cst_id = 29449;



-- QUALITY CHECK 2 BRONZE - Check for unwanted spaces in string values
-- If the original value is not same as the value after trimming, then there is space.
SELECT cst_firstname
FROM bronze_crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)  


-- Removes unwanted space
SELECT 
cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
cst_marital_status,
cst_gndr,
cst_create_date,
flag_last
FROM
(
	SELECT *,
	ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
	FROM bronze_crm_cust_info
)t WHERE flag_last = 1 AND cst_id IS NOT NULL;




SELECT DISTINCT cst_gndr
FROM bronze_crm_cust_info;

-- Data Standardization and Consistency

SELECT 
cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
CASE WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
	 WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
	 ELSE 'n/a'
END cst_marital_status,

CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
	 WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
	 ELSE 'n/a'
END cst_gndr,
cst_create_date
FROM
(
	SELECT *,
	ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
	FROM bronze_crm_cust_info
)t WHERE flag_last = 1 AND cst_id IS NOT NULL;



--Insert data into the table
PRINT('>>Truncating Table : silver_crm_cust_info');
TRUNCATE TABLE silver_crm_cust_info;
PRINT('>>Inserting Data Into : silver_crm_cust_info');

INSERT INTO silver_crm_cust_info (
cst_id,
cst_key,
cst_firstname,
cst_lastname,
cst_marital_status,
cst_gndr,
cst_create_date
)
SELECT 
cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
CASE WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
	 WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
	 ELSE 'n/a'
END cst_marital_status,

CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
	 WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
	 ELSE 'n/a'
END cst_gndr,
cst_create_date
FROM
(
	SELECT *,
	ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
	FROM bronze_crm_cust_info
)t WHERE flag_last = 1 AND cst_id IS NOT NULL;


SELECT * FROM silver_crm_cust_info;


-- QUALITY CHECK1 SILVER -  Check for NULL values or Duplicates in primary key.

SELECT cst_id, 
COUNT(*) AS Duplicated_count
FROM silver_crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;


-- QUALITY CHECK 2 SILVER - Check for unwanted spaces in string values
-- If the original value is not same as the value after trimming, then there is space.
SELECT cst_firstname
FROM silver_crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)  


-- Data Standardization and Consistency Check
SELECT DISTINCT cst_gndr
FROM silver_crm_cust_info;






/*
==================================================
crm_prd_info table
==================================================
*/

-- QUALITY CHECK1 BRONZE -  Check for NULL values or Duplicates in primary key.
SELECT prd_id, 
COUNT(*) AS Duplicated_count
FROM bronze_crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

SELECT * FROM bronze_crm_prd_info;



-- SUBSTRING prd_key
SELECT 
prd_id,
prd_key,
REPLACE(SUBSTRING(prd_key,1,5), '-', '_') AS cat_id,
SUBSTRING(prd_key, 7, len(prd_key)) AS sl_prd_key, -- equal to sls_prd_key from silver_crm_sales_details table
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt
FROM bronze_crm_prd_info

/*
WHERE REPLACE(SUBSTRING(prd_key,1,5), '-', '_') NOT IN 
(SELECT DISTINCT id FROM bronze_erp_PX_CAT_G1V2); -- Has underscore
*/

/*
WHERE SUBSTRING(prd_key, 7, len(prd_key)) NOT IN (
SELECT sls_prd_key FROM bronze_crm_sales_details);     -- Products that donot have any orders
*/




-- QUALITY CHECK 2 BRONZE - Check for unwanted spaces in string values
-- If the original value is not same as the value after trimming, then there is space.
SELECT prd_nm
FROM bronze_crm_prd_info
WHERE prd_nm != TRIM(prd_nm)  


-- QUALITY CHECK 3 BRONZE - Check for negative or NULL values
SELECT prd_cost
FROM bronze_crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;


-- Eliminate NULL values from prd_cost, standardizing prd_line
SELECT 
prd_id,
prd_key,
REPLACE(SUBSTRING(prd_key,1,5), '-', '_') AS cat_id,
SUBSTRING(prd_key, 7, len(prd_key)) AS sl_prd_key, -- equal to sls_prd_key from silver_crm_sales_details table
prd_nm,
ISNULL(prd_cost,0) AS prd_cost,
CASE UPPER(TRIM(prd_line)) 
	 WHEN 'M' THEN 'Mountain'
	 WHEN 'R' THEN 'Road'
	 WHEN 'S' THEN 'Other Sales'
	 WHEN 'T' THEN 'Touring'
	 ELSE 'n/a'
END AS prd_line,
prd_start_dt,
prd_end_dt
FROM bronze_crm_prd_info


-- Check if end date is greater then start date / Invalid Date Order
SELECT *
FROM bronze_crm_prd_info
WHERE prd_end_dt < prd_start_dt


-- Replace end date with start date - 1 for a product having multiple orders, and last record of end date should be NULL.
SELECT 
prd_id,
prd_key,
REPLACE(SUBSTRING(prd_key,1,5), '-', '_') AS cat_id,
SUBSTRING(prd_key, 7, len(prd_key)) AS sl_prd_key, -- equal to sls_prd_key from silver_crm_sales_details table
prd_nm,
ISNULL(prd_cost,0) AS prd_cost,
CASE UPPER(TRIM(prd_line)) 
	 WHEN 'M' THEN 'Mountain'
	 WHEN 'R' THEN 'Road'
	 WHEN 'S' THEN 'Other Sales'
	 WHEN 'T' THEN 'Touring'
	 ELSE 'n/a'
END AS prd_line,
CAST(prd_start_dt AS DATE) AS prd_start_dt,
CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - 1  AS DATE) AS prd_end_dt
FROM bronze_crm_prd_info



-- INSERT INTO 
PRINT('>>Truncating Table : silver_crm_prd_info');
TRUNCATE TABLE silver_crm_prd_info;
PRINT('>>Inserting Data Into : silver_crm_prd_info');
INSERT INTO silver_crm_prd_info(
prd_id,
cat_id,
prd_key,
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt
)
SELECT 
prd_id,
REPLACE(SUBSTRING(prd_key,1,5), '-', '_') AS cat_id,
SUBSTRING(prd_key, 7, len(prd_key)) AS prd_key, -- equal to sls_prd_key from silver_crm_sales_details table
prd_nm,
ISNULL(prd_cost,0) AS prd_cost,
CASE UPPER(TRIM(prd_line)) 
	 WHEN 'M' THEN 'Mountain'
	 WHEN 'R' THEN 'Road'
	 WHEN 'S' THEN 'Other Sales'
	 WHEN 'T' THEN 'Touring'
	 ELSE 'n/a'
END AS prd_line,
CAST(prd_start_dt AS DATE) AS prd_start_dt,
CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - 1  AS DATE) AS prd_end_dt
FROM bronze_crm_prd_info

SELECT * FROM silver_crm_prd_info;

-- QUALITY CHECK 1 SILVER -  Check for NULL values or Duplicates in primary key.
SELECT prd_id, 
COUNT(*) AS Duplicated_count
FROM silver_crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;


-- QUALITY CHECK 2 SILVER - Check for unwanted spaces in string values
-- If the original value is not same as the value after trimming, then there is space.
SELECT prd_nm
FROM silver_crm_prd_info
WHERE prd_nm != TRIM(prd_nm)  


-- QUALITY CHECK 3 SILVER - Check for negative or NULL values
SELECT prd_cost
FROM silver_crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- SILVER - Check if end date is greater then start date / Invalid Date Order
SELECT *
FROM silver_crm_prd_info
WHERE prd_end_dt < prd_start_dt




/*
==================================================
crm_sales_details table
==================================================
*/


SELECT
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price
FROM bronze_crm_sales_details;


-- QUALITY CHECK 1 : Dates <= 0 and check if the length of sls_order_dt is not equal to 8
SELECT 
sls_order_dt
FROM bronze_crm_sales_details
WHERE sls_order_dt <= 0 OR LEN(sls_order_dt) != 8;
-- Repeat the same for other date fields in the table 


-- Quality Check 2 : Order date < Shipping date AND Due date
SELECT 
*
FROM bronze_crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt;


-- Quality Check 3 : Sales = Quantity * price ; All the 3 fileds should be positive; Get suggestions from source system experts if this check fails.
SELECT 
sls_sales,
sls_quantity,
sls_price
FROM bronze_crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
ORDER BY sls_sales, sls_quantity, sls_price;


-- Modifying dates = 0 values to NULL and converting date field type from number to date; 
-- If sales is negative, zero, or null, derive it from quantity and price ; 
-- If price is zero or null, calculate it using sales and quantity; 
-- If price is negative, convert it to a positive value.
-- Insert all the data into silver_crm_sales_details table

PRINT('>>Truncating Table : silver_crm_sales_details');
TRUNCATE TABLE silver_crm_sales_details;
PRINT('>>Inserting Data Into : silver_crm_sales_details');
INSERT INTO silver_crm_sales_details(
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price
)
SELECT
sls_ord_num,
sls_prd_key,
sls_cust_id,
CASE WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
	 ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
END AS sls_order_dt,
CASE WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
	 ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
END AS sls_ship_dt,

CASE WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
	 ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
END AS sls_due_dt,

CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price) THEN sls_quantity * ABS(sls_price)
ELSE sls_sales
END AS sls_sales,

sls_quantity,

CASE WHEN sls_price IS NULL OR sls_price <= 0 THEN sls_sales / NULLIF(sls_quantity,0)
ELSE sls_price
END AS sls_price
FROM bronze_crm_sales_details;




-- QUALITY CHECK 2 SILVER table : Order date < Shipping date AND Due date
SELECT 
*
FROM silver_crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt;


-- QUALITY CHECK 3 SILVER table : Sales = Quantity * price ; All the 3 fileds should be positive; Get suggestions from source system experts if this check fails.
SELECT 
sls_sales,
sls_quantity,
sls_price
FROM silver_crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
ORDER BY sls_sales, sls_quantity, sls_price;




/*
==================================================
erp_CUST_AZ12 table
==================================================
*/

-- Check for bdates between a range(Very old date and current date)
SELECT DISTINCT
bdate
FROM bronze_erp_CUST_AZ12
WHERE bdate < '1924-01-01' OR bdate > GETDATE()

-- Check all the values for gen
SELECT DISTINCT
gen
FROM bronze_erp_CUST_AZ12

-- Modifying the invalid dates to current date; Removing the first 3 characters from cid to relate it to cst_key of silver_crm_cust_info table.
-- INSERT the data
PRINT('>>Truncating Table : silver_erp_CUST_AZ12');
TRUNCATE TABLE silver_erp_CUST_AZ12;
PRINT('>>Inserting Data Into : silver_erp_CUST_AZ12');
INSERT INTO silver_erp_CUST_AZ12(
cid,
bdate,
gen
)
SELECT 
CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4, LEN(cid))
	 ELSE cid
END AS cid,

CASE WHEN bdate > GETDATE() THEN NULL
	 ELSE bdate
END AS bdate,

CASE WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
	 WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
	 ELSE 'n/a'
END AS gen
FROM bronze_erp_CUST_AZ12;
--WHERE CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
--		ELSE cid 
--END NOT IN (SELECT DISTINCT cst_key FROM silver_crm_cust_info);


SELECT * FROM silver_erp_CUST_AZ12;




/*
==================================================
erp_LOC_A101 table
==================================================
*/

SELECT DISTINCT
cntry 
FROM bronze_erp_LOC_A101;


-- Replacing - character with nothing from cid field of bronze_erp_LOC_A101 table, to match cst_key field from silver_crm_cust_info table.
-- Cleaning cntry data values accordingly
-- Insert data into the table
PRINT('>>Truncating Table : silver_erp_LOC_A101');
TRUNCATE TABLE silver_erp_LOC_A101;
PRINT('>>Inserting Data Into : silver_erp_LOC_A101');
INSERT INTO silver_erp_LOC_A101(
cid,
cntry
)
SELECT 
REPLACE(cid, '-','') cid,
CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
	 WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
	 WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
	 ELSE TRIM(cntry)
END AS cntry
FROM bronze_erp_LOC_A101;
-- WHERE REPLACE(cid, '-','') NOT IN (SELECT cst_key FROM silver_crm_cust_info);


SELECT * FROM silver_erp_LOC_A101;





/*
==================================================
erp_px_CAT_G1V2 table
==================================================
*/

-- Check for unwanted spaces
SELECT * FROM bronze_erp_PX_CAT_G1V2
WHERE CAT != TRIM(CAT) OR SUBCAT != TRIM(SUBCAT) OR MAINTENANCE != TRIM(MAINTENANCE);

-- Check for data standardization and consistency
SELECT DISTINCT
CAT
FROM bronze_erp_PX_CAT_G1V2;

SELECT DISTINCT
SUBCAT
FROM bronze_erp_PX_CAT_G1V2;

SELECT DISTINCT
MAINTENANCE
FROM bronze_erp_PX_CAT_G1V2;

-- Data is perfect!!  Doesnot need any transformations
-- INSERT into silver_erp_PX_CAT_G1V2 table
PRINT('>>Truncating Table : silver_erp_PX_CAT_G1V2');
TRUNCATE TABLE silver_erp_PX_CAT_G1V2;
PRINT('>>Inserting Data Into : silver_erp_PX_CAT_G1V2');
INSERT INTO silver_erp_PX_CAT_G1V2
(
ID,
CAT,
SUBCAT,
MAINTENANCE
)
SELECT 
ID,
CAT,
SUBCAT,
MAINTENANCE
FROM bronze_erp_PX_CAT_G1V2


SELECT * FROM silver_erp_PX_CAT_G1V2;
