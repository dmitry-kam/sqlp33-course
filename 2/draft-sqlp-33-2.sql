select sum(amount)
from payment 
where payment_date::date between '01.07.2005' and '01.08.2005'

$$ $$ = ' '

create function foo1(date, date) returns numeric as $$
	begin
		return (select sum(amount)
		from payment 
		where payment_date::date between $1 and $2);	 
	end;
$$ language plpgsql

select foo1('15.07.2005', '01.08.2005')

create function foo1(start_date date, end_date date) returns numeric as $$
	declare res numeric;
	begin
		select sum(amount)
		from payment 
		where payment_date::date between start_date and end_date into res;	
		return res;
	end;
$$ language plpgsql

create or replace function foo1(start_date date, end_date date) returns numeric as $$
	declare res numeric;
	begin
		select sum(amount)
		from payment 
		where payment_date::date between start_date and end_date into res;	
		return res;
	end;
$$ language plpgsql

select foo1('15.07.2005', '01.08.2005')

drop function foo1

create or replace function foo1(date, date, out res numeric) as $$
	declare 
		start_date alias for $1;
		end_date alias for $2;
	begin
		select sum(amount)
		from payment 
		where payment_date::date between start_date and end_date into res;	
	end;
$$ language plpgsql

#####################################################################

create or replace function foo1(start_date date, end_date date, cust_id int) returns numeric as $$
	declare res numeric;
	begin
		select sum(amount)
		from payment 
		where payment_date::date between start_date and end_date and customer_id = cust_id into res;	
		return res;
	end;
$$ language plpgsql

select foo1('15.07.2005', '01.08.2005') --16716.72

select foo1('15.07.2005', '01.08.2005', 150) --10.97

foo1(date, date)

foo1(date, date, int)

drop function foo1

SQL Error [42725]: ОШИБКА: имя функции "foo1" не уникально

drop function foo1(date, date, int)

##################################################################################

if  then
elseif then 
else
end if;

elseif / elsif

case
	when условие then 
	else
end

case значение
	when значение then 
	else
end

create or replace function foo1(start_date date, end_date date) returns numeric as $$
	declare res numeric;
	begin
		if start_date is null 
			then start_date = (select min(payment_date::date) from payment);
		end if;
		if end_date is null 
			then end_date = (select max(payment_date::date) from payment);
		end if;
		if start_date > end_date
			then raise exception 'Дата начала % больше, чем дата окончания %', start_date, end_date;
		end if;
		select sum(amount)
		from payment 
		where payment_date::date between start_date and end_date into res;	
		return res;
	end;
$$ language plpgsql

select foo1(null, null) --16716.72

SQL Error [P0001]: ОШИБКА: Дата начала 2005-08-01 больше, чем дата окончания 2005-07-15

SQL Error [P0001]: ОШИБКА: Дата начала или окончания отсутствует

create or replace function foo1(start_date date, end_date date) returns numeric as $$
	declare res numeric;
	begin
		if start_date is null or end_date is null 
			then raise exception 'Дата начала или окончания отсутствует';
		elseif start_date > end_date
			then raise exception 'Дата начала % больше, чем дата окончания %', start_date, end_date;
		else 
			select sum(amount)
			from payment 
			where payment_date::date between start_date and end_date into res;	
			return res;
		end if;
	end;
$$ language plpgsql

create or replace function foo1(start_date date, end_date date) returns numeric as $$
	declare res numeric;
	begin
		if start_date is null or end_date is null 
			then raise notice 'Дата начала или окончания отсутствует';
		elseif start_date > end_date
			then raise notice 'Дата начала % больше, чем дата окончания %', start_date, end_date;
		else 
			select sum(amount)
			from payment 
			where payment_date::date between start_date and end_date into res;	
			return res;
		end if;
		return null;
	end;
$$ language plpgsql

try () catch () -- отсутствует

if () then raise notice ()

create or replace function foo2(start_date date, end_date date, cust_id int) returns text as $$
	begin
		case 
			when cust_id in (
				select customer_id
				from payment 
				where payment_date::date between start_date and end_date)
				then return 'yes';
			else return 'no';
		end case;	
	end;
