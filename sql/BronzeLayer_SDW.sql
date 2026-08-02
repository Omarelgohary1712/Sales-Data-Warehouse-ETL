use SalesDW

TRUNCATE TABLE bronze.BSales;


BULK INSERT bronze.BSales
FROM 'C:\Users\HP\Downloads\sales_data_50000_clean.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);
