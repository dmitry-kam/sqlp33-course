--- 1 task

SELECT * FROM pg_extension;

select *
from pg_catalog.pg_available_extensions
where installed_version is not null;

CREATE EXTENSION POSTGRES_FDW;

create server cloudNetology
foreign data wrapper postgres_fdw
options (host '51.250.106.132', port '19001', dbname 'workplace');

create user mapping for postgres
server cloudNetology
options (user 'netology', password 'NetoSQL2019');


create foreign table external_employee (
	emp_id int4 NOT NULL,
	emp_type_id int4 NOT NULL,
	person_id int4 NOT NULL,
	pos_id int4 NOT NULL,
	rate numeric(12, 2) NOT NULL,
	hire_date date NOT null
)
server cloudNetology
options (schema_name 'hr', table_name 'employee');

select * from external_employee;

create foreign table external_positions (
	pos_id int4 NOT NULL,
	pos_title varchar(250) NOT NULL,
	pos_category varchar(100) NULL,
	unit_id int4 NULL,
	grade int4 NULL,
	address_id int4 NULL,
	manager_pos_id int4 NULL
)
server cloudNetology
options (schema_name 'hr', table_name 'position');

select * from external_positions;


create foreign table external_persons (
	person_id int4 NOT NULL,
	first_name varchar(250) NOT NULL,
	middle_name varchar(250) NULL,
	last_name varchar(250) NOT NULL
)
server cloudNetology
options (schema_name 'hr', table_name 'person');

select * from external_persons;

select e.emp_id as "id", pos.pos_title as "position",
concat(p.last_name, ' ', p.first_name, ' ', p.middle_name) as fio
from external_employee e left join external_persons p on e.person_id = p.person_id
left join external_positions pos on e.pos_id = pos.pos_id
order by fio ASC;



--- 2 task

create extension tablefunc;

create foreign table external_projects (
	project_id int4 NOT NULL,
	"name" varchar(150) NOT NULL,
	employees_id _int4 NULL,
	amount numeric(12, 2) NOT NULL,
	assigned_id int4 NULL,
	created_at timestamp NULL
)
server cloudNetology
options (schema_name 'hr', table_name 'projects');

select * from external_projects;

select p.year, m.MonthName, p.sum
from (
	select to_char(created_at, 'YYYY') as year,
	to_char(created_at, 'MM') as MonthNum,
	sum(amount)
	from external_projects
	group by MonthNum, year
	order by year, MonthNum
) p join
(select LPAD(monthes::text,2,'0') as MonthNum,
TO_CHAR(TO_DATE(LPAD(monthes::text,2,'0'), 'MM'), 'Month') AS MonthName
from generate_series(1, 12, 1) monthes
order by monthes) m on m.MonthNum = p.MonthNum;

-- crosstab(text source_sql, text category_sql)	setof record
-- Выдаёт «повёрнутую таблицу» со столбцами значений, заданными вторым запросом


select
COALESCE("Year", '0') as "Year",
COALESCE("January", '0') as "January",
COALESCE("February", '0') as "February",
COALESCE("March", '0') as "March",
COALESCE("April", '0') as "April",
COALESCE("May", '0') as "May",
COALESCE("June", '0') as "June",
COALESCE("July", '0') as "July",
COALESCE("August", '0') as "August",
COALESCE("September", '0') as "September",
COALESCE("October", '0') as "October",
COALESCE("November", '0') as "November",
COALESCE("December", '0') as "December",
COALESCE("Total", '0') as "Total"
from crosstab($$
	select coalesce(t.year, 'Total')::text, coalesce(t.mname, 'Total')::text, t.amount::int8
	from (
			select
			--pg_typeof(p.year::text), pg_typeof(m.MonthName), pg_typeof(p.sum)
			p.year::text as "year", m.MonthName as mname, p.sum::int8 as amount
			from (
				select to_char(created_at, 'YYYY') as year,
				to_char(created_at, 'MM') as MonthNum,
				sum(amount)
				from external_projects
				group by cube (MonthNum, year)
				order by year, MonthNum
			) p left join
			(select LPAD(monthes::text,2,'0') as MonthNum,
			TO_CHAR(TO_DATE(LPAD(monthes::text,2,'0'), 'MM'), 'Month') AS MonthName
			from generate_series(1, 12, 1) monthes
			order by monthes) m on m.MonthNum = p.MonthNum
		) t$$,
		$$
		select *
		from (select
			TO_CHAR(TO_DATE(LPAD(monthes::text,2,'0'), 'MM'), 'Month') AS MonthName
			from generate_series(1, 12, 1) monthes
			order by monthes) t
		union all
		select 'Total'
$$) as ctb ("Year" text,
"January" int8, "February" int8, "March" int8,
"April" int8, "May" int8, "June" int8,
"July" int8, "August" int8, "September" int8,
"October" int8, "November" int8, "December" int8,
"Total" int8);


--- 3 task

create extension pg_stat_statements;

-- postgresql.conf ::: shared_preload_libraries = 'pg_stat_statements'

select query, calls, mean_exec_time from pg_stat_statements;



