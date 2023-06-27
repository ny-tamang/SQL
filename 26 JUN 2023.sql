use livedb;

SELECT users.id, users.name, sms_out_pools.operator_type, DATE(sms_out_pools.created_at) AS sent_date, COUNT(*) AS no_of_msg_sent
FROM sms_out_pools
INNER JOIN users ON sms_out_pools.user_id = users.id
WHERE sms_out_pools.operator_type = 'smartcell' AND sms_out_pools.status = 'sent'
GROUP BY users.id, users.name, sms_out_pools.operator_type, sent_date;

SELECT u.id, u.name, DATE(s.created_at) AS sent_date, 
       COUNT(CASE WHEN s.operator_type = 'smartcell' THEN 1 END) AS smartcell,
       COUNT(CASE WHEN s.operator_type = 'ncell' THEN 1 END) AS ncell,
       COUNT(CASE WHEN s.operator_type = 'ntc' THEN 1 END) AS ntc
FROM sms_out_pools AS s
INNER JOIN users AS u ON s.user_id = u.id
WHERE s.operator_type IN ('smartcell', 'ncell', 'ntc') and s.created_at between 2022-07-17 and 2023-06-25
GROUP BY u.id, u.name
ORDER BY u.id; -- Error Code: 1055. Expression #3 of SELECT list is not in GROUP BY clause and contains nonaggregated column 'livedb.s.created_at' which is not functionally dependent on columns in GROUP BY clause; this is incompatible with sql_mode=only_full_group_by


SELECT u.id, u.name, DATE(s.created_at) AS sent_date, 
       COUNT(CASE WHEN s.operator_type = 'smartcell' THEN 1 END) AS smartcell,
       COUNT(CASE WHEN s.operator_type = 'ncell' THEN 1 END) AS ncell,
       COUNT(CASE WHEN s.operator_type = 'ntc' THEN 1 END) AS ntc
FROM sms_out_pools AS s
INNER JOIN users AS u ON s.user_id = u.id
WHERE s.operator_type IN ('smartcell', 'ncell', 'ntc') AND s.created_at BETWEEN '2022-07-17' AND '2023-06-25'
GROUP BY u.id, u.name, DATE(s.created_at)
ORDER BY u.id; -- 9969 rows returned

-- here, the result came for each day rather than total within the timeframe.

-- external sorting in sql is merge sort


-- project le duplicate aaudaina works as select distinct

SELECT u.id, u.name, DATE(s.created_at) AS sent_date, 
       COUNT(CASE WHEN s.operator_type = 'smartcell' THEN 1 END) AS smartcell,
       COUNT(CASE WHEN s.operator_type = 'ncell' THEN 1 END) AS ncell,
       COUNT(CASE WHEN s.operator_type = 'ntc' THEN 1 END) AS ntc
FROM sms_out_pools AS s
INNER JOIN users AS u ON s.user_id = u.id
WHERE s.operator_type IN ('smartcell', 'ncell', 'ntc') AND s.created_at >= '2022-07-17' AND s.created_at <='2023-06-25'
GROUP BY u.id, u.name, DATE(s.created_at)
ORDER BY u.id; 

-- produces same result as above


SELECT u.id, u.name, 
       COUNT(CASE WHEN s.operator_type = 'smartcell' THEN 1 END) AS smartcell_078_079,
       COUNT(CASE WHEN s.operator_type = 'ncell' THEN 1 END) AS ncell_078_079,
       COUNT(CASE WHEN s.operator_type = 'ntc' THEN 1 END) AS ntc_078_079
FROM sms_out_pools AS s
INNER JOIN users AS u ON s.user_id = u.id
WHERE s.operator_type IN ('smartcell', 'ncell', 'ntc') 
  AND s.created_at >= '2022-07-17' 
  AND s.created_at <= '2023-06-25'
GROUP BY u.id, u.name
ORDER BY u.id;

SELECT u.id, u.name,
       FIRST_VALUE(s.operator_type) OVER (PARTITION BY u.id, u.name ORDER BY s.created_at) AS first_operator_type,
       COUNT(CASE WHEN s.operator_type = 'smartcell' THEN 1 END) AS smartcell,
       COUNT(CASE WHEN s.operator_type = 'ncell' THEN 1 END) AS ncell,
       COUNT(CASE WHEN s.operator_type = 'ntc' THEN 1 END) AS ntc
FROM sms_out_pools AS s
INNER JOIN users AS u ON s.user_id = u.id
WHERE s.operator_type IN ('smartcell', 'ncell', 'ntc') 
  AND s.created_at >= '2022-07-17' 
  AND s.created_at < '2023-06-26'