$$ language plpgsql

select foo2('01.07.2005', '15.07.2005', 30000)

create or replace function foo2(start_date date, end_date date, cust_id int) returns text as $$
	begin
		case cust_id
			when (
				select customer_id
				from payment 
				where payment_date::date between start_date and end_date
				order by random()
				limit 1)
				then return 'yes';
			when (
				select customer_id
				from payment 
				where payment_date::date between start_date and end_date
				order by 1
				limit 1)
				then return 'yes';
			else return 'no';
		end case;	
	end;
$$ language plpgsql

select foo2('01.07.2005', '15.07.2005', 2)

###############################################################################

for 
foreach 
while
loop next/exit/continue

create or replace function foo4(some_amount numeric, out user_name text, out total_amount numeric, out total_count int) returns setof record as $$
	declare i record;
	begin
		for i in 
			select customer_id
			from payment
			group by customer_id
			having sum(amount) > some_amount
		loop
			select concat(c.last_name, ' ', c.first_name), sum(p.amount), count(r.rental_id)
			from payment p
			join rental r on r.rental_id = p.rental_id
			join customer c on c.customer_id = p.customer_id
			where p.customer_id = i.customer_id
			group by c.customer_id into user_name, total_amount, total_count;
			return next;
		end loop;	
	end;
$$ language plpgsql

select *
from foo4(180)

drop function foo4

create or replace function foo4(some_amount numeric) returns table (user_name text, total_amount numeric, total_count bigint) as $$
	begin
	return query
		select concat(c.last_name, ' ', c.first_name), sum(p.amount), count(r.rental_id)
		from payment p
		join rental r on r.rental_id = p.rental_id
		join customer c on c.customer_id = p.customer_id
		group by c.customer_id 
		having sum(amount) > some_amount;
	end;
$$ language plpgsql

SQL Error [42804]: ОШИБКА: structure of query does not match function result type

create or replace function foo5(x int) returns table (y int) as $$
	declare i int = 0;
	begin
		for i in 1..x
		loop
			y = i;
			return next;
		end loop;		
	end;
$$ language plpgsql

select *
from foo5(10)

create or replace function foo5(x int) returns table (y int) as $$
	declare i int = 0;
	begin
		for i in reverse x..1
		loop
			y = i;
			return next;
		end loop;		
	end;
$$ language plpgsql

create or replace function foo5(x int) returns table (y int) as $$
	declare i int = 0;
	begin
		while i < 10
		loop
			i = i + 1;
			y = i;
			return next;
		end loop;		
	end;
$$ language plpgsql

select *
from foo5(10)

--for (i = 0; i < x; i++)

create or replace function foo5(x int) returns table (y int) as $$
	declare i int = 0;
	begin
		loop
			i = i + 1;
			y = i;
			exit when y > x;
			return next;
		end loop;		
	end;
$$ language plpgsql

create or replace function foo6(some_array text[]) returns table (some_element text) as $$
	declare i text;
	begin
		foreach i in array some_array
		loop
			some_element = i;
			return next;
		end loop;		
	end;
$$ language plpgsql

select *
from foo6((select special_features from film where film_id = 15))

select special_features from film where film_id = 15

############################################################################################

function 
procedure 
do 

select *
from pg_catalog.pg_roles pr

create role test_user with login

alter role test_user valid until (select date_trunc('month', current_date) + interval ' 1 month' - interval '1 day')

select (date_trunc('month', current_date) + interval ' 1 month' - interval '1 day')::date

do $$
	declare some_user text = 'test_user';
		some_date date = (select (date_trunc('month', current_date) + interval ' 1 month' - interval '1 day')::date);
	begin
		execute 'alter role ' || quote_ident(some_user) || ' valid until ' || quote_literal(some_date);
	end;
$$ language plpgsql

quote_ident() - ""
quote_literal() - ''
quote_nullable() - null

'alter role "test_user" valid until ''30.10.2023''';

