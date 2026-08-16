/*
======================================================================================================
DDL Script : Create Gold Views
======================================================================================================
Script Purpose : This script creates views for gold layer in the data warehouse (final dimension and fact tables (Start Schema))

Usage : These views can be queried directly for analytics and reporting.
======================================================================================================
*/


/*
--------------------------------------------------------------------------------------------------
Create Dimension for Customers : gold_dim_customers
--------------------------------------------------------------------------------------------------
*/

CREATE VIEW gold_dim_customers AS

SELECT
ROW_NUMBER() OVER (ORDER BY cst_id) AS Sno,
ci.cst_id AS customer_id,
ci.cst_key AS customer_key,
ci.cst_firstname AS First_Name,
ci.cst_lastname AS Last_Name,
CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr   --Because CRM is the Master Table here
	 ELSE COALESCE(caz.gen,'n/a')
END AS gender,

la1.CNTRY AS Country,
ci.cst_marital_status AS Marital_Status,
caz.BDATE AS Birth_Date,
ci.cst_create_date AS Create_Date
FROM silver_crm_cust_info AS ci
LEFT JOIN silver_erp_CUST_AZ12 caz
ON ci.cst_key = caz.cid
LEFT JOIN silver_erp_loc_a101 la1
ON ci.cst_key = la1.CID;

-- Check quality of the gold dimension.



/*
--------------------------------------------------------------------------------------------------
Create Dimension for Products : gold_dim_products
--------------------------------------------------------------------------------------------------
*/


CREATE VIEW gold_dim_products AS

SELECT  
ROW_NUMBER() OVER(ORDER BY pin.prd_start_dt, pin.prd_key) AS Sno,
pin.prd_id AS Product_id,
pin.prd_key AS Product_key,
pin.prd_nm AS Product_name,
pin.cat_id AS Category_id,
pcg.CAT AS Category,
pcg.SUBCAT AS Subcategory,
pcg.MAINTENANCE AS Maintenance,
pin.prd_cost AS Product_cost,
pin.prd_line AS Product_line,
pin.prd_start_dt AS Start_Ddate
FROM silver_crm_prd_info pin
LEFT JOIN silver_erp_PX_CAT_G1V2 pcg
ON pin.cat_id = pcg.ID
WHERE prd_end_dt IS NULL -- Filter out historical data




  /*
--------------------------------------------------------------------------------------------------
Create Fact for Sales : gold_fact_sales
--------------------------------------------------------------------------------------------------
*/
CREATE VIEW gold_fact_sales AS
SELECT 
sd.sls_ord_num AS order_number,
pr.product_key,
cu.customer_key,
sd.sls_order_dt AS order_date,
sd.sls_ship_dt AS shipping_date,
sd.sls_due_dt AS due_date,
sd.sls_sales AS sales_amount,
sd.sls_quantity AS quantity,
sd.sls_price
FROM silver_crm_sales_details sd
LEFT JOIN gold_dim_products pr
ON sd.sls_prd_key = pr.product_key
LEFT JOIN gold_dim_customers cu
ON sd.sls_cust_id = cu.customer_id