GROUP BY u.id, u.name
ORDER BY u.id;  -- Error Code: 1055. Expression #3 of SELECT list is not in GROUP BY clause and contains nonaggregated column 'livedb.s.operator_type' which is not functionally dependent on columns in GROUP BY clause; this is incompatible with sql_mode=only_full_group_by

-- another
SELECT u.name, 
       MAX(s.operator_type) AS operator_type,
       COUNT(CASE WHEN s.operator_type = 'smartcell' THEN 1 END) AS smartcell,
       COUNT(CASE WHEN s.operator_type = 'ncell' THEN 1 END) AS ncell,
       COUNT(CASE WHEN s.operator_type = 'ntc' THEN 1 END) AS ntc
FROM sms_out_pools AS s
INNER JOIN users AS u ON s.user_id = u.id
WHERE s.operator_type IN ('smartcell', 'ncell', 'ntc') 
GROUP BY u.name
ORDER BY COUNT(CASE WHEN s.operator_type = 'smartcell' THEN 1 END) AS smartcell,
       COUNT(CASE WHEN s.operator_type = 'ncell' THEN 1 END) AS ncell,
       COUNT(CASE WHEN s.operator_type = 'ntc' THEN 1 END) AS ntc;
-- Error Code: 1064. You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'AS smartcell,        COUNT(CASE WHEN s.operator_type = 'ncell' THEN 1 END) AS nc' at line 10

-- another

SELECT u.name, 
       MAX(s.operator_type) AS operator_type,
       COUNT(CASE WHEN s.operator_type = 'smartcell' THEN 1 END) AS smartcell,
       COUNT(CASE WHEN s.operator_type = 'ncell' THEN 1 END) AS ncell,
       COUNT(CASE WHEN s.operator_type = 'ntc' THEN 1 END) AS ntc
FROM sms_out_pools AS s
INNER JOIN users AS u ON s.user_id = u.id
WHERE s.operator_type IN ('smartcell', 'ncell', 'ntc') 
GROUP BY u.name
ORDER BY smartcell, ncell, ntc desc;

-- did not provide the required output

SELECT u.name, 
       COUNT(CASE WHEN s.operator_type = 'smartcell' THEN 1 END) AS smartcell,
       COUNT(CASE WHEN s.operator_type = 'ncell' THEN 1 END) AS ncell,
       COUNT(CASE WHEN s.operator_type = 'ntc' THEN 1 END) AS ntc
FROM sms_out_pools AS s
INNER JOIN users AS u ON s.user_id = u.id
WHERE s.operator_type IN ('smartcell', 'ncell', 'ntc') 
GROUP BY u.name
ORDER BY smartcell DESC, ncell DESC, ntc DESC;

-- this generated the required report

SELECT u.name, 
       COUNT(CASE WHEN s.operator_type = 'smartcell' THEN 1 END) AS smartcell,
       COUNT(CASE WHEN s.operator_type = 'ncell' THEN 1 END) AS ncell,
       COUNT(CASE WHEN s.operator_type = 'ntc' THEN 1 END) AS ntc,
       SUM(CASE WHEN s.operator_type IN ('smartcell', 'ncell', 'ntc') THEN 1 ELSE 0 END) AS total
FROM sms_out_pools AS s
INNER JOIN users AS u ON s.user_id = u.id
WHERE s.operator_type IN ('smartcell', 'ncell', 'ntc') 
GROUP BY u.name
ORDER BY total DESC, smartcell DESC, ncell DESC, ntc DESC;

-- this is the updated query that includes the total table which has total of messsage sent by all three operator type)

SELECT u.name,
       COUNT(CASE WHEN s.operator_type = 'smartcell' THEN 1 END) AS smartcell,
       COUNT(CASE WHEN s.operator_type = 'ncell' THEN 1 END) AS ncell,
       COUNT(CASE WHEN s.operator_type = 'ntc' THEN 1 END) AS ntc,
       SUM(IF(s.operator_type IN ('smartcell', 'ncell', 'ntc'), 1, 0)) AS total -- replaced the case with if
FROM sms_out_pools AS s
INNER JOIN users AS u ON s.user_id = u.id
WHERE s.operator_type IN ('smartcell', 'ncell', 'ntc')
GROUP BY u.name
ORDER BY total DESC, smartcell DESC, ncell DESC, ntc DESC;

-- ----

select u.name, sum(s.status) from sms_out_pools as s
inner join users as u
on s.user_id = u.id
group by u.name, s.status
order by s.status desc;

-- tried to check whether the above query is giving the right output or not but this is a worng query.

-- statements for controlling the source seve

show binary logs;

show master status;

show replicas; -- a warning as the table that it provides as output is empty

show slave hosts; -- same as the show replicas, can differ from the different versions


