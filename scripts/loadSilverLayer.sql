/*
=====================================================================
Insert CRM_custInfo from bronze to silver layer
=====================================================================
Script Purpose:
	This script will transform and insert bronze layer data to silver
	It main components do the following:
	- Check the data, and transform according standard business rule 
	- Insert data to silver layer table

Params:
	None

Example Use:
	EXEC silver.CRM_custInfo
*/

CREATE OR ALTER PROCEDURE silver.load_CRM_custInfo AS
BEGIN
	DECLARE @start_time DATETIME,
			@end_time DATETIME

	BEGIN TRY
	SET @start_time = GETDATE()

		PRINT '=========================='
		PRINT 'Loading silver.CRM_custInfo'
		PRINT '=========================='

	TRUNCATE TABLE silver.CRM_custInfo
	INSERT INTO silver.CRM_custInfo (
	   [cst_id]
      ,[cst_key]
      ,[cst_firstname]
      ,[cst_lastname]
      ,[cst_materialStatus]
      ,[cst_gndr]
      ,[cst_createDate]
      ,[dwh_loadDate] )

	SELECT 
		[cst_id]
      ,[cst_key]
	  ,TRIM(cst_firstname)
	  ,TRIM(cst_lastname)
	  ,CASE WHEN UPPER(TRIM(cst_materialStatus)) = 'S' THEN 'Single'
     		WHEN UPPER(TRIM(cst_materialStatus)) = 'M' THEN 'Married' 
			ELSE 'n/a'
		END cst_materialStatus
	  ,CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
			WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male' 
			ELSE 'n/a'
		END cst_gndr
      ,[cst_createDate]
	  ,CAST(GETDATE() AS datetime2) AS [dwh_loadDate]

		FROM (
			SELECT 
				cst_id,
				cst_key,
				cst_firstname,
				cst_lastname,
				cst_materialStatus,
				cst_gndr,
				cst_createDate,
				ROW_NUMBER() OVER(PARTITION BY cst_key ORDER BY cst_createDate DESC) AS rn
			FROM bronze.CRM_custInfo
		) t
		WHERE rn = 1;
		
	SET @end_time = GETDATE()
	PRINT 'Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'S'
	END TRY
	BEGIN CATCH
		PRINT '==================================================='
		PRINT 'Error Message: ' + ERROR_MESSAGE()
		PRINT 'Error Message: ' + CAST(ERROR_NUMBER() AS NVARCHAR)
		PRINT 'Error Message: ' + CAST(ERROR_STATE() AS NVARCHAR)
		PRINT '==================================================='
	END CATCH
END
GO

/*
=====================================================================
Insert CRM_prdInfo from bronze to silver layer
=====================================================================
Script Purpose:
	This script will transform and insert bronze layer data to silver
	It main components do the following:
	- Check the data, and transform according standard business rule 
	- Insert data to silver layer table

Params:
	None

Example Use:
	EXEC silver.CRM_prdInfo
*/

CREATE OR ALTER PROCEDURE silver.load_CRM_prdInfo AS
BEGIN
	DECLARE @start_time DATETIME,
			@end_time DATETIME

	BEGIN TRY
	SET @start_time = GETDATE()

		PRINT '=========================='
		PRINT 'Loading silver.CRM_prdInfo'
		PRINT '=========================='

	TRUNCATE TABLE silver.CRM_prdInfo
	INSERT INTO silver.CRM_prdInfo (
	   prd_id
	  ,cat_id
      ,prd_key
      ,prd_nm
      ,prd_cost
      ,prd_line
      ,prd_start_dt
      ,prd_end_dt
      ,dwh_loadDate )

	SELECT 
	   [prd_id]
      ,REPLACE(SUBSTRING(prd_key, 1,5),'-', '_') AS cat_id
      ,SUBSTRING(prd_key,7,LEN(prd_key)) AS prd_key
      ,[prd_nm]
      ,ISNULL(prd_cost, 0) AS prd_cost
      ,CASE WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
            WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountaion'
            WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
            WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
            ELSE 'n/a'
        END prd_line
      ,CAST(prd_start_dt AS DATE) AS prd_start_dt
      ,CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) -1 AS DATE)AS prd_end_dt
	  ,CAST(GETDATE() AS datetime) AS dwh_loadDate


	 FROM bronze.CRM_prdInfo
		
	SET @end_time = GETDATE()
	PRINT 'Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'S'
	END TRY
	BEGIN CATCH
		PRINT '==================================================='
		PRINT 'Error Message: ' + ERROR_MESSAGE()
		PRINT 'Error Message: ' + CAST(ERROR_NUMBER() AS NVARCHAR)
		PRINT 'Error Message: ' + CAST(ERROR_STATE() AS NVARCHAR)
		PRINT '==================================================='
	END CATCH
