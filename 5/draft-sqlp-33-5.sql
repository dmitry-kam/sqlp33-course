select *
from pg_catalog.pg_available_extensions
where installed_version is not null

create extension postgre_fdw

local	рабочий				cloud самостоятельная БД
S							SIUD
родительской				дочерняя
SIUD						S

create server out_server
foreign data wrapper postgres_fdw
options (host '51.250.106.132', port '19001', dbname 'workplace')

create user mapping for postgres
server out_server
options (user 'netology', password 'NetoSQL2019')

create foreign table some_in_1 (
	id serial,
	val text)
server out_server
options (schema_name 'p_fdw', table_name 'some_out')

select *
from some_in_3

insert into some_in_1 (val)
values ('aaa')

create foreign table some_in_2 (
	id serial,
	val text,
	created_at timestamp)
server out_server
options (schema_name 'p_fdw', table_name 'some_out')

insert into some_in_2 (val)
values ('bbb')

create foreign table some_in_3 (
	id serial,
	val text,
	created_at timestamp default now())
server out_server
options (schema_name 'p_fdw', table_name 'some_out')

insert into some_in_3 (val)
values ('ccc')

create schema some_payments

create server out_server_2
foreign data wrapper postgres_fdw
options (host '51.250.106.132', port '19001', dbname 'postgres')

create user mapping for postgres
server out_server_2
options (user 'netology', password 'NetoSQL2019')

import foreign schema public --limit to (table1, table2 ....)
from server out_server_2 into some_payments

select * --32 098
from payment p
union all
select *
from some_payments.payment

#####################################################################################

select *
from pg_catalog.pg_available_extensions
where installed_version is not null

create extension file_fdw

select * from customer 

create server some_csv_server
foreign data wrapper file_fdw

create foreign table csv_customer (
	customer_id int,
	store_id int2,
	first_name varchar(60),
	last_name varchar(60),
	email varchar(75),
	address_id int2,
	activebool bool,
	create_date date,
	last_update timestamp,
	active int4)
server some_csv_server
options (filename 'c:\1\some_csv.csv', format 'csv', delimiter ';', header 'true')

select * from csv_customer

###################################################################################################

select *
from pg_catalog.pg_available_extensions
where installed_version is not null

create extension tablefunc

select departure_airport, aircraft_code, count(*)
from flights
group by departure_airport, aircraft_code

select distinct aircraft_code
from flights
order by 1

аэропорт "319" "321" "733" "763" "773" "CN1" "CR2" "SU9" "Итого"
aaq					  70							61	  131
aba
Итого				  70									X

select *
from crosstab($$
	select coalesce(departure_airport, 'Итого')::text, coalesce(aircraft_code, 'Итого')::text, count
	from (
		select departure_airport, aircraft_code, count(*)
		from flights
		group by cube (departure_airport, aircraft_code)
		order by departure_airport, aircraft_code) t
$$) as ctb ("Аэропорт" text, "319" bigint,  "321" bigint, "733" bigint, "763" bigint, "773" bigint, "CN1" bigint, "CR2" bigint, "SU9" bigint, "Итого" bigint)

select "Аэропорт", coalesce("319", 0),  "321", "733", "763", "773", "CN1", "CR2", "SU9", "Итого"
from crosstab($$
	select coalesce(departure_airport, 'Итого')::text, coalesce(aircraft_code, 'Итого')::text, count
	from (
		select departure_airport, aircraft_code, count(*)
		from flights
		group by cube (departure_airport, aircraft_code)
		order by departure_airport, aircraft_code) t$$,
		$$
		select *
		from (
			select distinct aircraft_code
			from flights
			order by 1) t
		union all 
		select 'Итого'
		$$
		) as ctb ("Аэропорт" text, "319" bigint,  "321" bigint, "733" bigint, "763" bigint, "773" bigint, "CN1" bigint, "CR2" bigint, "SU9" bigint, "Итого" bigint)

select x::text
from generate_series(1, 25, 1) x
order by 1

select x::text
from (
	select (x::text)::int
	from generate_series(1, 25, 1) x
	order by 1)
	
create type air_code as (
	"Аэропорт" text, 
	"319" bigint,  
	"321" bigint, 
	"733" bigint, 
	"763" bigint, 
	"773" bigint, 
	"CN1" bigint, 
	"CR2" bigint, 
	"SU9" bigint, 
	"Итого" bigint)
	
create function air_code_count (text)
returns setof air_code
as '$libdir\tablefunc', 'crosstab' language C stable strict

select *
from air_code_count($$
	select coalesce(departure_airport, 'Итого')::text, coalesce(aircraft_code, 'Итого')::text, count
	from (
		select departure_airport, aircraft_code, count(*)
		from flights
		group by cube (departure_airport, aircraft_code)
		order by departure_airport, aircraft_code) t$$) 
		
create function air_code_count (text, text)
returns setof air_code
as '$libdir\tablefunc', 'crosstab_hash' language C stable strict

