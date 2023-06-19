
create table if not exists employee
( emp_ID int
, emp_NAME varchar(50)
, DEPT_NAME varchar(50)
, SALARY int);

insert into employee values(101, 'Mohan', 'Admin', 4000);
insert into employee values(102, 'Rajkumar', 'HR', 3000);
insert into employee values(103, 'Akbar', 'IT', 4000);
insert into employee values(104, 'Dorvin', 'Finance', 6500);
insert into employee values(105, 'Rohit', 'HR', 3000);
insert into employee values(106, 'Rajesh',  'Finance', 5000);
insert into employee values(107, 'Preet', 'HR', 7000);
insert into employee values(108, 'Maryam', 'Admin', 4000);
insert into employee values(109, 'Sanjay', 'IT', 6500);
insert into employee values(110, 'Vasudha', 'IT', 7000);
insert into employee values(111, 'Melinda', 'IT', 8000);
insert into employee values(112, 'Komal', 'IT', 10000);
insert into employee values(113, 'Gautham', 'Admin', 2000);
insert into employee values(114, 'Manisha', 'HR', 3000);
insert into employee values(115, 'Chandni', 'IT', 4500);
insert into employee values(116, 'Satya', 'Finance', 6500);
insert into employee values(117, 'Adarsh', 'HR', 3500);
insert into employee values(118, 'Tejaswi', 'Finance', 5500);
insert into employee values(119, 'Cory', 'HR', 8000);
insert into employee values(120, 'Monica', 'Admin', 5000);
insert into employee values(121, 'Rosalin', 'IT', 6000);
insert into employee values(122, 'Ibrahim', 'IT', 8000);
insert into employee values(123, 'Vikram', 'IT', 8000);
insert into employee values(124, 'Dheeraj', 'IT', 11000);
COMMIT;

select * from employee as e;

-- Window Functions in SQL which is also referred to as Analytic Function in some of the RDBMS
SELECT e.*, MAX(e.Salary) OVER (PARTITION BY e.dept_name) AS max_salary FROM employee e;

-- row number
select e.*,
row_number()
OVER(PARTITION BY dept_name) as rn
from employee e;

-- fetch the first two employees to join the company--

select * from (
select e.*,
row_number()
OVER(PARTITION BY dept_name order by emp_id) as rn
from employee e ) x
where x.rn < 3;


-- rank()
-- fetch the top 3 employees from each department  earning the max salary

SELECT *
FROM (
    SELECT e.*, RANK() OVER (PARTITION BY dept_name ORDER BY salary DESC) AS rnk
    FROM employee e
) x
WHERE x.rnk < 4;


-- revision---

select *  from(
select e.*,
rank() OVER(partition by dept_name order by salary DESC) as rnk,
dense_rank() OVER(partition by DEPT_NAME order by salary DESC) as dense_rnk,
row_number() OVER(PARTITION BY dept_name order by emp_id) as rn
from employee e) x
where x.rnk < 4;

-- lag() and lead()

select e.*,
lag(salary) over (PARTITION by dept_name order by emp_id) as prev_emp_salary,
lead(salary) over (PARTITION by dept_name order by emp_id) as next_emp_salary
from employee e;


-- fetch a query to display if the salary of the employee is higher, lower or equal to the previous employee

select e.*,
lag(salary) over (PARTITION by dept_name order by emp_id) as prev_emp_salary,
case when e.salary > lag(Salary) over (PARTITION by   dept_name order by emp_id) then 'Higher than the previous salary'
     when e.salary < lag(Salary) over (PARTITION BY dept_name order by emp_id) then 'Lower than the previous salary'
     when e.salary = lag(salary) over (PARTITION by dept_name order by emp_id) then 'Equal to the previous salary'
    end sal_range
from employee e;


-- product table

select * from product;
-- first_value()
-- query to display the most expensive product under each category (corresponding to each record)

select *,
first_value(product_name)
over (PARTITION BY product_category order by price DESC)
as most_expensive_product
from product;

-- last_value()-
-- query to display the least expensive product under each category (corresponding to each record)
select *,
first_value(product_name)
over (PARTITION BY product_category order by price DESC) as most_expensive_product,
last_value(product_name)
over (PARTITION by product_category order by price DESC) as least_expensive_product
from product;


-- HOWEVER ON RUNNING THIS QUERY THE OUTPUT IS NOT THE RESULT WE WANTED. IT IS DUE TO THE FRAME CLAUSE

-- FRAME CLAUSE -> it is the subset of the partition
select *,
first_value(product_name)
    over (PARTITION BY product_category order by price DESC) as most_expensive_product,
last_value(product_name)
    over (PARTITION by product_category order by price DESC
    range between unbounded preceding and current ROW) as least_expensive_product -- this is the default frame clause
from product;

-- modified frame clause

select *,
first_value(product_name)
    over (PARTITION BY product_category order by price DESC)as most_expensive_product,
last_value(product_name)
    over (PARTITION by product_category order by price DESC
    range between unbounded preceding and unbounded following) as least_expensive_product
from product;


-- using the rows in the frame clause,
select *,
first_value(product_name)
    over (PARTITION BY product_category order by price DESC) as most_expensive_product,
last_value(product_name)
    over (PARTITION by product_category order by price DESC
    rows between unbounded preceding and unbounded following) as least_expensive_product
from product;

