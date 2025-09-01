## Gold Layer
**1. gold.factSales** <br>
This table stores sales transactions (fact table) that are linked to related dimensions.
   
   |No|Column Name|Type|Length|Description
   |--|-----------|----|------|-----------|
   |1|orderNumber|NVARCHAR|50|Unique serial number to identify order|.
   |2|productKey|INT||Foreign Key to gold.dimProduct. Refers to the product being sold.|
   |3|customerId|INT||Foreign Key to gold.dimCustomer. Refers to the customer placing the order.|
   |4|orderDate|DATE||Date when the order was created.|
   |5|shipDate|DATE||Actual shipping date of the order.|
   |6|dueDate|DATE||Planned shipping/delivery due date|
   |7|salesAmount|INT||Total income from order|
   |8|quantity|INT||Total number of product units sold in the order.|
   |9|price|INT||Unit price of the product at the time of sale.|

**2. gold.dimProducts** <br>
Dimension table that stores descriptive attributes of products.  
This table acts as a reference for product-related analysis in the data warehouse.  

|No| Column Name |Type|Length|Description                                                                 |
|----|-----------------|-----------|--------|-----------------------------------------------------------------------------|
| 1  | **productKey**  | INT       |        | Surrogate key (Primary Key). Used to uniquely identify each product in the dimension table. |
| 2  | **productId**   | INT       |        | Business key or source system ID for the product (from operational system). |
| 3  | **productNumber** | NVARCHAR | 50     | Internal product code/number from source system. |
| 4  | **productName** | NVARCHAR  | 50    | Descriptive name of the product (used in reporting/analysis). |
| 5  | **categoryId**  | NVARCHAR   |    50    | Foreign Key to product category (business category ID from source). |
| 6  | **category**    | NVARCHAR  | 50    | Product’s main category. |
| 7  | **subCategory** | NVARCHAR  | 50    | Sub-division of the product category (e.g., Laptops, Chairs). |
| 8  | **maintenence** | NVARCHAR  | 50    | Indicates whether the product requires maintenance/service (Yes/No or type of maintenance). |
| 9  | **productCost** | INT   |        | Cost of producing or procuring the product (used for margin analysis). |
| 10 | **productLine** | NVARCHAR  | 50    | Grouping of products into broader product lines. |
| 11 | **startDate**   | DATE      |        | Date the product became available in the system. |

**3. gold.dimCustomer** <br>
Dimension table that stores descriptive attributes of customers.  

|No|Column Name|Type|Length|Description                                                                 |
|----|------------------|-----------|--------|-----------------------------------------------------------------------------|
| 1  | **customerKey**  | INT       |        | Surrogate key (Primary Key). Used to uniquely identify each customer in the dimension table. |
| 2  | **customerId**   | INT       |        | Business key or source system ID for the customer. |
| 3  | **customerNumber** | NVARCHAR | 50     | Unique customer code/number from the source system. |
| 4  | **firstName**    | NVARCHAR  | 50    | Customer’s first name. |
| 5  | **lastName**     | NVARCHAR  | 50    | Customer’s last name. |
| 6  | **maritalStatus** | NVARCHAR | 50     | Customer’s marital status . |
| 7  | **gender**       | NVARCHAR  | 50     | Customer’s gender. |
| 8  | **createDate**   | DATE      |        | Date the customer record was created in the source system. |
| 9  | **birthdayDate** | DATE      |        | Customer’s date of birth. |
| 10 | **country**      | NVARCHAR  | 50    | Customer’s country of residence. |
