create database SalesDW

use SalesDW

create schema Bronze
create schema Silver
create schema Gold

--Bronze Layer-----------------------------------------------------------------------
DROP TABLE  bronze.BSales
create table bronze.BSales(
    SaleID INT PRIMARY KEY,

    SaleDate DATE,

    CustomerID INT,
    CustomerName NVARCHAR(100),
    Gender NVARCHAR(10),
    Age TINYINT,
    City NVARCHAR(50),

    ProductID INT,
    ProductName NVARCHAR(100),
    Category NVARCHAR(50),
    Brand NVARCHAR(50),
    CostPrice DECIMAL(10,2),
    SellingPrice DECIMAL(10,2),

    EmployeeID INT,
    EmployeeName NVARCHAR(100),
    Department NVARCHAR(50),

    Quantity TINYINT,
    Discount TINYINT,

    PaymentMethod NVARCHAR(20),

    Store NVARCHAR(50),
    Region NVARCHAR(20),

    OrderStatus NVARCHAR(20),
    DeliveryMethod NVARCHAR(20),

    TotalAmount DECIMAL(12,2)
);
select * from Bronze.BSales


--Silver Layer---------------------------------------------------------------
drop table Silver.SSales
CREATE TABLE silver.Sales (
    SaleID INT PRIMARY KEY,

    SaleDate DATE NOT NULL,

    CustomerID INT NOT NULL,
    CustomerName NVARCHAR(100) NOT NULL,
    Gender NVARCHAR(10) NULL,
    Age TINYINT NULL,
    City NVARCHAR(50) NULL,

    ProductID INT NOT NULL,
    ProductName NVARCHAR(100) NOT NULL,
    Category NVARCHAR(50) NOT NULL,
    Brand NVARCHAR(50) NOT NULL,
    CostPrice DECIMAL(10,2) NULL,
    SellingPrice DECIMAL(10,2) NOT NULL,

    EmployeeID INT NOT NULL,
    EmployeeName NVARCHAR(100) NOT NULL,
    Department NVARCHAR(50) NOT NULL,

    Quantity TINYINT NULL,
    Discount TINYINT NOT NULL DEFAULT 0,

    PaymentMethod NVARCHAR(20) NOT NULL,

    Store NVARCHAR(50) NOT NULL,
    Region NVARCHAR(20) NOT NULL,

    OrderStatus NVARCHAR(20) NOT NULL,
    DeliveryMethod NVARCHAR(20) NOT NULL,

    TotalAmount DECIMAL(12,2) NOT NULL
);



----Gold Layer-------------------------------------------------------------

CREATE TABLE gold.Dim_Date (
    DateKey INT PRIMARY KEY,
    FullDate DATE NOT NULL,
    Year INT,
    Month INT,
    MonthName NVARCHAR(20),
    Quarter INT
);


CREATE TABLE gold.Dim_Customer (
    CustomerKey INT IDENTITY(1,1) PRIMARY KEY,

    CustomerID INT,
    CustomerName NVARCHAR(100),
    Gender NVARCHAR(10),
    Age TINYINT,
    City NVARCHAR(50)
);

CREATE TABLE gold.Dim_Product (
    ProductKey INT IDENTITY(1,1) PRIMARY KEY,

    ProductID INT,
    ProductName NVARCHAR(100),
    Category NVARCHAR(50),
    Brand NVARCHAR(50),
    CostPrice DECIMAL(10,2)
);

CREATE TABLE gold.Dim_Employee (
    EmployeeKey INT IDENTITY(1,1) PRIMARY KEY,

    EmployeeID INT,
    EmployeeName NVARCHAR(100),
    Department NVARCHAR(50)
);

CREATE TABLE gold.Dim_Store (
    StoreKey INT IDENTITY(1,1) PRIMARY KEY,

    Store NVARCHAR(50),
    Region NVARCHAR(20)
);

CREATE TABLE gold.Fact_Sales (

    SalesKey INT IDENTITY(1,1) PRIMARY KEY,

    DateKey INT,
    CustomerKey INT,
    ProductKey INT,
    EmployeeKey INT,
    StoreKey INT,


    Quantity TINYINT,
    Discount TINYINT,

    SellingPrice DECIMAL(10,2),
    TotalAmount DECIMAL(12,2),

    PaymentMethod NVARCHAR(20),
    OrderStatus NVARCHAR(20),
    DeliveryMethod NVARCHAR(20),


    FOREIGN KEY (DateKey)
    REFERENCES gold.Dim_Date(DateKey),

    FOREIGN KEY (CustomerKey)
    REFERENCES gold.Dim_Customer(CustomerKey),

    FOREIGN KEY (ProductKey)
    REFERENCES gold.Dim_Product(ProductKey),

    FOREIGN KEY (EmployeeKey)
    REFERENCES gold.Dim_Employee(EmployeeKey),

    FOREIGN KEY (StoreKey)
    REFERENCES gold.Dim_Store(StoreKey)
);


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



