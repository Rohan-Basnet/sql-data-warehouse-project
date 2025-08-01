/*
========================================================================================
Stored Procedure: Loads Bronze Layer (Source -> Bronze)
========================================================================================
Script Purpose:
	This stored procedure loads data into Bronze tables from external CSV files.
	Actions Performed:
		-Truncates the bronze tables before loading data
		-Uses the 'BULK INSERT' command to load data from CSV file to Bronze tables
Parameters:
	None.
		This stored procedure doesnot accept any parameter or return values.

Usage Exaample:
	EXEC bronze.load_silver;
=========================================================================================
*/
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME , @end_time DATETIME, @batch_start_time DATETIME , @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT'======================================';
		PRINT'Loading Bronze Layer';
		PRINT'======================================';
		PRINT'--------------------------------------';
		PRINT'Loading CRM Tables';
		PRINT'--------------------------------------';
		
		SET @start_time = GETDATE();
		PRINT'<<< Truncating Table: bronze.crm_cust_info >>>';
		TRUNCATE TABLE bronze.crm_cust_info;
		PRINT'<<< Inserting Data into Table: bronze.crm_cust_info >>>';
		BULK INSERT bronze.crm_cust_info
		FROM 'E:\SQL Datawarehouse project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH(
			FIRSTROW =2,
			FIELDTERMINATOR =',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'** LOAD DURATION:'+ CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) +'seconds';
		PRINT'-----------------'
		--2.Inserting data into table bronze.crm_prd_info
		SET @start_time = GETDATE();
		PRINT'<<< Truncating Table: bronze.crm_prd_info >>>';
		TRUNCATE TABLE bronze.crm_prd_info;
		PRINT'<<< Inserting Data into Table: bronze.crm_prd_info >>>';
		BULK INSERT bronze.crm_prd_info
		FROM 'E:\SQL Datawarehouse project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'** LOAD DURATION:'+ CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) +'seconds';
		PRINT'-----------------'
		--3.Inserting data into table bronze.crm_sales_details
		SET @start_time = GETDATE();
		PRINT'<<< Truncating Table: bronze.crm_sales_details >>>';
		TRUNCATE TABLE bronze.crm_sales_details;
		PRINT'<<< Inserting Data into Table: bronze.crm_sales_details >>>';
		BULK INSERT bronze.crm_sales_details
		FROM 'E:\SQL Datawarehouse project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH(
			FIRSTROW =2,
			FIELDTERMINATOR =',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'** LOAD DURATION:'+ CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) +'seconds';
		PRINT'-----------------'
		PRINT'--------------------------------------'
		PRINT'Loading ERP Tables'
		PRINT'--------------------------------------'
		--4.Inserting data into table bronze.erp_cust_az12
		SET @start_time = GETDATE();
		PRINT'<<< Truncating Table: bronze.erp_cust_az12 >>>';
		TRUNCATE TABLE bronze.erp_cust_az12;
		PRINT'<<< Inserting Data into Table: bronze.erp_cust_az12 >>>';
		BULK INSERT bronze.erp_cust_az12
		FROM 'E:\SQL Datawarehouse project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'** LOAD DURATION:'+ CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) +'seconds';
		PRINT'-----------------'


		--5.Inserting data into table bronze.erp_loc_a101
		SET @start_time = GETDATE();
		PRINT'<<< Truncating Table: bronze.erp_loc_a101 >>>';
		TRUNCATE TABLE bronze.erp_loc_a101;
		PRINT'<<< Inserting Data into Table: bronze.erp_loc_a101 >>>';
		BULK INSERT bronze.erp_loc_a101
		FROM 'E:\SQL Datawarehouse project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'** LOAD DURATION:'+ CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) +'seconds';
		PRINT'-----------------'

		--6.Inserting data into table bronze.erp_px_cat_g1v2
		SET @start_time = GETDATE();
		PRINT'<<< Truncating Table: bronze.erp_px_cat_g1v2 >>>';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		PRINT'<<< Inserting Data into Table: bronze.erp_px_cat_g1v2 >>>';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'E:\SQL Datawarehouse project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'** LOAD DURATION:'+ CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) +'seconds';
		PRINT'-----------------'
		SET @batch_end_time = GETDATE();
		PRINT'=============================================='
		PRINT'LOADING BRONZE LAYER IS COMPLETED';
		PRINT'** TOTAL LOAD DURATION :' + CAST(DATEDIFF(second,@batch_start_time,@batch_end_time) AS NVARCHAR) + 'seconds';
		PRINT'=============================================='
	END TRY 
	BEGIN CATCH
		PRINT'============================================================'
		PRINT'ERROR OCCURED DURING LOADING BRONZE LAYER!!!';
		PRINT'ERROR MESSAGE' + ERROR_MESSAGE();
		PRINT'ERROR MESSAGE' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT'ERROR MESSAGE' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT'============================================================'
	END CATCH;
END
