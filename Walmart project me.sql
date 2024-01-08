CREATE DATABASE IF NOT EXISTS salesdatawalmart;
    CREATE TABLE IF NOT EXISTS wal_sale(
    invoive_id VARCHAR (30) NOT NULL PRIMARY KEY,
	Branch VARCHAR(5) NOT NULL , 
    city VARCHAR(30) NOT NULL ,
    CUSTOMER_TYPE VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL, 
    unit_price DECIMAL(10, 2) NOT NULL ,
    Quantity INT NOT NULL,
    VAT FLOAT NOT NULL,
    Total DECIMAL ( 12, 4) not null, 
    date_wal DATETIME NOT NULL, 
    time_wal TIME NOT NULL,
    payment_method VARCHAR(15) NOT NULL,
    cogs DECIMAL(10, 2) NOT NULL,
    gross_margin_pct FLOAT , 
    gross_income DECIMAL(12, 4) NOT NULL,
    rating FLOAT
    );
    select * from wal_sale;
--  ------------------------------------------------------------------------------------------------
-- -------------------------------Feature Engineering ----------------------------------------------

-- 1.) to get time_of_day

SELECT
    CASE 
        WHEN `time_wal` BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN `time_wal` BETWEEN '12:00:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_date
FROM wal_sale;

ALTER TABLE wal_sale ADD COLUMN time_off_day VARCHAR(20)   -- ITS TIME 'OF'DAY NOT 'OFF' Day


UPDATE wal_sale 
SET time_off_day = (
    CASE 
        WHEN `time_wal` BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN `time_wal` BETWEEN '12:00:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END
);


UPDATE wal_sale 
SET time_off_day = (
    CASE 
        WHEN `time_wal` BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN `time_wal` BETWEEN '12:00:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END
);


-- 2.) day_name 

SELECT date_wal, 
DAYNAME (date_wal) 
from wal_sale; 

ALTER TABLE wal_sale ADD COLUMN day_name VARCHAR(50);

update wal_sale
SET day_name = (DAYNAME (date_wal) );

-- 3.) month_name 

SELECT date_wal, MONTHNAME(date_wal)
FROM wal_sale;

ALTER TABLE wal_sale ADD COLUMN month_name VARCHAR(10);
 
UPDATE wal_sale 
SET month_name = MONTHNAME(date_wal);
  
 -- ---------------------------------------------------( EDA )----------------------------------------------------------------
 -- ----------------------------------------- -EXPLORATORY DATA ANALYSIS -----------------------------------------------------
 
-- 1.) How many unique cities does the data have ? 

SELECT DISTINCT CITY FROM wal_sale;

-- 2.) In which city is each Brand ?

SELECT DISTINCT city , branch -- SOLUTION 1 
from wal_sale;

SELECT city, branch  -- SOLUTION 2
FROM wal_sale
GROUP BY city, branch;

-- -------------------------------------Product-------------------------------------------------

-- 3.) How many unique product lines does the data have? 

SELECT product_line, count(*) AS pp_line  -- we have got 6 different product lines and additionally we have added count function to take count of it
from wal_sale
GROUP BY product_line;

-- 4.) What is the most common payment method 

SELECT payment_method , COUNT(*) AS Pay_Method
from wal_sale
GROUP BY payment_method
ORDER BY Pay_Method ASC;   -- I have added this by myself 

-- 5.) What is the most selling product line?

SELECT product_line , COUNT(*) AS most_selling_product
from wal_sale
GROUP BY product_line
ORDER BY most_selling_product DESC;

select * from wal_sale;

-- 6.) What is the total revenue by month ?

SELECT month_name AS Month,
SUM(total) AS Total_Revenue 
FROM wal_sale 
GROUP BY Month 
ORDER BY Total_Revenue DESC;
 
-- 7.) Which month has the largest COGS ?

SELECT month_name AS Month,
SUM(cogs) AS Largest_cogs
FROM wal_sale
GROUP BY Month
ORDER BY Largest_cogs DESC; 


-- 8.) Which product line had the largest revenue ?

SELECT product_line ,
SUM(total) AS total_revenue
FROM wal_sale
GROUP BY product_line
ORDER BY total_revenue DESC;

-- 9.) What is the city which has largest revenue ?

SELECT city , branch, -- I have added Branch
SUM(total) AS Revenue
FROM wal_sale
GROUP BY city , branch
ORDER BY Revenue DESC;

-- 10.) What product line has largest VAT ?

SELECT product_line,
SUM(VAT) AS VAT_AMOUNT 
FROM wal_sale
GROUP BY product_line 
ORDER BY VAT_AMOUNT DESC;

-- 11.)  Which branch sold more products than average product sold (Qunatity column) ?

SELECT branch ,   -- Solution 1
SUM(quantity) AS QTY 
from wal_sale
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM wal_sale);

