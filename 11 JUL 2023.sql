-- MySQL Basics Revision
use classicmodels;
 
select concat_ws(', ', lastname, firstname) from employees;
 
select concat_ws(', ', lastname, firstname) as 'full name'  from employees;
  
select concat_ws(', ', lastname, firstname) as 'full name' from employees
order by 'full name';
   
select ordernumber 'Order no.', sum(priceeach * quantityordered) total
from orderdetails
group by 'order no.' having total > 60000;  
-- Error Code: 1055. Expression #1 of SELECT list is not in GROUP BY clause and contains nonaggregated column 'classicmodels.orderdetails.orderNumber' which is not functionally dependent on columns in GROUP BY clause; this is incompatible with sql_mode=only_full_group_by
   
   
select ordernumber as 'Order no.', sum(priceeach * quantityordered) as total
from orderdetails
group by ordernumber having total > 60000;
   
select * from employees e;
   
select e.firstname, e.lastname from employees e order by e.firstname;

SELECT customers.customerName, COUNT(orders.orderNumber) total
FROM customers
INNER JOIN orders ON customers.customerNumber = orders.customerNumber
GROUP BY customerName
ORDER BY total DESC;

-- we have to use the tabe name to refer to its column which makes the query lengthy and less readable. So, we use aliases.

select customerName, count(o.ordernumber) total from customers c
inner join orders o on c.customernumber = o.customernumber 
group by customername order by total desc;

--

create table members(
member_id int auto_increment,
name varchar(100),
primary key(member_id)
);

create table committees(
committee_id int auto_increment,
name varchar(100),
primary key (committee_id));

INSERT INTO members(name)
VALUES('John'),('Jane'),('Mary'),('David'),('Amelia');

INSERT INTO committees(name)
VALUES('John'),('Mary'),('Amelia'),('Joe');

select * from members;

select m.member_id, m.name as member, c.committee_id, c.name as committee from members m
inner join committees c
on c.name = m.name;

select m.member_id, m.name as member,
c.committee_id, c.name as committee from members m
inner join committees c using(name);


select m.member_id, m.name as member, c.committee_id, c.name as committee from members m
left join committees c
on c.name = m.name;

select m.member_id, m.name as member,
c.committee_id, c.name as committee from members m
left join committees c using(name);


select m.member_id, m.name as member,
c.committee_id, c.name as committee from members m
left join committees c using(name)
where c.committee_id is null;

select m.member_id, m.name as member, c.committee_id, c.name as committee from members m
right join committees c
on c.name = m.name;


select m.member_id, m.name as member,
c.committee_id, c.name as committee from members m
right join committees c using(name);


select m.member_id, m.name as member,
c.committee_id, c.name as committee from members m
right join committees c using(name)
where m.member_id is null;

-- cross join for cartesian product
select m.member_id, m.name as member, c.committee_id, c.name as committee from members m
cross join committees c;

--
select productcode, productname, textdescription 
from products t1
inner join productlines t2
on t1.productline and t2.productline;

select productcode, productname, textdescription
from products inner join productlines using (productline);

select t1.ordernumber, t1.status, sum(quantityOrdered * priceeach) total
from orders t1
inner join orderdetails t2
on t1.ordernumber = t2.ordernumber
group by ordernumber;

select ordernumber, status, sum(quantityOrdered * priceeach) total
from orders inner join orderdetails
using (orderNumber) group by ordernumber;


select ordernumber, orderdate, orderlinenumber, productname,  quantityordered, priceeach
from orders
inner join orderdetails using (ordernumber)
inner join products using (productcode)
order by ordernumber, orderlinenumber;

SELECT orderNumber, orderDate, customerName, orderLineNumber, productName, quantityOrdered, priceEach
FROM orders
INNER JOIN orderdetails USING (orderNumber)
INNER JOIN products USING (productCode)
INNER JOIN customers USING (customerNumber)
ORDER BY orderNumber, orderLineNumber;

select ordernumber, productname, msrp, priceeach from products p inner join orderdetails o
on p.productcode = o.productcode
and p.msrp > o.priceeach where p.productcode = 'S10_1678';

SELECT customers.customerNumber, customerName, orderNumber, status
FROM customers
LEFT JOIN orders ON orders.customerNumber = customers.customerNumber;


SELECT c.customerNumber, customerName, orderNumber, status
FROM customers c
LEFT JOIN orders o ON c.customerNumber = o.customerNumber;
    
SELECT customerNumber, customerName, orderNumber,status
FROM customers
LEFT JOIN orders USING (customerNumber);

-- left join to find unmatched rows

SELECT c.customerNumber, c.customerName, o.orderNumber, o.status
FROM customers c
LEFT JOIN orders o ON c.customerNumber = o.customerNumber
WHERE orderNumber IS NULL;
    
SELECT lastName, firstName, customerName, checkNumber, amount
FROM employees
LEFT JOIN customers ON employeeNumber = salesRepEmployeeNumber
LEFT JOIN payments ON payments.customerNumber = customers.customerNumber
ORDER BY customerName, checkNumber;

