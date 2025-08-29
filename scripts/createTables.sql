/*
=====================================================================
Build all DWH tables
=====================================================================
Script Purpose:
	This script will loads data from excel into bronze layer.
	It main components do the following:
	- Check if the table already created, if found then drop table
	- Create table with the defined columns

Params:
	None

Example Use:
	None
*/

IF OBJECT_ID ('bronze.CRM_custInfo','U') IS NOT NULL
	DROP TABLE bronze.CRM_custInfo
CREATE TABLE bronze.CRM_custInfo(
	cst_id INT,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_materialStatus NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_createDate NVARCHAR(50),
)

GO

IF OBJECT_ID ('bronze.CRM_prdInfo','U') IS NOT NULL
	DROP TABLE bronze.CRM_prdInfo
CREATE TABLE bronze.CRM_prdInfo(
	prd_id INT,
	prd_key NVARCHAR(50),
	prd_nm NVARCHAR(50),
	prd_cost INT,
	prd_line NVARCHAR(50),
	prd_start_dt DATETIME,
	prd_end_dt DATETIME
)

GO

IF OBJECT_ID ('bronze.CRM_salesDetails','U') IS NOT NULL
	DROP TABLE bronze.CRM_salesDetails
CREATE TABLE bronze.CRM_salesDetails(
	sls_ordNum NVARCHAR(50),
	sls_prdKey NVARCHAR(50),
	sls_custId INT,
	sls_orderDt INT,
	sls_shipDt INT,
	sls_dueDt INT,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT
)

GO

IF OBJECT_ID ('bronze.ERP_custAz12','U') IS NOT NULL
	DROP TABLE bronze.ERP_locA101
CREATE TABLE bronze.ERP_locA101(
	cid NVARCHAR(50),
	bdate DATE,
	gen NVARCHAR(50)
)

IF OBJECT_ID ('bronze.ERP_locA101','U') IS NOT NULL
	DROP TABLE bronze.ERP_locA101
CREATE TABLE bronze.ERP_locA101(
	cid NVARCHAR(50),
	cntry NVARCHAR(50),
)

GO

IF OBJECT_ID ('bronze.ERP_pxCatG1v2','U') IS NOT NULL
	DROP TABLE bronze.ERP_pxCatG1v2
CREATE TABLE bronze.ERP_pxCatG1v2(
	id NVARCHAR(50),
	cat NVARCHAR(50),
	subcat NVARCHAR(50),
	maintenance NVARCHAR(50)
)
