/*
--==================================================================================
silver.test script for data validation:
--==================================================================================
This script performs quality checks to ensure data valididty,consistiency and 
reliability of 'gold' layer.This checks ensures
	1.Uniqueness of the surrogate key
	2.
	
 This will help ensure data relaiblity and traceability across downstream processes.
--==================================================================================
*/
--==================================================================================
--# Checking 'silver.crm_cust_info'
--==================================================================================
--Check for Nulls or duplicates in Primary Key:
--Expectation: No result
SELECT 
cst_id ,
COUNT(*) as flag
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS  NULL;
-----------------------------------------------------------------

--Check for Unwanted Spaces:
--Expectation: No Result
SELECT cst_marital_status
FROM silver.crm_cust_info
WHERE cst_marital_status != TRIM(cst_marital_status);  
------------------------------------------------------------------

--Data standardization and consistency :
--Check for consistency of values in low cardinality columns:
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info;

--==================================================================================
--# Checking 'silver.crm_prd_info'
--==================================================================================

--Checking Null or Duplicate Primary Keys:
--Expectation: No result
SELECT 
	prd_id,
	COUNT(*) 
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL ;
------------------------------------------------------------------

--Check for unwanted spaces
SELECT 
	prd_nm
FROM silver.crm_prd_info
WHERE TRIM(prd_nm)!= prd_nm;
------------------------------------------------------------------

--Check for NULL values
SELECT
	prd_cost
FROM silver.crm_prd_info
WHERE prd_cost IS NULL;
------------------------------------------------------------------

--Data Standardization and Consistency:
SELECT DISTINCT
	prd_line
FROM silver.crm_prd_info;
------------------------------------------------------------------

--Check for invalid order dates.(start_date > end_date)
SELECT 
	* 
FROM silver.crm_prd_info 
WHERE prd_end_dt < prd_start_dt;
------------------------------------------------------------------

--Randomly selected product keys to check data inconsistencies:
--Verifying if product start date and end date are logically consistent:
SELECT
	*
FROM silver.crm_prd_info
WHERE prd_key IN ('HL-U509','HL-U509-R');

--==================================================================================
--# Checking 'silver.crm_sales_details'
--==================================================================================

--Check unwanted spaces
SELECT
	*
FROM silver.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num);
------------------------------------------------------------------

--Checking integrity of columns useable to connect to other table:
--Expectation: No result

SELECT 
	*
FROM silver.crm_sales_details
WHERE sls_cust_id NOT IN (
						   SELECT 
								cst_id
                           FROM silver.crm_cust_info
						   );


------------------------------------------------------------------

--Check for Invalid Dates:
SELECT 
	 sls_order_dt,
	 sls_ship_dt,
	 sls_due_dt
FROM silver.crm_sales_details
WHERE 
 LEN(sls_order_dt)!= 10
OR sls_order_dt > '2050-01-01' OR sls_order_dt < '1990-01-01'
OR  LEN(sls_ship_dt)!= 10
OR sls_ship_dt > '2050-01-01' OR sls_ship_dt < '1990-01-01'
OR  LEN(sls_due_dt)!= 10
OR sls_due_dt > '2050-01-01' OR sls_due_dt < '1990-01-01';
------------------------------------------------------------------

--Check for Invalid Order Dates:
SELECT
	*
FROM silver.crm_sales_details
WHERE sls_order_dt  > sls_ship_dt OR sls_order_dt > sls_due_dt;
------------------------------------------------------------------

-- Checking sales records with missing or invalid price(negative), quantity, or sales amount
-- and sales!=price*quantity:
SELECT 
	sls_sales,
	sls_price,
	sls_quantity
FROM silver.crm_sales_details
WHERE sls_price IS NULL OR sls_price <=0 
OR sls_sales IS NULL OR sls_sales <= 0
OR sls_quantity IS NULL OR sls_quantity <=0
OR sls_sales != (sls_price*sls_quantity);

--==================================================================================
--# Checking 'silver.erp_cust_az12'
--==================================================================================

-- Checking  Primary Key and
-- Identifying records with NULL or untrimmed values
SELECT * 
FROM silver.erp_cust_az12
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
FROM silver.erp_cust_az12 
WHERE LEN(bdate) != 10 
   OR DATEDIFF(YEAR, bdate, GETDATE()) > 100 
   OR DATEDIFF(YEAR, bdate, GETDATE()) < 0;
------------------------------------------------------------------
-- Check for Invalid or Inconsistent Gender Values:
SELECT  gen
FROM silver.erp_cust_az12
WHERE gen IS NULL OR gen != TRIM(gen);

--==================================================================================
--# Checking 'silver.erp_loc_a101'
--==================================================================================
-- Check for NULL values in customer id (Primary Key Check):
SELECT cid
FROM silver.erp_loc_a101
WHERE cid IS NULL;
------------------------------------------------------------------

--Data Standardization and Consistency:
SELECT 
	cntry
FROM silver.erp_loc_a101
ORDER BY cntry

--==================================================================================
--# Checking 'silver.erp_px_cat_g1v2'
--==================================================================================
--Check for unwanted spaces:
SELECT 
	* 
FROM silver.erp_px_cat_g1v2
WHERE id!=TRIM(id) 
	OR cat!=TRIM(cat) 
	OR subcat!=TRIM(subcat)





