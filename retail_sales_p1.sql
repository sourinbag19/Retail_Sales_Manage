create database Retail_sales;
use Retail_sales;
-- 1. Database Setup

drop table if exists  Retail_Sales_Table;
create table Retail_Sales_Table(
transactions_id INT primary key,
sale_date date,
sale_time time,
customer_id int,
gender VARCHAR(15),
age int,
category VARCHAR(15),
quantiy int,
price_per_unit float,
cogs float,
total_sale float
);

-- 2. Data Exploration & Cleaning
-- **Record Count**: Determine the total number of records in the dataset.
-- **Customer Count**: Find out how many unique customers are in the dataset.
-- **Category Count**: Identify all unique product categories in the dataset.
-- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

select *from Retail_Sales_Table 
 limit 100;
 
 select count(*) from  Retail_Sales_Table ;
 
 select *from Retail_Sales_Table
 where category is null;
 
 select *from Retail_Sales_Table
 where transactions_id is null
 or
sale_date is null
or
sale_time is null
or
customer_id is null
or
gender is null
or
age is null
or
category is null
or
quantiy is null
or
price_per_unit 
is null
or
cogs is null
or
total_sale is null ;

--  delete data

SET SQL_SAFE_UPDATES = 0;

DELETE FROM Retail_Sales_Table
	 where transactions_id is null
	 or
	sale_date is null
	or
	sale_time is null
	or
	customer_id is null
	or
	gender is null
	or
	age is null
	or
	category is null
	or
	quantiy is null
	or
	price_per_unit 
	is null
	or
	cogs is null
	or
	total_sale is null;
   
   
   -- data Explorations
   
   -- how many sales we have?
select count(*) as total_sale from Retail_Sales_Table;
 -- How many customer we have?
 
 select count(distinct customer_id)  as total_sales from Retail_Sales_Table;
 select distinct category from Retail_Sales_Table;
 
 -- Data Analysis and Business key problems & Answer
 -- 1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
 select *
 from Retail_Sales_Table
 where sale_date='2022-11-05';
 
 -- 2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
select * from Retail_Sales_Table
where category = 'Clothing'
AND DATE_FORMAT(sale_date,'%Y-%m')='2022-11'
AND quantiy  >= 4;

-- 3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
select category ,
       sum(total_sale) as net_sale
       from Retail_Sales_Table
group by 1;

-- 4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
select avg(age) as avg_age
from  Retail_Sales_Table
where  category='Beauty'; 

-- 5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
select transactions_id from 
Retail_Sales_Table
where total_sale>1000;

-- 6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:

select 
category,
gender ,
COUNT(*) as total_trans
from Retail_Sales_Table
group by 1,2;

-- 7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
WITH monthly_avg AS (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS YEAR,
        EXTRACT(MONTH FROM sale_date) AS MONTH,
        AVG(total_sale) AS Avg_sale
    FROM Retail_Sales_Table
    GROUP BY 
        EXTRACT(YEAR FROM sale_date),
        EXTRACT(MONTH FROM sale_date)
),
frist_rank as (
SELECT 
    YEAR,
    MONTH,
    Avg_sale,
    RANK() OVER (PARTITION BY YEAR ORDER BY Avg_sale DESC) AS month_rank
FROM monthly_avg
ORDER BY YEAR, MONTH
)
select YEAR,MONTH,Avg_sale from frist_rank
where month_rank =1;

-- 8. **Write a SQL query to find the top 5 customers based on the highest total sales **:

select customer_id,
  sum(total_sale) as max_salary
from Retail_Sales_Table
group by customer_id
order by max_salary desc
limit 5
;

-- 10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
select
    category,
    count( distinct customer_id) as total_customer
from Retail_Sales_Table
group by category;    
     
with hourly_order as(
select *,
case
    when extract(HOUR from sale_time) <12 then 'Morning'
    when extract(HOUR from sale_time) between 12 and 17 then ' AfterNoon'
    else 'Evening'
end as Shift
from Retail_Sales_Table
)
select 
shift,
count(transactions_id) as total_ID
from hourly_order
group by shift; 
