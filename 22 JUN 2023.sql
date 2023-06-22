 -- subscriber table --
 SELECT * FROM livedb.subscriber;

select email from livedb.subscriber where email like '%@gmail.com';

select email from livedb.subscriber where email like '%@burpcollaborator.net';

-- sms_report_sender_wise
SELECT * FROM livedb.sms_report_sender_wise order by sender_id;

show columns from livedb.sms_report_sender_wise;

select count(*) from livedb.sms_report_sender_wise; -- 7140






--- for  report --

SELECT * FROM livedb.sms_out_pools;

SELECT count(*) FROM livedb.sms_out_pools; -- 4275732

use livedb;


select distinct user_id from sms_out_pools;

select count(user_id) from (
select distinct user_id from sms_out_pools)
as subquery; -- 440 unique users

select id, user_id, status, operator_type, created_at from sms_out_pools;
select sms_out_pools.user_id, users.id, users.name,  sms_out_pools.status, sms_out_pools.operator_type, sms_out_pools.created_at 
from sms_out_pools inner join users 
on sms_out_pools.user_id = users.id;

select sms_out_pools.user_id, users.id, users.name,  sms_out_pools.status, sms_out_pools.operator_type, sms_out_pools.created_at 
from sms_out_pools inner join users 
on sms_out_pools.user_id = users.id
order by user_id, operator_type; -- Error Code: 2013. Lost connection to MySQL server during query	30.015 sec



-- New versions of MySQL WorkBench have an option to change specific timeouts.
-- So, made changes under Edit → Preferences → SQL Editor → DBMS connection read time out (in seconds): 30 Changed the value to 600.
-- Also unchecked limit rows as putting a limit in every time to search the whole data set gets tiresome.



select sms_out_pools.user_id, users.id, users.name,  sms_out_pools.status, sms_out_pools.operator_type, sms_out_pools.created_at 
from sms_out_pools inner join users 
on sms_out_pools.user_id = users.id
where user_id = 1
order by user_id, operator_type; 

select sms_out_pools.user_id, users.id, users.name,  sms_out_pools.status, sms_out_pools.operator_type, sms_out_pools.created_at 
from sms_out_pools inner join users 
on sms_out_pools.user_id = users.id
where user_id = 1
order by operator_type; 

SELECT COUNT(*) AS no_of_msg_sent
FROM sms_out_pools
INNER JOIN users ON sms_out_pools.user_id = users.id
where user_id = 1 and operator_type ='ntc' and sms_out_pools.status ='sent'; -- Aqhter Ali using ntc 32610 messages sent 


SELECT COUNT(*) AS no_of_msg_sent
FROM sms_out_pools
INNER JOIN users ON sms_out_pools.user_id = users.id
where user_id = 1 and operator_type ='ncell' and sms_out_pools.status ='sent'; -- Aqhter Ali using ncell 7108 messages sent 

SELECT COUNT(*) AS no_of_msg_sent
FROM sms_out_pools
INNER JOIN users ON sms_out_pools.user_id = users.id
where user_id = 1 and operator_type ='smartcell' and sms_out_pools.status ='sent'; -- Aqhter Ali using smartcell 756 messages sent 



SELECT users.id, users.name, COUNT(*) AS no_of_msg_sent
FROM sms_out_pools
INNER JOIN users ON sms_out_pools.user_id = users.id
WHERE sms_out_pools.operator_type = 'smartcell' AND sms_out_pools.status = 'sent'
GROUP BY users.id, users.name;


SELECT users.id, users.name, COUNT(*) AS no_of_msg_sent
FROM sms_out_pools
INNER JOIN users ON sms_out_pools.user_id = users.id
WHERE sms_out_pools.operator_type = 'ncell' AND sms_out_pools.status = 'sent'
GROUP BY users.id, users.name;

SELECT users.id, users.name, COUNT(*) AS no_of_msg_sent
FROM sms_out_pools
INNER JOIN users ON sms_out_pools.user_id = users.id
WHERE sms_out_pools.operator_type = 'ntc' AND sms_out_pools.status = 'sent'
GROUP BY users.id, users.name;

-- queries used for report

SELECT users.id, users.name, sms_out_pools.operator_type, COUNT(*) AS no_of_msg_sent
FROM sms_out_pools
INNER JOIN users ON sms_out_pools.user_id = users.id
WHERE sms_out_pools.operator_type = 'smartcell' AND sms_out_pools.status = 'sent'
GROUP BY users.id, users.name
order by users.id; -- 157 rows returned

SELECT users.id, users.name, sms_out_pools.operator_type, COUNT(*) AS no_of_msg_sent
FROM sms_out_pools
INNER JOIN users ON sms_out_pools.user_id = users.id
WHERE sms_out_pools.operator_type = 'ncell'
GROUP BY users.id, users.name
order by users.id; -- 374 rows returned