####################################################################################

select *
from foo4(180) f
join customer c on f.user_name = concat(c.last_name, ' ', c.first_name)
where f.total_count in (select foo5(40))

explain analyze --519.97 / 1438
select customer_id, sum(amount) * 100. / foo1('15.07.2005', '01.08.2005')
from payment 
group by customer_id

select foo1('15.07.2005', '01.08.2005')

explain analyze --571.09 / 10
select customer_id, sum(amount) * 100. / f
from payment, foo1('15.07.2005', '01.08.2005') f
group by customer_id, f

####################################################################################

with cte as (
	select *
	from foo4(180) f
	join ...
	where ...
	aggregate ...)
select * from cte

####################################################################################

drop table some_table1

drop table some_table2

create table some_table1 (
	id int,
	val text,
	last_update timestamp)
	
create table some_table2 (
	id int,
	val text,
	last_update timestamp)
	
insert into some_table1 (id, val)
values (1, 'a')

select * from some_table1

create trigger some_table1_update_tg 
before update on some_table1
for each row execute function foo1_tf()

create or replace function foo1_tf() returns trigger as $$
	begin
		new.last_update = now();
		return new;
	end;
$$ language plpgsql

update some_table1
set val = 'b'
where id = 1

create trigger some_table1_strange_tg 
after insert or update of val or delete on some_table1
for each row execute function foo2_tf()

create or replace function foo2_tf() returns trigger as $$
	begin
		if tg_op = 'INSERT'
			then insert into some_table2 (id, val)
				values (new.id, new.val);
		elseif tg_op = 'UPDATE'
			then delete from some_table1
				where id = new.id - 1;
		else delete from some_table2;
		end if;
		return null;
	end;
$$ language plpgsql

insert into some_table1 (id, val)
values (1, 'x')

select * from some_table1

select * from some_table2

update some_table1
set val = 'y'
where id = 2

delete from some_table1
where id = 1

create trigger some_table1_strange2_tg 
before delete on some_table1
for each row execute function foo3_tf()

create or replace function foo3_tf() returns trigger as $$
	begin
		return null;
	end;
$$ language plpgsql


create trigger a_tg 
before insert or update or delete on some_table1
for each row execute function foo1_tf()

create or replace function foo1_tf() returns trigger as $$
	begin
		insert into some_table2 (id, val)
			values (coalesce(new.id, old.id), coalesce(new.val, old.val));
		return coalesce(new, old);
	end;
$$ language plpgsql

create trigger b_tg 
before insert or update or delete on some_table1
for each row execute function foo2_tf()

create or replace function foo2_tf() returns trigger as $$
	begin
		insert into some_table2 (id, val)
			values (coalesce(new.id, old.id), coalesce(new.val, old.val));
		return coalesce(new, old);
	end;
$$ language plpgsql

insert into some_table1 (id, val)
values (1, 'x')

select * from some_table1

select * from some_table2

delete from some_table2

create trigger a_tg 
before insert or update or delete on some_table1
for each row execute function foo1_tf()

create or replace function foo1_tf() returns trigger as $$
	begin
		insert into some_table1 (id, val)
			values (coalesce(new.id, old.id), coalesce(new.val, old.val));
		return coalesce(new, old);
	end;
$$ language plpgsql

SQL Error [54001]: ОШИБКА: превышен предел глубины стека

###########################################################################


ddl_command_start
CREATE, ALTER, DROP, SECURITY LABEL, COMMENT, GRANT и revoke 

ddl_command_end
CREATE, ALTER, DROP, SECURITY LABEL, COMMENT, GRANT и revoke 

pg_event_trigger_ddl_commands()
classid		oid	OID каталога, к которому относится объект
objid		oid	OID самого объекта
objsubid	integer	Идентификатор подобъекта (например, номер для столбца)
command_tag	text	Тег команды
object_type	text	Тип объекта
schema_name	text	Имя схемы, к которой относится объект; если объект не относится ни к какой схеме — NULL. В кавычки имя не заключается.
object_identity	text	Текстовое представление идентификатора объекта, включающее схему. При необходимости компоненты этого идентификатора 
					заключаются в кавычки.
