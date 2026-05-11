# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `sql_project_p1`

This project is intended to show the techniques and skills in SQL that a data analyst typically uses when exploring, cleaning and analyzing retail sales data. The objective of this project is to create a retail sales database, conduct exploratory data analysis (EDA), and answer questions using SQL. This project is meant for people who are taking baby steps into data analysis and want to strengthen their fundamentals with SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `sql_project_p1`.
- **Table Creation**: A table named `retail_salestb` is created to store the sales data. The table structure includes columns for transactions_id, sale_date,	sale_time, customer_id, gender,	age, category, quantiy, price_per_unit, cogs(cost of goods), total_sale amount.

```sql
CREATE DATABASE sql_project_p1;

DROP TABLE IF EXISTS retail_salestb;

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
			);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.


**Record Count**: Determine the total number of records in the dataset.
```sql
SELECT COUNT(*) FROM retail_salestb;
```

**Customer Count**: Find out how many unique customers are in the dataset.
```sql
SELECT COUNT(DISTINCT customer_id) FROM retail_salestb;
```

**Category Count**: Identify all unique product categories in the dataset.
```sql
SELECT DISTINCT category FROM retail_salestb;
SELECT COUNT(DISTINCT category) FROM retail_salestb
```

**Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
-- Exploring Null Value Data
SELECT * FROM public."retail_salestb"
WHERE 
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
-- Deleting Null Value Data
-- DATA CLEANIN

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
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT * FROM public."retail_salestb"
WHERE "sale_date" = '2022-10-25';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
SELECT * FROM public.retail_salestb 
	WHERE category = 'Clothing' 
	AND (sale_date >= '2022-11-01' 
	AND sale_date < '2022-12-01') 

	--AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND quantiy >= 4;
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
SELECT 
	category,
	SUM(total_sale) as TOTAL_SALE_AMOUNT,
	count(*) as TOTAL_ORDERS
FROM public.retail_salestb
GROUP BY category
ORDER BY TOTAL_SALE_AMOUNT;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT 
	category,
	ROUND(AVG(age), 2) as average_age
FROM public.retail_salestb
WHERE "category" = 'Beauty'
GROUP BY category;
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT * FROM public.retail_salestb
	WHERE total_sale > 1000;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql

SELECT 
	category,
	gender,
	--COUNT(*) as NO_OF_TRX
	COUNT(transactions_id) as NO_OF_TRX
FROM public.retail_salestb
GROUP BY category, gender
ORDER BY 1, 2
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql

-- Without subquery simple version 1
SELECT
	TO_CHAR(sale_date, 'YYYY-MM') AS MONTH_OF_SALE,
	ROUND(AVG(total_sale)::NUMERIC, 2) AS AVG_AVG_SALE_PM
FROM public.retail_salestb
GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
ORDER BY MONTH_OF_SALE ASC

-- Without subquery simple version 2
SELECT
	EXTRACT(YEAR FROM sale_date) AS YEAR,
	EXTRACT(MONTH FROM sale_date) AS MONTH,
	ROUND(AVG(total_sale)::NUMERIC, 2) as AVG_TOTAL_SALE

FROM public.retail_salestb
GROUP BY 1, 2
ORDER BY 1 ASC, 3 DESC

-- With subquery, more clean and more specific version
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


```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
SELECT
	customer_id,
	SUM(total_sale) as TOTAL_SOLD
FROM public.retail_salestb
GROUP BY 1
ORDER BY TOTAL_SOLD DESC 
LIMIT 5
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT 
	category,	
	COUNT(DISTINCT customer_id) as COUNT_UNIQ_CUSTOMER 
FROM public.retail_salestb
GROUP BY category
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql

-- Common Table Expression (CTE) application
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
```

## Findings

- **Customer Demographics**: Customers from different age groups have been included in the dataset data of sales which occur in various categories like Clothing and Beauty and Electronics.
- **High-Value Transactions**: Many sales might be classified as superlative since their total sums were greater than 1000.
- **Sales Trends**: Monthly analysis shows fluctuations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis shows the top spending customers and the top product categories.

## Reports

- **Sales Summary**: A report that summarizes total sales, customer and categories.
- **Trend Analysis**: Analysis of sales trend per month and shift.
- **Customer Insights**: Documents total customers and unique customer counts by top category.

## Conclusion

This project provides you with a holistic overview and introduction to SQL for Data Analysts. It covers the installation of the database, cleaning of data, exploratory data analysis, and how to work with SQL queries based on business cases. Conclusions of the project can throw light on business decisions by understanding sales, customers and product performance.

## How to Use

1. **Clone the Repository**: Clone this project repository from GitHub.
2. **Set Up the Database**: Run the SQL scripts provided in the `database_setup` to create and populate the database.
3. **Run the Queries**: Use the SQL queries provided in the `analysis_queries` to perform your analysis.
4. **Explore and Modify**: Feel free to modify the queries to explore different aspects of the dataset or answer additional business questions.
