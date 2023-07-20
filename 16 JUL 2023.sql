use classicmodels;

start transaction;
select  @orderNumber:= MAX(ordernumber)+1 from orders;
insert into orders(orderNumber, orderDate, requiredDate, shippedDate, status,customerNUmber)
VALUES(@orderNumber,
       '2005-05-31',
       '2005-06-10',
       '2005-06-11',
       'In Process',
        145);
        
INSERT INTO orderdetails(orderNumber,
                         productCode,
                         quantityOrdered,
                         priceEach,
                         orderLineNumber)
VALUES(@orderNumber,'S18_1749', 30, '136', 1),
      (@orderNumber,'S18_2248', 50, '55.09', 2); 
      
commit;

select a.ordernumber, orderdate, requireddate, shippeddate, status, comments, customernumber, orderlinenumber, productcode, quantityordered, priceeach
from orders a inner join orderdetails b using(ordernumber)
where a.ordernumber = 10423;


-- rollback
-- in 1st session
-- mysql> use classicmodels;
-- Database changed
-- mysql> start transaction;
-- Query OK, 0 rows affected (0.00 sec)

-- mysql> delete from orders;
-- ERROR 1451 (23000): Cannot delete or update a parent row: a foreign key constraint fails (`classicmodels`.`orderdetails`, CONSTRAINT `orderdetails_ibfk_1` FOREIGN KEY (`orderNumber`) REFERENCES `orders` (`orderNumber`))
-- mysql> delete from ordertails;
-- ERROR 1146 (42S02): Table 'classicmodels.ordertails' doesn't exist
-- mysql> delete from orderdetails;
-- Query OK, 2996 rows affected (0.09 sec)

-- -- note that do not close the first session
-- -- in second session 

-- mysql> use classicmodels;
-- Database changed
-- mysql> select count(*) from orderdetails;
-- +----------+
-- | count(*) |
-- +----------+
-- |     2996 |
-- +----------+
-- 1 row in set (0.01 sec)


-- in 1st session
-- mysql> rollback;
-- Query OK, 0 rows affected (0.06 sec)

-- mysql> select count(*) from orders;
-- +----------+
-- | count(*) |
-- +----------+
-- |      326 |
-- +----------+
-- 1 row in set (0.00 sec)


-- table locking

create table messages (
id int not null auto_increment,
message varchar(100) not null,
primary key(id));


select connection_id(); -- 30

insert into messages(message) values ('hello');

select * from messages;

lock table messages read;

insert into messages(message) values('Hi');
-- Error Code: 1099. Table 'messages' was locked with a READ lock and can't be updated


-- in another session - in another local instance
use classicmodels;
select connection_id(); -- 30
select * from messages;
insert into messages(message) values('bye');
-- Running duration =?..

-- in the 1st session
show processlist; -- '30', 'root', 'localhost:57494', 'classicmodels', 'Query', '112', 'Waiting for table metadata lock', 'insert into messages(message) values(\'bye\')'

unlock tables;

select * from messages; -- finally the bye message is inserted after the tables are unlocked

--
--
-- write locks
lock table messages write;

insert into messages(message) values ('Good Morning');

select * from messages;

-- in second session
insert into messages(message) values('Bye Bye');
-- 12:29:52	insert into messages(message) values('Bye Bye')	Running...	?

show processlist; -- '30', 'root', 'localhost:57494', 'classicmodels', 'Query', '57', 'Waiting for table metadata lock', 'insert into messages(message) values(\'Bye Bye\')'

unlock tables;

select * from messages; -- insert clause is run of the second session.

-- truncate table
CREATE TABLE books (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL
)  ENGINE=INNODB;

drop procedure load_book_data;
delimiter //
create procedure load_book_data(in num int(4))
begin
declare counter int(4) default 0;
declare book_title varchar(255) default '';

while counter < num do
set book_title = concat('Book Title #', counter);
set counter = counter + 1;
insert into books(title) values(book_title);
end while;
end //
delimiter ;

call load_book_data(10000); -- Error Code: 1054. Unknown column 'book' in 'field list'

select * from books;

truncate table books; -- o delete all rows from the books table:

-- 
CREATE TABLE IF NOT EXISTS tasks (
    task_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    start_date DATE,
    due_date DATE,
    status TINYINT NOT NULL,
    priority TINYINT NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)  ENGINE=INNODB;

describe tasks;

CREATE TABLE IF NOT EXISTS checklists (
    todo_id INT AUTO_INCREMENT,
    task_id INT,
    todo VARCHAR(255) NOT NULL,
    is_completed BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (todo_id , task_id),
    FOREIGN KEY (task_id)
        REFERENCES tasks (task_id)
        ON UPDATE RESTRICT ON DELETE CASCADE
);

--
-- alter

CREATE TABLE vehicles (
    vehicleId INT,
    year INT NOT NULL,
    make VARCHAR(100) NOT NULL,
    PRIMARY KEY(vehicleId)
);

alter table vehicles
add model varchar(100) not null;

describe vehicles;

alter table vehicles add color varchar(50),
add mote varchar(225);

describe vehicles;

alter table vehicles modify mote varchar(100) not null;

