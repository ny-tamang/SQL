-- 19 JUL
-- check constraint

use classicmodels;
create table parts(
    part_no varchar(18) primary key ,
    description varchar(40),
    cost decimal(10, 2) not null check (cost >= 0 ),
    price decimal(10, 2) not null check (price >= 0)
);

show create table parts;


INSERT INTO parts(part_no, description,cost,price) VALUES('A-001','Cooler',0,-100); -- INSERT INTO parts(part_no, description,cost,price)
-- Check constraint 'parts_chk_2' is violated.

drop table if exists parts;


create table parts(
    part_no varchar(18) primary key ,
    description varchar(40),
    cost decimal(10, 2) not null check (cost >= 0 ),
    price decimal(10, 2) not null check (price >= 0),
    constraint  parts_chk_price_gt_cost check (price >= cost)
);

show create table parts;


INSERT INTO parts(part_no, description,cost,price)VALUES('A-001','Cooler',200,100); -- Check constraint 'parts_chk_price_gt_cost' is violated.


--
-- default constraint

  create table cart_items(
      item_id int auto_increment primary key,
      name varchar(225) not null,
      quantity int not null,
      price dec(5,2) not null,
      sales_tax dec(5,2) not null default 0.1,
      check ( quantity > 0),
      check ( sales_tax >= 0)
  );

select * from cart_items;

INSERT INTO cart_items(name, quantity, price)
VALUES('Keyboard', 1, 50);

select * from cart_items;

INSERT INTO cart_items(name, quantity, price, sales_tax)
VALUES('Battery',4, 0.25 , DEFAULT);

select * from cart_items;

alter table cart_items alter column quantity set default 1;

INSERT INTO cart_items(name, price, sales_tax)
VALUES('Maintenance services',25.99, 0);

--
-- check constraint emulation
drop table parts;

CREATE TABLE IF NOT EXISTS parts (
    part_no VARCHAR(18) PRIMARY KEY,
    description VARCHAR(40),
    cost DECIMAL(10 , 2 ) NOT NULL,
    price DECIMAL(10,2) NOT NULL
);

-- creating a stored procedure for checking the values in the cost and price

delimiter //
create procedure 'check_parts'(in cost decimal(10,2), in price decimal(10,2))
begin if cost < 0 then
    signal sqlstate '45000'
    set message_text = 'check constraint on part.cost failed';
end if;

if price < 0 then
     signal sqlstate '45001'
    set message_text = 'check constraints on part.price failed';
end if;
end//
delimiter ;
-- You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near ''check_parts'(in cost decimal(10,2), in price decimal(10,2))
-- [2023-07-19 12:29:09] begin if cost < 0 ' at line 1


delimiter //
create procedure `check_parts`(in cost decimal(10,2), in price decimal(10,2))
begin
    if cost < 0 then
        signal sqlstate '45000'
        set message_text = 'check constraint on part.cost failed';
    end if;

    if price < 0 then
        signal sqlstate '45001'
        set message_text = 'check constraints on part.price failed';
    end if;
end //
delimiter ;


-- creating triggers before insert and before update
delimiter //
create trigger `parts_before_insert` before insert on `parts`
    for each row
    begin call check_parts(new.cost, new.price);
    end //
delimiter ;

delimiter //
create trigger `parts_before_update` before update on `parts`
    for each row
    begin
        call check_parts(new.cost, new.price);
    end //
delimiter ;

INSERT INTO parts(part_no, description,cost,price)
VALUES('A-001','Cooler',100,120);

INSERT INTO parts(part_no, description,cost,price)
VALUES('A-002','Heater',-100,120); -- check constraint on part.cost failed, must be greater than 0

INSERT INTO parts(part_no, description,cost,price)
VALUES('A-002','Heater',100,-120); -- check constraints on part.price failed, must be greater than 0

select * from parts;

update parts set price = 10 where part_no = 'A-001';

select * from parts;

DROP TABLE IF EXISTS parts;

CREATE TABLE IF NOT EXISTS parts_data (
    part_no VARCHAR(18) PRIMARY KEY,
    description VARCHAR(40),
    cost DECIMAL(10,2) NOT NULL,
    price DECIMAL(10,2) NOT NULL
);

create view part as
    select part_no, description, cost, price from parts_data
where cost > 0 and price > 0 and price >= cost
with check option;

INSERT INTO part(part_no, description,cost,price)
VALUES('A-001','Cooler',100,120);

INSERT INTO parts_checked(part_no, description,cost,price)
VALUES('A-002','Heater',-100,120); -- 'classicmodels.parts_checked' doesn't exist
-- Error Code: 1369. CHECK OPTION failed 'classicmodels.parts_checked'