in_extension	boolean	True, если команда является частью скрипта расширения
pg_ddl_command	Полное представление команды, во внутреннем формате. Его нельзя вывести непосредственно, но можно передать другим функциям, 
						чтобы получить различные сведения о команде.

table_rewrite
ALTER TABLE и ALTER type

sql_drop
drop

pg_event_trigger_dropped_objects()
classid	oid	OID каталога, к которому относился объект
objid	oid	OID самого объекта
objsubid	integer	Идентификатор подобъекта (например, номер для столбца)
original	boolean	True, если это один из корневых удаляемых объектов
normal	boolean	True, если к этому объекту в графе зависимостей привело отношение обычной зависимости
is_temporary	boolean	True, если объект был временным
object_type	text	Тип объекта
schema_name	text	Имя схемы, к которой относился объект; если объект не относился ни к какой схеме — NULL. В кавычки имя не заключается.
object_name	text	Имя объекта, если сочетание схемы и имени позволяет уникально идентифицировать объект; в противном случае — NULL. 
					Имя не заключается в кавычки и не дополняется именем схемы.
object_identity	text	Текстовое представление идентификатора объекта, включающее схему. При необходимости компоненты этого идентификатора 
					заключаются в кавычки.
address_names	text[]	Массив, который в сочетании с object_type и массивом address_args можно передать функции pg_get_object_address,
						чтобы воссоздать адрес объекта на удалённом сервере, содержащем одноимённый объект того же рода.
address_args	text[]	Дополнение к массиву address_names

TG_EVENT - — тип данных text. Строка, содержащая событие, для которого сработал триггер.
TG_TAG - — тип данных text. Переменная, содержащая тег команды, для которой сработал триггер.

CREATE TABLE ddl_audit (
	id SERIAL PRIMARY KEY,
	command_type VARCHAR(64) NOT NULL,
	schema_name VARCHAR(64) NOT NULL,
	object_name VARCHAR(64) NOT NULL,
	user_name VARCHAR(64) NOT NULL DEFAULT CURRENT_USER,
	created_at TIMESTAMP NOT NULL DEFAULT NOW())
	
CREATE OR REPLACE FUNCTION ddl_command_audit() RETURNS event_trigger AS $$
DECLARE i record;
BEGIN
	IF TG_EVENT = 'ddl_command_end' then
		FOR i IN SELECT * FROM pg_event_trigger_ddl_commands() WHERE object_type = 'table' or object_type = 'function' 
		loop
			INSERT INTO ddl_audit (command_type, schema_name, object_name)
		    VALUES (tg_tag, (SELECT SPLIT_PART(i.object_identity, '.', 1)), (SELECT SPLIT_PART(i.object_identity, '.', 2)));
		END LOOP;
	ELSEIF TG_EVENT = 'sql_drop' THEN
   		FOR i IN SELECT * FROM pg_event_trigger_dropped_objects() WHERE object_type = 'table' or object_type = 'function' 
	    LOOP
			INSERT INTO ddl_audit (command_type, schema_name, object_name)
			VALUES(tg_tag, (SELECT SPLIT_PART(i.object_identity, '.', 1)), (SELECT SPLIT_PART(i.object_identity, '.', 2)));
	    END LOOP;
   END IF;	
END; $$ LANGUAGE plpgsql;


CREATE EVENT TRIGGER ddl_command_audit ON ddl_command_end
EXECUTE FUNCTION ddl_command_audit();

CREATE EVENT TRIGGER ddl_command_audit_drop ON sql_drop
EXECUTE FUNCTION ddl_command_audit();

select * from ddl_audit

drop function foo1_tf cascade

drop EVENT TRIGGER ddl_command_audit

drop EVENT TRIGGER ddl_command_audit_drop

select * from pg_catalog.pg_trigger pt

select * from information_schema.triggers t

#######################################################################################

