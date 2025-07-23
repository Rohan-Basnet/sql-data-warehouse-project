--Creating Object CUSTOMER
IF OBJECT_ID('gold.dim_customers','V') IS NOT NULL
	DROP VIEW gold.dim_customers;
GO
CREATE VIEW gold.dim_customers AS
(
SELECT 
	ROW_NUMBER() OVER( ORDER BY i.cst_id)	AS customer_key, -- Surrogate Key
	i.cst_id								AS	customer_id,
	i.cst_key								AS customer_number,
	i.cst_firstname							AS first_name,
	i.cst_lastname							AS last_name,
	lo.cntry								AS country,
	i.cst_marital_status					AS marital_status,
	CASE WHEN i.cst_gndr != 'n/a' THEN i.cst_gndr --CRM is the Master for Gender Info
	ELSE COALESCE(az.gen,'n/a')
	END										AS gender,
	az.bdate								AS birth_date,
	i.cst_create_date						AS create_date
FROM silver.crm_cust_info i
LEFT JOIN silver.erp_cust_az12 az
ON i.cst_key = az.cid
LEFT JOIN silver.erp_loc_a101 lo
ON i.cst_key = lo.cid
);
--Creating Object PRODUCT
IF OBJECT_ID('gold.dim_product','V') IS NOT NULL
	DROP VIEW gold.dim_product;
GO
CREATE VIEW gold.dim_product AS
(
SELECT 
	ROW_NUMBER() OVER(ORDER BY pi.prd_start_dt,pi.prd_key)	AS product_key, --	Surrogate Key
	pi.prd_id												AS product_id,
	pi.prd_key												AS product_number,
	pi.prd_nm												AS product_name,
	pi.cat_id												AS category_id,
	pc.cat													AS category,
	pc.subcat												AS sub_category,
	pc.maintenance,
	pi.prd_cost												AS product_cost,
	pi.prd_line												AS product_line,
	pi.prd_start_dt											AS start_date
FROM silver.crm_prd_info pi
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pi.cat_id = pc.id
WHERE pi.prd_end_dt IS NULL --Filtering all Historical Data
);
--Creating object SALES
IF OBJECT_ID('gold.fact_sales','V') IS NOT NULL
	DROP VIEW gold.fact_sales;
GO
CREATE VIEW gold.fact_sales AS
(SELECT 
	sd.sls_ord_num		 AS order_number,
	dp.product_key ,
	dc.customer_key ,
	sd.sls_order_dt		AS order_date,
	sd.sls_ship_dt		AS shipping_date,
	sd.sls_due_dt		AS due_date,
	sd.sls_sales		AS sales_amount,
	sd.sls_quantity		AS quantity,
	sd.sls_price		AS price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_product dp
ON sd.sls_prd_key = dp.product_number
LEFT JOIN gold.dim_customers dc
ON sd.sls_cust_id = dc.customer_id
)

