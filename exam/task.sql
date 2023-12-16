-- роль и права

create role netocourier with login;
alter role netocourier with password 'NetoSQL2022' valid until '2024-11-25';

REVOKE ALL PRIVILEGES ON all tables IN SCHEMA auth FROM netocourier;
REVOKE ALL PRIVILEGES ON all tables IN SCHEMA extensions FROM netocourier;
REVOKE ALL PRIVILEGES ON all tables IN SCHEMA graphql FROM netocourier;
REVOKE ALL PRIVILEGES ON all tables IN SCHEMA graphql_public FROM netocourier;
--REVOKE ALL PRIVILEGES ON all tables IN SCHEMA pgbouncer FROM netocourier;
REVOKE ALL PRIVILEGES ON all tables IN SCHEMA pgsodium FROM netocourier;
REVOKE ALL PRIVILEGES ON all tables IN SCHEMA pgsodium_masks FROM netocourier;
REVOKE ALL PRIVILEGES ON all tables IN SCHEMA realtime FROM netocourier;
REVOKE ALL PRIVILEGES ON all tables IN SCHEMA storage FROM netocourier;
REVOKE ALL PRIVILEGES ON all tables IN SCHEMA vault FROM netocourier;

REVOKE USAGE ON SCHEMA auth from netocourier;
REVOKE USAGE ON SCHEMA graphql from netocourier;
REVOKE USAGE ON SCHEMA graphql_public from netocourier;
--REVOKE USAGE ON SCHEMA pgbouncer from netocourier;
REVOKE USAGE ON SCHEMA pgsodium from netocourier;
REVOKE USAGE ON SCHEMA pgsodium_masks from netocourier;
REVOKE USAGE ON SCHEMA realtime from netocourier;
REVOKE USAGE ON SCHEMA storage from netocourier;
REVOKE USAGE ON SCHEMA vault from netocourier;


REVOKE ALL PRIVILEGES ON all tables IN SCHEMA information_schema FROM netocourier;
REVOKE ALL PRIVILEGES ON all tables IN SCHEMA pg_catalog FROM netocourier;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO netocourier;
grant usage on schema information_schema to netocourier;
grant usage on schema pg_catalog to netocourier;
grant select ON ALL TABLES IN schema information_schema to netocourier;
grant select ON ALL TABLES IN schema pg_catalog to netocourier;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO postgres;

----- тип и таблицы

-- DROP TABLE public.courier;

CREATE TYPE courier_status_enum AS ENUM ('В очереди','Выполняется', 'Выполнено', 'Отменен');

CREATE TABLE public.courier (
	id uuid NOT NULL,
	from_place varchar(80) NOT NULL,
	where_place varchar(80) NOT NULL,
	"name" varchar(30) NOT NULL,
	account_id uuid NOT NULL,
	contact_id uuid NOT NULL,
	description text NULL,
	user_id uuid NOT NULL,
	status courier_status_enum NOT null default 'В очереди',
	created_date date NULL DEFAULT now(),
	CONSTRAINT courier_pk PRIMARY KEY (id),
	CONSTRAINT courier_fk_acc FOREIGN KEY (account_id) REFERENCES public.account(id) ON UPDATE CASCADE,
	CONSTRAINT courier_fk_cont FOREIGN KEY (contact_id) REFERENCES public.contact(id) ON UPDATE CASCADE,
	CONSTRAINT courier_fk_user FOREIGN KEY (user_id) REFERENCES public."user"(id) ON UPDATE CASCADE
);


CREATE TABLE public.account (
	id uuid NOT NULL,
	"name" varchar(30) NOT NULL,
	CONSTRAINT account_pk PRIMARY KEY (id)
);

DROP TABLE public.contact;

CREATE TABLE public.contact (
	id uuid NOT NULL,
	last_name varchar(20) NOT NULL,
	first_name varchar(15) NOT NULL,
	account_id uuid NOT NULL,
	CONSTRAINT contact_pk PRIMARY KEY (id),
	CONSTRAINT contact_fk_acc FOREIGN KEY (account_id) REFERENCES public.account(id) ON UPDATE CASCADE
);