SELECT o.orderNumber, customerNumber, productCode
FROM orders o
LEFT JOIN orderDetails USING (orderNumber) WHERE orderNumber = 10123;
    
SELECT o.orderNumber, customerNumber, productCode
FROM orders o
LEFT JOIN orderDetails d ON o.orderNumber = d.orderNumber AND o.orderNumber = 10123;


--
SELECT employeeNumber, customerNumber
FROM customers
RIGHT JOIN employees ON salesRepEmployeeNumber = employeeNumber
ORDER BY employeeNumber;
    
-- using right join to find unmatching rows
SELECT employeeNumber, customerNumber
FROM customers
RIGHT JOIN employees ON salesRepEmployeeNumber = employeeNumber 
WHERE customerNumber is NULL
ORDER BY employeeNumber;

-- self join
select concat(m.lastname, ', ', m.firstname) as Manager,
concat(e.lastname, ', ', e.firstname) as 'Direct report'
from employees e
inner join employees m on
m.employeenumber = e.reportsto
order by manager;

-- self join using left join
-- The President is the employee who does not have any manager or value in the reportsTo column is NULL .
-- The following statement uses the LEFT JOIN clause instead of INNER JOIN to include the President:

select ifnull(concat(m.lastname, ', ', m.firstname), 'Top Manager') as 'Manager',
concat(e.lastname, ', ', e.firstname) as 'Direct report'
from employees e
left join employees m on m.employeenumber = e.reportsto
order by manager desc;

-- self join o compare successive rows

select c1.city, c1.customername, c2.customername
from customers c1
inner join customers c2 using(city)
and c1.customername > c2.customername order by c1.city; -- Error Code: 1064. You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'and c1.customername > c2.customername order by c1.city' at line 4

select c1.city, c1.customername, c2.customername
from customers c1
inner join customers c2 on c1.city = c2.city
and c1.customername > c2.customername order by c1.city;

create database if not exists salesdb;

use salesdb;
drop table if exists products;
drop table if exists stores;
drop table if exists sales;
create table products (
    id int primary key auto_increment,
    product_name varchar(100),
    price decimal(13,2));

create table stores (
    id int primary key auto_increment,
    store_name varchar(100));

create table sales (
    product_id int,
    store_id int,
    quantity decimal(13 , 2) not null,
    sales_date date not null,
    primary key (product_id , store_id),
    foreign key (product_id) references products (id)
        on delete cascade on update cascade,
    foreign key (store_id) references stores (id)
        on delete cascade on update cascade);

insert into products(product_name, price) values('iphone', 699), ('ipad',599), ('macbook pro',1299);
insert into stores(store_name) values('north'), ('south');
insert into sales(store_id,product_id,quantity,sales_date)
values(1,1,20,'2017-01-02'),
      (1,2,15,'2017-01-05'),
      (1,3,25,'2017-01-05'),
      (2,1,30,'2017-01-02'),
      (2,2,35,'2017-01-05');

select store_name, product_name, sum(quantity * price) as revenue
from sales inner join products on products.id = sales.product_id
inner join stores on stores.id = sales.store_id
group by store_name, product_name;

select store_name, product_name from stores as a cross join products as b; -- gives combination of all stores and products

-- the query returns the total os sales by sales and product 

select b.store_name, a.product_name, ifnull(c.revenue, 0) as revenue
from products as a cross join stores as b left join
(select stores.id as store_id, products.id as product_id, store_name, product_name, round(sum(quantity * price), 0) as revenue
from sales 
inner join products on products.id = sales.product_id
inner join stores on stores.id = sales.store_id
group by stores.id, products.id, store_name, product_name) as c
on c.store_id = b.id
and c.product_id and a.id
order by b.store_name;

-- Note:-  used the IFNULL function to return 0 if the revenue is NULL (in case the store had no sales).

-- MySQL evaluates the GROUP BY clause after the FROM and WHERE clauses and before the HAVING, SELECT, DISTINCT, ORDER BY and LIMIT clauses:
-- from-> where-> group by -> select -> distinct -> order by-> limit

use classicmodels;
select status from orders group by status;
-- the GROUP BY clause returns unique occurrences of status values. It works like the DISTINCT operator

select distinct status from orders;

-- using group by with aggregaate fucntions

select status, count(*) from orders group by status;

select status, sum(quantityordered * priceeach) as amount from orders 
inner join orderdetails using (ordernumber) group by status;

select ordernumber, sum(quantityordered * priceeach) as total
from orderdetails group by ordernumber;

-- with expression

select year(orderdate) as year, sum(quantityordered * priceeach) as total
from orders inner join orderdetails using (ordernumber)
where status = 'shipped' group by year(orderdate);

select year(orderdate) as year, round(sum(quantityordered * priceeach)) as total
from orders inner join orderdetails using (ordernumber)
where status = 'shipped' group by year(orderdate); -- gives the round off value

-- with having
select year(orderdate) as year, round(sum(quantityordered * priceeach)) as total
from orders inner join orderdetails using (ordernumber)
where status = 'shipped' group by year(orderdate)
having year > 2003;

