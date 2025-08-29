/*
=====================================================================
Stored Procedure : Load data to Bronze Layer
=====================================================================
Script Purpose:
	This script will loads data from excel into bronze layer.
	It main components do the following:
	- Truncates bronze table before loading all data.
	- Uses Bulk Method to load data from external csv files to bronze layer tables.

Params:
	None

Example Use:
	EXEC bronze.loadBronzeLayer

*/

CREATE OR ALTER PROCEDURE bronze.loadBronzeLayer AS
BEGIN 

	DECLARE @start_time DATETIME , 
			@end_time DATETIME ,
			@batch_start_time DATETIME,
			@batch_end_time DATETIME

	BEGIN TRY
	SET @batch_start_time = GETDATE()

		PRINT '=========================='
		PRINT 'Loading Bronze Layer Data'
		PRINT '=========================='

		PRINT 'Loading CRM Data'

		SET @start_time = GETDATE()
		PRINT 'Truncating and Inserting: bronze.CRM_CustInfo'
		TRUNCATE TABLE bronze.CRM_CustInfo
		BULK INSERT bronze.CRM_CustInfo
		FROM 'C:\Penyimpanan Utama\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ','
		)
		SET @end_time = GETDATE()
		PRINT 'Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'S'

		SET @start_time = GETDATE()
		PRINT 'Truncating and Inserting: bronze.CRM_prdInfo'
		TRUNCATE TABLE bronze.CRM_prdInfo
		BULK INSERT bronze.CRM_prdInfo
		FROM 'C:\Penyimpanan Utama\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ','
		)
		SET @end_time = GETDATE()
		PRINT 'Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'S'

		SET @start_time = GETDATE()
		PRINT 'Truncating and Inserting: CRM_salesDetails'
		TRUNCATE TABLE bronze.CRM_salesDetails
		BULK INSERT bronze.CRM_salesDetails
		FROM 'C:\Penyimpanan Utama\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ','
		)
		SET @end_time = GETDATE()
		PRINT 'Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'S'

		PRINT 'Loading ERP Data'

		SET @start_time = GETDATE()
		PRINT 'Truncating and Inserting: bronze.ERP_custAz12'
		TRUNCATE TABLE bronze.ERP_custAz12
		BULK INSERT bronze.ERP_custAz12
		FROM 'C:\Penyimpanan Utama\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ','
		)
		SET @end_time = GETDATE()
		PRINT 'Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'S'

		SET @start_time = GETDATE()
		PRINT 'Truncating and Inserting: bronze.ERP_locA101'
		TRUNCATE TABLE bronze.ERP_locA101
		BULK INSERT bronze.ERP_locA101
		FROM 'C:\Penyimpanan Utama\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ','
		)
		SET @end_time = GETDATE()
		PRINT 'Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'S'

		SET @start_time = GETDATE()
		PRINT 'Truncating and Inserting: bronze.ERP_pxCatG1v2'
		TRUNCATE TABLE bronze.ERP_pxCatG1v2
		BULK INSERT bronze.ERP_pxCatG1v2
		FROM 'C:\Penyimpanan Utama\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ','
		)
		SET @end_time = GETDATE()
		PRINT 'Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'S'

	SET @batch_end_time = GETDATE()
	PRINT 'Total Duration ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + 'S'
	END TRY
	BEGIN CATCH
		PRINT '==================================================='
		PRINT 'Error Message: ' + ERROR_MESSAGE()
		PRINT 'Error Message: ' + CAST(ERROR_NUMBER() AS NVARCHAR)
		PRINT 'Error Message: ' + CAST(ERROR_STATE() AS NVARCHAR)
		PRINT '==================================================='
	END CATCH
END

EXEC bronze.loadBronzeLayer
