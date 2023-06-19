use livedb;
show tables;
select count(*) as table_count from information_schema.tables where table_schema = 'livedb';

show columns from activity_log;

show columns from contacts;

select count(*) from contacts;

select name from contacts;

select name from contacts where name like 'NE%';

select name from contacts where name like '_a%';

select * from enquiry_forms;
show columns from enquiry_forms;

select count(user_id) from livedb.balance_load_logs where extra is null;

SELECT * FROM livedb.sms_batches as s;
select total_cost from livedb.sms_batches;

SELECT s.*, MAX(s.total_cost) OVER (PARTITION BY s.name order by s.user_id) AS max_total_cost FROM sms_batches s;

select *,
first_value(total_cost)
over (PARTITION BY name order by total_cost DESC)
as most
from sms_batches;

select distinct name from sms_batches;

SELECT * FROM livedb.telescope_entrbalance_load_logsies;

select content from livedb.telescope_entries;

show columns from livedb.telescope_entries;

SELECT * FROM livedb.telescope_entries_tags;
show columns from livedb.telescope_entries_tags;

 
SELECT * FROM livedb.telescope_monitoring;

SELECT * FROM livedb.activity_log;

show columns from livedb.activity_log;

select properties from livedb.activity_log;

SELECT * FROM livedb.users;

select distinct user_type from livedb.users;

SELECT * FROM livedb.enquiry_forms;

select * from livedb.enquiry_forms where phone_number like '98________';

SELECT * FROM livedb.failed_jobs;

select distinct connection from livedb.failed_jobs;

SELECT * FROM livedb.groups;

SELECT distinct name FROM livedb.groups order by name;