/*
========================================================================================
DDL Script: Create Silver Tables
========================================================================================
Script Purpose:
  This script create table in the 'silver' schema, dropping existing tables
  if they already exists.
  Run this script to re-define the DDL structure of 'silver' Tables
========================================================================================
*/

If object_id('silver.crm_cust_info','U') Is not null 
Drop table silver.crm_cust_info;

Create Table silver.crm_cust_info(
	cst_id	            INT,
	cst_key	            NVarChar(50),
	cst_firstname       NVarChar(50),
	cst_lastname        NVarChar(50),
	cst_marital_status	NVarChar(10),
	cst_gndr            NVarChar(10),
	cst_create_date     Date,
	dwh_create_date 	Datetime2 default GETDATE()
);

If object_id('silver.crm_prd_info','U') Is not null 
Drop table silver.crm_prd_info;

Create table silver.crm_prd_info(
prd_id	     		INT,
cat_id		 		VarChar(50),
prd_key	     		VarChar(50),
prd_nm	    	 	VarChar(50),
prd_cost     		INT,
prd_line     		VarChar(20),
prd_start_dt 		Date,
prd_end_dt   		Date,
dwh_create_date 	Datetime2 default GETDATE()
);

If object_id('silver.crm_sales_details','U') Is not null 
Drop table silver.crm_sales_details;

Create table silver.crm_sales_details(
sls_ord_num   	Varchar(50),
sls_prd_key	  	Varchar(50),
sls_cust_id	  	Int,
sls_order_dt  	Date,
sls_ship_dt	  	Date,
sls_due_dt	  	Date,
sls_sales     	Int,
sls_quantity  	Int,
sls_price     	Int,
dwh_create_date Datetime2 default GETDATE()
);


If object_id('silver.erp_CUST_AZ12','U') Is not null 
Drop table silver.erp_CUST_AZ12;

Create Table silver.erp_CUST_AZ12(
CID   			Varchar(30),
BDATE 			Date,
GEN    			Varchar(10),
dwh_create_date Datetime2 default GETDATE()
);


If object_id('silver.erp_LOC_A101','U') Is not null 
Drop table silver.erp_LOC_A101;

Create Table silver.erp_LOC_A101(
CID	    		Varchar(50),
CNTRY   		Varchar(30),
dwh_create_date Datetime2 default GETDATE()
);

If object_id('silver.erp_PX_CAT_G1V2','U') Is not null 
Drop table silver.erp_PX_CAT_G1V2;

Create table Silver.erp_PX_CAT_G1V2(
ID	         	  Varchar(30),
CAT	         	  Varchar(30),
SUBCAT       	  Varchar(30),
MAINTENANCE  	  Varchar(10),
dwh_create_date Datetime2  default GETDATE()
);
