use classicmodels;
show tables;

select now();

select concat('John',' ','Doe');

select customerName from dual;

-- mysql rollup 

create table sales
select productLine, year(orderDate) orderYear, sum(quantityOrdered * priceEach) orderValue
from orderDetails inner join orders using(orderNumber) inner join products using (productCode)
group by
productline, year(orderDate);
    
select productline, sum(orderValue) totalOrderValue from sales 
group by productline;

select sum(orderValue) totalOrderValue from sales;

select productline, sum(orderValue) totalOrderValue from sales 
group by productline
union all
select null, sum(orderValue) totalOrderValue
from sales;

-- query quite lengthy,performance may not be good, union all reuires all queries to have same no of columns, so added null in the select list of the second query

-- to fix these issues, use rollup clause

select productline, sum(orderValue) totalOrderValue from sales 
group by productline with rollup;

select productline, orderYear, sum(orderValue) totalOrderValue from sales
group by productline, orderyear with rollup;

-- reverse hierarchy
select orderYear, productline, sum(orderValue) totalOrderValue from sales
group by orderYear, productline with rollup;

-- grouping function
select orderYear, productline, sum(orderValue) totalOrderValue, grouping(orderYear),
grouping(productline) from sales
group by orderYear, productline with rollup;

-- The GROUPING() function returns 1 when NULL occurs in a supper-aggregate row, otherwise, it returns 0.



