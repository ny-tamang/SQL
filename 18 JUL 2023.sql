drop table if exists checklists;
drop table if exists tasks;

create table tasks(
    id int auto_increment primary key,
    title varchar(225) not null,
    start_date date not null,
    end_date date
);


INSERT INTO tasks(title ,start_date, end_date)
VALUES('Learn MySQL NOT NULL constraint', '2017-02-01','2017-02-02'),
      ('Check and update NOT NULL constraint to your database', '2017-02-01',NULL);

select  * from tasks where end_date is null;

update tasks set end_date = start_date +7 where end_date is null;

select * from tasks;

alter table tasks change end_date
    end_date not null; -- You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'not null' at line 1

alter table tasks modify end_date date not null; --  Invalid use of NULL value

select current_time;

alter table tasks change end_date
    end_date date not null; -- Invalid use of NULL value

describe tasks;

alter table tasks modify end_date end_date date not null;

CREATE TABLE users(
   user_id INT AUTO_INCREMENT PRIMARY KEY,
   username VARCHAR(40),
   password VARCHAR(255),
   email VARCHAR(255)
);

CREATE TABLE roles(
   role_id INT AUTO_INCREMENT,
   role_name VARCHAR(50),
   PRIMARY KEY(role_id)
);

CREATE TABLE user_roles(
   user_id INT,
   role_id INT,
   PRIMARY KEY(user_id,role_id),
   FOREIGN KEY(user_id) REFERENCES users(user_id),
   FOREIGN KEY(role_id) REFERENCES roles(role_id)
);

CREATE TABLE pkdemos(
   id INT,
   title VARCHAR(255) NOT NULL
);

alter table pkdemos add primary key (id);

alter table users add unique index username_unique(email ASC);


create database fkdemo;

use fkdemo;

create table categories(
    categoryId int auto_increment primary key,
    categoryName varchar(100) not null
)engine = innodb;

CREATE TABLE products(
    productId INT AUTO_INCREMENT PRIMARY KEY,
    productName varchar(100) not null,
    categoryId INT,
    CONSTRAINT fk_category
    FOREIGN KEY (categoryId)
        REFERENCES categories(categoryId)
) ENGINE=INNODB;

INSERT INTO categories(categoryName) VALUES ('Smartphone'), ('Smartwatch');

select * from categories;

INSERT INTO products(productName, categoryId) VALUES('iPhone',1);

INSERT INTO products(productName, categoryId) VALUES('iPad',3); -- Cannot add or update a child row: a foreign key constraint fails (`fkdemo`.`products`, CONSTRAINT `fk_category` FOREIGN KEY (`categoryId`) REFERENCES `categories` (`categoryId`))

update categories set categoryId = 100 where categoryid = 1;
-- Cannot delete or update a parent row: a foreign key constraint fails (`fkdemo`.`products`, CONSTRAINT `fk_category` FOREIGN KEY (`categoryId`) REFERENCES `categories` (`categoryId`))

drop table if exists products;

show tables;

create table products(
    productid int auto_increment primary key,
    productname varchar(100) not null,
    categoryid int not null,
    constraint fk_category
                     foreign key (categoryid) references categories(categoryId)
                     on delete cascade on update cascade
)engine = innodb;


INSERT INTO products(productName, categoryId) VALUES ('iPhone', 1), ('Galaxy Note',1), ('Apple Watch',2), ('Samsung Galary Watch',2);

select * from products;

UPDATE categories SET categoryId = 100 WHERE categoryId = 1;

select * from categories;

select * from products;

delete from categories where categoryid =2;

select * from categories;

select * from products;


--
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS products;

CREATE TABLE categories(
    categoryId INT AUTO_INCREMENT PRIMARY KEY,
    categoryName VARCHAR(100) NOT NULL
)ENGINE=INNODB;

CREATE TABLE products(
    productId INT AUTO_INCREMENT PRIMARY KEY,
    productName varchar(100) not null,
    categoryId INT,
    CONSTRAINT fk_category
    FOREIGN KEY (categoryId)
        REFERENCES categories(categoryId)
        ON UPDATE SET NULL
        ON DELETE SET NULL
)ENGINE=INNODB;


INSERT INTO categories(categoryName)
VALUES
    ('Smartphone'),
    ('Smartwatch');

INSERT INTO products(productName, categoryId)
VALUES
    ('iPhone', 1),
    ('Galaxy Note',1),
    ('Apple Watch',2),
    ('Samsung Galaxy Watch',2);

UPDATE categories
SET categoryId = 01
WHERE categoryId = 1;

select * from categories;

DELETE FROM categories WHERE categoryId = 2;

select * from products;

show create table products;

set foreign_key_checks = 0; -- to disable foreign key checks

set foreign_key_checks = 1; -- To enable foreign key checks

--
--
use classicmodels;

CREATE TABLE suppliers (
    supplier_id INT AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(15) NOT NULL UNIQUE,
    address VARCHAR(255) NOT NULL,
    PRIMARY KEY (supplier_id),
    CONSTRAINT uc_name_address UNIQUE (name , address)
);

INSERT INTO suppliers(name, phone, address)
VALUES( 'ABC Inc',
       '(408)-908-2476',
       '4000 North 1st Street');

INSERT INTO suppliers(name, phone, address)
VALUES( 'XYZ Corporation','(408)-908-2476','3000 North 1st Street'); -- Duplicate entry '(408)-908-2476' for key 'suppliers.phone'


INSERT INTO suppliers(name, phone, address)
VALUES( 'XYZ Corporation','(408)-908-3333','3000 North 1st Street');


INSERT INTO suppliers(name, phone, address)
VALUES( 'ABC Inc',
       '(408)-908-1111',
       '4000 North 1st Street');
 -- Duplicate entry 'ABC Inc-4000 North 1st Street' for key 'suppliers.uc_name_address'

 show create table suppliers;

show index from suppliers;

drop index uc_name_address on suppliers;

show index from suppliers;

-- add new unique constraint

alter table suppliers add constraint uc_name_address unique (name, address);

show index from suppliers;