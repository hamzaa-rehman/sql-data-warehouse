/*
====================================================
 Create Database and Schemas
====================================================
Script Purpose:
	This script creates a new database named'DataWareHouse'after checking if it already exists.
	If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas 
	within the database: 'Bronze', 'Silver', 'Gold'.
	
Warning:
	Running this script will drop entire 'DataWareHouse' database if it exists.
	All data in the database will be permanently deleted. Proceed with caution
	and ensure you have proper backups before running this script.
*/

Use master;

--Drop and recreate the 'DataWareHouse' database
If Exists(Select 1 from sys.databases where name= 'DataWareHouse')
begin
	Alter Database datawarehouse set single_user with rollback immediate;
	drop database datawarehouse;
end;

--Create the'DataWarehouse' Database
Create Database DataWarehouse;

Use DataWarehouse;

--Create Schemas 
Create Schema Bronze;

Create schema Silver;

Create schema Gold;



