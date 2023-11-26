-- 2 task

create database inventory_base;


-- в новой базе

CREATE TABLE public.inventory_store1 (
	inventory_id serial4 NOT NULL,
	film_id int2 NOT NULL,
	store_id int2 NOT null CHECK (store_id = 1),
	last_update timestamp NOT NULL DEFAULT now()
);

CREATE TABLE public.inventory_store2 (
	inventory_id serial4 NOT NULL,
	film_id int2 NOT NULL,
	store_id int2 NOT null CHECK (store_id = 2),
	last_update timestamp NOT NULL DEFAULT now()
);

-- возвращаемся в старую БД

create server inventory_server
foreign data wrapper postgres_fdw
options (host 'localhost', port '5432', dbname 'inventory_base')

create user mapping for postgres
server inventory_server
options (user 'postgres', password '1234')

create foreign table inventory_store1_in2 (
	inventory_id serial4 NOT NULL,
	film_id int2 NOT NULL,
	store_id int2 NOT null CHECK (store_id = 1),
	last_update timestamp NOT NULL DEFAULT now()
)
inherits (inventory)
server inventory_server
options (schema_name 'public', table_name 'inventory_store1');


create foreign table inventory_store2_in2 (
	inventory_id serial4 NOT NULL,
	film_id int2 NOT NULL,
	store_id int2 NOT null CHECK (store_id = 2),
	last_update timestamp NOT NULL DEFAULT now()
)
inherits (inventory)
server inventory_server
options (schema_name 'public', table_name 'inventory_store2');

--

create or replace function inventory_insert_tg() returns trigger as $$
begin
	if new.store_id = 1 then
		insert into inventory_store1_in2 values (new.*);
	elsif new.store_id = 2 then
		insert into inventory_store2_in2 values (new.*);
	else raise exception 'Unknown store id, create shard';
	end if;
	return null;
end; $$ language plpgsql;

create or replace trigger inventory_insert_trigger
before insert on inventory
for each row execute function inventory_insert_tg();

-- удаляем правила из 1 задачи, чтобы не мешали новой логике

drop rule IF exists inventory_update_1 on inventory;
drop rule IF exists inventory_store1_insert_ on inventory;
drop rule IF exists inventory_update_2 on inventory;
drop rule IF exists inventory_store2_insert_ on inventory;

---

create temporary table temp_inventory as (select * from inventory);
delete from inventory;
select * from inventory;
select * from inventory_store2_in;

insert into inventory
(select * from temp_inventory);

insert into inventory (inventory_id, film_id, store_id)
values (1000, 2000, 1);