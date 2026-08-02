use SalesDW

DELETE FROM gold.Fact_Sales;
DELETE FROM gold.Dim_Date;
DELETE FROM gold.Dim_Customer;
DELETE FROM gold.Dim_Product;
DELETE FROM gold.Dim_Employee;
DELETE FROM gold.Dim_Store;

INSERT INTO gold.Dim_Date
(
DateKey,
FullDate,
Year,
Month,
MonthName,
Quarter
)

SELECT DISTINCT

CONVERT(INT,FORMAT(SaleDate,'yyyyMMdd')),

SaleDate,

YEAR(SaleDate),

MONTH(SaleDate),

DATENAME(MONTH,SaleDate),

DATEPART(QUARTER,SaleDate)

FROM silver.Sales;



INSERT INTO gold.Dim_Customer
(
CustomerID,
CustomerName,
Gender,
Age,
City
)

SELECT DISTINCT

CustomerID,
CustomerName,
Gender,
Age,
City

FROM silver.Sales;



INSERT INTO gold.Dim_Product
(
ProductID,
ProductName,
Category,
Brand,
CostPrice
)

SELECT DISTINCT

ProductID,
ProductName,
Category,
Brand,
CostPrice

FROM silver.Sales;


INSERT INTO gold.Dim_Employee
(
EmployeeID,
EmployeeName,
Department
)

SELECT DISTINCT

EmployeeID,
EmployeeName,
Department

FROM silver.Sales;

INSERT INTO gold.Dim_Store
(
Store,
Region
)

SELECT DISTINCT

Store,
Region

FROM silver.Sales;


INSERT INTO gold.Fact_Sales
(
DateKey,
CustomerKey,
ProductKey,
EmployeeKey,
StoreKey,

Quantity,
Discount,

SellingPrice,
TotalAmount,

PaymentMethod,
OrderStatus,
DeliveryMethod
)


SELECT


D.DateKey,

C.CustomerKey,

P.ProductKey,

E.EmployeeKey,

S.StoreKey,


SLS.Quantity,

SLS.Discount,


SLS.SellingPrice,

SLS.TotalAmount,


SLS.PaymentMethod,

SLS.OrderStatus,

SLS.DeliveryMethod


FROM silver.Sales SLS


JOIN gold.Dim_Date D

ON D.FullDate = SLS.SaleDate


JOIN gold.Dim_Customer C

ON C.CustomerID = SLS.CustomerID


JOIN gold.Dim_Product P

ON P.ProductID = SLS.ProductID


JOIN gold.Dim_Employee E

ON E.EmployeeID = SLS.EmployeeID


JOIN gold.Dim_Store S

ON S.Store = SLS.Store

AND S.Region = SLS.Region;

delete from Gold.Fact_Sales 
where SalesKey between 50001 and 50017

select * from Gold.Fact_Sales
order by SalesKey

