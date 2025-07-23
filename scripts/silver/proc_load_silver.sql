/*
========================================================================================
Stored Procedure: Loads Silver Layer (Bronze -> Silver)
========================================================================================
Script Purpose:
	This stored procedure performs ETL (Extract, Transform , Load) process to
	laod the 'silver'schema tables from the 'bronze' schema.
	Actions Performed:
		-Truncates the target tables in 'Silver' schema to avoid duplicates Table
		-Applies necessary transformations
		-Loads the cleansed data form Bronze into Silver tables

Parameters:
	None.
		This stored procedure doesnot accept any parameter or return values.

Usage Exaample:
	EXEC silver.load_silver;
=========================================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	DECLARE @start_time DATETIME , @end_time DATETIME , @batch_start_time DATETIME ,@batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT'======================================';
		PRINT'Loading Silver Layer';
		PRINT'======================================';
		PRINT'--------------------------------------';
		PRINT'Inserting Into CRM Tables';
		PRINT'--------------------------------------';
		--===========================================================================================
		--INSERTING Clean Data into Table silver.crm_cust_info
		--===========================================================================================
		SET @start_time = GETDATE();
		PRINT'<<< Truncating Table silver.crm_cust_info >>>';
		TRUNCATE TABLE silver.crm_cust_info;
		PRINT'<<< Inserting into Table silver.crm_cust_info >>>';
		INSERT INTO silver.crm_cust_info
		(	cst_id,
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
			CASE WHEN UPPER(cst_marital_status) = 'M' THEN 'Married'
				WHEN UPPER(cst_marital_status) = 'S' THEN 'Single'
				ELSE 'n/a' 
			END AS cst_marital_status,	--Mapping readable values to cst_marital_status
			CASE WHEN UPPER(cst_gndr) = 'F' THEN 'Female'
				WHEN UPPER(cst_gndr) = 'M' THEN 'Male'
				ELSE 'n/a' 
			END AS cst_gndr,	--Mapping readable values to cst_gndr
			cst_create_date
			FROM(SELECT*,
			ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) flag_check
			FROM bronze.crm_cust_info
		)T WHERE flag_check = 1 AND cst_id IS NOT NULL;	--Retaining upto date values

		SET @end_time = GETDATE();
		PRINT'** INSERT DURATION:'+ CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) +'seconds';
		PRINT'-----------------'
		--===========================================================================================
		--INSERTING Cleansed Data into Table silver.crm_prd_info
		--===========================================================================================
		
		SET @start_time = GETDATE();
		PRINT'<<< Truncating Table silver.crm_prd_info >>>';
		TRUNCATE TABLE silver.crm_prd_info;
		PRINT'<<< Inserting into Table silver.crm_prd_info >>>';
		INSERT INTO silver.crm_prd_info
		(	prd_id,
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
			REPLACE(SUBSTRING(prd_key, 1, 5),'-','_') AS cat_id,  --Extract category id
			SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,   --Extract product key
			prd_nm,
			COALESCE(prd_cost,0) AS prd_cost,-- OR ISNULL(prd_cost,0)
			CASE UPPER(TRIM(prd_line)) 
				 WHEN 'R' THEN 'Road'
				 WHEN 'S' THEN 'Other Sales'
   				 WHEN 'M' THEN 'Mountain'   --Data Normalization
				 WHEN  'T' THEN 'Touring'
				 ELSE 'n/a'   --Handling missing data
			END AS prd_line,   --Mapping product line codes to descriptive value
			prd_start_dt,
			DATEADD(DAY,-1,LEAD(prd_start_dt)   --Data Enrichment
			OVER(PARTITION BY prd_key ORDER BY prd_start_dt)) AS prd_end_dt --Calculating end date as one day before the next start date
		FROM bronze.crm_prd_info;

		SET @end_time = GETDATE();
		PRINT'** INSERT DURATION:'+ CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) +'seconds';
		PRINT'-----------------'
		--===========================================================================================
		--INSERTING Cleansed Data into Table silver.crm_sales_details
		--===========================================================================================

		SET @start_time = GETDATE();
		PRINT'<<< Truncating Table silver.crm_sales_details >>>';
		TRUNCATE TABLE silver.crm_sales_details;
		PRINT'<<< Inserting into Table silver.crm_sales_details >>>';
		INSERT INTO silver.crm_sales_details
		(
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
			CASE
				WHEN LEN(sls_order_dt) != 8 
					 OR TRY_CONVERT(INT, sls_order_dt) IS NULL 
					 OR sls_order_dt < '19900101' 
					 OR sls_order_dt > '20500101' 
				THEN NULL
				ELSE CONVERT(DATE, sls_order_dt, 112)
			END AS sls_order_dt,
			sls_ship_dt,
			sls_due_dt,
				CASE 
				WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != ABS(sls_price*sls_quantity) 
				THEN ABS(sls_price)*sls_quantity
				ELSE sls_sales
			END AS sls_sales, --Recalulate sales if original value is missing or incorrect
			sls_quantity,
			CASE
				WHEN sls_price IS NULL OR sls_price <=0 
				THEN sls_sales/NULLIF(sls_quantity,0)
				ELSE sls_price
			END AS sls_price --Derive price if original price is missing or invalid
		FROM bronze.crm_sales_details;
		SET @end_time = GETDATE();
		PRINT'** INSERT DURATION:'+ CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) +'seconds';
		PRINT'-----------------'
		--===========================================================================================
		--INSERTING Cleansed Data into Table silver.erp_cust_az12
		--===========================================================================================

		PRINT'--------------------------------------'
		PRINT'Inserting Into ERP Tables'
		PRINT'--------------------------------------'
		SET @start_time = GETDATE();
		PRINT'<<< Truncating Table silver.erp_cust_az12 >>>';
		TRUNCATE TABLE silver.erp_cust_az12;
		PRINT'<<< Inserting into Table silver.erp_cust_az12 >>>';

		INSERT INTO silver.erp_cust_az12
		(cid,
		bdate,
		gen
		)
		SELECT 
			 CASE 
				 WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,	LEN(cid)) --Remove NAS prefix if present
				 ELSE cid
			 END AS cid,
			CASE WHEN bdate > GETDATE() OR bdate < '1925-01-01' THEN NULL
				 ELSE bdate
			END AS bdate, --Set future dates and date below '1925-01-01' to NULL
			CASE WHEN UPPER(TRIM(gen)) IN ('F','FEMALE') THEN 'Female'
				WHEN UPPER(TRIM(gen)) IN ('M','MALE') THEN 'Male'
				 ELSE 'n/a'
			END AS gen --Normalize gender values and handle unknown value
		FROM bronze.erp_cust_az12;
		SET @end_time = GETDATE();
		PRINT'** INSERT DURATION:'+ CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) +'seconds';
		PRINT'-----------------'
		--===========================================================================================
		--INSERTING Cleansed Data into Table silver.erp_loc_a101
		--===========================================================================================
		
		SET @start_time = GETDATE();
		PRINT'<<< Truncating Table silver.erp_loc_a101 >>>';
		TRUNCATE TABLE silver.erp_loc_a101;
		PRINT'<<< Inserting into Table silver.erp_loc_a101 >>>';
		
		INSERT INTO silver.erp_loc_a101
		(cid,
		cntry
		)
		SELECT
			REPLACE(cid,'-','') AS cid, -- Handle Invalid value
			CASE WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
				 WHEN TRIM(cntry) = 'DE' THEN 'Germany'
				 WHEN cntry IS NULL OR cntry ='' THEN 'n/a'
				 ELSE TRIM(cntry)
			END AS cntry  -- Normalize country values and Handle NULL or missing values
		FROM bronze.erp_loc_a101

		SET @end_time = GETDATE();
		PRINT'** INSERT DURATION:'+ CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) +'seconds';
		PRINT'-----------------'
		--===========================================================================================
		--INSERTING Cleansed Data into Table silver.erp_px_cat_g1v2
		--===========================================================================================
		
		SET @start_time = GETDATE();
		PRINT'<<< Truncating Table silver.erp_px_cat_g1v2 >>>';
		TRUNCATE TABLE silver.erp_px_cat_g1v2;
		PRINT'<<< Inserting into Table silver.erp_px_cat_g1v2 >>>';

		INSERT INTO silver.erp_px_cat_g1v2
		(id,
		cat,
		subcat,
		maintenance
		)
		SELECT 
			id,
			cat,
			subcat,
			maintenance
		FROM bronze.erp_px_cat_g1v2

		SET @end_time = GETDATE();
		PRINT'** INSERT DURATION:'+ CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) +'seconds';
		PRINT'-----------------'
		SET @batch_end_time = GETDATE();
		PRINT'=============================================='
		PRINT'INSERTING SILVER LAYER IS COMPLETED';
		PRINT'** TOTAL INSERT DURATION :' + CAST(DATEDIFF(second,@batch_start_time,@batch_end_time) AS NVARCHAR) + 'seconds';
		PRINT'=============================================='
	END TRY
	BEGIN CATCH
		PRINT'============================================================'
		PRINT'<<< ERROR OCCURED DURING INSERTING INTO SILVER LAYER !!!';
		PRINT'<<< ERROR MESSAGE:'+ ERROR_MESSAGE();
		PRINT'<<< ERROR MESSAGE:'+ CAST(ERROR_NUMBER() AS VARCHAR);
		PRINT'<<< ERROR MESSAGE:'+ CAST(ERROR_STATE() AS VARCHAR);
		PRINT'============================================================'
	END CATCH
END	


  
