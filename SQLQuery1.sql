-- Online Retail Data Analysis SQL Script

-- Introduction:
-- This SQL script performs data cleaning, transformation, and analysis on an online retail dataset.
-- The dataset contains information about customer transactions, products, and sales.

-- Dataset Description:
-- The online_retail table includes columns such as InvoiceNo, StockCode, Description, Quantity,
-- UnitPrice, CustomerID, InvoiceDate, and Country.

-- 1. Update NULL Description values to "None"

UPDATE online_retail
SET Description = 'None'
WHERE Description IS NULL;

-- 2. Remove ".0" from the end of CustomerID values

UPDATE online_retail
SET CustomerID = SUBSTRING(CustomerID, 1, LEN(CustomerID) - 2)
WHERE CustomerID LIKE '%.0';

-- 3. Convert CustomerID to INT data type

ALTER TABLE online_retail
ALTER COLUMN CustomerID INT;

-- 4. Update NULL CustomerID values to "0"

UPDATE online_retail
SET CustomerID = 0
WHERE CustomerID IS NULL;

-- 5. Create a Status column based on transaction details

ALTER TABLE online_retail
ADD Status VARCHAR(20);

UPDATE online_retail
SET Status = CASE
    WHEN InvoiceNo LIKE 'C%' THEN 'Cancel'
	WHEN InvoiceNo LIKE 'A%' THEN 'Issue'
	WHEN UnitPrice LIKE '-%' THEN 'Issue'
	WHEN Quantity LIKE '-%' THEN 'Issue'
	WHEN UnitPrice = 0.00 THEN 'Issue'
    ELSE 'Success'
END;

-- 6. Create separate columns for year and month based on InvoiceDate

ALTER TABLE online_retail
ADD InvoiceYear INT,
    InvoiceMonth INT;

UPDATE online_retail
SET InvoiceYear = YEAR(InvoiceDate),
    InvoiceMonth = MONTH(InvoiceDate);

-- 7. Create a TotalSales column and calculate total sales

ALTER TABLE online_retail
ADD TotalSales DECIMAL(10, 2);

UPDATE online_retail
SET TotalSales = Quantity * UnitPrice
WHERE Status= 'Success';

-- 8. Update NULL TotalSales values to "0"

UPDATE online_retail
SET TotalSales = 0
WHERE TotalSales IS NULL;

-- 9. Update country abbreviations to full country names

UPDATE online_retail
SET Country = 'Ireland'
WHERE Country= 'EIRE';

UPDATE online_retail
SET Country = 'Republic of South Africa'
WHERE Country= 'RSA';

UPDATE online_retail
SET Country = 'United State'
WHERE Country= 'USA';

-- Analysis:

-- 10. Monthly Sales Trends

SELECT InvoiceYear, InvoiceMonth, SUM(TotalSales) AS TotalSalesAmount
FROM online_retail
GROUP BY InvoiceYear, InvoiceMonth
ORDER BY TotalSalesAmount DESC;

-- 11. Customer Segmentation by Country

SELECT Country, COUNT(DISTINCT CustomerID) AS CustomerCount, SUM(TotalSales) AS TotalSalesAmount
FROM online_retail
GROUP BY Country
ORDER BY TotalSalesAmount DESC;

-- 12. List the top selling products based on quantity

SELECT top 10 StockCode, Description, SUM(Quantity) AS TotalQuantity
FROM online_retail
WHERE Status= 'Success'
GROUP BY StockCode, Description
ORDER BY TotalQuantity DESC;

-- 13. Count and Calculate Rate of Each Status Category

SELECT
    Status,
    COUNT(*) AS StatusCount,
    (COUNT(*) * 100.0) / (SELECT COUNT(*) FROM online_retail) AS StatusRate
FROM online_retail
GROUP BY Status;


-- 14. Success Transaction Trends by Hour

SELECT
    DATEPART(HOUR, InvoiceDate) AS HourOfDay,
    Count(Status) AS SuccessTransaction
FROM online_retail
WHERE Status = 'Success'
GROUP BY DATEPART(HOUR, InvoiceDate)
ORDER BY SuccessTransaction DESC;

-- 15. Success Transaction Trends by Day

SELECT
    DATEPART(WEEKDAY, InvoiceDate) AS DayOfWeekNumber,
    CASE
        WHEN DATEPART(WEEKDAY, InvoiceDate) = 1 THEN 'Sunday'
        WHEN DATEPART(WEEKDAY, InvoiceDate) = 2 THEN 'Monday'
        WHEN DATEPART(WEEKDAY, InvoiceDate) = 3 THEN 'Tuesday'
        WHEN DATEPART(WEEKDAY, InvoiceDate) = 4 THEN 'Wednesday'
        WHEN DATEPART(WEEKDAY, InvoiceDate) = 5 THEN 'Thursday'
        WHEN DATEPART(WEEKDAY, InvoiceDate) = 6 THEN 'Friday'
        WHEN DATEPART(WEEKDAY, InvoiceDate) = 7 THEN 'Saturday'
    END AS DayOfWeek,
    count(Status) AS SuccessTransaction
FROM online_retail
WHERE Status = 'Success'
GROUP BY DATEPART(WEEKDAY, InvoiceDate)
ORDER BY SuccessTransaction DESC;

--------------------------------------------------------------------------