SELECT users.id, users.name, sms_out_pools.operator_type, COUNT(*) AS no_of_msg_sent
FROM sms_out_pools
INNER JOIN users ON sms_out_pools.user_id = users.id
WHERE sms_out_pools.operator_type = 'ntc'
GROUP BY users.id, users.name
order by users.id; -- 416 rows returned


SELECT users.id, users.name, DATE(sms_out_pools.created_at) AS sent_date, COUNT(*) AS no_of_msg_sent
FROM sms_out_pools
INNER JOIN users ON sms_out_pools.user_id = users.id
WHERE sms_out_pools.operator_type = 'smartcell'
GROUP BY users.id, users.name, sent_date
ORDER BY users.id, sent_date; -- 2111 rows returned

SELECT users.id, users.name, DATE(sms_out_pools.created_at) AS sent_date, COUNT(*) AS no_of_msg_sent
FROM sms_out_pools
INNER JOIN users ON sms_out_pools.user_id = users.id
WHERE sms_out_pools.operator_type = 'ncell'
GROUP BY users.id, users.name, sent_date
ORDER BY users.id, sent_date; -- 9671 rows returned


SELECT users.id, users.name, DATE(sms_out_pools.created_at) AS sent_date, COUNT(*) AS no_of_msg_sent
FROM sms_out_pools
INNER JOIN users ON sms_out_pools.user_id = users.id
WHERE sms_out_pools.operator_type = 'ntc'
GROUP BY users.id, users.name, sent_date
ORDER BY users.id, sent_date; -- 11401 rows returned


-- try --

SELECT 
  CASE 
    WHEN ROW_NUMBER() OVER (PARTITION BY users.id, users.name ORDER BY sent_date) = 1
    THEN users.id
    ELSE NULL
  END AS user_id,
  CASE 
    WHEN ROW_NUMBER() OVER (PARTITION BY users.id, users.name ORDER BY sent_date) = 1
    THEN users.name
    ELSE NULL
  END AS user_name,
  sent_date,
  row_count
FROM (
  SELECT users.id, users.name, DATE(sms_out_pools.created_at) AS sent_date, COUNT(*) AS row_count
  FROM sms_out_pools
  INNER JOIN users ON sms_out_pools.user_id = users.id
  WHERE sms_out_pools.operator_type = 'smartcell'
  GROUP BY users.id, users.name, sent_date
) AS subquery
ORDER BY user_id, sent_date;

SELECT u.id AS user_id, u.name AS user_name, subquery.sent_date, subquery.row_count
FROM (
  SELECT sms_out_pools.user_id, DATE(sms_out_pools.created_at) AS sent_date, COUNT(*) AS row_count
  FROM sms_out_pools
  WHERE sms_out_pools.operator_type = 'smartcell'
  GROUP BY sms_out_pools.user_id, sent_date
) AS subquery
JOIN users AS u ON subquery.user_id = u.id
ORDER BY user_id, sent_date;

-- 

SELECT 
  q1.id,
  q1.name,
  q1.sent_date,
  q1.no_of_msg_sent,
  q2.total_msg_sent
FROM (
  SELECT
    users.id,
    users.name,
    DATE(sms_out_pools.created_at) AS sent_date,
    COUNT(*) AS no_of_msg_sent
  FROM sms_out_pools
  INNER JOIN users ON sms_out_pools.user_id = users.id
  WHERE sms_out_pools.operator_type = 'ntc'
  GROUP BY users.id, users.name, sent_date
) AS q1
JOIN (
  SELECT
    users.id,
    COUNT(*) AS total_msg_sent
  FROM sms_out_pools
  INNER JOIN users ON sms_out_pools.user_id = users.id
  WHERE sms_out_pools.operator_type = 'ntc'
  GROUP BY users.id
) AS q2 ON q1.id = q2.id
ORDER BY q1.id, q1.sent_date;  -- 11401 row(s) returned


SELECT 
  q1.id,
  q1.name,
  q1.operator_type,
  q1.sent_date,
  q1.no_of_msg_sent,
  q2.total_msg_sent
FROM (
  SELECT
    users.id,
    users.name,
    DATE(sms_out_pools.created_at) AS sent_date,
    COUNT(*) AS no_of_msg_sent
  FROM sms_out_pools
  INNER JOIN users ON sms_out_pools.user_id = users.id
  -- WHERE sms_out_pools.operator_type = 'ntc'
  GROUP BY users.id, users.name, sent_date
) AS q1
JOIN (
  SELECT
    users.id,
    COUNT(*) AS total_msg_sent
  FROM sms_out_pools
  INNER JOIN users ON sms_out_pools.user_id = users.id
  -- WHERE sms_out_pools.operator_type = 'ntc'
  GROUP BY users.id, sms_out_pools.operator_type
) AS q2 ON q1.id = q2.id
ORDER BY q1.id, q1.sent_date;  -- Error Code: 1054. Unknown column 'q1.operator_type' in 'field list'



