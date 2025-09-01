-- Create Customer Dimension Table
CREATE VIEW gold.dimCustomer AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY cst_id) AS customerKey,
	ci.cst_id AS customerId,
	ci.cst_key AS customerNumber,
	ci.cst_firstname as firstName,
	ci.cst_lastname AS lastName,
	ci.cst_materialStatus AS maritalStatus,
	CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
		ELSE COALESCE(cu.gen,'n/a')
	END gender,
	ci.cst_createDate AS createDate,
	cu.bdate AS birthdayDate,
	loc.cntry AS country
FROM
	silver.CRM_custInfo ci
LEFT JOIN
	silver.ERP_custAz12 cu
ON ci.cst_key = cu.cid
LEFT JOIN
	silver.ERP_locA101 loc
ON ci.cst_key = loc.cid

-- Create Products Dimension Table
CREATE VIEW gold.dimProducts AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY prd_start_dt, prd_key) as productKey,
	pn.prd_id AS productId,
	pn.prd_key AS productNumber,
	pn.prd_nm AS productName,
	pn.cat_id AS categoryId,
	px.cat AS category,
	px.subcat AS subCategory,
	px.maintenance AS maintenence ,
	pn.prd_cost AS productCost,
	pn.prd_line AS productLine,
	pn.prd_start_dt AS startDate
FROM silver.CRM_prdInfo pn
LEFT JOIN
	silver.ERP_pxCatG1v2 px
ON pn.cat_id = px.id
WHERE pn.prd_end_dt IS NULL

-- Create Sales Fact Table
CREATE VIEW gold.factSales AS
SELECT sd.sls_ordNum AS orderNumber
      ,pr.productKey 
      ,cu.customerId
      ,sd.sls_orderDt AS orderDate
      ,sd.sls_shipDt AS shipDate
      ,sd.sls_dueDt AS dueDate
      ,sd.sls_sales AS salesAmount
      ,sd.sls_quantity AS quantity
      ,sd.sls_price AS price
  FROM silver.CRM_salesDetails sd
  LEFT JOIN gold.dimProducts pr
  ON sls_prdKey = pr.productNumber
  LEFT JOIN gold.dimCustomer cu
  ON sls_custId = cu.customerId
