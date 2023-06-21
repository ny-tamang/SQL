-- media table --

SELECT * FROM livedb.media;
show columns from livedb.media;
select distinct extension from livedb.media;
select distinct aggregate_type from livedb.media;
select distinct disk from livedb.media;

select title from livedb.media where title is not null;

select count(*) as row_count 
from (select title from livedb.media where title is not null) as subquery;

-- mediables table --

SELECT * FROM livedb.mediables;
use livedb;

select * from media inner join mediables on media.id = mediable.media_id;

SELECT * FROM media INNER JOIN mediables ON media.id = mediables.media_id  limit 0, 1000 ;

SELECT * FROM media INNER JOIN mediables ON media.id = mediables.media_id
GROUP BY aggregate_type having aggregate_type = 'spreadsheet'
LIMIT 0, 1000;


SELECT * FROM media INNER JOIN mediables ON media.id = mediables.media_id where aggregate_type = 'document' order by id 
LIMIT 0, 1000;

SELECT COUNT(*) AS row_count
FROM (
    SELECT * FROM media INNER JOIN mediables ON media.id = mediables.media_id
    WHERE aggregate_type = 'document' ORDER BY id LIMIT 0, 1000
) AS subquery;


-- log table --
SELECT * FROM livedb.logs;

SELECT table_name FROM livedb.logs;

show columns from livedb.logs;

select json_pretty(data) as log_details from livedb.logs; -- data stored as longtext data type.


-- failed_jobs table 

SELECT * FROM livedb.failed_jobs;

select json_pretty(payload) as pay_details from livedb.failed_jobs;

SELECT payload -> '$.job' AS extracted_value
FROM livedb.failed_jobs;

SELECT payload ->> '$.data' AS extracted_value -- equivalent to json_extract(), json_unquote()
FROM livedb.failed_jobs;

SELECT JSON_KEYS(payload) AS properties
FROM livedb.failed_jobs; 

SELECT distinct JSON_KEYS(payload) AS properties
FROM livedb.failed_jobs; 

-- '[\"job\", \"data\", \"uuid\", \"backoff\", \"timeout\", \"maxTries\", \"retryUntil\", \"displayName\", \"failOnTimeout\", \"maxExceptions\", \"telescope_uuid\"]'



-- notification table --

SELECT * FROM livedb.notifications;

show columns from livedb.notifications;
select distinct json_keys(data) as properties from livedb.notifications;
select JSON_KEYS(data) as properties from livedb.notifications;

select json_pretty(data) from livedb.notifications;

select distinct notifiable_type from livedb.notifications;

select json_pretty(type) from livedb.notifications; 

-- error occurs as type is not a json data type.  In the schema information, the json data type is often showed as text or middletext or longtext.


-- oauth_access_tokens
SELECT * FROM livedb.oauth_access_tokens;

select distinct scopes from livedb.oauth_access_tokens; -- [] is the only output


-- sender_setup table

SELECT * FROM livedb.sender_setups;

select distinct sender_name from livedb.sender_setups;

select count(*) from (
select distinct sender_name from livedb.sender_setups)
as subquery;
-- total count = 139

select distinct sender_type from livedb.sender_setups; -- ALERT, SHORTCODE

select distinct operator_type from livedb.sender_setups;

select JSON_PRETTY(extra) as details from livedb.sender_setups where extra is not null;

select distinct JSON_PRETTY(extra) as details from livedb.sender_setups where extra is not null;

select json_keys(extra) from livedb.sender_setups;

select json_keys(extra) from livedb.sender_setups where extra is not null;

select distinct json_keys(extra) from livedb.sender_setups where extra is not null; 
-- '[\"name\", \"email\", \"mobile\"]'

-- group table

SELECT * FROM livedb.groups;
select count(*) from livedb.groups; -- 519

select count(*) from (
select distinct name from livedb.groups)
as subquery; -- 457

-- sms batches

SELECT * FROM livedb.sms_batches;

select count(*) from livedb.sms_batches; -- 9997

select distinct media_id from livedb.sms_batches where media_id is not null;

select count(*) from 
(select distinct media_id from livedb.sms_batches where media_id is not null) as subquery; -- 3496

select distinct group_ids from livedb.sms_batches where group_ids is not null;

select count(*) from (select distinct group_ids from livedb.sms_batches where group_ids is not null) as subquery1; -- 39, 
-- here if the alias is as above then error accours

select distinct scheduled_for from livedb.sms_batches where scheduled_for is not null;

select distinct name from livedb.sms_batches;

-- sms inbound table

SELECT * FROM livedb.sms_inbound;

select count(extra) from livedb.sms_inbound where extra is not null; -- 32310

select count(extra) from livedb.sms_inbound where extra is null; -- 0

select distinct operator_type FROM livedb.sms_inbound; -- null, otehr, ncell, ntc

select distinct json_pretty(extra) from livedb.sms_inbound;

select count(*) from(
select distinct json_pretty(extra) from livedb.sms_inbound)
as subquery; -- 30836

select distinct json_keys(extra) from livedb.sms_inbound;

-- json_keys(extra)

-- '[\"id\", \"body\", \"tags\", \"source\", \"status\", \"message\", \"esmClass\", \"sequence\", \"dataCoding\", \"protocolId\", \"destination\", \"priorityFlag\", \"service_type\", \"smDefaultMsgId\", \"validityPeriod\", \"registeredDelivery\", \"replaceIfPresentFlag\", \"scheduleDeliveryTime\"]'
-- NULL
-- '[\"response_data\", \"coupon_redeemed\"]'
-- '[\"id\", \"body\", \"tags\", \"source\", \"status\", \"message\", \"esmClass\", \"sequence\", \"dataCoding\", \"protocolId\", \"destination\", \"priorityFlag\", \"service_type\", \"response_data\", \"smDefaultMsgId\", \"validityPeriod\", \"coupon_redeemed\", \"registeredDelivery\", \"replaceIfPresentFlag\", \"scheduleDeliveryTime\"]'
-- '[\"message\", \"mobileNumber\", \"response_data\", \"coupon_redeemed\"]'
-- '[\"test\", \"test2\", \"response_data\", \"coupon_redeemed\"]'
-- '[\"message\", \"mobileNumber\"]'
-- '[\"test\", \"test2\"]'
-- '[\"message\"]'
-- '[\"errors\", \"message\"]'
-- '[\"error\", \"exception\"]'

select distinct message from livedb.sms_inbound;

select distinct no_of_matches from livedb.sms_inbound;

-- sms_out_pools tables

SELECT * FROM livedb.sms_out_pools;

SELECT count(*) FROM livedb.sms_out_pools; -- 4275732

select distinct via from livedb.sms_out_pools;

-- sms queues

SELECT * FROM livedb.sms_queues; -- foreign key user id