function 							procedure 
обязательно что-то возвращает		ничего не возвращает
returns должен быть					returns отсутствует
вызывается где угодно				call 
работает внутри транзакции			управляет транзакциями


create or replace function foo() returns .... as $$
	begin
		begin;
			....
		commit;	
	end;
$$ language plpgsql

begin; select foo() commit;	

create or replace procedure p() as $$
	begin
		call p2();
		select ...
	end;
$$ language plpgsql

create or replace procedure p2() as $$
	begin
		rollback;
	end;
$$ language plpgsql

CREATE TABLE table_a (
	id serial PRIMARY KEY,
	val int NOT NULL);
	
INSERT INTO table_a (val)
VALUES (11), (12), (13);

CREATE TABLE table_b (
	id serial PRIMARY KEY,
	val int NOT NULL,
	created_at timestamp DEFAULT now());
	
CREATE or replace FUNCTION f1() RETURNS void AS $$
	BEGIN
		FOR i IN 1..10
		LOOP 
			IF i%2 = 0 
				THEN 
					INSERT INTO table_b(val)
					VALUES (i);
			END IF;
		END LOOP;
	END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION f2() RETURNS void AS $$
	DECLARE i record;
	BEGIN
		PERFORM f1();
		FOR i IN 
			SELECT val FROM table_a
		LOOP 
			INSERT INTO table_b(val)
			VALUES (i.val);
		END LOOP;
	END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION f3() RETURNS void AS $$
	BEGIN
		PERFORM f2();
	END;
$$ LANGUAGE plpgsql;

select f3()

select * from table_b

delete from table_b

CREATE PROCEDURE p1() AS $$
	BEGIN
		FOR i IN 1..10
		LOOP 
			INSERT INTO table_b(val)
			VALUES (i);
			IF i%2 = 0 
				THEN COMMIT; 
			ELSE 
				ROLLBACK;
			END IF;
		END LOOP;
	END;
$$ LANGUAGE plpgsql;

CREATE or replace PROCEDURE p2() AS $$
	DECLARE i record;
	BEGIN
		FOR i IN 
			SELECT val FROM table_a
		LOOP 
			INSERT INTO table_b(val)
			VALUES (i.val);
		END LOOP;
		commit;
		CALL p1();
	END;
$$ LANGUAGE plpgsql;

CREATE PROCEDURE p3() AS $$
	BEGIN
		CALL p2();
	END;
$$ LANGUAGE plpgsql;

call p3()

drop procedure p1()

НЕПРОТЕСТИРОВАННЫЕ РЕШЕНИЯ УЛЕТАЮТ НА ДОРАБОТКУ.
ПРОВЕРЯЮЩИЕ НЕ ТЕСТИРОВЩИКИ, ПРОВЕРЯЮЩИЕ - ЛЕНИВЫЕ.

Задание 1. Напишите функцию, которая принимает на вход название должности (например, стажер), а также даты периода поиска, 
и возвращает количество вакансий, опубликованных по этой должности в заданный период.

Задание 2. Напишите триггер, срабатывающий тогда, когда в таблицу position добавляется значение grade, которого нет в 
таблице-справочнике grade_salary. Триггер должен возвращать предупреждение пользователю о несуществующем значении grade.

insert 
update

Задание 3. Создайте таблицу employee_salary_history с полями:
emp_id - id сотрудника
salary_old - последнее значение salary (если не найдено, то 0)
salary_new - новое значение salary
difference - разница между новым и старым значением salary
last_update - текущая дата и время
Напишите триггерную функцию, которая срабатывает при добавлении новой записи о сотруднике или при обновлении значения 
salary в таблице employee_salary, и заполняет таблицу employee_salary_history данными.

1 - самый первый оклад по сотруднику salary_old = 0
2 - по сотруднику вносится очередной оклад salary_old внести значение предыдущего оклада
3 - изменение значения, спец переменные

Задание 4. Напишите процедуру, которая содержит в себе транзакцию на вставку данных в таблицу employee_salary. 
Входными параметрами являются поля таблицы employee_salary.