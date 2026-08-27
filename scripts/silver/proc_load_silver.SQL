/*
======================================================================
 Stored Procedure: Load Silver Layer (Bronze -> Silver) 
======================================================================
Script Purpose: 
  This stored procedure performs ETL(Extract, Transform, Load) process to populate the 'silver' schema tables from 'bronze' schema.
  It performs the following actions:
  -Truncates the Silver tables before loading data.
  -Insert transformed and cleansed data from Bronze into Silver tables.
  
  Parameters:
    None.
    This is stored procedure does not accept any parameter or return any values.

Usage Example: 
  Exec silver.load_bronze;
======================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_procedure AS
BEGIN
	Declare @start_time datetime, @end_time datetime,@batch_start_time datetime;
	Begin Try
 	  Set @batch_start_time=getdate()
		print'===========================================';
		print'We are loading silver layer ';
		print'===========================================';
		
		print'--------------------------------------------';
		print' Loading CRM Tables';
		print'--------------------------------------------';
		
		Set @start_time=getdate();
		print'>>Truncating Table: silver.crm_cust_info';
		Truncate table silver.crm_cust_info ;
		print'>> Inserting Data Into: silver.crm_cust_info';
		insert into silver.crm_cust_info (
			cst_id,
			cst_key,
			cst_firstname,
			cst_lastname,
			cst_marital_status,
			cst_gndr,
			cst_create_date
		)
		select
		cst_id,
		cst_key,
		trim(cst_firstname) as cst_firstname,
		trim(cst_lastname) as cst_lastname,
		case
			when upper(trim(cst_marital_status))='S' then 'Single'
			when upper(trim(cst_marital_status))='M' then 'Married'
			else 'n/a'
		end as cst_marital_status,
		case
			when upper(trim(cst_gndr))='F' then 'Female'
			when upper(trim(cst_gndr))='M' then 'Male'
		end as cst_gndr,
		cst_create_date
		from(
			select *,
				Row_Number()over (partition by cst_id order by cst_create_date) as flag_last
				from bronze.crm_cust_info
				where cst_id is not null
		)t
		where t.flag_last=1;
		
		set @end_time=getdate();
		print'>> Load time: ' + cast(datediff(second,@start_time,@end_time) as Varchar)+' seconds';
		print'>>-------------------------'
		
		set @start_time=getdate()
		print'>>Truncating Table: silver.crm_prd_info';
		Truncate table silver.crm_prd_info ;
		print'>> Inserting Data Into: silver.crm_prd_info';
		Insert into Silver.crm_prd_info(
			prd_id,
			cat_id,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt
		)
		Select 
		prd_id,
		replace(SUBSTRING(prd_key,1,5),'-','_') as cat_id, --Extract category ID
		SUBSTRING(prd_key,7,len(prd_key)) as prd_key,	   --Extract product Key
		prd_nm,
		isnull(prd_cost,0) prd_cost,
		case Upper(trim(prd_line))
			when 'M' then 'Mountain'
			when 'R' then 'Road'
			when 'S' then 'Other sales'
			when 'T' then 'Touring'
			else 'n/a'			
		end as prd_line,	--Map Product line codes to descriptive values
		prd_start_dt,
		dateadd(day,-1,lead(prd_start_dt) --Calculate end date as one day before the next start date
		over(partition by prd_key 
			 order by prd_start_dt)) as prd_end_dt
		from Bronze.crm_prd_info
		order by prd_key;
		set @end_time=getdate();
		print'>> Load time: ' + cast(datediff(second,@start_time,@end_time) as Varchar)+' seconds';
		print'>>-------------------------'
		
		
		set @start_time=getdate();
		print'>>Truncating Table: silver.crm_sales_details';
		Truncate table silver.crm_sales_details;
		print'>> Inserting Data Into: silver.crm_sales_details';
		insert INTO  silver.crm_sales_details(
			sls_ord_num  , 	
			sls_prd_key	  ,	
			sls_cust_id	  ,	
			sls_order_dt  ,	
			sls_ship_dt	  ,	
			sls_due_dt	  ,	
			sls_sales     ,	
			sls_quantity  ,	
			sls_price     	
		)
		select 
		sls_ord_num,
		sls_prd_key ,
		sls_cust_id ,
		case 
			when sls_order_dt=0 or len(sls_order_dt)!=8 then NULL
			 else convert(Date,cast(sls_order_dt as VArChar)) 
		end as sls_order_dt,
		case 
			when sls_ship_dt =0 or len(sls_ship_dt)!=8 then NULL
			 else convert(Date,cast(sls_ship_dt as VArChar)) 
		end as sls_ship_dt ,
		case 
			when sls_due_dt=0 or len(sls_due_dt)!=8 then NULL
			 else convert(Date,cast(sls_due_dt as VArChar)) 
		end as  sls_due_dt ,
		case 
			when sls_sales is null or sls_sales=0 or sls_sales!= ABS(sls_price)*sls_quantity
			then ABS(sls_price)*sls_quantity
			else sls_sales
		end as sls_sales,
		sls_quantity ,
		CASE 
			when sls_price<=0 or sls_price is null 
			then sls_sales/nullif(sls_quantity,0)
			else sls_price
		END as sls_price
		from Bronze.crm_sales_details;
		set @end_time=getdate();
		print'>> Load time: ' + cast(datediff(second,@start_time,@end_time) as Varchar)+' seconds';
		print'>>-------------------------';
		
		print'--------------------------------------------';
		print' Loading ERP Tables';
		print'--------------------------------------------';
		
		set @start_time=getdate();
		print'>>Truncating Table: silver.erp_CUST_AZ12';
		Truncate table silver.erp_CUST_AZ12 ;
		print'>> Inserting Data Into: silver.erp_CUST_AZ12';
		insert into Silver.erp_CUST_AZ12 (cid,Bdate,gen)
		select 
		case
			when cid like 'NAS%' then SUBSTRING(cid,4,len(cid))--Remove 'NAS' prefix if present 
			else cid
		end as cid,
		CASE
			when bdate>getdate() then NULL 
			else bdate
		END as bdate, -- Set future birthdates to NULL
		case 
			when upper(trim(REPLACE(gen, CHAR(13), ''))) in ('F','Female') then 'Female'
			when upper(trim(REPLACE(gen, CHAR(13), ''))) in ('M','Male') then 'Male'
			else 'n/a'
		end as gen -- Normalize gender Values and handle unknwon cases
		from bronze.erp_cust_AZ12;
		set @end_time=getdate();
		print'>> Load time: ' + cast(datediff(second,@start_time,@end_time) as Varchar)+' seconds';
		print'>>-------------------------';
		
		set @start_time=getdate();
		print'>>Truncating Table: silver.erp_loc_a101';
		Truncate table silver.erp_loc_a101 ;
		print'>> Inserting Data Into: silver.erp_loc_a101';
		insert into silver.erp_loc_a101(cid,cntry)
		select 
		Replace(CID,'-','') as CID,
		CASE
		 WHEN TRIM(REPLACE(cntry, CHAR(13), '')) IN ('USA', 'US') THEN 'United States'
		 WHEN TRIM(REPLACE(cntry, CHAR(13), '')) IN ('DE', 'GERMANY') THEN 'Germany'
		 WHEN TRIM(REPLACE(cntry, CHAR(13), '')) = '' OR cntry IS NULL THEN 'n/a'
		 ELSE TRIM(REPLACE(cntry, CHAR(13), ''))
		END AS CNTRY
		from Bronze.erp_LOC_A101 ;
		set @end_time=getdate();
		print'>> Load time: ' + cast(datediff(second,@start_time,@end_time) as Varchar)+' seconds';
		print'>>-------------------------';
		
		set @start_time=getdate()
		insert into silver.erp_PX_CAT_G1V2 (
		ID,CAT,subcat,maintenance)
		select 
		ID,
		CAT,
		Subcat,
		replace(maintenance,char(13),'') as MAINTENANCE 
		from Bronze.erp_PX_CAT_G1V2;
	
		set @end_time=getdate();
		print'>> Load time: ' + cast(datediff(second,@start_time,@end_time) as Varchar)+' seconds';
		print'>>-------------------------';
		
		Print'==================================';
		set @end_time=getdate()
		print'>> Load time of whole silver layer is completed:'
		print'>> Load time:' + cast(datediff(second,@batch_start_time,@end_time) as Varchar) + ' seconds'
		print'>>-------------------------'
		Print'==================================';
	End try
	Begin Catch
		Print'==================================';
		print'Error Occured during loading Silver layer';
		print'Error Message' + Error_Message();
		print'Error Number' + cast(Error_number() as varchar);
		print'Error State' + cast(Error_state() as varchar);
		Print'==================================';
	End Catch
END