select "Аэропорт", coalesce("319", 0),  "321", "733", "763", "773", "CN1", "CR2", "SU9", "Итого"
from air_code_count($$
	select coalesce(departure_airport, 'Итого')::text, coalesce(aircraft_code, 'Итого')::text, count
	from (
		select departure_airport, aircraft_code, count(*)
		from flights
		group by cube (departure_airport, aircraft_code)
		order by departure_airport, aircraft_code) t$$,
		$$
		select *
		from (
			select distinct aircraft_code
			from flights
			order by 1) t
		union all 
		select 'Итого'
		$$)
		
explain analyze --85.13 / 0.13
with recursive r as (
	select *, 1 as level
	from "structure" 
	where unit_id = 114
	union 
	select s.*, level + 1 as level
	from r 
	join "structure" s on r.parent_id = s.unit_id)
select *
from r

explain analyze --21.71 / 0.27
select s.*, cb.level
from bookings.connectby('structure', 'parent_id', 'unit_id', '114', 0, '~') as cb (parent_id int, unit_id int, level int, branch text) 
join structure s on s.unit_id = cb.unit_id

#########################################################################################

select *
from pg_catalog.pg_available_extensions
where installed_version is not null

create extension pg_stat_statements

drop extension pg_stat_statements

select * 
from pg_stat_statements

SQL Error [55000]: ОШИБКА: pg_stat_statements must be loaded via shared_preload_libraries

1000  15	0,005

3000  20	0,01

5000  50   1

create table a (
	id int,
	val text)
	
do $$
begin
	for i in 1..1000
	loop
		insert into a 
		values (i, 'xxxxx');
		commit;
	end loop;	
end;
$$ language plpgsql

12 801.9338				64.1646	73.3431	66.82781666666666	2.653267540170465

23 2450.1894999999995	64.1646	82.1366	70.00541428571427	4.838689510786565

drop table a

do $$
begin
	for i in 1..1000
	loop
		insert into a 
		values (i, 'xxxxx');
		commit;
	end loop;	
end;
$$ language plpgsql

select count(*) from a

########################################################################################################

explain analyze --3998.34 / 50
SELECT DISTINCT a1.city, a2.city, 
	(acos(sin(radians(a1.latitude))*sin(radians(a2.latitude)) +cos(radians(a1.latitude))*
cos(radians(a2.latitude))*cos(radians(a1.longitude - a2.longitude)))*6371)::integer
FROM flights f
JOIN airports a1 ON f.departure_airport = a1.airport_code
JOIN airports a2 ON f.arrival_airport = a2.airport_code
order by 1, 2;

explain analyze --840367 / 180
SELECT DISTINCT a1.city, a2.city, 
	(ST_DISTANCESPHERE(ST_MAKEPOINT(a1.longitude, a1.latitude), ST_MAKEPOINT(a2.longitude, a2.latitude))/1000)::int
FROM flights f
JOIN airports a1 ON f.departure_airport = a1.airport_code
JOIN airports a2 ON f.arrival_airport = a2.airport_code
order by 1, 2

SELECT ST_AREA(
	ST_TRANSFORM(
		ST_GEOMFROMTEXT('POLYGON((37.547897 55.718520, 37.549551 55.717563, 37.550541 55.718105, 37.548887 55.719085, 37.547897 55.718520))',4326)
	,31467)
) AS sqm; -- 14140.807991123049

1			2
						3
						
						
				4
				
	5
	
POLYGON(1,2,3,4,5,1)	

SELECT ST_AREA(
	ST_TRANSFORM(
		ST_GEOMFROMTEXT('POLYGON((37.547897 55.718520, 37.549551 55.717563, 37.550541 55.718105, 37.548887 55.719085, 37.547897 55.718520))',4326)
	,32637)
) AS sqm; -- 13106.773573366776

select *
from planet_osm_point pop

CREATE TABLE cities(
	id serial PRIMARY KEY, 
	city_name varchar(40));
	
SELECT ADDGEOMETRYCOLUMN('cities', 'polygon', 4326, 'POLYGON', 2);

CREATE INDEX cities_idx ON cities USING gist(polygon);

INSERT INTO cities(city_name, polygon)
SELECT name, ST_TRANSFORM(way, 4326)
FROM planet_osm_polygon WHERE place = 'city';

select *
from cities


CREATE TABLE bar (
	id serial PRIMARY KEY,
	bar_name varchar(100));
	
SELECT ADDGEOMETRYCOLUMN('bar', 'point', 4326, 'point', 2);

CREATE INDEX bar_idx ON bar USING gist(point);

INSERT INTO bar(bar_name, point)
SELECT name, ST_TRANSFORM(way, 4326)
FROM planet_osm_point
WHERE amenity = 'bar' AND name IS NOT NULL;

SELECT bar_name, ST_ASTEXT(point) AS gps, point,
  ST_DISTANCESPHERE(point, ST_GEOMFROMEWKT('SRID=4326;POINT(37.581015 55.740604)')) AS dist
FROM bar
ORDER BY point <-> ST_GEOMFROMEWKT('SRID=4326;POINT(37.581015 55.740604)')
LIMIT 5;

15
25
37
85
98
102
150

180 150 250 102 98 85

250
500

год		1	2	3	4	5 .. 12	 итого
2018
2019
2020
Итого

uuid-ossp

