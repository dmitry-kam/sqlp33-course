-- 1 задание

create or replace function getVacanciesQty(roleName text, dateStart date, dateEnd date, out qty numeric) as $$
begin
	if length(roleName) = 0
		then raise exception 'Role is empty';
	end if;
	if (dateStart is null or dateEnd is null)
		then raise exception 'dateStart/dateEnd is empty';
	end if;
	if (dateStart > dateEnd)
		then raise exception 'Incorrect date range';
	end if;
	-- "опубликованных", как процесс появления
	select count(vac_id) from hr.vacancy where vac_title = roleName and create_date between dateStart::date and dateEnd::date into qty;
	-- "опубликованных", как факт опубликованности на какой-то площадке в указанный период (открыты и закрыты в течение периода)
	--select count(vac_id) from hr.vacancy where
	--	vac_title = roleName
	--	and create_date >= dateStart::date and closure_date <= dateEnd::date into qty;
end;
$$ language plpgsql

select getVacanciesQty('специалист', '2016-01-20', '2019-01-27');
select getVacanciesQty('разработчик', '2016-01-20', '2020-01-27');
select getVacanciesQty('старший разработчик', '2018-01-20', '2020-01-27');

-- 2 задание

create or replace function checkGrade() returns trigger as $$
begin
	if new.grade not in (select grade from hr.grade_salary)
		then raise exception 'Incorrect grade';
	end if;
	return new;
end;
$$ language plpgsql

create or replace trigger gradeCheckOnPositionInsert
before insert on hr."position"
for each row execute function checkGrade()

-- good
INSERT INTO hr."position"
(pos_id, pos_title, pos_category, unit_id, grade, address_id, manager_pos_id)
values((select max(pos_id) + 1 from hr."position"), 'test jobtitle', 'Административный', 212, NULL, 4, 10);

-- error
INSERT INTO hr."position"
(pos_id, pos_title, pos_category, unit_id, grade, address_id, manager_pos_id)
values((select max(pos_id) + 1 from hr."position"), 'test1 jobtitle', 'Административный', 212, 1, 4, 10);

-- good
INSERT INTO hr."position"
(pos_id, pos_title, pos_category, unit_id, grade, address_id, manager_pos_id)
values((select max(pos_id) + 1 from hr."position"), 'test2 jobtitle', 'Административный', 212, 2, 4, 10);

-- error
INSERT INTO hr."position"
(pos_id, pos_title, pos_category, unit_id, grade, address_id, manager_pos_id)
values
((select max(pos_id) + 1 from hr."position"), 'test3 jobtitle', 'Административный', 212, 2, 4, 10),
((select max(pos_id) + 1 from hr."position"), 'test4 jobtitle', 'Административный', 212, 1, 8, 10);

-- 3 задание

create table employee_salary_history (
	emp_id int,
	salary_old int,
	salary_new int,
	difference int,
	last_update timestamp NOT NULL DEFAULT NOW());

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA hr TO postgres;

create or replace function fillEmployeeSalaryHistory() returns trigger as $$
declare lastEmployeeSalary int;
begin
	if tg_op = 'INSERT'
		then
			SELECT salary FROM hr.employee_salary into lastEmployeeSalary
				WHERE emp_id = new.emp_id order by effective_from desc LIMIT 1 OFFSET 1;
				-- возможно стоит сортировать по order_id

			insert into employee_salary_history (emp_id, salary_old, salary_new, difference)
					values (
						new.emp_id,
						COALESCE(lastEmployeeSalary::int, 0),
						new.salary,
						abs(new.salary - COALESCE(lastEmployeeSalary::int, 0))
					);
	elseif tg_op = 'UPDATE'
		then
			if new.emp_id <> old.emp_id
				then raise exception 'Bad update!';
			end if;
			insert into employee_salary_history (emp_id, salary_old, salary_new, difference)
					values (new.emp_id, old.salary, new.salary, abs(new.salary - old.salary));
	end if;
	return new;
end;
$$ language plpgsql

create or replace trigger gradeCheckOnPositionInsert
after insert or update on hr.employee_salary
for each row execute function fillEmployeeSalaryHistory()


-- check
select * from employee_salary_history;
-- tests
INSERT INTO hr.employee_salary
(order_id, emp_id, salary, effective_from)
VALUES(125002, 2, 14130.00, '2023-10-30');
INSERT INTO hr.employee_salary
(order_id, emp_id, salary, effective_from)
VALUES(125003, 2, 15000.00, '2023-10-31');

-- no users without salary
select e.emp_id as emp_id, es.emp_id as existMark from hr.employee e left join hr.employee_salary es
on es.emp_id = e.emp_id
where es.emp_id is null;

INSERT INTO hr.employee
(emp_id, emp_type_id, person_id, pos_id, rate, hire_date)
VALUES((select max(emp_id) + 1 from hr.employee), 1, 4590, 4590, 1.00, '2023-10-30');

INSERT INTO hr.employee_salary
(order_id, emp_id, salary, effective_from)
VALUES(125004, 2736, 300000.00, '2023-10-31');

UPDATE hr.employee_salary
SET salary=30000.00
WHERE order_id=125004;

-- 4 задание

CREATE or replace PROCEDURE createEmployeeSalaryRecord(orderId int4, empId int4, salary numeric, effectiveFrom timestamp)
	AS $$
	BEGIN
		INSERT INTO hr.employee_salary(order_id, emp_id, salary, effective_from) VALUES (orderId, empId, salary, effectiveFrom);
		COMMIT;
	END;
$$ LANGUAGE plpgsql;


call createEmployeeSalaryRecord(10003, 2736, 60000, '2023-10-31');