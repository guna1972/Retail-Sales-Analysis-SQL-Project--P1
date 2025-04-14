CREATE TABLE retail_sales(
        transactions_id INT PRIMARY KEY,
		sale_date DATE,
		sale_time TIME,
		customer_id INT,
		gender VARCHAR(15),
		age INT,
		category VARCHAR(15),
		quantity INT,
		price_per_unit FLOAT,
		cogs FLOAT,
		total_sale FLOAT
);
SELECT count(*) FROM retail_sales 
where transaction_id is null or sale_date is null or sale_time is null or customer_id is null or gender is null or age is null or category is null or quantity is null or price_per_unit is null or cogs is null or total_sale is null;  
Delete from retail_sales
where transaction_id is null or sale_date is null or sale_time is null or customer_id is null or gender is null or age is null or category is null or quantity is null or price_per_unit is null or cogs is null or total_sale is null;  


---Data exploration---
--1)How many sales we have?-----
select count(*) as total_sale from retail_sales
--1)How many customers we have?-----
select count(distinct customer_id) from retail_sales

----Data Analysis Busssiness problems?----
---- q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05?----
select * from retail_sales
where sale_date='2022-11-05';

-----q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022)----
Select transaction_id,category,quantity from retail_sales
where category='Clothing' and quantity>=4 and TO_CHAR(sale_date ,'YYYY-MM')='2022-11';


------Q.3Write a SQL query to calculate the total sales (total_sale) for each category?-----
SELECT category,sum(total_sale) from retail_sales
group by category

-----q.4Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category---
select avg(age) as Average_age from retail_sales
where category ='Beauty';

-----q.5Write a SQL query to find all transactions where the total_sale is greater than 1000.
select transaction_id  from retail_sales
where total_sale>1000

----q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select count(transaction_id) as total_transactions, gender,category from retail_sales
group by gender,category;

-----q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1

----** q.8Write a SQL query to find the top 5 customers based on the highest total sales **:
select  customer_id, sum(total_sale) from retail_sales
group by 1 order by 2 desc
limit 5

---Write a SQL query to find the number of unique customers who purchased items from each category.:
select  count(distinct customer_id) as unique_count,category from retail_sales
group by 2

----Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
with hourly_sale as 
(
select *,
        case
		  when extract(hour from sale_time)<12 then 'morning'
		  when extract(hour from sale_time) between 12 and 17 then 'AfterNoon'
		  else 'Evening'
		end as shift 
from retail_sales
)
select shift,
count(*) as total_orders
from hourly_sale
group by shift
		  