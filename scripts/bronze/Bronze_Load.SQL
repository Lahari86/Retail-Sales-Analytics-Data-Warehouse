/*

## Load the data from six CSV files
..................................
## Script Purpose : This script truncates the bronze tables and then loads data from the CSV files. 
    ### Uses BULK INSERT command to load the data.
    ### Logs the duration of the load process.
    ### A stored procedure is created which can be executed using the below command, 
        "EXEC bronze_load_bronze;"
----------------------------------
*/


--Create Stored procedure when a script should be ran on a regular basis
CREATE OR ALTER PROCEDURE bronze_load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT('============================================================');
		PRINT('Loading Bronze Layer');
		PRINT('============================================================');

		PRINT('------------------------------------------------------------');
		PRINT('Loading CRM tables ');
		PRINT('------------------------------------------------------------');

		--bronze_crm_cust_info
		SET @start_time = GETDATE();
		PRINT('>>Truncating Table: bronze_crm_cust_info');
		TRUNCATE TABLE bronze_crm_cust_info; --FIRST DELETES ALL THE ROWS FROM THE TABLE

		PRINT('>>Loading Table: bronze_crm_cust_info');
		BULK INSERT bronze_crm_cust_info
		FROM 'C:\Desktop\Datawarehouse_projects\Sales_Customer_project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		--SELECT * FROM bronze_crm_cust_info;
		--SELECT COUNT(8) FROM bronze_crm_cust_info;
		SET @end_time = GETDATE();
		PRINT('>>Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds');
		PRINT('------------------------------------------------------------');
		
		-- bronze_crm_prd_info
		SET @start_time = GETDATE();
		PRINT('>>Truncating Table: bronze_crm_prd_info');
		TRUNCATE TABLE bronze_crm_prd_info; --FIRST DELETES ALL THE ROWS FROM THE TABLE

		PRINT('>>Loading Table: bronze_crm_prd_info');
		BULK INSERT bronze_crm_prd_info
		FROM 'C:\Desktop\Datawarehouse_projects\Sales_Customer_project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		--SELECT * FROM bronze_crm_prd_info;
		--SELECT COUNT(*) FROM bronze_crm_prd_info;
		SET @end_time = GETDATE();
		PRINT('>>Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds');
		PRINT('------------------------------------------------------------');


		-- bronze_crm_sales_details
		SET @start_time = GETDATE();
		PRINT('>>Truncating Table: bronze_crm_sales_details');
		TRUNCATE TABLE bronze_crm_sales_details; --FIRST DELETES ALL THE ROWS FROM THE TABLE

		PRINT('>>Loading Table: bronze_crm_sales_details');
		BULK INSERT bronze_crm_sales_details
		FROM 'C:\Desktop\Datawarehouse_projects\Sales_Customer_project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		--SELECT * FROM bronze_crm_sales_details;
		--SELECT COUNT(*) FROM bronze_crm_sales_details;
		SET @end_time = GETDATE();
		PRINT('>>Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds');
		PRINT('------------------------------------------------------------');


		PRINT('------------------------------------------------------------');
		PRINT('Loading ERP tables ');
		PRINT('------------------------------------------------------------');

		-- bronze_erp_CUST_AZ12
		SET @start_time = GETDATE();
		PRINT('>>Truncating Table: bronze_erp_CUST_AZ12');
		TRUNCATE TABLE bronze_erp_CUST_AZ12; --FIRST DELETES ALL THE ROWS FROM THE TABLE

		PRINT('>>Loading Table: bronze_erp_CUST_AZ12');
		BULK INSERT bronze_erp_CUST_AZ12
		FROM 'C:\Desktop\Datawarehouse_projects\Sales_Customer_project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		--SELECT * FROM bronze_erp_CUST_AZ12;
		--SELECT COUNT(*) FROM bronze_erp_CUST_AZ12;
		SET @end_time = GETDATE();
		PRINT('>>Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds');
		PRINT('------------------------------------------------------------');


		-- bronze_erp_LOC_A101
		SET @start_time = GETDATE();
		PRINT('>>Truncating Table: bronze_erp_LOC_A101');
		TRUNCATE TABLE bronze_erp_LOC_A101; --FIRST DELETES ALL THE ROWS FROM THE TABLE

		PRINT('>>Loading Table: bronze_erp_LOC_A101');
		BULK INSERT bronze_erp_LOC_A101
		FROM 'C:\Desktop\Datawarehouse_projects\Sales_Customer_project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		--SELECT * FROM bronze_erp_LOC_A101;
		--SELECT COUNT(*) FROM bronze_erp_LOC_A101;
		SET @end_time = GETDATE();
		PRINT('>>Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds');
		PRINT('------------------------------------------------------------');


		-- bronze_erp_PX_CAT_G1V2
		SET @start_time = GETDATE();
		PRINT('>>Truncating Table: bronze_erp_PX_CAT_G1V2');
		TRUNCATE TABLE bronze_erp_PX_CAT_G1V2; --FIRST DELETES ALL THE ROWS FROM THE TABLE

		PRINT('>>Loading Table: bronze_erp_PX_CAT_G1V2');
		BULK INSERT bronze_erp_PX_CAT_G1V2
		FROM 'C:\Desktop\Datawarehouse_projects\Sales_Customer_project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		--SELECT * FROM bronze_erp_PX_CAT_G1V2;
		--SELECT COUNT(*) FROM bronze_erp_PX_CAT_G1V2;
		SET @end_time = GETDATE();
		PRINT('>>Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds');
		SET @batch_end_time = GETDATE();
		PRINT('============================================================');
		PRINT('LOADING BRONZE LAYER COMPLETED');
		PRINT('Total Load Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + 'seonds');
		PRINT('============================================================');
		PRINT('------------------------------------------------------------');
	END TRY

	BEGIN CATCH
		PRINT('============================================================');
		PRINT('ERROR LOADING BRONZE LAYER');
		PRINT('Error Message' + ERROR_MESSAGE());
		PRINT('Error Number' + CAST(ERROR_NUMBER() AS NVARCHAR));
		PRINT('Error State' + CAST(ERROR_STATE() AS NVARCHAR));
		PRINT('============================================================');
	END CATCH
END

--Execute the stored procedure
EXEC bronze_load_bronze;
