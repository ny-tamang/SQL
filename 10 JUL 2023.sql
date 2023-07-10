-- revision --
use classicmodels;
 
 -- mysql basic --
select * from employees;
select lastName from employees;
select lastName, firstName, jobTitle from employees;
select now(); -- shows current date and time

select * from customers;
select country from customers;

select * from offices;
select * from orderdetails;

select * from orders;

select comments from orders;
select comments from orders where comments is not null;

select *  from payments;
select distinct customerNumber from payments;

select * from productlines;

select * from products;
select * from sales;


select concat('John',' ', 'Doe');
select concat('John',' ', 'Doe') as name;

select concat('Jane',' ', 'Doe') as 'full name';

-- When executing the SELECT statement with an ORDER BY clause, MySQL always evaluates the ORDER BY clause after the FROM and SELECT clauses:
-- from-> slelect -> order by

select contactLastname, contactFirstname from customers order by contactLastname;

select contactLastname, contactFirstname from customers order by contactLastname desc;

select contactlastname, contactfirstname from customers 
order by contactlastname desc, 
contactfirstname asc;

-- ordering the output using an expression or by an expression

select ordernumber, orderlinenumber, quantityOrdered * priceeach as 'total price'
from orderdetails order by quantityordered * priceeach desc;

select ordernumber, orderlinenumber, quantityordered * priceeach as subtotal
from orderdetails order by subtotal desc;

-- ordering using a custom field

select field('A', 'A','B','C');

SELECT FIELD('B', 'A','B','C');

select orderNUmber, status from orders 
order by field(status, 'In Process', 'On Hold', 'cancelled', 'resolved', 'disputed','shipped');	

-- In MySQL, NULL comes before non-NULL values. Therefore, when you the ORDER BY clause with the ASC option, NULLs appear first in the result set.

select firstname, lastname, reportsTo from employees order by reportsto;

select firstname, lastname, reportsto from employees order by reportsto desc; -- null appears at last


-- 
select lastname, firstname, jobtitle from employees where jobtitle = 'Sales Rep';

select lastname, firstname, jobtitle, officecode
from employees
where jobtitle = 'Sales Rep' and
officecode =1;

select lastname, firstname jobtitle, officecode from employees
where jobtitle = 'Sales Rep' or officecode = 1
order by officecode;

select firstname, lastname officecode from employees 
where officecode between 1 and 3
order by officecode;

select firstname, lastname from employees 
where lastname like '%son'
order by firstname;

select firstname, lastname from employees 
where firstname like 'A%';

select firstname, lastname from employees 
where lastname like '%e%'
order by firstname;

select firstname, lastname, officecode from employeees
where officecode in (1, 2, 3) order by officecode;

select customerName, contactfirstname, contactlastname, country from customers
where country in ('USA', 'UK', 'Canada')
order by customernumber;

select lastname, firstname, jobtitle from employees
where jobtitle <> 'Sales Rep'; -- used to find out the mployees who are not the sals rep

select lastname, firstname, officecode from employees where officecode > 5;
select lastname, firstname, officecode from employees where officecode <= 4;

--
-- When executing the SELECT statement with the DISTINCT clause, MySQL evaluates the DISTINCT clause after the FROM, WHERE, and SELECT clause and before the ORDER BY clause:
-- from ->where -> select -> distinct -> order by

select lastname from employees order by lastname;
select distinct lastname from employees order by lastname;


select distinct state from customers;

select distinct country from customers order by country;

select productname from products order by productname;

select distinct state, city from customers
where state is not null
order by state, city;

select state, city from customers
where state is not null
order by state, city;

--
select 1 and 1;
select 1 and 0, 0 and 1, 0 and 0, 1 and 1;
select 1 and 0, 0 and 1, 0 and 0, 0 and null;
select 1 and null, null and null;
select 1 = 0 and 1/0; -- When evaluating an expression that contains the AND operator, MySQL stops evaluating the remaining parts of the expression as soon as it can determine the result.This is called short-circuit evaluation.

select customername, country, state from customers
where country = 'USA' AND state = 'CA';

select customername, country, state, creditlimit from customers
where country = 'USA' and state ='CA' and creditlimit > 100000;

--
select 1 or 1, 1 or 0, 0 or 1;

select 0 or 0;

select 1 or null, 0 or null, null or null;

select 1 = 1 or 1/0; -- or operator and short-circuit evaluation

select 1 or 0 and 0; -- Since the AND operator has higher precedence than the OR operator, MySQL evaluates the AND operator before the OR operator. 

-- How it works. 1 OR 0 AND 0 = 1 OR 0 = 1

-- to change the order of evaluation, use parenthesis
select (1 or 0) and 0; -- How it works.(1 OR 0) AND 0 = 1 AND 0 = 0

select customername, country from customers
where country = 'USA' or country = 'France' order by country;

select customername, country, creditlimit  from customers
where (country = 'USA' or country = 'France') and creditlimit > 100000;

select customername, country, creditlimit  from customers
where country = 'USA' or country = 'France' and creditlimit > 100000;

--
select null in (1, 2, 3); -- returns null

select 0 in (1, 2, 3, null); -- returns null

select null in (1, 2, 3, null); -- returns null as null is not equal to any value in the list and the list has one NULL. Note that NULL is not equal to NULL.

