--------------------Salary 4 SCD----------------------
create or replace function fillEmployeesSalaryHistory() returns trigger as $$
begin
	insert into employee_salary_history (emp_id, salary)
	values (
		old.emp_id,
		old.salary
	);
	return null;
end;
$$ language plpgsql

------------

create or replace trigger writeEmployeeSalaryHistory
after update or delete
on public.employee_salary
for each row execute function fillEmployeesSalaryHistory()


-- check
select * from employee_salary_history;

-- tests

INSERT INTO public.employees (id, lastname, firstname, email, birthdate, phone, education)
values (1, 'TestLastname', 'TestFirstname', 'test@test.com', '01-01-1990', 1234567890, 'Институт Сеченова, фармакология, выпуск 2007 г.');

INSERT INTO public.employee_salary (emp_id, salary)
values (1, 60000);

UPDATE public.employee_salary
SET salary = 62000
WHERE emp_id=1;

delete from public.employee_salary
WHERE emp_id=1;

--------------------Suppliers 4 SCD----------------------

create or replace function fillSuppliersHistory() returns trigger as $$
begin
	insert into suppliers_history (sup_id, "name", phone, email, rating)
	values (
		old.id,
		old."name",
		old.phone,
		old.email,		
		old.rating
	);
	return null;
end;
$$ language plpgsql

------------

create or replace trigger writeSuppliersHistory
after update or delete
on public.suppliers
for each row execute function fillSuppliersHistory()


-- check
select * from suppliers_history;
select * from suppliers;

-- tests

INSERT INTO public.suppliers ("name", phone, email, rating)
values ('Test LLC', 1234567890, 'test@test.com', 10.0);


UPDATE public.suppliers
SET rating = 9.5, phone = 9998887766
WHERE id=1;

delete from public.suppliers
WHERE id=1;
