create or replace function fillDepartmentsHistory() returns trigger as $$
begin
	if tg_op  in ('UPDATE', 'INSERT')
		then
			if tg_op = 'UPDATE' AND new.id <> old.id
				then raise exception 'Bad update!';
			end if;
			insert into departments_history ("action", id, "name", city_id, city_name, address, boss_id, boss_name)
					values (
						tg_op,
						new.id,
						new."name",
						new.city_id,
						(select "name" as city_name from public.cities where id = new.city_id),
						new.address,
						new.boss_id,
						(select concat(lastname, ' ', firstname) as boss_name from public.employees where id = new.boss_id)
					);
			return new;
	elseif tg_op = 'DELETE'
		then
			insert into departments_history ("action", id, "name", city_id, city_name, address, boss_id, boss_name)
					values (
						tg_op,
						old.id,
						old."name",
						old.city_id,
						(select "name" as city_name from public.cities where id = old.city_id),
						old.address,
						old.boss_id,
						(select concat(lastname, ' ', firstname) as boss_name from public.employees where id = old.boss_id)
					);
			return old;
	end if;
end;
$$ language plpgsql

------------

create or replace trigger writeDepartmentHistory
before insert or update or delete
on public.departments
for each row execute function fillDepartmentsHistory()


-- check
select * from departments_history;

-- tests
INSERT INTO public.departments(id, "name", city_id, address, boss_id)
values (1, 'The first department', 1, 'Independece square 1', 1)
on conflict (id) do update
	set "name" = EXCLUDED."name", city_id = EXCLUDED.city_id,
	address = EXCLUDED.address, boss_id = EXCLUDED.boss_id
	where departments.id = EXCLUDED.id;
-- в видео на on conflict было указание имени ключа и new.* - у меня так не срабатывает

INSERT INTO public.departments(id, "name", city_id, address, boss_id)
values (4, 'Developers', 1, 'Independece square 2', 1);

UPDATE public.departments
SET city_id = 2, address = 'Red square 1'
WHERE id=4;

delete from public.departments
WHERE id=4;