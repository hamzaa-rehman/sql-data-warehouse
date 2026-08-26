/*
========================================================================================
DDL Script: Create Bronze Tables
========================================================================================
Script Purpose:
  This script create table in the 'bronze' schema, dropping existing tables
  if they already exists.
  Run this script to re-define the DDL structure of 'bronze' Tables
========================================================================================
*/
If object_id('bronze.crm_cust_info','U') Is not null 
Drop table bronze.crm_cust_info;

Create Table bronze.crm_cust_info(
	cst_id	            INT,
	cst_key	            NVarChar(50),
	cst_firstname       NVarChar(50),
	cst_lastname        NVarChar(50),
	cst_marital_status	NVarChar(1),
	cst_gndr            NVarChar(1),
	cst_create_date     Date
);

If object_id('bronze.crm_prd_info','U') Is not null 
Drop table bronze.crm_prd_info;

Create table bronze.crm_prd_info(
prd_id	     INT,
prd_key	     VarChar(50),
prd_nm	     VarChar(50),
prd_cost     INT,
prd_line     VarChar(10),
prd_start_dt Date,
prd_end_dt   Date
);

If object_id('bronze.crm_sales_details','U') Is not null 
Drop table bronze.crm_sales_details;

Create table bronze.crm_sales_details(
sls_ord_num   Varchar(50),
sls_prd_key	  Varchar(50),
sls_cust_id	  Int,
sls_order_dt  Int,
sls_ship_dt	  Int,
sls_due_dt	  Int,
sls_sales     Int,
sls_quantity  Int,
sls_price     Int
);


If object_id('bronze.erp_CUST_AZ12','U') Is not null 
Drop table bronze.erp_CUST_AZ12;

Create Table bronze.erp_CUST_AZ12(
CID    Varchar(30),
BDATE  Date,
GEN    Varchar(10)
);


If object_id('bronze.erp_LOC_A101','U') Is not null 
Drop table bronze.erp_LOC_A101;

Create Table bronze.erp_LOC_A101(
CID	    Varchar(50),
CNTRY   Varchar(30)
);

If object_id('bronze.erp_PX_CAT_G1V2','U') Is not null 
Drop table bronze.erp_PX_CAT_G1V2;

Create table Bronze.erp_PX_CAT_G1V2(
ID	         Varchar(30),
CAT	         Varchar(30),
SUBCAT       Varchar(30),
MAINTENANCE  Varchar(10)
); 
