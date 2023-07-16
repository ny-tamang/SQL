use classicmodels;

-- query to get the top five products by sales revenue in 2003 from the orders and orderdetails

select productCode, round(sum(quantityOrdered * orderdetails.priceEach)) sales
from orderdetails inner join orders using (orderNumber)
where year(shippedDate) = 2003
group by productCode order by sales desc limit 5;

-- can use the result of this query as a derived table and join it with the products table

select productName, sales from
     (select productCode, round(sum(quantityOrdered * orderdetails.priceEach)) sales
      from orderdetails inner join orders using (orderNumber)
      where  year(shippedDate) = 2003
      group by productCode order by sales desc limit 5) top5products2003
inner join products using (productCode);

-- First, the subquery is executed to create a result set or derived table.
-- Then, the outer query is executed that joined the top5product2003 derived table with the products table using the productCode column.

select customerNumber, round(sum(quantityOrdered * priceEach)) sales,
       (case
           when sum(quantityOrdered * priceEach) < 10000 then 'silver'
           when sum(quantityOrdered * priceEach) between 10000 and 100000 then 'gold'
           when sum(quantityOrdered * priceEach) > 100000 then 'platinum'
    end) customergroup
from orderdetails inner join orders using (orderNumber)
where year(shippedDate) = 2003 group by customerNumber;


select customergroup, count(cg.customergroup) as groupcount
from (
    select customerNumber, round(sum(quantityOrdered * priceEach)) sales,
           (case when sales < 10000 then 'silver'
               when sales between 10000 and 100000 then 'gold'
               when sales > 100000 then 'platinum'
            end) customergroup
    from orderdetails inner join orders using (ordernumber)
    where year(shippedDate) = 2023
    group by customerNumber) cg
group by cg.customergroup; -- Unknown column 'sales' in 'field list'

select customergroup, count(cg.customergroup) as groupcount
from (
    select customerNumber, round(sum(quantityOrdered * priceEach)) sales,
           (case when sum(quantityOrdered * priceEach) < 10000 then 'silver'
               when sum(quantityOrdered * priceEach) between 10000 and 100000 then 'gold'
               when sum(quantityOrdered * priceEach) > 100000 then 'platinum'
            end) customergroup
    from orderdetails inner join orders using (ordernumber)
    where year(shippedDate) = 2023
    group by customerNumber) cg
group by cg.customergroup;



-- exists
SELECT customerNumber, customerName
FROM customers
WHERE EXISTS(
	SELECT 1 FROM orders WHERE orders.customernumber = customers.customernumber); -- returns the customer who has at least one order

SELECT customerNumber, customerName
FROM customers
WHERE NOT EXISTS(
	SELECT 1 FROM orders WHERE orders.customernumber = customers.customernumber); -- customers do not have any orders	
    
-- update exists
select employeenumber, firstname, lastname, extension from employees
where exists (select 1 from offices where city = 'San Francisco' and offices.officecode = employees.officecode);

update employees
set extension = concat(extension, '1')
where exists (select 1 from offices where city  = 'San Francisco' and offices.officecode = employees.officecode);
-- Error Code: 1175. You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column.  To disable safe mode, toggle the option in Preferences -> SQL Editor and reconnect.

-- insert exists
create table customers_archive like customers; -- creating a new tale for archiving the customers by copying the structure from the customers table

insert into customers_archive select * from customers where not exists(
select 1 from orders where orders.customernumber = customers.customernumber); -- insert customers who do not have any sales order

select * from customers_archive; -- query data to verify the insert operation


-- delete exists
delete from customers where exists(
select 1 from customers_archive a where a.customernumber = customers.customerNumber); -- One final task in archiving the customer data is to delete the customers that exist in the customers_archive table from the customers table.

-- exists vs in

select customernumber, customername from customers 
where customernumber in (select customernumber from orders);

select * from customers;

EXPLAIN SELECT customerNumber, customerName
FROM customers
WHERE EXISTS( SELECT 1 FROM orders WHERE orders.customernumber = customers.customernumber);

SELECT customerNumber, customerName
FROM customers
WHERE customerNumber IN (SELECT customerNumber FROM orders);

SELECT employeenumber, firstname, lastname
FROM employees
WHERE officeCode IN (SELECT officeCode FROM offices WHERE offices.city = 'San Francisco');


-- A common table expression is a named temporary result set that exists only within the execution scope of a single SQL statement e.g.,SELECT, INSERT, UPDATE, or DELETE.
-- Similar to a derived table, a CTE is not stored as an object and last only during the execution of a query.

