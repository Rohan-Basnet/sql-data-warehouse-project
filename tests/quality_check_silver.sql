/*
--==================================================================================
silver.test script for data validation:
--==================================================================================
This script performs data consistency and validation checks on the 'silver' layer tables to ensure data 
quality before promoting to the 'gold' layer.
Key checks include:
	1.Null/missing value identification
	2.Duplicate detection
	3.Business logic validation(eg. date consistency, value ranges)
	4.Referential integrity between 'silver' tables
 This will help ensure data relaiblity and traceability across downstream processes.
--==================================================================================
*/

--==================================================================================
--# Cleaning Customer Info Table
--==================================================================================
--Check for Nulls or duplicates in Primary Key:
--Expectation: No Result
SELECT 
cst_id ,
COUNT(*) as flag
FROM [bronze].[crm_cust_info]
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS  NULL;
-----------------------------------------------------------------

--Check for Unwanted Spaces:
--Expectation: No Result
SELECT cst_marital_status
FROM bronze.crm_cust_info
WHERE cst_marital_status != TRIM(cst_marital_status);
------------------------------------------------------------------

--Data standardization and consistency :
--Check the consistency of values in low cardinality columns:
SELECT DISTINCT cst_gndr
FROM bronze.crm_cust_info;

--==================================================================================
--#Cleaning Product Info table
--==================================================================================

--Checking NULL OR duplicate Primary Keys:
SELECT 
prd_id,
COUNT(*) 
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL ;
------------------------------------------------------------------

--Check unwanted spaces
SELECT prd_nm
FROM bronze.crm_prd_info
WHERE TRIM(prd_nm)!= prd_nm;
------------------------------------------------------------------

--Check NULL values
SELECT prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost IS NULL;
------------------------------------------------------------------

--Retrieve a list of all unique product lines from the product information table:
SELECT DISTINCT prd_line
FROM bronze.crm_prd_info;
------------------------------------------------------------------

--Check for prd_start_dt and prd_end_dt (invalid order dates):
SELECT * 
FROM bronze.crm_prd_info 
WHERE prd_end_dt < prd_start_dt;
------------------------------------------------------------------

--Randomly selected product keys to find data inconsistencies:
--Verifying if product start date and end date are logically consistent:
SELECT * FROM bronze.crm_prd_info
WHERE prd_key IN ('AC-HE-HL-U509','AC-HE-HL-U509-R');

--==================================================================================
--# Cleaning Sales Details Table
--==================================================================================

--Check unwanted spaces
SELECT * FROM bronze.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num);
------------------------------------------------------------------

--Checking integrity of columns useable to connect to other table:
SELECT * FROM bronze.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT prd_key
                           FROM silver.crm_prd_info);

SELECT * FROM bronze.crm_sales_details
WHERE sls_cust_id NOT IN (SELECT cst_id
                           FROM silver.crm_cust_info);
------------------------------------------------------------------

--Check for Invalid Dates:
SELECT 
 sls_order_dt,
 sls_ship_dt,
 sls_due_dt
FROM bronze.crm_sales_details
WHERE 
 LEN(sls_order_dt)!= 10
OR sls_order_dt > '2050-01-01' OR sls_order_dt < '1990-01-01'
OR  LEN(sls_ship_dt)!= 10
OR sls_ship_dt > '2050-01-01' OR sls_ship_dt < '1990-01-01'
OR  LEN(sls_due_dt)!= 10
OR sls_due_dt > '2050-01-01' OR sls_due_dt < '1990-01-01';
------------------------------------------------------------------

--Check Invalid Order Dates:
SELECT * FROM bronze.crm_sales_details
WHERE sls_order_dt  > sls_ship_dt OR sls_order_dt > sls_due_dt;
------------------------------------------------------------------

-- Identify sales records with missing or invalid price, quantity, or sales amount,
-- or where sales amount does not match price multiplied by quantity:
SELECT 
	sls_sales,
	sls_price,
	sls_quantity
FROM bronze.crm_sales_details
WHERE sls_price IS NULL OR sls_price <=0 
OR sls_sales IS NULL OR sls_sales <= 0
OR sls_quantity IS NULL OR sls_quantity <=0
OR sls_sales != (sls_price*sls_quantity);

--==================================================================================
--# Cleaning ERP_CUST_AZ12 Table 
--==================================================================================

-- Check for Primary Key Issues in 'erp_cust_az12'
-- Identify records with NULL or untrimmed 'cid' values (violates key uniqueness or consistency):
SELECT * 
FROM bronze.erp_cust_az12
WHERE cid IS NULL 
   OR cid != TRIM(cid);
------------------------------------------------------------------

-- Check for Invalid or Out-of-Range Birthdates:
-- Detect rows with incorrect date lengths or ages > 100 years or negative:
SELECT 
  CASE 
      WHEN bdate > GETDATE() OR bdate < '1925-01-01' THEN NULL
      ELSE bdate
  END AS bdate
FROM bronze.erp_cust_az12 
WHERE LEN(bdate) != 10 
   OR DATEDIFF(YEAR, bdate, GETDATE()) > 100 
   OR DATEDIFF(YEAR, bdate, GETDATE()) < 0;
------------------------------------------------------------------

-- Check for Invalid or Inconsistent Gender Values:
SELECT  gen
FROM bronze.erp_cust_az12
WHERE gen IS NULL OR gen != TRIM(gen);

--==================================================================================
--# ERP_LOC_A101 Table - Customer Location Data Cleansing
--==================================================================================

-- Check for NULL values in cid (Primary Key Check):
SELECT cid
FROM bronze.erp_loc_a101
WHERE cid IS NULL;
------------------------------------------------------------------

--Check for invalid country values:
SELECT cntry
FROM bronze.erp_loc_a101
WHERE cntry != TRIM(cntry) OR cntry IS NULL;

--==================================================================================
--# ERP_PX_CAT_G1V2 Table - Product Category Validation
--==================================================================================

-- Check for product categories missing in CRM master:
SELECT id
FROM bronze.erp_px_cat_g1v2
WHERE id NOT IN (SELECT cat_id FROM silver.crm_prd_info);
------------------------------------------------------------------

-- Check for Inconsistent 'maintenance' Values:
SELECT DISTINCT maintenance 
FROM bronze.erp_px_cat_g1v2
WHERE maintenance != TRIM(maintenance);
           