END
GO

/*
=====================================================================
Insert CRM_salesDetails from bronze to silver layer
=====================================================================
Script Purpose:
	This script will transform and insert bronze layer data to silver
	It main components do the following:
	- Check the data, and transform according standard business rule 
	- Insert data to silver layer table

Params:
	None

Example Use:
	EXEC silver.CRM_salesDetails
*/

CREATE OR ALTER PROCEDURE silver.load_CRM_salesDetails AS
BEGIN
	DECLARE @start_time DATETIME,
			@end_time DATETIME

	BEGIN TRY
	SET @start_time = GETDATE()

		PRINT '=========================='
		PRINT 'Loading silver.CRM_salesDetails'
		PRINT '=========================='

	TRUNCATE TABLE silver.CRM_salesDetails
	INSERT INTO silver.CRM_salesDetails (
	   sls_ordNum
	  ,sls_prdKey
      ,sls_custId
      ,sls_orderDt
      ,sls_shipDt
      ,sls_dueDt
      ,sls_sales
      ,sls_quantity
	  ,sls_price
      ,dwh_loadDate )

	SELECT
	   [sls_ordNum]
      ,[sls_prdKey]
      ,[sls_custId]
      ,CASE WHEN sls_orderDt = 0 OR LEN(sls_orderDt) != 8 THEN NULL
            ELSE CAST(CONVERT(CHAR(8),sls_orderDt) AS DATE) 
            END sls_orderDt
      ,CASE WHEN sls_shipDt = 0 OR LEN(sls_shipDt) != 8 THEN NULL
            ELSE CAST(CONVERT(CHAR(8),sls_shipDt) AS DATE) 
            END sls_shipDt
      ,CASE WHEN sls_dueDt = 0 OR LEN(sls_dueDt) != 8 THEN NULL
            ELSE CAST(CONVERT(CHAR(8),sls_dueDt) AS DATE) 
            END sls_dueDt
      ,CASE WHEN sls_sales <= 0 OR sls_sales != sls_quantity  * ABS(sls_price) THEN sls_quantity * ABS(sls_price) 
            ELSE sls_sales
            END sls_sales
      ,[sls_quantity]
      ,CASE WHEN sls_price <= 0 OR sls_sales IS NULL THEN sls_sales / NULLIF(sls_quantity,0)
            ELSE sls_price
            END sls_price
	  ,CAST(GETDATE() AS datetime) AS dwh_loadDate
  
	 FROM bronze.CRM_salesDetails
   	
	SET @end_time = GETDATE()
	PRINT 'Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'S'
	END TRY
	BEGIN CATCH
		PRINT '==================================================='
		PRINT 'Error Message: ' + ERROR_MESSAGE()
		PRINT 'Error Message: ' + CAST(ERROR_NUMBER() AS NVARCHAR)
		PRINT 'Error Message: ' + CAST(ERROR_STATE() AS NVARCHAR)
		PRINT '==================================================='
	END CATCH
END
GO

/*
=====================================================================
Insert ERP_custAz12 from bronze to silver layer
=====================================================================
Script Purpose:
	This script will transform and insert bronze layer data to silver
	It main components do the following:
	- Check the data, and transform according standard business rule 
	- Insert data to silver layer table

Params:
	None

Example Use:
	EXEC silver.ERP_custAz12
*/