-- the difference between the range and the rows comes when we are looking the duplicate
/*
In the context of window functions in SQL, the ROWS and RANGE frame clauses define the window frame over which the window function operates.

1. ROWS frame clause: The ROWS frame clause specifies a physical range of rows within the partition. It operates based on the number of rows, rather than the actual values. For example, if you specify `ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING`, it means the window frame will include the current row and the two rows before and after it. The ROWS frame clause provides a fixed number of rows to include in the window frame.

2. RANGE frame clause: The RANGE frame clause operates based on the actual values in the window ordering. It considers the logical range of values rather than the physical position of the rows. The range is defined by the values, not the number of rows. It is commonly used with ordered data, such as dates or numeric values. For example, if you specify `RANGE BETWEEN INTERVAL '3' DAY PRECEDING AND INTERVAL '3' DAY FOLLOWING`, it means the window frame will include the rows within a range of 3 days before and after the current row based on the ordering of dates.

In summary, the ROWS frame clause operates on the physical position of rows, while the RANGE frame clause operates on the logical values in the ordering. The choice between ROWS and RANGE depends on the specific requirements and the type of data being analyzed. */

-- range frame clause is commonly used with the ordered data

-- difference between the range and rows

select *,
first_value(product_name)
    over (PARTITION BY product_category order by price DESC) as most_expensive_product,
last_value(product_name)
    over (PARTITION by product_category order by price DESC
    rows between unbounded preceding and unbounded following)
from product
where product_category='Phone'; -- duplicate values is not considered

select *,
first_value(product_name)
    over (PARTITION BY product_category order by price DESC) as most_expensive_product,
last_value(product_name)
    over (PARTITION by product_category order by price DESC
    range between unbounded preceding and unbounded following)
from product
where product_category='Phone'; -- duplicate values considered


-- other modification on the frame clause

select *,
first_value(product_name)
    over (PARTITION BY product_category order by price DESC) as most_expensive_product,
last_value(product_name)
    over (PARTITION by product_category order by price DESC
    RANGE between 2 preceding and 2 following)
from product;


-- alternate ways of writing the SQL QUERIES USING THE WINDOW FXN
-- repeating the over() is not considered good
select *,
first_value(product_name) over w as most_expensive_product,
last_value(product_name) over w as least_expensive_product
from product
where product_category='Phone'
WINDOW w as (PARTITION by product_category order by price DESC
    range between unbounded preceding and unbounded following);

-- nth value similar to the first value and the last value
select *,
first_value(product_name) over w as most_expensive_product,
last_value(product_name) over w as least_expensive_product,
nth_value(product_name, 2) over w as second_most_expensive_product
from product
WINDOW w as (PARTITION by product_category order by price DESC
    range between unbounded preceding and unbounded following);

select *,
first_value(product_name) over w as most_expensive_product,
last_value(product_name) over w as least_expensive_product,
nth_value(product_name, 5) over w as second_most_expensive_product -- searches for the 5th record in the partition and prints the fifth record but if there is no value then the value will be set as null)
from product
WINDOW w as (PARTITION by product_category order by price DESC
    range between unbounded preceding and unbounded following);

-- ntile -> used to group together the set of data within the partition and place it into certain buckets.
-- Write a query to segregate all the expensive phones, mid range phones and the cheaper phones.

-- here we are creating three different bucket of expensive, mid range and cheap products.

SELECT product_name,
  CASE
    WHEN x.buckets = 1 THEN 'Expensive phone'
    WHEN x.buckets = 2 THEN 'Midrange phone'
    WHEN x.buckets = 3 THEN 'Cheaper phone'
  END AS category
FROM (
  SELECT *, NTILE(3) OVER (ORDER BY price DESC) AS buckets
  FROM product
  WHERE product_category = 'Phone'
) x;

-- cumt_dist()
-- always provide a value ranging from 0 to 1
-- formula = current row no (or Row no with value same as current row)/ Total no of rows

-- query to fetch all products which are constituting first 30% of the data in the products table based on price.

select *,
cume_dist() over (order BY price desc) as cume_distribution,
round(cume_dist() over (order BY price desc) *100, 2) as rounded_cume_distribution
from product;


SELECT product_name, cume_dist_percentage || '%') as cume_dist_percentage
from(select *,
cume_dist() over (order BY price desc) as cume_distribution,
round(cume_dist() over (order BY price desc) *100, 2) as rounded_cume_distribution)
from product )x
WHERE x.cume_dist_percentage <=30;

SELECT
  product_name,
  CONCAT(ROUND(cume_distribution * 100, 2), '%') AS cume_dist_percentage
FROM
  (SELECT
    *,
    cume_dist() OVER (ORDER BY price DESC) AS cume_distribution
  FROM
    product) x
WHERE
  x.cume_distribution <= 0.3;


-- percent_rank stands for percentage rank, provides the relative rank of the current row
-- similar to the cume_dist, value between the range of the 0 to 1
-- formula = current row no - 1/total no of rows -1

-- Query to identify how much percentage more expensive is " Galaxy Z fold 3" when compared to all products.

select *,
percent_rank() over (order by price) as percentage_rank
from product;

select product_name, per_rank
from(
select *,
percent_rank() over (order by price) as percentage_rank,
round(percent_rank() over (order by price)::numeric * 100, 2) as per_rank
from product) x
where x.product_name ='Galaxy Z Fold 3';

SELECT product_name, per_rank
FROM
  (SELECT
    *,
    -- percent_rank() OVER (ORDER BY price) AS percentage_rank,
    ROUND(percent_rank() OVER (ORDER BY price)* 100, 2) AS per_rank
  FROM product) x
WHERE x.product_name = 'Galaxy Z Fold 3';
