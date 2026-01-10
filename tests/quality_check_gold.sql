/*
--==================================================================================
silver.test script for data validation:
--==================================================================================
This script performs quality checks to ensure validity,consistency and 
reliability of data in 'gold' layer.This checks ensures
	-Uniqueness of the surrogate key
	-Referential integrity between fact and dimension tables
	-Validation of relationships in the data model for analytical purpose
	
Usage Notes:
	-
--==================================================================================
*/
--==================================================================================
--#Checking 'gold.dim_customers'
--==================================================================================
--Checking whether the customer key is unique within gold.dim_customers

SELECT   
	customer_key,
	COUNT(*) AS duplicate_key
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

--==================================================================================
--#Checking 'gold.dim_product'
--==================================================================================
--Checking whether the product key is unique within gold.dim_product

SELECT 
	product_key,
	COUNT(product_key)
FROM gold.dim_product
GROUP BY product_key
HAVING COUNT(*) > 1;

--==================================================================================
--#Checking 'glod.fact_sales'
--==================================================================================
--Checking for data model connectivity between fact and dimension
SELECT
	*
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
ON s.customer_key= c.customer_key
LEFT JOIN gold.dim_product p
ON s.product_key=p.product_key
WHERE c.customer_key IS NULL 
	 OR p.product_key IS NULL;




