SELECT * FROM pg_replication_slots

select pg_drop_replication_slot('sub_2');

select * from pg_catalog.pg_publication pp

drop publication pub_3

select pg_terminate_backend(20532) from pg_stat_replication;

create schema test_repl

select *
from pg_catalog.pg_stat_replication psr

create table aaa ()

create publication pub_1 for table a, b, c, d...

create publication pub_1 for all tables 

create publication pub_1 for table a where (id > 1000)

create publication pub_1 for all tables with (publish = 'insert, update')

create table a (
	id serial primary key,
	val text,
	ts timestamp default now())
	
create publication pub_1 for table a with (publish = 'insert, update')

insert into a (val)
values ('a')

select * from a

delete from a

insert into a (val)
values ('z')

create publication pub_2 for table payment where (payment_id > 1000)

create publication pub_3 for table payment 

create publication pub_4 for table rental 

select * from payment p

insert into rental 
values (100001,	'2005-05-24 22:53:30',	367,	136,	'2005-05-26 22:04:30',	2,	'2006-02-15 21:30:53')

select * from payment p

insert into payment 
values (100001,	1,	1,	76,	2.99,	'2005-05-25 11:30:37')


drop schema test_repl1

select * from pg_catalog.pg_subscription ps

drop subscription sub_1

SQL Error [25006]: ОШИБКА: в транзакции в режиме "только чтение" нельзя выполнить DROP schema

select * from customer c

create table a (
	id serial primary key,
	val text,
	ts timestamp default now())
	
insert into a (id, val)
values (4, 'x')

delete from a 
where id = 4
	
create subscription sub_t_1 
connection 'host=localhost port=5435 user=postgres password=123 dbname=postgres'
publication pub_1 

select * from a

delete from payment

select * from payment

create subscription sub_t_2 
connection 'host=localhost port=5435 user=postgres password=123 dbname=postgres'
publication pub_2 with (copy_data = true) 

select * from payment

create subscription sub_t_3 
connection 'host=localhost port=5435 user=postgres password=123 dbname=postgres'
publication pub_3 with (copy_data = true) 

select * from payment

delete from rental

create subscription sub_t_4 
connection 'host=localhost port=5435 user=postgres password=123 dbname=postgres'
publication pub_4 with (copy_data = false) 

select * from rental

select distinct date_trunc('month', payment_date) 
from payment p

CREATE TABLE payment_05_2005 
(CHECK (DATE_TRUNC('month', payment_date) = '01.05.2005')) INHERITS (payment);

CREATE TABLE payment_06_2005 
(CHECK (DATE_TRUNC('month', payment_date) = '01.06.2005')) INHERITS (payment);

CREATE TABLE payment_07_2005 
(CHECK (DATE_TRUNC('month', payment_date) = '01.07.2005')) INHERITS (payment);

CREATE TABLE payment_08_2005 
(CHECK (DATE_TRUNC('month', payment_date) = '01.08.2005')) INHERITS (payment);

CREATE INDEX payment_05_2005_date_idx ON payment_05_2005 (CAST(payment_date as date));

CREATE INDEX payment_06_2005_date_idx ON payment_06_2005 (CAST(payment_date as date));

CREATE INDEX payment_07_2005_date_idx ON payment_07_2005 (CAST(payment_date as date));

CREATE INDEX payment_08_2005_date_idx ON payment_08_2005 (CAST(payment_date as date));

CREATE RULE payment_insert_05_2005 AS ON INSERT TO payment 
WHERE (DATE_TRUNC('month', payment_date) = '01.05.2005')
DO INSTEAD INSERT INTO payment_05_2005 VALUES (new.*);

CREATE RULE payment_insert_06_2005 AS ON INSERT TO payment 
WHERE (DATE_TRUNC('month', payment_date) = '01.06.2005')
DO INSTEAD INSERT INTO payment_06_2005 VALUES (new.*)

CREATE RULE payment_insert_07_2005 AS ON INSERT TO payment 
WHERE (DATE_TRUNC('month', payment_date) = '01.07.2005')
DO INSTEAD INSERT INTO payment_07_2005 VALUES (new.*)

CREATE RULE payment_insert_08_2005 AS ON INSERT TO payment 
WHERE (DATE_TRUNC('month', payment_date) = '01.08.2005')
DO INSTEAD INSERT INTO payment_08_2005 VALUES (new.*)

WITH cte AS (  
	DELETE FROM ONLY payment      
	WHERE DATE_TRUNC('month', payment_date) = '01.05.2005' RETURNING *)
INSERT INTO payment_05_2005   
SELECT * FROM cte;

WITH cte AS (  
	DELETE FROM ONLY payment      
	WHERE DATE_TRUNC('month', payment_date) = '01.06.2005' RETURNING *)