select officecode, city, phone, country from offices
where country in  ('USA', 'France');

select officecode, city, phone, country from offices
where country in  ('UK', 'Canada');


SELECT officeCode, city, phone FROM offices
WHERE country = 'USA' OR country = 'France'; -- generates same resut as above


--
select 1 not in (1, 2, 3); -- It returns 0 (false) because 1 is NOT IN the list is false.

select 0 not in (1, 2, 3);

select null not in (1, 2, 3);

select officecode, city, phone from offices
where country not in ('USA', 'France') order by city;

--

select 15 between 10 and 20; -- returns 1 as it is true
select 15 between 20 and 30; -- returns 0 as it is false

select 15 not between 10 and 20; -- returns 0 because 15 is not between 10 and 20 is not true

select productcode, productname, buyprice from products 
where buyprice between 90 and 100;


select productcode, productname, buyprice from products
where buyprice >= 90 and buyprice <= 100;

select productcode, productname, buyprice from products
where buyprice not between 20 and 100;

select productcode, productname, buyprice from products
where buyprice < 20 or buyprice > 100; -- rewiting the above query, generates same results as above

-- betwwen operator with dates
select ordernumber, requiredDate, status from orders
where requireddate between cast('2003-01-01' as date) and
							cast('2003-01-31' as date);
                            
--  we use the CAST() to cast the literal string '2003-01-01' into a DATE value

--

select employeenumber, lastname, firstname from employees
where firstname like 'a%';

select employeenumber, lastname, firstname from employees
where lastname like '%on';

select employeenumber, lastname, firstname from employees
where lastname like '%on%';

select employeenumber, lastname, firstname from employees
where firstname like 'T_m';

select employeenumber, lastname, firstname from employees
where lastname not like 'B%';

-- mysql like operator with the escape clause

-- if you want to find products whose product codes contain the string _20 , you can use the pattern %\_20% with the default escape character

select productcode, productname from products
where productcode like '%\_20%'; 

--  Alternatively, you can specify a different escape character e.g., $ using the ESCAPE clause

select productcode, productname from products
where productcode like '%$_20%' escape '$';
-- The pattern %$_20% matches any string that contains the _20 string.


--
select customernumber, customername, creditlimit
from customers order by creditlimit desc limit 5;

select customernumber, customername, creditlimit from customers order by creditlimit
limit 5;

select customernumber, customername, creditlimit from customers
order by creditlimit, customernumber limit 5;

-- limit for pagination

select count(*) from customers;

-- Suppose that each page has 10 rows; to display 122 customers, you have 13 pages. The last 13th page contains two rows only.
-- This query uses the LIMIT clause to get rows of page 1 which contains the first 10 customers sorted by the customer name:

select customernumber, customername from customers
order by customername
limit 10;

-- This query uses the LIMIT clause to get the rows of the second page that include rows 11 – 20:
select customernumber, customername from customers order by customerName
limit 10, 10;


-- using LIMIT to get the nth highest or lowest value

-- To get the nth highest or lowest value, you use the following LIMIT clause:

-- SELECT select_list
-- FROM table_name
-- ORDER BY sort_expression
-- LIMIT n-1, 1;
-- Code language: SQL (Structured Query Language) (sql)
-- The clause LIMIT n-1, 1 returns 1 row starting at the row n.

-- the following finds the customer who has the second-highest credit:

select customername, creditlimit from customers
order by creditlimit desc
limit 1,1;

-- double check
select customername, creditlimit
from customers
order by creditlimit desc;

-- limit and distinct cluase
select distinct state from customers where state is not null
limit 5;

--
select 1 is null, -- returns 0 as false
 0 is null, -- returns 0
 null is null;  -- returns 1
 
 select 1 is not null, -- 1 as true
 0 is not null, -- 1
 null is not null; -- 0
 
SELECT customerName, country, salesrepemployeenumber FROM customers
WHERE salesrepemployeenumber IS NULL
ORDER BY customerName; 

 SELECT customerName, country, salesrepemployeenumber FROM customers
WHERE salesrepemployeenumber IS NOT NULL
ORDER BY customerName; 
 
 -- is null (specialized features) 1. treatment of date '0000-00-00'
create table if not exists projects (
id int auto_increment,
title varchar(225),
begin_date date not null,
complete_date date not null,
primary key(id) );

insert into projects(title,begin_date, complete_date)
values('New CRM','2020-01-01','0000-00-00'),
      ('ERP Future','2020-01-01','0000-00-00'),
      ('VR','2020-01-01','2030-01-01');
 -- Error Code: 1292. Incorrect date value: '0000-00-00' for column 'complete_date' at row 1


insert into projects(title,begin_date, complete_date)
values('New CRM','2020-01-01', null),
      ('ERP Future','2020-01-01', null),
      ('VR','2020-01-01','2030-01-01');
-- Error Code: 1048. Column 'complete_date' cannot be null

SELECT *  FROM projects WHERE complete_date IS NULL;

-- Influence of @@sql_auto_is_null variable

SET @@sql_auto_is_null = 1;

INSERT INTO projects(title,begin_date, complete_date)
VALUES('MRP III','2010-01-01','2020-12-31');

SELECT id FROM projects WHERE id IS NULL;



