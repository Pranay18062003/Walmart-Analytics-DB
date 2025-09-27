DROP TABLE IF EXISTS WALMART;
CREATE TABLE WALMART
(
    invoice_id VARCHAR(20),       
    branch VARCHAR(6),
    city VARCHAR(50),             
    customer_type VARCHAR(20),
    gender VARCHAR(10),
    product_line VARCHAR(50),
    unit_price NUMERIC(10, 2),    
    quantity INT,
    vat NUMERIC(10, 2),           
    total NUMERIC(10, 2),         
    date DATE,
    time TIME,
    payment_method VARCHAR(20),
    rating NUMERIC(3, 1)          
);
SELECT * FROM WALMART;
--Q.1 Find the total sales amount for each branch--
SELECT 
BRANCH,
SUM(TOTAL)
FROM WALMART 
GROUP BY 1
ORDER BY 2 DESC
--Q.2 Calculate the average customer rating for each city.--
SELECT
CITY,
AVG(RATING)
FROM WALMART
GROUP BY 1
ORDER BY 2 DESC
--Q.3 Count the number of sales transactions for each customer type.--
SELECT 
CUSTOMER_TYPE,
COUNT(INVOICE_ID) AS NET_SALES_TRANSACTIONS
FROM WALMART
GROUP BY CUSTOMER_TYPE
--Q.4 Find the total quantity of products sold for each product line.--
SELECT 
PRODUCT_LINE,
SUM(QUANTITY)
FROM WALMART
GROUP BY 1
--Q.4(i) Calculate the total VAT collected for each payment method.--
SELECT 
COUNT(VAT) AS TOTAL_VAT,
SUM(VAT) AS NET_VAT
FROM WALMART

--Q.5 Find the total sales amount and average customer rating for each branch.--
SELECT
BRANCH,
SUM(TOTAL) AS TOTAL_SALES,
AVG(RATING) AS AVG_RATING
FROM WALMART
GROUP BY 1

--Q.6 Calculate the total sales amount for each city and gender combination.--
SELECT 
CITY,
GENDER,
SUM(TOTAL) AS TOTAL_SALES
FROM WALMART
GROUP BY 1, 2

--Q.7 Find the average quantity of products sold for each product line to female customers.--
SELECT 
    product_line,
    AVG(quantity) as avg_qty_sold
    -- gender
FROM walmart
WHERE gender = 'Female'
GROUP BY product_line

--Q.8 Count the number of sales transactions for members in each branch.--
SELECT * FROM WALMART
SELECT 
BRANCH,
COUNT(INVOICE_ID)
FROM WALMART
GROUP BY 1

--Q.9 Find the total sales amount for each day. (Return day name and their total sales order DESC by amt)--
SELECT 
TO_CHAR(DATE, 'DAY') AS DAY,
SUM(TOTAL) AS NET
FROM WALMART
GROUP BY DAY
ORDER BY NET DESC

--Q.10 Calculate the total sales amount for each hour of the day--
SELECT 
EXTRACT(HOUR FROM TIME) AS HOURS,
SUM(TOTAL) AS NET
FROM WALMART
GROUP BY HOURS
--Q.11 Find the total sales amount for each month. (return month name and their sales)--
SELECT 
TO_CHAR(DATE, 'MONTH') AS MONTH,
SUM(TOTAL) AS NET
FROM WALMART
GROUP BY MONTH
ORDER BY NET DESC

--Q.12 Calculate the total sales amount for each branch where the average customer rating is greater than 7.--
SELECT
BRANCH,
SUM(TOTAL) AS NET,
AVG(RATING) AS AVG_RATING --HAVING USED ONLY IN AGGREGATION AFTER THE GROUP BY 
FROM WALMART              -- GROUP BY ONLY USED IN COLUMN IF WE USE WHERE THERE IT TAKES WHOLE COLUMN WHICH IS NOT REQUIRED BECAUSE WE FILTERING THE RATING LESS THAN 7
GROUP BY 1
HAVING AVG(RATING) > 7

--Q.13 Find the total VAT collected for each product line where the total sales amount is more than 500.--
SELECT * FROM WALMART
SELECT
PRODUCT_LINE,
SUM(TOTAL) AS NET,
SUM(VAT) AS NET_VAT
FROM WALMART
GROUP BY 1
HAVING SUM(TOTAL) > 500

--Q.14 Calculate the average sales amount for each gender in each branch.--
SELECT 
GENDER,
BRANCH,
AVG(TOTAL) AS NET
FROM WALMART
GROUP BY 1, 2

--Q.15 Count the number of sales transactions for each day of the week.--
SELECT 
TRIM(TO_CHAR(DATE, 'DAY')) AS DAY,
COUNT(TOTAL)
FROM WALMART
GROUP BY DAY

--Q.16 Find the total sales amount for each city and customer type combination where the number of sales transactions is greater than 50.--
SELECT
CITY, 
CUSTOMER_TYPE,
SUM(TOTAL) AS NET
FROM WALMART
GROUP BY 1, 2
HAVING COUNT(TOTAL) > 50

--Q.17 Calculate the average unit price for each product line and payment method combination.--
SELECT * FROM WALMART;
SELECT 
PRODUCT_LINE,
PAYMENT_METHOD,
AVG(UNIT_PRICE) AS AVG_PRICE
FROM WALMART
GROUP BY 1, 2

--Q.18 Find the total sales amount for each branch and hour of the day combination.--
SELECT
BRANCH,
EXTRACT(HOUR FROM TIME) AS HOURS,
SUM(TOTAL)
FROM WALMART
GROUP BY 1,2 

--Q.19 Calculate the total sales amount and average customer rating for each product line where the total sales amount is greater than 1000.--
SELECT
PRODUCT_LINE,
SUM(TOTAL) AS NET,
AVG(RATING) AS AVG_RATING
FROM WALMART
GROUP BY 1
HAVING SUM(TOTAL) > 1000

--Q.20 Calculate the total sales amount for morning (6 AM to 12 PM), afternoon (12 PM to 6 PM), and evening (6 PM to 12 AM) periods using the time condition.--
WITH NEW_TABLE
AS
(
SELECT *,
CASE
WHEN EXTRACT(HOUR FROM TIME) BETWEEN 6 AND 12 THEN 'MORNING'
WHEN EXTRACT(HOUR FROM TIME) BETWEEN 12 AND 18 THEN 'AFTERNOON'
ELSE 'EVENING'
END AS SHIFT
FROM WALMART SALES
)
SELECT 
SHIFT,
SUM(TOTAL) AS NET,
COUNT(INVOICE_ID) AS TOTAL
FROM NEW_TABLE 
WHERE BRANCH <> 'A'
GROUP BY SHIFT
HAVING COUNT(INVOICE_ID) < 500
-------------------------------------------
SELECT 
INVOICE_ID,
MAX(RATING) AS MAX
FROM WALMART
GROUP BY 1

SELECT E.*,
MAX(RATING) OVER() AS MAX
FROM WALMART E;