-- analyze[table] sms_out_pools [partition (pools_patrition)] [cascade]; -- syntax error

-- ANALYZE TABLE sms_out_pools PARTITION(pools_partition) CASCADE; -- syntax error

-- ANALYZE TABLE sms_out_pools CASCADE; -- syntax error

ANALYZE TABLE sms_out_pools; 
-- -> livedb.sms_out_pools, analyze, status, OK

OPTIMIZE TABLE sms_out_pools; 
-- -> livedb.sms_out_pools, optimize, note, Table does not support optimize, doing recreate + analyze instead livedb.sms_out_pools, optimize, status, OK

use livedb;


select u.id, u.name, count(*) as smartcell 
from sms_out_pools as s
inner join users as u
on s.user_id = u.id
where s.operator_type = 'smartcell'
group by u.id, u.name
order by id;

select u.id, u.name, count(*) as ncell
from sms_out_pools as s
inner join users as u
on s.user_id = u.id
where s.operator_type = 'ncell'
group by u.id, u.name
order by id;

select u.id, u.name, count(*) as smartcell 
from sms_out_pools as s
inner join users as u
on s.user_id = u.id
where s.operator_type = 'smartcell'
group by u.id, u.name
union all
select count(*) as ncell 
from sms_out_pools as s
inner join users as u
on s.user_id = u.id
where s.operator_type = 'ncell'
group by u.id, u.name
union all
select count(*) as ntc 
from sms_out_pools as s
inner join users as u
on s.user_id = u.id
where s.operator_type = 'ntc'
group by u.id, u.name
order by id;

SELECT u.id, u.name, COUNT(*) AS smartcell
FROM sms_out_pools AS s
INNER JOIN users AS u ON s.user_id = u.id
WHERE s.operator_type = 'smartcell'
GROUP BY u.id, u.name

UNION ALL

SELECT NULL, NULL, COUNT(*) AS ncell
FROM sms_out_pools AS s
INNER JOIN users AS u ON s.user_id = u.id
WHERE s.operator_type = 'ncell'
GROUP BY u.id, u.name

UNION ALL

SELECT NULL, NULL, COUNT(*) AS ntc FROM sms_out_pools AS s
INNER JOIN users AS u ON s.user_id = u.id
WHERE s.operator_type = 'ntc'
GROUP BY u.id, u.name
ORDER BY id;

-- another 

SELECT u.id, u.name, COUNT(*) AS smartcell
FROM sms_out_pools AS s
INNER JOIN users AS u ON s.user_id = u.id
WHERE s.operator_type = 'smartcell'
GROUP BY u.id, u.name

UNION ALL

SELECT u.id, u.name, COUNT(*) AS ncell
FROM sms_out_pools AS s
INNER JOIN users AS u ON s.user_id = u.id
WHERE s.operator_type = 'ncell'
GROUP BY u.id, u.name

UNION ALL

SELECT u.id, u.name, COUNT(*) AS ntc
FROM sms_out_pools AS s
INNER JOIN users AS u ON s.user_id = u.id
WHERE s.operator_type = 'ntc'
GROUP BY u.id, u.name

ORDER BY id;

-- another

SELECT u.id, u.name, COUNT(*) AS smartcell
FROM sms_out_pools AS s
INNER JOIN users AS u ON s.user_id = u.id
WHERE s.operator_type = 'smartcell'
GROUP BY u.id, u.name

UNION ALL

SELECT u.id, u.name, NULL AS ncell
FROM users AS u
WHERE u.id NOT IN (
  SELECT DISTINCT s.user_id
  FROM sms_out_pools AS s
  WHERE s.operator_type = 'ncell'
)

UNION ALL

SELECT u.id, u.name, NULL AS ntc
FROM users AS u
WHERE u.id NOT IN (
  SELECT DISTINCT s.user_id
  FROM sms_out_pools AS s
  WHERE s.operator_type = 'ntc'
)

ORDER BY id;

-- another

select u.id, u.name, count(operator_type) as smartcell, count(operator_type) as ncell, count(operator_type) as ntc
from sms_out_pools as s
inner join users as u
on s.user_id = u.id
where s.operator_type = 'smartcell' and s.operator_type = 'ncell' and s.operator_type = 'ntc'
group by u.id, u.name
order by id; -- although the syntax is correct here there is logical error

-- another 
SELECT u.id, u.name, 
       COUNT(CASE WHEN s.operator_type = 'smartcell' THEN 1 END) AS smartcell,
       COUNT(CASE WHEN s.operator_type = 'ncell' THEN 1 END) AS ncell,
       COUNT(CASE WHEN s.operator_type = 'ntc' THEN 1 END) AS ntc
FROM sms_out_pools AS s
INNER JOIN users AS u 
ON s.user_id = u.id
WHERE s.operator_type IN ('smartcell', 'ncell', 'ntc')
GROUP BY u.id, u.name
ORDER BY u.id;

-- the above generated the required report --

-- using view for the above query --
create or replace view sms_sent_Details 
as
	SELECT u.id, u.name, 
       COUNT(CASE WHEN s.operator_type = 'smartcell' THEN 1 END) AS smartcell,
       COUNT(CASE WHEN s.operator_type = 'ncell' THEN 1 END) AS ncell,
       COUNT(CASE WHEN s.operator_type = 'ntc' THEN 1 END) AS ntc
FROM sms_out_pools AS s
INNER JOIN users AS u ON s.user_id = u.id
WHERE s.operator_type IN ('smartcell', 'ncell', 'ntc')
GROUP BY u.id, u.name
ORDER BY u.id;

show create view sms_sent_details;

-- show view sms_sent_details; -> this is the syntax error

SELECT * FROM sms_sent_details; -- 440 rows returned