describe vehicles;

alter table vehicles
modify year smallint not null, modify color varchar(20) null after make;

describe vehicles;

alter table vehicles
change column mote vehicleCondition varchar(100) not null; -- renaming the column

describe vehicles;

alter table vehicles drop column vehiclecondition;

alter table vehicles rename to cars; -- renaming the table.

describe cars;

CREATE DATABASE IF NOT EXISTS hr;

use hr;

CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_name VARCHAR(100)
);

CREATE TABLE employees (
    id int AUTO_INCREMENT primary key,
    first_name varchar(50) not null,
    last_name varchar(50) not null,
    department_id int not null,
    FOREIGN KEY (department_id)
        REFERENCES departments (department_id)
);


INSERT INTO departments(dept_name)
VALUES('Sales'),('Markting'),('Finance'),('Accounting'),('Warehouses'),('Production');

INSERT INTO employees(first_name,last_name,department_id) 
VALUES('John','Doe',1),
		('Bush','Lily',2),
		('David','Dave',3),
		('Mary','Jane',4),
		('Jonatha','Josh',5),
		('Mateo','More',1);
        
select id, first_name, last_name, department_id from employees;
select department_id, dept_name from departments;

CREATE VIEW v_employee_info as
    SELECT id, first_name, last_name, dept_name from employees
	inner join departments USING (department_id);
    
select * from v_employee_info;

rename table employees to people;

select * from v_employee_info;
-- Error Code: 1356. View 'hr.v_employee_info' references invalid table(s) or column(s) or function(s) or definer/invoker of view lack rights to use them


select * from employees;
-- Error Code: 1146. Table 'hr.employees' doesn't exist

select * from people;

check table v_employee_info;

rename table people to employees;

check table v_employee_info;

delimiter //
create procedure get_employee(in p_id int)
begin select first_name, last_name, dept_name from employees
inner join departments using (department_id) where id = p_id;
end //
delimiter ;

call get_employee(1);

rename table employees to people;

call get_employee(2); -- Error Code: 1146. Table 'hr.employees' doesn't exist
-- To fix this, we must manually change the employees table in the stored procedure to people table

rename table departments to depts;

delete from depts where department_id = 1; -- Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails (`hr`.`people`, CONSTRAINT `people_ibfk_1` FOREIGN KEY (`department_id`) REFERENCES `depts` (`department_id`))

rename table depts to departments,
people to employeees;

rename table employeees to employees;

create temporary table lastnames as
select distinct last_name from employees; 

rename table lastnames to unique_lastnames; 
-- Error Code: 1146. Table 'hr.lastnames' doesn't exist

alter table lastnames rename to unique_lastnames;

describe lastnames; -- Error Code: 1146. Table 'hr.lastnames' doesn't exist

drop table lastnames;

--
--
use classicmodels;
create table if not exists vendors (
id int auto_increment primary key,
name varchar(225));

ALTER TABLE vendors
ADD COLUMN phone VARCHAR(15) AFTER name;

alter table vendors add column vendor_group int not null;

INSERT INTO vendors(name,phone,vendor_group)
VALUES('IBM','(408)-298-2987',1);

INSERT INTO vendors(name,phone,vendor_group)
VALUES('Microsoft','(408)-298-2988',1);

select id, name, phone, vendor_group from vendors;

ALTER TABLE vendors
ADD COLUMN email VARCHAR(100) NOT NULL,
ADD COLUMN hourly_rate decimal(10,2) NOT NULL;

describe vendors;

select id, name , phone, vendor_group, email, hourly_rate from vendors;

alter table vendors add column vendor_group int not null;
-- Error Code: 1060. Duplicate column name 'vendor_group'

select if(count(*) = 1, 'exist', 'not exist') as result from information_schema.columns
where table_schema = 'classicmodels'
and table_name = 'vendors'
and column_name = 'phone';


--
--
CREATE TABLE posts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    excerpt VARCHAR(400),
    content TEXT,
    created_at DATETIME,
    updated_at DATETIME
);

alter table posts drop column excerpt;

describe posts;

alter table posts drop column created_at,
drop column updated_at;

describe posts;

create table categories(
id int auto_increment primary key,
name varchar(225));

alter table posts
add column category_id int not null;

alter table posts add constraint fk_cat foreign key (category_id) references categories(id);
-- Error Code: 1824. Failed to open the referenced table 'categories'

alter table posts add constraint fk_cat foreign key (category_id) references categories(id);


alter table posts drop column category_id; -- Error Code: 1828. Cannot drop column 'category_id': needed in a foreign key constraint 'fk_cat'

--
--
CREATE TABLE insurances (
    id INT AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    effectiveDate DATE NOT NULL,
    duration INT NOT NULL,
    amount DEC(10 , 2 ) NOT NULL,
    PRIMARY KEY(id)
);

drop table insurances;


CREATE TABLE CarAccessories (
    id INT AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    price DEC(10 , 2 ) NOT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE CarGadgets (
    id INT AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    price DEC(10 , 2 ) NOT NULL,
    PRIMARY KEY(id)
);

drop table caraccessories, cargadgets;

