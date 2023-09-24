-- Online Retail Data Analysis SQL Script

-- Introduction:
-- This SQL script performs data cleaning, transformation, and analysis on an online retail dataset.
-- The dataset contains information about customer transactions, products, and sales.

-- Dataset Description:
-- The online_retail table includes columns such as InvoiceNo, StockCode, Description, Quantity,
-- UnitPrice, CustomerID, InvoiceDate, and Country.

-- Check the entire dataset for issues
SELECT * FROM online_retail;

-- Update NULL Description values to "None"

UPDATE online_retail
SET Description = 'None'
WHERE Description IS NULL;

-- Remove ".0" from the end of CustomerID values

UPDATE online_retail
SET CustomerID = SUBSTRING(CustomerID, 1, LEN(CustomerID) - 2)
WHERE CustomerID LIKE '%.0';

-- Convert CustomerID to INT data type

ALTER TABLE online_retail
ALTER COLUMN CustomerID INT;

-- Update NULL CustomerID values to "0"

UPDATE online_retail
SET CustomerID = 0
WHERE CustomerID IS NULL;


--check if all InvoiceNo values in dataset have 6 digits
--selects InvoiceNo values that are not cancellations (do not start with 'C') 
--and have a length different from 6 or do not start with a digit

SELECT InvoiceNo
FROM online_retail
WHERE InvoiceNo NOT LIKE 'C%' -- Exclude cancellation invoices
      AND (LEN(InvoiceNo) <> 6 OR InvoiceNo NOT LIKE '[0-9]%'); --There are 3 InvoiceNo starting with A

SELECT * FROM online_retail
WHERE InvoiceNo LIKE 'A%'; --Description is Adjust bad debt and unit price is negative price

-- Delete rows where InvoiceNo starts with 'A'
DELETE FROM online_retail
WHERE InvoiceNo LIKE 'A%';

-- Create a Status column based on transaction details

ALTER TABLE online_retail
ADD Status VARCHAR(20);

--InvoiceNo: Invoice number. Nominal, a 6-digit integral number 
--uniquely assigned to each transaction. If this code starts with letter 'c', it indicates a cancellation.

UPDATE online_retail
SET Status = CASE
    WHEN InvoiceNo LIKE 'C%' THEN 'Cancel'
    ELSE 'Success'
END;

-- Check distinct values in the Quantity column (excluding cancellations)
SELECT DISTINCT Quantity
FROM online_retail 
WHERE InvoiceNo NOT LIKE 'C%';--There is a negative value in the quantity column but not a cancellation

-- Select rows with negative Quantity values (excluding cancellations)
SELECT * FROM online_retail
WHERE Quantity < 0 AND 
	InvoiceNo NOT LIKE 'C%'; --All unit price and CustomerID are 0,so there is no transaction.

-- Remove rows with negative Quantity values and unit price equal to 0
DELETE FROM online_retail
WHERE Quantity < 0 AND UnitPrice = 0;

-- Select rows with 0 Unit Price (excluding cancellations)
SELECT * FROM online_retail
WHERE UnitPrice = 0 AND 
	InvoiceNo NOT LIKE 'C%'; --Some descriptions contain 'None'

-- Remove rows with 0 unit price (excluding cancellations)
DELETE FROM online_retail
WHERE UnitPrice = 0 AND 
	InvoiceNo NOT LIKE 'C%';


-- Create separate columns for year and month based on InvoiceDate

ALTER TABLE online_retail
ADD InvoiceYear INT,
    InvoiceMonth INT;

UPDATE online_retail
SET InvoiceYear = YEAR(InvoiceDate),
    InvoiceMonth = MONTH(InvoiceDate);

--  Create a TotalSales column and calculate total sales

ALTER TABLE online_retail
ADD TotalSales DECIMAL(10, 2);

-- Update the Total Sales column with the calculated total sales where the status is "Success"

UPDATE online_retail
SET TotalSales = Quantity * UnitPrice
WHERE Status= 'Success';

-- Update NULL TotalSales values to "0"

UPDATE online_retail
SET TotalSales = 0
WHERE TotalSales IS NULL;

--remove duplicate rows

WITH CTE AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY InvoiceNo,StockCode,Description,Quantity,
		   InvoiceDate,UnitPrice,CustomerID,Country ORDER BY (SELECT NULL)) AS rn
    FROM online_retail
)
DELETE FROM CTE
WHERE rn > 1;

-- Update country abbreviations to full country names

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

-- Calculate the Sum of Total Sales (Total Sales Amount)

SELECT SUM(TotalSales)
FROM online_retail; 

--Distinct CustomerID (excluding cancellations)

SELECT COUNT(DISTINCT CustomerID)
FROM online_retail
WHERE Status = 'Success';

--Number of unique transaction

SELECT COUNT(DISTINCT InvoiceNo) 
FROM online_retail
WHERE InvoiceNo NOT LIKE 'C%'; 

-- Calculate the Average Order Value (excluding cancellations)

SELECT AVG(OrderTotal) AS AvgOrderValue
FROM (
    SELECT InvoiceNo, SUM(TotalSales) AS OrderTotal
    FROM online_retail
    GROUP BY InvoiceNo
) AS OrderTotals
WHERE InvoiceNo NOT LIKE 'C%'; 


-- Monthly Sales Trends

SELECT InvoiceYear, InvoiceMonth, SUM(TotalSales) AS TotalSalesAmount
FROM online_retail
GROUP BY InvoiceYear, InvoiceMonth
ORDER BY TotalSalesAmount DESC;

-- Customer Segmentation by Country

SELECT Country, COUNT(DISTINCT CustomerID) AS CustomerCount, SUM(TotalSales) AS TotalSalesAmount
FROM online_retail
WHERE InvoiceNo NOT LIKE 'C%'
GROUP BY Country
ORDER BY TotalSalesAmount DESC;

-- List the top selling products based on quantity

SELECT top 10 Description, SUM(Quantity) AS TotalQuantity
FROM online_retail
WHERE Status= 'Success'
GROUP BY  Description
ORDER BY TotalQuantity DESC;

-- Count and Calculate Rate of Each Status Category

SELECT
    Status,
    COUNT(*) AS StatusCount,
    (COUNT(*) * 100.0) / (SELECT COUNT(*) FROM online_retail) AS StatusRate
FROM online_retail
GROUP BY Status;

-- Success Transaction Trends by Hour

SELECT
    DATEPART(HOUR, InvoiceDate) AS HourOfDay,
    Count(DISTINCT InvoiceNo) AS NumberOfTransaction
FROM online_retail
WHERE InvoiceNo NOT LIKE 'C%'
GROUP BY DATEPART(HOUR, InvoiceDate)
ORDER BY NumberOfTransaction DESC;

-- Success Transaction Trends by Day

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
    COUNT (DISTINCT InvoiceNo) AS NumberOfTransaction
FROM online_retail
WHERE InvoiceNo NOT LIKE 'C%'
GROUP BY DATEPART(WEEKDAY, InvoiceDate)
ORDER BY NumberOfTransaction DESC;

--------------------------------------------------------------------------
















