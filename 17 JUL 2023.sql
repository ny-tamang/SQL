use classicmodels;

drop table aliens;
-- Error Code: 1051. Unknown table 'classicmodels.aliens'

drop table if exists aliens;
-- 0 row(s) affected, 1 warning(s): 1051 Unknown table 'classicmodels.aliens'

show warnings;
-- 'Note', '1051', 'Unknown table \'classicmodels.aliens\''

create table test1(
    id int auto_increment,
    primary key (id)
);

create table if not exists test2 like test1;

create table if not exists test3 like test1;


-- set table schema and pattern matching for the tables

set @schema = 'classicmodels';

set @pattern = 'test%'; -- pattern to match the table

-- dynamic drop table
select concat('drop table ', group_concat(concat(@schema,'.',table_name)),';')
into @droplike
from information_schema.TABLES
where @schema = database()
    and table_name like @pattern;

-- display the dynamic sql statement
select @droplike;


-- execute the dynamic sql using the prepared statement
prepare stmt from @droplike;
execute stmt;
deallocate prepare stmt;