INSERT INTO payment_06_2005   
SELECT * FROM cte;

WITH cte AS (  
	DELETE FROM ONLY payment      
	WHERE DATE_TRUNC('month', payment_date) = '01.07.2005' RETURNING *)
INSERT INTO payment_07_2005   
SELECT * FROM cte;

WITH cte AS (  
	DELETE FROM ONLY payment      
	WHERE DATE_TRUNC('month', payment_date) = '01.08.2005' RETURNING *)
INSERT INTO payment_08_2005   
SELECT * FROM cte;

select * from only payment p

select * from payment p

explain analyze
select *
from payment 
where payment_date::date = '01.08.2005'

--Append  (cost=0.14..112.09 rows=680 width=26) (actual time=0.173..0.402 rows=671 loops=1)
--Seq Scan on payment  (cost=0.00..359.74 rows=80 width=26) (actual time=0.030..1.5 rows=671 loops=1)

CREATE RULE payment_update_05_2005 AS ON UPDATE TO payment 
WHERE (DATE_TRUNC('month', old.payment_date) = '01.05.2005' AND DATE_TRUNC('month', new.payment_date) != '01.05.2005')
DO INSTEAD (INSERT INTO payment VALUES (new.*); DELETE FROM payment_05_2005 WHERE payment_id = new.payment_id);

CREATE RULE payment_update_06_2005 AS ON UPDATE TO payment 
WHERE (DATE_TRUNC('month', old.payment_date) = '01.06.2005' AND DATE_TRUNC('month', new.payment_date) != '01.06.2005')
DO INSTEAD (INSERT INTO payment VALUES (new.*); DELETE FROM payment_06_2005 WHERE payment_id = new.payment_id);

CREATE RULE payment_update_07_2005 AS ON UPDATE TO payment 
WHERE (DATE_TRUNC('month', old.payment_date) = '01.07.2005' AND DATE_TRUNC('month', new.payment_date) != '01.07.2005')
DO INSTEAD (INSERT INTO payment VALUES (new.*); DELETE FROM payment_07_2005 WHERE payment_id = new.payment_id);

CREATE RULE payment_update_08_2005 AS ON UPDATE TO payment 
WHERE (DATE_TRUNC('month', old.payment_date) = '01.08.2005' AND DATE_TRUNC('month', new.payment_date) != '01.08.2005')
DO INSTEAD (INSERT INTO payment VALUES (new.*); DELETE FROM payment_08_2005 WHERE payment_id = new.payment_id);

select * from payment_05_2005

update payment
set payment_date = '2005-05-25 11:30:37'
where payment_id = 1

select * from payment_07_2005

delete from payment
where payment_id = 1

create view 

select * from payment

CREATE OR REPLACE FUNCTION payment_insert_tg() RETURNS TRIGGER AS $$
BEGIN
	IF DATE_TRUNC('month', new.payment_date) = '01.05.2005' THEN    
		INSERT INTO payment_05_2005 VALUES (new.*);
	ELSIF DATE_TRUNC('month', new.payment_date) = '01.06.2005' THEN  
		INSERT INTO payment_06_2005 VALUES (new.*);
	ELSIF DATE_TRUNC('month', new.payment_date) = '01.07.2005' THEN  
		INSERT INTO payment_07_2005 VALUES (new.*);
	ELSIF DATE_TRUNC('month', new.payment_date) = '01.08.2005' THEN  
		INSERT INTO payment_08_2005 VALUES (new.*);
	ELSE RAISE EXCEPTION 'Отсутствует партиция';
	END IF;
	RETURN NULL;
END; $$ LANGUAGE plpgsql;

CREATE TRIGGER payment_insert_tg
BEFORE INSERT ON payment
FOR EACH ROW EXECUTE FUNCTION payment_insert_tg();

create temporary table temp_pay as (select * from payment p)

delete from payment

select * from payment p

insert into payment
select * from temp_pay

SQL Error [P0001]: ОШИБКА: Отсутствует партиция

create or replace function payment_insert_tg() returns trigger as $$
declare part_date date = date_trunc('month', new.payment_date)::date;
	part_name text = concat('payment_', to_char(part_date, 'MM_YYYY'));
begin
	if to_regclass(part_name) is null then
		execute format ('create table %I (check (date_trunc(''month'', payment_date) = %L)) inherits (payment);', part_name, part_date);
		execute format ('create index %1$s_date_idx on %1$I (cast(payment_date as date));', part_name);
		execute format ('create trigger %1$s_update_tg before update on %1$I for each row execute function payment_update_tg();', part_name);
	end if;
	execute format ('insert into %I values ($1.*)', part_name) using new;
	return null;
end; $$ language plpgsql;

date_trunc('month', new.payment_date)::date