SELECT branch, SUM(quantity) AS QTY    -- Solution 2
FROM wal_sale
WHERE branch IN (
    SELECT branch
    FROM wal_sale
    GROUP BY branch
    HAVING SUM(quantity) > (SELECT AVG(quantity) FROM wal_sale)
)
GROUP BY branch;


-- 12.)  What is the most common product line by Gender ?

SELECT product_line , gender,
count(gender) as total_count 
FROM wal_sale 
GROUP BY gender, product_line
ORDER BY total_count DESC;

-- 13.)  What is the average rating of each product line ?

SELECT product_line,
ROUND(AVG(rating), 2) AS Product_Rating
FROM wal_sale
GROUP BY product_line
ORDER BY Product_Rating DESC;


-- ----------------------------------------------Sales P2-----------------------------------------------------------

select * from wal_sale;

-- 14.) Number of sales made in each time of the day ?

SELECT time_off_day,
COUNT(*) AS Total_Sales 
from wal_sale
WHERE day_name = "Monday"
GROUP BY time_off_day
ORDER BY Total_Sales DESC;

-- 15.)  Which of the customer types brings the most revenue ?

SELECT CUSTOMER_TYPE , 
SUM(Total) AS Total_Revenue
FROM wal_sale
GROUP BY CUSTOMER_TYPE
ORDER BY Total_Revenue DESC;

-- 16.) Which city has largest VAT ?

SELECT city, 
SUM(VAT) AS VATU 
FROM  wal_sale
GROUP BY city
ORDER BY VATU DESC;
 
 
 -- 17.)  Which customer type pays the most VAT ?
 
 SELECT CUSTOMER_TYPE,
 SUM(VAT) AS VAT_U
 FROM wal_sale
 GROUP BY CUSTOMER_TYPE
 ORDER BY VAT_U DESC;
 
 -- ----------------------------------------------------CUSTOMER----------------------------------------------------------------- 
 
 -- 18.) How many unique customer type does this data have ?

SELECT COUNT(DISTINCT CUSTOMER_TYPE) AS unique_customer_types
FROM wal_sale;


-- 19.) How many unique payment methods does the data have ?

SELECT COUNT(DISTINCT payment_method) AS unique_payment_method
FROM wal_sale;

-- 20.)  What is the most common customer type ?

SELECT customer_type, COUNT(*) AS type_count
FROM wal_sale
GROUP BY customer_type
ORDER BY type_count DESC
LIMIT 1   -- Limit means it gives top (1/2/3....) row(s) from the table




-- 21.) Which customer type buys the most?


SELECT CUSTOMER_TYPE , SUM(Quantity) AS buys_most -- MYSQL IS ONLY SHOWING THIS ERROR, NOTHING WRONG IN THIS 
from wal_sale 
GROUP BY CUSTOMER_TYPE
ORDER BY buys_most DESC;

SELECT CUSTOMER_TYPE, SUM(Quantity) AS total_quantity_bought
FROM wal_sale
GROUP BY CUSTOMER_TYPE
ORDER BY total_quantity_bought DESC
LIMIT 1;

-- 22.) What is the gender of most customers ?

SELECT gender , COUNT(*) AS GEN_COUNT
FROM wal_sale
GROUP BY gender
ORDER BY GEN_COUNT ASC;


-- 23.) What is the gender distribution per branch ?

SELECT gender , COUNT(*) AS GEN_COUNT  -- SOLUTION 1
FROM wal_sale
WHERE branch = "B" 
GROUP BY gender
ORDER BY GEN_COUNT ASC;

SELECT branch, gender, COUNT(*) AS customer_count  -- SOLUTON 2
FROM wal_sale
GROUP BY branch, gender;

-- 24.) What time (morning, afternoon, evening) of the day customer give more rating ?

SELECT * FROM WAL_SALE;

SELECT time_off_day,
AVG(rating) AS RAT_ING
FROM wal_sale 
GROUP BY time_off_day 
ORDER BY RAT_ING DESC

-- 25.) What time (morning, afternoon, evening) of the day customer give more rating per branch ?
SELECT time_off_day,                                    -- SQL WORKBENCH ERROR
AVG(rating) AS RAT_ING
FROM wal_sale 
where branch = "C"
GROUP BY time_off_day 
ORDER BY RAT_ING DESC;

SELECT time_off_day,
AVG(rating) AS RAT_ING
FROM wal_sale 
where branch = "A"
GROUP BY time_off_day 
ORDER BY RAT_ING DESC;

-- 26.) Which day of the week has the best AVG ratings ?

SELECT day_name, 
AVG(rating) AS AVG_rating
FROM wal_sale
GROUP BY day_name
ORDER BY AVG_rating DESC;

-- 27.)  Which day of the week has the best AVG ratings per branch ?

SELECT day_name, 
AVG(rating) AS AVG_rating
FROM wal_sale
WHERE branch = "A"
GROUP BY day_name
ORDER BY AVG_rating DESC;


