-- SQL Retail Sales Analysis - P1

-- CREATE DATABASE sql_project_p1;

-- Create table
DROP TABLE IF EXISTS retail_salesTB;

CREATE TABLE retail_salestb
			(
				transactions_id INT PRIMARY KEY,	
				sale_date DATE,
				sale_time TIME,
				customer_id INT,
				gender VARCHAR(10),
				age INT,
				category VARCHAR(15),
				quantiy INT,
				price_per_unit FLOAT,
				cogs FLOAT,
				total_sale FLOAT
			)

SELECT * FROM public."retail_salestb" LIMIT 10;

SELECT COUNT(*) FROM public."retail_salestb";

SELECT * FROM public."retail_salestb"
WHERE transactions_id IS NULL;

SELECT * FROM public."retail_salestb"
WHERE sale_date IS NULL;

SELECT * FROM public."retail_salestb"
WHERE sale_time IS NULL;

SELECT * FROM public."retail_salestb"
WHERE customer_id IS NULL;

SELECT * FROM public."retail_salestb"
WHERE gender IS NULL;

SELECT * FROM public."retail_salestb"
WHERE age IS NULL;

SELECT * FROM public."retail_salestb"
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL

-- DELETING DATA FROM TABLE
-- DATA CLEANING
DELETE FROM retail_salestb
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

-- DATA EXPLORATION

-- HOW MANY SALES WE HAVE

SELECT COUNT(*) as total_sale FROM public."retail_salestb"

-- HOW MANY CUSTOMERS WE HAVE

SELECT COUNT(DISTINCT customer_id) no_of_customer FROM public."retail_salestb";

-- HOW MANY CATEGORIES WE HAVE

SELECT COUNT(DISTINCT category) as categories FROM public."retail_salestb";

-- Which categories we have?

SELECT DISTINCT category as categories from public."retail_salestb"


-- DATA ANALYSIS & BUSINESS KEY PROBLEM & ANSWERS
--

/*
-- My analysis and findings
Q-01. Write a SQL query to retrieve all columns for sales made on '2022-10-25?
Q-02. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022?
Q-03. Write a SQL query to calculate the total sales (total_sale) for each category?
Q-04. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
Q-05. Write a SQL query to find all transactions where the total_sale is greater than 1000.
Q-06. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category
Q-07. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
Q-08. Write a SQL query to find the top 5 customers based on the highest total sales
Q-09. Write a SQL query to find the number of unique customers who purchased items from each category.
Q-10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)


*/


-- SELECT * FROM public."retail_salestb";
-- Q-01. Write a SQL query to retrieve all columns for sales made on '2022-10-25?
SELECT * FROM public."retail_salestb"
WHERE "sale_date" = '2022-10-25';


-- Q-02. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022?

SELECT * FROM public.retail_salestb WHERE "category" = 'Clothing';

SELECT * FROM public.retail_salestb WHERE sale_date >= '2022-11-01' AND sale_date < '2022-12-01';

SELECT * FROM public.retail_salestb WHERE quantiy > 4;

SELECT * FROM public.retail_salestb 
	WHERE category = 'Clothing' 
	AND (sale_date >= '2022-11-01' 
	AND sale_date < '2022-12-01') 

	--AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND quantiy >= 4;


--Q-03. Write a SQL query to calculate the total sales (total_sale) for each category?

SELECT 
	category,
	SUM(total_sale) as TOTAL_SALE_AMOUNT,
	count(*) as TOTAL_ORDERS

FROM public.retail_salestb
GROUP BY category
ORDER BY TOTAL_SALE_AMOUNT

--Q-04. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select * from public.retail_salestb


SELECT 
	category,
	ROUND(AVG(age), 2) as average_age

FROM public.retail_salestb
WHERE "category" = 'Beauty'
GROUP BY category




--Q-05. Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM public.retail_salestb
	WHERE total_sale > 1000

--Q-06. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category
select * from public.retail_salestb

SELECT 
	category,
	gender,
	--COUNT(*) as NO_OF_TRX
	COUNT(transactions_id) as NO_OF_TRX
FROM public.retail_salestb
GROUP BY category, gender
ORDER BY 1, 2


--Q-07. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT * FROM public.retail_salestb

SELECT
	TO_CHAR(sale_date, 'YYYY-MM') AS MONTH_OF_SALE,
	ROUND(AVG(total_sale)::NUMERIC, 2) AS AVG_AVG_SALE_PM
FROM public.retail_salestb
GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
ORDER BY MONTH_OF_SALE ASC


--without subquery >> calculate the average sale for each month.

SELECT
	EXTRACT(YEAR FROM sale_date) AS YEAR,
	EXTRACT(MONTH FROM sale_date) AS MONTH,
	ROUND(AVG(total_sale)::NUMERIC, 2) as AVG_TOTAL_SALE

FROM public.retail_salestb
GROUP BY 1, 2
ORDER BY 1 ASC, 3 DESC

-- with subquery >> Find out best selling month in each year
SELECT 
	year,
	month,
	AVG_TOTAL_SALE
FROM
(
SELECT
	EXTRACT(YEAR FROM sale_date) AS YEAR,
	EXTRACT(MONTH FROM sale_date) AS MONTH,
	ROUND(AVG(total_sale)::NUMERIC, 2) as AVG_TOTAL_SALE,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM  sale_date) ORDER BY AVG(total_sale) DESC) as RANK
FROM public.retail_salestb
GROUP BY 1, 2
) as T1
WHERE RANK=1

-- Q-08. Write a SQL query to find the top 5 customers based on the highest total sales

SELECT * FROM public.retail_salestb

SELECT
	customer_id,
	SUM(total_sale) as TOTAL_SOLD
FROM public.retail_salestb
GROUP BY 1
ORDER BY TOTAL_SOLD DESC 
LIMIT 5


-- Q-09. Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT * FROM public.retail_salestb

SELECT 
	category,	
	COUNT(DISTINCT customer_id) as COUNT_UNIQ_CUSTOMER 
FROM public.retail_salestb
GROUP BY category



-- Q-10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

SELECT * FROM public.retail_salestb

WITH hourly_sale
AS
( 

SELECT
	*,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'MORNING'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'AFTERNOON'
		ELSE 'EVENING'
	END AS SHIFT
FROM public.retail_salestb
)

SELECT 
	SHIFT,
	COUNT(*) AS TOTAL_ORDERS
FROM hourly_sale
GROUP BY SHIFT
ORDER BY SHIFT DESC


-- END OF PROJECT



	
	
	