select date_trunc('month', '2005-05-25 11:30:37'::timestamp)::date --2005-05-01

select concat('payment_', to_char(date_trunc('month', '2005-05-25 11:30:37'::timestamp)::date, 'MM_YYYY')) --payment_05_2005

select to_regclass('payment_02_2006')

quote_literal
quote_ident

%I - " "
%L - ' '
%s - как есть

format('...%1$I...%1$s ... %2$I.. %1$s   ', var1, var2)

create trigger payment_08_2005_update_tg before update on payment_08_2005 for each row execute function payment_update_tg();

create or replace function payment_update_tg() returns trigger as $$
declare part_date_new date = date_trunc('month', new.payment_date)::date;
	part_name_new text = concat('payment_', to_char(part_date_new, 'MM_YYYY'));
	part_date_old date = date_trunc('month', old.payment_date)::date;
	part_name_old text = concat('payment_', to_char(part_date_old, 'MM_YYYY'));
begin
	if part_date_new != part_date_old then 
		execute format ('insert into %I values ($1.*)', part_name_new) using new;
		execute format ('delete from %I where payment_id = $1', part_name_old) using old.payment_id;
		return null;
	else 
		return new;
	end if;
end; $$ language plpgsql;

select * from payment_05_2005

update payment
set payment_date = '2005-05-25 11:30:37'
where payment_id = 1

select * from payment_02_2006

select distinct date_part('year', payment_date) 
from payment

create database payment_2005

CREATE TABLE payment_2005_out (
	payment_id int4 NOT NULL,
	customer_id int2 NOT NULL,
	staff_id int2 NOT NULL,
	rental_id int4 NOT NULL,
	amount numeric(5, 2) NOT NULL,
	payment_date timestamp NOT null check (date_part('year', payment_date) = 2005));

create database payment_2006

CREATE TABLE payment_2006_out (
	payment_id int4 NOT NULL,
	customer_id int2 NOT NULL,
	staff_id int2 NOT NULL,
	rental_id int4 NOT NULL,
	amount numeric(5, 2) NOT NULL,
	payment_date timestamp NOT null check (date_part('year', payment_date) = 2006));

create extension postgres_fdw 

create server pay_server_2005
foreign data wrapper postgres_fdw
options (host 'localhost', port '5435', dbname 'payment_2005')

create server pay_server_2006
foreign data wrapper postgres_fdw
options (host 'localhost', port '5435', dbname 'payment_2006')

create user mapping for postgres
server pay_server_2005
options (user 'postgres', password '123')

create user mapping for postgres
server pay_server_2006
options (user 'postgres', password '123')

create foreign table payment_2005_in (
	payment_id int4 not null,
	customer_id int2 not null,
	staff_id int2 not null,
	rental_id int4 not null,
	amount numeric(5, 2) not null,
	payment_date timestamp not null check (date_part('year', payment_date) = 2005))
inherits (payment)
server pay_server_2005
options (schema_name 'public', table_name 'payment_2005_out')

create foreign table payment_2006_in (
	payment_id int4 not null,
	customer_id int2 not null,
	staff_id int2 not null,
	rental_id int4 not null,
	amount numeric(5, 2) not null,
	payment_date timestamp not null check (date_part('year', payment_date) = 2006))
inherits (payment)
server pay_server_2006
options (schema_name 'public', table_name 'payment_2006_out')

create or replace function payment_insert_tg() returns trigger as $$
begin
	if date_part('year', new.payment_date) = 2005 then    
		insert into payment_2005_in values (new.*);
	elsif date_part('year', new.payment_date) = 2006 then  
		insert into payment_2006_in values (new.*);
	else raise exception 'отсутствует шард, автоматизация затруднительна, не ругайтесь';
	end if;
	return null;
end; $$ language plpgsql;

create trigger payment_insert_tg
before insert on payment
for each row execute function payment_insert_tg();

create temporary table temp_pay as (select * from payment p)

delete from payment

select * from payment p

insert into payment
select * from temp_pay

"Задание 1. Выполните горизонтальное партиционирование для таблицы inventory учебной базы dvd-rental:
создайте 2 партиции по значению store_id
создайте индексы для каждой партиции
заполните партиции данными из родительской таблицы
для каждой партиции создайте правила на внесение, обновление данных. Напишите команды SQL для проверки работы правил.

Задание 2. Создайте новую базу данных и в ней 2 таблицы для хранения данных по инвентаризации каждого магазина, которые будут 
наследоваться из таблицы inventory базы dvd-rental. Используя шардирование и модуль postgres_fdw создайте подключение к новой 
базе данных и необходимые внешние таблицы в родительской базе данных для наследования. Распределите данные по внешним таблицам. 
Напишите триггер для переноса данных
Напишите SQL-запросы для проверки работы внешних таблиц.