CREATE OR ALTER PROCEDURE silver.load_ERP_custAz12 AS
BEGIN
	DECLARE @start_time DATETIME,
			@end_time DATETIME

	BEGIN TRY
	SET @start_time = GETDATE()

		PRINT '=========================='
		PRINT 'Loading silver.ERP_custAz12'
		PRINT '=========================='

	TRUNCATE TABLE silver.ERP_custAz12
	INSERT INTO silver.ERP_custAz12 (
		 CID
		,BDATE
		,GEN
		,dwh_loadDate )

	SELECT 
		   CASE WHEN CID LIKE 'NAS%' THEN SUBSTRING([CID],4,LEN(CID))
		   ELSE CID
		   END CID
		  ,CASE WHEN BDATE > GETDATE() THEN NULL
		   ELSE BDATE
		   END BDATE
		  ,CASE WHEN UPPER(TRIM(GEN)) IN ('F', 'FEMALE') THEN 'Female'
				WHEN UPPER(TRIM(GEN)) IN ('M', 'MALE') THEN 'Male'
			ELSE 'n/a'
			END GEN
		  ,CAST(GETDATE() AS datetime) AS dwh_loadDate
  
	 FROM bronze.ERP_custAz12
   	
	SET @end_time = GETDATE()
	PRINT 'Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'S'
	END TRY
	BEGIN CATCH
		PRINT '==================================================='
		PRINT 'Error Message: ' + ERROR_MESSAGE()
		PRINT 'Error Message: ' + CAST(ERROR_NUMBER() AS NVARCHAR)
		PRINT 'Error Message: ' + CAST(ERROR_STATE() AS NVARCHAR)
		PRINT '==================================================='
	END CATCH
END
GO

/*
=====================================================================
Insert ERP_locA101 from bronze to silver layer
=====================================================================
Script Purpose:
	This script will transform and insert bronze layer data to silver
	It main components do the following:
	- Check the data, and transform according standard business rule 
	- Insert data to silver layer table

Params:
	None

Example Use:
	EXEC silver.ERP_locA101
*/

CREATE OR ALTER PROCEDURE silver.load_ERP_locA101 AS
BEGIN
	DECLARE @start_time DATETIME,
			@end_time DATETIME

	BEGIN TRY
	SET @start_time = GETDATE()

		PRINT '=========================='
		PRINT 'Loading silver.ERP_locA101'
		PRINT '=========================='

	TRUNCATE TABLE silver.ERP_locA101
	INSERT INTO silver.ERP_locA101 (
		 CID
		,CNTRY
		,dwh_loadDate )

	SELECT REPLACE(CID, '-','') AS CID
		  ,CASE WHEN CNTRY = 'DE' THEN 'Germany'
				WHEN CNTRY = 'USA' THEN 'United States'
				WHEN CNTRY IS NULL OR CNTRY = '' THEN 'n/a'
			ELSE CNTRY
			END CNTRY
		  ,CAST(GETDATE() AS datetime) AS dwh_loadDate
  
	 FROM bronze.ERP_locA101
   	
	SET @end_time = GETDATE()
	PRINT 'Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'S'
	END TRY
	BEGIN CATCH
		PRINT '==================================================='
		PRINT 'Error Message: ' + ERROR_MESSAGE()
		PRINT 'Error Message: ' + CAST(ERROR_NUMBER() AS NVARCHAR)
		PRINT 'Error Message: ' + CAST(ERROR_STATE() AS NVARCHAR)
		PRINT '==================================================='
	END CATCH
END
GO

/*
=====================================================================
Insert ERP_pxCatG1v2 from bronze to silver layer
=====================================================================
Script Purpose:
	This script will transform and insert bronze layer data to silver
	It main components do the following:
	- Check the data, and transform according standard business rule 
	- Insert data to silver layer table

Params:
	None

Example Use:
	EXEC silver.ERP_pxCatG1v2
*/

CREATE OR ALTER PROCEDURE silver.load_ERP_pxCatG1v2 AS
BEGIN
	DECLARE @start_time DATETIME,
			@end_time DATETIME

	BEGIN TRY
	SET @start_time = GETDATE()

		PRINT '=========================='
		PRINT 'Loading silver.ERP_pxCatG1v2'
		PRINT '=========================='

	TRUNCATE TABLE silver.ERP_pxCatG1v2
	INSERT INTO silver.ERP_pxCatG1v2 (
		 id
		,cat
		,subcat
		,maintenance
		,dwh_loadDate )

	SELECT 		 
		id
		,cat
		,subcat
		,maintenance
		  ,CAST(GETDATE() AS datetime) AS dwh_loadDate
  
	 FROM bronze.ERP_pxCatG1v2
   	
	SET @end_time = GETDATE()
	PRINT 'Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'S'
	END TRY
	BEGIN CATCH
		PRINT '==================================================='
		PRINT 'Error Message: ' + ERROR_MESSAGE()
		PRINT 'Error Message: ' + CAST(ERROR_NUMBER() AS NVARCHAR)
		PRINT 'Error Message: ' + CAST(ERROR_STATE() AS NVARCHAR)
		PRINT '==================================================='
	END CATCH
END
GO
