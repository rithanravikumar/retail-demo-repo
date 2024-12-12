select * from order_data;
select * from product_data;

select product_id,category,sub_category,count(order_id) as order_count from df
group by product_id,category,sub_category;

create table product_data (product_id varchar primary key,category varchar,
sub_category varchar,order_count bigint)

select * from product_data;

insert into product_data(product_id, category, sub_category, order_count)
select product_id,category,sub_category,count(order_id)
from df
group by product_id,category,sub_category;


create table order_data as select order_id,order_date,product_id,ship_mode,segment,country,city,state,
postal_code,region,cost_price,list_price,quantity,discount_percent,discount_price,sale_price,profit,
year,month from df;

select * from order_data;

alter table order_data
add constraint pk primary key (order_id);
alter table order_data
add constraint fk foreign key (product_id)
references product_data (product_id);

select * from order_data;
select * from information_schema.table_constraints;

--1)Find top 10 highest revenue generating products:
select p.product_id,p.sub_category,round(sum(o.sale_price::numeric * o.quantity::numeric),2) as revenue from product_data p join order_data o 
on p.product_id=o.product_id group by p.product_id order by revenue desc limit 10;


--2) Find the top 5 cities with the highest profit margins:
select city,avg(case when sale_price = 0 then 0 else ((profit/sale_price)*100) end)
as profit_margin from order_data group by city order by profit_margin desc limit 5;

--3) Calculate the total discount given for each category:
select p.category,sum(o.discount_price) as total_discount from product_data p 
join order_data o on p.product_id=o.product_id group by p.category;

--4) Find the average sale price per product category:
select p.category,avg(o.sale_price) as Avg_saleprice from order_data o join product_data p
on p.product_id= o.product_id group by category;

--5) Find the region with the highest average sale price:
select region, avg(sale_price) as avg_sales from order_data group by region order by avg_sales desc limit 1;


--6) Find the total profit per category:
select p.category, sum(o.profit) as total_profit from product_data p join order_data o on 
p.product_id=o.product_id group by p.category;

--7)  Identify the top 3 segments with the highest quantity of orders:
select segment, sum(quantity) as highest_quantity  from order_data group by segment 
order by highest_quantity desc;


--8) Determine the average discount percentage given per region: 
select region, round(avg(discount_percent),2) as avg_discount from order_data group by region;


--9) Find the product category with the highest total profit:
select p.category, round(sum(o.profit)::numeric,2) as total_profit from product_data p join order_data o 
on p.product_id=o.product_id group by p.category order by total_profit desc limit 1;

--10) Calculate the total revenue generated per year:
select year, round(sum(sale_price)::numeric,2) as Revenue_per_year from order_data group by year;

-----------------------------------
--1.11) Find total sales revenue for each region:
select region, sum(sale_price * quantity) as total_revenue from order_data group by region;


--4.12)  Identify regions with total profits greater than $50,000:
select region, sum(profit*quantity) as total_profit from order_data group by region
having sum(profit*quantity) >50000;


--7.13) Find the region with the highest number of orders:
select region, count(order_id) as order_count
from order_data group by region
order by order_count desc limit 1;

--14. Count the total number of orders each year:
select year, count(distinct order_id) as total_orders from order_data group by year;


--9.15) Count unique products in each category:
select category, count(distinct product_id) as unique_products from product_data group by category;


--15.16) List top 3 states with the most orders:
select state, count(distinct order_id) as total_orders from order_data group by state order by total_orders desc limit 3;


--18.17) List regions with negative profit products:
select region from order_data where profit < 0 group by region;


--19.18) Determine the most frequently ordered product:
select p.product_id,p.sub_category, count(distinct o.order_id) as order_frequency from product_data p join order_data o 
on p.product_id=o.product_id group by p.product_id order by order_frequency desc limit 1;


--22.19) Identify cities with profits exceeding $10,000:
select city, sum(profit) as total_profit 
from order_data group by city having sum(profit) > 10000 order by total_profit desc ;


--29.20) Identify top 5 sub categories with the most products sold:
select p.sub_category, sum(o.quantity) as total_quantity from product_data p join order_data o on p.product_id=o.product_id
group by p.sub_category order by total_quantity desc limit 5;

