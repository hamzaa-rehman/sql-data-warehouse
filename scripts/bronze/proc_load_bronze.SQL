/*
======================================================================
 Stored Procedure: Load Bronze Layer (Source -> Bronze) 
======================================================================
Script Purpose: 
  This stored procedure loads data into the 'bronze' schema from external CSV files.
  It performs the following actions:
  -Truncates the bronze tables before loading data.
  -Uses the `Bulk Insert` command to load data from CSV Files to bronze tables.

Parameters:
  None.
 This is stored procedure does not accept any parameter or return any values.

Usage Example: 
  Exec bronze.load_bronze;
======================================================================
*/

Create or alter procedure bronze.load_bronze AS
Begin
	Declare @start_time datetime, @end_time datetime,@batch_start_time datetime
	Begin Try
 	    set @batch_start_time=getdate()
		print'===========================================';
		print('We are loading bronze layer ');
		print'===========================================';
		
		print'--------------------------------------------';
		print' Loading CRM Tables';
		print'--------------------------------------------';
		
		Set @start_time=getdate();
		print'>> Truncating Table: Bronze.crm_cust_info';
		Truncate Table Bronze.crm_cust_info;
		 
		print'>> Inserting Data into: Bronze.crm_cust_info';
		BULK INSERT Bronze.crm_cust_info
		FROM '/tmp/cust_info.csv'
		WITH
		(
		    FIRSTROW = 2,
		    FIELDTERMINATOR = ',',
		    TABLOCK
		);
		set @end_time=getdate();
		
		print'>> Load time: ' + cast(datediff(second,@start_time,@end_time) as Varchar)+' seconds';
		print'>>-------------------------'
		
		Set @start_time=getdate();
		print'>> Truncating Table: bronze.crm_prd_info';
		Truncate table bronze.crm_prd_info;
		
		print'>> Inserting data into: bronze.crm_prd_info';
		Bulk insert bronze.crm_prd_info
		from '/tmp/prd_info.csv'
		WITH
		(
		    FIRSTROW = 2,
		    FIELDTERMINATOR = ',',
		    TABLOCK
		    );
		set @end_time=getdate();
		
		print'>> Load time: ' + cast(datediff(second,@start_time,@end_time) as Varchar)+' seconds';
		print'>>-------------------------'
		
		Set @start_time=getdate();
		print'>> Truncating Table: bronze.crm_sales_details';
		Truncate table bronze.crm_sales_details;
		print'>> Inserting data into: bronze.crm_sales_details';
		Bulk insert bronze.crm_sales_details
		from '/tmp/sales_details.csv'
		WITH
		(
		    FIRSTROW = 2,
		    FIELDTERMINATOR = ',',
		    TABLOCK
		    );
		
			set @end_time=getdate();
		
		print'>> Load time: ' + cast(datediff(second,@start_time,@end_time) as Varchar)+' seconds';
		print'>>-------------------------'
		
		print'--------------------------------------------';
		print' Loading ERP Tables';
		print'--------------------------------------------';
		
		Set @start_time=getdate();
				
		print'>> Truncating Table: bronze.erp_CUST_AZ12';
		Truncate table bronze.erp_CUST_AZ12;
		print'>> Inserting data into: bronze.erp_CUST_AZ12';
		Bulk insert bronze.erp_CUST_AZ12
		from '/tmp/CUST_AZ12.csv'
		WITH
		(
		    FIRSTROW = 2,
		    FIELDTERMINATOR = ',',
		    tablock
		    );
		
		set @end_time=getdate();
		
		print'>> Load time: ' + cast(datediff(second,@start_time,@end_time) as Varchar)+' seconds';
		print'>>-------------------------'
		
		Set @start_time=getdate();
		print'>> Truncating Table: bronze.erp_LOC_A101';
		
		Truncate table bronze.erp_LOC_A101;
		print'>> Inserting data into: bronze.erp_LOC_A101';
		Bulk insert bronze.erp_LOC_A101
		from '/tmp/LOC_A101.csv'
		WITH
		(
		    FIRSTROW = 2,
		    FIELDTERMINATOR = ',',
		    tablock
		    );
		set @end_time=getdate();
		
		print'>> Load time: ' + cast(datediff(second,@start_time,@end_time) as Varchar)+' seconds';
		print'>>-------------------------'
		
		Set @start_time=getdate();
		print'>> Truncating Table: bronze.erp_PX_CAT_G1V2';
		Truncate table bronze.erp_PX_CAT_G1V2;
		print'>> Inserting data into: bronze.erp_PX_CAT_G1V2';
		Bulk insert bronze.erp_PX_CAT_G1V2
		from '/tmp/PX_CAT_G1V2.csv'
		WITH
		(
		    FIRSTROW = 2,
		    FIELDTERMINATOR = ',',
		    tablock
		    );
			set @end_time=getdate();
		
		print'>> Load time: ' + cast(datediff(second,@start_time,@end_time) as Varchar)+' seconds';
		print'>>-------------------------'
		
		Print'==================================';
		set @end_time=getdate()
		print'>> Load time of whole bronze layer is completed:'
		print'>> Load time:' + cast(datediff(second,@batch_start_time,@end_time) as Varchar) + ' seconds'
		print'>>-------------------------'
		Print'==================================';
		
	End try	
	Begin Catch
		Print'==================================';
		print'Error Occured during loading Bronze layer';
		print'Error Message' + Error_Message();
		print'Error Number' + cast(Error_number() as varchar);
		print'Error State' + cast(Error_state() as varchar);
	
		Print'==================================';
	End catch
End;

EXEC bronze.load_bronze;
