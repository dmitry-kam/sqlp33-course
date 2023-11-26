-- 1 task

select store_id from inventory group by store_id;

CREATE TABLE inventory_store1
(CHECK (store_id = 1)) INHERITS (inventory);

CREATE TABLE inventory_store2
(CHECK (store_id = 2)) INHERITS (inventory);

CREATE INDEX inventory_store_idx ON inventory_store1 USING btree (film_id);
CREATE INDEX inventory_store2_idx ON inventory_store2 USING btree (film_id);

CREATE RULE inventory_store1_insert_ AS ON INSERT TO inventory
WHERE (store_id = 1)
DO INSTEAD INSERT INTO inventory_store1 VALUES (new.*);

CREATE RULE inventory_store2_insert_ AS ON INSERT TO inventory
WHERE (store_id = 2)
DO INSTEAD INSERT INTO inventory_store2 VALUES (new.*);

ALTER TABLE inventory
DROP CONSTRAINT inventory_store_id_fkey;
ALTER TABLE inventory
DROP CONSTRAINT inventory_film_id_fkey;
ALTER TABLE rental
DROP CONSTRAINT rental_inventory_id_fkey;
--CONSTRAINT inventory_film_id_fkey FOREIGN KEY (film_id) REFERENCES public.film(film_id) ON DELETE RESTRICT ON UPDATE CASCADE

WITH cte AS (
	DELETE FROM ONLY inventory
	WHERE store_id = 1 RETURNING *
	)
INSERT INTO inventory_store1
SELECT * FROM cte;

WITH cte AS (
	DELETE FROM ONLY inventory
	WHERE store_id = 2 RETURNING *
	)
INSERT INTO inventory_store2
SELECT * FROM cte;

--SELECT * FROM inventory;

CREATE RULE inventory_update_1 AS ON UPDATE TO inventory
WHERE (new.store_id != old.store_id)
DO INSTEAD (
INSERT INTO inventory VALUES (new.*);
DELETE FROM inventory_store1 WHERE inventory_id = old.inventory_id
);

CREATE RULE inventory_update_2 AS ON UPDATE TO inventory
WHERE (new.store_id != old.store_id)
DO INSTEAD (
INSERT INTO inventory VALUES (new.*);
DELETE FROM inventory_store2 WHERE inventory_id = old.inventory_id
);

-- tests

insert into inventory (inventory_id, film_id, store_id) values
(123, 240, 1);
update inventory set store_id = 2 where inventory_id = 123 and film_id = 240 and store_id = 1;
insert into inventory (inventory_id, film_id, store_id) values
(123, 240, 2);
update inventory set store_id = 1 where inventory_id = 123 and film_id = 240 and store_id = 2;
delete from inventory where inventory_id = 123 and film_id = 240;