select year(orderdate) as year, count(ordernumber) from orders group by year; -- this is not valid in SQL standard
-- extracts the year from the order date. It first uses the year as an alias of the expression YEAR(orderDate) and then uses the year alias in the GROUP BY clause.

select status, count(*) from orders group by status desc; 
-- Error Code: 1064. You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'desc' at line 1

select 'status', count(*) from orders group by 'status' desc; 
-- Error Code: 1064. You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'desc' at line 1

select o.status, count(*) from orders as o group by o.status desc; 
-- Error Code: 1064. You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'desc' at line 1

SELECT o.status, COUNT(*) FROM orders AS o GROUP BY o.status ORDER BY o.status DESC; -- needs order by

-- group by vs distinct

select state from customers group by state;
select distinct state from customers;

select distinct state from customers order by state;

-- 
-- MySQL evaluates the HAVING clause after the FROM, WHERE, SELECT and GROUP BY clauses and before ORDER BY, and LIMIT clauses:
-- from -> where-> group by-> having -> select -> distinct-> order by -> limit

select ordernumber, sum(quantityordered) as itemscount, sum(priceeach* quantityordered) as total 
from orderdetails
group by ordernumber;

select ordernumber, sum(quantityordered) as itemscount, sum(priceeach* quantityordered) as total 
from orderdetails
group by ordernumber
having total > 1000;


select ordernumber, sum(quantityordered) as itemscount, sum(priceeach* quantityordered) as total 
from orderdetails
group by ordernumber
having total > 1000 and itemscount >600;

select a.ordernumber, status, sum(priceEach*quantityOrdered) total
from orderdetails a inner join orders o on a.orderNumber = o.orderNumber
group by ordernumber, status
having status = 'Shipped' and total >1500;

select * from sales;

select productLine, sum(orderValue) totalordervalue from sales group by productLine;

select sum(orderValue) totalordevalue from sales;

select productLine, sum(orderValue) totalordervalue from sales group by productLine
union all select null, sum(orderValue) totalordervalue from sales;

-- because the UNION ALL requires all queries to have the same number of columns, we added NULL in the select list of the second query to fulfill this requirement.

-- This query is able to generate the total order values by product lines and also the grand total row. However, it has two problems:
# The query is quite lengthy.
# The performance of the query may not be good since the database engine has to internally execute two separate queries and combine the result sets into one.
# To fix these issues, you can use the ROLLUP clause.

select productLine, sum(orderValue) totalordervalue from sales group by productLine with rollup;

select productline, orderYear, sum(orderValue) totalordervalue from sales
group by PRODUCTLINE, orderYear WITH ROLLUP;

-- The ROLLUP generates the subtotal row every time the product line changes and the grand total at the end of the result.
-- The hierarchy in this case is productLine > orderYear

select productline, orderYear, sum(orderValue) totalordervalue from sales
group by orderYear, productLine with rollup ;

-- reverse hierarchy , The hierarchy in this example is: orderYear > productLine

-- using grouping function
select orderYear, productLine, sum(orderValue) totalordervalue, grouping(orderYear), grouping(productLine)
from sales group by orderyear, productLine with rollup;

-- GROUPING() function returns 1 when NULL occurs in a supper-aggregate row, otherwise, it returns 0.

select if(grouping(orderYear), 'All Years', orderYear) orderYear,
       if(grouping(productLine), 'All Product Lines', productLine) productLine,
       sum(orderValue) totalordervalue
from sales group by orderYear, productLine with rollup; -- fills up the null value

--
select lastName, firstName FROM employees
where officecode in (select officeCode from offices where country = 'USA');

-- The sub-query returns all office codes of the offices located in the USA.
-- The outer query selects the last name and first name of employees who work in the offices whose office codes are in the result set returned by the sub-query.

select customerNumber, checkNumber, amount from payments
where amount = (select max(amount) from payments); -- returns who has highest payment

select customerNumber, checkNumber, amount from payments
where amount > (select avg(amount) from payments);

select customerName from customers
where customerNumber not in (select distinct customerNumber from orders);

select max(items), min(items), floor(avg(items))
from (select orderNumber, count(orderNumber) as items
      from orderdetails
      group by orderNumber) as lineitems;

-- FLOOR() is used to remove decimal places from the average values of items.

-- correlated sub-query

select orderNumber, count(ordernumber) as items
from orderdetails group by ordernumber;

select productName, buyPrice from products p1
where buyPrice > (select avg(buyPrice) from products
                 where productline = p1.productLine);

select  orderNumber, sum(priceEach * orderdetails.quantityOrdered) total
from orderdetails inner join orders using (orderNumber)
group by orderNumber having sum(priceEach * quantityOrdered) > 60000;

select customerNumber, customerName from customers
where exists (select  orderNumber, sum(priceEach * orderdetails.quantityOrdered)
              from orderdetails inner join orders using (orderNumber)
              where orders.customerNumber = customers.customerNumber
              group by orderNumber
              having sum(priceEach * quantityOrdered) > 60000);

-- When a subquery is used with the EXISTS or NOT EXISTS operator, a subquery returns a Boolean value of TRUE or FALSE.


