create or replace function fillEmployeesHistory() returns trigger as $$
begin
	if tg_op = 'UPDATE' and new.id <> old.id
				then raise exception 'Bad update!';
			end if;

	insert into employees_scd4 (emp_id, lastname, firstname, email, immediate_boss_id)
	values (
		old.id,
		old.lastname,
		old.email,
		old.firstname,
		old.immediate_boss_id
	);

    -- можно сделать триггер after и вернуть null
	if tg_op = 'UPDATE'
		then
			return new;
	elseif tg_op = 'DELETE'
		then
			return old;
	end if;
end;
$$ language plpgsql

------------

create or replace trigger writeEmployeeHistory
before update or delete
on public.employees
for each row execute function fillEmployeesHistory()


-- check
select * from employees_scd4;

-- tests
INSERT INTO public.employees (id, lastname, firstname, email, immediate_boss_id)
values (2, 'TestLastname', 'TestFirstname', 'test@test.com', 1)
on conflict (id) do update
	set lastname = EXCLUDED.lastname, firstname = EXCLUDED.firstname,
	email = EXCLUDED.email, immediate_boss_id = EXCLUDED.immediate_boss_id
	where employees.id = EXCLUDED.id;
-- в видео на on conflict было указание имени ключа и new.* - у меня так не срабатывает

INSERT INTO public.employees (id, lastname, firstname, email, immediate_boss_id)
values (3, 'TestLastname2', 'TestFirstname2', 'test2@test.com', 1);

UPDATE public.employees
SET immediate_boss_id = 2, email = 'test3@test.com'
WHERE id=3;

delete from public.employees
WHERE id=3;