with customers_in_usa as(
select customername, state from customers where country = 'USA')
select customername from customers_in_usa where state = 'CA' order by customername; -- Error Code: 1146. Table 'classicmodels.customer_in_usa' doesn't exist

-- the name of the CTE is customers_in_usa, the query that defines the CTE returns two columns customerName and state. Hence, the customers_in_usa CTE returns all customers located in the USA.
-- After defining the customers_in_usa CTE, we referenced it in the SELECT statement to select only customers located in California.

with topsales2003 as (
select salesrepemployeenumber employeenumber, sum(quantityordered * priceeach) sales from orders inner join orderdetails using (ordernumber)
inner join customers using (customernumber)
where year(shippeddate) = 2003 and status = 'Shipped'
group by salesrepemployeenumber order by sales desc limit 5)
select employeenumber, firstname, lastname, sales from employees join topsales2003 using (employeenumber);

with salesrep as (
select employeenumber, concat(firstname, ' ', lastname) as salesrepname
from employees where jobtitle = 'Sales rep'),
customer_salesrep as (
select customername, salesrepname from customers
inner join salesrep on employeenumber = salesrepemployeenumber)
select * from customer_salesrep
order by customername;

-- 
-- recursive CTE

with recursive employee_paths as
( select employeenumber, reportsto managernumber, officecode, 1 lvl from employees
where reportsto is null union all
select e.employeenumber, e.reportsto, e.officecode, lvl+1 from employees e
inner join employee_paths ep 
on ep.employeenumber = e.reportsto)
select employeenumber, managernumber, lvl, city from employee_paths ep
inner join offices o using (officecode) order by lvl, city;


SELECT firstName, lastName FROM employees 
UNION 
SELECT contactFirstName, contactLastName FROM customers;

SELECT CONCAT(firstName,' ',lastName) fullname FROM employees 
UNION 
SELECT CONCAT(contactFirstName,' ',contactLastName) FROM customers;
    
SELECT concat(firstName,' ',lastName) fullname FROM employees 
UNION SELECT concat(contactFirstName,' ',contactLastName) FROM customers
ORDER BY fullname;


SELECT CONCAT(firstName, ' ', lastName) fullname, 'Employee' as contactType FROM employees 
UNION SELECT CONCAT(contactFirstName, ' ', contactLastName),'Customer' as contactType
FROM customers ORDER BY fullname;
    
SELECT CONCAT(firstName,' ',lastName) fullname FROM employees 
UNION SELECT CONCAT(contactFirstName,' ',contactLastName)
FROM customers ORDER BY 1;


-- emaluate minus operation using the left join
-- for intersection we use the inner join

CREATE TABLE IF NOT EXISTS tasks (
    task_id INT AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    start_date DATE,
    due_date DATE,
    priority TINYINT NOT NULL DEFAULT 3,
    description TEXT,
    PRIMARY KEY (task_id)
);

INSERT INTO tasks(title,priority)
VALUES('Learn MySQL INSERT Statement',1);

select * from tasks;

INSERT INTO tasks(title,priority)
VALUES('Understanding DEFAULT keyword in INSERT statement',DEFAULT);

select * from tasks; -- because the default value for the column priority is 3

INSERT INTO tasks(title, start_date, due_date)
VALUES('Insert date into table','2018-01-09','2018-09-15');

INSERT INTO tasks(title,start_date,due_date)
VALUES('Use current date for the task',CURRENT_DATE(),CURRENT_DATE());

INSERT INTO tasks(title, priority)
VALUES
	('My first task', 1),
	('It is the second task',2),
	('This is the third task of the week',3);
    
select * from tasks;

--
SHOW VARIABLES LIKE 'max_allowed_packet';

-- To set a new value for the max_allowed_packet variable:
-- SET GLOBAL max_allowed_packet=size;

drop table if exists projects;
CREATE TABLE projects(
	project_id INT AUTO_INCREMENT, 
	name VARCHAR(100) NOT NULL,
	start_date DATE,
	end_date DATE,
	PRIMARY KEY(project_id)
);

INSERT INTO projects(name, start_date, end_date)
VALUES
	('AI for Marketing','2019-08-01','2019-12-31'),
	('ML for Sales','2019-05-15','2019-11-20');

select * from projects;