SELECT 
  q1.id,
  q1.name,
  q1.operator_type,
  q1.sent_date,
  q1.no_of_msg_sent,
  q2.total_msg_sent
FROM (
  SELECT
    users.id,
    users.name,
    sms_out_pools.operator_type,
    DATE(sms_out_pools.created_at) AS sent_date,
    COUNT(*) AS no_of_msg_sent
  FROM sms_out_pools
  INNER JOIN users ON sms_out_pools.user_id = users.id
  GROUP BY users.id, users.name, sms_out_pools.operator_type, sent_date
) AS q1
JOIN (
  SELECT
    users.id,
    sms_out_pools.operator_type,
    COUNT(*) AS total_msg_sent
  FROM sms_out_pools
  INNER JOIN users ON sms_out_pools.user_id = users.id
  GROUP BY users.id, sms_out_pools.operator_type
) AS q2 ON q1.id = q2.id AND q1.operator_type = q2.operator_type
ORDER BY q1.id, q1.sent_date;  -- 23183 rows returned

-- SELECT id, user_name, 'sent_date' AS column_name, sent_date AS column_value
-- FROM YourTable
-- UNION ALL
-- SELECT id, user_name, 'no_of_msg_sent' AS column_name, CAST(no_of_msg_sent as varchar) AS column_value
-- FROM YourTable;

-- Merging all

SELECT users.id, users.name, sms_out_pools.operator_type, COUNT(*) AS no_of_msg_sent
FROM sms_out_pools
INNER JOIN users ON sms_out_pools.user_id = users.id
WHERE sms_out_pools.operator_type = 'smartcell' AND sms_out_pools.status = 'sent'
GROUP BY users.id, users.name, sms_out_pools.operator_type
UNION ALL
SELECT users.id, users.name, sms_out_pools.operator_type, COUNT(*) AS no_of_msg_sent
FROM sms_out_pools
INNER JOIN users ON sms_out_pools.user_id = users.id
WHERE sms_out_pools.operator_type = 'ncell'
GROUP BY users.id, users.name, sms_out_pools.operator_type
UNION ALL
SELECT users.id, users.name, sms_out_pools.operator_type, COUNT(*) AS no_of_msg_sent
FROM sms_out_pools
INNER JOIN users ON sms_out_pools.user_id = users.id
WHERE sms_out_pools.operator_type = 'ntc'
GROUP BY users.id, users.name, sms_out_pools.operator_type
ORDER BY id, operator_type;  -- 947 rows returned

-- 
SELECT users.id, users.name, sms_out_pools.operator_type, DATE(sms_out_pools.created_at) AS sent_date, COUNT(*) AS no_of_msg_sent
FROM sms_out_pools
INNER JOIN users ON sms_out_pools.user_id = users.id
WHERE sms_out_pools.operator_type = 'smartcell' AND sms_out_pools.status = 'sent'
GROUP BY users.id, users.name, sms_out_pools.operator_type, sent_date
UNION ALL
SELECT users.id, users.name, sms_out_pools.operator_type, DATE(sms_out_pools.created_at) AS sent_date, COUNT(*) AS no_of_msg_sent
FROM sms_out_pools
INNER JOIN users ON sms_out_pools.user_id = users.id
WHERE sms_out_pools.operator_type = 'ncell'
GROUP BY users.id, users.name, sms_out_pools.operator_type, sent_date
UNION ALL
SELECT users.id, users.name, sms_out_pools.operator_type, DATE(sms_out_pools.created_at) AS sent_date, COUNT(*) AS no_of_msg_sent
FROM sms_out_pools
INNER JOIN users ON sms_out_pools.user_id = users.id
WHERE sms_out_pools.operator_type = 'ntc'
GROUP BY users.id, users.name, sms_out_pools.operator_type, sent_date
ORDER BY id, operator_type, sent_date;

-- 

SELECT users.id, users.name, sms_out_pools.operator_type, COUNT(*) AS no_of_msg_sent
FROM sms_out_pools
INNER JOIN users ON sms_out_pools.user_id = users.id
WHERE sms_out_pools.operator_type IN ('smartcell', 'ncell', 'ntc')
GROUP BY users.id, users.name, sms_out_pools.operator_type
ORDER BY id, operator_type;

-- select id, 'a' col, a value from yourtable
-- union all
-- select id, 'b' col, b value from yourtable
-- union all
-- select id, 'c' col, c value from yourtable

select users.id, users.name, sms_out_pools.operator_type, count(*) as no_of_msg_sent 
from sms_out_pools
cross join users on sms_out_pools.user_id = users.id
where sms_out_pools.operator_type in ('smartcell', 'ncell', 'ntc')
group by users.id, users.name, sms_out_pools.operator_type
order by id, operator_type;