create database amazon_sales_data;

use amazon_sales_data;

create table amazon(

Invoice_ID varchar(20) not null,
Branch varchar(10) not null,
City varchar(30) not null,
Customer_type varchar(30) not null,
Gender varchar(20) not null,
Product_line varchar(20) not null,
unit_price int not null,
quantity int not null,
tax float(6,4) not null default 0.05,
total float(8,5) not null,
date date not null,
time time not null,
payment varchar(30) not null,
cogs float(10,2) not null,
gross_margin_percentage float(11,9) not null,
gross_income float(10,2) not null,
rating float(2,1)
);

select * from amazon;

select count(*) from amazon;

-- checking for null values in all columns

select * from amazon where 1 = 0;

-- inserting new columns timeofday, dayname, monthname

alter table amazon 
add column timeofday varchar(20);

update amazon 
set timeofday  = 
case 
     when hour(time) >= 0 and hour(time) < 6 then 'Night'
     when hour(time) >= 6 and hour(time) < 12 then 'Morning'
     when hour(time) >= 12 and hour(time) < 18 then 'Afternoon'
     else 'Evening'
end;

alter table amazon 
add column dayname varchar(20);

update amazon 
set dayname = dayname(date);

alter table amazon
add column monthname varchar(30);

update amazon 
set monthname = date_format(date, "%b");
-- %b refers to abbrevated name of month name

select * from amazon;

-- 1).	What is the count of distinct cities in the dataset?

select count(distinct(city)) from amazon;

-- 2).	For each branch, what is the corresponding city?

select branch, city from amazon
group by branch, city;

-- 3).	What is the count of distinct product lines in the dataset

select product_line, count(product_line) as count_of_prod_line
from amazon 
group by product_line;

-- 4).	Which payment method occurs most frequently?

select payment, count(payment) as frequency
from amazon 
group by payment
order by frequency desc
limit 1;

-- 5.	Which product line has the highest sales?

select product_line, sum(total) as highest_sales
from amazon
group by product_line
order by highest_sales desc
limit 1;

-- 6.	How much revenue is generated each month?

select year(date) as 'YEAR', month(date) as 'MONTH' , sum(total) as mon_revenue
from amazon
group by YEAR,MONTH
order by MONTH;

-- 7.	In which month did the cost of goods sold reach its peak?

select month(date) as MONTH , sum(cogs) as peak_of_cogs
from amazon
group by MONTH
order by peak_of_cogs desc 
LIMIT 1;

-- 8.	Which product line generated the highest revenue?

select product_line, sum(total) as highest_revenue 
from amazon 
group by product_line 
order by highest_revenue desc
limit 1;

-- 9.	In which city was the highest revenue recorded?

select city, sum(total) as highest_revenue
from amazon 
group by city
order by highest_revenue desc
limit 1;

-- 10.	Which product line incurred the highest Value Added Tax?

select product_line, sum(tax) as highest_tax
from amazon
group by product_line
order by highest_tax desc
limit 1;

-- 11.	For each product line, add a column 
-- indicating "Good" if its sales are above average, otherwise "Bad."

alter table amazon 
add column review varchar(30) not null;

select * from amazon;

select product_line, sum(total) as sales,
case
	when sum(total) < (select avg(total) from amazon) then 'Not that great'
    else 'Good'
end as review
from amazon
group by product_line;

alter table amazon drop column review;

select * from amazon;

-- 12.	Identify the branch that exceeded the average number of products sold?

select branch, sum(quantity) as total_quantity from amazon
group by branch
having sum(quantity) > (select avg(quantity) from amazon);


-- 13.	Calculate the average rating for each product line.

select product_line, avg(rating) from amazon 
group by product_line;

-- 14.	Count the sales occurrences for each time of day on every weekday?

select * from amazon;

select timeofday, dayname, count(*) as sales
from amazon
where dayname not in ('Sunday' , 'Saturday')
group by timeofday, dayname
order by sales desc;

-- 15.	Identify the customer type contributing the highest revenue?

select Customer_type, sum(total) as highest_revenue from amazon 
group by Customer_type 
order by highest_revenue desc
Limit 1;

-- 16.	Determine the city with the highest VAT percentage.

select City, max(tax) as VAT_percentage from amazon 
group by City
order by VAT_percentage desc
Limit 1;

-- 17.	Identify the customer type with the highest VAT payments.

select Customer_type, round(sum(tax)) as highest_VAT_payment
from amazon 
group by Customer_type
order by highest_VAT_payment desc
LIMIT 1;

-- 18.	What is the count of distinct customer types in the dataset?

select Customer_type, count(distinct(Customer_type)) as Count_of_customer_type
from amazon 
group by Customer_type 
order by Count_of_customer_type desc;

-- 19.	What is the count of distinct payment methods in the dataset?

select payment, count(distinct(payment)) as count_of_distinct_payment_method
from amazon 
group by payment
order by count_of_distinct_payment_method desc;

-- 20.	Which customer type occurs most frequently?

select Customer_type, count(Customer_type) as frequency
from amazon 
group by Customer_type 
order by frequency desc
limit 1;

-- 21.	Identify the customer type with the highest purchase frequency?

select Customer_type, count(*) as highest_purchase_frequency
from amazon 
group by Customer_type 
order by highest_purchase_frequency desc;

-- 22.	Determine the predominant gender among customers?

select Gender, count(*) as predominant_count
from amazon 
group by Gender
order by predominant_count desc;

-- 23.	Examine the distribution of genders within each branch?

select Branch, 
count(case when Gender = 'Male' then 1 end) as Male_counts,
count(case when Gender = 'Female' then 1 end) as female_counts
from amazon 
group by Branch
-- group by Gender
order by Branch;
-- order by Gender;

select * from amazon;

--  24.	Identify the time of day when customers provide the most ratings?

select timeofday, count(rating) as most_ratings from amazon
group by timeofday
order by most_ratings desc
limit 1;

-- 25.	Determine the time of day with the highest customer ratings for each branch

select timeofday, Branch, max(rating) as highest_customer_ratings 
from amazon 
group by timeofday, Branch
order by highest_customer_ratings desc
limit 5;

-- 26.	Identify the day of the week with the highest average ratings

select * from amazon;


select dayname, round(avg(rating),3) as avg_rating from amazon
group by dayname
order by avg_rating desc
limit 1;

-- 27.	Determine the day of the week with the highest average ratings for each branch?

select dayofWeek, branch, avgrating from(
select dayname(date) as dayofWeek, branch, round(avg(rating),3) as avgrating,
row_number() over (partition by branch order by avg(rating) desc) as rn
from amazon 
group by branch, dayofWeek) as ranked 
where rn = 1;





