--
CREATE TABLE suppliers (
    supplierNumber INT AUTO_INCREMENT,
    supplierName VARCHAR(50) NOT NULL,
    phone VARCHAR(50),
    addressLine1 VARCHAR(50),
    addressLine2 VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postalCode VARCHAR(50),
    country VARCHAR(50),
    customerNumber INT,
    PRIMARY KEY (supplierNumber)
);

SELECT customerNumber,customerName, phone, addressLine1, addressLine2, city, state, postalCode, country
FROM customers WHERE country = 'USA' AND state = 'CA';
    
-- to insert customers who locate in California USA from the  customers table into the  suppliers table:
INSERT INTO suppliers (
supplierName, phone, addressLine1, addressLine2, city, state, postalCode, country,customerNumber
)
SELECT customerName, phone, addressLine1, addressLine2, city, state , postalCode, country, customerNumber
FROM customers
WHERE country = 'USA' AND state = 'CA';
    
select * from suppliers;

CREATE TABLE stats (
    totalProduct INT,
    totalCustomer INT,
    totalOrder INT
);

INSERT INTO stats(totalProduct, totalCustomer, totalOrder)
VALUES(
	(SELECT COUNT(*) FROM products),
	(SELECT COUNT(*) FROM customers),
	(SELECT COUNT(*) FROM orders)
);

select * from stats;

--
CREATE TABLE devices (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100)
);

INSERT INTO devices(name) VALUES('Router F1'),('Switch 1'),('Switch 2');

SELECT id, name FROM devices; -- to verify insert

INSERT INTO devices(name) VALUES ('Printer') ON DUPLICATE KEY UPDATE name = 'Printer';

INSERT INTO devices(name) VALUES ('Printer');

-- finally insert a row with a duplicate value in the id column

INSERT INTO devices(id,name) VALUES (4,'Printer') 
ON DUPLICATE KEY UPDATE name = 'Central Printer';


CREATE TABLE subscribers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(50) NOT NULL UNIQUE
);


INSERT INTO subscribers(email)
VALUES('john.doe@gmail.com');

INSERT INTO subscribers(email)
VALUES('john.doe@gmail.com'), 
      ('jane.smith@ibm.com');
-- Error Code: 1062. Duplicate entry 'john.doe@gmail.com' for key 'subscribers.email'

INSERT IGNORE INTO subscribers(email)
VALUES('john.doe@gmail.com'), 
      ('jane.smith@ibm.com');

show warnings;

CREATE TABLE tokens (
    s VARCHAR(6)
);

INSERT INTO tokens VALUES('abcdefg');
-- Error Code: 1406. Data too long for column 's' at row 1

INSERT IGNORE INTO tokens VALUES('abcdefg');

show warnings;

--
--
SELECT firstname, lastname, email FROM employees WHERE employeeNumber = 1056;

update employees
set email ='mary.patterson@classicmodelcars.com' where employeenumber = 1056; -- 1 row(s) affected Rows matched: 1  Changed: 1  Warnings: 0

UPDATE employees 
SET lastname = 'Hill', email = 'mary.hill@classicmodelcars.com' WHERE employeeNumber = 1056;

-- to verify
select firstname, lastname, email from employees where employeenumber = 1056;

-- update clause to replace string
update employees
set email = replace(email, '@classicmodelcars.com', '@mysqlpractice.org')
where jobtitle = 'Sales Rep' and officecode = 6;
-- Error Code: 1175. You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column.  To disable safe mode, toggle the option in Preferences -> SQL Editor and reconnect.


-- to update the rows returned by select statement
SELECT customername, salesRepEmployeeNumber FROM customers
WHERE salesRepEmployeeNumber IS NULL;

select employeenumber from employees where jobtitle = 'Sales Rep'
order by rand() limit 1;

update customers set salesrepemployeenumber  =(
select employeenumber from employees where jobtitle = 'Sales rep' order by rand()
limit 1)
where salesrepemployeenumber is null;

SELECT salesRepEmployeeNumber FROM customers WHERE salesRepEmployeeNumber IS NULL; -- returns no row

--
--
CREATE DATABASE IF NOT EXISTS empdb;

USE empdb;

-- create tables
CREATE TABLE merits (
    performance INT(11) NOT NULL,
    percentage FLOAT NOT NULL,
    PRIMARY KEY (performance)
);

CREATE TABLE employees (
    emp_id INT(11) NOT NULL AUTO_INCREMENT,
    emp_name VARCHAR(255) NOT NULL,
    performance INT(11) DEFAULT NULL,
    salary FLOAT DEFAULT NULL,
    PRIMARY KEY (emp_id),
    CONSTRAINT fk_performance FOREIGN KEY (performance)
        REFERENCES merits (performance)
);

