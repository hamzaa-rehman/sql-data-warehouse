  /*
  =============================================================================
  Quality Checks
  =============================================================================
  Script Purpose:
    This script performs various quality checks for data consistency, accuracy, 
    and standardization across the 'silver' schemas. It includes checks for:
    -Null or duplicate primary keys.
    -Unwanted spaces in string fields.
    -Data standardization and consistency.
    -Invalid date ranges and orders.
    -Data consistency between related fields.
  
  Usage Notes:
    -Run these checks after data loading Silver Layer.
    -Investigate and resolve any discrepancies found during checks.
  =============================================================================
  */

  --============================================================
  -- Checking 'silver.crm_cust_info'
  --============================================================
  -- Check for NULLs or Duplicates in Primary Key
  -- Expectations: No Results
  SELECT 
  	cst_id,
  	count(*)
  FROM Silver.crm_cust_info 
  GROUP BY cst_id 
  HAVING COUNT(*)>1 OR cst_id IS NULL;

  -- Check for unwanted Spaces
  -- Expectations: No Results
  SELECT
    cst_key
  FROM Silver.crm_cust_info
  WHERE datalength(cst_key)!=datalength(TRIM(cst_key))

  --Data Standarization & Consistency
  SELECT distinct 
	  cst_marital_status 
  FROM Silver.crm_cust_info 

  --============================================================
  -- Checking 'silver.crm_prd_info'
  --============================================================
  -- Check for NULLs or Duplicates in Primary Key
  -- Expectations: No Results
  SELECT
  	prd_id,
  	count(*)
  FROM silver.crm_prd_info 
  GROUP BY prd_id 
  HAVING count(*)>1 or prd_id is null
  
  --Check unwanted spaces
  --Expectations: No results

  SELECT 
    prd_nm
  FROM Silver.crm_prd_info
  WHERE datalength(prd_nm)!=datalength(TRIM(prd_nm))
  
  --Check for Nulls or Negative Values in Cost
  --Expectations: No results
  
  SELECT 
    prd_cost
  FROM silver.crm_prd_info
  WHERE prd_cost<0 or prd_cost is null

  -- Check for invalid Order dates
  SELECT  
    prd_id,
    prd_key,
    prd_nm,
    prd_start_dt,
    prd_end_dt,
  FROM silver.crm_prd_info
  WHERE prd_end_dt<prd_start_dt

  -- Data Standarization & Consistency
  SELECT distinct 
	  prd_line 
  FROM Silver.crm_prd_info 

  
  --============================================================
  -- Checking 'silver.crm_sales_details'
  --============================================================
  -- Check Invalid Dates 
  -- Expectations: No Invalid Dates 
  SELECT 
    nullif(sls_due_dt,0) as sls_due_dt
  FROM bronze.crm_sales_details 
  WHERE sls_due_dt <=0
  OR len(sls_due_dt)!=8
  OR sls_due_dt >20500101
  OR sls_due_dt <20000101
  
  -- Check for invalid date orders(Orderdate>Shipping/Due Dtaes)
  -- Expectations: No Results
  SELECT 
    * 
  FROM Silver.crm_sales_details
  WHERE sls_order_dt>sls_ship_dt   
  OR sls_order_dt>sls_due_dt 
  OR sls_order_dt> sls_due_dt ; 
  
  
  -- Check Data Consistency: Sales= Price * Quantity
  -- Expectations: No Results
  SELECT distinct
  	sls_sales ,
  	sls_quantity,
  	sls_price
  FROM silver.crm_sales_details
  WHERE sls_sales!=sls_price * sls_quantity 
  OR sls_sales is null 
  OR sls_price is null 
  OR sls_quantity is null
  OR sls_sales <=0 
  OR sls_price<=0 
  OR sls_quantity <=0 
  ORDER BY sls_sales , sls_quantity, sls_price;

    
  --============================================================
  -- Checking 'silver.erp_cust_az12'
  --============================================================
  --Check for invalid dates
  -- Expectations: No Invalid Dates 
  SELECT 
    bdate 
  FROM silver.erp_CUST_AZ12 
  WHERE bdate<'1924-01-01' OR bdate>getdate()
  
  -- Check for Data Standarization & Consistency
  SELECT distinct 
  	Gen
  FROM silver.erp_CUST_AZ12

    
  --============================================================
  -- Checking 'silver.erp_loc-a101'
  --============================================================
  -- Check for Data Standarization & Consistency
  SELECT DISTINCT 
	  cntry 
  FROM silver.erp_LOC_A101;

  -- Removing '-' from CID 
  select 
    Replace(CID,'-','')
  from silver.erp_LOC_A101

  --============================================================
  -- Checking 'silver.erp_px_cat_g1v2'
  --============================================================
  -- Check for Unwanted spaces
  -- Expectations: No Results
  SELECT 
	*  
  FROM Bronze.erp_PX_CAT_G1V2
  WHERE 
  cat!=trim(cat)
  OR subcat!=TRIM(subcat)
  OR MAINTENANCEtrim!=(maintenance)

  -- Data Standarization & Consistency 
  SELECT distinct 
    maintenance
  FROM silver.erp_PX_CAT_G1V2 epcgv 