CREATE TABLE public.user (
	id uuid NOT NULL,
	last_name varchar(20) NOT NULL,
	first_name varchar(15) NOT NULL,
	dismissed bool not null default FALSE,
	CONSTRAINT user_pk PRIMARY KEY (id)
);
------ uuid

select uuid_generate_v4();

ALTER TABLE public.account ALTER COLUMN id SET DEFAULT uuid_generate_v4();
ALTER TABLE public.contact ALTER COLUMN id SET DEFAULT uuid_generate_v4();
ALTER TABLE public.courier ALTER COLUMN id SET DEFAULT uuid_generate_v4();
ALTER TABLE public.user ALTER COLUMN id SET DEFAULT uuid_generate_v4();

----

insert into account ("name") values ('test');
truncate account CASCADE;

---- рандомные типы через функции

create or replace function getRandomString(len int4, out rStr varchar) as $$
begin
	SELECT substring(
	repeat(substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя',1, CEILING(random()*33)::integer), CEILING(random()*10)::integer), 0, len) into rStr;
end;
$$ language plpgsql

---v2
-- todo: Генерация символьных типов должна быть от 1 до N, а не N минус пустые элементы массива.
create or replace function getRandomString(len int4, out rStr varchar) as $$
begin
	SELECT array_to_string(
	array(select substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя', CEILING(random() * 33)::integer + 1, 1)
  FROM   generate_series(1, len)), '') into rStr;end;
$$ language plpgsql


create or replace function getRandomBool(out rStr bool) as $$
begin
	SELECT
	case
		when random() > 0.5 then true
		else false
	end
	into rStr;
end;
$$ language plpgsql

create or replace function getRandomDate(out rStr timestamp) as $$
begin
	select now() - interval '1 day' * round(random() * 1000) as timestamp
	into rStr;
end;
$$ language plpgsql


create or replace function getRandomEnum(relation_name anyelement, out result anyenum)
as $$
begin
  execute format(
    $sql$
      select elem
      from unnest(enum_range(null::%1$I)) as elem
      order by random()
      limit 1;
    $sql$,
    pg_typeof(relation_name)
  ) into result;
end;
$$ language plpgsql;

--select getRandomString(8);

--explain analyze
SELECT getRandomBool();
SELECT getRandomDate();
SELECT getRandomEnum(null::courier_status_enum);

----------- вставка случайных тестовых данных (ушел от большого числа подзапросов в сторону вставок большими чанками
-- чтобы ускорить время вставки - получилось примерно 60-70с для 10k)

-- https://habr.com/ru/articles/747348/
-- https://www.gab.lc/articles/bigdata_postgresql_order_by_random/

--		value * 1 строк случайных данных в отношение account.
--		value * 2 строк случайных данных в отношение contact.
--		value * 1 строк случайных данных в отношение user.
--		value * 5 строк случайных данных в отношение courier.
--- v1
CREATE or replace PROCEDURE insert_test_data(qty int4)
	AS $$
	declare
	offsetArr int;
	offsetCurrent int;
	i int;
	chunk int;
--	new_users record;
	begin
		select COUNT(*)::integer INTO offsetArr
		from public.account;
		--
		-- big query instead loop with a lot of subqueries
			offsetCurrent := offsetArr - 100; -- + i
			if offsetCurrent < 0 then
				offsetCurrent := 0;
			end if;

			INSERT INTO public.account ("name")
				select getRandomString(30) from generate_series(1, qty);
			COMMIT;

			INSERT INTO public."user" (last_name, first_name, dismissed)
			(
				select -- INTO new_users
					getRandomString(20) as last_name,
					getRandomString(15) as first_name,
					getRandomBool() as dismissed
			 	from generate_series(1, qty)
			);
			COMMIT;

			INSERT INTO public.contact (last_name, first_name, account_id)
			(
				select
				getRandomString(20) as last_name, getRandomString(15) as first_name, id
				from public.account order by RANDOM() limit 2*qty -- offset offsetCurrent   limit 2
				-- , generate_series(1, 2*qty)
			);
			COMMIT;


			INSERT INTO public.contact (last_name, first_name, account_id)
			(
				select
				getRandomString(20) as last_name, getRandomString(15) as first_name, id
				from public.account order by RANDOM() limit 2*qty -- offset offsetCurrent   limit 2
				-- , generate_series(1, 2*qty)
			);
			COMMIT;

			i := 0;
			if qty < 50 then
				chunk := 1;
			else
				chunk := 10;
			end if;

			--FOR i IN 1..qty loop
			WHILE i < qty LOOP

				INSERT INTO public.courier(
						from_place, where_place,
						"name", description,
						account_id, contact_id,
						user_id, status,
						created_date)
				select getRandomString(80) as from_place,
				   getRandomString(80) as where_place,
				   getRandomString(30) as "name",
				   getRandomString(100) as description,
				   (select id from public.account order by RANDOM() limit 1),
				   (select id from public.contact order by RANDOM() limit 1),
				   (select id from public."user" order by RANDOM() limit 1),
				   getRandomEnum(null::courier_status_enum) as status,
				   getRandomDate() as created_date
				from generate_series(1, 5*chunk);
		   		COMMIT;

			--explain analyze
--			WITH foreignAIds AS (
--				select id from public.account order by RANDOM()
--			), foreignCIds AS (
--				select id from public.contact order by RANDOM()
--			), foreignUIds AS (
--				select id from public."user" order by RANDOM()
--			)
----			select distinct * from foreignAIds a, foreignCIds c, foreignUIds u;
--			INSERT INTO public.courier(
--				from_place, where_place,
--				"name", description,
--				account_id, contact_id,
--				user_id, status,
--				created_date)
--			select distinct getRandomString(80) as from_place,
--			   getRandomString(80) as where_place,
--			   getRandomString(30) as "name",
--			   getRandomString(100) as description,
--			   a.id as account_id,
--			   c.id as contact_id,
--			   u.id as user_id,
--			   getRandomEnum(null::courier_status_enum) as status,
--			   getRandomDate() as created_date
--		   from foreignAIds a, foreignCIds c, foreignUIds u limit 5*qty;
--		   COMMIT;

		  if qty >= 50 then
				i := i + 10;
		  else
		  		i := i + 1;
		  end if;
		  exit when i >= qty;
	   	END LOOP;
	END;
$$ LANGUAGE plpgsql;


-- чистовик v2 (через tablesample, для 10k отрабатывает примерно за 25 секунд) - в таком виде принято
-- https://habr.com/ru/articles/266759/
CREATE or replace PROCEDURE insert_test_data(qty int4)
	AS $$
	declare
	offsetArr int;
	part int;
	begin
			select COUNT(*)::integer INTO offsetArr
			from public.account;
			-- big query instead loop with a lot of subqueries

			INSERT INTO public.account ("name")
				select getRandomString(30) from generate_series(1, qty);
			COMMIT;

			INSERT INTO public."user" (last_name, first_name, dismissed)
			(
				select
					getRandomString(20) as last_name,
					getRandomString(15) as first_name,
					getRandomBool() as dismissed
			 	from generate_series(1, qty)
			);
			COMMIT;

			INSERT INTO public.contact (last_name, first_name, account_id)
			(
				select
				getRandomString(20) as last_name, getRandomString(15) as first_name, id
				from public.account order by RANDOM() limit 2*qty
			);
			COMMIT;

			if offsetArr >= 1000 then
	  			part := 1;
	  		elseif offsetArr >= 500 then
		  		part := 5;
	  		else
		  		part := 10;
		  	end if;

			FOR i IN 1..5*qty loop
				if i >= 1000 then
			        part := 1;
			  	end if;

				INSERT INTO public.courier(
						from_place, where_place,
						"name", description,
						account_id, contact_id,
						user_id, status,
						created_date)
				select getRandomString(80) as from_place,
				   getRandomString(80) as where_place,
				   getRandomString(30) as "name",
				   getRandomString(100) as description,
				   case
						when part >= 10 then (select id from public.account order by random() limit 1)
						else (select id from public.account TABLESAMPLE BERNOULLI(part) limit 1)
				   end,
				   case
						when part >= 10 then (select id from public.contact order by random() limit 1)
						else (select id from public.contact TABLESAMPLE BERNOULLI(part) limit 1)
				   end,
				   case
						when part >= 10 then (select id from public."user" order by random() limit 1)
						else (select id from public."user" TABLESAMPLE BERNOULLI(part) limit 1)
				   end,
				   getRandomEnum(null::courier_status_enum) as status,
				   getRandomDate() as created_date;

	   		END LOOP;
	    COMMIT;
	END;
$$ LANGUAGE plpgsql;


CREATE or replace PROCEDURE erase_test_data()
	AS $$
	begin
		truncate courier CASCADE;
		truncate contact CASCADE;
		truncate "user" CASCADE;
		truncate account CASCADE;
	END;
$$ LANGUAGE plpgsql;

-------- выборки и проверки процедур

call erase_test_data();
call insert_test_data(100);
select count(*) from courier;
select count(*) from account;
select count(*) from contact;
select count(*) from "user";

explain analyze select * from account where random() < 0.5 limit 1000;
EXPLAIN analyze select * from account order by random() limit 1000;

select * from courier offset 1000 limit 10;

explain analyze
select * from courier order by random() limit 10; -- 7
select * from courier limit 10; -- 0.03
select * from courier offset 1000 limit 10; -- 0.2
--select * from courier offset 1000 limit 10;
-- fetch first 10 rows only

---------------------------------------
-- список процедур
--SELECT routine_schema As schema_name,
--routine_name As procedure_name
--FROM information_schema.routines
--WHERE routine_type = 'PROCEDURE';

-- процедуры и функции по заданиям
--- CALL add_courier (?, ?, ?, ?, ?, ?, ?)
CREATE or replace PROCEDURE add_courier(
	fromPlace varchar(80),
	wherePlace varchar(80),
	nameIn varchar(30),
	accountId text,
	contactId text,
	descriptionIn text,
	userId text
	)
	AS $$
	begin
		insert into courier (
			from_place,
			where_place,
			"name",
			account_id,
			contact_id,
			description,
			user_id
		)
		VALUES (fromPlace, wherePlace, nameIn, accountId::uuid, contactId::uuid, descriptionIn, userId::uuid);
		COMMIT;
	END;
$$ LANGUAGE plpgsql;

-- тестим
call add_courier(
'test',
'test2',
'test3',
'8f6e70cd-5122-49f8-bd74-9e4892b3af8e',
'b04f0e14-c217-430e-a617-34071fd65d20',
'test4 text text example',
'dcac54ba-22d4-419e-8377-3404432eb7c2'
);

--------------------------------------
--Нужно реализовать функцию get_courier(), которая возвращает таблицу согласно следующей структуры:
DROP FUNCTION get_courier();
create or replace function get_courier()
	returns table (
		id uuid,
		from_place varchar,
		where_place varchar,
		"name" varchar,
		account_id uuid,
		account varchar(30),
		contact_id uuid,
		contact text,
		description text,
		user_id uuid,
		"user" text,
		status courier_status_enum,
		created_date date
	)
as $$
begin
	return query
		select c.id as id, c.from_place as from_place,
		c.where_place as where_place, c."name" as "name",
		c.account_id as account_id, a."name" as account,
		c.contact_id as contact_id, CONCAT(con.last_name, ' ', con.first_name) as contact,
		c.description, c.user_id, CONCAT(u.last_name, ' ', u.first_name) as "user",
		c.status as status, c.created_date as created_date
		from courier c
			join account a on c.account_id = a.id
			join contact con on c.contact_id = con.id
			join "user" u on c.user_id = u.id
		order by status, created_date desc;
end;
$$ language plpgsql

SELECT * FROM get_courier();

------------------
-- реализовать процедуру change_status(status, id), которая будет изменять статус заявки.
-- На вход процедура принимает новое значение статуса и значение идентификатора заявки.

CREATE or replace PROCEDURE change_status(statusNew text, idRequest text)
AS
$$
	begin
		update courier
		set status = statusNew::courier_status_enum
		where id = idRequest::uuid;
		COMMIT;
	END;
$$
LANGUAGE plpgsql;

select id, status from courier where id = '5b200971-e11f-4856-bc5b-7effac5b842f'::uuid;

call change_status(
'В очереди',
'5b200971-e11f-4856-bc5b-7effac5b842f'
);

-----------------------

--Нужно реализовать функцию get_users(), которая возвращает таблицу согласно следующей структуры:
--user --фамилия и имя сотрудника через пробел
--Сотрудник должен быть действующим! Сортировка должна быть по фамилии сотрудника.

DROP FUNCTION get_users();
create or replace function get_users()
	returns table (
		"user" text
	)
as $$
begin
	return query
		select CONCAT(u.last_name, ' ', u.first_name) as "user"
		from "user" u
		where u.dismissed is false
		order by u.last_name asc;
end;
$$ language plpgsql

SELECT * FROM get_users();

------------------------------------------------------------------
--get_accounts() --получение списка контрагентов
DROP FUNCTION get_accounts();
create or replace function get_accounts()
	returns table (
		"account" varchar
	)
as $$
begin
	return query
		select a."name" as account
		from account a
		order by account asc;
end;
$$ language plpgsql

SELECT * FROM get_accounts();

-----------------------------------------------------------------

-- реализовать функцию get_contacts(account_id),
-- которая принимает на вход идентификатор контрагента и возвращает таблицу с
-- контактами переданного контрагента согласно следующей структуры:
-- contact --фамилия и имя контакта через пробел
-- Сортировка должна быть по фамилии контакта.
-- Если в функцию вместо идентификатора контрагента передан null, нужно вернуть строку 'Выберите контрагента'.

DROP FUNCTION get_contacts();
create or replace function get_contacts(accountId text default null)
	returns table (
		contact varchar
	)
as $$
begin
	if accountId is null
	then
		return query
			select 'Выберите контрагента'::varchar as contact;
	end if;

	return query
		select CONCAT(con.last_name, ' ', con.first_name)::varchar as contact
		from contact con
		where con.account_id = accountId::uuid
		order by con.last_name asc;
end;
$$ language plpgsql

SELECT * FROM get_contacts();
SELECT * FROM get_contacts('5f29e1d4-2ca6-4d40-88ed-f1871fc6cfb5');

-------------------- представление по заданию. ушел от подзапросов к джойнам с другими представлениями,
-- заранее декомпозированными, чтобы итоговый запрос не был слишком монструозным


--SELECT EXTRACT(MONTH FROM now()) AS "Month";
--SELECT EXTRACT(YEAR FROM now()) AS "Year";

CREATE or replace VIEW orders_by_accounts AS
select account_id, status, count(*) as qty from courier group by account_id, status;

CREATE or replace VIEW all_orders_by_accounts AS
select account_id, SUM(qty) as qty from orders_by_accounts group by account_id;

CREATE or replace VIEW whereplaces_by_accounts AS
select t.account_id, count(*) as qty from (
	select account_id, count(*) as qty from courier
	group by account_id, where_place
) as t
group by t.account_id;

-- условие: count_contact --количество контактов по контрагенту, которым доставляются документы
-- ответ заказчика: count_contact - вопрос про заявки, которые в данный момент выполняются, а не все
-- todo: нужно сделать from courier с условием по статусу и группировкой по аккаунту, left join к контактам со связкой по аккаунту
CREATE or replace VIEW contacts_by_accounts AS
select account_id, count(*) as qty from contact
	group by account_id;

CREATE or replace VIEW cancelleduseridarray_by_accounts AS
SELECT account_id, array_agg(user_id) as cancel_user_array
	FROM courier
    where status = 'Отменен'::courier_status_enum
    GROUP BY account_id;

CREATE or replace VIEW percent_relative_by_accounts AS
select t.account_id, t.currentMonthQty, t2.prevMonthQty, case
			when t2.prevMonthQty = 0 then 0
			else round(t.currentMonthQty::numeric/t2.prevMonthQty::numeric * 100, 2)
		end as percent
		 from
			(select account_id, count(*) as currentMonthQty from courier c2 where
				EXTRACT(YEAR FROM c2.created_date)=EXTRACT(YEAR FROM now())
				and EXTRACT(MONTH FROM c2.created_date)=EXTRACT(MONTH FROM now())
				group by account_id
			) t
				join
			(select account_id, count(*) as prevMonthQty from courier c2 where
				EXTRACT(YEAR FROM c2.created_date)=EXTRACT(YEAR FROM now())
				and EXTRACT(MONTH FROM c2.created_date)=(EXTRACT(MONTH FROM now())-1)
				group by account_id
			) t2
			 on t.account_id = t2.account_id;

CREATE or replace VIEW grouped_accounts_list AS
select
a.id as account_id,
a."name" as account from account a;

---- проверяем вьюхи

SELECT * FROM orders_by_accounts;
SELECT * FROM all_orders_by_accounts;
SELECT * FROM whereplaces_by_accounts;
SELECT * FROM contacts_by_accounts;
SELECT * FROM cancelleduseridarray_by_accounts;
SELECT * FROM percent_relative_by_accounts;
SELECT * FROM grouped_accounts_list;

--- делаем и проверяем итоговую (после созданиях всех не забываем повторить процедуру выдачи прав на таблицы для пользователя курьера)

SELECT * FROM courier_statistic;

--реализовать представление courier_statistic, со следующей структурой:
-- account_id --идентификатор контрагента
-- account --название контрагента
--count_courier --количество заказов на курьера для каждого контрагента
--count_complete --количество завершенных заказов для каждого контрагента
--count_canceled --количество отмененных заказов для каждого контрагента
--percent_relative_prev_month
-- процентное изменение количества заказов текущего месяца к предыдущему месяцу для каждого контрагента,
-- если получаете деление на 0, то в результат вывести 0.
--count_where_place --количество мест доставки для каждого контрагента
--count_contact --количество контактов по контрагенту, которым доставляются документы
--cansel_user_array --массив с идентификаторами сотрудников, по которым были заказы со статусом "Отменен" для каждого контрагента

CREATE or replace VIEW courier_statistic AS
select
	a.account_id as account_id,
	a.account as account,
	coalesce(ao.qty,0) AS count_courier,
       coalesce(ofinished.qty,0) AS count_complete,
       coalesce(ocancelled.qty,0) AS count_canceled,
       coalesce(relprev."percent",0) AS percent_relative_prev_month,
       coalesce(wp.qty,0) AS count_where_place,
       coalesce(cont.qty,0) AS count_contact,
       coalesce(arrusers.cancel_user_array, '{}') AS cansel_user_array
from grouped_accounts_list a
	left join all_orders_by_accounts ao on a.account_id = ao.account_id
	join orders_by_accounts ocancelled on a.account_id = ocancelled.account_id and ocancelled.status = 'Отменен'::courier_status_enum
	join orders_by_accounts ofinished on a.account_id = ofinished.account_id and ofinished.status = 'Выполнено'::courier_status_enum
	join percent_relative_by_accounts relprev on a.account_id = relprev.account_id
	join whereplaces_by_accounts wp on a.account_id = wp.account_id
	join contacts_by_accounts cont on a.account_id = cont.account_id
	join cancelleduseridarray_by_accounts arrusers on a.account_id = arrusers.account_id
order by account;


--- v2 без других представлений (в таком виде принято)
CREATE OR REPLACE VIEW courier_statistic AS
SELECT a.account_id AS account_id,
       a.account AS account,
       coalesce(ao.qty,0) AS count_courier,
       coalesce(ofinished.qty,0) AS count_complete,
       coalesce(ocancelled.qty,0) AS count_canceled,
       coalesce(relprev."percent",0) AS percent_relative_prev_month,
       coalesce(wp.qty,0) AS count_where_place,
       coalesce(cont.qty,0) AS count_contact,
       coalesce(arrusers.cancel_user_array, '{}') AS cansel_user_array
FROM
  (SELECT id AS account_id,
          "name" AS account
   FROM account) a
LEFT JOIN
  (SELECT tt.account_id AS account_id,
          SUM(tt.qty) AS qty
   FROM
     (SELECT account_id,
             status,
             count(*) AS qty
      FROM courier
      GROUP BY account_id,
               status) tt
   GROUP BY account_id) ao ON a.account_id = ao.account_id
LEFT JOIN
  (SELECT account_id,
          count(*) AS qty
   FROM courier
   WHERE status = 'Отменен'::courier_status_enum
   GROUP BY account_id) ocancelled ON a.account_id = ocancelled.account_id
LEFT JOIN
  (SELECT account_id,
          count(*) AS qty
   FROM courier
   WHERE status = 'Выполнено'::courier_status_enum
   GROUP BY account_id) ofinished ON a.account_id = ofinished.account_id
LEFT JOIN
  (SELECT t.account_id,
          t.currentMonthQty,
          t2.prevMonthQty,
          CASE
              WHEN t2.prevMonthQty = 0 THEN 0
              ELSE round(t.currentMonthQty::numeric/t2.prevMonthQty::numeric * 100, 2)
          END AS percent
   FROM
     (SELECT account_id,
             count(*) AS currentMonthQty
      FROM courier c2
      WHERE EXTRACT(YEAR
                    FROM c2.created_date)=EXTRACT(YEAR
                                                  FROM now())
        AND EXTRACT(MONTH
                    FROM c2.created_date)=EXTRACT(MONTH
                                                  FROM now())
      GROUP BY account_id) t
   JOIN
     (SELECT account_id,
             count(*) AS prevMonthQty
      FROM courier c2
      WHERE EXTRACT(YEAR
                    FROM c2.created_date)=EXTRACT(YEAR
                                                  FROM now())
        AND EXTRACT(MONTH
                    FROM c2.created_date)=(EXTRACT(MONTH
                                                   FROM now())-1)
      GROUP BY account_id) t2 ON t.account_id = t2.account_id) relprev ON a.account_id = relprev.account_id
LEFT JOIN
  (SELECT t.account_id,
          count(*) AS qty
   FROM
     (SELECT account_id,
             count(*) AS qty
      FROM courier
      GROUP BY account_id,
               where_place) AS t
   GROUP BY t.account_id) wp ON a.account_id = wp.account_id
LEFT JOIN
  (SELECT account_id,
          count(*) AS qty
   FROM contact
   GROUP BY account_id) cont ON a.account_id = cont.account_id
LEFT JOIN
  (SELECT account_id,
          array_agg(user_id) AS cancel_user_array
   FROM courier
   WHERE status = 'Отменен'::courier_status_enum
   GROUP BY account_id) arrusers ON a.account_id = arrusers.account_id
ORDER BY account;



--- черновик с подзапросами
--CREATE or replace VIEW courier_statistic AS
--  select --distinct
--		a.id as account_id,
--		a."name" as account
----		(select count(*) from courier c2 where c2.account_id = a.id) as count_courier,
----		(select count(*) from courier c2 where c2.account_id = a.id and c2.status = 'Выполнено'::courier_status_enum) as count_complete,
----		(select count(*) from courier c2 where c2.account_id = a.id and c2.status = 'Отменен'::courier_status_enum) as count_canceled
----		,
----		(select case
----			when t2.prevMonthQty = 0 then 0
----			else t.currentMonthQty::float/t2.prevMonthQty::float
----		end
----		 from
----			(select count(*) as currentMonthQty from courier c2 where c2.account_id = a.id and
----				EXTRACT(YEAR FROM c2.created_date)=EXTRACT(YEAR FROM now())
----				and EXTRACT(MONTH FROM c2.created_date)=EXTRACT(MONTH FROM now())) t,
----			(select count(*) as prevMonthQty from courier c2 where c2.account_id = a.id and
----				EXTRACT(YEAR FROM c2.created_date)=EXTRACT(YEAR FROM now())
----				and EXTRACT(MONTH FROM c2.created_date)=(EXTRACT(MONTH FROM now())-1)) t2
----		) as percent_relative_prev_month,
----		(select count(*) from courier c2 where c2.account_id = a.id and c2.status = 'Отменен'::courier_status_enum) as count_where_place
----		c.contact_id as contact_id, CONCAT(con.last_name, ' ', con.first_name) as contact,
----		c.description, c.user_id, CONCAT(u.last_name, ' ', u.first_name) as "user",
----		c.status as status, c.created_date as created_date
--	from account a
--		join courier c on c.account_id = a.id
--		join contact con on c.contact_id = con.id
--		join "user" u on c.user_id = u.id
--	group by a.id
--	order by account;