-- insert data for merits table
INSERT INTO merits(performance,percentage)
VALUES(1,0), (2,0.01), (3,0.03), (4,0.05), (5,0.08);

-- insert data for employees table
INSERT INTO employees(emp_name,performance,salary)      
VALUES('Mary Doe', 1, 50000),
      ('Cindy Smith', 3, 65000),
      ('Sue Greenspan', 4, 75000),
      ('Grace Dell', 5, 125000),
      ('Nancy Johnson', 3, 85000),
      ('John Doe', 2, 45000),
      ('Lily Bush', 3, 55000);
      
update employees inner join merits
on employees using(performance)
set salary = salary +salary * percentage;
-- Error Code: 1064. You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'using (performance) set salary = salary +salary * percentage' at line 2

update employees inner join merits
on employees.performance = merits.performance
set salary = salary +salary * percentage;

INSERT INTO employees(emp_name,performance,salary)
VALUES('Jack William',NULL,43000), ('Ricky Bond',NULL,52000);

update employees left join merits 
on employees.performance = merits.performance
set salary = salary + salary * 0.015
where merits.percentage is null;


--
--

use classicmodels;
DELETE FROM employees WHERE officeCode = 4;

DELETE FROM employees; -- to delete all rows

DELETE FROM customers ORDER BY customerName LIMIT 10;

DELETE FROM customers WHERE country = 'France' ORDER BY creditLimit LIMIT 5;

DELETE customers FROM customers LEFT JOIN orders ON customers.customerNumber = orders.customerNumber 
WHERE orderNumber IS NULL;
    
-- to verify
SELECT c.customerNumber, c.customerName, orderNumber
FROM customers c LEFT JOIN orders o ON c.customerNumber = o.customerNumber
WHERE orderNumber IS NULL;
    
-- on delete cascade
CREATE TABLE buildings (
    building_no INT PRIMARY KEY AUTO_INCREMENT,
    building_name VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL
);

CREATE TABLE rooms (
    room_no INT PRIMARY KEY AUTO_INCREMENT,
    room_name VARCHAR(255) NOT NULL,
    building_no INT NOT NULL,
    FOREIGN KEY (building_no)
        REFERENCES buildings (building_no)
        ON DELETE CASCADE
);

INSERT INTO buildings(building_name,address)
VALUES('ACME Headquaters','3950 North 1st Street CA 95134'),
      ('ACME Sales','5000 North 1st Street CA 95134');
      
SELECT * FROM buildings;

INSERT INTO rooms(room_name,building_no)
VALUES('Amazon',1),
      ('War Room',1),
      ('Office of CEO',1),
      ('Marketing',2),
      ('Showroom',2);
      
SELECT * FROM rooms;

DELETE FROM buildings 
WHERE building_no = 2;

SELECT * FROM rooms;


-- to find out the tables affected by teh on delete cascade

USE information_schema;

SELECT table_name FROM referential_constraints
WHERE constraint_schema = 'database_name' AND referenced_table_name = 'parent_table' AND delete_rule = 'CASCADE';


USE information_schema;
SELECT table_name FROM referential_constraints
WHERE constraint_schema = 'classicmodels' AND referenced_table_name = 'buildings' AND delete_rule = 'CASCADE';

--
create table cities(
id int auto_increment primary key,
name varchar(50),
population int not null
);

INSERT INTO cities(name,population)
VALUES('New York',8008278), ('Los Angeles',3694825), ('San Diego',1223405);

select * from cities;

replace into cities(id, population) values (2, 3696820); -- to insert a new row

select * from cities;

replace into cities set id = 4, name = 'Phoenix', population = 1768980; -- to update a row

select * from cities;

replace into cities(name, population)
select name, population from cities where id = 1;

select * from cities;

--
-- prepared statement
-- In order to use MySQL prepared statement, you use three following statements:
-- PREPARE – prepare a statement for execution.
-- EXECUTE – execute a prepared statement prepared by the PREPARE statement.
-- DEALLOCATE PREPARE – release a prepared statement.

prepare stmt1 from 
'select productcode, productname from products where productcode = ?';

set @pc = 'S10_1678'; -- variable pc for product code declared and its value set

execute stmt1 using @pc;

set @pc ='S12_1099'; -- variable value overridden

execute stmt1 using @pc;

deallocate prepare stmt1; -- releasing the prepared statement



