/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs quality checks to validate the integrity, consistency, 
    and accuracy of the Gold Layer. These checks ensure:
    - Uniqueness of surrogate keys in dimension tables.
    - Referential integrity between fact and dimension tables.
    - Validation of relationships in the data model for analytical purposes.

Usage Notes:
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

-- ====================================================================
-- Checking 'gold.dim_customers'
-- ====================================================================
-- Check for Uniqueness of Customer Key in gold.dim_customers
-- Expectation: No results 
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

---- Check quality after cretaing view

SELECT DISTINCT
  gender 
FROM gold.dim_customers 

-- ====================================================================
-- Checking 'gold.product_key'
-- ====================================================================
-- Check for Uniqueness of Product Key in gold.dim_products
-- Expectation: No results 
SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

---- Check quality after cretaing view

SELECT DISTINCT
  gender 
FROM gold.dim_products

-- ====================================================================
-- Checking 'gold.fact_sales'
-- ====================================================================
-- Check the data model connectivity between fact and dimensions
-- Check Foreign key integrity (Dimensions)
SELECT *
FROM Gold.fact_sales f
WHERE NOT EXISTS (
    SELECT 1
    FROM Gold.dim_customers dc
    WHERE dc.customer_key = f.customer_key
);

SELECT *
FROM Gold.fact_sales f
WHERE NOT EXISTS (
    SELECT 1
    FROM Gold.dim_products pr
    WHERE pr.product_key = f.product_key
);

---- Check quality after cretaing view

SELECT DISTINCT
  gender 
FROM gold.fact_sales 
